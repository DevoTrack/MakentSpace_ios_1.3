/**
* CountryModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class CountryModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var country_code : NSString = ""
    var country_name : NSString = ""
    var country_id : NSString = ""
    
   // MARK: Inits
    func initiateCountryData(responseDict: NSDictionary) -> Any
    {
        country_code = self.checkParamTypes(params: responseDict, keys:"country_code")
        country_name = self.checkParamTypes(params: responseDict, keys:"country_name")
        country_id = self.checkParamTypes(params: responseDict, keys:"country_id")
        return self
    }
    
  
    
    //MARK: Check Param Type
    func checkParamTypes(params:NSDictionary, keys:NSString) -> NSString
    {
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
