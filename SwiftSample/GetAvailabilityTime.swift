//
//  GetAvailabilityTime.swift
//  Makent
//
//  Created by trioangle on 17/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class GetAvailabilityTimeData

{
    
    var startDate = String()
    var endDate   = String()
    var starttimes = [TimesAvailability]()
    var endTimes   = [TimesAvailability]()
    var selectedStarTime = String()
    var selectedEndTime = String()
    
    init(availabilityTimeJson : JSONS) {
        self.startDate = availabilityTimeJson.string("start_date")
        self.endDate   = availabilityTimeJson.string("end_date")
        
        self.starttimes.removeAll()
        availabilityTimeJson.array("start_times").forEach { (temp) in
            let model = TimesAvailability(json: temp)
            self.starttimes.append(model)
        }
        
        self.endTimes.removeAll()
        availabilityTimeJson.array("end_times").forEach { (temp) in
         let model = TimesAvailability(json: temp)
         self.endTimes.append(model)
        }
    }
    
    
    
}

extension GetAvailabilityTimeData {
   
}

class TimesAvailability
{
    var time = String()
    var blocked = Bool()
    
    init (json : JSONS)
    {
        self.time   = json.string("time")
        self.blocked = json.bool("is_blocked")
    }
}



