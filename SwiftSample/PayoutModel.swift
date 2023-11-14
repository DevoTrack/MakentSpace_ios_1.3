/**
 * PayoutModel.swift
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

class PayoutModel : NSObject {
    
    //MARK Properties
    var success_message : NSString = ""
    var status_code : NSString = ""
    var payout_id : NSString = ""
    var payout_type : NSString = ""
    var payout_user_name : NSString = ""
    var payout_mail_id : NSString = ""
    var paypal_method : NSString = ""

   // MARK: Inits
    func initiatePayoutData(responseDict: NSDictionary) -> Any
    {
        payout_id =  MakentSupport().checkParamTypes(params: responseDict, keys:"payout_id")
        payout_type = MakentSupport().checkParamTypes(params: responseDict, keys:"set_default")
        payout_user_name = MakentSupport().checkParamTypes(params: responseDict, keys:"payout_user_name")
        payout_mail_id = MakentSupport().checkParamTypes(params: responseDict, keys:"paypal_email")
        paypal_method = MakentSupport().checkParamTypes(params: responseDict, keys:"paypal_method")
        return self
    }
}
