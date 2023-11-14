/**
* RoomPropertyModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit




class RoomPropertyModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var property_name : NSString!
    var property_id : NSString!
    var property_description : NSString!
    var property_isShared : NSString!
    var property_Image: NSString!
    
    var len_nights : NSString!
    var len_text : NSString!
    
    var res_text : NSString!
    var start_date : NSString!
    var end_date : NSString!

    // MARK: Inits
    func initiatePropertyData(responseDict: NSDictionary) -> Any
    {
        property_name = MakentSupport().checkParamTypes(params: responseDict, keys:"name")
        property_id = MakentSupport().checkParamTypes(params: responseDict, keys:"id")
        property_description = MakentSupport().checkParamTypes(params: responseDict, keys:"description")
        property_isShared = MakentSupport().checkParamTypes(params: responseDict, keys:"is_shared")
        property_Image = MakentSupport().checkParamTypes(params: responseDict, keys:"image_name")
        return self
    }
    func initiatePriceData(responseDict: NSDictionary) -> Any
    {
        len_nights = MakentSupport().checkParamTypes(params: responseDict, keys:"nights")
        len_text = MakentSupport().checkParamTypes(params: responseDict, keys:"text")
        return self
    }
    func initiateReservationData(responseDict: NSDictionary) -> Any
    {
        res_text = MakentSupport().checkParamTypes(params: responseDict, keys:"text")
        start_date = MakentSupport().checkParamTypes(params: responseDict, keys:"start_date")
        end_date = MakentSupport().checkParamTypes(params: responseDict, keys:"end_date")
        return self
    }
}
