/**
* BookingVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social
import Stripe
import Alamofire

protocol AfterPaymentDelegate {
    func afterPayment(paymentKey: String)
}


class BookingVC : UIViewController,UITableViewDelegate, UITableViewDataSource, WWCalendarTimeSelectorProtocol, AddGuestDelegate,HouseRulesAgreeDelegate,AddMessageDelegate,ViewOfflineDelegate,UITextFieldDelegate
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
    
    @IBOutlet var ApplyCouponMainView: UIView!
    @IBOutlet weak var applyCoupon: UITextField!
    @IBOutlet weak var applyCouponBtn: UIButton!
    
    var strStartDate:String = ""
    var strEndDate:String = ""
    var strRoomID:String = ""
    var strTotalGuest:String = ""
    var strRoomName:String = ""
    var strLocationName:String = ""
    var house_rules:String = ""
    var resultText = ""
    
//    var getPaymentDetail : PrePaymentModel!
    var nStepsLeft : Int = 3
    var strAboutHome:String = ""
    var strHostUserId:String = ""
    var strBookDetail:String = ""
    var strLengthDetail:String = ""
    var strInstantBook:String = ""
    var strHostMessage:String = ""
    var sKey = String()
    var Reser_ID : String!
    var couponTitleName : String?
    var getPaymentDetail : PaymentDetailData!
    var  userDefaults = UserDefaults.standard
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var instantBookSelected:Bool = false
    var isFirstTime:Bool = true
    var StripeID : String = ""
    var currencySym = ""
    var spaceAmnt = ""
    var spaceName = ""
//    var payPalConfig = PayPalConfiguration()
//    var completeBooking:CompleteBookingDelegate?
    var brainTree : BrainTreeProtocol?
    
//    var environment:String = PayPalEnvironmentNoNetwork {
//           willSet(newEnvironment) {
//               if (newEnvironment != environment) {
//                   PayPalMobile.preconnect(withEnvironment: newEnvironment)
//               }
//           }
//       }
  // var payPalConfig = PayPalConfiguration()
    
    var arrPrice = [String]()
    var arrPirceDesc = [String]()
    var arrBlockedDates : NSMutableArray = NSMutableArray()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    fileprivate var singleDate: Date = Date()
    var multipleDates: [Date] = []
    var selectedCountry = ""
    @IBOutlet var animatedImageView: FLAnimatedImageView?
    
    var clientScrectId:String = ""
    var paymentIntStripeID: String = ""
    var stripeId:String = ""
    
    var paykey : String?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Booking VC")
        userDefaults.set("", forKey: "paymenttype")
        userDefaults.set("", forKey: "hostmessage")
        userDefaults.synchronize()
        print("InstantBook",strInstantBook)
        let height = MakentSupport().onGetStringHeight(lblOtherDetail.frame.size.width, strContent: strAboutHome as NSString, font: (lblOtherDetail.font)!)
        var rectLblDetails = lblOtherDetail.frame
        rectLblDetails.size.height = height+5
        ApplyCouponMainView.addTap {
            self.hideCouponPopup()
        }
        /// Stripe Configuration
        self.getPaymentInfo()
        applyCouponBtn.addTarget(self, action: #selector(self.onRemoveApplyPopup), for: .touchUpInside)
        self.applyCoupon.delegate = self
        
        lblOtherDetail.frame = rectLblDetails
        var rectHeaderView = tblHeaderView.frame
        rectHeaderView.size.height = tblHeaderView.frame.size.height + (height - 40)
        tblHeaderView.frame = rectHeaderView
        self.navigationController?.isNavigationBarHidden = true
        tblFooderView.isHidden = false
       // MakentSupport().setDotLoader(animatedLoader: animatedImageView!)
        print("house rules count",house_rules.count)
        btnBookNow?.appHostSideBtnBG()
        //nStepsLeft = (house_rules.count>0) ? 3 : 2
        nStepsLeft   = 0
        lblSeparatorOne.isHidden = true
        lblSeparatorTwo.isHidden = true
        lblHotelName.text = strRoomName
        lblHouse.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblHotelName.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblRoomDetails.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblOtherDetail.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblHostedByUser?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        btnBookNow?.setTitle("\(nStepsLeft.localize) \(lang.steps_LeftTitle)", for: .normal)
        //btnBookNow?.setTitle("\(lang.choose_your_country)", for: .normal)
        
        tableFilter.tableHeaderView = tblHeaderView
        imgHostedUser.layer.cornerRadius = imgHostedUser.frame.size.height/2
        imgHostedUser.clipsToBounds = true
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PaymentComplete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeDetails(notification:)), name: NSNotification.Name(rawValue: "PaymentComplete"), object: nil)
        // Paypal is switched to Braintree --> Rathna
        //self.configPaypalPayment()
    }
    
    // handle notification
    @objc func timeDetails(notification: NSNotification) {
        print("Notification Received")
        
//            self.completeBooking(bookingType: "instant_book", paymentMode: "stripe", payKey: notification.userInfo?["payKey"] as! String)
         let countryCode = userDefaults.string(forKey: "countrycode")
        if countryCode != nil {
          self.Booking("stripe", String(describing: countryCode!))
        
        }else{
            
        }
        
    }
    func authenticatePaypalPayment(for amount : Double,using clientId : String, currencyCode: String){
        self.brainTree = BrainTreeHandler.default
        self.brainTree?.initalizeClient(with: clientId)
        self.view.isUserInteractionEnabled = false
        self.brainTree?.authenticatePaypalUsing(self, for: amount, currecyCode: currencyCode) { (result) in
            self.view.isUserInteractionEnabled = true
            switch result{
            case .success(let token):
                self.paykey = token.nonce
                self.onCompleteBooking(bookingType: "instant_book", paymentMode: "paypal", payKey: self.paykey ?? "")
                //self.wsToAddMoneyInWallet()
            case .failure(let error):
                Utilities.showAlertMessage(message: error.localizedDescription, onView: self)
            }
        }
    }
    
    
    func onCompleteBooking(bookingType: String, paymentMode: String, payKey: String){

            print("onStartToBooking")
            let country = userDefaults.object(forKey: "countryname")
            let countryCode = userDefaults.object(forKey: "countrycode")
            print("selected country",country)
            print("selected countryCode",countryCode)
            var dicts = [String: Any]()
            dicts["token"]          = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
            dicts["s_key"]          = self.getPaymentDetail.data.sKey
            dicts["paymode"]        = paymentMode
            dicts["message"]        = "Testing"
            dicts["pay_key"]        = payKey
            dicts["country"]        = countryCode
            dicts["currency_code"]  = getPaymentDetail.data.paymentCurrency
            dicts["booking_type"]   = bookingType

            WebServiceHandler.sharedInstance.getToWebService(wsMethod: "complete_booking", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false){
                (responseDict) in
                if responseDict.string("status_code") == "1"
                {
                    self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)


//                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: {

                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 1)
                    })
                }
                else{
                    self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let  userDefaults = UserDefaults.standard
        let countrys = userDefaults.object(forKey: "countryname") as? NSString
        let countryCode = userDefaults.object(forKey: "countrycode")
        print("countrycode",countryCode)
        print("country",countrys)
        if (countrys != nil && countrys != "")
        {
            if strInstantBook == "Yes"
            {
                btnBookNow?.setTitle("\(lang.Book_Now)", for: .normal)
            }
            else
            {
                btnBookNow?.setTitle("\(lang.Book_Now)", for: .normal)
            }
            selectedCountry = YSSupport.escapedValue(countrys as! String)
        }
        else
        {
            btnBookNow?.setTitle("\(lang.choose_your_country)", for: .normal)
            selectedCountry = YSSupport.escapedValue(("United States"))
        }
    }
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.getPaymentInfo()
    }
    
    // MARK: CURRENCY API CALL
    /*
     */
    func getPaymentInfo()
    {
        
      if !MakentSupport().checkNetworkIssue(self, errorMsg: "") {
            return
        }
        let langval = Language.getCurrentLanguage().rawValue
        self.animatedImageView?.isHidden = false
        var dicts = [String: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["s_key"] = self.sKey
        dicts["reservation_id"] = self.Reser_ID

        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "get_payment_data", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            print("getPaymentData",responseDict)
            guard let statusCode = responseDict["status_code"] as? String, statusCode == "1" else {
                self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
                self.dismiss(animated: true, completion: nil)
                return
            }
            self.getPaymentDetail = PaymentDetailData(json: responseDict)
            self.sKey = self.getPaymentDetail.data.sKey
           // print("Status Code",responseDict.string("status_code"))
            print("paymentData",self.getPaymentDetail.data.bookingDateTimes)
            self.strTotalGuest = String(self.getPaymentDetail.data.numberOfGuest)
            self.setupHeaderinfo()
            self.tableFilter.reloadData()

        }
    }
    
  
    
    func makeSpecialPrices()
    {
//        let currencySymbol = (getPaymentDetail.data.currencySymbol as String).stringByDecodingHTMLEntities
//        let strAdditionalGuest = String(format:"%@ %@",currencySymbol,getPaymentDetail.data.fe)
//        let strsecurity_deposit = String(format:"%@ %@",currencySymbol,getPaymentDetail.data.security_fee)
//        let strcleaning_fee = String(format:"%@ %@",currencySymbol,getPaymentDetail.data.cleaning_fee)
//        let lengthofstay_fee = String(format:"%@ %@",currencySymbol,getPaymentDetail.data.length_of_stay_discount_price)
//        let booking_fee = String(format:"%@ %@",currencySymbol,getPaymentDetail.data.booked_period_discount_price)
//        let lengthofdiscount = getPaymentDetail.data.length_of_stay_discount as String
//        let bookingdiscount = getPaymentDetail.data.booked_period_discount as String
//        let type = getPaymentDetail.data.booked_period_type as String
//        let newString = type.replacingOccurrences(of: "_", with: " ")
//        let booking_type = newString as String
//        arrPrice = [String]()
//        arrPirceDesc = [String]()
//        if getPaymentDetail.data.addition_guest_fee != "0" && getPaymentDetail.data.addition_guest_fee != ""
//        {
//            arrPrice.append(strAdditionalGuest)
//            arrPirceDesc.append("Additional Guest fee")
//        }
//        if getPaymentDetail.data.booked_period_discount_price != "0" && getPaymentDetail.data.booked_period_discount_price != ""
//        {
//            strBookDetail = "\(bookingdiscount)% \(booking_type) \(self.lang.discount_Title)"
//        }
//        if getPaymentDetail.data.length_of_stay_discount_price != "0" && getPaymentDetail.data.length_of_stay_discount_price != ""
//        {
//            strLengthDetail = "\(lengthofdiscount)% \(self.lang.lengthdis_Title)"
//        }
//        if getPaymentDetail.data.security_fee != "0" && getPaymentDetail.data.security_fee != ""
//        {
//            arrPrice.append(strsecurity_deposit)
//            arrPirceDesc.append("Security fee")
//        }
//        if getPaymentDetail.data.cleaning_fee != "0" && getPaymentDetail.data.cleaning_fee != ""
//        {
//            arrPrice.append(strcleaning_fee)
//            arrPirceDesc.append("Cleaning fee")
//        }
    }
    
    func setupHeaderinfo()
    {
//        if getPaymentDetail != nil
//        {
        if self.getPaymentDetail != nil
        {
            lblSeparatorOne.isHidden = false
            lblSeparatorTwo.isHidden = false
            
            lblHouse.text = "Entire place"
            lblHouse.appGuestTextColor()
            lblHotelName.text = self.getPaymentDetail.data.spaceName
//            var bedRooms = ""
//            var bathRooms = ""
            
//            bedRooms = String(format: (getPaymentDetail.no_of_bedrooms == "0" || getPaymentDetail.no_of_bedrooms == "1") ? "%@ \(self.lang.bedroom_Tit)" : "%@ \(self.lang.bedroom_Tit)",getPaymentDetail.no_of_bedrooms)
//
//            bathRooms = String(format: (getPaymentDetail.no_of_bathrooms == "0" || getPaymentDetail.no_of_bathrooms == "1") ? "%@ \(self.lang.bath_Tit)" : "%@ \(self.lang.bath_Tit)",getPaymentDetail.no_of_bathrooms)
            
            //lblRoomDetails.text = String(format: "%@ . %@",bedRooms,bathRooms)
            lblRoomDetails.text = self.getPaymentDetail.data.spaceAddress
            lblOtherDetail.text = self.getPaymentDetail.data.activityType
            imgHostedUser.addRemoteImage(imageURL: self.getPaymentDetail.data.hostThumbImage, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: getPaymentDetail.host_user_image as String) as! URL, placeholderImage:UIImage(named:""))
            tableFilter.tableFooterView = tblFooderView
//            lblHostedByUser?.attributedText = MakentSupport().makeAttributeTextColor(originalText: String(format:"\(self.lang.hostby_Title) %@", getPaymentDetail.host_user_name) as NSString, normalText: "\(self.lang.hostby_Title) " as NSString, attributeText: getPaymentDetail.host_user_name, font: (lblHostedByUser?.font)!)
            lblHostedByUser?.attributedText = MakentSupport().makeAttributeTextColor(originalText: String(format:"\(self.lang.hostby_Title) %@", self.getPaymentDetail.data.hostUserName) as NSString, normalText: "\(self.lang.hostby_Title) " as NSString, attributeText: self.getPaymentDetail.data.hostUserName as NSString, font: (lblHostedByUser?.font)!)
            
            tblFooderView.isHidden = false
        }
    }
    
    // MARK: ROOMDETAIL CELL DELEGATE METHODS
    internal func onGuestAdded(index: Int) {
        strTotalGuest = String(format: "%d", index)
        appDelegate.searchguest = strTotalGuest
        getPaymentInfo()
    }
    
    @IBAction func onHostProfileTapped()
    {
        let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
//        viewProfile.strOtherUserId = strHostUserId
        viewProfile.strOtherUserId = String(getPaymentDetail.data.hostUserId)
        viewProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewProfile, animated: true)
    }
    
    @IBAction func onStartToBooking(_ sender:UIButton!)
    {
       // complete_Booking(bookingType: "request_book", paymentMode: "")
        //self.payPalIntegrations()
       // self.checkoutAction()
        print("onStartToBooking")
        completeBooking(bookingType: "request_book", paymentMode: "", payKey: "")
    }
    
    func completeBooking(bookingType : String, paymentMode : String, payKey: String)
    {
        print("Complete Booking Type")
        print("stepsLeft",nStepsLeft)
        if nStepsLeft == 0
        {
            print("self.paymentIntStripeID",self.paymentIntStripeID)
            let country = userDefaults.object(forKey: "countryname") as? NSString
            
            print("selected country",country)
            let countryCode = userDefaults.string(forKey: "countrycode")
            print("selected countryCode",countryCode)
            // country == nil && country == ""
            
            if country != nil && country != ""
            {
                if strInstantBook == "Yes"
                {
                    //showPaymentType()
                    print("currency",self.getPaymentDetail.data.paymentCurrency)
                    self.payAlert()
                }
                else
                {
                    let countryCode = userDefaults.string(forKey: "countrycode")
                    if countryCode != nil && countryCode != ""
                    {
                      self.Booking(paymentMode, countryCode!.description)
                    }
                    
                    
                }
            }
            else
            {
                onCountryTypeTapped()
            }
        
        }
    }
    
    func payAlert(){
        let alertController = UIAlertController(title: "Payment Method", message: "Choose Payment Option", preferredStyle: .actionSheet)
     
     let sendButton = UIAlertAction(title: "PayPal", style: .default, handler: { (action) -> Void in
        
        self.wsToConverCurrency()
        //self.authenticatePaypalPayment(for: 10.0, using: "")
       // self.payPalIntegrations()
     })

     
     let  deleteButton = UIAlertAction(title: "Stripe", style: .default, handler: { (action) -> Void in
        self.stripeNavigation()
     })
     
     let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
         
     })
     
     
     alertController.addAction(sendButton)
     alertController.addAction(deleteButton)
     alertController.addAction(cancelButton)
     
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func wsToConverCurrency(){
            let amount = NSDecimalNumber(string: "\(self.getPaymentDetail.data.paymentTotal)")
            let params = ["amount": amount,
                          "payment_type": "paypal",
                          "token" : SharedVariables.sharedInstance.userToken,
    //                      "service_type": self.sharedVariable.selectedServiceDict.string("id")] as [String : Any]
                          "currency_code" : "\(self.getPaymentDetail.data.currencyCode)"] as [String : Any] //"service_type": "\("1")"
            WebServiceHandler.sharedInstance
                .getToWebService(wsMethod: "currency_conversion",
                               paramDict: params,
                               viewController: self,
                               isToShowProgress: true,
                               isToStopInteraction: false) { (response) in
                                guard let json = response as? JSONS else{
                                    return
                                }
                                if json.isSuccess{
                                    self.authenticatePaypalPayment(for: json.double("amount"),
                                                                   using: json.string("braintree_clientToken"), currencyCode: json.string("currency_code"))
                                }else{
                                    Utilities.showAlertMessage(message: json.statusMessage, onView: self)
                                }
            }
        }
    
    // MARK: Setting Progress value and Animation
    func makeProgressAnimaiton(percentage:Int)
    {
        
    }
    
 //   func payPalIntegrations()
