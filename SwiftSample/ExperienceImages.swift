//
//  ExperienceImages.swift
//
//  Created by Ranjith Kumar on 9/19/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ExperienceImages {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kExperienceImagesNameKey: String = "name"

  // MARK: Properties
  public var name: String?

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
    name = json[kExperienceImagesNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kExperienceImagesNameKey] = value }
    return dictionary
  }

}
