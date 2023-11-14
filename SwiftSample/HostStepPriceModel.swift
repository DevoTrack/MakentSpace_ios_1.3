//
//  HostStepPriceModel.swift
//  Makent
//
//  Created by trioangle on 29/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation


class HostStepPriceModel {
    var currency_code = String()
    var currency_symbol = String()
    var minimum_amount = String()
    var activityPrice = [ActivityPrice]()
        init(json:JSONS) {
            self.currency_symbol = json.string("currency_symbol")
            self.currency_code = json.string("currency_code")
            self.minimum_amount = json.string("minimum_amount")
            activityPrice.removeAll()
            json.array("activity_price").forEach { (tempJSONS) in
                let model = ActivityPrice(tempJSONS)
                activityPrice.append(model)
            }
            
        }
}






class ActivityPrice {
    var activity_name = String()
    var image_url = String()
    var activity_id = Int()
    var currency_code = String()
    var currency_symbol = String()
    var hourly = Int()
    var min_hours = Int()
    var full_day = Int()
    var weekly = Int()
    var monthly = Int()
    
    init(_ json:JSONS) {
        if json["name"] != nil {
            self.activity_name = json.string("name")
        }else {
            self.activity_name = json.string("activity_name")
        }
        
        self.image_url = json.string("image_url")
        if json["id"] != nil {
            self.activity_id = json.int("id")
        }else {
            self.activity_id = json.int("activity_id")
        }
        
        
        self.currency_code = json.string("currency_code")
        self.currency_symbol = json.string("currency_symbol")
        self.hourly = json.int("hourly")
        self.min_hours = json.int("min_hours")
        self.full_day = json.int("full_day")
        self.weekly = json.int("weekly")
        self.monthly = json.int("monthly")
        
    }
}

extension ActivityPrice {
    func getDict()-> JSONS {
        var param = JSONS()
        param["currency_code"] = self.currency_code
        param["activity_id"] = self.activity_id
        param["hourly"] = self.hourly
        param["weekly"] = self.weekly
        param["monthly"] = self.monthly
        param["min_hours"] = self.min_hours
        param["full_day"] = self.full_day
        return param
    }
}
