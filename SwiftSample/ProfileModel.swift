/**
 * ProfileModel.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */


import Foundation
import UIKit

class ProfileModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var user_name : NSString = ""
    var first_name : NSString = ""
    var last_name : NSString = ""
    var user_thumb_image : NSString = ""
    var user_normal_image_url : NSString = ""
    var user_large_image_url : NSString = ""
    var user_small_image_url : NSString = ""
    var dob : NSString = ""
    var email_id : NSString = ""
    var user_location : NSString = ""
    var member_from : NSString = ""
    var about_me : NSString = ""
    var school : NSString = ""
    var gender : NSString = ""
    var phone : NSString = ""
    var work : NSString = ""
    var is_email_connect : NSString = ""
    var is_facebook_connect : NSString = ""
    var is_google_connect : NSString = ""
    var is_linkedin_connect : NSString = ""
    var user_id : NSString = ""
    
    init(json:JSONS) {
        self.user_name = json.nsString("user_name")
        self.first_name = (json.nsString("first_name").removingPercentEncoding ?? "") as NSString
        self.last_name = json.nsString("last_name")
        if (self.user_name as String).isEmpty {
            self.user_name = "\(self.first_name) \(self.last_name)" as NSString
        }
        self.user_thumb_image = json.nsString("small_image_url")
        self.user_normal_image_url = json.nsString("normal_image_url")
        user_large_image_url = json.nsString("large_image_url")
        user_small_image_url = json.nsString("small_image_url")
        dob = json.nsString("dob")
        email_id = json.nsString("email")
        user_location = json.nsString("user_location")
        member_from = json.nsString("member_from")
        about_me = json.nsString("about_me")
        school = json.nsString("school")
        gender = json.nsString("gender")
        phone = json.nsString("phone")
        work = json.nsString("work")
        is_email_connect = json.nsString("is_email_connect")
        is_facebook_connect = json.nsString("is_facebook_connect")
        is_google_connect = json.nsString("is_google_connect")
        is_linkedin_connect = json.nsString("is_linkedin_connect")
        
        
    }
    //MARK: Inits
    func initiateOtherProfileData(responseDict: NSDictionary) -> Any
    {
        user_name =  String(format:"%@ %@",responseDict["first_name"] as! NSString,responseDict["last_name"] as! NSString) as NSString
        first_name = responseDict["first_name"] as! NSString
        last_name = responseDict["last_name"] as! NSString
        user_thumb_image = responseDict["large_image"] as! NSString
        user_normal_image_url = responseDict["large_image"] as! NSString
        user_large_image_url = responseDict["large_image"] as! NSString
        user_small_image_url = responseDict["large_image"] as! NSString
        user_location = responseDict["user_location"] as! NSString
        member_from = MakentSupport().checkParamTypes(params: responseDict, keys:"member_from")
        about_me = MakentSupport().checkParamTypes(params: responseDict, keys:"about_me")
        return self
    }
    
    
}
extension ProfileModel {
    convenience init(otherProfileJson:JSONS) {
        self.init(json: otherProfileJson)
        first_name = otherProfileJson.nsString("first_name")
        last_name = otherProfileJson.nsString("last_name")
        user_name =  String(format:"%@ %@",first_name,last_name) as NSString
        user_thumb_image = otherProfileJson.nsString("large_image")
        user_normal_image_url = otherProfileJson.nsString("large_image")
        user_large_image_url = otherProfileJson.nsString("large_image")
        user_small_image_url = otherProfileJson.nsString("large_image")
        user_location = otherProfileJson.nsString("user_location")
        member_from = otherProfileJson.nsString("member_from")
        about_me = otherProfileJson.nsString("about_me")
    }
}
