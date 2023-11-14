//
//  ChatViewController.swift
//  MakentCars
//
//  Created by trioangle on 13/04/19.
//  Copyright © 2019 Trioangle. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class ChatViewController: UIViewController,MessageComposerViewDelegate,UITableViewDataSource,UITableViewDelegate {

//    @IBOutlet weak var btnTrans: UIButton!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatHistoryTableView: UITableView!
    @IBOutlet weak var bookNowButtonOutlet: UIButton!
    @IBOutlet weak var chatStatusLabel: UILabel!
    @IBOutlet weak var chatHeaderView: UIView!
    @IBOutlet weak var detailHeight: NSLayoutConstraint!
    @IBOutlet weak var decline: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var preApprove: UIButton!
    var composeView: MessageComposerView!
    let trnasLateBtn = UIButton()
    let borderLbl = UILabel()
    var isDeletedUser: Bool = false
//     var completeDelegate:CompleteBookingDelegate?
    var  userDefaults = UserDefaults.standard
//    var modelInboxData : InboxBookingModel!
//    var modelTripData : TripBookingModel!
//    var modelReservationData: ReservationBookingModel!
    var baseBookingModel:BaseBookingModel!
    var conversationChatModel : ConversationChatModel!
    var pageType:BookingDetailsTypeEnum = BookingDetailsTypeEnum.trips
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var isTranslate = false
    var chatListArray = [Chat]()
    var hostUserName = String()
    var tripStatus = String()
    var ownerUserId = Int()
    var carId = Int()
    var messageType = String()
    var reservationId = Int()
    var val = ""
//    var listType = String()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func viewDidLayoutSubviews() {
        self.chatHistoryTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden  = false
