//
//  EventViewController.swift
//  Makent
//
//  Created by trioangle on 14/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import UserNotifications
import Stripe

protocol DateselectionProtocal {
    func setCheckInOutDate(checkInTime :String, checkOutTime: String)
}

class EventViewController: UIViewController,DateselectionProtocal {
    
    @IBOutlet weak var eventTypeParentView: UIView!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventActivityCollectionView: UICollectionView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var checkInTime: UILabel!
    @IBOutlet weak var checkOutTime: UILabel!
    
    @IBOutlet weak var eventBottomView: UIView!
    @IBOutlet weak var pricePerNight: UILabel!
    @IBOutlet weak var requestBook: UILabel!
    var headerTitleArray = [EventSpaceActivityData]()
    var token = ""
    
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var maximunGuestCount: UILabel!
    @IBOutlet weak var subActivityValues: UILabel!
    @IBOutlet weak var guestCountTextFiled: UITextField!
    
    @IBOutlet weak var contactHostHeaderStackView: UIStackView!
    @IBOutlet weak var headerStackHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contachHostHeaderView: UIView!
    @IBOutlet weak var listNameLbl: UILabel!
    @IBOutlet weak var listTypeLbl: UILabel!
    
    @IBOutlet weak var hostPicImageView: UIImageView!
    @IBOutlet weak var hostNameLbl: UILabel!
    
    @IBOutlet weak var writeMessageStackView: UIStackView!
    
    @IBOutlet weak var messageHostView: UIView!
    @IBOutlet weak var writeMsgTxtViewParentView: UIView!
    @IBOutlet weak var writeMsgTxtViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var writeMsgTxtView: KMPlaceholderTextView!
    @IBOutlet weak var writeMsgTitleLbl: UILabel!
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var spaceDetails : SpaceDetailData!
    var isSubActivityChecked = Bool()
    
    var collectionSelectedIndex = Int()
    var selectedSubActivityValues : String!
    var isFromContactHost = Bool()
    /// dates
    var srtDate = String()
    var srtTime = String()
    var endDate = String()
    var endTime = String()
    
    var activityType = Int()
    var activity     = Int()
    var subActivity  =  Int()
    var spaceID: String!
    var modelEventDetails = [EventSpaceActivityData]()
    var selectedEventDetails = [Activity]()
    open var arrBlockedDates = [String]()
    open var notAvailableDays = [String]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    func setCheckInOutDate(checkInTime: String, checkOutTime: String)
    {
        print("Check In Time",checkInTime, "Check Out Time", checkOutTime)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Initilize the tableview
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        activityTableView.delegate = self
        activityTableView.dataSource = self
        
        eventActivityCollectionView.delegate = self
        eventActivityCollectionView.dataSource = self
       
        self.addBackButton()
        self.initView()
          wsToGetSpaceActivity()
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeDetails(notification:)), name: NSNotification.Name(rawValue: "DateTimeDetails"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableFooterView = self.view.getViewExactHeight(view: self.tableFooterView)
        self.tableHeaderView =  self.view.getViewExactHeight(view: self.tableHeaderView)
    }
    func initView() {
        
        self.activityTableView.tableHeaderView = self.tableHeaderView
        self.activityTableView.tableFooterView = self.tableFooterView
        
        self.checkContactHostPage()
        
        guestCountTextFiled.delegate  = self
        guestCountTextFiled.keyboardType = .numberPad
        guestCountTextFiled.leftViewMode = .always
        guestCountTextFiled.tintColor  = UIColor.appGuestThemeColor
        /// Add the corner to label
        checkOutTime.appGuestTextColor()
        self.borderView(subView: self.writeMsgTxtViewParentView)
        self.borderView(subView: guestCountTextFiled)
        self.borderView(subView: eventBottomView)
        requestBook.addPinkThemeColorBG()
         self.addGestureLbls()
         maximunGuestCount.text = "\(self.lang.guestTitle)\(" ")\("(")\(self.lang.maximumGuestTitle)\(" ")\(self.spaceDetails.maximumGuest)\(")")"
        
        checkInTime.text! = self.lang.check_inTitle
        checkInTime.appGuestTextColor()
        checkOutTime.text! = self.lang.check_outTitle
        if Language.getCurrentLanguage().isRTL {
            activityTableView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            self.activityTableView.contentOffset = CGPoint(x: self.activityTableView.contentSize.width - self.activityTableView.contentOffset.x - self.activityTableView.bounds.size.width,
                                                                y: self.activityTableView.contentOffset.y);
        } else {
            activityTableView.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        }
        
    }
    
