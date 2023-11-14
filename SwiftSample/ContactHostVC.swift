/**
* ContactHostVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class ContactHostVC : UIViewController,UITableViewDelegate, UITableViewDataSource,WWCalendarTimeSelectorProtocol, AddGuestDelegate,AddMessageDelegate,ViewOfflineDelegate
{
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblContactHost: UITableView!
    @IBOutlet var tblHeader: UIView!
    @IBOutlet var lblRoomType: UITextView?
    @IBOutlet var imgHostThumb: UIImageView?
    @IBOutlet var btnSend: UIButton!

    var strHostThumbUrl = ""
    var strRoomType = ""
    var btntype = ""
    var strHostUserName = ""
    var strAdult = ""
    var strMessage = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var strHostUserId:String = ""
    var strCheckInDate = ""
    var strCheckOutDate = ""
    var strRoomId = ""
    var strTotalGuest = ""
    var words = ""
    var datecheck = ""
    var sendenable = ""
    var currentGuest: Int = 0
    var modelRoomDetails : RoomDetailModel!
    var booking = ""
    var blockedDates:[String]?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    fileprivate var singleDate: Date = Date()
    //fileprivate var multipleDates: [Date] = []

    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet weak var msghst_Title: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       back_Btn.transform = Language.getCurrentLanguage().getAffine
        btnSend.addTarget(self, action: #selector(self.onSaveTapped), for: UIControl.Event.touchUpInside)
        self.btnSend.appHostBGColor()
        self.msghst_Title.text = self.lang.msghst_Tit
        self.msghst_Title.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        btnSend.isUserInteractionEnabled = false
        self.btnSend.setTitle(self.lang.send_Title, for: .normal)
        self.navigationController?.isNavigationBarHidden = true
        imgHostThumb?.layer.cornerRadius = (imgHostThumb?.frame.size.width)!/2
        imgHostThumb?.clipsToBounds = true
//        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        tblContactHost.tableHeaderView = tblHeader
        imgHostThumb?.addRemoteImage(imageURL: strHostThumbUrl, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: strHostThumbUrl) as! URL, placeholderImage:UIImage(named:""))

        lblRoomType?.text = String(format:"%@ \(lang.hostby_Title) %@",strRoomType,strHostUserName)
       
        if appDelegate.multipleDates == []{
            appDelegate.startdate = ""
            appDelegate.enddate = ""
        }
        btnSend?.alpha = 0.7
        checkSaveButtonStatus()
        
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.onSaveTapped(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        appDelegate.makentTabBarCtrler.tabBar.isHidden = false
    }
    
    @IBAction func onHostProfileTapped()
    {
        let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        viewProfile.strOtherUserId = strHostUserId
        viewProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewProfile, animated: true)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (indexPath.row == 0) ? 70 : (indexPath.row == 1) ? 85 : 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellContactHost = tblContactHost.dequeueReusableCell(withIdentifier: "CellContactHost")! as! CellContactHost
        cell.lblTitle.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblSubTitle?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblDescription?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblDescription?.appGuestTextColor()
        
        if (appDelegate.startdate != "" || appDelegate.enddate != "") {
            
            var startdate  = appDelegate.startdate.components(separatedBy: "-")
            let date = startdate[1]
            let month = startdate[2]
            var enddate  = appDelegate.enddate.components(separatedBy: "-")
            let date1 = enddate[1]
            let month1 = enddate[2]
            cell.lblTitle?.text = (indexPath.row == 0) ? "\(month) \(date)-\(date1)" : (indexPath.row == 1) ? self.lang.guest_Title : self.lang.yourmsg_Title
            datecheck = "\(month) \(date)-\(date1)"
            
        }
        else{
            
           sendenable = "1"
           cell.lblTitle?.text = (indexPath.row == 0) ? self.lang.dat_Title : (indexPath.row == 1) ? self.lang.guest_Title : self.lang.yourmsg_Title
           datecheck = "Date"
        }
        if appDelegate.searchguest == "" {
            appDelegate.searchguest = "1"
        }
        cell.lblSubTitle?.text = (indexPath.row == 0) ? "" : (indexPath.row == 1) ? (strAdult.count > 0 ? strAdult : "\(appDelegate.searchguest) \(lang.guess_Tit)") : strMessage.count > 0 ? strMessage : lang.hostapp_Msg
    
       cell.lblDescription?.text = (indexPath.row == 0) ? appDelegate.multipleDates.count > 0 ? lang.change_Title : lang.addStr : (indexPath.row == 1) ? (strAdult.count > 0 ? lang.change_Title : lang.change_Title)  : strMessage.count > 0 ? lang.change_Title : lang.addStr

        var rectViewRule = cell.viewHolder?.frame
        rectViewRule?.origin.y = (indexPath.row == 0) ? 20 : 12
        cell.viewHolder?.frame = rectViewRule!

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let selector = k_MakentStoryboard.instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector
            selector.delegate = self
            selector.isFromExplorePage = true
            selector.callAPI = true
            selector.fromContact = true
            selector.room_Id = strRoomId
            selector.optionCurrentDate = singleDate
            selector.optionCurrentDates = Set(appDelegate.multipleDates)
  
//            if modelRoomDetails.blocked_dates != nil
//            {
//                if modelRoomDetails.blocked_dates.count > 0
//                {
//                    selector.arrBlockedDates = modelRoomDetails.blocked_dates as! NSMutableArray
//                }
//            }
            if blockedDates != nil
            {
                if blockedDates!.count > 0
                {
                    blockedDates?.forEach({ (value) in
                        selector.arrBlockedDates.append(value)
                    })
                    //selector.arrBlockedDates = blockedDates as! NSMutableArray
                }
            }

            if let firstDate = appDelegate.multipleDates.first,
                let lastDate = appDelegate.multipleDates.last{
                selector.optionCurrentDateRange.setStartDate(firstDate)
                selector.optionCurrentDateRange.setEndDate(lastDate)
                selector.showPlaceHolder(false)
            }else{
                selector.optionCurrentDateRange.setStartDate( singleDate)
                selector.optionCurrentDateRange.setEndDate( singleDate)
                selector.showPlaceHolder(true)
            }
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.range
            self.navigationController?.pushViewController(selector, animated: false)
        }
        else if indexPath.row == 1
        {
            let guestView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddGuestVC") as! AddGuestVC
            guestView.delegate = self
            guestView.nMaxGuestCount = Int(strTotalGuest)!
            guestView.nCurrentGuest = Int(appDelegate.searchguest)!
             if words == "1"{
                 guestView.nCurrentGuest = (strAdult.count > 0) ? Int(strAdult.replacingOccurrences(of: " Guests", with: "") as String)! : 1
            }
            present(guestView, animated: true, completion: nil)
        }
        else
        {
            let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "AddMessageVC") as! AddMessageVC
            viewHouseRule.hidesBottomBarWhenPushed = true
            viewHouseRule.urlHostImg = strHostThumbUrl
            viewHouseRule.strHostUserId = strHostUserId
            viewHouseRule.strMessage = strMessage
            viewHouseRule.delegate = self
            present(viewHouseRule, animated: true, completion: nil)

        }
    }
    
    // MARK: Guest CELL DELEGATE METHODS
    internal func onGuestAdded(index: Int)
    {
        strAdult = String(format: "%d Guests", index)
        currentGuest = (strAdult.count > 0) ? Int(strAdult.replacingOccurrences(of: " Guests", with: "") as String)! : 1
        appDelegate.searchguest = "\(currentGuest)"
        words = "1"
        tblContactHost.reloadData()
        checkSaveButtonStatus()
    }

    // MARK: Add Message Delegate Methods
    internal func onMessageAdded(messsage:String)
    {
        strMessage = messsage
        tblContactHost.reloadData()
        checkSaveButtonStatus()
    }

    // MARK: ****** WWCalendar Delegate Methods ******
    internal func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    {
        //print(dates)
        appDelegate.day1 = "1"
        appDelegate.multipleDates = dates
        let formalDates = dates
        
        let startDay = formalDates[0]
        //  let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
        let lastDay = formalDates.last
        //  let last = Calendar.current.date(byAdding: .day, value: 1, to: lastDay!)
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        
        strCheckInDate = dateFormatter.string(from: startDay)
        
        if formalDates.count==1
        {
            let startDay = formalDates[0]
            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
            strCheckOutDate = dateFormatter.string(from: (start)!)
            
        }
        else
        {
            strCheckOutDate = dateFormatter.string(from: lastDay!)
        }
        
        checkSaveButtonStatus()
        
        tblContactHost.reloadData()
    }
    
    func checkSaveButtonStatus()
    {
         // if multipleDates.count > 0 && strAdult.replacingOccurrences(of: " Guests", with: "").count > 0
        //if multipleDates.count > 0 && strMessage.count > 0

        if appDelegate.multipleDates.count > 0
        //if sendenable != "1"
        {
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 1.0
        }
        else
        {
            //self.appDelegate.createToastMessage("", isSuccess: )
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 0.7
        }
    }
    
    // MARK: ***** ROOM DETAIL API CALL *****
    /*
     Here Getting Room Details
     */
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"] = strRoomId
        
        if self.sendenable != "1"{
            self.convertdate()
            dicts["check_in_date"] = strCheckInDate
            dicts["check_out_date"] = strCheckOutDate
        }
        else{
            
            dicts["check_in_date"] = strCheckInDate
            dicts["check_out_date"] = strCheckOutDate
        }
        dicts["no_of_guest"] = appDelegate.searchguest
        dicts["message_to_host"] = strMessage
        let message = dicts["message_to_host"] as! String
        dicts["list_type"]   = "Rooms"
        appDelegate.s_date = strCheckInDate
        appDelegate.e_date = strCheckOutDate
        
        
        if message != "" {
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
            MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_CONTACT_HOST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: true)
                    self.onBackTapped(nil)
                    self.appDelegate.day = "1"
                    self.appDelegate.gothis = "1"
                    self.appDelegate.day1 = "1"

                }
                else
                {
                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                MakentSupport().removeProgressInWindow(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
        }else if strCheckInDate == "" || strCheckOutDate == ""{
            appDelegate.createToastMessage(lang.date_Req, isSuccess: true)
            btnSend.isUserInteractionEnabled = true
        }else{
            btnSend.isUserInteractionEnabled = true
        }
    }
    
    func convertdate(){
        
        let dates = appDelegate.multipleDates
        if dates.count > 0{
        let formalDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        strCheckInDate = dateFormatter.string(from: startDay)
        if formalDates.count==1
        {
            let startDay = formalDates[0]
            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
            strCheckOutDate = dateFormatter.string(from: (start)!)
            
        }
        else
        {
            strCheckOutDate = dateFormatter.string(from: lastDay!)
        }
        }
        
    }
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
//        if appDelegate.lastPageMaintain == "contact" {
//            let roomDetailView = self.storyboard?.instantiateViewController(withIdentifier: "RoomDetailPage") as! RoomDetailPage
//            roomDetailView.strRoomId = self.appDelegate.strRoomID
//            self.navigationController?.pushViewController(roomDetailView, animated: true)
//        }
//        else{
//
//        }
        
        if appDelegate.back1 == "book" {
            self.convertdate()
            appDelegate.s_date = strCheckInDate
            appDelegate.e_date = strCheckOutDate
        }
        appDelegate.s_date = strCheckInDate
        appDelegate.e_date = strCheckOutDate
        appDelegate.day = "1"
        self.navigationController!.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped()
    {
        
    }
}

class CellContactHost: UITableViewCell
{
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel?
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var viewHolder: UIView?
}
