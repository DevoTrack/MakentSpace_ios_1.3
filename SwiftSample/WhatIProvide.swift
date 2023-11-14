//
//  WhatIProvide.swift
//
//  Created by Ranjith Kumar on 9/19/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct WhatIProvide {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kWhatIProvideDescriptionValueKey: String = "description"
  private let kWhatIProvideNameKey: String = "name"
  private let kWhatIProvideImageKey: String = "image"

  // MARK: Properties
  public var descriptionValue: String?
  public var name: String?
  public var image: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    descriptionValue = json[kWhatIProvideDescriptionValueKey].string
    name = json[kWhatIProvideNameKey].string
    image = json[kWhatIProvideImageKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = descriptionValue { dictionary[kWhatIProvideDescriptionValueKey] = value }
    if let value = name { dictionary[kWhatIProvideNameKey] = value }
    if let value = image { dictionary[kWhatIProvideImageKey] = value }
    return dictionary
  }

}
