//
//  PayoutPerferenceModel.swift
//  Makent
//
//  Created by Trioangle on 18/09/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class PayoutPerferenceModel: NSObject {
    var success_message : NSString = ""
    var status_code : NSString = ""
    var country_id : NSString = ""
    var country_name : NSString = ""
    var country_code : NSString = ""
    var currency_code : NSArray?

    func initiateListingData(responseDict: NSDictionary) -> Any
    {
        country_id =  self.checkParamTypes(params: responseDict, keys:"country_id")
        country_name = self.checkParamTypes(params: responseDict, keys:"country_name")
        country_code = self.checkParamTypes(params: responseDict, keys:"country_code")
        
        if let latestValue = responseDict["currency_code"] as? NSArray
        {
            currency_code = latestValue
        }

        return self
    }
    //MARK: Check Param Type
    func checkParamTypes(params:NSDictionary, keys:NSString) -> NSString
    {
        
        print("params is: \(params)")
        
        if let latestValue = params[keys] as? NSString {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? String {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? Int {
            return String(format:"%d",latestValue) as NSString
        }
        else if (params[keys] as? NSNull) != nil {
            return ""
        }
        else
        {
            return ""
        }
    }

}
