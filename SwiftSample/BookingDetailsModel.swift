//
//  BookingDetailsModel.swift
//  Makent
//
//  Created by trioangle on 06/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//
import Foundation


class BaseBookingModel {
    
    var reservationID = Int()
    var spaceID = Int()
    var bookingStatus = String()
    var reservationStatus = String()
    var spaceName = String()
    var spaceTypeName = String()
    var spaceImage = String()
    var spaceLocation = String()
    var memberFrom = String()
    var reservationDate = String()
    var checkin = String()
    var checkout = String()
    var startTime = String()
    var endTime = String()
    var numberOfGuests = String()
    var guidance = String()
    var currencySymbol = String()
    var totalCost = String()
    var reviewCount = String()
    var specialOfferID = String()
    var specialOfferStatus = String()
    var canViewReceipt = Bool()
    var paymentRecievedDate = String()
    var expireTimer = String()
    var requestUserID  = Int()
    var guestUserID =  Int()
    var userType = String()
    var host_user_deleted = Bool()
    init(json:JSONS)
    {
         self.reservationID       =  json.int("reservation_id")
         self.spaceID             = json.int("space_id")
         self.bookingStatus       = json.string("booking_status")
         self.reservationStatus   = json.string("reservation_status")
         self.spaceName           = json.string("space_name")
         self.spaceTypeName       = json.string("space_type_name")
         self.spaceImage          = json.string("space_image")
         self.spaceLocation       = json.string("space_location")
         self.memberFrom          = json.string("member_from")
         self.reservationDate     = json.string("reservation_date")
         self.guidance            = json.string("check_in_guidance")
         self.checkin             = json.string("checkin")
         self.checkout            = json.string("checkout")
         self.startTime           = json.string("start_time")
         self.endTime             = json.string("end_time")
         self.numberOfGuests      = json.string("number_of_guests")
         self.currencySymbol      = json.string("currency_symbol").stringByDecodingHTMLEntities
         self.totalCost           = json.string("total_cost")
         self.reviewCount         = json.string("review_count")
         self.specialOfferStatus  = json.string("special_offer_status")
         self.paymentRecievedDate = json.string("payment_recieved_date")
         self.expireTimer         = json.string("expire_timer")
         self.canViewReceipt      = json.bool("can_view_receipt")
        self.requestUserID  = json.int("request_user_id")
        self.guestUserID =  json.int("guest_user_id")
        self.userType = json.string("user_type")
        self.host_user_deleted = json.bool("host_user_deleted")
    }
}

class InboxBookingModel:ReservationBookingModel {
    var isMessageRead  = Int()
    var lastMessage    = String()
//    var requestUserID  = Int()
    
    init(jsons:JSONS) {
        super.init(reservDict: jsons)
        self.isMessageRead  = jsons.int("is_message_read")
        self.lastMessage    = jsons.string("last_message")
//        self.requestUserID  = jsons.int("request_user_id")
    }
}

class ReservationBookingModel:BaseBookingModel {
    var totalHours = String()
    var otherUserName = String()
    var otherThumbImage = String()
    var otherUserLocation = String()
    var otherUserID = Int()
    
    init(reservDict:JSONS) {
        super.init(json: reservDict)
        self.totalHours = reservDict.string("total_hours")
        self.otherUserName = reservDict.string("other_user_name")
        self.otherThumbImage = reservDict.string("other_thumb_image")
        self.otherUserLocation = reservDict.string("other_user_location")
        self.otherUserID = reservDict.int("other_user_id")
    }
}

class TripBookingModel:BaseBookingModel {
//    var guestUserID = Int()
    var guestUserName = String()
    var guestThumbImage = String()
    var guestUserLocation = String()
    
    var hostUserID = Int()
    var hostUserName = String()
    var hostThumbImage = String()
    
    init(tripDict:JSONS) {
        super.init(json: tripDict)
//        self.guestUserID =  tripDict.int("guest_user_id")
        self.hostUserID =  tripDict.int("host_user_id")
        self.guestUserName = tripDict.string("guest_user_name")
        self.guestThumbImage = tripDict.string("guest_thumb_image")
        self.guestUserLocation = tripDict.string("guest_user_location")
        self.hostUserName = tripDict.string("host_user_name")
        self.hostThumbImage = tripDict.string("host_thumb_image")
    }
}
