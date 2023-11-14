//
//  PaymentData.swift
//
//  Created by Ranjith Kumar on 12/18/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class PaymentData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let couponCode = "coupon_code"
    static let hostExperienceId = "host_experience_id"
    static let currencyCode = "currency_code"
    static let couponCodeApplied = "coupon_code_applied"
    static let serviceFee = "service_fee"
    static let guestDetails = "guest_details"
    static let hostUserImage = "host_user_image"
    static let paypalExchangeRate = "paypal_exchange_rate"
    static let spotsLeft = "spots_left"
    static let total = "total"
    static let endTime = "end_time"
    static let couponPrice = "coupon_price"
    static let startTime = "start_time"
    static let couponCodeError = "coupon_code_error"
    static let paypalCurrencySymbol = "paypal_currency_symbol"
    static let totalHours = "total_hours"
    static let paypalCurrencyCode = "paypal_currency_code"
    static let date = "date"
    static let subtotal = "subtotal"
    static let numberOfGuests = "number_of_guests"
    static let isReserved = "is_reserved"
    static let price = "price"
    static let hostName = "host_name"
    static let status = "status"
    static let hostExperienceName = "host_experience_name"
    static let paypalPrice = "paypal_price"
    static let isAvailableBooking = "is_available_booking"
    static let isCouponCode = "is_coupon_code"
    static let currencySymbol = "currency_symbol"
  }

  // MARK: Properties
  public var couponCode: String?
  public var hostExperienceId: String?
  public var currencyCode: String?
  public var couponCodeApplied: Bool? = false
  public var serviceFee: Int?
  public var guestDetails: [Any]?
  public var hostUserImage: String?
  public var paypalExchangeRate: Int?
  public var spotsLeft: Int?
  public var total: Int?
  public var endTime: String?
  public var couponPrice: Int?
  public var startTime: String?
  public var couponCodeError: String?
  public var paypalCurrencySymbol: String?
  public var totalHours: Int?
  public var paypalCurrencyCode: String?
  public var date: String?
  public var subtotal: Int?
  public var numberOfGuests: Int?
  public var isReserved: Bool? = false
  public var price: Int?
  public var hostName: String?
  public var status: String?
  public var hostExperienceName: String?
  public var paypalPrice: Int?
  public var isAvailableBooking: Bool? = false
  public var isCouponCode: Bool? = false
  public var currencySymbol: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    couponCode = json[SerializationKeys.couponCode].string
    hostExperienceId = json[SerializationKeys.hostExperienceId].string
    currencyCode = json[SerializationKeys.currencyCode].string
    couponCodeApplied = json[SerializationKeys.couponCodeApplied].boolValue
    serviceFee = json[SerializationKeys.serviceFee].int
    if let items = json[SerializationKeys.guestDetails].array { guestDetails = items.map { $0.object} }
    hostUserImage = json[SerializationKeys.hostUserImage].string
    paypalExchangeRate = json[SerializationKeys.paypalExchangeRate].int
    spotsLeft = json[SerializationKeys.spotsLeft].int
    total = json[SerializationKeys.total].int
    endTime = json[SerializationKeys.endTime].string
    couponPrice = json[SerializationKeys.couponPrice].int
    startTime = json[SerializationKeys.startTime].string
    couponCodeError = json[SerializationKeys.couponCodeError].string
    paypalCurrencySymbol = json[SerializationKeys.paypalCurrencySymbol].string
    totalHours = json[SerializationKeys.totalHours].int
    paypalCurrencyCode = json[SerializationKeys.paypalCurrencyCode].string
    date = json[SerializationKeys.date].string
    subtotal = json[SerializationKeys.subtotal].int
    numberOfGuests = json[SerializationKeys.numberOfGuests].int
    isReserved = json[SerializationKeys.isReserved].boolValue
    price = json[SerializationKeys.price].int
    hostName = json[SerializationKeys.hostName].string
    status = json[SerializationKeys.status].string
    hostExperienceName = json[SerializationKeys.hostExperienceName].string
    paypalPrice = json[SerializationKeys.paypalPrice].int
    isAvailableBooking = json[SerializationKeys.isAvailableBooking].boolValue
    isCouponCode = json[SerializationKeys.isCouponCode].boolValue
    currencySymbol = json[SerializationKeys.currencySymbol].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = couponCode { dictionary[SerializationKeys.couponCode] = value }
    if let value = hostExperienceId { dictionary[SerializationKeys.hostExperienceId] = value }
    if let value = currencyCode { dictionary[SerializationKeys.currencyCode] = value }
    dictionary[SerializationKeys.couponCodeApplied] = couponCodeApplied
    if let value = serviceFee { dictionary[SerializationKeys.serviceFee] = value }
    if let value = guestDetails { dictionary[SerializationKeys.guestDetails] = value }
    if let value = hostUserImage { dictionary[SerializationKeys.hostUserImage] = value }
    if let value = paypalExchangeRate { dictionary[SerializationKeys.paypalExchangeRate] = value }
    if let value = spotsLeft { dictionary[SerializationKeys.spotsLeft] = value }
    if let value = total { dictionary[SerializationKeys.total] = value }
    if let value = endTime { dictionary[SerializationKeys.endTime] = value }
    if let value = couponPrice { dictionary[SerializationKeys.couponPrice] = value }
    if let value = startTime { dictionary[SerializationKeys.startTime] = value }
    if let value = couponCodeError { dictionary[SerializationKeys.couponCodeError] = value }
    if let value = paypalCurrencySymbol { dictionary[SerializationKeys.paypalCurrencySymbol] = value }
    if let value = totalHours { dictionary[SerializationKeys.totalHours] = value }
    if let value = paypalCurrencyCode { dictionary[SerializationKeys.paypalCurrencyCode] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = subtotal { dictionary[SerializationKeys.subtotal] = value }
    if let value = numberOfGuests { dictionary[SerializationKeys.numberOfGuests] = value }
    dictionary[SerializationKeys.isReserved] = isReserved
    if let value = price { dictionary[SerializationKeys.price] = value }
    if let value = hostName { dictionary[SerializationKeys.hostName] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = hostExperienceName { dictionary[SerializationKeys.hostExperienceName] = value }
    if let value = paypalPrice { dictionary[SerializationKeys.paypalPrice] = value }
    dictionary[SerializationKeys.isAvailableBooking] = isAvailableBooking
    dictionary[SerializationKeys.isCouponCode] = isCouponCode
    if let value = currencySymbol { dictionary[SerializationKeys.currencySymbol] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.couponCode = aDecoder.decodeObject(forKey: SerializationKeys.couponCode) as? String
    self.hostExperienceId = aDecoder.decodeObject(forKey: SerializationKeys.hostExperienceId) as? String
    self.currencyCode = aDecoder.decodeObject(forKey: SerializationKeys.currencyCode) as? String
    self.couponCodeApplied = aDecoder.decodeBool(forKey: SerializationKeys.couponCodeApplied)
    self.serviceFee = aDecoder.decodeObject(forKey: SerializationKeys.serviceFee) as? Int
    self.guestDetails = aDecoder.decodeObject(forKey: SerializationKeys.guestDetails) as? [Any]
    self.hostUserImage = aDecoder.decodeObject(forKey: SerializationKeys.hostUserImage) as? String
    self.paypalExchangeRate = aDecoder.decodeObject(forKey: SerializationKeys.paypalExchangeRate) as? Int
    self.spotsLeft = aDecoder.decodeObject(forKey: SerializationKeys.spotsLeft) as? Int
    self.total = aDecoder.decodeObject(forKey: SerializationKeys.total) as? Int
    self.endTime = aDecoder.decodeObject(forKey: SerializationKeys.endTime) as? String
    self.couponPrice = aDecoder.decodeObject(forKey: SerializationKeys.couponPrice) as? Int
    self.startTime = aDecoder.decodeObject(forKey: SerializationKeys.startTime) as? String
    self.couponCodeError = aDecoder.decodeObject(forKey: SerializationKeys.couponCodeError) as? String
    self.paypalCurrencySymbol = aDecoder.decodeObject(forKey: SerializationKeys.paypalCurrencySymbol) as? String
    self.totalHours = aDecoder.decodeObject(forKey: SerializationKeys.totalHours) as? Int
    self.paypalCurrencyCode = aDecoder.decodeObject(forKey: SerializationKeys.paypalCurrencyCode) as? String
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.subtotal = aDecoder.decodeObject(forKey: SerializationKeys.subtotal) as? Int
    self.numberOfGuests = aDecoder.decodeObject(forKey: SerializationKeys.numberOfGuests) as? Int
    self.isReserved = aDecoder.decodeBool(forKey: SerializationKeys.isReserved)
    self.price = aDecoder.decodeObject(forKey: SerializationKeys.price) as? Int
    self.hostName = aDecoder.decodeObject(forKey: SerializationKeys.hostName) as? String
    self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? String
    self.hostExperienceName = aDecoder.decodeObject(forKey: SerializationKeys.hostExperienceName) as? String
    self.paypalPrice = aDecoder.decodeObject(forKey: SerializationKeys.paypalPrice) as? Int
    self.isAvailableBooking = aDecoder.decodeBool(forKey: SerializationKeys.isAvailableBooking)
    self.isCouponCode = aDecoder.decodeBool(forKey: SerializationKeys.isCouponCode)
    self.currencySymbol = aDecoder.decodeObject(forKey: SerializationKeys.currencySymbol) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(couponCode, forKey: SerializationKeys.couponCode)
    aCoder.encode(hostExperienceId, forKey: SerializationKeys.hostExperienceId)
    aCoder.encode(currencyCode, forKey: SerializationKeys.currencyCode)
    aCoder.encode(couponCodeApplied, forKey: SerializationKeys.couponCodeApplied)
    aCoder.encode(serviceFee, forKey: SerializationKeys.serviceFee)
    aCoder.encode(guestDetails, forKey: SerializationKeys.guestDetails)
    aCoder.encode(hostUserImage, forKey: SerializationKeys.hostUserImage)
    aCoder.encode(paypalExchangeRate, forKey: SerializationKeys.paypalExchangeRate)
    aCoder.encode(spotsLeft, forKey: SerializationKeys.spotsLeft)
    aCoder.encode(total, forKey: SerializationKeys.total)
    aCoder.encode(endTime, forKey: SerializationKeys.endTime)
    aCoder.encode(couponPrice, forKey: SerializationKeys.couponPrice)
    aCoder.encode(startTime, forKey: SerializationKeys.startTime)
    aCoder.encode(couponCodeError, forKey: SerializationKeys.couponCodeError)
    aCoder.encode(paypalCurrencySymbol, forKey: SerializationKeys.paypalCurrencySymbol)
    aCoder.encode(totalHours, forKey: SerializationKeys.totalHours)
    aCoder.encode(paypalCurrencyCode, forKey: SerializationKeys.paypalCurrencyCode)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(subtotal, forKey: SerializationKeys.subtotal)
    aCoder.encode(numberOfGuests, forKey: SerializationKeys.numberOfGuests)
    aCoder.encode(isReserved, forKey: SerializationKeys.isReserved)
    aCoder.encode(price, forKey: SerializationKeys.price)
    aCoder.encode(hostName, forKey: SerializationKeys.hostName)
    aCoder.encode(status, forKey: SerializationKeys.status)
    aCoder.encode(hostExperienceName, forKey: SerializationKeys.hostExperienceName)
    aCoder.encode(paypalPrice, forKey: SerializationKeys.paypalPrice)
    aCoder.encode(isAvailableBooking, forKey: SerializationKeys.isAvailableBooking)
    aCoder.encode(isCouponCode, forKey: SerializationKeys.isCouponCode)
    aCoder.encode(currencySymbol, forKey: SerializationKeys.currencySymbol)
  }

}