//    {
//
//        print("CurrencySym:",self.getPaymentDetail.data.currencyCode)
//
//        let total = NSDecimalNumber(string: "\(self.getPaymentDetail.data.paymentPrice)")
//
////          let item1 = PayPalItem(name: self.spaceName, withQuantity: 1, withPrice: NSDecimalNumber(string: String(self.getPaymentDetail.data.paymentTotal)), withCurrency: self.getPaymentDetail.data.currencyCode, withSku: "")
//
//        let item1 = PayPalItem(name: self.spaceName, withQuantity: 1, withPrice: total, withCurrency: self.getPaymentDetail.data.paymentCurrency, withSku: "")
//
//
//        let items = [item1]
//        let subtotal = PayPalItem.totalPrice(forItems: items)
//
//        print("subtotal amount",subtotal,"Payment Amount",self.getPaymentDetail.data.paymentCurrency)
//
//        let shipping = NSDecimalNumber(string: "0.00")
//        let tax = NSDecimalNumber(string: "0.00")
//        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
//
////        let total = subtotal.adding(shipping).adding(tax)
////        print("total amount",total)
////        let payment = PayPalPayment(amount: total, currencyCode: self.getPaymentDetail.data.currencyCode, shortDescription: self.spaceName, intent: .sale)
//
//        print("total amount",total)
//        let payment = PayPalPayment(amount: total, currencyCode: self.getPaymentDetail.data.paymentCurrency, shortDescription: self.spaceName, intent: .sale)
//
//        payment.items = items
//        payment.paymentDetails = paymentDetails
//
//
//        if (payment.processable) {
//            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
//            paymentViewController?.modalPresentationStyle = .fullScreen
//            self.present(paymentViewController!, animated: true, completion: nil)
//        }
//        else {
//            print("Payment not processalbe: \(payment)")
//        }
//    }
    
    func stripeNavigation(){
        let countryCode = userDefaults.object(forKey: "countrycode") as? NSString
        let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "StripeViewController") as! StripeViewController
        contactView.sKey = self.sKey
        contactView.paymentCurrenncy = self.getPaymentDetail.data.currencyCode
        contactView.paymentCountryCode = countryCode!.description
        contactView.paymentAmount  = self.getPaymentDetail.data.paymentTotal.description
        contactView.stripePublishKey = self.getPaymentDetail.paymentCredential.stripePublishKey
        contactView.afterPaymentDelegate = self
        let navController = UINavigationController(rootViewController: contactView)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    func Booking(_ paymentMode : String, _ counrtyCode : String, bookingType: String = "request_book"){
        print("onStartToBooking")
        var dicts = [String: Any]()
        dicts["token"]          = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["s_key"]          = self.sKey
        dicts["paymode"]        = paymentMode
        dicts["message"]        = "Testing"
        dicts["pay_key"]        = self.paymentIntStripeID
        dicts["country"]        = counrtyCode
        //dicts["country"]        = "EUR"
        dicts["currency_code"]  = getPaymentDetail.data.paymentCurrency
        //dicts["booking_type"]   = bookingType
        dicts["booking_type"]   = bookingType

        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "complete_booking", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false)
        {
            (responseDict) in
            if responseDict.string("status_code") == "1"
            {
                self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
                self.dismiss(animated: false, completion: nil)
                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 1)
                
            }
            else
            {
                self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
            }
        }
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
        //return (getPaymentDetail == nil) ? 0 : 1
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("Booking TableView")
        let cell:CellBooking = tableFilter.dequeueReusableCell(withIdentifier: "CellBooking") as! CellBooking
        
        cell.btnGuestVal.setTitle(lang.guess_Tit, for: .normal)
        cell.btnNightVal.setTitle(lang.total_Hours, for: .normal)
       // cell.btnNightVal.setTitle(lang.nights_Title, for: .normal)
        cell.lblPaymentType.textAlignment = .right
        if let val = userDefaults.object(forKey: "countryname") as? NSString
        {
            if val != "" || val != nil{
                cell.lblPaymentType.text = val.description == "" ? self.lang.add_Title : val.description
        }else{
             cell.lblPaymentType.text = self.lang.add_Title
            }
        }
        cell.btnPrice.setTitle(lang.seepric_Dwn,for: .normal)
        cell.lblHostMessage.text = self.lang.mssg_Titt
        
        cell.steps_LeftLbl.text = self.lang.stps_Lftbk
        cell.lblTotal.text = self.lang.lblTotText1
        cell.lblHouseRules.text = self.lang.read_Title
        cell.lblNightVal.appGuestTextColor()
        cell.lblGuestVal.appGuestTextColor()
        cell.lblPaymentType.appGuestTextColor()
        cell.btnPrice.appGuestTextColor()
        cell.lblHostMessage.appGuestTextColor()
        cell.lblHouseRules.appGuestTextColor()
        cell.promoLbl.textColor = UIColor.gray
        cell.promoLbl.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.applyCouponPopup.appGuestTextColor()
        cell.promoLbl.text = self.lang.coup_Tit
        
        
        cell.lblPaymentType.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .right)
        cell.lblHostMessage.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblHouseRules.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        
        //cell.btnPaymentType.setTitle(self.lang.payment_Title, for: .normal)
        cell.btnPaymentType.setTitle(self.lang.country_Title, for: .normal)
        cell.btnHostMessage.setTitle(self.lang.msghst_Tit, for: .normal)
        cell.btnHouseRules.setTitle(self.lang.housrul_Title, for: .normal)
        
        cell.btnPaymentType.contentHorizontalAlignment = Language.getCurrentLanguage().getButtonTextAlignment(align: .left)
        cell.btnHostMessage.contentHorizontalAlignment = Language.getCurrentLanguage().getButtonTextAlignment(align: .left)
        cell.btnHouseRules.contentHorizontalAlignment = Language.getCurrentLanguage().getButtonTextAlignment(align: .left)
        
        
        cell.btnPrice.addTarget(self, action: #selector(self.onPriceValueTapped), for: UIControl.Event.touchUpInside)
    
        cell.applyCouponPopup.addTarget(self, action: #selector(self.onCouponCodeTapped(sender:)), for: .touchUpInside)
        cell.btnPaymentType.addTarget(self, action: #selector(self.onCountryTypeTapped), for: UIControl.Event.touchUpInside)
        cell.btnHostMessage.addTarget(self, action: #selector(self.onHostMessageTapped), for: UIControl.Event.touchUpInside)
        cell.btnHouseRules.addTarget(self, action: #selector(self.onHouseRulesTapped), for: UIControl.Event.touchUpInside)
        if self.getPaymentDetail != nil
        {
             cell.setPrePaymentDetails(preModel: self.getPaymentDetail)
            if self.getPaymentDetail.data.couponApplied {
                self.couponTitleName = self.lang.removeCoupon
            }
            else {
                self.couponTitleName = self.lang.applyCoupon
            }
             self.currencySym = self.getPaymentDetail.data.currencyCode
             self.spaceAmnt = self.getPaymentDetail.data.paymentTotal.description
             self.spaceName = self.getPaymentDetail.data.spaceName

        }
        cell.applyCouponPopup.setTitle(self.couponTitleName, for: .normal)
        cell.lblGuestVal.text = strTotalGuest
        cell.lblGuestVal.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblNightVal.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.btnNightVal.contentHorizontalAlignment = Language.getCurrentLanguage().getButtonTextAlignment(align: .left)
        cell.btnGuestVal.contentHorizontalAlignment = Language.getCurrentLanguage().getButtonTextAlignment(align: .left)
        cell.lblHostMessage.text = (strHostMessage.count>0) ? lang.edit_Title : lang.mssg_Titt
        if house_rules.count == 0 {
            cell.rulesButtonHeightConstraint.constant = 0
            cell.btnHouseRules.isHidden = true
            cell.lblHouseRules.isHidden = true
        }
        else {
            cell.rulesButtonHeightConstraint.constant = 50
            cell.btnHouseRules.isHidden = false
            cell.lblHouseRules.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
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
        strEndDate = dateFormatter.string(from: lastDay! ?? Date())
        
        //strStartDate = dateFormatter.string(from: startDay)
        //strEndDate = dateFormatter.string(from: lastDay!)
        appDelegate.s_date = strStartDate
        appDelegate.e_date = strEndDate 
        self.getPaymentInfo()
    }
    
    @objc func onPriceValueTapped()
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tableFilter.cellForRow(at: indexPath) as! CellBooking
        let guestView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PriceBreakDown") as! PriceBreakDown
        guestView.serviceKey = self.sKey
        guestView.reservation_id = self.Reser_ID ?? ""
        guestView.modalPresentationStyle = .fullScreen
        present(guestView, animated: true, completion: nil)
    }
    @objc func onRemoveApplyPopup()
    {
        self.wsToApplycoupon()
    }
    
    @objc func onCouponCodeTapped(sender : UIButton)
    {
//        let couponView = k_MakentStoryboard.instantiateViewController(withIdentifier: "CouponVC") as! CouponVC
//        present(couponView, animated: true, completion: nil)
        print("coupon title",self.applyCouponBtn.titleLabel?.text)
        if sender.titleLabel?.text == self.lang.applyCoupon
        {
            self.showCouponPopup()
        }
        else
        {
            self.wsToRemovecoupon()
        }
    
    }
//    @objc func onPaymentTypeTapped()
//    {
//        print("onPaymentTypeTapped")
//        let countryVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "CountryListVC") as! CountryListVC
//        self.navigationController?.pushViewController(countryVC, animated: true)
//    }
    @objc func onCountryTypeTapped()
    {
        print("onPaymentTypeTapped")
        let countryVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "CountryListVC") as! CountryListVC
        self.navigationController?.pushViewController(countryVC, animated: true)
    }
    
    @objc func onHostMessageTapped()
    {
        let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "AddMessageVC") as! AddMessageVC
        viewHouseRule.hidesBottomBarWhenPushed = true
        viewHouseRule.modalPresentationStyle = .fullScreen
        viewHouseRule.urlHostImg = getPaymentDetail.data.hostThumbImage
        viewHouseRule.strHostUserId = String(getPaymentDetail.data.hostUserId)
        let username = userDefaults.object(forKey: "hostmessage") as? NSString
        if (username != nil && username != "")
        {
            viewHouseRule.strMessage = (userDefaults.object(forKey: "hostmessage") as! NSString) as String
        }
        viewHouseRule.delegate = self
        present(viewHouseRule, animated: true, completion: nil)
    }
    
    @objc func onHouseRulesTapped()
    {
        let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "RoomsHouseRules") as! RoomsHouseRules
        viewHouseRule.hidesBottomBarWhenPushed = true
        viewHouseRule.delegate = self
        viewHouseRule.strHouseRules = house_rules
        viewHouseRule.strHostUserName = getPaymentDetail.data.hostUserName as String
        present(viewHouseRule, animated: true, completion: nil)
    }
    
    // MARK: HOUSE RULES DELEGATE METHOD
    internal func onAgreeTapped() {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tableFilter.cellForRow(at: indexPath) as! CellBooking
        
        if selectedCell.lblHouseRules.text == lang.read_Title
        {
            selectedCell.lblHouseRules.text = lang.agreed_Title
            checkRemainingSteps()
        }
    }
    
    // MARK: HOST MESSAGE DELEGATE METHOD
    func onHostMessageAdded(messsage: String)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tableFilter.cellForRow(at: indexPath) as! CellBooking
        strHostMessage = messsage.replacingOccurrences(of: " ", with: "%20")
        strHostMessage = strHostMessage.replacingOccurrences(of: "\n", with: "%20")

        if selectedCell.lblHostMessage.text == lang.mssg_Titt
        {
            selectedCell.lblHostMessage.text = lang.edit_Title
            checkRemainingSteps()
        }
    }
    
    // MARK: Add Message Delegate Methods
    internal func onMessageAdded(messsage:String)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tableFilter.cellForRow(at: indexPath) as! CellBooking
        strHostMessage = messsage.replacingOccurrences(of: " ", with: "%20")
        strHostMessage = strHostMessage.replacingOccurrences(of: "\n", with: "%20")
        if selectedCell.lblHostMessage.text == lang.mssg_Titt
        {
            selectedCell.lblHostMessage.text = lang.edit_Title
            checkRemainingSteps()
        }
    }
    
    func onPaymentTypeSelected()
    {
        let country = userDefaults.object(forKey: "countryname") as? NSString
        print("Country",country)
        let username = userDefaults.object(forKey: "countryname") as? NSString
        if (username != nil && username != "")
        {
            let indexPath = IndexPath(row: 0, section: 0)
            let selectedCell = tableFilter.cellForRow(at: indexPath) as! CellBooking
            if Language.getCurrentLanguage().isRTL {
                selectedCell.lblPaymentType.textAlignment = .left
            } else {
                selectedCell.lblPaymentType.textAlignment = .right
            }
            
            if selectedCell.lblPaymentType.text == lang.add_Title
            {
                checkRemainingSteps()
            }
            if let val = userDefaults.object(forKey: "countryname") as! String?
            {
                if val == "CreditCard"
                {
                   // selectedCell.lblPaymentType.text = self.lang.crdit_Titlt//userDefaults.object(forKey: "paymenttype") as! String?
                    selectedCell.lblPaymentType.text = userDefaults.object(forKey: "countryname") as! String?
                    
                }
            }
            selectedCell.lblPaymentType.text = userDefaults.object(forKey: "countryname") as! String?
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
            let locVal = nStepsLeft.localize
            btnBookNow?.setTitle(String(format:(strInstantBook == "Yes") ? self.lang.Book_Now : lang.continue_Title,locVal), for: .normal)
        }
        else if nStepsLeft == 1
        {
            let locVal = nStepsLeft.localize
            btnBookNow?.setTitle(( locVal + " " + self.lang.step_LeftTitle ), for: .normal)
        }
        else
        {
            let locVal = nStepsLeft.localize
            btnBookNow?.setTitle(( locVal + " " + self.lang.steps_LeftTitle ), for: .normal)
        }
    }
    
    func onStartBooking()
    {
        let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
        viewWeb.hidesBottomBarWhenPushed = true
        viewWeb.strPageTitle = self.lang.payment_Title
        var strPaytype = userDefaults.object(forKey: "paymenttype") as! String?
        if strPaytype == self.lang.crdit_Titlt{
            strPaytype = "Credit Card"
        }
        strPaytype = strPaytype?.replacingOccurrences(of: " ", with: "%20")
        viewWeb.isFromBooking = true
        if appDelegate.searchguest == ""{
            appDelegate.searchguest = "1"
        }
        if (strInstantBook == "Yes")
        {
            viewWeb.strWebUrl = String(format:"%@%@?room_id=%@&card_type=%@&check_in=%@&check_out=%@&number_of_guests=%@&country=%@&token=%@",k_APIServerUrl,APPURL.API_BOOK_NOW,strRoomID,strPaytype!,strStartDate,strEndDate,appDelegate.searchguest,selectedCountry,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))
        }
        else
        {
            viewWeb.strWebUrl = String(format:"%@%@?room_id=%@&card_type=%@&check_in=%@&check_out=%@&number_of_guests=%@&country=%@&token=%@",k_APIServerUrl,APPURL.API_BOOK_NOW,strRoomID,strPaytype!,strStartDate,strEndDate,appDelegate.searchguest,selectedCountry,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))
        }
        self.navigationController?.pushViewController(viewWeb, animated: true)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if appDelegate.lastPageMaintain != "" {
            appDelegate.searchguest = ""
            self.dismiss(animated: true, completion: nil)
        }
        else{
            appDelegate.back1 = "book"
            appDelegate.searchguest = ""
            self.dismiss(animated: true, completion: nil)
//            self.navigationController!.popViewController(animated: true)
        }
        let  userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "countryname")
        userDefaults.synchronize()
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    func showPaymentType()
    {
        let errorAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        errorAlert.addAction(UIAlertAction(title: "Paypal", style: .default, handler: nil))
        errorAlert.addAction(UIAlertAction(title: "Stripe", style: .default, handler: nil))
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(errorAlert,animated: true)
    }
    
    /// Apply coupons
     func wsToApplycoupon()
     {
        var dicts = [String: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["s_key"] = self.sKey
        dicts["coupon_code"] = self.applyCoupon.text
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "apply_coupon", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false)
        {
            (responseDict) in
            print("applyCoupon",responseDict)
            if(responseDict.string("status_code") == "1")
            {
                self.hideCouponPopup()
                
                self.couponTitleName = self.lang.removeCoupon
                self.tableFilter.reloadData()
                 self.getPaymentInfo()
            }
            else
            {
                self.appDelegate.createToastMessage(responseDict.string("success_message"))
                self.applyCoupon.text = ""
            }
        }
    }
    
    func showCouponPopup(){
        self.view.addSubview(self.ApplyCouponMainView)
        self.view.bringSubviewToFront(self.ApplyCouponMainView)
        self.applyCoupon.text = ""
        self.ApplyCouponMainView.frame = self.view.frame
        self.ApplyCouponMainView.isHidden = false
    }
    
    func hideCouponPopup(){
        self.ApplyCouponMainView.isHidden = true
        self.ApplyCouponMainView.removeFromSuperview()
    }
    
    func wsToRemovecoupon()
    {
        var dicts = [String: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["s_key"] = self.sKey
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "remove_coupon", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false)
        {
            (responseDict) in
            print("applyCoupon",responseDict)
            if(responseDict.string("status_code") == "1")
            {
                self.couponTitleName = self.lang.applyCoupon
                self.tableFilter.reloadData()
                self.getPaymentInfo()
            }
            else
            {
                self.appDelegate.createToastMessage(responseDict.string("success_message"))
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("UITextdelegate method",textField.text)
        return true
    }
    
//    func configPaypalPayment() {
//
//
//        payPalConfig.acceptCreditCards = true
//               payPalConfig.merchantName = "Awesome Shirts, Inc."
//               payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//               payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//
//               payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//               payPalConfig.payPalShippingAddressOption = .payPal;
//               print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
//
//    }

    }


//extension BookingVC:CompleteBookingDelegate
//{
//    func onCompleteBooking(bookingType: String, paymentMode: String, payKey: String)
//    {
//
//            print("onStartToBooking")
//            let country = userDefaults.object(forKey: "countryname")
//            let countryCode = userDefaults.object(forKey: "countrycode")
//            print("selected country",country)
//            print("selected countryCode",countryCode)
//            var dicts = [String: Any]()
//            dicts["token"]          = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//            dicts["s_key"]          = self.getPaymentDetail.data.sKey
//            dicts["paymode"]        = paymentMode
//            dicts["message"]        = "Testing"
//            dicts["pay_key"]        = payKey
//            dicts["country"]        = countryCode
//            dicts["currency_code"]  = getPaymentDetail.data.paymentCurrency
//            dicts["booking_type"]   = bookingType
//
//            WebServiceHandler.sharedInstance.getToWebService(wsMethod: "complete_booking", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false)
//            {
//                (responseDict) in
//                if responseDict.string("status_code") == "1"
//                {
//                    self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
//
//
////                    self.dismiss(animated: true, completion: nil)
//                    self.dismiss(animated: true, completion: {
//
//                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 1)
//                    })
//
//
//                }
//                else
//                {
//                    self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
//                }
//            }
//    }
//
//}

extension BookingVC: AfterPaymentDelegate {
    func afterPayment(paymentKey: String) {
        let countryCode = userDefaults.string(forKey: "countrycode")
        if countryCode != nil {
            self.paymentIntStripeID = paymentKey
          self.Booking("stripe", String(describing: countryCode!), bookingType: "instant_book")
        }
    }
}

class CellBooking: UITableViewCell
{
    @IBOutlet var lblCheckInDate: UILabel!
    @IBOutlet var lblCheckOutDate: UILabel!
    @IBOutlet var lblNightVal: UILabel!
    @IBOutlet var lblGuestVal: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblTotal: UILabel!
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
    @IBOutlet weak var rulesButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var applyCouponPopup: UIButton!
    
    @IBOutlet weak var steps_LeftLbl: UILabel!
    
    @IBOutlet weak var promoLbl: UILabel!
    
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    

    
    func setPrePaymentDetails(preModel : PaymentDetailData)
    {
        let dateFormater = DateFormatter()
        dateFormater.locale = Language.getCurrentLanguage().locale
        dateFormater.dateFormat = "dd-MM-yyyy"
        
        print("start time",preModel.data.bookingDateTimes.startTime)
         lblCheckInDate.text = dateConverstion(preModel.data.bookingDateTimes.startDate) + "\n\(timeConvertions(preModel.data.bookingDateTimes.startTime))" //as String
         lblCheckOutDate.text =  dateConverstion(preModel.data.bookingDateTimes.endDate) + "\n\(timeConvertions(preModel.data.bookingDateTimes.endTime))" //as String
        
         lblNightVal.text = preModel.data.totalHours.description
        let price = preModel.data.paymentTotal.description
        //lblNightVal.text = "100"
        //  lblPrice.text = price
       lblPrice.attributedText =  MakentSupport().attributedTextboldText(originalText: String(format:"%@ %@ %@",preModel.data.currencyCode,(preModel.data.currencySymbol).stringByDecodingHTMLEntities, price) as NSString, boldText: String(format:"%@ %@",(preModel.data.currencySymbol as String).stringByDecodingHTMLEntities, price) as String, fontSize: 22.0)
        
    }
    
    func timeConvertions (_ time : String) -> String
      {
         // let dateAsString = "6:35 PM"
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH:mm:ss"
          let date = dateFormatter.date(from: time)
          
          dateFormatter.dateFormat = "h:mm a"
          let date24 = dateFormatter.string(from: date!)
          
          return date24
      }
    
    func dateConverstion (_ date : String) -> String
    {
        let inputFormatter = DateFormatter()
               inputFormatter.dateFormat = "yyyy-MM-d"
               let showDate = inputFormatter.date(from: date)
               inputFormatter.dateFormat = "EEE d-MM-yyyy"
               let resultStartDate = inputFormatter.string(from: showDate!)
               print("resulting",resultStartDate)
        
        return resultStartDate;
    }
    
}

//extension BookingVC :  PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate{
//
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }
//
//
//    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//        print("PayPal Payment Cancelled")
////        resultText = ""
//        //successView.isHidden = true
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
//         print("PayPal Payment Success !")
//               paymentViewController.dismiss(animated: true, completion: { () -> Void in
//                   // send completed confirmaion to your server
//                   print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
//                   let response = completedPayment.confirmation as! JSONS
//                   print("response",response.json("response").string("id"))
//                self.onCompleteBooking(bookingType: "instant_book", paymentMode: "paypal", payKey: response.json("response").string("id"))
//
//                   self.resultText = completedPayment.description
//
//               })
//    }
//
//    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
//        print("PayPal Future Payment Authorization Canceled")
//        //successView.isHidden = true
//        futurePaymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable : Any]) {
//        print("PayPal Future Payment Authorization Success!")
//        // send authorization to your server to get refresh token.
//        futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
//            self.resultText = futurePaymentAuthorization.description
//            //self.showSuccess()
//        })
//    }
//
//    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
//         profileSharingViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]) {
//        print("PayPal Profile Sharing Authorization Success!")
//
//        // send authorization to your server
//        profileSharingViewController.dismiss(animated: true, completion: { () -> Void in
//            self.resultText = profileSharingAuthorization.description
//            //self.showSuccess()
//        })
//    }
//
//
//}







