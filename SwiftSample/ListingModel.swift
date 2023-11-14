/**
 * ListingModel.swift
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

class ListingModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var room_id : NSString = ""
    var room_type : NSString = ""
    var room_name : NSString = ""
    var remaining_steps : NSString = ""
    var room_status : NSString = ""
    var room_title : NSString = ""
    var room_description : NSString = ""
    var room_price : NSString = ""
    var room_location : NSString = ""
    var latitude : NSString = ""
    var longitude : NSString = ""
    var additional_rules_msg : NSString = ""
    var selected_amenities_id : NSString = ""
    var isListEnabled : NSString = ""
    var room_thumb_images : NSArray?
    var home_type : NSString = ""
    var max_guest_count : NSString = ""
    var bedroom_count : NSString = ""
    var beds_count : NSString = ""
    var bathrooms_count : NSString = ""
    var weekly_price : NSString = ""
    var monthly_price : NSString = ""
    var minimum_stay : NSString = ""
    var maximum_stay : NSString = ""
    var cleaningFee:NSString = ""
    var additionGuestFee:NSString = ""
    var additionGuestCount:NSString = ""
    var securityDeposit:NSString = ""
    var weekendPrice:NSString = ""
    var booking_type:NSString = ""
    var policy_type:NSString = ""
    var currency_code:NSString = ""
    var currency_symbol:NSString = ""
    
    var street_name:NSString = ""
    var street_address:NSString = ""
    var city_name:NSString = ""
    var state_name:NSString = ""
    var country_name:NSString = ""
    var zipcode:NSString = ""
    var bed_type:NSString = ""
    var property_type:NSString = ""
    
    var room_thumb_image_ids : NSArray?
    var price_rules : NSArray?
    var blocked_dates : NSArray?
    var reserved_dates : NSArray?
    var nightly_price : NSArray?
    var listed_rooms : NSArray?
    var un_listed_rooms : NSArray?
    
    var length_of_stay_rules : NSMutableArray = NSMutableArray()
    var early_bird_rules : NSMutableArray = NSMutableArray()
    var last_min_rules : NSMutableArray = NSMutableArray()
    var availability_rules : NSMutableArray = NSMutableArray()
    var length_of_stay_options : NSMutableArray = NSMutableArray()
    var availability_rules_options : NSMutableArray = NSMutableArray()
  
   // MARK: Inits
    func initiateListingData(responseDict: NSDictionary) -> Any
    {
        room_id =  self.checkParamTypes(params: responseDict, keys:"room_id")
        room_price = self.checkParamTypes(params: responseDict, keys:"room_price")
        room_name = self.checkParamTypes(params: responseDict, keys:"room_name")
        room_type = self.checkParamTypes(params: responseDict, keys:"room_type")
        remaining_steps = self.checkParamTypes(params: responseDict, keys:"remaining_steps")
        room_title =  self.checkParamTypes(params: responseDict, keys:"room_title")
        room_description = self.checkParamTypes(params: responseDict, keys:"room_description")
        room_location = self.checkParamTypes(params: responseDict, keys:"room_location")
        latitude = self.checkParamTypes(params: responseDict, keys:"latitude")
        longitude = self.checkParamTypes(params: responseDict, keys:"longitude")
        room_status = self.checkParamTypes(params: responseDict, keys: "room_status")
        additional_rules_msg = self.checkParamTypes(params: responseDict, keys:"additional_rules_msg")
        bed_type = self.checkParamTypes(params: responseDict, keys:"bed_type")
        property_type = self.checkParamTypes(params: responseDict, keys:"property_type")
        room_type = self.checkParamTypes(params: responseDict, keys:"room_type")
        home_type = self.checkParamTypes(params: responseDict, keys:"home_type")
        max_guest_count = self.checkParamTypes(params: responseDict, keys:"max_guest_count")
        bedroom_count = self.checkParamTypes(params: responseDict, keys:"bedroom_count")
        beds_count = self.checkParamTypes(params: responseDict, keys:"beds_count")
        bathrooms_count = self.checkParamTypes(params: responseDict, keys:"bathrooms_count")
        weekly_price = self.checkParamTypes(params: responseDict, keys:"weekly_price")
        monthly_price = self.checkParamTypes(params: responseDict, keys:"monthly_price")
        minimum_stay = self.checkParamTypes(params: responseDict, keys:"minimum_stay")
        maximum_stay = self.checkParamTypes(params: responseDict, keys:"maximum_stay")
        cleaningFee = self.checkParamTypes(params: responseDict, keys:"cleaning_fee")
        additionGuestFee = self.checkParamTypes(params: responseDict, keys:"additional_guests_fee")
        additionGuestCount = self.checkParamTypes(params: responseDict, keys:"for_each_guest_after")
        securityDeposit = self.checkParamTypes(params: responseDict, keys:"security_deposit")
        weekendPrice = self.checkParamTypes(params: responseDict, keys:"weekend_pricing")
        booking_type = self.checkParamTypes(params: responseDict, keys:"booking_type")
        policy_type = self.checkParamTypes(params: responseDict, keys:"policy_type")
        selected_amenities_id = self.checkParamTypes(params: responseDict, keys:"amenities")
        isListEnabled = self.checkParamTypes(params: responseDict, keys:"is_list_enabled")
        currency_code = self.checkParamTypes(params: responseDict, keys:"room_currency_code")
        currency_symbol = self.checkParamTypes(params: responseDict, keys:"room_currency_symbol")
        street_name = self.checkParamTypes(params: responseDict, keys:"street_name")
        street_address = self.checkParamTypes(params: responseDict, keys:"street_address")
        city_name = self.checkParamTypes(params: responseDict, keys:"city")
        state_name = self.checkParamTypes(params: responseDict, keys:"state")
        country_name = self.checkParamTypes(params: responseDict, keys:"country")
        zipcode = self.checkParamTypes(params: responseDict, keys:"zip")
        
        if let latestValue = responseDict["room_thumb_images"] as? NSArray
        {
            room_thumb_images = latestValue
        }
        
        if let latestValue = responseDict["room_image_id"] as? NSArray
        {
            room_thumb_image_ids = latestValue
        }

        if let latestValue = responseDict["blocked_dates"] as? NSArray
        {
            blocked_dates = latestValue
        }

        if let latestValue = responseDict["reserved_dates"] as? NSArray
        {
            reserved_dates = latestValue
        }
        
        if let latestValue = responseDict["nightly_price"] as? NSArray
        {
            nightly_price = latestValue
        }
        
        let arrData = responseDict["length_of_stay_rules"] as? NSArray
        let arrData1 = responseDict["early_bird_rules"] as? NSArray
        let arrData2 = responseDict["last_min_rules"] as? NSArray
        let arrData3 = responseDict["availability_rules"] as? NSArray
        let arrDate4 = responseDict["length_of_stay_options"] as? NSArray
        let arrDate5 = responseDict["availability_rules_options"] as? NSArray

        if let arr = arrData,arr.count > 0 {
            for i in 0 ..< arr.count
            {
                self.length_of_stay_rules.addObjects(from: ([RoomDetailModel().initiateDiscountlengthData(responseDict: arr[i] as! NSDictionary)]))
            }
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let path = String(format:"%@/roomtype.plist",paths)
            arr.write(toFile: path, atomically: true)
            
         }

        if let arr1 = arrData1, arr1.count > 0 {
            
            for i in 0 ..< arr1.count
            {
                self.early_bird_rules.addObjects(from: ([RoomDetailModel().initiateDiscountData(responseDict: arr1[i] as! NSDictionary)]))
            }
        }

        if let arr2 = arrData2, arr2.count > 0 {

            for i in 0 ..< arr2.count
            {
                self.last_min_rules.addObjects(from: ([RoomDetailModel().initiateDiscountData(responseDict: arr2[i] as! NSDictionary)]))
            }
            
        }

        if let arr3 = arrData3, arr3.count > 0 {
            
            
            for i in 0 ..< arr3.count
            {
                self.availability_rules.addObjects(from: ([RoomDetailModel().initiateAvailabilityData(responseDict: arr3[i] as! NSDictionary)]))
            }
       }
        
        if let arr4 = arrDate4, arr4.count > 0 {
            
            for i in 0 ..< arr4.count
            {
                self.length_of_stay_options.addObjects(from: ([RoomDetailModel().initiateAvailabilityOptionsData(responseDict: arr4[i] as! NSDictionary)]))
            }
        }
        if let arr5 = arrDate5, arr5.count > 0 {
            
            for i in 0 ..< arr5.count
            {
                self.availability_rules_options.addObjects(from: ([RoomDetailModel().initiateAvailabilityRuleOptionsData(responseDict: arr5[i] as! NSDictionary)]))
            }
        }
        return self
    }
    func initiateDeleteListingData(responseDict: NSDictionary) -> Any
    {
        room_id =  self.checkParamTypes(params: responseDict, keys:"room_id")
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
