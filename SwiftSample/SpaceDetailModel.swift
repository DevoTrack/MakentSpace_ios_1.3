//
//  SpaceDetailModel.swift
//  Makent
//
//  Created by trioangle on 04/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class SpaceDetailData:BasicListDetails
{
    var statusCode          = String()
    var SuccessMessage      = String()
    
    var spaceUrl            = String()
    
    var hostProfilePic      = String()
    var canBook             = String()
    
    var summary             = String()
    var userId              = Int()
    var hostName            = String()
    var wishList            = String()
    
    var numberOfGuests      = Int()
    var numberOfRooms       = Int()
    var numberOfRestRoom    = Int()
    var floorNumber         = Int()
    var squareFeet          = String()
    var cancellationPolicy  = String()
    var serviceExtra        = String()
    var reviewMessage       = String()
    var reviewUserName      = String()
    var reviewUserImage     = String()
    var reviewDate          = String()
    var maximumGuest        = String()
    
    var spacePhoto          = [SpacePhoto]()
    var spaceActivities     = [ActivityPrice]()
    var amenities           = [Amenities]()
    var guestAccess         = [Space2Type]()
    var services            = [Space2Type]()
    var spaceStyle          = [Space2Type]()
    var specialFeatures     = [Space2Type]()
    var spaceRules          = [Space2Type]()
    var theSpace            = [Space2Type]()
    var similarList         = [SimilarListDetails]()
    var availabilityTimes   = [AvailabilityTime]()
    var locationData: LocationData!
    var notAvailableDates = [String]()
    
    init(json: JSONS) {
        super.init(baseJSONS: json)
        self.notAvailableDates = json.array("not_available_dates")
        self.statusCode         = json.string("status_code")
        self.SuccessMessage     = json.string("success_message")
        self.spaceUrl           = json.string("space_url")
        self.hostProfilePic     = json.string("host_profile_pic")
        self.canBook            = json.string("can_book")
        self.wishList           = json.string("is_wishlist")
        self.summary            = json.string("summary")
        self.userId             = json.int("user_id")
        self.hostName           = json.string("host_name")
        self.numberOfGuests     = json.int("number_of_guests")
        self.numberOfRooms      = json.int("number_of_rooms")
        self.numberOfRestRoom   = json.int("number_of_restrooms")
        self.floorNumber        = json.int("floor_number")
        self.squareFeet         = json.string("sq_ft_text")
        self.cancellationPolicy = json.string("cancellation_policy")
        self.serviceExtra       = json.string("services_extra")
        self.reviewMessage      = json.string("review_message")
        self.reviewUserName     = json.string("review_user_name")
        self.reviewUserImage    = json.string("review_user_image")
        self.reviewDate         = json.string("review_date")
        self.maximumGuest       = json.string("maximum_guests")
        self.locationData       = LocationData(locationDataJson: json.json("location_data"))
        
        self.spacePhoto.removeAll()
        json.array("space_photos").forEach { (temp) in
            let model = SpacePhoto(photoJson: temp)
            self.spacePhoto.append(model)
        }
        
        self.theSpace.removeAll()
        json.array("the_space").forEach { (temp) in
            let model = Space2Type(json: temp)
            self.theSpace.append(model)
        }
        
        self.spaceActivities.removeAll()
        json.array("space_activities").forEach { (temp) in
            let model = ActivityPrice(temp)
            self.spaceActivities.append(model)
        }
        
        self.amenities.removeAll()
        json.array("amenities").forEach { (temp) in
            let model = Amenities(amenitiesJson: temp)
            self.amenities.append(model)
        }
        
        self.guestAccess.removeAll()
        json.array("guest_access").forEach { (temp) in
            let model = Space2Type(json: temp)
            self.guestAccess.append(model)
        }
        
        self.services.removeAll()
        json.array("services").forEach { (temp) in
            let model = Space2Type(json: temp)
            self.services.append(model)
        }
        
        self.spaceStyle.removeAll()
        json.array("space_style").forEach { (temp) in
            let model = Space2Type(json: temp)
            self.spaceStyle.append(model)
        }
        
        self.specialFeatures.removeAll()
        json.array("special_feature").forEach { (temp) in
            let model = Space2Type(json: temp)
            self.specialFeatures.append(model)
        }
        
        self.similarList.removeAll()
        json.array("similar_listings").forEach { (temp) in
            let model = SimilarListDetails(jsons: temp)
            self.similarList.append(model)
        }
        
        self.spaceRules.removeAll()
        json.array("space_rules").forEach { (temp) in
            let model = Space2Type(json: temp)
            self.spaceRules.append(model)
        }
        
        self.availabilityTimes.removeAll()
        json.array("availability_times").forEach { (temp) in
            let model = AvailabilityTime(availabilityJson: temp)
            self.availabilityTimes.append(model)
        }
    }
}

