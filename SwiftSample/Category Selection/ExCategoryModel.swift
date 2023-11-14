//
//  ExCategoryModel.swift
//
//  Created by Ranjith Kumar on 10/2/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ExCategoryModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kExCategoryModelStatusCodeKey: String = "status_code"
  private let kExCategoryModelHostExperienceCategoriesKey: String = "host_experience_categories"
  private let kExCategoryModelSuccessMessageKey: String = "success_message"

  // MARK: Properties
  public var statusCode: String?
  public var hostExperienceCategories: [HostExperienceCategories]?
  public var successMessage: String?

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
    statusCode = json[kExCategoryModelStatusCodeKey].string
    if let items = json[kExCategoryModelHostExperienceCategoriesKey].array { hostExperienceCategories = items.map { HostExperienceCategories(json: $0) } }
    successMessage = json[kExCategoryModelSuccessMessageKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = statusCode { dictionary[kExCategoryModelStatusCodeKey] = value }
    if let value = hostExperienceCategories { dictionary[kExCategoryModelHostExperienceCategoriesKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = successMessage { dictionary[kExCategoryModelSuccessMessageKey] = value }
    return dictionary
  }

}
