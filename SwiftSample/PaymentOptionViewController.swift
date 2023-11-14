//
//  PaymentOptionViewController.swift
//  Makent
//
//  Created by trioangle on 09/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

//import UIKit
//import Stripe
//import UserNotifications
//
//protocol CompleteBookingDelegate
//{
//    func onCompleteBooking(bookingType : String, paymentMode : String,payKey : String)
//}
//
//class PaymentOptionViewController: UIViewController, STPAuthenticationContext, PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {
//
//    @IBOutlet weak var paypalLabel: UILabel!
//
//    @IBOutlet weak var stripeLabel: UILabel!
//
//    @IBOutlet weak var cancelLabel: UILabel!
//
//    @IBOutlet weak var blankView: UIView!
//
//    var sKey:String = ""
//    var payKey:String = ""
//    var spaceName : String = ""
//    var paymentCurrenncy:String = ""
//    var paymentCurrencySym : String = ""
//    var paymentCountryCode:String = ""
//    var paymentAmount:String    = ""
//    var stripePubKey:String     = ""
//    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
//    var completeDelegate:CompleteBookingDelegate?
//
//    // PayPalPaymentDelegate
//    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//        print("PayPal Payment Cancelled")
//        resultText = ""
//        //successView.isHidden = true
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
//        print("PayPal Payment Success !")
//        paymentViewController.dismiss(animated: true, completion: { () -> Void in
//            // send completed confirmaion to your server
//            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
//            let response = completedPayment.confirmation as! JSONS
//            print("response",response.json("response").string("id"))
//            self.completeDelegate?.onCompleteBooking(bookingType: "instant_book", paymentMode: "paypal", payKey: response.json("response").string("id"))
//
//            self.resultText = completedPayment.description
//
//        })
//    }
//
//    // MARK: Future Payments
//    @IBAction func authorizeFuturePaymentsAction(_ sender: AnyObject) {
//        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
//        present(futurePaymentViewController!, animated: true, completion: nil)
//    }
//
//    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
//        print("PayPal Future Payment Authorization Canceled")
//        //successView.isHidden = true
//        futurePaymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
//        print("PayPal Future Payment Authorization Success!")
//        // send authorization to your server to get refresh token.
//        futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
//            self.resultText = futurePaymentAuthorization.description
//            //self.showSuccess()
//        })
//    }
//
//    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
//        print("PayPal Profile Sharing Authorization Canceled")
//        //successView.isHidden = true
//        profileSharingViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable: Any]) {
//        print("PayPal Profile Sharing Authorization Success!")
//
//        // send authorization to your server
//        profileSharingViewController.dismiss(animated: true, completion: { () -> Void in
//            self.resultText = profileSharingAuthorization.description
//            //self.showSuccess()
//        })
//    }
//
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }
//
//    var environment:String = PayPalEnvironmentNoNetwork {
//        willSet(newEnvironment) {
//            if (newEnvironment != environment) {
//                PayPalMobile.preconnect(withEnvironment: newEnvironment)
//            }
//        }
//    }
//
//    var resultText = "" // empty
//    var payPalConfig = PayPalConfiguration() // default
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .clear
//
//        /// Receive the values
//   print("paymentOptions",self.sKey,"payKey",self.payKey,"paymentCurrency",self.paymentCurrenncy,"paymentCountryCode",self.paymentCountryCode,"paymentAmount",self.paymentAmount,"paymentStripe",self.stripePubKey)
//
//        payPalConfig.acceptCreditCards = true
//        payPalConfig.merchantName = "Awesome Shirts, Inc."
//        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//
//        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//        payPalConfig.payPalShippingAddressOption = .payPal;
//        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
//
//        paypalLabel.addTap {
////            self.payPalIntegrations()
//        }
//        self.view.backgroundColor = .white
//        self.addBackButton()
//        stripeLabel.addTap {
//            let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "StripeViewController") as! StripeViewController
//            contactView.sKey    = self.sKey
//            contactView.paymentCurrenncy = self.paymentCurrenncy
//            contactView.paymentCountryCode = self.paymentCountryCode
//            contactView.paymentAmount  = self.paymentAmount
//            contactView.stripePublishKey = self.stripePubKey
//            let navController = UINavigationController(rootViewController: contactView)
//            navController.modalPresentationStyle = .fullScreen
//            self.present(navController, animated:true, completion: nil)
//        }
//
//        cancelLabel.addTap {
//             self.dismiss(animated: true, completion: nil)
//        }
//
//
//
//    }
//
//
//
//    func payPalIntegrations()
//    {
//
//        print("CurrencySym:",self.paymentCurrencySym)
//          let item1 = PayPalItem(name: self.spaceName, withQuantity: 1, withPrice: NSDecimalNumber(string: self.paymentAmount), withCurrency: self.paymentCurrencySym, withSku: "")
//
//
//        let items = [item1]
//        let subtotal = PayPalItem.totalPrice(forItems: items)
//
//        print("subtotal amount",subtotal,"Payment Amount",self.paymentAmount)
//
//        let shipping = NSDecimalNumber(string: "0.00")
//        let tax = NSDecimalNumber(string: "0.00")
//        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
//
//        let total = subtotal.adding(shipping).adding(tax)
//        print("total amount",total)
//        let payment = PayPalPayment(amount: total, currencyCode: self.paymentCurrenncy, shortDescription: self.spaceName, intent: .sale)
//
//        payment.items = items
//        payment.paymentDetails = paymentDetails
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
//
//    // complete booking
//    func complete_Booking(paymentMode : String,payKey : String)
//    {
//         print("onStartToBooking")
//         var dicts = [String: Any]()
//         dicts["token"]          = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//         dicts["s_key"]          = self.sKey
//         dicts["paymode"]        = paymentMode
//         dicts["message"]        = "Testing"
//         dicts["pay_key"]        = payKey
//         dicts["country"]        = self.paymentCountryCode
//         dicts["currency_code"]  = self.paymentCurrenncy
//         dicts["booking_type"]   = "instant_book"
//
//         WebServiceHandler.sharedInstance.getToWebService(wsMethod: "complete_booking", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false)
//                    {
//                        (responseDict) in
//                        if responseDict.string("status_code") == "1"
//                        {
//                        self.dismiss(animated: true, completion: nil)
//                        self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
//
//                            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
//
//                        }
//                        else
//                        {
//                            self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
//                        }
//                    }
//        }
//}
