/**
* GeneralModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class GeneralModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    
    // This is for room booking
    var availability_msg : NSString = ""
    var pernight_price : NSString = ""

    // Inbox
    var unread_message_count : NSString = ""
    
    var min_price : NSString = ""
    var max_price : NSString = ""
    var total_page: Int = 0

    var room_id : NSString = ""
    var room_location : NSString = ""
    var host_user_id : NSString = ""
    var request_user_id : String = ""
    
    var count : Int = 0
    var bookVal : NSString = ""
    
    var message : NSString = ""
    var message_time : NSString = ""
    var length_of_stay_options : NSString = ""

    var receiver_thumb_image : NSString = ""
    var sender_thumb_image : NSString = ""
    
    var dictTemp : NSMutableDictionary = NSMutableDictionary()
    var tripArray = NSArray()
    var arrTemp1 : NSMutableArray = NSMutableArray()
    var arrTemp2 : NSMutableArray = NSMutableArray()
    var arrTemp3 : NSMutableArray = NSMutableArray()
    var arrTemp4 : NSMutableArray = NSMutableArray()
    var arrTemp5 : NSMutableArray = NSMutableArray()
    var arrTemp6 : NSMutableArray = NSMutableArray()
    var trpModel = [tripList]()
    var brkModel = [tripList]()
    var bedTypes : [BedType]?

}
class tripList{
    var count = Int()
    var key = String()
    var value = String()
    
    init(){}
    init(_ json:JSONS) {
        self.count = json.int("count")
        self.key = json.string("key")
        self.value = json.string("value")
    }
}

