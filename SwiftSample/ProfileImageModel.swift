/**
* ProfileImageModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class ProfileImageModel : NSObject {
    
    //MARK Properties
    var large_image_url : NSString = ""
    var normal_image_url : NSString = ""
    var small_image_url : NSString = ""

    //MARK: Inits
    func initiateProfileImageData(responseDict: NSDictionary) -> Any
    {
        large_image_url = MakentSupport().checkParamTypes(params: responseDict, keys:"large_image_url")
        normal_image_url = MakentSupport().checkParamTypes(params: responseDict, keys:"normal_image_url")
        small_image_url = MakentSupport().checkParamTypes(params: responseDict, keys:"small_image_url")
        return self
    }
    
    
}
