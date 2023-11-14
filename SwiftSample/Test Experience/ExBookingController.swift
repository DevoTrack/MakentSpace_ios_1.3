//
//  ExBookingController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/27/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit
import MessageUI
import Social
import Alamofire


class ExBookingController : UIViewController,UITableViewDelegate, UITableViewDataSource, WWCalendarTimeSelectorProtocol, AddGuestDelegate,HouseRulesAgreeDelegate,AddMessageDelegate,ViewOfflineDelegate
{

    @IBOutlet var tableFilter: UITableView!
    @IBOutlet var imgHostedUser: UIImageView!
    @IBOutlet var lblHouse: UILabel!
    @IBOutlet var lblHostedByUser: UILabel?
    @IBOutlet var lblHotelName: UILabel!
    @IBOutlet var lblRoomDetails: UILabel!
    @IBOutlet var lblOtherDetail: UILabel!
    @IBOutlet var lblSeparatorOne: UILabel!
    @IBOutlet var lblSeparatorTwo: UILabel!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var tblFooderView: UIView!
    @IBOutlet var btnBookNow: UIButton?
    @IBOutlet var viewTopHolder: UIView!

    var strStartDate:String = ""
    var strEndDate:String = ""
    var strRoomID:Int = 0
    var strTotalGuest:String = ""
    var strRoomName:String = ""
    var strLocationName:String = ""
    var house_rules:String = ""
    var modelPaymentDetails : ExPrepaymentResponse!
    var nStepsLeft : Int = 1
    var strAboutHome:String = ""
    var strHostUserId:String = ""
    var strBookDetail:String = ""
    var strLengthDetail:String = ""

    var strInstantBook:String = ""

    var  userDefaults = UserDefaults.standard

    var strHostMessage:String = ""

    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var instantBookSelected:Bool = false
    var isFirstTime:Bool = true


    var arrPrice = [String]()
    var arrPirceDesc = [String]()

    var arrBlockedDates = [String]()

    fileprivate var singleDate: Date = Date()
    var multipleDates: [Date] = []
    var selectedCountry = ""
    var handPickedGuests:[Guest] = []
    var availablityModel:CheckDateAvailablity!
    var datePicked: String!
    var experienceDetails:ExperienceRoomDetails?
    @IBOutlet var animatedImageView: FLAnimatedImageView?
    let Lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userDefaults.set("", forKey: "paymenttype")
        userDefaults.set("", forKey: "hostmessage")
        userDefaults.synchronize()

        let height = MakentSupport().onGetStringHeight(lblHotelName.frame.size.width, strContent: lblHotelName.text! as NSString, font: (lblHotelName.font)!)

        var rectLblDetails = lblHotelName.frame
        rectLblDetails.size.height = height+5
        lblHotelName.frame = rectLblDetails

        var rectHeaderView = tblHeaderView.frame
        rectHeaderView.size.height = tblHeaderView.frame.size.height + (height - 40)
        tblHeaderView.frame = rectHeaderView

        self.navigationController?.isNavigationBarHidden = true
        tblFooderView.isHidden = true
        MakentSupport().setDotLoader(animatedLoader: animatedImageView!)
        btnBookNow?.setTitle(String(format:"%d \(Lang.steps_LeftTitle)",nStepsLeft), for: .normal)
        lblSeparatorOne.isHidden = true
        lblSeparatorTwo.isHidden = true
//        lblHotelName.textAlignment = Lang.getTextAlignment(align: .right)
        lblHotelName.text = strRoomName
        self.getPrePaymentInfo()
        tableFilter.tableHeaderView = tblHeaderView
        imgHostedUser.layer.cornerRadius = imgHostedUser.frame.size.height/2
        imgHostedUser.clipsToBounds = true
        btnBookNow?.appHostSideBtnBG()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let  userDefaults = UserDefaults.standard
        let countrys = userDefaults.object(forKey: "countryname") as? NSString
        if (countrys != nil && countrys != "")
        {
            selectedCountry =  countrys?.trimmingCharacters(in: .whitespaces) ?? ""//YSSupport.escapedValue(countrys! as String)
        }
        else{
            let us = "United States"
            selectedCountry = us.trimmingCharacters(in: .whitespaces) //YSSupport.escapedValue(("UnitedStates"))
        }
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.getPrePaymentInfo()
    }

    // MARK: CURRENCY API CALL
    /*
     */
    
    
    func getPrePaymentInfo()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        self.animatedImageView?.isHidden = false
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["host_experience_id"] = strRoomID
        dicts["scheduled_id"] = availablityModel.scheduledId
