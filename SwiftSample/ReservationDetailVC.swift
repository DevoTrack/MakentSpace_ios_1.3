/**
* ReservationDetailVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class ReservationDetailVC : UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tblReservation: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var lblMemberFrom : UILabel!
    @IBOutlet weak var lblDetail : UILabel!
    @IBOutlet weak var lblStatus : UILabel!

   
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var viewNavHeader: UIView?
    @IBOutlet var btnPreAccept: UIButton?
    @IBOutlet var lblRoomName: UILabel!
    @IBOutlet weak var expirelab: UILabel!
    @IBOutlet weak var expireview: UIView!
    @IBOutlet weak var clockImageView: UIImageView!
    var isFromGuestInbox : Bool = false

    var strHeaderTitle:String = ""
    var Exp_time = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var arrTitle = [String]()
    var arrPlaceHolderTitle = [String]()
    var arrPrice = [String]()
    var arrPirceDesc = [String]()
    var today : String!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var modelReservationData : ReservationModel!
    var nTotalRow:Int = 0
    var isDeletedUser: Bool = false
    var isFromReservation: Bool = false
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var min = 0
    var hours = 0
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    @IBOutlet weak var back_Btn: UIButton!
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        imgUserThumb?.layer.cornerRadius = (imgUserThumb?.frame.size.height)! / 2
        imgUserThumb?.clipsToBounds = true
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine
        self.btnPreAccept?.setTitle(self.lang.preacc_Title, for: .normal)
        tblHeaderView.appGuestViewBGColor()
        btnPreAccept?.appHostSideBtnBG()
        clockImageView.clockImage(.appGuestThemeColor)
        setReservationInfo()
        runTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reservationCancelled), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)

        
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ReservationDetailVC.updateTimer)),userInfo: nil, repeats: true)
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
            
            expirelab.text = "\(self.lang.expires_Title) \(hours):\(min):\(timee)"
        }
      
        if(timee == "0" && min == 0 && hours == 0){
          
            expirelab.isHidden = true
        }
    }
   
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        //print( hours, minutes, seconds)
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func setReservationInfo()
    {
        if modelReservationData != nil
        {
            btnPreAccept?.isHidden = (modelReservationData.trip_status == "Pending") ? false : true
            expireview?.isHidden = (modelReservationData.trip_status == "Pending") ? false : true
            let strCurrency = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL) as String
            if modelReservationData.list_type == "Experiences"{
                lblDetail.text = String(format:"%@ \(self.lang.guests) · %@ %@",modelReservationData.guest_count,strCurrency,modelReservationData.total_cost)
            }
            else{
                lblDetail.text = String(format:"%@ \(self.lang.guests) · %@ \(self.lang.nights_Title) · %@ %@",modelReservationData.guest_count,modelReservationData.total_nights,strCurrency,modelReservationData.total_cost)
            }
            if modelReservationData.trip_status == "Pending"{
                lblStatus.text = self.lang.pend_Tit
            }else  if modelReservationData.trip_status == "Cancelled"{
                lblStatus.text = self.lang.canld_Tit
            }else  if modelReservationData.trip_status == "Declined"{
                lblStatus.text = self.lang.decld_Tit
            }else  if modelReservationData.trip_status == "Expired"{
                lblStatus.text = self.lang.exp_Tit
            }else  if modelReservationData.trip_status == "Accepted"{
                lblStatus.text = self.lang.accep_Tit
            }else  if modelReservationData.trip_status == "Pre-Accepted"{
                lblStatus.text = self.lang.preaccep_Tit
            }else  if modelReservationData.trip_status == "Inquiry"{
                lblStatus.text = self.lang.inq_Title
            }
//            lblStatus.text = modelReservationData.trip_status as String
            lblRoomName?.text = modelReservationData.room_name as String
            let ttime = modelReservationData.expire_timer as String
            if ttime != ""{
                let exptime = ttime.components(separatedBy: ":")
                let h = exptime[0]
                let m = exptime[1]
                let s = exptime[2]
                hours = Int(h)!
                min = Int(m)!
                seconds = Int(s)!
            }
            lblUserName.text = modelReservationData.guest_user_name as String
            lblLocation.text = modelReservationData.guest_user_location as String
            lblMemberFrom.text = modelReservationData.member_from as String
            lblRoomName?.text = modelReservationData.room_name as String
            tblReservation.tableHeaderView = tblHeaderView
            imgUserThumb?.addRemoteImage(imageURL: modelReservationData.guest_thumb_image as String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: modelReservationData.guest_thumb_image as String) as URL?, placeholderImage:UIImage(named:""))
            nTotalRow = 7
            var start = ""
            var end = ""
            if modelReservationData.start_time != "00:00" && modelReservationData.end_time != "00:00"{
                start = "\(modelReservationData.check_in as String)   \(modelReservationData.start_time as String)"
                end = "\(modelReservationData.check_out as String)   \(modelReservationData.end_time as String)"
            }
            else{
                start = modelReservationData.check_in as String
                end = modelReservationData.check_out as String
            }
            if modelReservationData.trip_status == "Pending"
            {
                arrPlaceHolderTitle = [start,end,modelReservationData.guest_count as String," ",String(format:(modelReservationData.can_view_receipt == "Yes") ? "%@%@  " :"%@%@",strCurrency,modelReservationData.total_cost),"",""]
                arrTitle = [self.lang.checkin_Title,
                            self.lang.checkout_Title,
                            "\(self.lang.capguest_Title)\n1 \(self.lang.guest_Title)",
                    "",
                            self.lang.totalcost_Title,
                            self.lang.decline_Title,
                            self.lang.discuss_Title]
            }
            else if modelReservationData.trip_status == "Accepted"
            {
                arrPlaceHolderTitle = [start,end,modelReservationData.guest_count as String," ",String(format:(modelReservationData.can_view_receipt == "Yes") ? "%@%@  " :"%@%@",strCurrency,modelReservationData.total_cost),"",""]
                arrTitle = [self.lang.checkin_Title,self.lang.checkout_Title,"\(self.lang.capguest_Title)\n1 \(self.lang.guest_Title)","",self.lang.totalcost_Title,self.lang.cancel_Title,(isFromGuestInbox) ? self.lang.discuss_Title : self.lang.msghist_Title]
            }
            else
            {
                nTotalRow = 6
                arrPlaceHolderTitle = [start,end,modelReservationData.guest_count as String," ",String(format:(modelReservationData.can_view_receipt == "Yes") ? "%@%@  " :"%@%@",strCurrency,modelReservationData.total_cost),""]
                arrTitle = [self.lang.checkin_Title,self.lang.checkout_Title,"\(self.lang.capguest_Title)\n1 \(self.lang.guest_Title)","",self.lang.totalcost_Title,(isFromGuestInbox) ? self.lang.discuss_Title : self.lang.msghist_Title]
            }

            tblReservation.reloadData()
        }
    }

    
    @IBAction func onPreAcceptTapped(sender: UIButton)
    {
        let preView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PreAcceptVC") as! PreAcceptVC
        preView.strReservationId = modelReservationData.reservation_id as String
        preView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(preView, animated: true)
    }
    
    @objc func reservationCancelled()
    {
        var tempModel = ReservationModel()
        tempModel = modelReservationData
        tempModel.trip_status = (arrTitle[5] as String == self.lang.decline_Title) ? "Declined" : "Cancelled"
        modelReservationData = tempModel
        self.setReservationInfo()
    }
    
    @objc func PreAcceptChanged()
    {
        btnPreAccept?.isHidden = true
        expireview?.isHidden = true
        var tempModel = ReservationModel()
        tempModel = modelReservationData
        tempModel.trip_status = "Pre-Accepted"
        modelReservationData = tempModel
        self.setReservationInfo()
    }
    
   
    @IBAction func onHostProfileTapped()
    {
        if self.isDeletedUser {
            let viewEditProfile = DeletedUserVC.initWithStory()
            viewEditProfile.modalPresentationStyle = .fullScreen
            self.present(viewEditProfile, animated: true, completion: nil)
        } else {
            let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            viewProfile.strOtherUserId = modelReservationData.guest_users_id as String
            viewProfile.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewProfile, animated: true)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 3
        {
            return  289
        }
        else
        {
            return 77
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nTotalRow
//        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath.row == 3)
        {
            let cell:CellInboxRoom = tblReservation.dequeueReusableCell(withIdentifier: "CellInboxRoom") as! CellInboxRoom
            cell.imgRoomThumb?.addRemoteImage(imageURL: modelReservationData.room_image as String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: modelReservationData.room_image as String) as URL?, placeholderImage:UIImage(named:""))
            cell.lblRoomName?.text = modelReservationData.room_name as String
            return cell
        }
        else
        {
            let cell:CellInboxDetail = tblReservation.dequeueReusableCell(withIdentifier: "CellInboxDetail") as! CellInboxDetail
            cell.lblTitleName?.text = arrTitle[indexPath.row]
            cell.lblDetails?.text = arrPlaceHolderTitle[indexPath.row]
            cell.imgAccessory?.isHidden = (indexPath.row == 4 && modelReservationData.can_view_receipt == "Yes") ? false : true
            return cell
        }
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
       
        if isFromGuestInbox
        {
            if (indexPath.row == 3)
            {
                gotoRoomDetailPage()
            }
            else if (indexPath.row == 4){
                appDelegate.samVal = "4"
                self.gotoReceiptPage()
            }
            else if arrTitle[indexPath.row] as String == self.lang.decline_Title
            {
                gotoCancelRequestPage(index: indexPath.row)
            }
            if arrTitle[indexPath.row] as String == self.lang.discuss_Title
            {
                gotoMessageHistory()
            }
        }
        else{
            if modelReservationData.trip_status == "Pending"
            {
//                nTotalRow = 7
//                arrTitle = [self.lang.checkin_Title,self.lang.checkout_Title,"\(self.lang.guess_Tit)\n1 \(self.lang.guest_Title)","",self.lang.totalcost_Title,self.lang.decline_Title,self.lang.discuss_Title]
                if(indexPath.row == 5)
                {
                    self.gotoCancelRequestPage(index: indexPath.row)
                }
                else if (indexPath.row == 6)
                {
                    self.gotoMessageHistory()
                }
                else if (indexPath.row == 4){
                    
                    self.gotoReceiptPage()
                    appDelegate.samVal = "3"
                }
            }
            else if modelReservationData.trip_status == "Accepted"
            {
//                nTotalRow = 7
//                arrTitle = [self.lang.checkin_Title,self.lang.checkout_Title,"\(self.lang.guess_Tit)\n1 \(self.lang.guest_Title)","",self.lang.totalcost_Title,(isFromGuestInbox) ? self.lang.discuss_Title : self.lang.MsgHis_Title]
                if(indexPath.row == 5)
                {
                    self.gotoCancelRequestPage(index: indexPath.row)
                }
                else if (indexPath.row == 6)
                {
                    self.gotoMessageHistory()
                }
                else if (indexPath.row == 4){
                    
                    self.gotoReceiptPage()
                    appDelegate.samVal = "3"
                }else{
                    
                }
            }
            else
            {
//                arrTitle = [self.lang.checkin_Title,self.lang.checkout_Title,"\(self.lang.guess_Tit)\n1 \(self.lang.guest_Title)","",self.lang.totalcost_Title,(isFromGuestInbox) ? self.lang.discuss_Title : self.lang.MsgHis_Title]
                if (indexPath.row == 5)
                {
                    self.gotoMessageHistory()
                }
                else if (indexPath.row == 4){
                    
                    self.gotoReceiptPage()
                    appDelegate.samVal = "3"
                }
            }
        }
     
    }
    
    func gotoCancelRequestPage(index: Int)
    {
        let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "CancelRequestVC") as! CancelRequestVC
        viewWeb.strReservationId = modelReservationData.reservation_id as String
        var arrCancelTitle = [String]()
        viewWeb.strButtonTitle = self.lang.cancelreser_Title//"Cancel Reservation"
        if modelReservationData.trip_status == "Accepted"
        {
            viewWeb.strMethodName = APPURL.METHOD_CANCEL_RESERVATION
            arrCancelTitle = ["Why are you Cancelling?","My place is longer available","I want to offer a different listing or change the price","My place needs maintenance","I have an extenuating circumstance","My guest needs to cancel","Other"]
        }
        else
        {
            if arrTitle[index] as String == "Decline"
            {
                viewWeb.strMethodName = APPURL.METHOD_DECLINE_RESERVATION
                arrCancelTitle = ["Why are you declining?","Dates are not available","I do not feel comfortable with this guest","My listing is not a good to fit for the guest's needs (children, pets, ets.)","I'm waiting for a more attractive reservation","The guest is asking for different dates than the ones selected in this request","This message is spam","Other"]
            }
            else
            {
                viewWeb.strMethodName = APPURL.METHOD_CANCEL_RESERVATION
                arrCancelTitle = ["Why are you declining?","I no longer need accommodations","My travel dates changed","I made the reservation by accident","I have an extenuating circumstance","My host needs to cancel","I’m uncomfortable with the host","The place isn't what I was expecting","The place isn't what I was expecting","Other"]
            }
        }
        viewWeb.arrTitle = arrCancelTitle
        viewWeb.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewWeb, animated: true)

    }
    
    func gotoMessageHistory()
    {
        let viewEditProfile = k_MakentStoryboard.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
//        viewEditProfile.hidesBottomBarWhenPushed = true
//        viewEditProfile.modelReservationData = modelReservationData
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    
    func gotoRoomDetailPage()
    {
//        let roomDetailView = self.storyboard?.instantiateViewController(withIdentifier: "RoomDetailPage") as! RoomDetailPage
//        roomDetailView.strRoomId = (modelReservationData.room_id as Any as! NSString) as String
//        roomDetailView.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(roomDetailView, animated: true)
    }
    
    func gotoReceiptPage()
    {
        makeSpecialPrices()
/* ####### HIDE HOST EXPLERIENCE ####### @START */
        if modelReservationData.list_type == "Experiences" {
            let guestView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "ExperienceRecipitPageVC") as! ExperienceRecipitPageVC
            guestView.isFromGuestSide = false
            guestView.strLocationName = (modelReservationData?.room_location as String?)!
            guestView.subtotal = modelReservationData.per_night_price as String
            guestView.totalAmt = modelReservationData.total_cost as String
            guestView.serviceFee = modelReservationData.service_fee as String
            guestView.guestCount = modelReservationData.guest_count as String
            guestView.isExperiences = true
            guestView.currencySym = (modelReservationData.currency_symbol as String).stringByDecodingHTMLEntities
            guestView.currencyCode = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_ORG) as String
            present(guestView, animated: true, completion: nil)
        }
        else{
/* ####### HIDE HOST EXPLERIENCE ####### @END */
            let guestView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PriceBreakDown") as! PriceBreakDown
            present(guestView, animated: true, completion: nil)
        }
        // ****HIDE HOST EXPLERIENCE****
    }
    
    func makeSpecialPrices()
    {
        let currencySymbol = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL) as String
        let strAdditionalGuest = String(format:"%@ %@",currencySymbol,modelReservationData.additional_guest_fee)
        let strsecurity_deposit = String(format:"%@ %@",currencySymbol,modelReservationData.security_deposit)
        let strcleaning_fee = String(format:"%@ %@",currencySymbol,modelReservationData.cleaning_fee)
        arrPrice = [String]()
        arrPirceDesc = [String]()
        if modelReservationData.additional_guest_fee != "0" && modelReservationData.additional_guest_fee != ""
        {
            arrPrice.append(strAdditionalGuest)
            arrPirceDesc.append("Additional Guest fee")
        }
        if modelReservationData.security_deposit != "0" && modelReservationData.security_deposit != ""
        {
            arrPrice.append(strsecurity_deposit)
            arrPirceDesc.append("Security fee")
        }
        if modelReservationData.cleaning_fee != "0" && modelReservationData.cleaning_fee != ""
        {
            arrPrice.append(strcleaning_fee)
            arrPirceDesc.append("Cleaning fee")
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {

    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    
}

class CellReservationDesc: UITableViewCell
{
    @IBOutlet var lblStatus: UILabel?
    @IBOutlet var lblDate: UILabel?
    @IBOutlet var lblMessage: UILabel?
    @IBOutlet var lblGuest: UILabel?
}


