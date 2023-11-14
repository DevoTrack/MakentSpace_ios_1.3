/**
* WishListModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class WishListModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var list_id : NSString = ""
    var host_experience_count : NSString = ""
    var rooms_count : NSString = ""
    var list_name : NSString = ""
    var privacy : NSString = ""
//    var arrListRooms : NSMutableArray = NSMutableArray()
    var arrListRooms : NSArray?

   // MARK: Inits
    func initiateWishListData(responseDict: NSDictionary) -> Any
    {
        print(responseDict.allKeys)
        
        list_id =  self.checkParamTypes(params: responseDict, keys:"list_id")
        list_name = self.checkParamTypes(params: responseDict, keys:"list_name")
        privacy = self.checkParamTypes(params: responseDict, keys:"privacy")
        host_experience_count = self.checkParamTypes(params: responseDict, keys:"host_experience_count")
        rooms_count = self.checkParamTypes(params: responseDict, keys:"space_count")
        
//        if let latestValue = responseDict["room_thumb_images"] as? NSArray
//        {
//            arrListRooms = latestValue
//        }
        if let latestValue = responseDict["space_thumb_images"] as? NSArray
        {
            arrListRooms = latestValue
        }

        return self
    }
    
    
    
    //MARK: Check Param Type
    func checkParamTypes(params:NSDictionary, keys:NSString) -> NSString
    {
        if let latestValue = params[keys] as? NSString {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? String {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? Int {
            return String(format:"%d",latestValue) as NSString
        }
        else if (params[keys] as? NSNull) != nil {
            return ""
        }
        else
        {
            return ""
        }
    }

}

class WishListRoomModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var room_id : NSString = ""
    var user_id : NSString = ""
    var room_thumb_image : NSString = ""

    // MARK: Inits
    func initiateWishListRoomData(responseDict: NSDictionary) -> Any
    {
//        room_id =  self.checkParamTypes(params: responseDict, keys:"room_id")
//        room_thumb_image = self.checkParamTypes(params: responseDict, keys:"room_thumb_image")
        room_id =  self.checkParamTypes(params: responseDict, keys:"list_id")
        room_thumb_image = self.checkParamTypes(params: responseDict, keys:"space_thumb_images")
        user_id = self.checkParamTypes(params: responseDict, keys:"user_id")
        return self
    }
    
    
    //MARK: Check Param Type
    func checkParamTypes(params:NSDictionary, keys:NSString) -> NSString
    {
        if let latestValue = params[keys] as? NSString {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? String {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? Int {
            return String(format:"%d",latestValue) as NSString
        }
        else if (params[keys] as? NSNull) != nil {
            return ""
        }
        else
        {
            return ""
        }
    }
    
}

