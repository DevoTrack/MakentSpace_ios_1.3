//
//  HomeModel.swift
//  Makent
//
//  Created by Trioangle on 19/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit
enum DetailType{
    case room
    case experiance
}
class HomeModel {
    
    let lists: [List]
    
    init(  lists: [List]) {
        self.lists = lists
    }
}


// MARK: - List
class List {
    let title: String
    let key : String
    let details: [Detail]
    
    init(title: String,key : String, details: [Detail]) {
        self.title = title
        self.key = key
        self.details = details
    }
}

// MARK: - Detail
class Detail: Equatable {
    
    var id = Int()
    var spaceid = Int()
    var hourly  = Int()
    var category = Int()
    var name = String()
    var categoryName = String()
    var spaceType = String()
    var size = String()
    var sizeType = String()
    var photoName = String()
    var rating = String()
    var isWishlist = String()
    var reviewsCount = Int()
    var price = Int()
    var roomprice = Int()
    var currencyCode = String()
    var currencySymbol = String()
    var decodedCurrencySymbol : String{
        return self.currencySymbol.stringByDecodingHTMLEntities
    }
    var cityName = String()
    var countryName = String()
    var latitude = String()
    var longitude = String()
    var type = String()
    
    var roomid = Int()
    var instantBook = String()
    //    var ratingValue = Int()
    var roomname = String()
    var roomThumbImage = String()
    var roomType = String()
    
    var bedCount = Int()
    var location : CLLocation{
        guard let lat = Double(self.latitude),
            let lng = Double(self.longitude) else{return CLLocation()}
        return CLLocation(latitude: lat, longitude: lng)
    }
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var getDisplayRoomName : String{
        var dispName = String()
        dispName.append(self.name)
        //        if bedCount != 0{
        //            dispName.append(" • \(self.bedCount) \(lang.capbed_Title)")
        //        }
        return dispName
    }
    var contentType : DetailType{
        guard type.isEmpty else {return type.lowercased().contains("room") ? .room : .experiance}
        if [self.roomid].contains(0){
            return .experiance
        }else{
            return .room
        }
    }
    var getMarkerPrice : String{
        if self.contentType == .room{
            if price != 0{
                if Language.getCurrentLanguage().isRTL{
                    return "\(self.price) \(self.currencySymbol)"
                }else{
                    return "\(self.currencySymbol) \(self.price)"
                }
            }else{
                if Language.getCurrentLanguage().isRTL{
                    return "\(self.hourly) \(self.currencySymbol)"
                }else{
                    return "\(self.currencySymbol) \(self.hourly)"
                }
            }
        }else{
            if Language.getCurrentLanguage().isRTL{
                return "\(self.hourly) \(self.decodedCurrencySymbol)"
            }else{
                return "\(self.decodedCurrencySymbol) \(self.hourly)"
            }
            
        }
        
    }
    init(_ json:JSONS) {
        self.id = json.int("id")
        self.category = json.int("category")
        self.name = json.string("name")
        self.categoryName = json.string("category_name")
        self.photoName = json.string("photo_name")
        self.rating = json.string("rating")
        self.isWishlist = json.string("is_wishlist")
        self.reviewsCount = json.int("reviews_count")
        self.price = json.int("price")
        self.roomprice = json.int("room_price")
        self.currencyCode = json.string("currency_code")
        self.spaceid  = json.int("space_id")
        self.hourly   = json.int("hourly")
        self.spaceType = json.string("space_type_name")
        self.size = json.string("size")
        self.sizeType = json.string("size_type")
        self.currencySymbol = json.string("currency_symbol").stringByDecodingHTMLEntities
        if (Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL) as String).isEmpty {
            Constants().STOREVALUE(value: currencySymbol as NSString, keyname: APPURL.USER_CURRENCY_SYMBOL)
        }
        self.cityName = json.string("city_name")
        self.countryName = json.string("country_name")
        self.latitude = json.string("latitude")
        self.longitude = json.string("longitude")
        self.type = json.string("type")
        self.roomid = json.int("room_id")
        self.instantBook = json.string("instant_book")
        if self.instantBook.isEmpty || self.instantBook == "instant_book" {
            self.instantBook = "No"
        }
        //        self.ratingValue = json.int("rating_value")
        self.roomname = json.string("room_name")
        self.roomThumbImage = json.string("photo_name")
        self.roomType = json.string("room_type")
        self.bedCount = json.int("bed_count")
        
    }
    static func == (lhs: Detail, rhs: Detail) -> Bool {
        return lhs.id == rhs.id || lhs.roomid == rhs.roomid
    }
    
}

class ExperienceDetails:Detail{
    var experienceId = Int()
    var experiencePrice = Int()
    var experienceName = String()
    var experienceThumbImage = String()
    var experienceCategory = String()
    
    override var contentType: DetailType{
        guard type.isEmpty else {return type.lowercased().contains("room") ? .room : .experiance}
        if [self.experienceId].contains(0){
            return .room
        }else{
            return .experiance
        }
    }
    override init(_ json:JSONS){
        super.init(json)
        if self.id == 0{
            self.id = json.int("experience_id")
        }
        
        self.experienceId = json.int("experience_id")
        self.experienceName = json.string("experience_name")
        self.experienceThumbImage = json.string("photo_name")
        self.experienceCategory = json.string("experience_category")
        //self.experiencePrice = json.string("price")
        // Feature use to pass whislist data
        if self.type.isEmpty {
            self.type = "Experiences".capitalized
        }
        
        
    }
}

class ExploreCat{
    var image = String()
    var name = String()
    var id = Int()
    var key = String()
    init(_ json : JSONS){
        self.id = json.int("id")
        // self.image = json.string("image") //["image"] as? String ?? ""
        self.image = json.string("image_url") //["image"] as? String ?? ""
        self.key = json.string("key")
        self.name = json["name"] as? String ?? ""
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