//        let barButtonItem = UIBarButtonItem(image: UIImage(named: "searchBack.png"), style: .plain, target: self, action: #selector(self.back_Act))
        
        self.chatHistoryTableView.estimatedRowHeight = 91.0
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "back_btn_grey_new.png"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btn1.transform = Language.getCurrentLanguage().getAffine
        btn1.addTarget(self, action: #selector(self.back_Act), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item1
        self.bookNowButtonOutlet.appHostSideBtnBG()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.preApprove.isHidden = true
        self.decline.isHidden = true
        bookNowButtonOutlet.isHidden = true
        self.chatHistoryTableView.estimatedRowHeight = 74
        detailHeight.constant = 0
        if pageType == .trips,let model = baseBookingModel as? TripBookingModel {
                hostUserName = model.hostUserName as String
                tripStatus = model.reservationStatus as String
                ownerUserId = model.hostUserID
                carId = model.spaceID
                messageType = "5"
                reservationId = model.reservationID
                //            listType = modelTripData.list_type as String
            
        }else if pageType == .inbox, let model = baseBookingModel as? InboxBookingModel
        {
            print("Booking Model values",baseBookingModel.reservationID)
            hostUserName = model.otherUserName
            tripStatus = model.reservationStatus
            ownerUserId = model.otherUserID  == 0 ? model.requestUserID : model.otherUserID
            carId = model.spaceID
            messageType = "5"
//                model.message_type
            reservationId = model.reservationID
            //            listType = modelInboxData.list_type as String
        }else if pageType == .reservation, let model = baseBookingModel as? ReservationBookingModel {
            hostUserName = model.otherUserName as String
            //            if hostUserName.isEmpty {
            //                hostUserName = modelReservationData.guest_user_name as String
            //            }
            tripStatus = model.reservationStatus as String
            ownerUserId = model.otherUserID
            carId = model.spaceID
            messageType = "5"
            reservationId = model.reservationID
            //            listType = modelReservationData.list_type as String
        }
        
        
         self.setBookingInfo()
        self.title = hostUserName
//        chatStatusLabel.text = tripStatus
        if self.isDeletedUser {
            
        } else {
            self.onShowMsgComposeView()
        }
      
        
//        if tripStatus == "Declined"{
//            chatStatusLabel.text = self.lang.decld_Tit
//        }else if tripStatus == "Inquiry"{
//            chatStatusLabel.text = self.lang.inq_Title
//        }else if tripStatus == "Cancelled"{
//            chatStatusLabel.text = self.lang.canld_Tit
//        }else if tripStatus == "Expired"{
//            chatStatusLabel.text = self.lang.exp_Tit
//        }else if tripStatus == "Accepted"{
//            chatStatusLabel.text = self.lang.accep_Tit
//        }else if tripStatus == "Pre-Accepted"{
//            chatStatusLabel.text = self.lang.preacc_Title
//        }else if tripStatus == "Pending"{
//            chatStatusLabel.text = self.lang.pend_Tit
//        }else if tripStatus == "Pre-Approved" {
//            chatStatusLabel.text = self.lang.prepproved_Title
//        }
       
        if tripStatus == "Resubmit"{
            chatStatusLabel.text = self.lang.resub_Tit
            self.composeView.isHidden = true
        }else {
            self.chatStatusLabel.text = Constants().setTripStatus(baseBookingModel)
        }
       
        
        
        self.chatHeaderView.backgroundColor = UIColor.appGuestThemeColor
        //self.chatStatusLabel.textColor = UIColor.appTitleColor
        self.bookNowButtonOutlet.backgroundColor = UIColor.appHostButtonBG
        self.bookNowButtonOutlet.layer.cornerRadius = 5.0
        self.bookNowButtonOutlet.clipsToBounds = true
        self.bookNowButtonOutlet.elevate(3.0)
        
        self.preApprove.appGuestBGColor()
        self.decline.appHostBGColor()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        chatStatusLabel.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.requestUpdated), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestUpdated), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestUpdated), name: NSNotification.Name(rawValue: "ResquestToBook"), object: nil)
        self.wsToGetMessageList(progress: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func requestUpdated() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    @IBAction func preApproveButtonTapped(_ sender: UIButton) {
        guard baseBookingModel != nil else {
            return
        }
     
        let preView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PreAcceptVC") as! PreAcceptVC
        if baseBookingModel.reservationStatus == "Inquiry" || baseBookingModel.reservationStatus == "Pre-Accepted" {
            preView.strPageTitle = self.lang.preapprove_Title
        }
        preView.strReservationId = baseBookingModel.reservationID.description
        preView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(preView, animated: true)
        
        
    }
    
    @IBAction func declineButtonTapped(_ sender: UIButton) {
        guard baseBookingModel != nil else {
            return
        }
        
        let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "CancelRequestVC") as! CancelRequestVC
        viewWeb.strReservationId = baseBookingModel.reservationID.description
        var arrCancelTitle = [String]()
        viewWeb.strButtonTitle = "Cancel Reservation"
        viewWeb.strMethodName = APPURL.METHOD_PRE_APPROVAL_OR_DECLINE
        arrCancelTitle = ["Why are you declining?","I do not feel comfortable with this guest","My listing is not a good to fit for the guest's needs (children, pets, ets.)","I'm waiting for a more attractive reservation","The guest is asking for different dates than the ones selected in this request","This message is spam","Other"]
        viewWeb.arrTitle = arrCancelTitle
        viewWeb.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewWeb, animated: true)
        
    }
    
    @objc func back_Act(){
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if self.composeView != nil {
            tableViewBottomConstraint.constant = 0
            self.composeView.messageTextView.resignFirstResponder()
            self.composeView.removeFromSuperview()
            self.trnasLateBtn.removeFromSuperview()
            self.composeView = nil;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = false
        if self.isDeletedUser {
            
        } else {
            self.onShowMsgComposeView()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListArray.count
    }
    func setBookingInfo(){
        
        guard  baseBookingModel != nil else {
            return
        }
        if self.checkOwner() && tripStatus == "Inquiry" {
            self.detailHeight.constant = 58
            self.preApprove.isHidden = false
            self.decline.isHidden = false
        }else if ((tripStatus == "Pre-Accepted" || tripStatus == "Pre-Approved") && !self.checkOwner())  {
            self.bookNowButtonOutlet.layer.cornerRadius = 5
            self.bookNowButtonOutlet.clipsToBounds = true
            bookNowButtonOutlet.isHidden = false
            bookNowButtonOutlet.setTitleColor(.white, for: .normal )
        }
        
        
    }
    func checkOwner()->Bool {
        if let model = self.baseBookingModel as? InboxBookingModel {
            if (Constants().GETVALUE(keyname: APPURL.USER_ID) as String == model.requestUserID.description){
                return true
            }else {
                return false
            }
        }
        
        return false
    }
    
     
     
     
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if chatListArray.count > 0 {
//            if chatListArray[indexPath.row].sender_user_name != "" {
////                let cell = tableView.cellForRow(at: indexPath) as! SenderMessageTVC
//
//                return MakentSupport().onGetStringHeight(tableView.frame.width, strContent: chatListArray[indexPath.row].sender_messages as NSString, font: UIFont(name: Fonts.CIRCULAR_LIGHT, size: 17)!)
//            }else {
//
//                return MakentSupport().onGetStringHeight(tableView.frame.width, strContent: chatListArray[indexPath.row].receiver_messages as NSString, font: UIFont(name: Fonts.CIRCULAR_LIGHT, size: 17)!)
//            }
//        }
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if chatListArray[indexPath.row].sender_user_name != "" {
            let cell: SenderMessageTVC = tableView.dequeueReusableCell(withIdentifier: "senderMessageTVC") as! SenderMessageTVC
            //cell.senderView.backgroundColor = UIColor.appTitleColor
            cell.senderView.appGuestViewBGColor()
            let senderData = self.chatListArray[indexPath.row]
            cell.senderImageButtonOutlet.sd_setBackgroundImage(with: URL(string: senderData.sender_thumb_image)!, for: .normal)
            cell.timeLbl.text = senderData.conversation_time
            if self.isTranslate{
                cell.transText("\(senderData.sender_messages)", "\(senderData.sender_messages_time)")
                DispatchQueue.main.async {
                    cell.transText("\(senderData.sender_messages)", "\(senderData.sender_messages_time)")
                }
            }else{
                cell.senderMessageLabel.text = "\(senderData.sender_messages)\n\(senderData.sender_messages_time)"
                DispatchQueue.main.async {
                    cell.senderMessageLabel.text = "\(senderData.sender_messages)\n\(senderData.sender_messages_time)"
                }
            }
            
            cell.senderIndicatorImageView.image = UIImage(named: "sender_indicator")?.withRenderingMode(.alwaysTemplate)
            cell.senderIndicatorImageView.tintColor = UIColor.appGuestThemeColor
            //cell.senderIndicatorImageView.image?.withRenderingMode(.alwaysTemplate)
//            cell.senderMessageLabel.text = "\(senderData.sender_messages)"
            cell.senderMessageLabel.attributedText =   MakentSupport().addAttributeFont(originalText: cell.senderMessageLabel.text!, attributedText: senderData.sender_messages_time, attributedFontName: Fonts.CIRCULAR_LIGHT, attributedColor: .white, attributedFontSize: 4)
            cell.senderImageButtonOutlet?.layer.cornerRadius = (cell.senderImageButtonOutlet?.frame.size.height)! / 2
            cell.senderImageButtonOutlet?.clipsToBounds = true
            cell.senderIndicatorImageView.transform = Language.getCurrentLanguage().getAffine
            cell.senderMessageLabel?.layer.cornerRadius = 5
            cell.senderMessageLabel?.clipsToBounds = true
            cell.senderView?.layer.cornerRadius = 5
            cell.senderView?.clipsToBounds = true
            cell.senderImageButtonOutlet.addTarget(self, action: #selector(self.onSenderProfileTapped), for: .touchUpInside)
            print("LABEL TEXT: \(cell.senderMessageLabel.text ?? "EMPTYYYYY")")
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell: ReceiverMessageTVC = tableView.dequeueReusableCell(withIdentifier: "receiverMessageTVC") as! ReceiverMessageTVC
            let senderData = self.chatListArray[indexPath.row]
            cell.receiverView.backgroundColor = UIColor.init(hex: "#EFEFEF")
//            (named: "#EFEFEF")
            cell.timeLbl.text = senderData.conversation_time
            cell.receiverIndicatorImageView.image = UIImage(named: "receiver_indicator")?.withRenderingMode(.alwaysTemplate)
            cell.receiverIndicatorImageView.tintColor =  UIColor.init(hex: "#EFEFEF")
            cell.receiverImageButtonOutlet.sd_setBackgroundImage(with: URL(string: senderData.receiver_thumb_image)!, for: .normal)
            if self.isTranslate{
                cell.transText("\(senderData.receiver_messages)", "\(senderData.receiver_messages_time)")
                DispatchQueue.main.async {
                    cell.transText("\(senderData.receiver_messages)", "\(senderData.receiver_messages_time)")
                }
               
             }
            else{
                cell.receiverMessageLabel.text = "\(senderData.receiver_messages)\n\(senderData.receiver_messages_time)"
                DispatchQueue.main.async {
                    cell.receiverMessageLabel.text = "\(senderData.receiver_messages)\n\(senderData.receiver_messages_time)"
                }
            }
            cell.receiverMessageLabel.attributedText =   MakentSupport().addAttributeFont(originalText: cell.receiverMessageLabel.text!, attributedText: senderData.receiver_messages_time, attributedFontName: Fonts.CIRCULAR_LIGHT, attributedColor: .black, attributedFontSize: 4)
            cell.receiverImageButtonOutlet?.layer.cornerRadius = (cell.receiverImageButtonOutlet?.frame.size.height)! / 2
            cell.receiverIndicatorImageView.transform = Language.getCurrentLanguage().getAffine
            cell.receiverImageButtonOutlet?.clipsToBounds = true
            cell.receiverMessageLabel?.layer.cornerRadius = 5
            cell.receiverMessageLabel?.clipsToBounds = true
            cell.receiverView?.layer.cornerRadius = 5
            cell.receiverView?.clipsToBounds = true
            cell.receiverImageButtonOutlet.addTarget(self, action: #selector(self.onReceiverProfileTapped), for: .touchUpInside)
            print("LABEL TEXT: \(cell.receiverMessageLabel.text ?? "EMPTYYYYY")")
            cell.layoutIfNeeded()
            return cell
        }
    }


    //MARK: MESSAGE DELEGATE METHODS
    func messageComposerSendMessageClicked(withMessage message: String!) {
        if message.isEmpty {
            return
        }
        self.composeView.messageTextView.resignFirstResponder()
        var dicts = JSONS()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["message"]   = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.removingPercentEncoding
        dicts["host_user_id"]   = ownerUserId
        dicts["message_type"]   = messageType
        dicts["space_id"]   =    carId
//        dicts["room_id"]   =    carId
        dicts["reservation_id"]   = reservationId
//        dicts["list_type"] = listType
        self.wsTosendMessageToHost(params: dicts)
    }

    func wsTosendMessageToHost(params: JSONS) {
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.METHOD_SEND_MESSAGE, paramDict: params, viewController: self, isToShowProgress: true, isToStopInteraction: false){ (responseDict) in
            if responseDict.statusCode == 1 {
                self.wsToGetMessageList(progress: false)
            }
        }
    }

    //MARK: MESSAGE VIEW DISPLAY
    func onShowMsgComposeView() {
        if self.composeView == nil {
            
            let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
            
            trnasLateBtn.setTitle("Translate To English", for: .normal)
            trnasLateBtn.backgroundColor = .white
            trnasLateBtn.setTitleColor(.gray, for: .normal)
            trnasLateBtn.addTap {
                if self.trnasLateBtn.titleLabel?.text == "Show Original text"{
                    self.isTranslate = false
                    self.trnasLateBtn.setTitle("Translate To English", for: .normal)
                    
                    self.chatHistoryTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.chatHistoryTableView.setContentOffset(.zero, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.chatHistoryTableView.reloadData()
                            self.chatHistoryTableView.layoutIfNeeded()
                        }
                    }
                    self.chatHistoryTableView.setContentOffset(.zero, animated: true)
                }else{
                    self.isTranslate = true
                    self.trnasLateBtn.setTitle("Show Original text", for: .normal)
                   // if self.val != ""{
                      
                   // }
                    self.chatHistoryTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.chatHistoryTableView.setContentOffset(.zero, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.chatHistoryTableView.reloadData()
                            self.chatHistoryTableView.layoutIfNeeded()
                        }
                    }
                    self.chatHistoryTableView.setContentOffset(.zero, animated: true)
                }
            }
//            self.composeView = MessageComposerView(frame: CGRect(x: CGFloat(0), y: CGFloat(470), width: CGFloat(self.view.frame.size.width), height: CGFloat(100)))
            self.composeView = MessageComposerView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(470), width: CGFloat(self.view.frame.size.width), height: CGFloat(100)), isRTL: Language.getCurrentLanguage().isRTL)
            self.composeView.delegate = self
            self.composeView.isRTL = Language.getCurrentLanguage().isRTL
            trnasLateBtn.frame = CGRect(x: CGFloat(0), y: 0, width: CGFloat(self.view.frame.size.width), height: CGFloat(25))
            self.composeView.placeHolderLabel.text = self.lang.write_Msg
            self.composeView.messagePlaceholder = self.lang.write_Msg
            self.composeView.messageTextView.placeTextHolder(holdVal: self.lang.write_Msg)
            self.composeView.placeHolderLabel.AlignText()
            self.composeView.messageTextView.textColor = UIColor.lightGray
            self.composeView.messageTextView.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            self.composeView.messageTextView.autocorrectionType = .default
            self.composeView.sendButton.setTitleColor(UIColor.appTitleColor.withAlphaComponent(0.5), for: .normal)
            self.composeView.sendButton.setTitle(self.lang.send_Title, for: .normal)
            
            tableViewBottomConstraint.constant = 10
//            self.chatHistoryTableView.tableFooterView = self.composeView
            if !(appDelegate.window?.subviews.contains(self.composeView))! {
                
                appDelegate.window!.addSubview(self.composeView)
                self.composeView.addSubview(trnasLateBtn)
                
            }
//            self.composeView.addSubview(trnasLateBtn)
//            self.composeView.bringSubviewToFront(trnasLateBtn)
            self.composeView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
            self.composeView.layer.borderWidth = 1.0;
            tableViewBottomConstraint.constant = 100
            //self.composeView.transform = self.getAffine
        }
    }

    func scrollToLastChat()
    {
        OperationQueue.main.addOperation {
            guard self.chatListArray.count > 0 else{return}
            let indexPath = IndexPath(row: self.chatListArray.count-1, section: 0)
            self.chatHistoryTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            self.chatHistoryTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.chatHistoryTableView.reloadData()
            }
            self.chatHistoryTableView.isHidden = false
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        if chatHistoryTableView.contentSize.height > chatHistoryTableView.frame.size.height - 130
        {
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

            //            print(self.chatHistoryTableView.contentOffset.y + keyboardFrame.size.height)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.chatHistoryTableView.setContentOffset(CGPoint(x: 0, y:(self.chatHistoryTableView.contentOffset.y - keyboardFrame.size.height)), animated:true)
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        if chatHistoryTableView.contentSize.height > chatHistoryTableView.frame.size.height - 130
        {
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.chatHistoryTableView.setContentOffset(CGPoint(x: 0, y: self.chatHistoryTableView.contentOffset.y + keyboardFrame.size.height), animated:true)
            })
        }
    }


    @objc func onSenderProfileTapped()
    {
        let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        viewProfile.strOtherUserId = Constants().GETVALUE(keyname: APPURL.USER_ID) as String
        viewProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewProfile, animated: true)

    }
    @objc func onReceiverProfileTapped()
    {
        
        if self.isDeletedUser {
            let viewEditProfile = DeletedUserVC.initWithStory()
                                    viewEditProfile.modalPresentationStyle = .fullScreen
                                    self.present(viewEditProfile, animated: true, completion: nil)
        } else {
            let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            viewProfile.strOtherUserId = ownerUserId.description
            viewProfile.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewProfile, animated: true)
        }
        

    }

    @IBAction func booknowButtonAction(_ sender: UIButton) {
       
        let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        contactView.sKey = ""
        contactView.strInstantBook = "Yes"
        contactView.Reser_ID    = reservationId.description
        let navController = UINavigationController(rootViewController: contactView)
        self.present(navController, animated:true, completion: nil)
    }

    //MARK API METHODS
    func wsToGetMessageList(progress:Bool) {
        var dicts = [String: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["reservation_id"]   = reservationId
        dicts["host_user_id"]   = ownerUserId

        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.METHOD_GET_CONVERSATION, paramDict: dicts, viewController: self, isToShowProgress: progress, isToStopInteraction: false) { (resonseDict) in
            if resonseDict.statusCode == 1 {
                print("message response",resonseDict)
                self.conversationChatModel = MakentSeparateParam().separateParamForConversationList(params: resonseDict)
                if self.conversationChatModel.chat.count > 0 {
                    self.chatListArray.removeAll()
                    self.chatListArray = self.conversationChatModel.chat
                }
                self.chatHistoryTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.chatHistoryTableView.reloadData()
                    self.chatHistoryTableView.scrollToBottom()
                }
                self.scrollToLastChat()
                
            } else {
                Utilities.sharedInstance.createToastMessage(resonseDict.statusMessage, isSuccess: false, viewController: self)
            }

//            responseJSON = resonseDict
        }
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class SenderMessageTVC: UITableViewCell {
    @IBOutlet weak var senderView:UIView!
    @IBOutlet weak var senderMessageLabel: UILabel!
    @IBOutlet weak var senderIndicatorImageView: UIImageView!
    @IBOutlet weak var senderImageButtonOutlet: UIButton!
    
    
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func transText(_ text : String, _ time : String){

         let languageId = NaturalLanguage.naturalLanguage().languageIdentification()
         languageId.identifyPossibleLanguages(for: text) { (identifiedLanguages, error) in             if let error = error {
//                    print("Failed with error: \(error)")
                    self.senderMessageLabel.text = "\(text)\n\(time)"
                    return
                }
            guard let identifiedLanguages = identifiedLanguages,                 !identifiedLanguages.isEmpty, identifiedLanguages[0].languageCode != "und"
                else {
//                    print("No language was identified")
                    self.senderMessageLabel.text = "\(text)\n\(time)"
                    return
            }
            if identifiedLanguages[0].languageCode != ""{
               // DispatchQueue.main.async {
                
                let options = TranslatorOptions(sourceLanguage: .fromLanguageCode(identifiedLanguages[0].languageCode), targetLanguage: .en)
                let TamilEnglishTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
                let conditions = ModelDownloadConditions(allowsCellularAccess: false ,allowsBackgroundDownloading: true)
                TamilEnglishTranslator.downloadModelIfNeeded(with: conditions) { (error) in
                    guard error == nil else {
                        self.senderMessageLabel.text = "\(text)\n\(time)"
                        return
                    }
                }

                TamilEnglishTranslator.translate(text) { translatedText, error in
                    guard error == nil, let translatedText = translatedText else { return }
                    print("Text:",translatedText)
                    if translatedText.count > 0 {
                        self.senderMessageLabel.text = "\(translatedText)\n\(time)"
                    }
                    else {
                        self.senderMessageLabel.text = "\(text)\n\(time)"
                    }
                    
                   // Translation succeeded.
                    }
            }
//            print("Identified Languages:\n",identifiedLanguages.map({$0.languageCode}))
            print("TRANSLATED TEXT FOR SENDER: \(self.senderMessageLabel.text ?? "NONEEEEEE")")
        }
    }
    
}
class ReceiverMessageTVC: UITableViewCell {
    @IBOutlet weak var receiverMessageLabel: UILabel!
    @IBOutlet weak var receiverIndicatorImageView: UIImageView!
    @IBOutlet weak var receiverImageButtonOutlet: UIButton!
    @IBOutlet weak var receiverView:UIView!
    
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func transText(_ text : String, _ time : String){

         let languageId = NaturalLanguage.naturalLanguage().languageIdentification()
         languageId.identifyPossibleLanguages(for: text) { (identifiedLanguages, error) in             if let error = error {
//                    print("Failed with error: \(error)")
                    self.receiverMessageLabel.text = "\(text)\n\(time)"
                    return
                }
            guard let identifiedLanguages = identifiedLanguages,                 !identifiedLanguages.isEmpty, identifiedLanguages[0].languageCode != "und"
                else {
//                    print("No language was identified")
                    self.receiverMessageLabel.text = "\(text)\n\(time)"
                    return
            }
            if identifiedLanguages[0].languageCode != ""{
               // DispatchQueue.main.async {
                
//                print("senderTerxt:",text)
                let options = TranslatorOptions(sourceLanguage: .fromLanguageCode(identifiedLanguages[0].languageCode), targetLanguage: .en)
                let TamilEnglishTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
                let conditions = ModelDownloadConditions(allowsCellularAccess: false ,allowsBackgroundDownloading: true)
                TamilEnglishTranslator.downloadModelIfNeeded(with: conditions) { (error) in
                    guard error == nil else {
                        self.receiverMessageLabel.text = "\(text)\n\(time)"
                        return
                    }
                }

                TamilEnglishTranslator.translate(text) { translatedText, error in
                    guard error == nil, let translatedText = translatedText else { return }
//                    print("Text:",translatedText)
                    self.receiverMessageLabel.text = "\(translatedText)\n\(time)"
                   // Translation succeeded.
                    }
            }
//            print("Identified Languages:\n",identifiedLanguages.map({$0.languageCode}))
            print("TRANSLATED TEXT FOR RECEIVER: \(self.receiverMessageLabel.text ?? "NONEEEEEE")")
        }
    }
}

