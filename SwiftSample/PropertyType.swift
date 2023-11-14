/**
* PropertyType.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class PropertyType : UIViewController,UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblPropertyType: UITableView!
    @IBOutlet var viewHeader: UIView!

    var bedTypes : [BedType]?
    var strRoomType = ""
    
    @IBOutlet weak var bck_Btn: UIButton!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let arrIconName = ["apartment.png","entirehome.png","bedcoffee.png"]
    
    var arrPropertyData : NSArray!
    var arrBedData : NSArray!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var isMoreTapped : Bool = false
    
//    @IBOutlet weak var proptyp_Msg: UILabel!

//    @IBOutlet weak var proptyp_Title: UILabel!
    @IBOutlet weak var proptyp_Title: UILabel!
    
    @IBOutlet weak var proptyp_Msg: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.bck_Btn.transform = self.getAffine
        bck_Btn.appHostTextColor()
        self.proptyp_Title.text = self.lang.proptyp_Tit
        self.proptyp_Msg.text = self.lang.proptyp_Msg
        
        var rectHeaderView = viewHeader.frame
        rectHeaderView.size.height = self.view.frame.height/2
        viewHeader.frame = rectHeaderView
        tblPropertyType.tableHeaderView = viewHeader
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: Room Detail Table view Handling
    /*
     Room Detail List View Table Datasource & Delegates
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (arrPropertyData == nil)
        {
            return 0
        }
        
        return (isMoreTapped) ? arrPropertyData.count : ((arrPropertyData.count > 3) ? 4 : arrPropertyData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(!isMoreTapped && indexPath.row==3)
        {
            let cell:CellMoreType = tblPropertyType.dequeueReusableCell(withIdentifier: "CellMoreType") as! CellMoreType
            cell.lbl_More.text = self.lang.mr_Tit
            cell.lbl_More.appHostTextColor()
            cell.dropDownImageView.dropDownImage(.appHostTitleColor)
//            cell.btnMore?.addTarget(self, action: #selector(self.onMoreTypeTapped), for: UIControlEvents.touchUpInside)
            return cell
        }
        else
        {
            let cell:CellPropertyType = tblPropertyType.dequeueReusableCell(withIdentifier: "CellPropertyType")! as! CellPropertyType
            
            let proModel = arrPropertyData[indexPath.row] as? RoomPropertyModel
            
            cell.lblHomeType?.text = proModel?.property_name as String?
            var rectEmailView = cell.lblHomeType?.frame
            rectEmailView?.origin.x = (indexPath.row<3) ? 60 : 15
            cell.lblHomeType?.frame = rectEmailView!

//            if (indexPath.row<3)
//            {
//                cell.imgIcon?.isHidden = false
//                cell.imgIcon?.image =  UIImage(named: arrIconName[indexPath.row])
            cell.imgIcon?.addRemoteImage(imageURL: proModel?.property_Image as! String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: (proModel?.property_Image as String? ?? "")!)! as URL, placeholderImage:UIImage(named:""))
//            }
//            else
//            {
//                cell.imgIcon?.isHidden = true
//            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(!isMoreTapped && indexPath.row==3)
        {
            self.onMoreTypeTapped(UIButton())
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        locView.hidesBottomBarWhenPushed = true
        locView.strRoomType = strRoomType
        if arrBedData != nil
        {
            locView.arrBedData = arrBedData
        }
        locView.bedTypes = self.bedTypes

        let proModel = arrPropertyData[indexPath.row] as? RoomPropertyModel
        locView.strPropertyType = (proModel?.property_id as String?)!
        locView.strPropertyName = (proModel?.property_name as String?)!
        self.navigationController?.pushViewController(locView, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMoreTypeTapped(_ sender:UIButton!)
    {
        isMoreTapped = true
        tblPropertyType.reloadData()
        tblPropertyType.setContentOffset(CGPoint(x: 0, y:220), animated:true)
//        tblPropertyType.setContentOffset:CGPointMake(0, origin.y)];
//        let indexPath = IndexPath(row: 0, section: 0)
//        tblPropertyType.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    func onAddListTapped(){
        
    }
}

class CellPropertyType: UITableViewCell
{
    @IBOutlet var lblHomeType: UILabel?
    @IBOutlet var imgIcon: UIImageView?
}

class CellMoreType : UITableViewCell
{
  
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var lbl_More: UILabel!
}
