//
//  AppleLoginStorge.swift
//  Makent
//
//  Created by trioangle on 20/01/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit



enum AppleLogin:String{
    case firstName
    case lastName
    case userIdentifer
    case email
}
class AppleLoginStorge  {
    
    
    var firstName:String
    var lastName:String
    var userIdentifer:String
    var email:String
    
    init(first:String,last:String,user:String,email:String) {
        self.firstName = first
        self.lastName = last
        self.userIdentifer = user
        self.email = email
       
    }
    
    
    func storeDetails(){
        
        
        
        KeychainItem.currentUserEmail = self.email
        KeychainItem.currentUserFirstName = self.firstName
        KeychainItem.currentUserLastName = self.lastName
        KeychainItem.currentUserIdentifier = self.userIdentifer
       
        
//        if let identityTokenData = appleIDCredential.identityToken,
//            let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
//            debug(print: "Identity Token \(identityTokenString)")
//        }
    }
    
    
    static func getStoreDetails()->AppleLoginStorge{
        
        
        let first = KeychainItem.currentUserFirstName  ?? ""
        let last = KeychainItem.currentUserLastName ?? ""
        let user = KeychainItem.currentUserIdentifier ?? ""
        let email = KeychainItem.currentUserEmail ?? ""
        let model = AppleLoginStorge(first: first, last: last, user: user, email: email)
        return model
    }
    
    
    static func deleteUserDetails(){
        KeychainItem.deletedKeyChainDatas()
        
    }
    
    
}