//extension ChatViewController:CompleteBookingDelegate
//{
//    func onCompleteBooking(bookingType: String, paymentMode: String, payKey: String)
//    {
//
//        print("onStartToBooking")
//        let country = userDefaults.object(forKey: "countryname")
//        let countryCode = userDefaults.object(forKey: "countrycode")
//        print("selected country",country)
//        print("selected countryCode",countryCode)
//        var dicts = [String: Any]()
//        dicts["token"]          = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//        dicts["s_key"]          = self.baseBookingModel.reservationID
//        dicts["paymode"]        = paymentMode
//        dicts["message"]        = "Testing"
//        dicts["pay_key"]        = payKey
//        dicts["country"]        = countryCode
//        dicts["currency_code"]  = ""
//        dicts["booking_type"]   = bookingType
//
//        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "complete_booking", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false)
//        {
//            (responseDict) in
//            if responseDict.string("status_code") == "1"
//            {
//                self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
//                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
//                self.navigationController?.popToRootViewController(animated: true)
//               // self.dismiss(animated: true, completion: nil)
//            }
//            else
//            {
//                self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
//            }
//        }
//
//    }
//
//}


extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

//    override func scrollToTop() {
//
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: 0, section: 0)
//            self.scrollToRow(at: indexPath, at: .top, animated: false)
//        }
//    }
}
