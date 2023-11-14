//
//  Color+Additions.swift
//  InstagramStories
//
//  Created by Ranjith Kumar on 9/8/17.
//  Copyright © 2017 Dash. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func rgb(from hex: Int,alpha :CGFloat=1.0) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((hex & 0x00FF00) >> 8) / 0xFF
        let blue = CGFloat(hex & 0x0000FF) / 0xFF
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    func getTodayColor() -> UIColor{
        
        return UIColor.init(hex: "#46A4A7")
        
    }
    
    func getBlockedColor() -> UIColor{
        
        return UIColor.init(hex: "#8592ff")
        
    }
    
    func getAvailableColor() -> UIColor{
        
        return UIColor.white
        
    }
    
    func getNotAvailableColor() -> UIColor{
        
        return UIColor.init(hex: "#AFE4A4").withAlphaComponent(0.7)
        
    }
    
}
