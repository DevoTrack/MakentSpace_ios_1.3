/**
 * RoomDetailModel.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */


import Foundation
import UIKit

class RoomDetailModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var room_id : NSString = ""
    var room_price : NSString = ""
    var room_name : NSString = ""
    var room_images : NSArray!
    var rating_value : NSString = ""
    var reviews_count : NSString = ""
    var is_whishlist : NSString = ""
    var room_share_url : NSString = ""
    var host_user_id : NSString = ""
    var host_user_name : NSString = ""
    var room_type : NSString = ""
    var is_shared : NSString  = ""
    var host_user_image : NSString = ""
    var no_of_guest : NSString = ""
    var no_of_beds : NSString = ""
    var no_of_bedrooms : NSString = ""
    var no_of_bathrooms : NSString = ""
    var locaiton_name : NSString = ""
    
    var loc_latidude : NSString = ""
    var loc_longidude : NSString = ""
    var review_user_name : NSString = ""
    var review_user_image : NSString = ""
    var review_date : NSString = ""
    var review_message : NSString = ""
    var review_value : NSString = ""
    var room_detail : NSString = ""
    var check_in_time : NSString = ""
    var check_out_time : NSString = ""
    var weekly_price : NSString = ""
    var monthly_price : NSString = ""
    var security_deposit : NSString = ""
    var additional_guests : NSString = ""
    var cleaning_fee : NSString = ""
    var currency_symbol : NSString = ""
    var currency_code : NSString = ""
    var instant_book : NSString = ""
    var house_rules : NSString = ""
    var cancellation_policy : NSString = ""
    var can_book : NSString = ""
    var minimum_stay : NSString  = ""
    var maximum_stay : NSString = ""
    var space : NSString = ""
    var access  : NSString = ""
    var interaction : NSString = ""
    var neighborhood_overview : NSString = ""
    var getting_around : NSString = ""
    var notes : NSString = ""
    
    var amenities_values : NSArray!
    var price_rules : NSArray!
    var similar_list_details : NSArray!
    var blocked_dates : NSArray!
    var length_of_stay_rules : NSArray!
    var early_bird_rules : NSArray!
    var last_min_rules : NSArray!
    var availability_rules : NSArray!
    
    var arrTemp1 : NSMutableArray = NSMutableArray()
    var arrTemp2 : NSMutableArray = NSMutableArray()
    var arrTemp3 : NSMutableArray = NSMutableArray()
    var arrTemp4 : NSMutableArray = NSMutableArray()
    var arrTemp5 : NSMutableArray = NSMutableArray()
    
    
    //MARK: for discount
    var discount : NSString = ""
    var roomid : NSString = ""
    var period : NSString = ""
    var period_text : NSString = ""
    var type : NSString = ""
    var id : NSString = ""
    //MARK: for aminities
    var ame_id : NSString = ""
    var ame_icon : NSString = ""
    var ame_name : NSString = ""
    
    //MARK: for aviable
    
    var minimumstay : NSString = ""
    var maximumstay : NSString = ""
    var start_date : NSString = ""
    var end_date : NSString = ""
    var during : NSString = ""
    var start_date_formatted : NSString = ""
    var end_date_formatted : NSString = ""
    
    var dictTemp1 : NSMutableDictionary = NSMutableDictionary()
    
    
    var avbNight : NSString = ""
    var avbText : NSString = ""
    
    
    // MARK: Inits
    func initiateDiscountData(responseDict: NSDictionary) -> Any
    {
        discount = self.checkParamTypes(params: responseDict, keys:"discount")
        period = self.checkParamTypes(params: responseDict, keys:"period")
        roomid = self.checkParamTypes(params: responseDict, keys:"room_id")
        type = self.checkParamTypes(params: responseDict, keys:"type")
        id = self.checkParamTypes(params: responseDict, keys:"id")
        return self
    }
    func initiateDiscountlengthData(responseDict: NSDictionary) -> Any
    {
        discount = self.checkParamTypes(params: responseDict, keys:"discount")
        period = self.checkParamTypes(params: responseDict, keys:"period_text")
        period_text = self.checkParamTypes(params: responseDict, keys:"period")
        roomid = self.checkParamTypes(params: responseDict, keys:"room_id")
        type = self.checkParamTypes(params: responseDict, keys:"type")
        id = self.checkParamTypes(params: responseDict, keys:"id")
        return self
    }
    func initiateEditlengthData(responseDict: NSDictionary) -> Any
    {
        type = self.checkParamTypes(params: responseDict, keys:"type")
        
        if type == "length_of_stay" {
            period = self.checkParamTypes(params: responseDict, keys:"period_text")
            period_text = self.checkParamTypes(params: responseDict, keys:"period")
        }
        else{
            period = self.checkParamTypes(params: responseDict, keys:"period")
        }
        discount = self.checkParamTypes(params: responseDict, keys:"discount")
        roomid = self.checkParamTypes(params: responseDict, keys:"room_id")
        id = self.checkParamTypes(params: responseDict, keys:"id")
        return self
    }
    func initiateAminitiesData(responseDict: NSDictionary) -> Any
    {
        ame_id = self.checkParamTypes(params: responseDict, keys:"id")
        ame_icon = self.checkParamTypes(params: responseDict, keys:"icon")
        ame_name = self.checkParamTypes(params: responseDict, keys:"name")
        print(ame_id,ame_name,ame_icon)
        return self
    }
    func initiateAvailabilityRuleOptionsData(responseDict: NSDictionary) -> Any
    {
        avbText = self.checkParamTypes(params: responseDict, keys:"text")
        start_date = self.checkParamTypes(params: responseDict, keys:"start_date")
        end_date = self.checkParamTypes(params: responseDict, keys:"end_date")
        return self
    }
    func initiateAvailabilityOptionsData(responseDict: NSDictionary) -> Any
    {
        
        avbNight = self.checkParamTypes(params: responseDict, keys:"nights")
        avbText = self.checkParamTypes(params: responseDict, keys:"text")
        
        return self
    }
    func initiateAvailabilityData(responseDict: NSDictionary) -> Any
    {
        minimumstay = self.checkParamTypes(params: responseDict, keys:"minimum_stay")
        maximumstay = self.checkParamTypes(params: responseDict, keys:"maximum_stay")
        start_date = self.checkParamTypes(params: responseDict, keys:"start_date")
        end_date = self.checkParamTypes(params: responseDict, keys:"end_date")
        during = self.checkParamTypes(params: responseDict, keys:"during")
        start_date_formatted = self.checkParamTypes(params: responseDict, keys:"start_date_formatted")
        end_date_formatted = self.checkParamTypes(params: responseDict, keys:"end_date_formatted")
        roomid = self.checkParamTypes(params: responseDict, keys:"room_id")
        type = self.checkParamTypes(params: responseDict, keys:"type")
        id = self.checkParamTypes(params: responseDict, keys:"id")
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
