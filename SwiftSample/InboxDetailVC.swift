/**
* InboxDetailVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol InboxDetailDelegate
{
    func roomDescriptionChanged(strDescription: NSString, isTitle: Bool)
}

struct BookingDetailHistory {
    var key : String
    var value : String
}

struct simulator {
    static var isSimulator : Bool{
        return TARGET_OS_SIMULATOR != 0
    }
}

class InboxDetailVC : UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableInboxDetail: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var lblSeparator: UILabel?
    
    @IBOutlet var lblRoomName: UILabel?
    @IBOutlet var lblTotalNights: UILabel?
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet var lblRoomType: UILabel?
    @IBOutlet var lblHostedBy: UILabel?
    @IBOutlet var btnBookNow: UIButton?
    @IBOutlet weak var bookNowBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var expirelab: UILabel!
    @IBOutlet weak var expireview: UIView!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var back_btn: UIButton!
    
    @IBOutlet weak var profileParentView: UIView!
    var pageType:BookingDetailsTypeEnum = .trips
    
    var arrTripDetailsList = [BookingDetailHistory]()
    var delegate: InboxDetailDelegate?
    var modelTripsData : BaseBookingModel!
    var nTotalRow:Int = 0
    var strTripsType : String = ""
    var isDeletedUser: Bool = false
    var isFromReservation: Bool = false
    var arrPrice = [String]()
    var arrPirceDesc = [String]()
    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let cellReuseIdentifier = "cell"
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var arrTitle = [String]()
    var arrPlaceHolderTitle = [String]()
    var timer = Timer()
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var min = 0
    var hours = 0
    
    var isFromGuest = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.back_btn.transform = Language.getCurrentLanguage().getAffine
        lblSeparator?.alpha = 0.0
        imgUserThumb?.layer.cornerRadius = (imgUserThumb?.frame.size.height)! / 2
        imgUserThumb?.clipsToBounds = true
        btnBookNow?.appHostSideBtnBG()
        tblHeaderView.appGuestViewBGColor()
        clockImageView.clockImage(.appGuestThemeColor)
        clockImageView.isHidden = true
        self.tableInboxDetail.estimatedRowHeight = 125
//        self.tableInboxDetail.estimatedRowHeight
        self.initDetails()
        self.tableInboxDetail.register(UINib.init(nibName: "GuidanceCell", bundle: nil), forCellReuseIdentifier: "GuidanceCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reservationCancelled), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tripCancelled), name: NSNotification.Name(rawValue: "CancelResquestToBook"), object: nil)
    }
    
    
    
    @IBAction func onBookNowTapped(sender: UIButton)
    {
        //let model = bookingDetailsModelArray[sender.tag]
        if sender.currentTitle == self.lang.Book_Now {
            self.callBookNowAction()
            
        }else if sender.currentTitle == self.lang.preAccepted {
            
            self.callPreAcceptedAction()
        }

    }

    func callBookNowAction() {
//        let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
//        viewWeb.hidesBottomBarWhenPushed = true
//        //            viewWeb.appDelegate.lastPageMaintain = "Trips"
//        viewWeb.strPageTitle = self.lang.payment_Title
//        viewWeb.strWebUrl = String(format:"%@%@?reservation_id=%@&token=%@",k_APIServerUrl,API_PAY_NOW,(modelTripsData.reservationID),Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))
//        self.navigationController?.pushViewController(viewWeb, animated: true)
        let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        contactView.sKey = ""
        contactView.strInstantBook = "Yes"
        contactView.Reser_ID  = modelTripsData.reservationID.description
        contactView.modalPresentationStyle = .fullScreen
        let navController = UINavigationController(rootViewController: contactView)
        self.present(navController, animated:true, completion: nil)
        
    }
    
    func callPreAcceptedAction() {
        let preView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PreAcceptVC") as! PreAcceptVC
        preView.strReservationId = modelTripsData.reservationID.description
        preView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(preView, animated: true)
    }
    
    @objc func tripCancelled()
    {
        self.onBackTapped(nil)
    }
    
    
    
    @objc func reservationCancelled()
    {
//        var tempModel = ReservationBookingModel()
//        tempModel = modelReservationData
//        tempModel.trip_status = (arrTitle[5] as String == self.lang.decline_Title) ? "Declined" : "Cancelled"
//        modelReservationData = tempModel
        self.onBackTapped(self.back_btn)
    }
    
    @objc func PreAcceptChanged()
    {
//        btnBookNow?.isHidden = true
//        expireview?.isHidden = true
////        var tempModel = ReservationModel()
//
//        self.modelTripsData.reservationStatus = "Pre-Accepted"
////        modelReservationData = tempModel
//        self.setReservationInfo(model: self.modelTripsData)
        self.onBackTapped(self.back_btn)
    }
    
    
   
    
    
    func setLocalData(_ model:BaseBookingModel) {
        
        let Currency = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL) as String
        let strCurrency = Currency.stringByDecodingHTMLEntities
        
        var start = ""
        var end = ""
        let count = model.numberOfGuests.toInt()
        var gueststr:String = ""
        if (count == 1){
            gueststr = self.lang.guesss_Tit.capitalized
        }else{
            gueststr = self.lang.guessts_Tit.capitalized
            
        }
        if (model.startTime != "00:00" && model.endTime != "00:00") && (!model.startTime.isEmpty && !model.endTime.isEmpty) {
            start = "\(model.checkin as String) \n\(model.startTime as String)"
            end = "\(model.checkout as String) \n\(model.endTime as String)"
        }
        else{
            start = model.checkin as String
            end = model.checkout as String
        }
        self.arrTripDetailsList.removeAll()
        let startTime = BookingDetailHistory(key: self.lang.checkin_Title, value: start)
        self.arrTripDetailsList.append(startTime)
        let endTime = BookingDetailHistory(key: self.lang.checkout_Title, value: end)
        self.arrTripDetailsList.append(endTime)
        let guest = BookingDetailHistory(key: gueststr, value: model.numberOfGuests)
        self.arrTripDetailsList.append(guest)
        let guidance = BookingDetailHistory(key: self.lang.chkGuidance  , value: model.guidance)
        if model.guidance != ""{
        self.arrTripDetailsList.append(guidance)
        }
        let totalCost = BookingDetailHistory(key: self.lang.totalcost_Title, value: "\(strCurrency)\(model.totalCost)")
        self.arrTripDetailsList.append(totalCost)
        
        if self.pageType == .trips {
            self.setInboxList(model)
        }else {
            if self.pageType == .inbox {
                self.isFromGuest = true
            }
            self.setReservationList(model)
        }

    }
    
    private func setInboxList(_ model:BaseBookingModel) {
//        if self.strTripsType != "Expired" && model.reservationStatus != "Cancelled" {
        if (model.reservationStatus != "Expired" && model.reservationStatus != "Cancelled") && self.strTripsType != "previous_bookings" {
            
            if strTripsType == "pending_bookings" {
                
                let cancelReq = BookingDetailHistory(key: self.lang.Cancelreq_Title, value: "")
                self.arrTripDetailsList.append(cancelReq)
            }else if !strTripsType.isEmpty {
                let checkoutDate = model.checkout
                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let date = dateFormatter.date(from:checkoutDate)!
//                let todaydate = Date()
//                var showCancel = Bool()
//                let today = date.isToday
//                if date > todaydate {
//                    print("\(date) is passed")
//                    showCancel = true
//                } else if today {
//                    showCancel = true
//                } else {
//                    showCancel = false
//                }
                if model.reservationStatus != "Declined"
                    // && showCancel
                    
                {
                    let cancel = BookingDetailHistory(key: self.lang.cancel_Title, value: "")
                    self.arrTripDetailsList.append(cancel)
                }
            }
            let messageHistory = BookingDetailHistory(key: self.lang.msghist_Title, value: "")
            self.arrTripDetailsList.append(messageHistory)
        }
        if model.reservationStatus == "Cancelled"{
            let messageHistory = BookingDetailHistory(key: self.lang.msghist_Title, value: "")
            self.arrTripDetailsList.append(messageHistory)
        }
    }
    
    func setReservationList(_ model:BaseBookingModel) {
        if model.reservationStatus == "Pending" {
            let decline = BookingDetailHistory(key: self.lang.decline_Title, value: "")
            self.arrTripDetailsList.append(decline)
            let discuss = BookingDetailHistory(key: self.lang.discuss_Title, value: "")
            self.arrTripDetailsList.append(discuss)
        }else {
            
            if self.isFromGuest {
                let decline = BookingDetailHistory(key: self.lang.decline_Title, value: "")
                self.arrTripDetailsList.append(decline)
            }else {
                let checkoutDate = model.checkout
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let date = dateFormatter.date(from:checkoutDate)!
//                var showCancel = Bool()
//                let today = date.isToday
//                let todaydate = Date()
//                if date > todaydate {
//                    print("\(date) is passed")
//                    showCancel = true
//                } else if today {
//                    showCancel = true
//                } else {
//                    showCancel = false
//                }
                if model.reservationStatus != "Declined" && model.reservationStatus != "Cancelled"
                    //&& showCancel
                {
                    let cancel = BookingDetailHistory(key: self.lang.cancel_Title, value: "")
                    self.arrTripDetailsList.append(cancel)
                    let messageHistory = BookingDetailHistory(key: self.lang.msghist_Title, value: "")
                    self.arrTripDetailsList.append(messageHistory)
                }
            }
           
        }

    }
    
    func initDetails() {
        self.setBasicDetails(model: self.modelTripsData)
        self.setLocalData(modelTripsData)
        self.imgUserThumb?.addTap {
            if self.pageType == .trips {
                let model = self.modelTripsData as! TripBookingModel
                self.onHostProfileTapped(userID: model.hostUserID)
            }else if self.pageType == .inbox {
                let model = self.modelTripsData as! InboxBookingModel
                self.onHostProfileTapped(userID: model.otherUserID)
            }else {
                let model = self.modelTripsData as! ReservationBookingModel
                self.onHostProfileTapped(userID: model.otherUserID)
            }
            
        }
        
        
    }
    
    func setBasicDetails(model:BaseBookingModel) {
        lblRoomName?.text = model.spaceName as String
        lblStatus.text = model.reservationStatus
        lblTotalNights?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblRoomName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblHostedBy?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        tableInboxDetail.tableHeaderView = tblHeaderView
        if self.pageType == .trips {
            self.setTripDetailsInfo(model: model as! TripBookingModel)
        }else {
            self.setReservationInfo(model: model )
        }
    }
    
    func setTripDetailsInfo(model:TripBookingModel) {
        
        lblTotalNights?.text = "\(model.spaceLocation)\n\(Constants().setTripStatus(model))"
        self.lblRoomName?.text = model.spaceName
        self.lblHostedBy?.text = String(format:"\(self.lang.host_ByTitle) %@", model.hostUserName)
        imgUserThumb?.addRemoteImage(imageURL: model.hostThumbImage as String, placeHolderURL: "", isRound: true)
        self.showBookNowBtn(model: model)

    }
    
    func showBookNowBtn(model:BaseBookingModel) {
        btnBookNow?.setTitle(self.lang.Book_Now, for: .normal)
        if (model.bookingStatus == "Available" && model.reservationStatus != "Pending") {
            btnBookNow?.isHidden = false
            bookNowBtnWidthConstraint.constant = btnBookNow?.intrinsicContentSize.height ?? 75
            expireview.isHidden = false
        }else {
            btnBookNow?.isHidden = true
            bookNowBtnWidthConstraint.constant = 0
        }
        
    }
    
    
    func setReservationInfo(model:BaseBookingModel) {
       
        let currency = model.currencySymbol
        let price = model.totalCost
        let spaceName = model.spaceName
        self.lblTotalNights?.text = Constants().setTripStatus(model)
        
        self.lblRoomName?.text = "\(currency)\(price)\n\(spaceName)"
        
        if self.pageType == .reservation {
            let baseModel = model as! ReservationBookingModel
            let userName = baseModel.otherUserName
            let member = model.memberFrom
            self.lblHostedBy?.text = "\(userName)\n\(member)"
            self.imgUserThumb?.addRemoteImage(imageURL: baseModel.otherThumbImage, placeHolderURL: "", isRound: true)
        }else {
            let baseModel = model as! ReservationBookingModel
            let userName = baseModel.otherUserName
            let member = model.memberFrom
            self.lblHostedBy?.text = "\(userName)\n\(member)"
            self.imgUserThumb?.addRemoteImage(imageURL: baseModel.otherThumbImage, placeHolderURL: "", isRound: true)
        }
        self.showPreAcceptBtn(model: model)
    }
    
    private func showPreAcceptBtn(model:BaseBookingModel) {
        if model.reservationStatus == "Pending" {
            btnBookNow?.isHidden =  false
            expireview?.isHidden =  false
            let ttime = model.expireTimer as String
            if ttime != ""{
                let exptime = ttime.components(separatedBy: ":")
                let h = exptime[0]
                let m = exptime[1]
                let s = exptime[2]
                hours = Int(h)!
                min = Int(m)!
                seconds = Int(s)!
                self.runTimer()
            }
            self.btnBookNow?.setTitle(self.lang.preAccepted, for: .normal)
            bookNowBtnWidthConstraint.constant = btnBookNow?.intrinsicContentSize.height ?? 75
        }else {
            btnBookNow?.isHidden = true
            bookNowBtnWidthConstraint.constant = 0
        }
        
        
    }
    
    
    private func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)),userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        var timee = ""
        if seconds < 1 {
            
            timer.invalidate()
            seconds = 60
            //Send alert to indicate "time's up!"
        } else {
            seconds -= 1
            // let timee = timeString(time: TimeInterval(seconds))
            timee = "\(seconds)"
            //print(timee)
            if timee == "0"{
                
                min -= 1
                runTimer()
            }
            if(timee == "0" && min == 0){
                
                hours -= 1
            }
            clockImageView.isHidden = false
            expirelab.text = "\(self.lang.expires_Title) \(hours):\(min):\(timee)"
        }
        
        if(timee == "0" && min == 0 && hours == 0){
            clockImageView.isHidden = true
            expirelab.isHidden = true
        }
    }
    
    
    func onHostProfileTapped(userID:Int)
    {
        if self.isDeletedUser {
            let viewEditProfile = DeletedUserVC.initWithStory()
                                    viewEditProfile.modalPresentationStyle = .fullScreen
                                    self.present(viewEditProfile, animated: true, completion: nil)
        } else {
            let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            viewProfile.strOtherUserId = userID.description
            viewProfile.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewProfile, animated: true)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        if indexPath.row == 3
//        {
//            return  289
//        }
//        else
//        {
            return UITableView.automaticDimension
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tblHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTripDetailsList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellInboxDetail = tableInboxDetail.dequeueReusableCell(withIdentifier: "CellInboxDetail") as! CellInboxDetail
        cell.lblTitleName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblDetails?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .right)
        print("indexPathRow:",indexPath.row)
        if (indexPath.row == 3)
        {
            let cell:CellInboxRoom = tableInboxDetail.dequeueReusableCell(withIdentifier: "CellInboxRoom") as! CellInboxRoom
            cell.imgRoomThumb?.addRemoteImage(imageURL: modelTripsData.spaceImage, placeHolderURL: "")
            cell.lblRoomName?.text = modelTripsData.spaceName
            cell.lblRoomName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            return cell
        }
        else if indexPath.row > 3
        {

            guard self.arrTripDetailsList.count > 0 else{return cell}
            let model = arrTripDetailsList[indexPath.row - 1]
//            let guidance = BookingDetailHistory(key: "Check in-guidance\n" + model.guidance, value: "")
//            if model.guidance != ""{
//                self.arrTripDetailsList.append(guidance)
//             }
            if model.key == self.lang.chkGuidance{
               let cell:GuidanceCell = tableInboxDetail.dequeueReusableCell(withIdentifier: "GuidanceCell") as! GuidanceCell
                cell.Lbltitle.text = model.key
                let termText = model.value
                let txtView = "View"
                cell.Lblguidance.text = termText + " " + txtView
                
                return cell
            }
            cell.lblTitleName?.text = model.key
            cell.lblDetails?.text = model.value
            if model.key == self.lang.totalcost_Title {
                cell.accessoryType = .disclosureIndicator
            }else {
                cell.accessoryType = .none
            }
            return cell
        }else {
            cell.accessoryType = .none
            let model = arrTripDetailsList[indexPath.row]
            cell.lblTitleName?.text = model.key
            cell.lblDetails?.text = model.value
            return cell
        }
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row > 3 {
            let model = arrTripDetailsList[indexPath.row - 1]
            if model.key ==  self.lang.totalcost_Title {
                gotoReceiptPage()
            }else if model.key == self.lang.Cancelreq_Title || model.key == self.lang.cancel_Title || model.key == self.lang.decline_Title {
                self.gotoCancelPage()
            }else if model.key == self.lang.MsgHis_Title || model.key == self.lang.discuss_Title {
                self.gotoChatView()
            }
            
        }else if indexPath.row == 3 {
            if self.isDeletedUser {
                let viewEditProfile = DeletedUserVC.initWithStory()
                                        viewEditProfile.modalPresentationStyle = .fullScreen
                                        self.present(viewEditProfile, animated: true, completion: nil)
            } else {
                gotoRoomDetailPage()
            }
            
        }

    }
    
    func gotoChatView()
    {
        let viewEditProfile = k_MakentStoryboard.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
        viewEditProfile.hidesBottomBarWhenPushed = true
        viewEditProfile.pageType = self.pageType
        if self.isDeletedUser{
            viewEditProfile.isDeletedUser = true
        }
        viewEditProfile.baseBookingModel = modelTripsData
        self.navigationController?.pushViewController(viewEditProfile, animated: true)

    }
    
    func gotoRoomDetailPage()
    {
          let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
        homeDetailVC.roomIDString = modelTripsData.spaceID.description
        homeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeDetailVC, animated: true)
    }
    
    func gotoCancelPage() {
        let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "CancelRequestVC") as! CancelRequestVC
        viewWeb.strReservationId = modelTripsData.reservationID.description
            viewWeb.pageType = self.pageType
//        if self.pageType == .reservation || ((self.modelTripsData.bookingStatus == "Not Available" || self.modelTripsData.reservationStatus == "Pending")) {
//        if SharedVariables.sharedInstance.userID == "\(self.modelTripsData.guestUserID)" {
//
//        }else {
//            viewWeb.strMethodName = METHOD_CANCEL_RESERVATION
//        }
        
        
//        if (strTripsType == "pending_bookings")
//        {
//            viewWeb.strMethodName = METHOD_CANCEL_PENDING_TRIP_BY_GUEST
//        }
//        else
//        {
        
//            if self.modelTripsData.reservationStatus != "Accepted" {
//                    viewWeb.strMethodName = METHOD_CANCEL_RESERVATION
//            }else {
//                viewWeb.strMethodName = METHOD_GUEST_CANCEL_TRIP_AFTER_PAY
//            }
            
//        }
        
        viewWeb.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewWeb, animated: true)
    }
    
    func gotoReceiptPage()
    {
        makeSpecialPrices()
            let guestView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PriceBreakDown") as! PriceBreakDown
            guestView.reservation_id = modelTripsData.reservationID.description
        if let userID = UserDefaults.standard.value(forKey: APPURL.USER_ID) {
            guestView.isFromReservation = "\(modelTripsData.guestUserID)" != "\(userID)" || self.pageType == .reservation
        }
//        guestView.isFromReservation = (self.pageType == .reservation || self.pageType == .inbox)
        
            guestView.modalPresentationStyle = .fullScreen
            present(guestView, animated: true, completion: nil)
//        }// ****HIDE HOST EXPLERIENCE****
    }
    
    func makeSpecialPrices()
    {
//        let currencySymbol = (Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL) as String).stringByDecodingHTMLEntities
//
//        let strAdditionalGuest = String(format:"%@ %@",currencySymbol,modelTripsData.addition_guest_fee)
//        let strsecurity_deposit = String(format:"%@ %@",currencySymbol,modelTripsData.security_fee)
//        let strcleaning_fee = String(format:"%@ %@",currencySymbol,modelTripsData.cleaning_fee)
//        let couponAmount = String(format:"-%@ %@",currencySymbol,modelTripsData.coupon_amount)
//        let travelCredit = String(format:"-%@ %@",currencySymbol,modelTripsData.travel_credit)
//        arrPrice = [String]()
//        arrPirceDesc = [String]()
//        if modelTripsData.addition_guest_fee != "0" && modelTripsData.addition_guest_fee != ""
//        {
//            arrPrice.append(strAdditionalGuest)
//            arrPirceDesc.append("Additional Guest fee")
//        }
//
//        if modelTripsData.security_fee != "0" && modelTripsData.security_fee != ""
//        {
//            arrPrice.append(strsecurity_deposit)
//            arrPirceDesc.append("Security fee")
//        }
//
//        if modelTripsData.cleaning_fee != "0" && modelTripsData.cleaning_fee != ""
//        {
//            arrPrice.append(strcleaning_fee)
//            arrPirceDesc.append("Cleaning fee")
//        }
//        if modelTripsData.coupon_amount != "0" && modelTripsData.coupon_amount != ""
//        {
//            arrPrice.append(couponAmount)
//            arrPirceDesc.append("Coupon Amount")
//        }
//        if modelTripsData.travel_credit != "0" && modelTripsData.travel_credit != ""
//        {
//            arrPrice.append(travelCredit)
//            arrPirceDesc.append("Travel Credit")
//        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        lblSeparator?.alpha = (scrollView.contentOffset.y as CGFloat > 20) ? 1.0 : 0.0
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellInboxDetail: UITableViewCell
{
    @IBOutlet var lblTitleName: UILabel?
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var imgAccessory: UIImageView?

}

class CellInboxRoom: UITableViewCell
{
    @IBOutlet var lblRoomName: UILabel?
    @IBOutlet var imgRoomThumb: UIImageView?
}