//        let arrayOfGuestDictionary = handPickedGuests.map{$0.toDictionary}
//        dicts["guest_details"] = handPickedGuests as! [[String:String]]
//        print(handPickedGuests.count)
//        var arrayDict = [String]()
//        var jsonParamString = String()
//        var jsonParamDict = [String:Any]()
//        for index in handPickedGuests {
//            let dictArray = index.toJSONtoD
//            var jsonData :Data!
//            do {
//                if #available(iOS 11.0, *) {
//                     jsonData = try JSONSerialization.data(withJSONObject: dictArray, options: .sortedKeys)
//                } else {
//                    // Fallback on earlier versions
//                }
//                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                if let dictFromJSON = decoded as? [String:Any] {
//                    // use dictFromJSON
//                    print(dictFromJSON)
//                    jsonParamString = "\(decoded)"
//                    jsonParamDict = decoded as! [String : Any]
//
//                }
//                do {
//                    let data1 =  try JSONSerialization.data(withJSONObject: decoded, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//                    jsonParamString = String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
//                    print(jsonParamString)
//                } catch let myJSONError {
//                    print(myJSONError)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//            let test = String(jsonParamString.filter { !" \n\t\r".contains($0) })
//            print(test)
//            arrayDict.append(test)
//        }
//        dicts["guest_details"] = String(describing: arrayDict)
        
        
        
        
        
        
//        let test = String(jsonParamString.filter { !" \n\t\r".contains($0) })
        
