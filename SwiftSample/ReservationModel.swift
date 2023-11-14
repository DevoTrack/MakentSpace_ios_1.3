/**
* ReservationModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class ReservationModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var space_type_name : NSString = ""
    var status_code : NSString = ""
    var additional_guest_fee : NSString = ""
    var can_view_receipt : NSString = ""
    var check_in : NSString = ""
    var check_out : NSString = ""
    var cleaning_fee : NSString = ""
    var currency_symbol : NSString = ""
    var guest_count : NSString = ""
    var guest_thumb_image : NSString = ""
    var guest_user_name : NSString = ""
    var guest_users_id : NSString = ""
    var host_thumb_image : NSString = ""
    var host_user_name : NSString = ""
    var host_users_id : NSString = ""
    var payment_recieved_date : NSString = ""
    var per_night_price : NSString = ""
    var reservation_id : NSString = ""
    var room_id : NSString = ""
    var room_image : NSString = ""
    var room_location : NSString = ""
    var room_name : NSString = ""
    var room_type : NSString = ""
    var security_deposit : NSString = ""
    var service_fee : NSString = ""
    var host_fee : NSString = ""
    var request_user_id : NSString = ""
    var start_time : NSString = ""
    var end_time : NSString = ""
    var list_type : NSString = ""
    

    var total_cost : NSString = ""
    var total_nights : NSString = ""

    var trip_date : NSString = ""
    var trip_status : NSString = ""
    var guest_user_location : NSString = ""
    var member_from : NSString = ""
    var expire_timer : NSString = ""
//    var created_at_timer : NSString = ""
//    var created_at : NSString = ""

    var length_of_stay_discount : NSString = ""
    var length_of_stay_discount_price : NSString = ""
    var length_of_stay_type : NSString = ""
    var booked_period_discount_price : NSString = ""
    var booked_period_discount : NSString = ""
    var booked_period_type : NSString = ""
    var is_deleted_user: NSString = ""
  
    
    //MARK: Inits
    func initiateReservationData(responseDict: NSDictionary) -> Any
    {
        additional_guest_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"additional_guest_fee")
        space_type_name = MakentSupport().checkParamTypes(params: responseDict, keys: "space_type_name")
        start_time = MakentSupport().checkParamTypes(params: responseDict, keys:"start_time")
        list_type = MakentSupport().checkParamTypes(params: responseDict, keys: "list_type")
        end_time = MakentSupport().checkParamTypes(params: responseDict, keys:"end_time")
        can_view_receipt = MakentSupport().checkParamTypes(params: responseDict, keys:"can_view_receipt")
        check_in = MakentSupport().checkParamTypes(params: responseDict, keys:"check_in")
        check_out = MakentSupport().checkParamTypes(params: responseDict, keys:"check_out")
        cleaning_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"cleaning_fee")
        currency_symbol = MakentSupport().checkParamTypes(params: responseDict, keys:"currency_symbol")
        guest_count = MakentSupport().checkParamTypes(params: responseDict, keys:"guest_count")
        guest_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"other_thumb_image")
            ////MakentSupport().checkParamTypes(params: responseDict, keys:"room_image")
        guest_user_name = MakentSupport().checkParamTypes(params: responseDict, keys:"guest_user_name")
        guest_users_id = MakentSupport().checkParamTypes(params: responseDict, keys: "other_user_id")
            //MakentSupport().checkParamTypes(params: responseDict, keys:"guest_users_id")
        host_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"host_thumb_image")
        host_user_name = MakentSupport().checkParamTypes(params: responseDict, keys:"host_user_name")
        host_users_id = MakentSupport().checkParamTypes(params: responseDict, keys:"host_users_id")
        payment_recieved_date = MakentSupport().checkParamTypes(params: responseDict, keys:"payment_recieved_date")
        per_night_price = MakentSupport().checkParamTypes(params: responseDict, keys:"per_night_price")
        reservation_id = MakentSupport().checkParamTypes(params: responseDict, keys:"reservation_id")
        room_id = MakentSupport().checkParamTypes(params: responseDict, keys:"space_id")
            //MakentSupport().checkParamTypes(params: responseDict, keys:"room_id")space_image
        room_name = MakentSupport().checkParamTypes(params: responseDict, keys:"space_name")
        room_image = MakentSupport().checkParamTypes(params: responseDict, keys:"space_image")
            //MakentSupport().checkParamTypes(params: responseDict, keys:"room_image")
        room_location = MakentSupport().checkParamTypes(params: responseDict, keys:"space_location")
        
            //MakentSupport().checkParamTypes(params: responseDict, keys:"room_location")
        room_type = MakentSupport().checkParamTypes(params: responseDict, keys:"room_type")
        security_deposit = MakentSupport().checkParamTypes(params: responseDict, keys:"security_deposit")
        service_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"service_fee")
        host_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"host_fee")
        
        request_user_id = MakentSupport().checkParamTypes(params: responseDict, keys:"request_user_id")

        total_cost = MakentSupport().checkParamTypes(params: responseDict, keys:"total_cost")
        total_nights = MakentSupport().checkParamTypes(params: responseDict, keys:"total_nights")
        trip_date = MakentSupport().checkParamTypes(params: responseDict, keys:"reservation_date")
            //MakentSupport().checkParamTypes(params: responseDict, keys:"trip_date")
        trip_status = MakentSupport().checkParamTypes(params: responseDict, keys:"reservation_status")
        
            //MakentSupport().checkParamTypes(params: responseDict, keys:"trip_status")
        expire_timer = MakentSupport().checkParamTypes(params: responseDict, keys:"expire_timer")
        guest_user_location = MakentSupport().checkParamTypes(params: responseDict, keys:"guest_user_location")

        member_from = MakentSupport().checkParamTypes(params: responseDict, keys:"member_from")
        
        length_of_stay_discount  = MakentSupport().checkParamTypes(params: responseDict, keys:"length_of_stay_discount")
        length_of_stay_discount_price  = MakentSupport().checkParamTypes(params: responseDict, keys:"length_of_stay_discount_price")
        length_of_stay_type  = MakentSupport().checkParamTypes(params: responseDict, keys:"length_of_stay_type")
        booked_period_discount_price  = MakentSupport().checkParamTypes(params: responseDict, keys:"booked_period_discount_price")
        booked_period_discount  = MakentSupport().checkParamTypes(params: responseDict, keys:"booked_period_discount")
        booked_period_type  = MakentSupport().checkParamTypes(params: responseDict, keys:"booked_period_type")
        is_deleted_user  = MakentSupport().checkParamTypes(params: responseDict, keys: "is_deleted_user")
       
        return self
    }
    
    
}