extension SpaceDetailData {

    func getFeaturesData()->[DetailSectionHeader] {
        var headerTitleArray = [DetailSectionHeader]()
        if !self.guestAccess.isEmpty
        {
            let model = DetailSectionHeader(title: .guestAccess, subDetailsArray: self.guestAccess, isMoreTapped: false)
            headerTitleArray.append(model)
        }
        if !self.services.isEmpty
        {
            let model = DetailSectionHeader(title: .serviceOffered, subDetailsArray: self.services, isMoreTapped: false)
            headerTitleArray.append(model)
        }
        if !self.serviceExtra.isEmpty && self.serviceExtra != Language.getCurrentLanguage().getLocalizedInstance().additionalInf
        {
            let model = DetailSectionHeader(title: .theotherservices, subDetailsArray: [], isMoreTapped: false)
            headerTitleArray.append(model)
        }
        if !self.specialFeatures.isEmpty
        {
            let model = DetailSectionHeader(title: .specialFeatures, subDetailsArray: self.specialFeatures, isMoreTapped: false)
            headerTitleArray.append(model)
        }
        if !self.spaceRules.isEmpty
        {
            let model = DetailSectionHeader(title: .spaceRules, subDetailsArray: self.spaceRules, isMoreTapped: false)
            headerTitleArray.append(model)
        }
        if !self.spaceStyle.isEmpty
        {
            let model = DetailSectionHeader(title: .spaceStyle, subDetailsArray: self.spaceStyle, isMoreTapped: false)
            headerTitleArray.append(model)
        }
        return headerTitleArray
    }
    
    func updateFeatureData(section:sectionHeader)->[DetailSectionHeader] {
        var headerTitleArray = [DetailSectionHeader]()
        self.getFeaturesData().forEach { (temp) in
            var newHeader = temp
            if newHeader.title == section {
                newHeader.isMoreTapped = true
            }
            headerTitleArray.append(newHeader)
        }
        return headerTitleArray
    }
    
}

class SpacePhoto
{
    var id = Int()
    var name = String()
    var highLights = String()
    
    init (photoJson : JSONS)
    {
        self.id = photoJson.int("id")
        self.name = photoJson.string("name")
        self.highLights = photoJson.string("highlights")
    }
}

class TheSpace
{
    var key = String()
    var values = String()
    
    init (thespaceJson : JSONS)
    {
        self.key = thespaceJson.string("key")
        self.values = thespaceJson.string("value")
    }
}


class BasicListDetails{
    var spaceId         = Int()
    var name            = String()
    var spaceTypeName   = String()
    var rating          = String()
    var isWishList      = String()
    var reviewCount     = Int()
    var currencyCode    = String()
    var currencySymbol  = String()
    var hourly          = Int()
    var instantBook     = String()
    var size            = Int()
    var sizeType        = String()
    var type:String = "Rooms"
    
    init (baseJSONS : JSONS)
    {
        self.spaceId        = baseJSONS.int("space_id")
        self.name           = baseJSONS.string("name")
        self.spaceTypeName  = baseJSONS.string("space_type_name")
        self.rating         = baseJSONS.string("rating")
        self.isWishList     = baseJSONS.string("is_wishlist")
        self.reviewCount    = baseJSONS.int("review_count")
        self.currencyCode   = baseJSONS.string("currency_code")
        self.currencySymbol = baseJSONS.string("currency_symbol")
        self.hourly         = baseJSONS.int("hourly")
        self.instantBook    = baseJSONS.string("instant_book")
        self.size           = baseJSONS.int("size")
        self.sizeType       = baseJSONS.string("size_type")
    }
    init(){
        
    }
}
class SimilarListDetails:BasicListDetails
{
    
