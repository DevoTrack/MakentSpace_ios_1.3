/**
* MakentServiceRequest.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import Alamofire

class MakentServiceRequest: NSObject {
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let appDelegatee = UIApplication.shared.delegate as! AppDelegate
    //MARK: API REQUEST - GET METHOD
    func getBlockServerResponseForparam(_ params: [AnyHashable: Any], method: NSString, withSuccessionBlock successBlock: @escaping (_ response: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void)
    {
//        if method != "experience_pre_payment" {
            let buildURLString = (MakentCreateUrl().serializeURL(params: params as NSDictionary, methodName: method) as NSString)
            var escapedAddress = String()
            var myURL = NSURL()
      
            escapedAddress = buildURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            myURL = NSURL(string:escapedAddress)!
        
            let trimmedURL = escapedAddress.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(trimmedURL,
                          method: HTTPMethod.get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON { (response) in
                            print("Å URL : \(response.request?.url?.description ?? trimmedURL)")
                            switch response.result{
                            case .success(let value):
                              
//                                if response.response?.statusCode == 401{
//
//                                    self.appDelegatee.createToastMessage(self.lang.cont_Admin, isSuccess: false)
//
//                                    self.appDelegatee.logoutFinish()
//                                    return
//                                }
                                if let json = value as? JSONS{
                                    var jsonresult = json
                                    
                                    jsonresult["success_message"] = (json as! JSONS).statusMessage
                                    jsonresult["status_code"] = (json as! JSONS).statusCode.description
                                    successBlock(MakentSeparateParam().separate(params:  jsonresult as NSDictionary, methodName: method))
                                    if !jsonresult.string("refresh_token").isEmpty {
                                        Constants().STOREVALUE(value: jsonresult.string("refresh_token") as NSString, keyname: APPURL.USER_ACCESS_TOKEN)
                                        SharedVariables.sharedInstance.userToken = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
                                    }
                                }
                                
                                
                                
                            case .failure(let error):
                                if response.response?.statusCode == 401{
                                    self.appDelegatee.createToastMessage(self.lang.cont_Admin, isSuccess: false)
                                    self.appDelegatee.logoutFinish()
                                    return
                                }
                                failureBlock(error)
                            }
        }
        
         /*   debugPrint("myURL: \(myURL)")
            var items = NSDictionary()
            let request = NSMutableURLRequest(url:myURL as URL);
            
            URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if !(data != nil) {
                    failureBlock(error!)
                }
                else
                {
                    do
                    {
                        let jsonResult : Dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary as Dictionary
                        items = jsonResult as NSDictionary
                        
                        if (items.count>0)
                        {
                            successBlock(MakentSeparateParam().separate(params:  items, methodName: method))
                        }
                        else {
                            failureBlock(error!)
                        }
                    }
                    catch _ {
                                          //  failureBlock(error!)
                                           // print(response!)
                    }
                }
                }.resume()*/

    }
    
    
    
    
    func postRequestWithUrlAndData (somedata: Data, method: NSString,url: URL, withSuccessionBlock successBlock: @escaping (_ response: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void)
    {
        let submitrequest = NSMutableURLRequest(url: url)
        submitrequest.httpMethod = "POST"
        submitrequest.httpBody = somedata
        
        print(url)
        var items = NSDictionary()
        
        URLSession.shared.dataTask(with: submitrequest as URLRequest){ (data, response, error) in
            
            
            if !(data != nil) {
                failureBlock(error!)
            }
            
            
            
            else
            {
                do
                {
                    let jsonResult : Dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary as Dictionary
                    items = jsonResult as NSDictionary
                    
                    if (items.count>0)
                    {
                        successBlock(MakentSeparateParam().separate(params:  items, methodName: method))
                    }
                    else {
//                        if response.response?.statusCode == 401{
//                            WebServiceHandler.appDelegate.logOutDidFinish()
//                            return
//                        }
                        failureBlock(error!)
                    }
                }
                catch _ {
//                    failureBlock(error!)
//                    print(response!)
                }
            }
            }.resume()
    }
    
    
    
}



