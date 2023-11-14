/**
 * GoogleLocationModel.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation
import UIKit

class GoogleLocationModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var street_address : String = ""
    var city_name : String = ""
    var city_name1 : String = ""
    var premise_name : String = ""
    var state_name : String = ""
    var postal_code : String = ""
    var country_name : String = ""
    var dictTemp : NSMutableDictionary = NSMutableDictionary()
    
    //MARK: Inits
    func initiateLocationData(responseDict: NSDictionary) -> Any
    {
        let dictMainResult = responseDict.value(forKeyPath: "result.address_components") as! NSArray

        for i in 0 ..< dictMainResult.count
        {
            let dictOrgResult = dictMainResult[i] as! NSDictionary
            let arrResult = dictOrgResult["types"] as! NSArray
            let strType = arrResult[0] as! String
            print(i)
            print(strType)
            if strType == "street_number"
            {
                street_address = dictOrgResult["long_name"] as! String
            }
            else if strType == "route"
            {
                if ((street_address as String).count > 0)
                {
                    street_address = String(format:"%@, %@",street_address,dictOrgResult["long_name"] as! String)
                }
                else
                {
                    street_address = String(format: "%@",dictOrgResult["long_name"] as! String)
                }
            }
            else if strType == "locality" || strType == "administrative_area_level_2"
            {
                city_name = dictOrgResult["long_name"] as! String
            }
            else if strType == "administrative_area_level_2" || strType == "political"
            {
                city_name1 = dictOrgResult["long_name"] as! String
            }
            else if strType == "administrative_area_level_1"
            {
                state_name = dictOrgResult["long_name"] as! String
            }
            else if strType == "country"
            {
                country_name = dictOrgResult["long_name"] as! String
            }
            else if strType == "postal_code"
            {
                postal_code = dictOrgResult["long_name"] as! String
            }
        }
 
        return self
    }
    
}
