//
//  HostExperienceCategories.swift
//
//  Created by Ranjith Kumar on 10/2/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class HostExperienceCategories: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHostExperienceCategoriesInternalIdentifierKey: String = "id"
  private let kHostExperienceCategoriesNameKey: String = "name"

  // MARK: Properties
  public var internalIdentifier: Int?
  public var name: String?
    var isSelected: Bool = false

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
    public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    internalIdentifier = json[kHostExperienceCategoriesInternalIdentifierKey].int
    name = json[kHostExperienceCategoriesNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kHostExperienceCategoriesInternalIdentifierKey] = value }
    if let value = name { dictionary[kHostExperienceCategoriesNameKey] = value }
    return dictionary
  }

}
