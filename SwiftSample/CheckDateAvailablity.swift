//
//  CheckDateAvailablity.swift
//
//  Created by Ranjith Kumar on 12/5/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CheckDateAvailablity {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let statusCode = "status_code"
        static let spotsLeft = "spots_left"
        static let scheduledId = "scheduled_id"
        static let guestLastName = "guest_last_name"
        static let guestFirstName = "guest_first_name"
        static let guestUserImage = "guest_user_image"
        static let successMessage = "success_message"
    }

    // MARK: Properties
    public var statusCode: String?
    public var spotsLeft: Int?
    public var scheduledId: String?
    public var guestLastName: String?
    public var guestFirstName: String?
    public var guestUserImage: String?
    public var successMessage: String?

    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }

    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        statusCode = json[SerializationKeys.statusCode].string
        spotsLeft = json[SerializationKeys.spotsLeft].int
        scheduledId = json[SerializationKeys.scheduledId].string
        guestLastName = json[SerializationKeys.guestLastName].string
        guestFirstName = json[SerializationKeys.guestFirstName].string
        guestUserImage = json[SerializationKeys.guestUserImage].string
        successMessage = json[SerializationKeys.successMessage].string
    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = statusCode { dictionary[SerializationKeys.statusCode] = value }
        if let value = spotsLeft { dictionary[SerializationKeys.spotsLeft] = value }
        if let value = scheduledId { dictionary[SerializationKeys.scheduledId] = value }
        if let value = guestLastName { dictionary[SerializationKeys.guestLastName] = value }
        if let value = guestFirstName { dictionary[SerializationKeys.guestFirstName] = value }
        if let value = guestUserImage { dictionary[SerializationKeys.guestUserImage] = value }
        if let value = successMessage { dictionary[SerializationKeys.successMessage] = value }
        return dictionary
    }

}
