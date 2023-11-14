//
//  ExperienceRoomDetails.swift
//
//  Created by Ranjith Kumar on 9/19/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ExperienceRoomDetails {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kExperienceRoomDetailsReviewsCountKey: String = "reviews_count"
  private let kExperienceRoomDetailsHostUserNameKey: String = "host_user_name"
  private let kExperienceRoomDetailsCurrencySymbolKey: String = "currency_symbol"
  private let kExperienceRoomDetailsCategoryTypeKey: String = "category_type"
  private let kExperienceRoomDetailsIncludesAlcoholKey: String = "includes_alcohol"
  private let kExperienceRoomDetailsLanguageKey: String = "language"
  private let kExperienceRoomDetailsBlockedDatesKey: String = "blocked_dates"
  private let kExperienceRoomDetailsCurrencyCodeKey: String = "currency_code"
  private let kExperienceRoomDetailsHostUserDescriptionKey: String = "host_user_description"
  private let kExperienceRoomDetailsSuccessMessageKey: String = "success_message"
  private let kExperienceRoomDetailsLocLongitudeKey: String = "loc_longitude"
  private let kExperienceRoomDetailsHostUserIdKey: String = "host_user_id"
  private let kExperienceRoomDetailsWhatWillDoKey: String = "what_will_do"
  private let kExperienceRoomDetailsCanBookKey: String = "can_book"
  private let kExperienceRoomDetailsStatusCodeKey: String = "status_code"
  private let kExperienceRoomDetailsHostUserImageKey: String = "host_user_image"
  private let kExperienceRoomDetailsEndTimeKey: String = "end_time"
  private let kExperienceRoomDetailsExperiencePriceKey: String = "experience_price"
  private let kExperienceRoomDetailsRatingValueKey: String = "rating_value"
  private let kExperienceRoomDetailsExperienceShareUrlKey: String = "experience_share_url"
  private let kExperienceRoomDetailsExperienceIdKey: String = "experience_id"
  private let kExperienceRoomDetailsNotesKey: String = "notes"
  private let kExperienceRoomDetailsCityKey: String = "city"
  private let kExperienceRoomDetailsCityNameKey: String = "city_name"
  private let kExperienceRoomDetailsWhoCanComeKey: String = "who_can_come"
  private let kExperienceRoomDetailsExperienceNameKey: String = "experience_name"
  private let kExperienceRoomDetailsStartTimeKey: String = "start_time"
  private let kExperienceRoomDetailsProvideItemsKey: String = "provide_items"
  private let kExperienceRoomDetailsSimilarListDetailsKey: String = "similar_list_details"
  private let kExperienceRoomDetailsWhatIProvideKey: String = "what_i_provide"
  private let kExperienceRoomDetailsIsWhishlistKey: String = "is_whishlist"
  private let kExperienceRoomDetailsLocLatitudeKey: String = "loc_latitude"
  private let kExperienceRoomDetailsExperienceImagesKey: String = "experience_images"
  private let kExperienceRoomDetailsHoursKey: String = "hours"
  private let kExperienceRoomDetailsNoOfGuestKey: String = "no_of_guest"
  private let kExperienceRoomDetailsWhereWillBeKey: String = "where_will_be"
  private let kExperienceRoomDetailsLocaitonNameKey: String = "locaiton_name"
  private let kExperienceRoomDetailsMinimumAgeHeadingKey: String = "minimum_age_heading"
  private let kExperienceRoomDetailsMinimumAgeKey: String = "minimum_age"
  private let kExperienceRoomDetailsAlcoholKey: String = "alcohol"
  private let kExperienceRoomDetailsAalcoholHeadinglKey:String = "alcohol_heading"
  private let kExperienceRoomDetailsAdditionalRequirementsKey: String = "additional_requirements"
  private let kExperienceRoomDetailsAdditionalHeadingKey: String = "additional_heading"
  private let kExperienceRoomDetailsAllowedUnder2Key: String = "allowed_under_2"
  private let kExperienceRoomDetailsWhoCanComeHeadingKey: String = "who_can_come_heading"

    

    


  // MARK: Properties
  public var reviewsCount: Int?
  public var hostUserName: String?
  public var currencySymbol: String?
  public var categoryType: String?
  public var includesAlcohol: String?
  public var language: String?
  public var blockedDates: [String]?
  public var currencyCode: String?
  public var hostUserDescription: String?
  public var successMessage: String?
  public var locLongitude: String?
  public var hostUserId: Int?
  public var whatWillDo: String?
  public var canBook: String?
  public var statusCode: String?
  public var hostUserImage: String?
  public var endTime: String?
  public var experiencePrice: Int?
  public var ratingValue: String?
  public var experienceShareUrl: String?
  public var experienceId: Int?
  public var notes: String?
  public var city: String?
  public var cityName: String?
  public var whoCanCome: String?
  public var experienceName: String?
  public var startTime: String?
  public var provideItems: String?
  public var similarListDetails: [Any]?
  public var whatIProvide: [WhatIProvide]?
  public var isWhishlist: String?
  public var locLatitude: String?
  public var experienceImages: [ExperienceImages]?
  public var hours: Float?
  public var noOfGuest: Int?
  public var whereWillBe: String?
  public var locaitonName: String?
  public var minimumAgeHeading : String?
  public var minimumAge : String?
  public var alcohol : String?
  public var alcoholHeading : String?
  public var additionalRequirements: String?
  public var additionalHeading : String?
  public var allowedUnder2 : String?
  public var whoCanComeHeading : String?

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
    reviewsCount = json[kExperienceRoomDetailsReviewsCountKey].int
    hostUserName = json[kExperienceRoomDetailsHostUserNameKey].string
    currencySymbol = json[kExperienceRoomDetailsCurrencySymbolKey].string
    categoryType = json[kExperienceRoomDetailsCategoryTypeKey].string
    includesAlcohol = json[kExperienceRoomDetailsIncludesAlcoholKey].string
    language = json[kExperienceRoomDetailsLanguageKey].string
    if let items = json[kExperienceRoomDetailsBlockedDatesKey].array { blockedDates = items.map { $0.stringValue } }
    currencyCode = json[kExperienceRoomDetailsCurrencyCodeKey].string
    hostUserDescription = json[kExperienceRoomDetailsHostUserDescriptionKey].string
    successMessage = json[kExperienceRoomDetailsSuccessMessageKey].string
    locLongitude = json[kExperienceRoomDetailsLocLongitudeKey].string
    hostUserId = json[kExperienceRoomDetailsHostUserIdKey].int
    whatWillDo = json[kExperienceRoomDetailsWhatWillDoKey].string
    canBook = json[kExperienceRoomDetailsCanBookKey].string
    statusCode = json[kExperienceRoomDetailsStatusCodeKey].string
    hostUserImage = json[kExperienceRoomDetailsHostUserImageKey].string
    endTime = json[kExperienceRoomDetailsEndTimeKey].string
    experiencePrice = json[kExperienceRoomDetailsExperiencePriceKey].int
    ratingValue = json[kExperienceRoomDetailsRatingValueKey].string
    experienceShareUrl = json[kExperienceRoomDetailsExperienceShareUrlKey].string
    experienceId = json[kExperienceRoomDetailsExperienceIdKey].int
    notes = json[kExperienceRoomDetailsNotesKey].string
    city = json[kExperienceRoomDetailsCityKey].string
    cityName = json[kExperienceRoomDetailsCityNameKey].string
    whoCanCome = json[kExperienceRoomDetailsWhoCanComeKey].string
    experienceName = json[kExperienceRoomDetailsExperienceNameKey].string
    startTime = json[kExperienceRoomDetailsStartTimeKey].string
    provideItems = json[kExperienceRoomDetailsProvideItemsKey].string
    if let items = json[kExperienceRoomDetailsSimilarListDetailsKey].array { similarListDetails = items.map { $0.object} }
    if let items = json[kExperienceRoomDetailsWhatIProvideKey].array { whatIProvide = items.map { WhatIProvide(json: $0) } }
    isWhishlist = json[kExperienceRoomDetailsIsWhishlistKey].string
    locLatitude = json[kExperienceRoomDetailsLocLatitudeKey].string
    if let items = json[kExperienceRoomDetailsExperienceImagesKey].array { experienceImages = items.map { ExperienceImages(json: $0) } }
    hours = json[kExperienceRoomDetailsHoursKey].float
    noOfGuest = json[kExperienceRoomDetailsNoOfGuestKey].int
    whereWillBe = json[kExperienceRoomDetailsWhereWillBeKey].string
    locaitonName = json[kExperienceRoomDetailsLocaitonNameKey].string
    minimumAgeHeading = json[kExperienceRoomDetailsMinimumAgeHeadingKey].string
    minimumAge = json[kExperienceRoomDetailsMinimumAgeKey].string
    alcohol = json[kExperienceRoomDetailsAlcoholKey].string
    alcoholHeading = json[kExperienceRoomDetailsAalcoholHeadinglKey].string
    additionalRequirements = json[kExperienceRoomDetailsAdditionalRequirementsKey].string
    additionalHeading = json[kExperienceRoomDetailsAdditionalHeadingKey].string
    allowedUnder2 = json[kExperienceRoomDetailsAllowedUnder2Key].string
    whoCanComeHeading =  json[kExperienceRoomDetailsWhoCanComeHeadingKey].string

  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = reviewsCount { dictionary[kExperienceRoomDetailsReviewsCountKey] = value }
    if let value = hostUserName { dictionary[kExperienceRoomDetailsHostUserNameKey] = value }
    if let value = currencySymbol { dictionary[kExperienceRoomDetailsCurrencySymbolKey] = value }
    if let value = categoryType { dictionary[kExperienceRoomDetailsCategoryTypeKey] = value }
    if let value = includesAlcohol { dictionary[kExperienceRoomDetailsIncludesAlcoholKey] = value }
    if let value = language { dictionary[kExperienceRoomDetailsLanguageKey] = value }
    if let value = blockedDates { dictionary[kExperienceRoomDetailsBlockedDatesKey] = value }
    if let value = currencyCode { dictionary[kExperienceRoomDetailsCurrencyCodeKey] = value }
    if let value = hostUserDescription { dictionary[kExperienceRoomDetailsHostUserDescriptionKey] = value }
    if let value = successMessage { dictionary[kExperienceRoomDetailsSuccessMessageKey] = value }
    if let value = locLongitude { dictionary[kExperienceRoomDetailsLocLongitudeKey] = value }
    if let value = hostUserId { dictionary[kExperienceRoomDetailsHostUserIdKey] = value }
    if let value = whatWillDo { dictionary[kExperienceRoomDetailsWhatWillDoKey] = value }
    if let value = canBook { dictionary[kExperienceRoomDetailsCanBookKey] = value }
    if let value = statusCode { dictionary[kExperienceRoomDetailsStatusCodeKey] = value }
    if let value = hostUserImage { dictionary[kExperienceRoomDetailsHostUserImageKey] = value }
    if let value = endTime { dictionary[kExperienceRoomDetailsEndTimeKey] = value }
    if let value = experiencePrice { dictionary[kExperienceRoomDetailsExperiencePriceKey] = value }
    if let value = ratingValue { dictionary[kExperienceRoomDetailsRatingValueKey] = value }
    if let value = experienceShareUrl { dictionary[kExperienceRoomDetailsExperienceShareUrlKey] = value }
    if let value = experienceId { dictionary[kExperienceRoomDetailsExperienceIdKey] = value }
    if let value = notes { dictionary[kExperienceRoomDetailsNotesKey] = value }
    if let value = city { dictionary[kExperienceRoomDetailsCityKey] = value }
    if let value = cityName { dictionary[kExperienceRoomDetailsCityNameKey] = value }
    if let value = whoCanCome { dictionary[kExperienceRoomDetailsWhoCanComeKey] = value }
    if let value = experienceName { dictionary[kExperienceRoomDetailsExperienceNameKey] = value }
    if let value = startTime { dictionary[kExperienceRoomDetailsStartTimeKey] = value }
    if let value = provideItems { dictionary[kExperienceRoomDetailsProvideItemsKey] = value }
    if let value = similarListDetails { dictionary[kExperienceRoomDetailsSimilarListDetailsKey] = value }
    if let value = whatIProvide { dictionary[kExperienceRoomDetailsWhatIProvideKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = isWhishlist { dictionary[kExperienceRoomDetailsIsWhishlistKey] = value }
    if let value = locLatitude { dictionary[kExperienceRoomDetailsLocLatitudeKey] = value }
    if let value = experienceImages { dictionary[kExperienceRoomDetailsExperienceImagesKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = hours { dictionary[kExperienceRoomDetailsHoursKey] = value }
    if let value = noOfGuest { dictionary[kExperienceRoomDetailsNoOfGuestKey] = value }
    if let value = whereWillBe { dictionary[kExperienceRoomDetailsWhereWillBeKey] = value }
    if let value = locaitonName { dictionary[kExperienceRoomDetailsLocaitonNameKey] = value }
    
    if let value = minimumAgeHeading { dictionary[kExperienceRoomDetailsMinimumAgeHeadingKey] = value }
    if let value = minimumAge { dictionary[kExperienceRoomDetailsMinimumAgeKey] = value }
    if let value = alcohol { dictionary[kExperienceRoomDetailsAlcoholKey] = value }
    if let value = alcoholHeading { dictionary[kExperienceRoomDetailsAalcoholHeadinglKey] = value }
    if let value = additionalRequirements { dictionary[kExperienceRoomDetailsAdditionalRequirementsKey] = value }
    if let value = additionalHeading { dictionary[kExperienceRoomDetailsAdditionalHeadingKey] = value }
    if let value = allowedUnder2 { dictionary[kExperienceRoomDetailsAllowedUnder2Key] = value }
    if let value = whoCanComeHeading { dictionary[kExperienceRoomDetailsWhoCanComeHeadingKey] = value }
    return dictionary
  }

}
