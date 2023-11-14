//
//  Guest.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/10/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import Foundation

class Guest: Equatable {
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.fullName == rhs.fullName
    }

    var firstName: String
    var lastName: String
    var email: String
    var profilePicture:String?

    init(firstName:String,lastName:String,email:String,profilePicture:String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePicture = profilePicture
    }

    var fullName: String {
        if lastName.isEmpty {
            return firstName
        }else {
            return firstName + " " + lastName
        }

    }
}
extension Guest {
    var toDictionary: Dictionary<String,String> {
        var dict = [String:String]()
        dict["first_name"] = self.firstName
        dict["last_name"] = self.lastName
        dict["email"] = self.email
        return dict
    }
    
    var toJSON: Dictionary<String, Any> {
    var toJSONFormat = [String:Any]()
        toJSONFormat["first_name"] = self.firstName
        toJSONFormat["last_name"] = self.lastName
        toJSONFormat["email"] = self.email
       return toJSONFormat
    }
}
