/**
* TripsModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class TripsModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var booking_status : NSString = ""
    var currency_symbol : NSString = ""
    var guest_count : NSString = ""
    var host_thumb_image : NSString = ""
    var host_user_id : NSString = ""
    var host_user_name : NSString = ""
    var room_image : NSString = ""
    var room_location : NSString = ""
    var room_name : NSString = ""
    var room_type : NSString = ""
    var total_cost : NSString = ""
    var list_type : NSString = ""
    var total_nights : NSString = ""
    var total_trips_count : NSString = ""
    var trip_date : NSString = ""
    var trip_status : NSString = ""
    var user_name : NSString = ""
    var user_thumb_image : NSString = ""
    var reservation_id : NSString = ""
    var room_id : NSString = ""
    var per_night_price : NSString = ""
    var service_fee : NSString = ""
    var cleaning_fee : NSString = ""
    var addition_guest_fee : NSString = ""
    var coupon_amount : NSString = ""
    var security_fee : NSString = ""
    var travel_credit : NSString = ""
    var can_view_receipt : NSString = ""
    var check_in : NSString = ""
    var check_out : NSString = ""
    var length_of_stay_discount : NSString = ""
    var length_of_stay_discount_price : NSString = ""
    var length_of_stay_type : NSString = ""
    var booked_period_discount_price : NSString = ""
    var booked_period_discount : NSString = ""
    var booked_period_type : NSString = ""
    var start_time : NSString = ""
    var end_time : NSString = ""
    var subtotal : NSString = ""
    var is_deleted_user : NSString = ""
    

    
    //MARK: Inits
    func initiateTripsData(responseDict: NSDictionary) -> Any
    {
        booking_status = MakentSupport().checkParamTypes(params: responseDict, keys:"booking_status")
        end_time = MakentSupport().checkParamTypes(params: responseDict, keys:"end_time")
        list_type = MakentSupport().checkParamTypes(params: responseDict, keys:"list_type")
        start_time = MakentSupport().checkParamTypes(params: responseDict, keys:"start_time")
        currency_symbol = MakentSupport().checkParamTypes(params: responseDict, keys:"currency_symbol")
        guest_count = MakentSupport().checkParamTypes(params: responseDict, keys:"number_of_guests")
        host_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"host_thumb_image")
        //responseDict["host_thumb_image"] as! NSString
        host_user_id = MakentSupport().checkParamTypes(params: responseDict, keys:"host_user_id")
        host_user_name = MakentSupport().checkParamTypes(params: responseDict, keys:"host_user_name")
        room_image = MakentSupport().checkParamTypes(params: responseDict, keys:"space_image")
        room_location = MakentSupport().checkParamTypes(params: responseDict, keys:"space_location")
        room_name = MakentSupport().checkParamTypes(params: responseDict, keys:"space_name")
        room_type = MakentSupport().checkParamTypes(params: responseDict, keys:"room_type")
        total_cost = MakentSupport().checkParamTypes(params: responseDict, keys:"total_cost")
        subtotal = MakentSupport().checkParamTypes(params: responseDict, keys:"subtotal")
        total_nights = MakentSupport().checkParamTypes(params: responseDict, keys:"total_nights")
        total_trips_count = MakentSupport().checkParamTypes(params: responseDict, keys:"total_trips_count")
        trip_date = MakentSupport().checkParamTypes(params: responseDict, keys:"reservation_date")
        trip_status = MakentSupport().checkParamTypes(params: responseDict, keys:"reservation_status")
        check_in = MakentSupport().checkParamTypes(params: responseDict, keys:"check_in")
        check_out = MakentSupport().checkParamTypes(params: responseDict, keys:"check_out")
        room_id = MakentSupport().checkParamTypes(params: responseDict, keys:"space_id")
        user_name =  MakentSupport().checkParamTypes(params: responseDict, keys:"user_name")
        //responseDict["user_name"] as! NSString
        user_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"user_thumb_image")
            //responseDict["user_thumb_image"] as! NSString
        reservation_id = MakentSupport().checkParamTypes(params: responseDict, keys:"reservation_id")
        per_night_price = MakentSupport().checkParamTypes(params: responseDict, keys:"per_night_price")
        service_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"service_fee")
        coupon_amount = MakentSupport().checkParamTypes(params: responseDict, keys:"coupon_amount")
        travel_credit = MakentSupport().checkParamTypes(params: responseDict, keys:"travel_credit")
        cleaning_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"cleaning_fee")
        addition_guest_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"additional_guest_fee")
        security_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"security_deposit")
        can_view_receipt = MakentSupport().checkParamTypes(params: responseDict, keys:"can_view_receipt")
        length_of_stay_discount  = MakentSupport().checkParamTypes(params: responseDict, keys:"length_of_stay_discount")
        length_of_stay_discount_price  = MakentSupport().checkParamTypes(params: responseDict, keys:"length_of_stay_discount_price")
        length_of_stay_type  = MakentSupport().checkParamTypes(params: responseDict, keys:"length_of_stay_type")
        booked_period_discount_price  = MakentSupport().checkParamTypes(params: responseDict, keys:"booked_period_discount_price")
        booked_period_discount  = MakentSupport().checkParamTypes(params: responseDict, keys:"booked_period_discount")
        booked_period_type  = MakentSupport().checkParamTypes(params: responseDict, keys:"booked_period_type")
  
        is_deleted_user =  MakentSupport().checkParamTypes(params: responseDict, keys:"is_deleted_user")
        
        return self
    }
    
    
}
