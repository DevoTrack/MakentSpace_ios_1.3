//
//  WebServiceHandler.swift
//  makent
//
//  Created by Vignesh Palanivel on 09/03/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit
import Alamofire

typealias APIResponse = (_ success: JSONS?,_ failure: Error?) -> Void
enum APIMethodsEnum : String{
    case language
    case addNewRoom = "new_add_room"
    case roomBedDetails = "room_bed_details"
    case updateBedRooms = "update_bed_detail"
    case basicStepItems = "basics_step_items"
    case spaceListDetails = "space_listing_details"
    case updateSpace = "update_space"
    case updateCalendar = "update_calendar"
    case payout = "add_payout_perference"
    //case createSpace = "create_space"
    case deleteImage = "delete_image"
    case updateImageDesc = "update_image_description"
    case listingSpace = "listing"
    case imageUpload = "space_image_upload"
    case setupItems = "setup_step_items"
    case deleteAccount = "delete_account"
}
class WebServiceHandler: NSObject {

    static var sharedInstance = WebServiceHandler()
    
    static var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let appDelegatee = UIApplication.shared.delegate as! AppDelegate
    func getWebService(wsMethod : APIMethodsEnum,
                       params : [String: Any] = [String:Any](),
                       response : APIResponse?){
        UIApplication.shared.beginIgnoringInteractionEvents()
        var parameter = Parameters()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        for (key,value) in params{
            parameter[key] = value
        }
        Alamofire.request("\(k_APIServerUrl)\(wsMethod.rawValue)",
            method: .get,
            parameters: parameter,
            encoding: URLEncoding.default,
            headers: nil).responseJSON { (responseReturned) in
                
                print("Å -  URL: \(String(describing: responseReturned.request?.url))")
                UIApplication.shared.endIgnoringInteractionEvents()
                switch responseReturned.result{
                    
                case .success(let value):
                    
//                    if !responsDict.string("refresh_token").isEmpty {
//                        Constants().STOREVALUE(value: responsDict.string("refresh_token") as NSString, keyname: USER_ACCESS_TOKEN)
//                        SharedVariables.sharedInstance.userToken = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
//                    }
                    if let _response = response{
                        _response(value as? JSONS,nil)
                    }
                    
                case .failure(let error):
                    if responseReturned.response?.statusCode == 401{
                        self.appDelegatee.createToastMessage(self.lang.cont_Admin, isSuccess: false)
                        WebServiceHandler.appDelegate.logoutFinish()
                        return
                    }else{
                        
                    }
                    if let _response = response{
                        _response(nil,error)
                    }
                    
                }
        }
    }
    
