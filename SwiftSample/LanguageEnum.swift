//
//  LanguageEnum.swift
//  Makent
//
//  Created by trioangle on 08/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
//MARK:- SupportedLanugages
enum Language : String{
    
    case english = "en"
    case spanish = "es"
    case arabic = "ar"
    

}
extension Language{
    
    static func localizedInstance()-> LanguageProtocol{
        return self.getCurrentLanguage().getLocalizedInstance()
    }
    
    //MARK:- get Current Language
    static func getCurrentLanguage() -> Language{
        let def:String = UserDefaults.standard.string(forKey: "lang") ?? "en"
       
        return Language(rawValue: def) ?? .english
    }
    static func saveLanguage(_ Lang:Language){
       UserDefaults.standard.set(Lang.rawValue, forKey:  "lang")
    }
    //MARK:- get localization  instace
    func getLocalizedInstance()-> LanguageProtocol{
      
        switch self{
        case .spanish:
            return Spanish()
        case .arabic:
            return Arabic()
        default:
            return English()
        }
    }
    
    var isRTL : Bool{
        
        if Language.getCurrentLanguage().rawValue == "ar"{
            return true
        }
        return false
    }
    var locale : Locale{
        switch self {
        case .arabic:
            return Locale(identifier: "en")
        default:
            return Locale(identifier: "en")
        }
    }
    //NSCalendar(calendarIdentifier:
    var identifier : NSCalendar{
        switch self {
        case .arabic:
            return NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)!
        default:
            return NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)!
        }
    }
    var calIdentifier : Calendar{
        switch self {
        case .arabic:
            return Calendar.init(identifier: Calendar.Identifier.gregorian)
        default:
            return Calendar.init(identifier: Calendar.Identifier.gregorian)
        }
    }
    //MARK:- get display semantice
    var getSemantic:UISemanticContentAttribute {
        
        return self.isRTL ? .forceRightToLeft : .forceLeftToRight
     
    }
    
    //MARK:- for imageView Transform Display
    var getAffine:CGAffineTransform {
        
        return self.isRTL ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: 1.0)
    
    }
    
    //MARK:- for Text Alignment
    func getTextAlignment(align : NSTextAlignment) -> NSTextAlignment{
        guard self.getSemantic == .forceRightToLeft else {
            return align
        }
        switch align {
        case .left:
            return .right
        case .right:
            return .left
        case .natural:
            return .natural
        default:
            return align
        }
    }
    
    //MARK:- for ButtonText Alignment
    func getButtonTextAlignment(align : UIControl.ContentHorizontalAlignment) -> UIControl.ContentHorizontalAlignment{
        guard self.getSemantic == .forceRightToLeft else {
            return align
        }
        switch align {
        case .left:
            return .right
        case .right:
            return .left
        case .center:
            return .center
        default:
            return align
        }
    }
    
  
}
class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3).cgColor
        let colorBottom = UIColor(red: 0.0/255.0,
                                  green: 0.0/255.0,
                                  blue: 0.0/255.0, alpha: 0.0)
            .cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.startPoint = CGPoint(x: 0.5, y: 0.0)
        self.gl.endPoint = CGPoint(x: 0.5, y: 1)
        self.gl.locations = [1.0, 0.0]
        
    }
}
