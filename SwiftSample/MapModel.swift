/**
* MapModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class MapModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var currency_code : NSString = ""
    var currency_symbol : NSString = ""
    var country_name : NSString = ""
    var room_id : NSString = ""
    var room_price : NSString = ""
    var room_name : NSString = ""
    var room_thumb_image : NSString = ""
    var rating_value : NSString = ""
    var reviews_count : NSString = ""
    var is_whishlist : NSString = ""
    var arrExploreData : NSArray?
    var latitude : NSString = ""
    var longitude : NSString = ""
    var room_type : NSString = ""

   // MARK: Inits
    func initiateMapData(responseDict: NSDictionary) -> Any
    {
        room_id =  String(format:"%d",responseDict["room_id"] as! Int) as NSString
        room_price = String(format:"%d",responseDict["room_price"] as! Int) as NSString
        room_name = responseDict["room_name"] as! NSString
        room_thumb_image = responseDict["room_thumb_image"] as! NSString
        rating_value =  self.checkParamTypes(params: responseDict, keys:"rating_value")
        reviews_count =  self.checkParamTypes(params: responseDict, keys:"reviews_count")
        is_whishlist = responseDict["is_whishlist"] as! NSString
        country_name = self.checkParamTypes(params: responseDict, keys:"country_name")
        currency_code = self.checkParamTypes(params: responseDict, keys:"currency_code")
        currency_symbol = self.checkParamTypes(params: responseDict, keys:"currency_symbol")
        latitude = self.checkParamTypes(params: responseDict, keys:"loc_latidude")
        longitude = self.checkParamTypes(params: responseDict, keys:"loc_longidude")
        room_type = self.checkParamTypes(params: responseDict, keys:"room_type")
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
