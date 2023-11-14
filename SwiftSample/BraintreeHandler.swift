//
//  BraintreeHandler.swift
//  Makent
//
//  Created by Trioangle technologies on 30/09/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.

import Foundation
import Braintree
import BraintreeDropIn


enum BTErrors : Error{
    case clientNotInitialized
    case clientCancelled
}
extension BTErrors : LocalizedError{
    var errorDescription: String?{
        return self.localizedDescription
    }
    var localizedDescription: String{
        switch self {
        case .clientNotInitialized:
            return "Client not initialized" //.localize
        case .clientCancelled:
            return "Cancelled" //.localize
        }
    }
}
protocol BrainTreeProtocol {
    func initalizeClient(with id : String)
    func authenticatePaymentUsing(_ view : UIViewController,
                                  for amount : Double,
                                  result: @escaping BrainTreeHandler.BTResult)
    func authenticatePaypalUsing(_ view : UIViewController,
                                  for amount : Double,
                                  currecyCode : String,
                                  result: @escaping BrainTreeHandler.BTResult)
}

class BrainTreeHandler : NSObject{
    static var ReturnURL  : String  {
        let bundle = Bundle.main
        
        return "\(bundle.bundleIdentifier ?? "com.trioangle.space")" + ".payments"
    }
    class func isBrainTreeHandleURL(_ url: URL,options: [UIApplication.OpenURLOptionsKey : Any] ) -> Bool{
        if url.scheme?
            .localizedCaseInsensitiveCompare(BrainTreeHandler.ReturnURL) == .orderedSame {
            return BTAppContextSwitcher.handleOpenURL(url)
        }
        return false
    }
    typealias BTResult = (Result<BTPaymentMethodNonce, Error>) -> Void
    static var `default` : BrainTreeProtocol = {
        BrainTreeHandler()
    }()
    
    
    
    var client : BTAPIClient?
    var hostView : UIViewController?
    var result : BTResult?
    var clientToken : String?
    private override init(){
        super.init()
        
    }
    
}
//MARK:- BrainTreeProtocol
extension BrainTreeHandler : BrainTreeProtocol{
    
    func initalizeClient(with id : String){
        
        self.clientToken = id
        self.client = BTAPIClient(authorization: id)
        BTAppContextSwitcher.setReturnURLScheme(BrainTreeHandler.ReturnURL)
    }
    
