/**
 * String+Timepiece.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation

extension String {
    // MARK - Parse into NSDate
    
    func dateFromFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
//        formatter.locale = Language.getCurrentLanguage().locale
//        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
//    func DateBoolCheck(_ str:String)-> Bool{
//        var dateVal = ""
//        let dateFormat = DateFormatter()
//        let date = dateFormat.date(from: str)!
//        dateFormat.dateFormat = "hh:mm a"
//        dateVal = dateFormat.string(from: date)
//           while tempDate < last {
//            }
//    }
//    
    func getUserFormattedDate()->String {
        var str = ""
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm a" //?? "HH:mm:ss"
        guard !self.isEmpty else{ return "" }
        
        if let date = dateFormat.date(from: self){
        dateFormat.dateFormat = "hh:mm a"
        str = dateFormat.string(from: date)
        }else{
          dateFormat.dateFormat = "HH:mm:ss"
          let date = dateFormat.date(from: self)!
          dateFormat.dateFormat = "hh:mm a"
          str = dateFormat.string(from: date)
        }
        return str
    }
    
    func getFormattedDate()->String {
        var str = ""
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm a" //?? "HH:mm:ss"
        guard !self.isEmpty else{ return "" }
        
        if let date = dateFormat.date(from: self){
            dateFormat.dateFormat = "HH:mm:ss"
            str = dateFormat.string(from: date)
        }else{
            dateFormat.dateFormat = "HH:mm:ss"
            let date = dateFormat.date(from: self)!
            dateFormat.dateFormat = "hh:mm a"
            str = dateFormat.string(from: date)
        }
        return str
    }
    
    
}
