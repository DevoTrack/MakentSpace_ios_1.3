/**
* AmenitiesModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class AmenitiesModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var amenities_id : NSString = ""
    var amenities_name : NSString = ""
    var amenities_type : NSString = ""
    var amenities_iconname : NSString = ""

   // MARK: Inits
    func initiateAmenitiesData(responseDict: NSDictionary,iconName: NSDictionary) -> Any
    {
        amenities_id =  String(format:"%d",iconName["id"] as! Int) as NSString
        amenities_name = String(format:"%@",iconName["name"] as! String) as NSString
        amenities_type = MakentSupport().checkParamTypes(params: iconName, keys: "type_id")
        amenities_iconname = String(format:"%@",responseDict["icon"] as! String) as NSString
        return self
    }
}