    func fileUpload(endUrl : APIMethodsEnum,
                    params : [String: Any] = [String:Any](),imageData: Data?,
                    response : APIResponse?){
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                multipartFormData.append(imageData!, withName: "image", fileName: "image.png", mimeType: "image/png")
                for (key, val) in params {
                    multipartFormData.append("\(val)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
        },
            to: "\(k_APIServerUrl)\(endUrl.rawValue)",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { apiUploadResponse in
                        switch apiUploadResponse.result{
                        case .success(let value):
                            if let _response = response{
                                _response(value as? JSONS,nil)
                            }
                        case .failure(let error):
                            if apiUploadResponse.response?.statusCode == 401{
                                self.appDelegatee.createToastMessage(self.lang.cont_Admin, isSuccess: false)
                                WebServiceHandler.appDelegate.logoutFinish()
                                return
                            }else{
                                
                            }
                            if let _response = response{
                                _response(nil,error)
                            }
                            
                        }
                        
                        
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
       
    }
    
    func postWebService(wsMethod : APIMethodsEnum,
                        params : [String: Any] = [String:Any](),
                        response : APIResponse?){
        
        var param = Parameters()
        let headers: HTTPHeaders = [
            "Authorization": "XXXXXX",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        //param["language"] = Language.getCurrentLanguage().rawValue
        for (key,value) in params{
            param[key] = value
        }
        Alamofire.request("\(k_APIServerUrl)\(wsMethod.rawValue)", method: .post, parameters: param,encoding: JSONEncoding.default, headers: headers).responseJSON {
            Returnresponse in
            print("Å -  URL: \(String(describing: Returnresponse.request?.url))\(param)")
            switch Returnresponse.result {
            case .success(let value):
                print(Returnresponse.result.value)
                
                if let _response = response{
                   _response(value as? JSONS,nil)
                }
                
                   //_response(value as? JSONS,nil)
            
                break
            case .failure(let error):
                if Returnresponse.response?.statusCode == 401{
                  self.appDelegatee.createToastMessage(self.lang.cont_Admin, isSuccess: false)
                  WebServiceHandler.appDelegate.logoutFinish()
                   return
                }
                if let _response = response{
                    _response(nil,error)
                }
                print(error)
            }
        }
        
    }
    
    func postWebSeriveAlamofire(wsMethod:String, paramDict: [String:Any], viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
           MakentSupport().showProgress(viewCtrl: viewController, showAnimation: true)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else if isToStopInteraction {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        
        let headers = ["Content-Type":"Application/json"]
        //        Alamofire.request("\(k_BaseURL)\(wsMethod)", method: .post, parameters: paramDict, encoding: JSONEncoding.default)
        
        Alamofire.request("\(k_APIServerUrl)\(wsMethod)", method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: headers)
            
            //        Alamofire.request("\(k_BaseURL)\(wsMethod)", method: .post, parameters: paramDict)
            //            .validate()
            .responseJSON { response in
                if isToShowProgress {
                   MakentSupport().removeProgress(viewCtrl: viewController)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                else if isToStopInteraction {
                    UIApplication.shared.beginIgnoringInteractionEvents()
                }
                switch response.result {
                case .success:
                    print("Validation Successful")
                    print(response.result.value!)
                    let responseDict = response.result.value! as! [String : Any]
                    if (responseDict.statusCode ) == 0 && ((responseDict.statusMessage) == "Inactive User" || (responseDict.statusMessage) == "The token has been blacklisted" ||  responseDict.statusMessage == "User not found") {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "k_LogoutUser"), object: nil)
                    }
                    else {
                        complete(response.result.value! as! [String : Any])
                    }
                    
                case .failure(let error):
                    print(error)
                    if error._code == 4 {
                        WebServiceHandler.appDelegate.createToastMessage("We are having trouble fetching the menu. Please try again.", isSuccess: false)
                    }
                    else {
                        WebServiceHandler.appDelegate.createToastMessage(error.localizedDescription, isSuccess: false)
                        
                    }
                    
                }
        }
    }
    
    func getWebService(wsMethod:String, paramDict: [String:Any], viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
            MakentSupport().showProgress(viewCtrl: viewController, showAnimation: true)
        }
        else if isToStopInteraction {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        var params = Parameters()
        params["language"] = Language.getCurrentLanguage().rawValue
        for (key,value) in paramDict{
            params[key] = value
        }
       
//        Alamofire.request("\(k_APIServerUrl)\(wsMethod)", method: .post, parameters: params)
        let headers = ["Content-Type":"application/json"]
        //        Alamofire.request("\(k_BaseURL)\(wsMethod)", method: .post, parameters: paramDict, encoding: JSONEncoding.default)
        
        Alamofire.request("\(k_APIServerUrl)\(wsMethod)", method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: nil)
            .validate()
                .responseJSON { response in
                    if isToShowProgress {
                        MakentSupport().removeProgress(viewCtrl: viewController)
                    }
                    else {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                     print("Å \(response.request?.url)")
                    switch response.result {
                    case .success:
                       
                        print("Validation Successful")
                        print(response.result.value!)
                        complete(response.result.value! as! [String : Any])
                        
                    case .failure(let error):
                        print(error)
                        if response.response?.statusCode == 401 {
                            self.appDelegatee.createToastMessage(self.lang.cont_Admin, isSuccess: false)
                            WebServiceHandler.appDelegate.logoutFinish()
                            return
                        }
                        MakentSupport().removeProgress(viewCtrl: viewController)
                        WebServiceHandler.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: true)
                    }
            }
        }
    
    
    
    
    func getToWebService(wsMethod:String, paramDict: [String:Any], viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
            
//            MakentSupport().showProgress(viewCtrl: viewController, showAnimation: true)
            MakentSupport().showProgressInWindow(viewCtrl: viewController, showAnimation: true)
        }
        if isToStopInteraction {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        var params = Parameters()
        params["language"] = Language.getCurrentLanguage().rawValue
        for (key,value) in paramDict{
            params[key] = value
        }
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request("\(k_APIServerUrl)\(wsMethod)", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                print("URL: \(String(describing: response.request?.url!))")
                if isToShowProgress {
//                    MakentSupport().removeProgress(viewCtrl: viewController)
                    MakentSupport().removeProgressInWindow(viewCtrl: viewController)
                }
                 if isToStopInteraction {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                switch response.result {
                case .success:
                    print("Validation Successful")
                    print(response.result.value!)
                    if let responsDict = response.result.value as? JSONS{
                        if responsDict.statusMessage == "token_invalid" || responsDict.statusMessage == "user_not_found" || responsDict.statusMessage == "Authentication Failed"
                        {
                            WebServiceHandler.appDelegate.logOutDidFinish()
                            return
                        }
                        if !responsDict.string("refresh_token").isEmpty {
                            Constants().STOREVALUE(value: responsDict.string("refresh_token") as NSString, keyname: APPURL.USER_ACCESS_TOKEN)
                            SharedVariables.sharedInstance.userToken = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
                        }
                        complete(responsDict)
                    }
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401{
                        self.appDelegatee.createToastMessage(self.lang.cont_Admin, isSuccess: false)
                        WebServiceHandler.appDelegate.logoutFinish()
                        return
                    }
                    if error._code == 4 {
                        WebServiceHandler.appDelegate.createToastMessage("We are having trouble fetching the menu. Please try again.", isSuccess: false)
                    }
                    else {
                        WebServiceHandler.appDelegate.createToastMessage(error.localizedDescription, isSuccess: false)
                        
                    }
                }
        }
    }
    
    func getThirdPartyAPIWebService(wsURL:String, paramDict: [String:Any], viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
            MakentSupport().showProgressInWindow(viewCtrl: viewController, showAnimation: true)
            
            
        }
         if isToStopInteraction {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        Alamofire.request("\(wsURL)", method: .get, parameters: paramDict)
            .validate()
            .responseJSON { response in
                if isToShowProgress {
                    MakentSupport().removeProgressInWindow(viewCtrl: viewController)
                    
                }
                if isToStopInteraction{
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                switch response.result {
                case .success:
                    print("Validation Successful")
                    print(response.result.value!)
                    complete(response.result.value! as! [String : Any])
                case .failure(let error):
                    print(error)
                    if error._code == 4 {
                        WebServiceHandler.appDelegate.createToastMessage("We are having trouble fetching the menu. Please try again.", isSuccess: false)
                    }
                    else {
                        WebServiceHandler.appDelegate.createToastMessage(error.localizedDescription, isSuccess: false)
                        
                    }
                }
        }
    }
    
}