//        print(handPickedGuests.map{$0.toDictionary})
        dicts["date"] = datePicked

        var str = "["
        
        handPickedGuests.forEach { (guest) in
            str += "{"
            guest.toDictionary.forEach({ (key,value) in
                str += "\"\(key)\":\"\(value)\","
            })
            str.remove(at: str.index(before: str.endIndex))
            str += "},"
        }
        str.remove(at: str.index(before: str.endIndex))
        str += "]"
        print(str)
        
       dicts["guest_details"] = str
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_EXPERIENCE_PRE_PAYMENT as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let preModel = response as! ExPrepaymentResponse
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                if preModel.statusCode == "1"{
                    self.modelPaymentDetails = preModel
                    if self.isFirstTime{
                        self.setupHeaderinfo()
                        self.isFirstTime = false
                    }
                    self.tableFilter.reloadData()
                }else{
                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: preModel.successMessage as! String)
                    if preModel.successMessage == "token_invalid" || preModel.successMessage == "user_not_found" || preModel.successMessage == "Authentication Failed"{
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.animatedImageView?.isHidden = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedImageView?.isHidden = true
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.Lang.network_ErrorIssue)
            }
        })
    }

    func setupHeaderinfo()
    {
        if modelPaymentDetails != nil
        {
            lblSeparatorOne.isHidden = true
            lblSeparatorTwo.isHidden = false

//            lblHouse.text = modelPaymentDetails.room_type as String
            lblHotelName.text = modelPaymentDetails.paymentData?.hostExperienceName as! String
            lblHotelName.sizeToFit()
            lblSeparatorOne.frame = CGRect(x: lblSeparatorOne.frame.origin.x, y: lblHotelName.frame.maxY + 4, width: lblSeparatorOne.frame.width, height: lblSeparatorOne.frame.height)
            lblHostedByUser!.frame = CGRect(x: lblHostedByUser!.frame.origin.x, y: lblHostedByUser!.frame.origin.y + 8, width: lblHostedByUser!.frame.width, height: lblHostedByUser!.frame.height)
            imgHostedUser.center.y = (lblHostedByUser?.center.y)!
            imgHostedUser.addRemoteImage(imageURL: modelPaymentDetails.paymentData?.hostUserImage ?? "", placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: modelPaymentDetails.paymentData?.hostUserImage as! String) as! URL, placeholderImage:UIImage(named:""))
            tableFilter.tableFooterView = tblFooderView
            if let u_name = modelPaymentDetails.paymentData?.hostName {
                lblHostedByUser?.attributedText = MakentSupport().makeAttributeTextColor(originalText: String(format:"\(Lang.hostby_Title) %@", u_name) as NSString, normalText: "\(Lang.hostby_Title) " as NSString, attributeText: u_name as NSString, font: (lblHostedByUser?.font)!)
            }
            tblFooderView.isHidden = false
            
        }
    }

    // MARK: ROOMDETAIL CELL DELEGATE METHODS
    internal func onGuestAdded(index: Int) {
        strTotalGuest = String(format: "%d", index)
        appDelegate.searchguest = strTotalGuest
        getPrePaymentInfo()
    }

    @IBAction func onHostProfileTapped()
    {
        let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        viewProfile.strOtherUserId = strHostUserId
        viewProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewProfile, animated: true)
    }

    @IBAction func onStartToBooking(_ sender:UIButton!)
    {
        if nStepsLeft == 0
        {
            let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
            viewWeb.hidesBottomBarWhenPushed = true
            viewWeb.strPageTitle = Lang.payment_Title
//            viewWeb.isFromBooking = true
            var strPaytype = userDefaults.object(forKey: "paymenttype") as! String?
            let langval = Language.getCurrentLanguage().rawValue
            if strPaytype == self.Lang.crdit_Titlt{
                strPaytype = "Credit Card"
            }
            if appDelegate.searchguest == ""{
                appDelegate.searchguest = "1"
            }else {
                appDelegate.searchguest = "\(handPickedGuests.count)"
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            dateFormatterGet.locale = Locale.convertEnglish
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MM-yyyy"
            dateFormatterPrint.locale = Locale.convertEnglish
            var backendDate:String?
            if let date = dateFormatterGet.date(from: (modelPaymentDetails.paymentData?.date)!) {
                backendDate = dateFormatterPrint.string(from: date)
            } else {
                print("There was an error decoding the string")
            }

           // let arrayOfGuestDictionary = handPickedGuests.map{$0.toDictionary}
            var str = "["
            
            handPickedGuests.forEach { (guest) in
                str += "{"
                guest.toDictionary.forEach({ (key,value) in
                    str += "\"\(key)\":\"\(value)\","
                })
                str.remove(at: str.index(before: str.endIndex))
                str += "},"
            }
            str.remove(at: str.index(before: str.endIndex))
            str += "]"
            let arrayOfGuestDictionary = str
            viewWeb.strWebUrl = String(format:"%@%@?host_experience_id=%@&date=%@&scheduled_id=%@&country=%@&card_type=%@&guest_details=%@&message=%@&token=%@&language=%@",k_APIServerUrl,APPURL.API_EXPERIENCE_PAYMENT,"\((experienceDetails?.experienceId)!)",backendDate!,availablityModel.scheduledId!,selectedCountry,strPaytype!,arrayOfGuestDictionary,strHostMessage,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN),langval).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            print(viewWeb.strWebUrl)
            self.navigationController?.pushViewController(viewWeb, animated: true)

        }
    }

    // MARK: Setting Progress value and Animation
    func makeProgressAnimaiton(percentage:Int)
    {

    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.onPaymentTypeSelected()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (MakentSupport().isPad()) ? 980 : (house_rules.count>0) ? 605 : 545
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (modelPaymentDetails == nil) ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ExCellBooking = tableFilter.dequeueReusableCell(withIdentifier: "ExCellBooking") as! ExCellBooking
        cell.checkin_Lbl.text = self.Lang.checkin_Title
        cell.checkout_Lbl.text = self.Lang.checkout_Title
        cell.stps_Left.text = self.Lang.stps_Lftbk
        cell.lblTotalEx.text = self.Lang.lblTotalExText
        cell.price_Brk.setTitle(self.Lang.seepric_Dwn, for: .normal)
        cell.lblPaymentType.text = self.Lang.add_Title
        cell.btnPaymentType.setTitle("1.\(self.Lang.payment_Title)", for: .normal)
        cell.btnNightVal.setTitle(self.Lang.hours_Tit, for: .normal)
        cell.btnGuestVal.setTitle(self.Lang.guess_Tit, for: .normal)
        cell.btnGuestVal.addTarget(self, action: #selector(self.onGuestValueTapped), for: UIControl.Event.touchUpInside)
        cell.price_Brk.addTarget(self, action: #selector(self.onPriceValueTapped), for: UIControl.Event.touchUpInside)
        cell.btnPaymentType.addTarget(self, action: #selector(self.onPaymentTypeTapped), for: UIControl.Event.touchUpInside)
        cell.lblHoursVal.appGuestTextColor()
        cell.lblGuestVal.appGuestTextColor()
        cell.price_Brk.appGuestTextColor()
        cell.lblPaymentType.appGuestTextColor()
    
        cell.setPrePaymentDetails(preModel: modelPaymentDetails.paymentData!)
        cell.lblGuestVal.text = handPickedGuests.count == 0 ? "1" : "\(handPickedGuests.count + 1)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }


    func checkInOutTapped()
    {
        let selector = k_MakentStoryboard.instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector
        selector.room_Id = String(strRoomID)
        selector.delegate = self
        selector.callAPI = true
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(appDelegate.multipleDates)

        if arrBlockedDates.count > 0
        {
            selector.arrBlockedDates = arrBlockedDates
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
        present(selector, animated: true, completion: nil)
    }

    internal func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    {
        appDelegate.multipleDates = dates
        let formalDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        strStartDate = dateFormatter.string(from: startDay)
        strEndDate = dateFormatter.string(from: lastDay!)
        appDelegate.s_date = strStartDate
        appDelegate.e_date = strEndDate
        self.getPrePaymentInfo()
    }


    func onNightValueTapped()
    {
        checkInOutTapped()
    }

    @objc func onGuestValueTapped()
    {
//        let guestView = self.storyboard?.instantiateViewController(withIdentifier: "AddGuestVC") as! AddGuestVC
//        guestView.nCurrentGuest = Int(strTotalGuest)!
//        guestView.nMaxGuestCount = (modelPaymentDetails.paymentData?.numberOfGuests)!
//        guestView.delegate = self
//        present(guestView, animated: true, completion: nil)
    }

    @objc func onPriceValueTapped()
    {
        let indexPath = IndexPath(row: 0, section: 0)
        _ = tableFilter.cellForRow(at: indexPath) as! ExCellBooking
        let guestView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "ExperienceRecipitPageVC") as! ExperienceRecipitPageVC
        guestView.strLocationName = modelPaymentDetails.paymentData?.hostExperienceName ?? ""
        guestView.perhead = experienceDetails?.experiencePrice?.description as! String
        guestView.subtotal =  modelPaymentDetails.paymentData?.subtotal?.description as! String
        guestView.totalAmt = modelPaymentDetails.paymentData?.total?.description as! String
        guestView.serviceFee = modelPaymentDetails.paymentData?.serviceFee?.description as! String
        guestView.guestCount = modelPaymentDetails.paymentData?.numberOfGuests?.description as! String
        guestView.currencySym = modelPaymentDetails.paymentData?.currencySymbol?.description as! String
        guestView.currencyCode = modelPaymentDetails.paymentData?.currencyCode ?? ""
        guestView.isFromGuestSide = true
        present(guestView, animated: true, completion: nil)
    }
    func onCouponCodeTapped()
    {
        let couponView = k_MakentStoryboard.instantiateViewController(withIdentifier: "CouponVC") as! CouponVC
        present(couponView, animated: true, completion: nil)
    }

    @objc func onPaymentTypeTapped(){
        
        let selectPaymentVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "CountryListVC") as! CountryListVC
        self.navigationController?.pushViewController(selectPaymentVC, animated: true)
    }

    func onHostMessageTapped()
    {
        let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "AddMessageVC") as! AddMessageVC
        viewHouseRule.hidesBottomBarWhenPushed = true
        viewHouseRule.urlHostImg = modelPaymentDetails.paymentData?.hostUserImage as! String
        viewHouseRule.strHostUserId = strHostUserId
        let username = userDefaults.object(forKey: "hostmessage") as? NSString
        if (username != nil && username != "")
        {
            viewHouseRule.strMessage = (userDefaults.object(forKey: "hostmessage") as! NSString) as String
        }
        viewHouseRule.delegate = self
        present(viewHouseRule, animated: true, completion: nil)
    }

    func onHouseRulesTapped()
    {
        let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "RoomsHouseRules") as! RoomsHouseRules
        viewHouseRule.hidesBottomBarWhenPushed = true
        viewHouseRule.delegate = self
        viewHouseRule.strHouseRules = house_rules
        viewHouseRule.strHostUserName = modelPaymentDetails.paymentData?.hostUserImage as! String
        present(viewHouseRule, animated: true, completion: nil)
    }

    // MARK: HOUSE RULES DELEGATE METHOD
    internal func onAgreeTapped() {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tableFilter.cellForRow(at: indexPath) as! ExCellBooking

        if selectedCell.lblHouseRules.text == Lang.read_Title
        {
            selectedCell.lblHouseRules.text = Lang.agreed_Title
            checkRemainingSteps()
        }
    }

    // MARK: HOST MESSAGE DELEGATE METHOD
    func onHostMessageAdded(messsage: String)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tableFilter.cellForRow(at: indexPath) as! ExCellBooking
        strHostMessage = messsage.replacingOccurrences(of: " ", with: "%20")
        strHostMessage = strHostMessage.replacingOccurrences(of: "\n", with: "%20")

        if selectedCell.lblHostMessage.text == Lang.add_Title
        {
            selectedCell.lblHostMessage.text = Lang.done_Title
            checkRemainingSteps()
        }
    }

    // MARK: Add Message Delegate Methods
    internal func onMessageAdded(messsage:String)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tableFilter.cellForRow(at: indexPath) as! ExCellBooking
        strHostMessage = messsage.replacingOccurrences(of: " ", with: "%20")
        strHostMessage = strHostMessage.replacingOccurrences(of: "\n", with: "%20")

        if selectedCell.lblHostMessage.text == Lang.add_Title
        {
            selectedCell.lblHostMessage.text = Lang.done_Title
            checkRemainingSteps()
        }

    }

    func onPaymentTypeSelected()
    {
        let username = userDefaults.object(forKey: "paymenttype") as? NSString
        if (username != nil && username != "")
        {
            let indexPath = IndexPath(row: 0, section: 0)
            let selectedCell = tableFilter.cellForRow(at: indexPath) as! ExCellBooking

            if selectedCell.lblPaymentType.text == Lang.add_Title
            {
                checkRemainingSteps()
            }

             let payVal = userDefaults.object(forKey: "paymenttype") as! String?
            if payVal == "PayPal"{
                selectedCell.lblPaymentType.text = userDefaults.object(forKey: "paymenttype") as! String?
            }else{
                selectedCell.lblPaymentType.text = self.Lang.crdit_Titlt
            }
        }
    }

    func checkRemainingSteps()
    {
        if nStepsLeft == 0
        {
            return
        }
        nStepsLeft = nStepsLeft - 1
        if nStepsLeft == 0
        {
            btnBookNow?.setTitle(String(format:(strInstantBook == "Yes") ? Lang.book_Title : Lang.continue_Title ,nStepsLeft), for: .normal)
        }
        else
        {
            btnBookNow?.setTitle(String(format:"%d \(Lang.steps_LeftTitle)",nStepsLeft), for: .normal)
        }
    }

    func onStartBooking()
    {
        let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
        viewWeb.hidesBottomBarWhenPushed = true
        let Langval = Language.getCurrentLanguage().rawValue
        viewWeb.strPageTitle = Lang.payment_Title
//        viewWeb.isFromBooking = true
        var strPaytype = userDefaults.object(forKey: "paymenttype") as! String?
        if strPaytype == self.Lang.crdit_Titlt{
            strPaytype = "Credit Card"
        }
        strPaytype = strPaytype?.replacingOccurrences(of: " ", with: "%20")

        if appDelegate.searchguest == ""{
            appDelegate.searchguest = "1"
        }else {
            appDelegate.searchguest = "\(handPickedGuests.count)"
        }
        if (strInstantBook == "Yes")
        {
            viewWeb.strWebUrl = String(format:"%@%@?room_id=%@&card_type=%@&check_in=%@&check_out=%@&number_of_guests=%@&country=%@&token=%@&language=%@",k_APIServerUrl,APPURL.API_BOOK_NOW,strRoomID.description,strPaytype!,(modelPaymentDetails.paymentData?.date)!,(modelPaymentDetails.paymentData?.date)!,appDelegate.searchguest,selectedCountry,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN),Langval)
            print(viewWeb.strWebUrl)
        }
        else
        {
            viewWeb.strWebUrl = String(format:"%@%@?room_id=%@&card_type=%@&check_in=%@&check_out=%@&number_of_guests=%@&country=%@&token=%@&language=%@",k_APIServerUrl,APPURL.API_BOOK_NOW,strRoomID.description,strPaytype!,(modelPaymentDetails.paymentData?.date)!,(modelPaymentDetails.paymentData?.date)!,appDelegate.searchguest,selectedCountry,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN),Langval)
        }
        print((modelPaymentDetails.paymentData?.date)!,(modelPaymentDetails.paymentData?.date)!,appDelegate.searchguest,selectedCountry)
        self.navigationController?.pushViewController(viewWeb, animated: true)

    }

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
        appDelegate.back1 = "book"
    }

    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    func wsToCreateWebService(paramDict:[String:Any],wsMethod:String) {
        var params = Parameters()
        params["language"] = Language.getCurrentLanguage().rawValue
        for (key,value) in paramDict{
            params[key] = value
        }
        Alamofire.request("\(k_APIServerUrl)\(wsMethod)", method: .get, parameters: params, encoding: URLEncoding.default , headers: nil).responseJSON { (response) in
            switch response.result {
                case .success:
                    print(response.result.value!)
                case .failure(let err):
                    print(err)
            }
        }
    }

}

