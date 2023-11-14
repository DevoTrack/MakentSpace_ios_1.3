//
//  GetPaymentModel.swift
//  Makent
//
//  Created by trioangle on 23/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class PaymentDetailData
{
    var data     : DataDetails!
    var paymentCredential : PaymentCredential!
    init(json : JSONS) {
       self.data = DataDetails(dataJson: json.json("data"))
        self.paymentCredential = PaymentCredential(paymentJson: json.json("payment_credentials"))
    }
}

class DataDetails
{
    var id = String()
    var spaceId = Int()
    var bookingDateTimes : BookingDateTimes!
    var numberOfGuest    = Int()
    var specialOfferId   = Int()
    var reservationId    = Int()
    var couponCode       = String()
    var sKey             = String()
    var spaceName        = String()
    var spaceTypeName    = String()
    var spaceAddress     = String()
    var hostUserId       = Int()
    var hostUserName     = String()
    var hostThumbImage   = String()
    var activityType     = String()
    var bookingDateTime  = String()
    var totalHours       = Int()
    var paymentTotal     = Int()
    var couponApplied    = Bool()
    var currencyCode     = String()
    var currencySymbol   = String()
    var paymentPriceRate = String()
    var paymentCurrency  = String()
    var paymentPrice     = Int()
    
    init(dataJson : JSONS) {
        self.id = dataJson.string("id")
        self.spaceId  =  dataJson.int("space_id")
        self.bookingDateTimes = BookingDateTimes(bookingJson: dataJson.json("booking_date_times"))
        self.numberOfGuest   = dataJson.int("number_of_guests")
        self.specialOfferId = dataJson.int("special_offer_id")
        self.reservationId  = dataJson.int("reservation_id")
        self.couponCode     = dataJson.string("coupon_code")
        self.sKey           = dataJson.string("s_key")
        self.spaceName      = dataJson.string("space_name")
        self.spaceTypeName    = dataJson.string("space_type_name")
        self.spaceAddress     = dataJson.string("space_address")
        self.hostUserId       = dataJson.int("host_user_id")
        self.hostUserName     = dataJson.string("host_user_name")
        self.hostThumbImage   = dataJson.string("host_thumb_image")
        self.activityType     = dataJson.string("activity_type")
        self.bookingDateTime  = dataJson.string("boooking_date_time")
        self.totalHours       = dataJson.int("total_hours")
        self.paymentTotal     = dataJson.int("payment_total")
        self.couponApplied    = dataJson.bool("coupon_applied")
        self.currencyCode     = dataJson.string("currency_code")
        self.currencySymbol   = dataJson.string("currency_symbol")
        self.paymentPriceRate = dataJson.string("payment_price_rate")
        self.paymentCurrency  = dataJson.string("payment_currency")
        self.paymentPrice     = dataJson.int("payment_price")
    }
}

class PaymentCredential
{
    var paypalLiveMode = Bool()
    var paypalClientID = String()
    var stripePublishKey = String()
    
    init(paymentJson : JSONS)
    {
        self.paypalLiveMode = paymentJson.bool("PAYPAL_LIVE_MODE")
        self.paypalClientID = paymentJson.string("PAYPAL_CLIENT_ID")
        self.stripePublishKey = paymentJson.string("STRIPE_PUBLISH_KEY")
    }
}

class BookingDateTimes
{
    var endDate = String()
    var endTime = String()
    var startDate = String()
    var startTime = String()
    var formattedStartDate = String()
    var formattedEndDate   = String()
    init(bookingJson : JSONS)
    {
        self.endDate = bookingJson.string("end_date")
        self.endTime = bookingJson.string("end_time")
        self.startDate = bookingJson.string("start_date")
        self.startTime = bookingJson.string("start_time")
        self.formattedStartDate = bookingJson.string("formatted_start_date")
        self.formattedEndDate   = bookingJson.string("formatted_end_date")
    }
}
