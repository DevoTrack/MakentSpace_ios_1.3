//
//  CodeHelpers.swift
//  Makent
//
//  Created by trioangle on 09/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
import CoreLocation
extension Int{
    var localize : String{
        let format = NumberFormatter()
        format.locale = Language.getCurrentLanguage().locale
        guard let number =  format.number(from: self.description),
            let convertedNumber = format.string(from: number)else{
                return self.description
        }
        return convertedNumber
    }
    
    var localizeEng : String{
        let format = NumberFormatter()
        format.locale = NSLocale.init(localeIdentifier: "en") as Locale
        guard let number =  format.number(from: self.description),
            let convertedNumber = format.string(from: number)else{
                return self.description
        }
        return convertedNumber
    }
  
    
    
}
extension Float{
    var localize : String{
        let format = NumberFormatter()
        format.minimumFractionDigits = 1
        format.allowsFloats = true
        format.locale = Language.getCurrentLanguage().locale
        format.number(from: self.description)
        guard let convertedNumber =
            format.string(from: NSNumber(value: self)) else{
                return self.description
        }
        return convertedNumber
    }
}
extension UIViewController{
    func isPresented() -> Bool {
        if self.presentedViewController != nil {
            return true
        }
        else if self.navigationController?.presentingViewController == self  {
            return true
        }
        else if self.navigationController?.presentedViewController == self.navigationController  {
            return true
        }else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    func timeValidate(check startTime : String,check endTime : String)->Bool{
        let dateFormatter = DateFormatter()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dateFormatter.dateFormat = "h:mm a"
        if startTime != "" && endTime != ""{
        let stTime = dateFormatter.date(from: startTime)!
        let edTime = dateFormatter.date(from: endTime)!
        print("StartTime and EndTime:",stTime,edTime)
        if stTime > edTime || stTime == edTime{
            appDelegate.createToastMessage(self.sharedAppDelegete.lang.pleaseChooseValidTimes, isSuccess: false)
            return false
        }
        }
        return true
    }
    
}
extension CLLocationCoordinate2D : Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