    func borderView(subView:UIView){
        subView.border(1.0, .lightGray)
        subView.elevate(1.3)
    }
    
    func checkContactHostPage() {
        if self.isFromContactHost {
            
            self.contactHostHeaderStackView.isHidden = false
            self.contachHostHeaderView.isHidden = false
            self.writeMessageStackView.isHidden = false
            self.writeMsgTxtView.isHidden = false
            self.writeMsgTitleLbl.isHidden = false
            
            self.listTypeLbl.text = self.spaceDetails.theSpace.first?.name
            self.listNameLbl.text = self.spaceDetails.name
            self.hostNameLbl.text = "\(self.lang.hostedby_Title) \(self.spaceDetails.hostName)"
            self.hostNameLbl.attributedText = MakentSupport().addAttributeText(originalText: self.hostNameLbl.text ?? "", attributedText: self.spaceDetails.hostName, attributedColor: .appGuestThemeColor)
            self.hostNameLbl.addTap {
                let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
                viewProfile.strOtherUserId = String(describing: self.spaceDetails.userId)
                viewProfile.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewProfile, animated: true)
            }
            self.hostPicImageView.addTap {
                let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
                viewProfile.strOtherUserId = String(describing: self.spaceDetails.userId)
                viewProfile.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewProfile, animated: true)
            }
            self.hostPicImageView.addRemoteImage(imageURL: self.spaceDetails.hostProfilePic, placeHolderURL: "", isRound: true)
            
            self.writeMsgTitleLbl.text = self.lang.write_Msg
            self.writeMsgTxtView.placeholder = self.lang.write_Mess
            
