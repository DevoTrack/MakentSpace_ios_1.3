//
//  InfoPlistKeys.swift
//  GoferHandy
//
//  Created by trioangle on 27/01/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

enum InfoPlistKeys : String{
    case GOOGLE_API_KEY
    case GOOGLE_PLACE_KEY
    case PAYPAL_ID
    case STRIPE_KEY
    case App_URL
    case APP_NAME
    case APP_LOGO
    case APP_TABBAR
}
extension InfoPlistKeys : PlistKeys{
    var key: String{
        return self.rawValue
    }
    
    static var fileName: String {
        return "Info"
    }
    
    
}
