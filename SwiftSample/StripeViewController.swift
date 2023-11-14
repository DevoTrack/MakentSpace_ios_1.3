//
//  StripeViewController.swift
//  Makent
//
//  Created by trioangle on 11/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import UserNotifications

class StripeViewController: UIViewController, UITextFieldDelegate, STPAuthenticationContext {
    
    @IBOutlet weak var cardImage: UIImageView!

    @IBOutlet weak var cardNumber: FormTextField!
    
    @IBOutlet weak var cardExpDate: FormTextField!
   
    @IBOutlet weak var cardCVC: FormTextField!
    
    @IBOutlet weak var billingFirstName: UITextField!
    
    @IBOutlet weak var billingLastName: UITextField!
    
    @IBOutlet weak var billingPostCode: UITextField!
    
    @IBOutlet weak var paymentNext: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var cvvView: UIView!
    
    @IBOutlet weak var expView: UIView!
    
    @IBOutlet weak var cardImg: UIImageView!
    
    var sKey:String = ""
    var paymentCurrenncy:String = ""
    var paymentCountryCode:String = ""
    var paymentAmount:String   = ""
    var stripePublishKey:String = ""
    var clientScrectId:String  = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var afterPaymentDelegate: AfterPaymentDelegate?
    
    func authenticationPresentingViewController() -> UIViewController
    {
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //// Card number initialize
        cardNumber.inputType = .integer
        cardNumber.formatter = CardNumberFormatter()
        cardNumber.placeholder = "Card Number"
        print("stripekey",self.stripePublishKey)
        // Stripe Configuration
        Stripe.setDefaultPublishableKey(self.stripePublishKey)
        
        self.backButton()
        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        cardNumber.inputValidator = inputValidator
        
        /// card exp date initialize
        cardExpDate.inputType = .integer
        cardExpDate.formatter = CardExpirationDateFormatter()
        cardExpDate.placeholder = "Expiration Date"
        
        var cardExpValidation = Validation()
        cardExpValidation.minimumLength = 1
        let cardExpinputValidator = CardExpirationDateInputValidator(validation: cardExpValidation)
        cardExpDate.inputValidator = cardExpinputValidator
        
        /// card cvc initialize
        cardCVC.inputType = .integer
        cardCVC.placeholder = "CVC"
        
        var cardCVCvalidation = Validation()
        cardCVCvalidation.maximumLength = "CVC".count
        cardCVCvalidation.minimumLength = "CVC".count
        cardCVCvalidation.characterSet = NSCharacterSet.decimalDigits
        let cardCVCinputValidator = InputValidator(validation: cardCVCvalidation)
        cardCVC.inputValidator = cardCVCinputValidator
        
        paymentNext.backgroundColor = UIColor.appGuestThemeColor
        cardView.setBottomBorder()
        expView.setBottomBorder()
        cvvView.setBottomBorder()

        paymentNext.addTap {
            self.stripePaymentAction()
        }
    }
    
    
    func backButton() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "Back")
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTap {
            self.dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController(animated: true)
        }
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("UITextdelegate method")
        
        if textField == cardNumber
        {
            print("card number")
            if range.location == 19
            {
                print("Finished the length")
                print("card type", self.validateCardType(testCard: textField.text!))
                return false
            }
            else
            {
                self.cardImg.image = (UIImage(named: "card_basic.png"))
                print("Else part")
            }
        }
        return true
    }
    
    func stripePaymentAction() {
 
        if cardNumber.text! == ""
        {
            self.appDelegate.createToastMessage(self.sharedAppDelegete.lang.pleaseEnterCardNumber)
        }
        else if cardExpDate.text! == ""
        {
            self.appDelegate.createToastMessage(self.sharedAppDelegete.lang.pleaseEnterExpirationDate)
        }
        else if cardCVC.text! == ""
        {
            self.appDelegate.createToastMessage(self.sharedAppDelegete.lang.pleaseEnterCvcNumber)
        }
        else if (billingFirstName.text! == "")
        {
            self.appDelegate.createToastMessage(self.sharedAppDelegete.lang.pleaseEnterFirstName)
        }
        else if (billingLastName.text! == "")
        {
            self.appDelegate.createToastMessage(self.sharedAppDelegete.lang.pleaseEnterLastName)
        }
        else if (billingPostCode.text! == "")
        {
            self.appDelegate.createToastMessage(self.sharedAppDelegete.lang.pleaseEnterPostCode)
        }
        else{
        
        let usercardParams = STPCardParams()
        usercardParams.name = "\(billingFirstName.text!)\(billingLastName.text!)"
        usercardParams.number = cardNumber.text!.replacingOccurrences(of: " ", with: "")
        if  cardExpDate.text! != nil
        {
            usercardParams.expMonth = UInt(cardExpDate.text!.components(separatedBy: "/")[0])!
            usercardParams.expYear = UInt(cardExpDate.text!.components(separatedBy: "/")[1])!
        }
        usercardParams.cvc = cardCVC.text!
        
        //let sourceParams = STPSourceParams.cardParams(withCard: usercardParams)
        let cardParams = STPPaymentMethodCardParams(cardSourceParams: usercardParams)
        let billingDetails = STPPaymentMethodBillingDetails()
    
        // Fill in card, billing details
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        print("paymentMethodParams.",paymentMethodParams.image)
        
            STPAPIClient.shared.createPaymentMethod(with: paymentMethodParams) { paymentMethod, error in
            // Hold onto the paymentMethod for Step 4
            print("PaymentMethod",paymentMethod)
            var paramDict = [String:Any]()
            paramDict["token"]              = SharedVariables.sharedInstance.userToken
            paramDict["s_key"]              = self.sKey
            paramDict["currency_code"]      = self.paymentCurrenncy
            paramDict["amount"]             = self.paymentAmount
            paramDict["payment_method_id"]  = paymentMethod?.stripeId
            
            let urlString = "\(k_WebServerUrl)api/generate_stripe_key"
            MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
            Alamofire.request(urlString, method: .post, parameters: paramDict,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let JSON = response.result.value as? [String: Any] {
                        guard JSON.string("status_code") != "0" else {
                            MakentSupport().removeProgressInWindow(viewCtrl: self)
                            self.appDelegate.createToastMessage(JSON.string("success_message"), isSuccess: false)
                            return
                        }
                        self.clientScrectId = JSON.string("client_secret")
                        print("clientSecret",JSON.string("client_secret"))
                        let  paymentIntentParams = STPPaymentIntentParams(clientSecret: self.clientScrectId)
                        let paymentManager = STPPaymentHandler.shared()
                        
                        //                        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                        paymentIntentParams.paymentMethodParams = paymentMethodParams
                        paymentManager.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                            MakentSupport().removeProgressInWindow(viewCtrl: self)
                            switch (status) {
                            case .succeeded:
                                // Payment succeeded
                                print("Payment succeeded",status)
                                print("Payment model ", paymentIntent)
                                print("payment intent values",paymentIntent?.stripeId)
                                let paramDict = ["payKey": paymentIntent?.stripeId, "skey": self.sKey]
                                self.afterPaymentDelegate?.afterPayment(paymentKey: paymentIntent!.stripeId)
                                self.dismiss(animated: true, completion: nil)
//                                self.dismiss(animated: true, completion: {
//                                     NotificationCenter.default.post(name: Notification.Name("PaymentComplete"), object: nil, userInfo: paramDict)
//                                })
//                                self.complete_Booking(payKey: paymentIntent!.stripeId)
                                break
                            case .canceled:
                                // Handle cancel
                                print("Payment Handle cancel")
                                break
                            case .failed:
                                print("Payment Handle error", error?.localizedDescription)
                                // Handle error
                                break
                            }
                        }
                    }
                    break
                case .failure(let error):
                    print(error)
                }
            }
           
        }
      
      }
    }
    
    /// complete booking
    func complete_Booking(payKey : String)
    {
        print("onStartToBooking")
        var dicts = [String: Any]()
        dicts["token"]          = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["s_key"]          = self.sKey
        dicts["paymode"]        = "stripe"
        dicts["message"]        = "Testing"
        dicts["pay_key"]        = payKey
        dicts["country"]        = self.paymentCountryCode
        dicts["currency_code"]  = self.paymentCurrenncy
        dicts["booking_type"]   = "instant_book"
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "complete_booking", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false)
        {
            (responseDict) in
            if responseDict.string("status_code") == "1"
            {
                self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
                self.dismiss(animated: true){
//                    self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
                }
            }
            else
            {
                self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
            }
        }
    }

    func validateCardType(testCard: String) -> String {
        print("validate the card",testCard.replacingOccurrences(of: " ", with: ""))
        let regVisa = "^4[0-9]{12}(?:[0-9]{3})?$"
        let regMaster = "^5[1-5][0-9]{14}$"
        let regExpress = "^3[47][0-9]{13}$"
        let regDiners = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        let regDiscover = "^6(?:011|5[0-9]{2})[0-9]{12}$"
        let regJCB = "^(?:2131|1800|35\\d{3})\\d{11}$"
        
        let regVisaTest = NSPredicate(format: "SELF MATCHES %@", regVisa)
        let regMasterTest = NSPredicate(format: "SELF MATCHES %@", regMaster)
        let regExpressTest = NSPredicate(format: "SELF MATCHES %@", regExpress)
        let regDinersTest = NSPredicate(format: "SELF MATCHES %@", regDiners)
        let regDiscoverTest = NSPredicate(format: "SELF MATCHES %@", regDiscover)
        let regJCBTest = NSPredicate(format: "SELF MATCHES %@", regJCB)
        
        if regVisaTest.evaluate(with: testCard.replacingOccurrences(of: " ", with: ""))
        {
            self.cardImg.image = (UIImage(named: "card_visa.png"))
            return "Visa"
        }
        else if regMasterTest.evaluate(with: testCard.replacingOccurrences(of: " ", with: ""))
        {
            self.cardImg.image = (UIImage(named: "card_master.png"))
            return "MasterCard"
        }
        else if regExpressTest.evaluate(with: testCard.replacingOccurrences(of: " ", with: ""))
        {
             self.cardImg.image = (UIImage(named: "card_amex.png"))
            return "American Express"
        }
        else if regDinersTest.evaluate(with: testCard.replacingOccurrences(of: " ", with: ""))
        {
            self.cardImg.image = (UIImage(named: "card_diner.png"))
            return "Diners Club"
        }
        else if regDiscoverTest.evaluate(with: testCard.replacingOccurrences(of: " ", with: ""))
        {
            self.cardImg.image = (UIImage(named: "card_discover.png"))
            return "Discover"
        }
        else if regJCBTest.evaluate(with: testCard.replacingOccurrences(of: " ", with: ""))
        {
            self.cardImg.image = (UIImage(named: "card_jcp.png"))
            return "JCB"
        }
        self.cardImg.image = (UIImage(named: "card_basic.png"))
        return ""
        
    }
}

extension UIView {
    func setBottomBorder() {
       // self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
