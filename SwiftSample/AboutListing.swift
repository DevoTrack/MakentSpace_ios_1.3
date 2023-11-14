/**
* AboutListing.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social


class AboutListing : UIViewController,UITableViewDelegate, UITableViewDataSource,EditTitleDelegate {
    @IBOutlet var tblAboutListing : UITableView!
    
    @IBOutlet weak var back_Btn: UIButton!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var arrDetails = ["The Space","Guest Access","Interaction with Guests"]
    var arrNeighbour = ["Overview","Getting Around"]
    var arrExtra = ["Other Things to Note","House Rules"]
    
    var arrValues = [String]()
    var arrPlaceHoders = [String]()

    var arrSelectedItems : NSMutableArray = NSMutableArray()
    
    var strSpace = "" , strGuestAccess = "" , strInteraction = "" , strOverView = "" , strGetting = "" , strOtherThing = "" , strHouseRules = "", strRoomId:String = ""
    var abtDescModel : AboutListingModel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var nSelectedRow : Int = 0
    
    @IBOutlet var animatedLoader: FLAnimatedImageView?

    @IBOutlet weak var titlbl: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.back_Btn.transform = self.getAffine
        back_Btn.appHostTextColor()
        arrDetails = [lang.tspc_Title,lang.gustAcc_Title,lang.interac_Guest]
        arrNeighbour = [lang.overv_Title,lang.getarnd_Title]
        self.titlbl.text = self.lang.det_Title
        arrExtra = [lang.othtin_Title,lang.housrul_Title]
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        getAboutListing()
    }
    
    func getAboutListing()
    {
        var dicts = [AnyHashable: Any]()
        
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = strRoomId

        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_GET_ROOM_DESC as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let abtModel = response as! AboutListingModel
            OperationQueue.main.addOperation {
                if abtModel.status_code == "1"
                {
                    self.abtDescModel = abtModel
                    self.setDescription()
                }
                else
                {
                    self.appDelegate.createToastMessage(abtModel.success_message as String, isSuccess: false)
                    if abtModel.success_message == "token_invalid" || abtModel.success_message == "user_not_found" || abtModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                    
                }
                
                self.animatedLoader?.isHidden = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    
    
    func setDescription()
    {
        strSpace        = (abtDescModel.space_msg != "") ? abtDescModel.space_msg as String : self.lang.addinf_Space
        strGuestAccess  = (abtDescModel.guest_access_msg != "") ? abtDescModel.guest_access_msg as String : self.lang.trav_Access
        strInteraction  = (abtDescModel.interaction_with_guest_msg != "") ? abtDescModel.interaction_with_guest_msg as String : self.lang.availgues_Stay
        strOverView     = (abtDescModel.overview_msg != "") ? abtDescModel.overview_msg as String : self.lang.shwpeop_Uniq
        strGetting      = (abtDescModel.getting_arround_msg != "") ? abtDescModel.getting_arround_msg as String : self.lang.pub_Trans
        strOtherThing   = (abtDescModel.other_things_to_note_msg != "") ? abtDescModel.other_things_to_note_msg as String : self.lang.trav_Othr
        strHouseRules   = (abtDescModel.house_rules_msg != "") ? abtDescModel.house_rules_msg as String : self.lang.beh_Expt
        
        
        arrPlaceHoders = [self.lang.addinf_Space,self.lang.trav_Access,self.lang.availgues_Stay,self.lang.shwpeop_Uniq,self.lang.pub_Trans,self.lang.trav_Othr,self.lang.beh_Expt]


        
        arrValues = [abtDescModel.space_msg as String,abtDescModel.guest_access_msg as String,abtDescModel.interaction_with_guest_msg as String,abtDescModel.overview_msg as String,abtDescModel.getting_arround_msg as String,abtDescModel.other_things_to_note_msg as String,abtDescModel.house_rules_msg as String]
        tblAboutListing.reloadData()
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
    
    //
    //MARK: Room Detail Table view Handling
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return abtDescModel == nil ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblAboutListing.frame.size.width) ,height: 40)
        
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:30, width: viewHolder.frame.size.width ,height: 40)
        if section == 0
        {
            lblRoomName.text=self.lang.det_Title
        }
        else if section == 1
        {
            lblRoomName.text=self.lang.tneigh_Title
        }
        else
        {
            lblRoomName.text=self.lang.exdet_Title
        }
        lblRoomName.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 15)
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row>=arrExtra.count && indexPath.section==2{
            return 50
        }
        
        if indexPath.row==1 && indexPath.section==1{
            return 100
        }
        if indexPath.row==1 && indexPath.section==2{
            return 70
        }
        return 87
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return arrDetails.count
        }
        else if section == 1
        {
            return arrNeighbour.count
        }
        else
        {
            return arrExtra.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellAboutListing = tblAboutListing.dequeueReusableCell(withIdentifier: "CellAboutListing")! as! CellAboutListing
        cell.contentView.backgroundColor = UIColor.white
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.backgroundColor = UIColor.white
        cell.textLabel?.backgroundColor = UIColor.white

        cell.lblSeparator?.backgroundColor = UIColor(red: 223.0 / 255.0, green: 224.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0)

        if indexPath.section==0
        {
            cell.lblTitle?.text = arrDetails[indexPath.row]
            cell.lblSubTitle?.text = (indexPath.row == 0) ? strSpace : (indexPath.row == 1) ? strGuestAccess : strInteraction
        }
        else if indexPath.section==1
        {
            cell.lblTitle?.text = arrNeighbour[indexPath.row]
            cell.lblSubTitle?.text = (indexPath.row == 0) ? strOverView : strGetting
//            if indexPath.row==1
//            {
//                let height = MakentSupport().onGetStringHeight((cell.lblSubTitle?.frame.size.width)!, strContent: strGetting as NSString, font: (cell.lblSubTitle?.font)!)
//                
//                var rectEmailView = cell.lblSubTitle?.frame
//                rectEmailView?.origin.y = (cell.lblTitle?.frame.size.height)! + 3
//                rectEmailView?.size.height = height+5
//                cell.lblSubTitle?.frame = rectEmailView!
//
//            }
        }
        else
        {
            // Here we adding extra cell
            if indexPath.row>=arrExtra.count{
                cell.backgroundColor = UIColor.clear
                cell.textLabel?.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblSeparator?.backgroundColor = UIColor.clear
                cell.lblTitle?.text = ""
                cell.lblSubTitle?.text = ""
                cell.accessoryType = UITableViewCell.AccessoryType.none
                return cell
            }
            
            cell.lblTitle?.text = arrExtra[indexPath.row]
            cell.lblSubTitle?.text = (indexPath.row == 0) ? strOtherThing : strHouseRules

        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row>=arrExtra.count && indexPath.section==2{
            return
        }
        
        if indexPath.section==0
        {
            nSelectedRow = indexPath.row
        }
        else if indexPath.section==1
        {
            nSelectedRow = indexPath.row + 3
        }
        else
        {
            nSelectedRow = indexPath.row + 5
        }
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! CellAboutListing
        
        let editView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditTitleVC") as! EditTitleVC
        editView.delegate = self
        editView.strRoomId = strRoomId
        editView.strAboutMe = arrValues[nSelectedRow]
        editView.strPlaceHolder = arrPlaceHoders[nSelectedRow]
        editView.strTitle = (selectedCell.lblTitle?.text)!
        editView.isFromRoomDesc = true
        self.navigationController?.pushViewController(editView, animated: true)
    }
    
    //MARK: EDIT TITLE CHANGED DELEGATE METHOD
    internal func EditTitleTapped(strDescription: NSString)
    {
        var abtModel = AboutListingModel()
        abtModel = abtDescModel
        if nSelectedRow == 0
        {
            abtModel.space_msg = strDescription
        }
        else if nSelectedRow == 1
        {
            abtModel.guest_access_msg = strDescription
        }
        else if nSelectedRow == 2
        {
            abtModel.interaction_with_guest_msg = strDescription
        }
        else if nSelectedRow == 3
        {
            abtModel.overview_msg = strDescription
        }
        else if nSelectedRow == 4
        {
            abtModel.getting_arround_msg = strDescription
        }
        else if nSelectedRow == 5
        {
            abtModel.other_things_to_note_msg = strDescription
        }
        else if nSelectedRow == 6
        {
            abtModel.house_rules_msg = strDescription
        }
        abtModel = abtDescModel
        setDescription()
    }

    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}

class CellAboutListing: UITableViewCell
{
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblSubTitle: UILabel?
    @IBOutlet var lblSeparator: UILabel?

}