class ExCellBooking: UITableViewCell
{
    @IBOutlet var lblCheckInDate: UILabel!
    @IBOutlet var lblCheckOutDate: UILabel!
    @IBOutlet var lblHoursVal: UILabel!
    @IBOutlet var lblGuestVal: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblTotalEx: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblHostMessage: UILabel!
    @IBOutlet var lblHouseRules: UILabel!
    @IBOutlet var btnCheckInOutDate: UIButton!
    @IBOutlet var btnNightVal: UIButton!
    @IBOutlet var btnGuestVal: UIButton!
    @IBOutlet var btnPrice: UIButton!
    @IBOutlet var btnPaymentType: UIButton!
    @IBOutlet var btnHostMessage: UIButton!
    @IBOutlet var btnHouseRules: UIButton!
    @IBOutlet weak var checkInTimeLabel: UILabel!
    @IBOutlet weak var checkOutTimeLabel: UILabel!

    @IBOutlet weak var stps_Left: UILabel!
    @IBOutlet weak var checkout_Lbl: UILabel!
    @IBOutlet weak var checkin_Lbl: UILabel!
    
    @IBOutlet weak var price_Brk: UIButton!
    
    
    func setPrePaymentDetails(preModel : PaymentData)
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE\nMMM dd"
        dateFormatterPrint.locale = Language.getCurrentLanguage().locale
        if let date = dateFormatterGet.date(from: preModel.date!) {
            lblCheckInDate.text = dateFormatterPrint.string(from: date)
            lblCheckOutDate.text = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
//
        checkInTimeLabel.text = preModel.startTime
        checkOutTimeLabel.text = preModel.endTime
//        lblNightVal.text = preModel.nights_count as String
        lblPrice.attributedText =  MakentSupport().attributedTextboldText(originalText: String(format:"%@ %@ %@",(preModel.currencyCode as! String),(preModel.currencySymbol as! String).stringByDecodingHTMLEntities, preModel.total?.description as! String) as NSString, boldText: String(format:"%@ %@",(preModel.currencySymbol as! String).stringByDecodingHTMLEntities, preModel.total?.description as! String) as String, fontSize: 22.0)
        lblGuestVal.text = (preModel.numberOfGuests?.description as! String)
        lblHoursVal.text = (preModel.totalHours?.description as! String)

    }
}

extension Locale {
    
    /// SwifterSwift: UNIX representation of locale usually used for normalizing.
    public static var convertEnglish: Locale {
        
        return Locale(identifier: "en_US")
    }
}