            self.messageHostView.isHidden = false
            self.headerStackHeightConstraint.constant = self.contactHostHeaderStackView.intrinsicContentSize.height
            self.requestBook.text = self.lang.send_Title
            
        }else {
            
            self.contactHostHeaderStackView.isHidden = true
            self.contachHostHeaderView.isHidden = true

            self.writeMessageStackView.isHidden = true
            self.writeMsgTxtView.isHidden = true
            self.writeMsgTitleLbl.isHidden = true
            self.headerStackHeightConstraint.constant = 0
            self.writeMsgTxtViewHeightConstraint.constant = 0
            self.messageHostView.isHidden = true
            if self.spaceDetails.instantBook == "Yes"
            {
                self.requestBook.text = self.lang.instant_book
            }
            else
            {
                self.requestBook.text = self.lang.request_book
            }
        }
    }
    
    func addGestureLbls() {
        let checkInTimeTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openCalendar))
        checkInTimeTap.cancelsTouchesInView = false
        self.checkInTime.isUserInteractionEnabled = true
        self.checkInTime.addGestureRecognizer(checkInTimeTap)
        
        let checkOutTimeTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openCalendar))
        checkOutTimeTap.cancelsTouchesInView = false
        self.checkOutTime.isUserInteractionEnabled = true
        self.checkOutTime.addGestureRecognizer(checkOutTimeTap)
        
        let requestTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.requestToBookAction))
        requestTap.cancelsTouchesInView = false
        self.requestBook.isUserInteractionEnabled = true
        self.requestBook.addGestureRecognizer(requestTap)
    }
    
    // handle notification
    @objc func timeDetails(notification: NSNotification) {
        print("Notification center")
        if let jsons = notification.userInfo as? JSONS{
            srtDate = jsons.string("startDate")
            endDate = jsons.string("endDate")
            srtTime = jsons.string("startTime")
            endTime  = jsons.string("endTime")
        }
        print("End time",endTime)
        print("startDate",srtDate,"endDate",endDate)
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-d"
        let showDate = inputFormatter.date(from: srtDate)
        inputFormatter.dateFormat = "EEE d-MM-yyyy"
        let resultStartDate = inputFormatter.string(from: showDate!)
        print("resulting",resultStartDate)
        
        let inputFormatter1 = DateFormatter()
        inputFormatter1.dateFormat = "yyyy-MM-d"
        let showEndDate = inputFormatter1.date(from: endDate)
        inputFormatter1.dateFormat = "EEE d-MM-yyyy"
        let resultEndDate = inputFormatter1.string(from: showEndDate!)
        print("resulting",resultEndDate)
        
//        self.checkInTime.text = "\(self.lang.checkin_Title)\n\(self.lang.checkin_Title)"
//        self.checkOutTime.text = "\(self.lang.checkout_Title)\n\(self.lang.checkin_Title)"
//        self.checkInTime.text = "\(self.lang.checkin_Title)\n\(String(describing: notification.userInfo?["startDate"]))"
//        self.checkOutTime.text = "\(self.lang.checkin_Title)\n\(String(describing: notification.userInfo?["endDate"]))"
        self.checkInTime.text = "\(resultStartDate)\n\(srtTime)"
        self.checkOutTime.text = "\(resultEndDate)\n\(endTime)"
       // print("start Date",notification.userInfo?["startDate"],"End Date",notification.userInfo?["endDate"])
    }
  
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        print("Single item clicked")
    }
    
    @objc func openCalendar(_ sender: UITapGestureRecognizer)
    {
        showCalander()
    }
    
    @objc func requestToBookAction(_ sender: UITapGestureRecognizer)
    {
        print("subActivityValues...",self.subActivityValues.text!)
        if subActivityValues.text!.isEmpty
        {
            self.appDelegate.createToastMessage(self.lang.choose_Activity, isSuccess: false)
        }
        else if checkInTime.text! == self.lang.check_inTitle
        {
          self.appDelegate.createToastMessage(self.lang.choose_Dates, isSuccess: false)
        }
        else if self.guestCountTextFiled.text!.isEmpty
        {
            self.appDelegate.createToastMessage(self.lang.pleaseEnterGuestCount, isSuccess: false)
        }
        else if (self.spaceDetails.maximumGuest as NSString).intValue < (self.guestCountTextFiled.text! as NSString).intValue
        {
       self.appDelegate.createToastMessage("\(self.lang.maximum_guestcount)\(" ")\(self.spaceDetails.maximumGuest)", isSuccess: false)
        }
        else
        {
            if token != ""
            {
               self.wsToRequestToBook()
            }
            else
            {
                let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                mainPage.hidesBottomBarWhenPushed = true
                self.appDelegate.lastPageMaintain = "trips"
                let naviation = UINavigationController(rootViewController: mainPage)
                naviation.modalPresentationStyle = .fullScreen
                self.present(naviation, animated: false, completion: nil)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guestCountTextFiled.resignFirstResponder()
        return true
    }

    
    /// opne the calender
    func showCalander()
    {
        // check the calender dates
        print("Checkavailability")
        let selector = k_MakentStoryboard.instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector
        selector.room_Id = self.spaceDetails.spaceId.description
        selector.RoomDetailData = self.spaceDetails
        if self.arrBlockedDates.count > 0 {
            selector.arrBlockedDates.append(contentsOf: self.arrBlockedDates)
            //(from: self.arrBlockedDates as [Any])
        }
        if self.notAvailableDays.count > 0 {
            selector.notAvailableDays.append(contentsOf: self.notAvailableDays)
        }
        let blockedDates = CalenderHelperForBlockedDates.instance
        blockedDates.setDateRangeYear(rangeYear: 5)
        let blockedModel = self.spaceDetails.availabilityTimes.filter({$0.status.capitalized == "Closed"})
       let newUpdatedBlockedDates =  blockedDates.getAllDays(selectedDates: blockedModel.map({$0.id}))
//        dd-MM-yyy
//        let calendar = Calendar.current
//        let date = Date()
        // let april13Date = calendar.date(from: april13Components)!
        
        // Get the current date components for year, month, weekday and weekday ordinal
     
//
//        for i in 0..<self.RoomDetails.availabilityTimes.count
//        {
//            if (self.RoomDetails.availabilityTimes[i].status == "Closed")
//            {
//                let dayType = self.RoomDetails.availabilityTimes[i].dayType
//                selector.arrBlockedDates.addObjects(from:dayType)
//            }
//            print("Status",self.RoomDetails.availabilityTimes[i].status)
//            print("DayType",self.RoomDetails.availabilityTimes[i].dayType)
//        }
        //        self.present(selector, animated: true, completion: nil)
//      selector.delegate = self
        selector.optionSelectionType = .range
        let navController = UINavigationController(rootViewController: selector)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    func wsToGetSpaceActivity() {
        print("Called the space activity webservice",spaceID)
            var paramDict = [String:Any]()
            paramDict["token"]     = SharedVariables.sharedInstance.userToken
            paramDict["space_id"]  = spaceID
            
            WebServiceHandler.sharedInstance.getToWebService(wsMethod: "space_activities", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
                print(responseDict)
                print("Status Code",responseDict.string("status_code"))
                print("Success Message",responseDict.string("success_message"))
                print("activity type",responseDict.array("activity_types"))
                // This is called single object array
               // let model = EventSpaceActivityData(ActivityJson: responseDict.array("activity_types")[0])
                responseDict.array("activity_types").forEach({ (tempJSON) in
                    let model = EventSpaceActivityData(ActivityJson: tempJSON)
                    print("Activities...",model.activities)
                    self.modelEventDetails.append(model)
                })
//                if self.modelEventDetails.count > 0 {
//                     self.eventActivityCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
//                }
                self.eventActivityCollectionView.reloadData()
               
                self.selectedEventDetails = self.modelEventDetails.first!.activities
                self.activityTableView.reloadData()
               
                self.activityType = self.modelEventDetails.first?.id ?? 0
                self.activity = self.modelEventDetails.first?.activities.first?.id ?? 0
                self.pricePerNight.text = "\(self.modelEventDetails[0].currencySymbol)\(self.modelEventDetails[0].hourly) \(self.lang.per_Hours)"
                
        }
    }
    
    func wsToRequestToBook() {
        print("Request to book")
        var paramDict = [String:Any]()
        var eventType = [String:Any]()
        eventType["activity_type"]  = self.activityType
        eventType["activity"]  = self.activity
        eventType["sub_activity"]  = self.subActivity

        print("srtDate",self.srtDate)
        print("selected activyt",self.activityType,self.activity,self.subActivity)
        
        var bookingDate = [String:Any]()
        bookingDate["start_date"]  = self.srtDate
        bookingDate["start_time"]  = timeConvertions(self.srtTime)
        bookingDate["end_date"]    = self.endDate
        bookingDate["end_time"]    = timeConvertions(self.endTime)
    
        paramDict["token"]  = SharedVariables.sharedInstance.userToken
        paramDict["space_id"]     = spaceID
        paramDict["event_type"]  = self.sharedUtility.getJsonFormattedString(eventType)
        paramDict["number_of_guests"]  = self.guestCountTextFiled.text!
        paramDict["booking_date_times"]  = self.sharedUtility.getJsonFormattedString(bookingDate)
        if self.isFromContactHost {
            paramDict["message"] = self.writeMsgTxtView.text
            self.wsTocontactRequestToHost(param: paramDict)
            return
        }
        paramDict["booking_type"]  = self.spaceDetails.instantBook == "No" ? "request_book" : "instant_book"
        paramDict["special_offer_id"]  = ""
        paramDict["reservation_id"]  = ""
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "store_payment_data", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            print(responseDict)
            print("Status Code",responseDict.string("status_code"))
            if responseDict.string("status_code") == "1"
            {
                let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
                contactView.sKey = responseDict.string("s_key")
                contactView.strInstantBook = self.spaceDetails.instantBook
                contactView.Reser_ID  = ""
                let navController = UINavigationController(rootViewController: contactView)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                 self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
            }
        }
    }
    
    func wsTocontactRequestToHost(param:JSONS) {
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "contact_request", paramDict: param, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            if responseDict.isSuccess {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
                self.navigationController?.popViewController(animated: true)
            }else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
            }
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
    
    func timeConvertions (_ time : String) -> String
    {
       // let dateAsString = "6:35 PM"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let date24 = dateFormatter.string(from: date!)
        
        return date24
    }
    func onCalendarTapped(sender:UITapGestureRecognizer) {
        print("tap working")
    }
}

//MARK: CALENDAR DELEGATE
extension EventViewController : UITextFieldDelegate,WWCalendarTimeSelectorProtocol
{
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyy"
        
        dates.forEach { (temp) in
            let str = dateFormat.string(from: temp)
            if let newDate = dateFormat.date(from: str) {
                self.sharedVariable.multipleDates.append(newDate)
            }
        }
        let eventView     = k_MakentStoryboard.instantiateViewController(withIdentifier: "ChooseTimingVC") as! ChooseTimingViewController
        if let availableTimes = sharedVariable.availableTimes {
              eventView.availableTimes = availableTimes
        }
      
        eventView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(eventView, animated: true)
//        forEach({self.sharedVariable.multipleDates.append(dateFormat.string(from: $0))})
    }
}
// MARK: SHARE BUTTON ACTION
extension EventViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ActivityTableCell = self.activityTableView.dequeueReusableCell(withIdentifier: "ActivityCellID") as! ActivityTableCell
//        let model = self.modelEventDetails[indexPath.section].activities[indexPath.section].subActivityTypes[indexPath.row]
    //    print("Model name",model.name)
        let model = self.selectedEventDetails[indexPath.section].subActivityTypes[indexPath.row]
        cell.subActivityName.text = model.name
        
            if model.isSelected {
                // cell.activityCheckImg.image = UIImage(named: "black-check-box-with-white-check")
               cell.activityCheckImg.image = self.checkBox.instance.first
            }
            else
            {
               // cell.activityCheckImg.image = UIImage(named: "check-box-empty")
                cell.activityCheckImg.image = self.checkBox.instance.last
            }
        
        cell.activityCheckImg.tintColor = k_AppThemePinkColor
        return cell
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: self.activityTableView.frame.width, height: 30))
        let imageView = UIImageView()
        let label = UILabel()
        if self.selectedEventDetails[section].isSelected {
            imageView.image = self.checkBox.instance.first
        }else {
            imageView.image = self.checkBox.instance.last
        }
        imageView.tintColor = UIColor.appHostThemeColor
        if Language.getCurrentLanguage().isRTL {
            imageView.frame = CGRect(x: self.activityTableView.frame.width-30, y: 0, width: 25, height: 25)
            label.frame = CGRect(x:self.activityTableView.frame.width-30, y: 0, width: self.activityTableView.frame.width, height:30)
            label.frame.origin.x = -45
        } else {
            imageView.frame = CGRect(x: 10, y: 0, width: 25, height: 25)
            label.frame = CGRect(x:10, y: 0, width: self.activityTableView.frame.width, height:30)
            label.frame.origin.x = 45
        }
       
        
        label.text = self.selectedEventDetails[section].name
        label.textColor = .black
        if self.selectedEventDetails[section].subActivityTypes.isEmpty {
            headerview.addSubview(imageView)
        } else {
            if Language.getCurrentLanguage().isRTL {
                imageView.frame = CGRect(x: self.activityTableView.frame.width-30, y: 0, width: 25, height: 25)
                label.frame = CGRect(x:self.activityTableView.frame.width-30, y: 0, width: self.activityTableView.frame.width, height:30)
                label.frame.origin.x = -10
            } else {
                imageView.frame = CGRect(x: 10, y: 0, width: 25, height: 25)
                label.frame = CGRect(x:10, y: 0, width: self.activityTableView.frame.width, height:30)
                label.frame.origin.x = 10
            }
        }
        
        headerview.addSubview(label)
        
        label.center.y = headerview.center.y
        imageView.center.y = label.center.y
        headerview.addTap {
            
            let tempModel = self.selectedEventDetails[section].copy() as! Activity
            if !tempModel.isSelected {
                tempModel.isSelected = true
                if self.selectedEventDetails[section].subActivityTypes.isEmpty {
                    self.updateBottomText(tempModel.name, id: tempModel.id)
                }
            }else {
                tempModel.isSelected = false
                self.updateBottomText("", id: 0)
            }
            let selected = tempModel.isSelected
            self.setAllUnSelected()
            tempModel.isSelected = selected
           
//            self.selectedEventDetails.forEach({ (temp) in
//                if temp.id == tempModel.id {
//                    temp.isSelected = tempModel.isSelected
//                }else {
//                    temp.isSelected = false
//                }
//            })
//            self.selected
            self.selectedEventDetails[section] = tempModel
            UIView.performWithoutAnimation {
                 self.activityTableView.reloadSections(IndexSet(integer: section), with: .none)
            }
           
        }
        headerview.tag = section
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = self.selectedEventDetails[indexPath.section].subActivityTypes[indexPath.row]
        let oldSelected = model
        let selected = oldSelected.isSelected
        let mainModel = self.selectedEventDetails[indexPath.section]
        self.setAllUnSelected()
        mainModel.subActivityTypes.forEach { (tempModel) in
            if tempModel.id == oldSelected.id {
                if !selected {
                    tempModel.isSelected = true
                    self.updateBottomText(model.name, id: model.id)
                }else {
                    tempModel.isSelected = false
                     self.updateBottomText("", id: 0)
                }
            }else {
                tempModel.isSelected = false
            }
        }
        self.activityTableView.reloadData()
    }
    
    func updateBottomText(_ text:String,id:Int) {
        self.subActivityValues.text = text
        self.subActivity = id
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // return 1
        print("selectedEventDetails...",self.selectedEventDetails.count)
       if self.selectedEventDetails != nil
        {
            return self.selectedEventDetails.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return 10
        return self.selectedEventDetails[section].subActivityTypes.count
    }
}



