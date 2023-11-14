/**
* InboxVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class InboxVC : UIViewController,UITableViewDelegate, UITableViewDataSource,ViewOfflineDelegate
{
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var tableInbox: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btnStartExploring: UIButton!
    @IBOutlet var lblUnreaderStatus: UILabel!
    @IBOutlet var lblSeparator: UILabel!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet weak var inbox_Title: UILabel!
    @IBOutlet weak var loginView: UIView!
    var arrInboxMsgs : NSMutableArray = NSMutableArray()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var token = ""

    @IBOutlet weak var inbx_Tit1: UILabel!
    @IBOutlet weak var inbx_Tit: UILabel!
    @IBOutlet weak var msghost_Msg: UILabel!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Inbox voew controller")
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        if token != ""{
            loginView.isHidden = true
            self.getInboxMessages()
            NotificationCenter.default.addObserver(self, selector: #selector(self.getInboxMessages), name: NSNotification.Name(rawValue: "roombooked"), object: nil)
        }
        else{
            loginView.isHidden = false
        }
        self.navigationController?.isNavigationBarHidden = true
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        tableInbox.addPullRefresh { [weak self] in
            if self?.token != "" {
                self?.getInboxMessages()
            }
        }
        self.loginButtonOutlet.setTitle(lang.login_Title, for: .normal)
        self.loginButtonOutlet.appGuestTextColor()
        self.loginButtonOutlet.borderColor = UIColor.appGuestThemeColor
        self.loginButtonOutlet.borderWidth = 2
        self.msghost_Msg.text = lang.msghost_Msg
        self.inbox_Title.text = self.lang.inbox_Title
        self.inbox_Title.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.inbx_Tit.text = self.lang.inbox_Title
        self.inbx_Tit.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.inbx_Tit1.text = self.lang.inbox_Title
        self.inbx_Tit1.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblSeparator?.alpha = 0.0
        lblTitle?.alpha = 0.0
        self.lblTitle.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        btnStartExploring.appGuestSideBtnBG()
        btnStartExploring.setTitle(self.lang.stexp_Title, for: .normal)
        btnStartExploring.isHidden = true
        
        let rect = UIScreen.main.bounds as CGRect
        var rectStartBtn = btnStartExploring.frame
        rectStartBtn.origin.y = rect.size.height-btnStartExploring.frame.size.height-90
        btnStartExploring.frame = rectStartBtn
//        var rectTblView = tableInbox.frame
//        rectTblView.size.height = rect.size.height-100
//        tableInbox.frame = rectTblView
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
        
    }
    
    @objc func PreAcceptChanged()
    {
        getInboxMessages()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    @IBAction func goToLoginAction(_ sender: Any) {
        let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainPage.hidesBottomBarWhenPushed = true
        
        appDelegate.lastPageMaintain = "inbox"
//        self.navigationController?.pushViewController(mainPage, animated: false)
        let naviation = UINavigationController(rootViewController: mainPage)
        naviation.modalPresentationStyle = .fullScreen
        self.present(naviation, animated: false, completion: nil)
    }
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
    }
    
    @objc func getInboxMessages()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["type"]   = "inbox"
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_INBOX_RESERVATION as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1" && gModel.arrTemp3.count > 0
                {
                    if self.arrInboxMsgs.count > 0
                    {
                        self.arrInboxMsgs.removeAllObjects()
                    }
                    self.arrInboxMsgs.addObjects(from: (gModel.arrTemp3 as NSArray) as! [Any])
                    if self.arrInboxMsgs.count > 0
                    {
                        self.setHeaderInfo(unread_count:gModel.unread_message_count)
                    }
                    self.btnStartExploring.isHidden = true
                    self.tableInbox.isHidden = false
                    self.tableInbox.reloadData()
                }
                else
                {
                    self.lblSeparator?.alpha = 1.0
                    self.lblTitle?.alpha = 1.0
                    self.lblUnreaderStatus.text = self.lang.nomsg_Msg
                    self.btnStartExploring.isHidden = false
                    self.tableInbox.isHidden = false
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.tableInbox.stopPullRefreshEver()
                self.lblUnreaderStatus.isHidden = true
                self.animatedLoader?.isHidden = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
                self.tableInbox.stopPullRefreshEver()
            }
        })
    }
    
    func setHeaderInfo(unread_count: NSString)
    {
        if (unread_count != "0")
        {
            lblUnreaderStatus.text = String(format: "\(self.lang.youhave_Title) %@ \(self.lang.unreadmsg_Title)",unread_count)
        }
        else{
            lblUnreaderStatus.text = self.lang.nounread_Msg
        }
    
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let msgModel = arrInboxMsgs[indexPath.row] as? InboxModel
        return ((msgModel!.last_message as String).count > 0) ? 128 : 100  // 100 - for last message has no text
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let msgModel = arrInboxMsgs[indexPath.row] as? InboxModel
        return UITableView.automaticDimension//((msgModel!.last_message as String).count > 0) ? 128 : 100  // 100 - for last message has no text
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInboxMsgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellInbox = tableInbox.dequeueReusableCell(withIdentifier: "CellInbox") as! CellInbox
        let msgModel = arrInboxMsgs[indexPath.row] as? InboxModel
        cell.setMessageDetails(msgModel: msgModel!)
       
        if msgModel!.reservation_status == "Cancelled"{
            cell.lblTripStatus?.text = self.lang.canld_Tit
        }
        else if msgModel!.reservation_status == "Inquiry"{
            cell.lblTripStatus?.text = self.lang.inq_Title
        }
        else if msgModel!.reservation_status == "Declined"{
            cell.lblTripStatus?.text = self.lang.decld_Tit
        }
        else if msgModel!.reservation_status == "Expired"{
            cell.lblTripStatus?.text = self.lang.exp_Tit
        }
        else if msgModel!.reservation_status == "Accepted"{
            cell.lblTripStatus?.text = self.lang.accep_Tit
        }
        else if msgModel!.reservation_status == "Pre-Accepted"{
            cell.lblTripStatus?.text = self.lang.preaccep_Tit
        }
        else if msgModel!.reservation_status == "Pending"{
            cell.lblTripStatus?.text = self.lang.pend_Tit
        }
        else if msgModel!.reservation_status == "Resubmit"{
            cell.lblTripStatus?.text = self.lang.resub_Tit
        }
        else if msgModel?.reservation_status == "Pre-Approved" {
            cell.lblTripStatus?.text = self.lang.prepproved_Title
        }
//        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if arrInboxMsgs.count == 0
        {
            return
        }
        let  modelInboxData = arrInboxMsgs[indexPath.row] as? InboxModel
        
        if(modelInboxData?.message_status == "Pending" && (Constants().GETVALUE(keyname: APPURL.USER_ID) as String == modelInboxData?.request_user_id as! String))
        {
            gotoReservationDetails(modelInboxData!)
            return
        }

        
        let viewEditProfile = k_MakentStoryboard.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
        if modelInboxData!.is_deleted_user == "true" {
            viewEditProfile.isDeletedUser = true
        }
//        viewEditProfile.hidesBottomBarWhenPushed = true
//        viewEditProfile.modelInboxData = modelInboxData
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tblHeaderView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        lblSeparator?.alpha = (scrollView.contentOffset.y as CGFloat > 55) ? 1.0 : 0.0
        lblTitle?.alpha = (scrollView.contentOffset.y as CGFloat > 55) ? 1.0 : 0.0
    }
    
    func gotoReservationDetails(_ modelInboxData : InboxModel)
    {
        let  userDefaults = UserDefaults.standard
        let msgModel = ReservationModel()
        msgModel.trip_status = modelInboxData.message_status
        msgModel.guest_user_name = modelInboxData.host_user_name
        msgModel.check_in = modelInboxData.check_in_time
        msgModel.check_out = modelInboxData.check_out_time
        msgModel.room_name = modelInboxData.room_name
        msgModel.room_id = modelInboxData.room_id
        msgModel.guest_thumb_image = modelInboxData.host_thumb_image
        msgModel.guest_users_id = modelInboxData.host_user_id
        msgModel.reservation_id = modelInboxData.reservation_id
        msgModel.total_cost = modelInboxData.total_cost
        msgModel.reservation_id = modelInboxData.reservation_id
        msgModel.reservation_id = modelInboxData.reservation_id
        msgModel.room_image = modelInboxData.room_thumb_image
        msgModel.guest_count = modelInboxData.total_guest
        msgModel.total_nights = modelInboxData.total_nights
        msgModel.member_from = modelInboxData.host_member_since_from
        msgModel.expire_timer = modelInboxData.expire_time
        msgModel.room_location = modelInboxData.room_location
        msgModel.service_fee = modelInboxData.service_fee
        msgModel.host_fee = modelInboxData.host_fee
        msgModel.request_user_id = modelInboxData.request_user_id
        msgModel.additional_guest_fee =  modelInboxData.additional_guest_fee
        msgModel.security_deposit = modelInboxData.security_deposit
        msgModel.cleaning_fee = modelInboxData.cleaning_fee
        msgModel.per_night_price = modelInboxData.per_night_price
        msgModel.currency_symbol = (userDefaults.object(forKey: APPURL.USER_CURRENCY_SYMBOL) as? NSString)!
        let viewEditProfile = StoryBoard.host.instance.instantiateViewController(withIdentifier: "ReservationDetailVC") as! ReservationDetailVC
        viewEditProfile.hidesBottomBarWhenPushed = true
        viewEditProfile.isFromGuestInbox = true
        viewEditProfile.modelReservationData = msgModel
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    
    
//    func gotoReservation(model:BaseBookingModel) {
//        let viewEditProfile = k_MakentStoryboard.instantiateViewController(withIdentifier: "InboxDetailVC") as! InboxDetailVC
//        viewEditProfile.modelTripsData = model
//        viewEditProfile.strTripsType = strTripsType
//        viewEditProfile.pageType = self.pageType
//        viewEditProfile.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(viewEditProfile, animated: true)
//    }

    
    // MARK: When User Press Start Exploring
    @IBAction func onStartExploreTapped(_ sender:UIButton!)
    {
        appDelegate.makentTabBarCtrler.selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellInbox: UITableViewCell
{
    @IBOutlet var lblUserName: UILabel?
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var lblMessage: UILabel?
    @IBOutlet var lblRoomLoc: UILabel?
    @IBOutlet var lblRoomPrice: UILabel?
    @IBOutlet var lblTripStatus: UILabel?
    
    func setMessageDetails(msgModel: InboxModel)
    {
       
        imgUserThumb?.layer.cornerRadius = (imgUserThumb?.frame.size.height)! / 2
        imgUserThumb?.clipsToBounds = true
        lblUserName?.text = msgModel.other_user_name as String//msgModel.host_user_name as String
        imgUserThumb?.addRemoteImage(imageURL: msgModel.other_thumb_image as String, placeHolderURL: "")
            //.sd_setImage(with: (NSURL(string: msgModel.host_thumb_image as String) as URL?), placeholderImage:UIImage(named:""))
       
        let replaced = msgModel.last_message as String
        var removPersen = replaced.removingPercentEncoding
        if removPersen == nil {
            removPersen = replaced.replacingOccurrences(of: "%20", with: " ")
            removPersen = removPersen!.replacingOccurrences(of: "%", with: " ")
        }
        lblMessage?.text = removPersen ?? ""
        if let msg = removPersen,
            msg.replacingOccurrences(of: " ", with: "").isEmpty{
            lblMessage?.text = ""
        }
//        lblMessage?.isHidden = replaced.isEmpty
        print("ƒ\(removPersen)\(removPersen?.count)")
        let strCurrency = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL) as String
//        print("Currency",strCurrency)
        if msgModel.total_cost == "0" || msgModel.total_cost == "0.0" || msgModel.total_cost == ""{
            lblRoomPrice?.isHidden = true
            lblRoomPrice?.text = ""
        }
        else{
            lblRoomPrice?.isHidden = false
            lblTripStatus?.isHidden = false
            lblRoomPrice?.text = String(format:"%@%@",strCurrency,msgModel.total_cost)
            // lblTripStatus?.text = msgModel.message_status as String
        }
         if(msgModel.list_type == "Experiences" && msgModel.message_status == "Expired"){
            lblRoomLoc?.text = String(format: "%@",msgModel.room_location)
        
         }else{
            if msgModel.check_in_time == "" && msgModel.check_out_time == ""{
              lblRoomLoc?.text = ""
            }else{
            lblRoomLoc?.text = String(format: "%@\n%@ - %@",msgModel.room_location,msgModel.check_in_time,msgModel.check_out_time)
            }
        }
        if msgModel.is_message_read == "Yes"
        {
            self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        }
        else
        {
            self.backgroundColor = UIColor.white
        }
        
        if msgModel.reservation_status == "Cancelled" || msgModel.reservation_status == "Declined" || msgModel.reservation_status == "Expired"
        {
            lblTripStatus?.textColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
        }
        else if msgModel.reservation_status == "Accepted"
        {
            lblTripStatus?.textColor = UIColor(red: 63.0 / 255.0, green: 179.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        }
        else if msgModel.reservation_status == "Pre-Accepted" || msgModel.reservation_status == "Inquiry"
        {
            lblTripStatus?.textColor = UIColor.darkGray
        }
        else if msgModel.reservation_status == "Pending" || msgModel.reservation_status == "Resubmit"
        {
            lblTripStatus?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }

    
    }
}
