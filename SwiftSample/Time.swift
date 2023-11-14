//
//  Time.swift
//  Makent
//
//  Created by trioangle on 05/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

enum Time : String{
    case _12AM = "12:00 AM"
    
    case _01AM = "01:00 AM"
    
    case _02AM = "02:00 AM"
    
    case _03AM = "03:00 AM"
    
    case _04AM = "04:00 AM"
    
    case _05AM = "05:00 AM"
    
    case _06AM = "06:00 AM"
    
    case _07AM = "07:00 AM"
    
    case _08AM = "08:00 AM"
    
    case _09AM = "09:00 AM"
    
    case _10AM = "10:00 AM"
    
    case _11AM = "11:00 AM"
    
    case _12PM = "12:00 PM"
    
    case _01PM = "01:00 PM"
    
    case _02PM = "02:00 PM"
    
    case _03PM = "03:00 PM"
    
    case _04PM = "04:00 PM"
    
    case _05PM = "05:00 PM"
    
    case _06PM = "06:00 PM"
    
    case _07PM = "07:00 PM"
    
    case _08PM = "08:00 PM"
    
    case _09PM = "09:00 PM"
    
    case _10PM = "10:00 PM"
    
    case _11PM = "11:00 PM"
    
    case _11_59PM = "11:59 PM"
    
    init(forStrTime time : String){
        self = Time(rawValue: time) ?? ._12AM
    }
    init(forRailway time : String){
        switch time {
            
            case "00:00:00":
            self = ._12AM
            case "01:00:00":
            self = ._01AM
            case "02:00:00":
            self = ._02AM
            case "03:00:00":
            self = ._03AM
            case "04:00:00":
            self = ._04AM
            case "05:00:00":
            self = ._05AM
            case "06:00:00":
            self = ._06AM
            case "07:00:00":
            self = ._07AM
            case "08:00:00":
            self = ._08AM
            case "09:00:00":
            self = ._09AM
            case "10:00:00":
            self = ._10AM
            case "11:00:00":
            self = ._11AM
            case  "12:00:00":
            self = ._12PM
            case "13:00:00":
            self = ._01PM
            case "14:00:00":
            self = ._02PM
            case "15:00:00":
            self = ._03PM
            case "16:00:00":
            self = ._04PM
            case "17:00:00":
            self = ._05PM
            case  "18:00:00":
            self = ._06PM
            case "19:00:00":
            self = ._07PM
            case "20:00:00":
            self = ._08PM
            case "21:00:00":
            self = ._09PM
            case "22:00:00":
            self = ._10PM
            case "23:00:00":
            self = ._11PM
            case "23:59:00":
            self = ._11_59PM
        default:
            self = ._12AM
        }
    }
    init(forIndex index : Int){
        let ranges = Time.timeRanges()
        guard ranges.indices.contains(index) else{
            self = ._12AM
            return
        }
        self = Time(forStrTime: ranges[index])
    }
    
    static let count = 24
}
extension Time{
    static func getTimeArray() -> [Time]{
        return self.timeRanges().compactMap({Time(forStrTime: $0)})
    }
    
    private static func timeRanges() -> [String] {
        
        var array: [String] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm a"
        
        let startDate = "19-08-2018 11:00 PM"
        let endDate = "21-08-2018 12:00 AM"
        
        let date1 = formatter.date(from: startDate)
        let date2 = formatter.date(from: endDate)
        
        var i = 1
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*60*60))
            let string = formatter2.string(from: date!)
            
            if date! >= date2! {
                break;
            }
            
            i += 1
            array.append(string)
        }
        array.append("11:59 PM")
        return array
    }
    
    var getIndex : Int{
        return Time.getTimeArray().find(includedElement: {self == $0}) ?? 0
    }
    
    var getRailwayTimes : String{
        switch self {
            
        case ._12AM: return "00:00:00"
            
        case ._01AM: return "01:00:00"
        case ._02AM: return "02:00:00"
        case ._03AM: return "03:00:00"
        case ._04AM: return "04:00:00"
        case ._05AM: return "05:00:00"
        case ._06AM: return "06:00:00"
            
        case ._07AM: return "07:00:00"
        case ._08AM: return "08:00:00"
        case ._09AM: return "09:00:00"
        case ._10AM: return "10:00:00"
        case ._11AM: return "11:00:00"
        case ._12PM: return "12:00:00"
            
        case ._01PM: return "13:00:00"
        case ._02PM: return "14:00:00"
        case ._03PM: return "15:00:00"
        case ._04PM: return "16:00:00"
        case ._05PM: return "17:00:00"
        case ._06PM: return "18:00:00"
            
        case ._07PM: return "19:00:00"
        case ._08PM: return "20:00:00"
        case ._09PM: return "21:00:00"
        case ._10PM: return "22:00:00"
        case ._11PM: return "23:00:00"
            
        case ._11_59PM: return "23:59:00"
            
        default:
            return "00:00:00"
        }
    }
}
