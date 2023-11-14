//
//  BasicStepEnum.swift
//  Makent
//
//  Created by trioangle on 27/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

enum SpaceList : Int {
    
    static let TotalSpaces = 7.0
    case typeSpace = 0
    case guestAccess
    case spaceGuest
    case spaceAmenities
    case extraServices
    case spaceAddress
    case accessibility
    
    
    
    
    var getProgress : Float {
        return Float(self.rawValue)/Float(SpaceList.TotalSpaces)
    }
}
enum SpaceSetupList : Int {
    static let Totalsetup = 5.0
    case addPhoto = 0
    case spaceStyle
    case spaceFeatures
    case spaceRules
    case spaceDescription
    
    var getProgress : Float {
        return Float(self.rawValue)/Float(SpaceSetupList.Totalsetup)
    }
}

enum SpaceReadyToHost : Int {
    static let Totalsetup = 5.0
    case activities = 0
    case spacePrice
    case spaceAvailability
    case spaceCancellation
    case spaceCalendar
    
    var getProgress : Float {
        return Float(self.rawValue)/Float(SpaceReadyToHost.Totalsetup)
    }
}

enum Availability: String {
    case Open
    case All
    case Closed
    case SetHours
    var text:String {
        return self.rawValue
    }
}



enum ChooseDate : String{
    case ArrayTime
    
    func description() -> String {
        switch self {
        case .ArrayTime:
            return "Introduced"
        }
    }
    
        func DateCompare(_ firstTime : String, _ secondTime : String){
            let formatter = DateFormatter()
            formatter.locale = Language.getCurrentLanguage().locale
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
    
    
            let firstTime = formatter.date(from: firstTime)
            let secondTime = formatter.date(from: secondTime)
    
    
            if firstTime?.compare(secondTime!) == .orderedAscending {
                print("First Time is smaller then Second Time")
            }
        }
}



