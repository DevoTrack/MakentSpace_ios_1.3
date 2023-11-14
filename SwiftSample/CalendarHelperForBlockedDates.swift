//
//  CalendarHelperForBlockedDates.swift
//  Makent
//
//  Created by trioangle on 14/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

import UIKit

class CalenderHelperForBlockedDates {
    static var instance = CalenderHelperForBlockedDates()
    var currenDates = Date()
    var dateFormater = DateFormatter()
    var rangeYear = Int()
    
    func setDateRangeYear(rangeYear:Int) {
        //        self.rangeYear = rangeYear
        self.dateFormater.dateFormat = "MM/dd/yyy"
        let str =  dateFormater.string(from: self.currenDates)
        
        if let newDate = dateFormater.date(from: str) {
            
            self.currenDates = newDate
        }
        
        self.rangeYear = rangeYear
        
    }
    
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
            Calendar.current.dateComponents([.year,.month, .day], from: self.currenDates))!
    }
    
    func getAllDays(selectedDates:[String]) -> [String]
    {
        var days = [Date]()
        
        let calendar = Calendar.current
        //        let rangeYear = calendar.range(of: .month, in: .year, for: self.rangeYear)!
        
        
        
        let range = calendar.range(of: .day, in: .month, for: self.currenDates)!
        self.dateFormater.dateFormat = "MM/dd/yyy"
        let day = firstDayOfTheMonth()
        let str = dateFormater.string(from: day)
        self.dateFormater.dateFormat = "MM/dd/yyy"
        guard var updateDate = dateFormater.date(from: str) else { return [] }
        print(updateDate)
        for _ in 1...rangeYear {
            for _ in 1...12 {
                for _ in 1...range.count
                {
                    days.append(updateDate)
                    updateDate.addDays(n: 1)
                }
            }
        }
        var newDays = [Date]()
        selectedDates.forEach { (temp) in
            let dates = days.filter({$0.dayOfWeek() == temp})
            newDays.append(contentsOf: dates)
        }
        var newDatesString = [String]()
        newDays.sorted().forEach { (tempDate) in
            newDatesString.append(tempDate.toString())
        }
        return newDatesString
        
        
    }
    
}

extension Date {
    mutating func addDays(n: Int)
    {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    mutating func addYear(year:Int) {
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month], from: self)

        if let startOfMonth = cal.date(from: components) {
            print(startOfMonth)
            self = cal.date(byAdding: .year, value: year, to: startOfMonth)!
        }
    }
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func toString()->String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyy"
        let str = dateFormat.string(from: self)
        return str
    }
    
    func getYear()->Int {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy"
        let str = dateFormat.string(from: self).toInt()
        return str
    }
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "h:mm a"

        return dateFormatter.string(from: dt!)
    }

    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"

        return dateFormatter.string(from: dt!)
    }
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))

            return self.addingTimeInterval(targetOffset - localOffeset)
        }

        return nil
    }
    
}

extension String {
    func toDate()->Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyy"
        guard let day = dateFormat.date(from: self) else { return nil }
        return day
    }
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "h:mm a"

        return dateFormatter.string(from: dt!)
    }

    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"

        return dateFormatter.string(from: dt!)
    }
    
}

