//
//  Date.swift
//  Makent
//
//  Created by trioangle on 05/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

extension Date {
    
    enum Day : Int{
        case sun = 1,mon,tue,wed,thu,fri,sat
        var description : String{
            return "\(self)"
        }
    }
    
    enum Month : Int{
        case jan = 1,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec
        var description : String{
            return "\(self)"
        }
    }
    
    init(day : Int,month : Month,year : Int){
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month.rawValue
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        self = date
    }
    

    func dateToDisplay(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ" // This formate is input formated .
        
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "yyyy-MM-dd" // Output Formated
        
        print ("Print :\(dateFormatter.string(from: formateDate))")//Print :02-02-2018
        return dateFormatter.string(from: formateDate)
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: components)!
        
        return startOfMonth
    }
    
    func endOfMonths() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        
        let endOfMonth = calendar.date(byAdding: comps2 as DateComponents, to: self.startOfMonth())!
        
        return endOfMonth
    }
    
    func monthsInYear() -> [Date]{
        var dates = [Date]()
        let calendar = Calendar.current
        let monthsOfYearRange = calendar.range(of: .month, in: .year, for: self)
        //print(monthsOfYearRange as Any)
        
        if let monthsOfYearRange = monthsOfYearRange {
            let year = calendar.component(.year, from: self)
            
            for monthOfYear in (monthsOfYearRange.lowerBound..<monthsOfYearRange.upperBound) {
                let components = DateComponents(year: year, month: monthOfYear)
                guard let date = Calendar.current.date(from: components) else { continue }
                dates.append(date)
            }
        }
        return dates
    }
    
    func getDatesForMonth() -> [Date]{
        let firstDate = self.startOfMonth()
        let lastDate = self.endOfMonths()
        
        if firstDate > lastDate { return [Date]() }
        
        var tempDate = firstDate
        var array = [tempDate]
        
        while tempDate < lastDate {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    var days : Int{
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let currentDateInt = (calendar?.component(NSCalendar.Unit.day, from: self))!
        
        return currentDateInt
    }
    
    var weekDays : Date.Day{
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let currentDayInt = (calendar?.component(NSCalendar.Unit.weekday, from: self))!
        
        return Day(rawValue: currentDayInt) ?? .sun
    }
    
    var months : Date.Month{
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let currentMonthInt = (calendar?.component(NSCalendar.Unit.month, from: self))!
        
        return Month(rawValue: currentMonthInt) ?? .jan
        
    }
    
    var years : Int{
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: self))!
        
        return currentYearInt
        
    }
    
    var tommorrow : Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var yesterDay : Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var nextYear : Date{
        return Calendar.current.date(byAdding: .year, value: 1, to: self)!
    }
    
    var previousYear : Date{
        return Calendar.current.date(byAdding: .year, value: -1, to: self)!
    }
    
    var previousTime : Time{
        let hour = Calendar.current.date(byAdding: .hour, value: -1, to: self)
        
        return Time(forIndex: hour?.hour ?? 0)
    }
    
    var currentTime : Time{
        let hour = Calendar.current.dateComponents([.hour, .year, .minute], from: self)
      
        return Time(forIndex: hour.hour ?? 0)
    }

    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var nextTime : Time{
        let hour = Calendar.current.date(byAdding: .hour, value: 1, to: self)
        
        return Time(forIndex: hour?.hour ?? 0)
    }
    
    func getDateVal(_ value: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: value)! //I am force-unwrapping for brevity
        let adjustedDate = date.addingTimeInterval(-TimeZone.current.daylightSavingTimeOffset(for: date))
        return adjustedDate
    }
    
}
