/**
* CurrencyModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class CurrencyModel  {
    
    //MARK Properties
  
    var currency_code : NSString = ""
    var currency_symbol : NSString = ""

   // MARK: Inits
    init(responseDict: JSONS)
    {
        currency_code = responseDict.string("code") as NSString
//            self.checkParamTypes(params: responseDict, keys:"code")
        currency_symbol = responseDict.string("symbol") as NSString
            
//            self.checkParamTypes(params: responseDict, keys:"symbol")
        
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
