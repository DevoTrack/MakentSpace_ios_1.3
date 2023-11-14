//
//  ExPrepaymentResponse.swift
//
//  Created by Ranjith Kumar on 12/18/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ExPrepaymentResponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let statusCode = "status_code"
    static let successMessage = "success_message"
    static let paymentData = "payment_data"
  }

  // MARK: Properties
  public var statusCode: String?
  public var successMessage: String?
  public var paymentData: PaymentData?

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
    statusCode = json[SerializationKeys.statusCode].string
    successMessage = json[SerializationKeys.successMessage].string
    paymentData = PaymentData(json: json[SerializationKeys.paymentData])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = statusCode { dictionary[SerializationKeys.statusCode] = value }
    if let value = successMessage { dictionary[SerializationKeys.successMessage] = value }
    if let value = paymentData { dictionary[SerializationKeys.paymentData] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.statusCode = aDecoder.decodeObject(forKey: SerializationKeys.statusCode) as? String
    self.successMessage = aDecoder.decodeObject(forKey: SerializationKeys.successMessage) as? String
    self.paymentData = aDecoder.decodeObject(forKey: SerializationKeys.paymentData) as? PaymentData
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(statusCode, forKey: SerializationKeys.statusCode)
    aCoder.encode(successMessage, forKey: SerializationKeys.successMessage)
    aCoder.encode(paymentData, forKey: SerializationKeys.paymentData)
  }

}