    func authenticatePaypalUsing(_ view: UIViewController,
                                  for amount: Double,
                                  currecyCode currencyCode: String,
                                  result: @escaping BrainTreeHandler.BTResult) {
        guard let currentClient = self.client else{
            result(.failure(BTErrors.clientNotInitialized))
            return
        }
        self.hostView = view
        self.result = result
        let paypalDriver = BTPayPalDriver(apiClient: currentClient)
//        paypalDriver.viewControllerPresentingDelegate = self
//        paypalDriver.appSwitchDelegate = self
        
        let request = BTPayPalCheckoutRequest(amount: amount.description)
        request.currencyCode = currencyCode
        paypalDriver.requestOneTimePayment(request) { (payPalAccountNonce, error) in
            guard let paypaNonce = payPalAccountNonce else{
                result(.failure(error ?? BTErrors.clientCancelled))
                return
            }
            print(paypaNonce.email ?? "")
            print(paypaNonce.firstName ?? "")
            print(paypaNonce.nonce)
            result(.success(paypaNonce))
        }
    }
    func authenticatePaymentUsing(_ view : UIViewController,
                                  for amount : Double,
                  result: @escaping BTResult) {
        guard let currentClientToken = self.clientToken else{
            result(.failure(BTErrors.clientNotInitialized))
            return
        }
        self.hostView = view
        self.result = result
        
        let user = self.getCurrentUserData()
        let request = BTDropInRequest()
//        request.threeDSecureVerification = true
        
        let threeDSecureRequest = BTThreeDSecureRequest()
        
        threeDSecureRequest.amount = NSDecimalNumber(value: amount)
        threeDSecureRequest.email = user.email ?? "test@email.com"
//        SharedVariables.sharedInstance.
        threeDSecureRequest.versionRequested = .version2
        
        let address = BTThreeDSecurePostalAddress()
        address.givenName = user.first_name ?? "Albin" // ASCII-printable characters required, else will throw a validation error
        address.surname = user.last_name ?? "MrngStar" // ASCII-printable characters required, else will throw a validation error
        address.phoneNumber = user.phone_number ?? "123456"
    
       
        threeDSecureRequest.billingAddress = address
//        if #available(iOS 13.0, *) {
//            BTUIKAppearance.sharedInstance().colorScheme = .dynamic
//        } else {
//            // Fallback on earlier versions
//        }
        // Optional additional information.
        // For best results, provide as many of these elements as possible.
        let info = BTThreeDSecureAdditionalInformation()
        info.shippingAddress = address
        threeDSecureRequest.additionalInformation = info
        
        let dropInRequest = BTDropInRequest()
//        dropInRequest.threeDSecureVerification = true
        dropInRequest.threeDSecureRequest = threeDSecureRequest
        
        dropInRequest.venmoDisabled = true
        dropInRequest.applePayDisabled = true
        dropInRequest.vaultCard = true
        dropInRequest.vaultManager = true
        
        let _dropIn = BTDropInController(authorization: currentClientToken, request: dropInRequest) { (controller, result, error) in
            if let btError = error {
                // Handle error
                print(dump(btError))
                self.result?(.failure(btError))
                self.dismissPresentedView()
            } else if (result?.isCanceled == true) {
                // Handle user cancelled flow
                
                self.result?(.failure(BTErrors.clientCancelled))
                self.dismissPresentedView()
            } else if let nonce = result?.paymentMethod{
//                SharedVariables.sharedInstance.btType = result?.paymentOptionType.rawValue ?? 0
                self.result?(.success(nonce))
            
                //result?.paymentOptionType.rawValue
                // Use the nonce returned in `result.paymentMethod`
            }
            
            controller.presentedViewController?.dismiss(animated: true, completion: nil)
            controller.dismiss(animated: true, completion: nil)
        }
        guard let dropIn = _dropIn else{return}
        view.present(dropIn, animated: true, completion: nil)
    }
}
//MARK:- BTDropInViewControllerDelegate
extension BrainTreeHandler : BTDropInControllerDelegate{
    func reloadDropInData() {
        
    }
    
    func editPaymentMethods(_ sender: Any) {
        
    }
    
    func drop(_ viewController: BTDropInController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        viewController.presentedViewController?.dismiss(animated: true, completion: nil)
        self.result?(.success(paymentMethodNonce))
        self.dismissPresentedView()
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInController) {
        viewController.presentedViewController?.dismiss(animated: true, completion: nil)
        self.result?(.failure(BTErrors.clientCancelled))
        self.dismissPresentedView()
    }
    
    
}
//MARK:- UDF
extension BrainTreeHandler {
    @objc func userDidCancelPayment() {
        self.result?(.failure(BTErrors.clientCancelled))
        self.dismissPresentedView()
    }
    
    func dismissPresentedView(){
        self.hostView?.dismiss(animated: true, completion: nil)
    }
    func getCurrentUserData() -> (
        first_name : String?,
        last_name : String?,
        email : String?,
        phone_number : String?
        ){
            if let data = UserDefaults.standard.value(forKey: "user_data") as? JSONS{
                let firstName = data["user_first_name"] as? String
                let lastName = data["user_last_name"] as? String
                let email = data["email"] as? String
                let mobileNumber = data.string("mobile_number").isEmpty ? nil : data.string("mobile_number")
                
                return(firstName,
                lastName,
                email,
                mobileNumber)
            }
            
            return (nil,nil,nil,nil)
    }
}
/*
 
 let dropIn = BTDropInViewController(apiClient: currentClient)
 dropIn.delegate = self
 dropIn.paymentRequest = request
 dropIn.navigationItem
 .leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem
 .SystemItem.cancel,
 target: self,
 action: #selector(self.userDidCancelPayment))
 
 let navigationController = UINavigationController(rootViewController: dropIn)
 navigationController.navigationBar.barStyle = .default
 navigationController.navigationBar.tintColor = .ThemeMain
 view.present(navigationController, animated: true, completion: nil)
 */
extension BrainTreeHandler : BTViewControllerPresentingDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    
}
//Compare to goferjek
//extension BrainTreeHandler : BTAppSwitchDelegate{
//    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
//
//    }
//
//    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
//
//    }
//
//    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
//
//    }
//
//
//}
