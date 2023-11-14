//
//  SharedVariables.swift
//  Makent
//
//  Created by trioangle on 07/02/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

let k_AlphaThemeColor: UIColor = UIColor.black
let k_BetaThemeColor: UIColor = UIColor.white
let k_AppThemeColor: UIColor = Utilities.sharedInstance.hexStringToUIColor(hex: "#299886")
let  k_AppLiteThemeColor: UIColor = Utilities.sharedInstance.hexStringToUIColor(hex: "#3D3D3D")
let  k_AppThemeGreenColor: UIColor = Utilities.sharedInstance.hexStringToUIColor(hex: "#299886")
let  k_AppThemePinkColor: UIColor = Utilities.sharedInstance.hexStringToUIColor(hex: "#FF4081")

class SharedVariables: NSObject {
    
    static let sharedInstance = SharedVariables()
//    var userDetails  = [String:Any]()
    
    var selectedDate = String()
    var selectedListType = String()
    var homeDetail = [String:Any]()
    var homeDetailList = [String:Any]()
    var readyToHostStep:ReadyToHost!
    var userToken = String()
    var userID = String()
    var homeType = HomeType.all
    var multipleDates = [Date]()
    var availableTimes: GetAvailabilityTimeData!
    var filterDict = [String:Any]()
    var lastWhistListRoomId = Int()
    var BTClinetToken = String()
    var btType: Int = 0
    var isToStopSegment = Bool()
    var isFormAppdelefateFirstTime = Bool()
    var categoryName: String = ""
    func getFilteredDatesDisplayName() -> String?{
        let formalDates = self.multipleDates
        guard let startDay = formalDates.first,
            let lastDay = formalDates.last else{
                return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.locale = Language.getCurrentLanguage().locale
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd MMM"//-MM-yyy"
        
        print(dateFormatter.string(from: startDay))
        
        var checkInDict = [String:Any]()
        
        if dateFormatter.string(from: startDay).count > 0 && dateFormatter.string(from: lastDay).count > 0 {
            
            let startDateString = dateFormatter.string(from: startDay)
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
            let endDateString = dateFormatter.string(from: lastDay)
            if startDateString == endDateString{
                let endDate = dateFormatter.string(from: tomorrow)
                return "\(startDateString) - \(endDate)"
            }else{
                return "\(startDateString) - \(endDateString)"
            }
        }
        return nil
    }
    func getFilteredDatesDict() -> [String:Any]?{
        let formalDates = self.multipleDates
        guard let startDay = formalDates.first,
            let lastDay = formalDates.last else{
                return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.locale = Language.getCurrentLanguage().locale
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        
        
        print(dateFormatter.string(from: startDay))
        
        var checkInDict = [String:Any]()
        
        if dateFormatter.string(from: startDay).count > 0 && dateFormatter.string(from: lastDay).count > 0 {
            checkInDict["checkin"] = dateFormatter.string(from: startDay)
            checkInDict["checkout"] = dateFormatter.string(from: lastDay)
            dateFormatter.dateFormat = "dd MMM"
            return checkInDict
        }
        return nil
    }

}
