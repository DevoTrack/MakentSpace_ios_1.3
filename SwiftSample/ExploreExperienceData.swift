//
//  ExploreExperienceData.swift
//  Makent
//
//  Created by Boominadha Prakash on 08/09/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import Foundation

struct ExploreExperienceData {
    private struct SerializableKeys {
        static let kExperienceIdKey = "experience_id"
        static let kExperiencePriceKey = "experience_price"
        static let kExperienceNameKey = "experience_name"
        static let kExperienceThumbImageURLKey = "experience_thumb_images"
        static let kExperienceCategoryKey = "experience_category"
        static let kRatingValueKey = "rating"
        static let kReviewsCountKey = "reviews_count"
        static let kLatitudeKey = "latitude"
        static let kLongitudeKey = "longitude"
        static let kIsWishlistKey = "is_wishlist"
        static let kCountryNameKey = "country_name"
        static let kCityNameKey = "city_name"
        static let kCurrencyCodeKey = "currency_code"
        static let kCurrencySymbolKey = "currency_symbol"

    }

    var experienceID: Int
    var experiencePrice: Int
    var experienceName: String
    var experienceThumbImageURL: String
    var experienceCategory: String
    var ratingValue: String
    var reviewsCount: Int
    var latitude: String
    var longitude: String
    var isWishlist: String
    var countryName: String
    var cityName: String
    var currencyCode: String
    var currencySymbol: String
    var response: [String: Any]
    
    init(response: [String: Any]) {
        self.response = response
        self.experienceID = response[SerializableKeys.kExperienceIdKey] as! Int
        self.experiencePrice = response[SerializableKeys.kExperiencePriceKey] as! Int
        self.experienceName =  response[SerializableKeys.kExperienceNameKey] as! String
        self.experienceThumbImageURL = response[SerializableKeys.kExperienceThumbImageURLKey] as! String
        self.experienceCategory = response[SerializableKeys.kExperienceCategoryKey] as! String
        self.ratingValue = response[SerializableKeys.kRatingValueKey] as! String
        self.reviewsCount = response[SerializableKeys.kReviewsCountKey] as! Int
        self.latitude = response[SerializableKeys.kLatitudeKey] as! String
        self.longitude = response[SerializableKeys.kLongitudeKey] as! String
        self.isWishlist = response[SerializableKeys.kIsWishlistKey] as! String
        self.countryName = response[SerializableKeys.kCountryNameKey] as! String
        self.cityName = response[SerializableKeys.kCityNameKey] as! String
        self.currencyCode = response[SerializableKeys.kCurrencyCodeKey] as! String
        self.currencySymbol = response[SerializableKeys.kCurrencySymbolKey] as! String
    }
}
