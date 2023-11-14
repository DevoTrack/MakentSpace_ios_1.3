//
//  ExploreDataModel.swift
//  Makent
//
//  Created by Trioangle on 19/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
class ExploreDataModel{
    var city_name = String()
    var country_name = String()
    var currency_code = String()
    var currency_symbol = String()
    var instant_book = String()
    var is_wishlist = String()
    var latitude = String()
    var longitude = String()
    var rating_value = Int()
    var reviews_count = Int()
    var room_id = Int()
    var room_name = String()
    var room_price = Int()
    var room_thumb_image = String()
    var room_type = String()
    var experience_id = Int()
    var experience_price = Int()
    var experience_thumb_images = String()
    var experience_category = String()
    
    init(_ json : JSONS){
        self.city_name = json["city_name"] as? String ?? ""
        self.country_name = json["country_name"] as? String ?? ""
        self.currency_code = json["currency_code"] as? String ?? ""
        self.currency_symbol = json["currency_symbol"] as? String ?? ""
        self.instant_book = json["instant_book"] as? String ?? ""
        self.is_wishlist = json["is_wishlist"] as? String ?? ""
        self.latitude = json["latitude"] as? String ?? ""
        self.longitude = json["longitude"] as? String ?? ""
        self.rating_value = json["rating_value"] as? Int ?? 0
        self.reviews_count = json["reviews_count"] as? Int ?? 0
        self.room_id = json["room_id"] as? Int ?? 0
        self.room_name = json["room_name"] as? String ?? ""
        self.room_price = json["room_price"] as? Int ?? 0
        self.room_thumb_image = json["room_thumb_image"] as? String ?? ""
        self.room_type = json["room_type"] as? String ?? ""
        self.experience_id = json["experience_id"] as? Int ?? 0
        self.experience_price = json["experience_price"] as? Int ?? 0
        self.experience_thumb_images = json["experience_thumb_images"] as? String ?? ""
        self.experience_category = json["experience_category"] as? String ?? ""
    }
}
class ExploreDataValueModel{
    var max_price = Int()
    var min_price = Int()
    var status_code = Int()
    var success_message = String()
    var total_page = Int()
    
    init(_ json: JSONS){
        self.max_price = json["max_price"] as? Int ?? 0
        self.min_price = json["min_price"] as? Int ?? 0
        self.status_code = json.int("status_code")//["status_code"] as? Int ?? 0
        self.success_message = json["sucess_message"] as? String ?? ""
        self.total_page = json["total_page"] as? Int ?? 0
    }
}

class ExperienceCategoryModel{
    var id = Int()
    var name = String()
    var image = String()
    init(_ json : JSONS){
        self.id = json["id"] as? Int ?? 0
        self.name = json["name"] as? String ?? ""
        self.image = json["image"] as? String ?? ""
    }
}
