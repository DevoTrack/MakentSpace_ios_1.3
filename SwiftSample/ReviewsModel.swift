/**
* ReviewsModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class ReviewsModel {
    
    //MARK Properties
   
    var accuracy_value : NSString = ""
    var check_in_value : NSString = ""
    var cleanliness_value : NSString = ""
    var communication_value : NSString = ""
    var location_value : NSString = ""
    var value : NSString = ""
    
    var total_review : NSString = ""
    var ratingValue: NSString = ""
    
   
    var userDetails = [ReviewUserDetail]()
   // MARK: Inits
    func initiateReviewData(responseDict: NSDictionary) -> Any
    {
        
        
        
        return self
    }
    
    init(json:JSONS) {
       self.accuracy_value = json.nsString("accuracy")
        self.check_in_value = json.nsString("check_in")
        self.cleanliness_value = json.nsString("cleanliness")
        self.communication_value = json.nsString("communication")
        self.location_value = json.nsString("location")
        self.value = json.nsString("value")
        self.total_review = json.nsString("total_review")
        self.ratingValue = json.nsString("rating")
        self.userDetails.removeAll()
        json.array("data").forEach({self.userDetails.append(ReviewUserDetail(json: $0))})
        
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

class ReviewUserDetail {
   
    var review_user_name : NSString = ""
    var review_user_image : NSString = ""
    var review_date : NSString = ""
    var review_message : NSString = ""
    
    init(json:JSONS) {
        
        self.review_user_name = json.nsString("review_user_name")
        self.review_user_image = json.nsString("review_user_image")
        self.review_date = json.nsString("review_date")
        self.review_message = json.nsString("review_message")
    }
}