/// For collection view
extension EventViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      // return  10
//        if self.modelEventDetails != nil
//        {
            return self.modelEventDetails.count
//        }
//        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print("Feature Collectionview cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCVCID", for: indexPath) as! ActivityCollectionView
        if collectionSelectedIndex != nil
        {
            if collectionSelectedIndex == indexPath.row
            {
                cell.activity.layer.backgroundColor  = k_AppThemePinkColor.cgColor as! CGColor
            }
            else
            {
                cell.activity.layer.backgroundColor  = UIColor.lightGray.cgColor as! CGColor
            }
        }
        
         cell.activity.layer.cornerRadius = 20
         cell.activity.text = self.modelEventDetails[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedEventDetails = self.modelEventDetails[indexPath.row].activities
        self.activity = selectedEventDetails.first?.id ?? 0
//         selectedEventDetails.forEach({$0.subActivityTypes.map({$0.isSelected = false})})
        self.setAllUnSelected()
        self.activityType = self.modelEventDetails[indexPath.row].id
        self.collectionSelectedIndex = indexPath.row
        self.eventActivityCollectionView.reloadData()
        self.updateBottomText("", id: 0)
        print("Price values")
        self.pricePerNight.text = "\(self.modelEventDetails[indexPath.row].currencySymbol)\(self.modelEventDetails[indexPath.row].hourly)\(self.lang.per_Hours)"
        print("Activity Count",self.modelEventDetails[indexPath.row].hourly)
        self.activityTableView.reloadData()
    }
    
    func setAllUnSelected(){
        self.modelEventDetails.forEach({$0.activities.forEach({$0.isSelected = false;$0.subActivityTypes.map({$0.isSelected = false})})})
        self.activityTableView.reloadData()
    }
}

class ActivityTableCell: UITableViewCell
{
    @IBOutlet weak var subActivityName: UILabel!
    
    @IBOutlet weak var activityCheckImg: UIImageView!
}

class ActivityCollectionView : UICollectionViewCell
{
    @IBOutlet weak var activity: UILabel!
}


extension UILabel {
    func addPinkThemeColorBG(corner:CGFloat = 5) {
        self.layer.backgroundColor  = k_AppThemePinkColor.cgColor
        self.layer.cornerRadius = corner
        
        self.textColor = .white
    }
}

extension UIView {
    func getViewExactHeight(view:UIView)->UIView {
       
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        if height != frame.size.height {
            frame.size.height = height
            view.frame = frame
        }
        return view
    }
}
