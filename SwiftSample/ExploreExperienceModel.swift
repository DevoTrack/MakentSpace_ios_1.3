//
//  ExploreExperienceModel.swift
//  Makent
//
//  Created by Boominadha Prakash on 08/09/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import Foundation

struct ExploreExperienceModel {
    private struct SerializableKeys {
        static let kSuccessMessageKey = "success_message"
        static let kStatusCodeKey = "status_code"
        static let kTotalPageKey = "total_page"
        static let kDataKey = "data"
        static let kErrorKey = "error"
    }
    
    var successMessage = ""
    var statusCode = ""
    var totalPage:Int?
    var data: [ExploreExperienceData] = [ExploreExperienceData]()
    var isSelected: Bool = false
    var response: [String: Any] = [:]
    var error: String?
    
    init(response: [String: Any]) {
        self.response = response
        if let errorMsg = response[SerializableKeys.kErrorKey] as? String {
            error = errorMsg
        } else {
            self.successMessage = response[SerializableKeys.kSuccessMessageKey] as! String
            self.statusCode = response[SerializableKeys.kStatusCodeKey] as! String
            self.totalPage = response[SerializableKeys.kTotalPageKey] as? Int
            self.isSelected = true
            (response[SerializableKeys.kDataKey] as? [[String: Any]])?.forEach { value in
                self.data.append(ExploreExperienceData(response: value))
            }
        }
    }
}
