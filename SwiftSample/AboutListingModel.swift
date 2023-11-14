/**
* AboutListingModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class AboutListingModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""

    var space_msg : NSString = ""
    var guest_access_msg : NSString = ""
    var interaction_with_guest_msg : NSString = ""
    var overview_msg : NSString = ""
    var getting_arround_msg : NSString = ""
    var other_things_to_note_msg : NSString = ""
    var house_rules_msg : NSString = ""

    
   // MARK: Inits
    func initiateListingData(responseDict: NSDictionary) -> Any
    {        
        space_msg = self.checkParamTypes(params: responseDict, keys:"space_msg")
        guest_access_msg = self.checkParamTypes(params: responseDict, keys:"guest_access_msg")
        interaction_with_guest_msg = self.checkParamTypes(params: responseDict, keys:"interaction_with_guest_msg")
        overview_msg = self.checkParamTypes(params: responseDict, keys:"overview_msg")
        getting_arround_msg = self.checkParamTypes(params: responseDict, keys:"getting_arround_msg")
        other_things_to_note_msg = self.checkParamTypes(params: responseDict, keys:"other_things_to_note_msg")
        house_rules_msg = self.checkParamTypes(params: responseDict, keys:"house_rules_msg")

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
