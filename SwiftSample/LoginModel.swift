/**
 * LoginModel.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */



import Foundation
import UIKit

class LoginModel : NSObject {
    
    //MARK Properties
    var success_message : String = ""
    var status_code : String = ""
    var user_name : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var user_image_small : String = ""
    var user_image_large : String = ""
    var dob : String = ""
    var email_id : String = ""
    var access_token : String = ""
    var user_id : String = ""
    var currency_code = String()
    var currency_symbol = String()
    
    //MARK: Inits
    
    init(jsons:JSONS) {
        self.first_name = jsons.string("first_name")
        self.last_name = jsons.string("last_name")
        
        self.user_name = "\(self.first_name) \(self.last_name)"
        self.user_image_small = jsons.string("user_image")
        self.user_image_large = jsons.string("user_image")
        self.dob = jsons.string("dob")
        self.email_id = jsons.string("email_id")
        self.access_token = jsons.string("access_token")
        self.user_id = jsons.string("user_id")
        self.currency_code = jsons.string("currency_code")
        self.currency_symbol = jsons.string("currency_symbol")
        self.status_code = jsons.string("status_code")
        self.success_message = jsons.string("success_message")
        
        
        Constants().STOREVALUE(value: currency_symbol.stringByDecodingHTMLEntities as NSString, keyname: APPURL.USER_CURRENCY_SYMBOL)
        Constants().STOREVALUE(value: access_token as NSString, keyname: APPURL.USER_ACCESS_TOKEN)
        
        Constants().STOREVALUE(value: (user_name as NSString), keyname: APPURL.USER_FULL_NAME)
        Constants().STOREVALUE(value: (first_name as NSString), keyname: APPURL.USER_FIRST_NAME)
        Constants().STOREVALUE(value: last_name as NSString, keyname: APPURL.USER_LAST_NAME)
        Constants().STOREVALUE(value: user_image_large as NSString, keyname: APPURL.USER_IMAGE_THUMB)
        Constants().STOREVALUE(value: user_id as NSString, keyname: APPURL.USER_ID)
        Constants().STOREVALUE(value: dob as NSString, keyname: APPURL.USER_DOB)
        Constants().STOREVALUE(value: currency_code as NSString, keyname:APPURL.USER_CURRENCY_ORG)
        Constants().STOREVALUE(value: currency_symbol as NSString, keyname: APPURL.USER_CURRENCY_SYMBOL_ORG)
//        Constants().STOREVALUE(value: String(format:"%@ (%@)",MakentSupport().checkParamTypes(params: params, keys:"currency_code") as NSString,currencySymbol) as NSString, keyname: USER_CURRENCY)
    }
    
}
