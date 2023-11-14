/**
* MakentAPICalls.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit

class MakentAPICalls: NSObject {
    var userDefaults = UserDefaults.standard

    //MARK: Login API Calls
    
    func GetRequest(_ dict: [AnyHashable: Any], methodName : NSString, forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        let sreq = MakentServiceRequest()
        sreq.getBlockServerResponseForparam(dict, method: methodName, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }
    
    func PostRequest(somedata:Data, methodName : NSString,urlLink:URL, forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        let sreq = MakentServiceRequest()
        sreq.postRequestWithUrlAndData(somedata: somedata, method: methodName,url: urlLink, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }

    
    
    //MARK: SignUp API Calls
    func SignUp(_ dict: [AnyHashable: Any], forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        let sreq = MakentServiceRequest()
        sreq.getBlockServerResponseForparam(dict, method: APPURL.METHOD_SIGNUP as NSString, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }
    
    //MARK: ForgotPassword API Calls
    func ForgotPassword(_ dict: [AnyHashable: Any], forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        let sreq = MakentServiceRequest()
        sreq.getBlockServerResponseForparam(dict, method: APPURL.METHOD_FORGOT_PASSWORD as NSString, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }
    
    func EmailValidation(_ dict: [AnyHashable: Any], forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        let sreq = MakentServiceRequest()
        sreq.getBlockServerResponseForparam(dict, method: APPURL.METHOD_EMAIL_VALIDATION as NSString, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }
    
    func ExploreRoomList(_ dict: [AnyHashable: Any], forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        //        if !self.isNetworkRechable() {
        //            return
        //        }
        let sreq = MakentServiceRequest()
        sreq.getBlockServerResponseForparam(dict, method: APPURL.METHOD_EXPLORE as NSString, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }

    func RoomDetails(_ dict: [AnyHashable: Any], forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        //        if !self.isNetworkRechable() {
        //            return
        //        }
        let sreq = MakentServiceRequest()
        sreq.getBlockServerResponseForparam(dict, method: APPURL.METHOD_ROOM_DETAIL as NSString, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }
    
    func showNotification() {
        
    }
    
}
