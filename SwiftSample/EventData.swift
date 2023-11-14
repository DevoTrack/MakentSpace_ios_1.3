//
//  EventData.swift
//  Makent
//
//  Created by trioangle on 14/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class EventSpaceActivityData
{
    var id             = Int()
    var name           = String()
    var imageUrl       = String()
    var currencyCode   = String()
    var currencySymbol = String()
    var hourly         = String()
    var minHours       = String()
    var fullDay        = String()
    var activities     = [Activity]()
    
    init (ActivityJson : JSONS)
    {
        print("eventtype init")
        self.id = ActivityJson.int("id")
        self.name = ActivityJson.string("name")
        self.imageUrl = ActivityJson.string("image_url")
        self.currencyCode = ActivityJson.string("currency_code")
        self.currencySymbol = ActivityJson.string("currency_symbol").stringByDecodingHTMLEntities
        self.hourly   = ActivityJson.string("hourly")
        self.minHours   = ActivityJson.string("min_hours")
        self.fullDay   = ActivityJson.string("full_day")
        
        self.activities.removeAll()
        ActivityJson.array("activities").forEach { (temp) in
            let model = Activity(activityJson: temp)
            self.activities.append(model)
        }
    }

}

//class ActivityType
//{
//    var activity  = [Activity]()
//    init(activityTypeJson : JSONS)
//    {
//        self.activity.removeAll()
//        activityTypeJson.array("activities").forEach { (temp) in
//            let model = Activity(activityJson: temp)
//            self.activity.append(model)
//        }
//    }
//}

class Activity : EventBaseModel
{
    var subActivityTypes  = [EventBaseModel]()
    init(activityJson : JSONS)
    {
        super.init(eventJson: activityJson)
        self.subActivityTypes.removeAll()
        activityJson.array("sub_activities").forEach { (temp) in
            let model = EventBaseModel(eventJson: temp)
            self.subActivityTypes.append(model)
        }
    }
}

extension Activity:NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    
}

class EventBaseModel
{
    var id       = Int()
    var name     = String()
    var isSelected = Bool()
    init(eventJson : JSONS)
    {
        self.id   = eventJson.int("id")
        self.name = eventJson.string("name")
        self.isSelected = false
    }
}
