/**
* InboxModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class InboxModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var check_in_time : NSString = ""
    var check_out_time : NSString = ""
    var host_thumb_image : NSString = ""
    var host_user_id : NSString = ""
    var request_user_id : NSString = ""
    var host_user_name : NSString = ""
    var last_message : NSString = ""
    var last_message_date_time : NSString = ""
    var message_status : NSString = ""
    var message_type : NSString = ""
    var reservation_id : NSString = ""
    var review_count : NSString = ""
    var room_location : NSString = ""
    var room_name : NSString = ""
    var total_cost : NSString = ""
    var unread_message_count : NSString = ""
    var user_location : NSString = ""
    var room_id : NSString = ""
    var is_message_read : NSString = ""
    var trip_status : NSString = ""
    var service_fee : NSString = ""
    var host_fee : NSString = ""
    var per_night_price : NSString = ""
    var room_thumb_image : NSString = ""
    var total_guest : NSString = ""
    var total_nights : NSString = ""
    var host_member_since_from : NSString = ""
    var expire_time : NSString = ""
    var additional_guest_fee : NSString = ""
    var security_deposit : NSString = ""
    var cleaning_fee : NSString = ""
    var booking_status : NSString = ""
    var receiver_thumb_image : NSString = ""
    var sender_thumb_image : NSString = ""
    var special_offer_status : NSString = ""
    var special_offer_id : NSString = ""
    var list_type : NSString = ""
    
    var other_thumb_image : NSString = ""
    var can_view_receipt : NSString = ""
    var other_user_name : NSString = ""
    var reservation_status : NSString = ""
    var is_deleted_user : NSString = ""
    //MARK: Inits
    func initiateInboxData(responseDict: NSDictionary) -> Any
    {
        other_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys: "other_thumb_image")
        other_user_name = MakentSupport().checkParamTypes(params: responseDict, keys: "other_user_name")
        can_view_receipt = MakentSupport().checkParamTypes(params: responseDict, keys: "can_view_receipt")
        reservation_status = MakentSupport().checkParamTypes(params: responseDict, keys: "reservation_status")
        
        
        list_type = MakentSupport().checkParamTypes(params: responseDict, keys:"list_type")
        additional_guest_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"additional_guest_fee")
        cleaning_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"cleaning_fee")
        special_offer_id = MakentSupport().checkParamTypes(params: responseDict, keys:"special_offer_id")
        special_offer_status = MakentSupport().checkParamTypes(params: responseDict, keys:"special_offer_status")
        receiver_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"receiver_thumb_image")
        sender_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"sender_thumb_image")  
         security_deposit = MakentSupport().checkParamTypes(params: responseDict, keys:"security_deposit")
        booking_status = MakentSupport().checkParamTypes(params: responseDict, keys:"booking_status")
        check_in_time = MakentSupport().checkParamTypes(params: responseDict, keys:"checkin")
        check_out_time = MakentSupport().checkParamTypes(params: responseDict, keys:"checkout")
        host_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"host_thumb_image")
        host_user_id = MakentSupport().checkParamTypes(params: responseDict, keys:"host_user_id")
        request_user_id = MakentSupport().checkParamTypes(params: responseDict, keys:"request_user_id")
        host_user_name = MakentSupport().checkParamTypes(params: responseDict, keys:"host_user_name")
        last_message = MakentSupport().checkParamTypes(params: responseDict, keys:"last_message")
        last_message_date_time = MakentSupport().checkParamTypes(params: responseDict, keys:"last_message_date_time")
        review_count = MakentSupport().checkParamTypes(params: responseDict, keys:"review_count")
        room_location = MakentSupport().checkParamTypes(params: responseDict, keys:"space_location")
        room_name = MakentSupport().checkParamTypes(params: responseDict, keys:"room_name")
        total_cost = MakentSupport().checkParamTypes(params: responseDict, keys:"total_cost")
        user_location = MakentSupport().checkParamTypes(params: responseDict, keys:"total_trips_count")
        message_status = MakentSupport().checkParamTypes(params: responseDict, keys:"message_status")
        message_type = "5"//MakentSupport().checkParamTypes(params: responseDict, keys:"message_type")
        reservation_id = MakentSupport().checkParamTypes(params: responseDict, keys:"reservation_id")
        room_id = MakentSupport().checkParamTypes(params: responseDict, keys:"space_id")
        is_message_read = MakentSupport().checkParamTypes(params: responseDict, keys:"is_message_read")
        trip_status = MakentSupport().checkParamTypes(params: responseDict, keys:"trip_status")
        
        room_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"room_thumb_image")
        total_guest = MakentSupport().checkParamTypes(params: responseDict, keys:"total_guest")
        total_nights = MakentSupport().checkParamTypes(params: responseDict, keys:"total_nights")
        host_member_since_from = MakentSupport().checkParamTypes(params: responseDict, keys:"host_member_since_from")
        expire_time = MakentSupport().checkParamTypes(params: responseDict, keys:"expire_timer")
        service_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"service_fee")
        host_fee = MakentSupport().checkParamTypes(params: responseDict, keys:"host_fee")
        per_night_price = MakentSupport().checkParamTypes(params: responseDict, keys:"per_night_price")
        is_deleted_user = MakentSupport().checkParamTypes(params: responseDict, keys:"is_deleted_user") 


        
        
        return self
    }
    
    
}