    var photoName       = String()
    var countryName     = String()
    var latitude        = String()
    var longitude       = String()
    var cityName        = String()
    
    init (jsons : JSONS)
    {
        super.init(baseJSONS: jsons)
        self.cityName = jsons.string("city_name")
        self.photoName      = jsons.string("photo_name")
        self.countryName    = jsons.string("country_name")
        self.latitude       = jsons.string("latitude")
        self.longitude      = jsons.string("longitude")
        
    }
    
}

class AvailabilityTime:Space2Type
{
    var  dayType = String()
//    var key      = String()
    var status   = String()
//    var value    = String()
    
    init (availabilityJson : JSONS)
    {
        super.init(json: availabilityJson)
//        super.init(spaceJson: availabilityJson)
        self.dayType = availabilityJson.string("day_type")
//        self.key     = availabilityJson.string("key")
        self.status  = availabilityJson.string("status")
//        self.value   = availabilityJson.string("value")
        if self.name.contains(",") {
            var result = String()
            
            for (index,value) in self.name.components(separatedBy: ",").enumerated() {
                result += "\(value )\n"
            }
//            self.value.components(separatedBy: ",").forEach { (temp) in
//                self.key.forEach({ (char) in
//                    result += " "
//                })
//                result += " \(temp )\n"
//            }
            self.name = result
                

        }
    }
}

//class SpaceActivity
//{
//    var id = Int()
//    var name = String()
//    var imageUrl = String()
//    var hourly = Int()
//    var minHours = Int()
//    var fullDay = Int()
//    var currencyCode = String()
//    var currencySymbol = String()
//
//    init (spaceActjson : JSONS)
//    {
//        self.id = spaceActjson.int("id")
//        self.name = spaceActjson.string("name")
//        self.imageUrl = spaceActjson.string("image_url")
//        self.hourly = spaceActjson.int("hourly")
//        self.minHours = spaceActjson.int("min_hours")
//        self.fullDay = spaceActjson.int("full_day")
//        self.currencyCode = spaceActjson.string("currency_code")
//        self.currencySymbol = spaceActjson.string("currency_symbol")
//    }
//}

class LocationData
{
    var addressLine1 = String()
    var addressLine2 = String()
    var city    = String()
    var state   = String()
    var country = String()
    var postalCode = String()
    var latitude  = String()
    var longitute = String()
    var guidance  = String()
    
    init (locationDataJson : JSONS)
    {
        self.addressLine1 = locationDataJson.string("address_line_1")
        self.addressLine2 = locationDataJson.string("address_line_2")
        self.city         = locationDataJson.string("city")
        self.state        = locationDataJson.string("state")
        self.country      = locationDataJson.string("country")
        self.postalCode   = locationDataJson.string("postal_code")
        self.latitude     = locationDataJson.string("latitude")
        self.longitute    = locationDataJson.string("longitude")
        self.guidance     = locationDataJson.string("guidance")
    }
    
}


class Space2Type
{
  
    var id = String()
    var name = String()
    
    init (json : JSONS)
    {
        
        if json.string("value").isEmpty {
            self.name = json.string("name")
        }else {
            self.name = json.string("value")
        }
        
        if json.string("key").isEmpty {
            self.id = json.string("id")
        }else {
            self.id = json.string("key")
        }
        
    }
}


//extension Space2Type{
//    convenience init(spaceJson : JSONS)
//    {
//        self.init(json: spaceJson)
//        self.name   = spaceJson.string("value")
//        self.id = spaceJson.string("key")
//    }
//
//
//}

class Amenities:Space2Type
{
    
    var imageName = String()
    
    init (amenitiesJson : JSONS)
    {
        super.init(json: amenitiesJson)
        self.imageName = amenitiesJson.string("image_name")
    }
}






