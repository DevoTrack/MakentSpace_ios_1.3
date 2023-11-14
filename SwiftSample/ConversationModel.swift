/**
 * ConversationModel.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */


import Foundation
import UIKit


//typealias JSON = [String:Any]
class ConversationModel : NSObject
{
    //MARK Properties
    var success_message : String = ""
    var status_code : String = ""
    var receiver_thumb_image : String = ""
    var receiver_user_name : String = ""
    var receiver_message_status : String = ""
    var receiver_details : JSONS = JSONS()
    var receiver_messages_time : String = ""
    
    var receiver_messages : String = ""
    var sender_thumb_image : String = ""
    var sender_user_name : String = ""
    var sender_message_status : String = ""
    var sender_details : JSONS = JSONS()
    var sender_messages : String = ""
    var sender_messages_time : String = ""
    
    
    //    var is_message_read : String = ""
    
    //MARK: Inits
    init(responseDict: JSONS)
    {
        receiver_thumb_image = responseDict.string("receiver_thumb_image")
        receiver_user_name = responseDict.string("receiver_user_name")
        receiver_message_status = responseDict.string("receiver_message_status")
        receiver_messages = responseDict.string("receiver_messages")
        receiver_messages_time = responseDict.string("date/time")
        sender_thumb_image = responseDict.string("sender_thumb_image")
        sender_user_name = responseDict.string("sender_user_name")
        sender_message_status = responseDict.string("sender_message_status")
        sender_messages = responseDict.string("sender_messages")
        
        //        receiver_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"receiver_thumb_image")
        //        receiver_user_name = MakentSupport().checkParamTypes(params: responseDict, keys:"receiver_user_name")
        //        receiver_message_status = MakentSupport().checkParamTypes(params: responseDict, keys:"receiver_message_status")
        //        receiver_messages = MakentSupport().checkParamTypes(params: responseDict, keys:"receiver_messages")
        //        receiver_messages_time = MakentSupport().checkParamTypes(params: responseDict, keys:"receiver_messages_date/time")
        //        sender_messages_time = MakentSupport().checkParamTypes(params: responseDict, keys:"sender_messages_date/time")
        //        sender_thumb_image = MakentSupport().checkParamTypes(params: responseDict, keys:"sender_thumb_image")
        //        sender_user_name = MakentSupport().checkParamTypes(params: responseDict, keys:"sender_user_name")
        //        sender_message_status = MakentSupport().checkParamTypes(params: responseDict, keys:"sender_message_status")
        //        sender_messages = MakentSupport().checkParamTypes(params: responseDict, keys:"sender_messages")
        
        
        if var latestValue = responseDict["sender_details"] as? JSONS
        {
            sender_details = latestValue
        }
        
        if var latestValue = responseDict["receiver_details"] as? JSONS
        {
            receiver_details = latestValue
        }
        
        //        return self
    }
    
    
}


class ConversationChatModel {
    var successMessage: String = ""
    var statusCode: String = ""
    var senderUserName: String = ""
    var senderThumbImage: String = ""
    var receiverUserName: String = ""
    var receiverThumbImage: String = ""
    var chat: [Chat] = []
    
    init(responseJSON: JSONS) {
        self.successMessage = responseJSON.statusMessage
        self.statusCode = "\(responseJSON.statusCode)"
        self.senderUserName = responseJSON.string("sender_user_name")
        self.senderThumbImage = responseJSON.string("sender_thumb_image")
        self.receiverUserName = responseJSON.string("receiver_user_name")
        self.receiverThumbImage = responseJSON.string("receiver_thumb_image")
        if responseJSON.array("data").count > 0 {
            self.chat.removeAll()
            for chat in responseJSON.array("data") {
                let chatJSON = Chat(responseDict: chat)
                self.chat.append(chatJSON)
            }
        }
    }
}

class Chat {
    var receiver_thumb_image : String = ""
    var receiver_user_name : String = ""
    var receiver_message_status : String = ""
    var receiver_details : ErDetails!
    var receiver_messages_time : String = ""
    var conversation_time: String = ""
    var receiver_messages : String = ""
    var sender_thumb_image : String = ""
    var sender_user_name : String = ""
    var sender_message_status : String = ""
    var sender_details : ErDetails!
    var sender_messages : String = ""
    var sender_messages_time : String = ""
    
    init(responseDict: JSONS) {
        receiver_thumb_image = responseDict.string("receiver_thumb_image")
        receiver_user_name = responseDict.string("receiver_user_name")
        receiver_message_status = responseDict.string("receiver_message_status")
        receiver_messages = responseDict.string("receiver_messages").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.removingPercentEncoding ?? ""
//            ((responseDict.string("receiver_messages") as NSString).removingPercentEncoding)! as String
        receiver_messages_time = responseDict.string("date/time")
        conversation_time = responseDict.string("conversation_time")
        sender_thumb_image = responseDict.string("sender_thumb_image")
        sender_user_name = responseDict.string("sender_user_name")
        sender_message_status = responseDict.string("sender_message_status")
        sender_messages = responseDict.string("sender_messages").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.removingPercentEncoding ?? ""
//            ((responseDict.string("sender_messages") as NSString).removingPercentEncoding)! as String
        sender_messages_time = responseDict.string("date/time")
        if let latestValue = responseDict["sender_details"] as? JSONS
        {
            let erDetails = ErDetails(status: latestValue.string("status"), dateTime: latestValue.string("date/time"))
            sender_details = erDetails
        }
        
        if let latestValue = responseDict["receiver_details"] as? JSONS
        {
            let erDetails = ErDetails(status: latestValue.string("status"), dateTime: latestValue.string("date/time"))
            receiver_details = erDetails
        }
    }
}

class ErDetails {
    var status: String = ""
    var dateTime: String = ""
    
    init(status: String?, dateTime: String?) {
        self.status = status ?? ""
        self.dateTime = dateTime ?? ""
    }
}

