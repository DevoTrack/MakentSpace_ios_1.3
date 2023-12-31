/**
 * NSDate+Timepiece.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation
import ObjectiveC

// MARK: - Calculation

func + (lhs: Date, rhs: Duration) -> Date {
    return (NSCalendar.current as NSCalendar).dateByAddingDuration(rhs, toDate: lhs, options: .searchBackwards)!
}

func - (lhs: Date, rhs: Duration) -> Date {
    return (NSCalendar.current as NSCalendar).dateByAddingDuration(-rhs, toDate: lhs, options: .searchBackwards)!
}

func - (lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSince(rhs)
}

// MARK: -
extension Date {
    fileprivate struct AssociatedKeys {
        static var TimeZone = "timepiece_TimeZone"
    }
    
    
   
    

    
    // MARK: - Get components
    
    var year: Int {
        return components.year!
    }
    
    var month: Int {
        return components.month!
    }
    
    var weekday: Int {
        return components.weekday!
    }
    
    var day: Int {
        
        return components.day!
    }
    
    var hour: Int {
        return components.hour!
    }
    
    var minute: Int {
        return components.minute!
    }
    
    var second: Int {
        return components.second!
    }
    
    var timeZone: NSTimeZone {
        return objc_getAssociatedObject(self, &AssociatedKeys.TimeZone) as? NSTimeZone ?? calendar.timeZone as NSTimeZone
    }
    
    fileprivate var components: DateComponents {
        
        return (calendar as NSCalendar).components([.year, .month, .weekday, .day, .hour, .minute, .second], from: self)
    }
    
    fileprivate var calendar: NSCalendar {
        return (NSCalendar.current as NSCalendar)
    }
    
    // MARK: - Initialize
    static func date(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        
        let now = Date()
        return now.change(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    static func date(year: Int, month: Int, day: Int) -> Date {
        return Date.date(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    
    static func today() -> Date {
        let now = Date()
        
        return Date.date(year: now.year, month: now.month, day: now.day)
    }
    
    static func yesterday() -> Date {
        return today() - 1.day
    }
    
    static func tomorrow() -> Date {
        return today() + 1.day
    }
    
    // MARK: - Initialize by setting components
    
    /**
     Initialize a date by changing date components of the receiver.
     */
    func change(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date! {
        var components = self.components
//        components.calendar?.locale = Language.getCurrentLanguage().locale

        components.year = year ?? self.year
        components.month = month ?? self.month
        components.day = day ?? self.day
        components.hour = hour ?? self.hour
        components.minute = minute ?? self.minute
        components.second = second ?? self.second
        return calendar.date(from: components)
    }
    
    /**
     Initialize a date by changing the weekday of the receiver.
     */
    func change(weekday: Int) -> Date! {
        return self - (self.weekday - weekday).days
    }
    
    /**
     Initialize a date by changing the time zone of receiver.
     */
    func change(timeZone: NSTimeZone) -> Date! {
        let originalTimeZone = calendar.timeZone
       
        calendar.timeZone = timeZone as TimeZone
//        calendar.locale = Language.getCurrentLanguage().locale
        let newDate = calendar.date(from: components)!
//        newDate.calendar.locale = Language.getCurrentLanguage().locale
        newDate.calendar.timeZone = timeZone as TimeZone
        objc_setAssociatedObject(newDate, &AssociatedKeys.TimeZone, timeZone, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        calendar.timeZone = originalTimeZone
        return newDate
    }
    
    // MARK: - Initialize a date at beginning/end of each units
    var beginningOfYear: Date {
        return change(month: 1, day: 1, hour: 0, minute: 0, second: 0)
    }
    var endOfYear: Date {
        return (beginningOfYear + 1.year).addingTimeInterval(-1)
    }
    
    var beginningOfMonth: Date {
        return change(day: 1, hour: 0, minute: 0, second: 0)
    }
    var endOfMonth: Date {
        return (beginningOfMonth + 1.month).addingTimeInterval(-1)
    }
    
    var beginningOfWeek: Date {
        return change(weekday: 1).beginningOfDay
    }
    var endOfWeek: Date {
        return (beginningOfWeek + 1.week).addingTimeInterval(-1)
    }
    
    var beginningOfDay: Date {
        return change(hour: 0, minute: 0, second: 0)
    }
    var endOfDay: Date {
        return (beginningOfDay + 1.day).addingTimeInterval(-1)
    }
    
    var beginningOfHour: Date {
        return change(minute: 0, second: 0)
    }
    var endOfHour: Date {
        return (beginningOfHour + 1.hour).addingTimeInterval(-1)
    }
    
    var beginningOfMinute: Date {
        return change(second: 0)
    }
    var endOfMinute: Date {
        return (beginningOfMinute + 1.minute).addingTimeInterval(-1)
    }
    
    // MARK: - Format dates
    func stringFromFormat(_ format: String) -> String {
        let formatter = DateFormatter()
         let georgian = Calendar.init(identifier: Calendar.Identifier.gregorian)
        formatter.calendar = georgian
//        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
//        let georgian = Calendar.init(identifier: Calendar.Identifier.gregorian)
//      if Language.getCurrentLanguage().rawValue == "en"{
//          formatter.locale = Language.getCurrentLanguage().locale
//          formatter.calendar = georgian
//       }else{
//          formatter.locale = Language.getCurrentLanguage().locale
//          formatter.calendar = hijriCalendar
//       }
        formatter.locale = Language.getCurrentLanguage().locale
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    // MARK: - Differences
    func differenceWith(_ date: Date, inUnit unit: NSCalendar.Unit) -> Int {
        return (calendar.components(unit, from: self, to: date, options: []) as NSDateComponents).value(forComponent: unit)
    }
}
enum Month : Int{
    case jan ,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec
}
