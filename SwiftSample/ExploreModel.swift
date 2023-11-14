/**
* ExploreModel.swift
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import Foundation
import UIKit

class ExploreModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var currency_code : NSString = ""
    var currency_symbol : NSString = ""
    var country_name : NSString = ""
    var city_name : NSString = ""
    var room_id : NSString = ""
    var wishroom_id : Int = 0
    var room_price : NSString = ""
    var room_name : NSString = ""
    var room_thumb_image : NSString = ""
    var rating_value : NSString = ""
    var reviews_count : NSString = ""
    var is_whishlist : NSString = ""
    var instant_book : NSString = ""
    var latitude : NSString = ""
    var longitude : NSString = ""
    var room_type : NSString = ""
    var arrExploreData : NSArray?
    
    var experience_id:NSString = ""
    var experience_price:NSString = ""
    var experience_name:NSString = ""
    var experience_thumb_images:NSString = ""
    var experience_category:NSString = ""
    var ex_rating_value:NSString = ""
    var ex_reviews_count : NSString = ""
    var ex_is_whishlist : NSString = ""
    var ex_latitude : NSString = ""
    var ex_longitude : NSString = ""
    var ex_currency_symbol : NSString = ""
    var ex_country_name : NSString = ""
    var ex_city_name : NSString = ""
    var ex_currency_code : NSString = ""
    var ex_room_id : NSString = ""
    var number_of_guest : Int = 0

    func initiateExperienceData(responseDict: NSDictionary) -> Any
    {
        ex_room_id = self.checkParamTypes(params: responseDict, keys:"experience_id")
        experience_price = self.checkParamTypes(params: responseDict, keys:"experience_price")
        experience_name = responseDict["experience_name"] as! NSString
        //experience_thumb_images = responseDict["experience_thumb_images"] as! NSString
        experience_category = self.checkParamTypes(params: responseDict, keys:"experience_category")       
        ex_rating_value = self.checkParamTypes(params: responseDict, keys:"rating_value")
        ex_reviews_count =  self.checkParamTypes(params: responseDict, keys:"reviews_count")
        ex_is_whishlist = responseDict["is_wishlist"] as! NSString
        ex_country_name = self.checkParamTypes(params: responseDict, keys:"country_name")
        ex_city_name = self.checkParamTypes(params: responseDict, keys:"city_name")
        let currency = self.checkParamTypes(params: responseDict, keys:"currency_code")
        ex_currency_code = MakentSupport().getSymbolForCurrencyCode(code: currency)!
        ex_currency_symbol = self.checkParamTypes(params: responseDict, keys:"currency_symbol")
        ex_latitude = self.checkParamTypes(params: responseDict, keys:"latitude")
        ex_longitude = self.checkParamTypes(params: responseDict, keys:"longitude")
       
        return self
    }
   // MARK: Inits
    func initiateExploreData(responseDict: NSDictionary) -> Any
    {
        room_id = self.checkParamTypes(params: responseDict, keys:"space_id")
        
        //wishroom_id = responseDict["room_id"] as! Int
        wishroom_id = Int(self.checkParamTypesNum(params: responseDict, keys:"space_id"))
            //responseDict["space_id"] as! Int
        room_price = self.checkParamTypes(params: responseDict, keys:"hourly_price")
        room_name = responseDict["space_name"] as! NSString
        room_thumb_image = responseDict["space_thumb_image"] as! NSString
        rating_value = self.checkParamTypes(params: responseDict, keys:"rating_value")
        reviews_count =  self.checkParamTypes(params: responseDict, keys:"reviews_count")
        is_whishlist = responseDict["is_wishlist"] as! NSString
        country_name = self.checkParamTypes(params: responseDict, keys:"country_name")
        //city_name = self.checkParamTypes(params: responseDict, keys:"city_name")
        let currency = self.checkParamTypes(params: responseDict, keys:"currency_code")
        currency_code = MakentSupport().getSymbolForCurrencyCode(code: currency)!
        currency_symbol = self.checkParamTypes(params: responseDict, keys:"currency_symbol")
        instant_book = self.checkParamTypes(params: responseDict, keys:"is_instant_book")
         number_of_guest = Int(self.checkParamTypesNum(params: responseDict, keys:"number_of_guests"))
        room_type = self.checkParamTypes(params: responseDict, keys:"space_type_name")
        //latitude = self.checkParamTypes(params: responseDict, keys:"latitude")
        //longitude = self.checkParamTypes(params: responseDict, keys:"longitude")
        //room_type = self.checkParamTypes(params: responseDict, keys:"room_type")
        //instant_book = self.checkParamTypes(params: responseDict, keys:"instant_book")
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
    
    
    //MARK: Check Param Type
    func checkParamTypesNum(params:NSDictionary, keys:NSString) -> NSNumber
    {
        if let latestValue = params[keys] as? NSNumber {
            return latestValue as NSNumber
        }
        else if let latestValue = params[keys] as? Int {
            return latestValue as NSNumber
        }
//        else if let latestValue = params[keys] as? Int {
//            return String(format:"%d",latestValue) as NSNumber
//        }
        else if (params[keys] as? NSNull) != nil {
            return 0
        }
        else
        {
            return 0
        }
    }
    

}
