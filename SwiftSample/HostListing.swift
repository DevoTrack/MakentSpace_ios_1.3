/**
* HostListing.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class HostListing : UIViewController,UITableViewDelegate,UITableViewDataSource, ViewOfflineDelegate {
    
    
    @IBOutlet weak var newListingTopBtn: UIButton!
    @IBOutlet var tblListSpace: UITableView!
    @IBOutlet var viewHeader: UIView!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var nPageNumber : Int = 1
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrListing : NSMutableArray = NSMutableArray()
    var isDataFinishedFromServer : Bool = false
    var isApiCalling : Bool = false
    var arrListedRooms : NSMutableArray = NSMutableArray()
    var arrUnListedRooms : NSMutableArray = NSMutableArray()
    var nSectionCount : Int = 0
    
    @IBOutlet weak var list_Title: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        newListingTopBtn.appHostTextColor()
        print("Hostlisting Viewcontroller")
        isApiCalling = true
        self.getRoomList(pageNumber: nPageNumber, isDelete: false)
        self.list_Title.text = self.lang.host_List
        NotificationCenter.default.addObserver(self, selector: #selector(self.getNewListing), name: NSNotification.Name(rawValue: "NewRoomAdded"), object: nil)
//        tblListSpace.refreshControl?.backgroundColor = .black
        tblListSpace.addPullRefresh { [weak self] in
           
            self?.getNewListing(isFromRefresh: true)
           
            
        }
        
        self.newListingTopBtn.addTarget(self, action: #selector(onAddListTapped), for: .touchUpInside)
        let rect = UIScreen.main.bounds as CGRect
        var rectTblView = tblListSpace.frame
        rectTblView.size.height = rect.size.height-100
        tblListSpace.frame = rectTblView
        self.view.layoutIfNeeded()
    }
    
    @objc func getNewListing(isFromRefresh:Bool = false)
    {
        self.tblListSpace.stopPullRefreshEver()
        nPageNumber = 1
        nSectionCount = 0
        isApiCalling = true
        if arrListedRooms.count == 0{
            isApiCalling = true
            self.tblListSpace.stopPullRefreshEver()
        }
        if arrListedRooms.count > 0
        {
            arrListedRooms.removeAllObjects()


        }
        if self.arrUnListedRooms.count > 0 {
            arrUnListedRooms.removeAllObjects()
        }
        
        self.tblListSpace.reloadData()
        self.getRoomList(pageNumber: nPageNumber, isDelete: true)
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        getNewListing()
    }
    
    func getRoomList(pageNumber: Int, isDelete: Bool)
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        self.setTableProperties()
        if pageNumber == 1 || isApiCalling
        {
            isDataFinishedFromServer = false
            tblListSpace.reloadData()
        }
        
        var dicts = [AnyHashable: Any]()
        
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["page"]    = String(format:"%d", pageNumber)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_GET_LISTING as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if isDelete && self.arrListedRooms.count > 0
                {
                    self.arrListedRooms.removeAllObjects()
                }
                
                if isDelete && self.arrUnListedRooms.count > 0
                {
                    self.arrUnListedRooms.removeAllObjects()
                }
                if gModel.status_code == "1"
                {
                    if gModel.arrTemp2.count>0
                    {
                        self.arrListedRooms.addObjects(from: (gModel.arrTemp2 as NSArray) as! [Any])
                    }
                    if gModel.arrTemp3.count>0
                    {
                        self.arrUnListedRooms.addObjects(from: (gModel.arrTemp3 as NSArray) as! [Any])
                    }
                    else
                    {
                        self.isDataFinishedFromServer = true
                    }
                    
                    
                    self.setTableProperties()
                }
                else
                {
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                    self.isDataFinishedFromServer = true
                }
                self.isApiCalling = false
                self.tblListSpace.stopPullRefreshEver()
                self.tblListSpace.reloadData()
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
//                self.isDataFinishedFromServer = true
                self.tblListSpace.stopPullRefreshEver()
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    func setTableProperties()
    {
        nSectionCount = 0
        if arrListedRooms.count > 0
        {
            nSectionCount += 1
        }
        
        if arrUnListedRooms.count > 0
        {
            nSectionCount += 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = false
        tblListSpace.reloadData()
    }
    
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: Room Detail Table view Handling
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if (arrUnListedRooms.count == 0 && arrListedRooms.count == 0)
        {
            return 1
        }
        return nSectionCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if (arrUnListedRooms.count == 0 && arrListedRooms.count == 0)
        {
            return nil
        }

        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblListSpace.frame.size.width) ,height: 40)
        
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 10, y:10, width: viewHolder.frame.size.width-10 ,height: 40)
        
        if section == 0
        {
            lblRoomName.text = (arrListedRooms.count > 0) ? self.lang.lis_Title : self.lang.unlis_Title
        }
        else if section == 1
        {
            lblRoomName.text = self.lang.unlis_Title
        }
        
        viewHolder.backgroundColor = UIColor.white
        lblRoomName.textAlignment = NSTextAlignment.left
        lblRoomName.textColor = UIColor.darkGray
        lblRoomName.font = UIFont (name: Fonts.CIRCULAR_LIGHT, size: 17)!
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (arrUnListedRooms.count == 0 && arrListedRooms.count == 0)
        {
            return 0
        }

        return 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (arrUnListedRooms.count == 0 && arrListedRooms.count == 0)
        {
            return 1
        }
        if section == 0
        {
            if (nSectionCount == 1 && arrListedRooms.count > 0)
            {
                return arrListedRooms.count+1
            }
            else if (arrListedRooms.count > 0)
            {
                return arrListedRooms.count
            }
            else
            {
                return arrUnListedRooms.count + 1
            }
            
        }
        else
        {
            return arrUnListedRooms.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            if (nSectionCount == 1 && arrListedRooms.count > 0)
            {
                if indexPath.row >= arrListedRooms.count
                {
                    return self.showAddRoomCell()
                }
                return showListedCell(index : indexPath.row)
            }
            else if (arrListedRooms.count > 0)
            {
                if indexPath.row >= arrListedRooms.count
                {
                    return self.showAddRoomCell()
                }
                return showListedCell(index : indexPath.row)
            }
            else
            {
                if indexPath.row >= arrUnListedRooms.count
                {
                    return self.showAddRoomCell()
                }

                return showUnListedCell(index : indexPath.row)
            }
        }
        else
        {
            if indexPath.row >= arrUnListedRooms.count
            {
                return self.showAddRoomCell()
            }
            
            return showUnListedCell(index : indexPath.row)
        }
    }
    
    func showListedCell(index : Int) -> CellListSpace
    {
        let cell:CellListSpace = tblListSpace.dequeueReusableCell(withIdentifier: "CellListSpace")! as! CellListSpace
        let listModel = arrListedRooms[index] as? ListingModel
        cell.setRoomDatas(modelListing: listModel!)
        return cell
    }
    
    func showUnListedCell(index : Int) -> CellListSpace
    {
        let cell:CellListSpace = tblListSpace.dequeueReusableCell(withIdentifier: "CellListSpace")! as! CellListSpace
        let listModel = arrUnListedRooms[index] as? ListingModel
        cell.setRoomDatas(modelListing: listModel!)
        return cell
    }
    
    func showAddRoomCell() -> CellAddList
    {
            let cell:CellAddList = tblListSpace.dequeueReusableCell(withIdentifier: "CellAddList")! as! CellAddList
        
            if isApiCalling
            {
                cell.list_AddLbl.text = ""
                cell.animatedLoader?.isHidden = false
                if !cell.animatedLoader!.isHidden  {
                    MakentSupport().setDotLoader(animatedLoader: cell.animatedLoader!)
                }
                
            }
            else
            {
                cell.animatedLoader?.isHidden = true
                cell.list_AddLbl.text = "+ \(self.lang.addnw_List)"
            }
        
            cell.btnAddList?.addTarget(self, action: #selector(self.onAddListTapped), for: UIControl.Event.touchUpInside)
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let locView = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomDetails") as! AddRoomDetails
        //let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddSpaceViewController") as! AddSpaceViewController
        locView.hidesBottomBarWhenPushed = false
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true

        self.navigationController?.pushViewController(locView, animated: true)
        //        if indexPath.section == 0
        //        {
        //            if (nSectionCount == 1 && arrListedRooms.count > 0)
        //            {
        //                locView.listModel = arrListedRooms[indexPath.row] as? ListingModel
        //                locView.strRemaingSteps = String(format:"%@",(locView.listModel.remaining_steps))
        //
        //            }
        //            else if (arrListedRooms.count > 0)
        //            {
        //                locView.listModel = arrListedRooms[indexPath.row] as? ListingModel
        //                locView.strRemaingSteps = String(format:"%@",(locView.listModel.remaining_steps))
        //            }
        //            else
        //            {
        //                locView.listModel = arrUnListedRooms[indexPath.row] as? ListingModel
        //                locView.strRemaingSteps = String(format:"%@",(locView.listModel.remaining_steps))
        //            }
        //
        //        }
        //        else
        //        {
        //            locView.listModel = arrUnListedRooms[indexPath.row] as? ListingModel
        //            locView.strRemaingSteps = String(format:"%@",(locView.listModel.remaining_steps))
        //        }
        //        let boolVal : Bool = (indexPath.section == 0) ? false : true
        //        UserDefaults.standard.set(boolVal, forKey: "isStepsCompleted")
        //        appDelegate.isStepsCompleted = (indexPath.section == 0) ? false : true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if self.tblListSpace.refreshControl?.isRefreshing ?? false {
            self.tblListSpace.stopPullRefreshEver()
        }
//        self.tblListSpace.stopPullRefreshEver()
    }
    
    func shallMoveToNextPage() -> Bool {
        let yOffset: CGFloat = tblListSpace.contentOffset.y
        let height: CGFloat = tblListSpace.contentSize.height - tblListSpace.frame.height
        return yOffset / height > 0.89
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func onAddListTapped(){
        let locView = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomDetails") as! AddRoomDetails
        //let Addnew = TypeSpaceViewController.InitWithStory(isToEdit: true)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(locView, animated: true)
    }
}

class CellListSpace: UITableViewCell
{
    @IBOutlet var lblName: UILabel?
    @IBOutlet var lblRemainingSteps: UILabel?
    @IBOutlet var imgRoomThumb: UIImageView?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func setRoomDatas(modelListing: ListingModel)
    {
        if (modelListing.room_title as String).count > 0
        {
            lblName?.text = modelListing.room_title.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        }
        else
        {
            lblName?.text = String(format:"%@ in %@",modelListing.room_name,((modelListing.city_name as String).count > 0) ? modelListing.city_name : modelListing.room_location)
        }
        
        if modelListing.remaining_steps == "0"
        {
            lblRemainingSteps?.text = modelListing.isListEnabled == "Yes" ? self.lang.lis_Title : self.lang.pend_Tit
            lblRemainingSteps?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
        else
        {
            lblRemainingSteps?.attributedText = MakentSupport().makeHostAttributeTextColor(originalText: String(format:"%@ \(self.lang.stplis_Title) - %@",modelListing.remaining_steps,modelListing.room_name) as NSString, normalText: String(format:" - %@",modelListing.room_name) as NSString, attributeText: String(format:"%@ \(self.lang.stplis_Title)",modelListing.remaining_steps) as NSString, font: (lblRemainingSteps?.font)!)
        }
        
        if (modelListing.room_thumb_images?.count)! > 0
        {
            imgRoomThumb?.addRemoteImage(imageURL: modelListing.room_thumb_images?[0] as! String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: modelListing.room_thumb_images?[0] as! String) as! URL, placeholderImage:UIImage(named:""))
        }
        else
        {
            imgRoomThumb?.image = UIImage(named:"room_default_no_photos.png")
        }
    }
}

class CellAddList: UITableViewCell
{
    @IBOutlet var btnAddList: UIButton?
    @IBOutlet var addNewRoom: UIImageView?
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    
    @IBOutlet weak var list_AddLbl: UILabel!
}


