/**
* Constants.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

//MARK:- Updated from Info file
let infoPlist = PlistReader<InfoPlistKeys>()

let APIBaseUrl : String = (infoPlist?.value(for: .App_URL) ?? "").replacingOccurrences(of: "\\", with: "")

let APIUrl : String = APIBaseUrl + "api/"
let GOOGLE_MAP_API_KEY : String = infoPlist?.value(for: .GOOGLE_API_KEY) ?? ""
let GOOGLE_MAP_PLACE_KEY : String = infoPlist?.value(for: .GOOGLE_PLACE_KEY) ?? ""

let k_PaypalClientID : String = infoPlist?.value(for: .PAYPAL_ID) ?? ""
let k_StripeKey : String = infoPlist?.value(for: .STRIPE_KEY) ?? ""
let k_AppName : String = infoPlist?.value(for: .APP_NAME) ?? ""
let k_AppLogo : String = infoPlist?.value(for: .APP_LOGO) ?? ""
let k_AppTabBar : String = infoPlist?.value(for: .APP_TABBAR) ?? ""



let k_APIServerUrl   = "\(APIBaseUrl)api/"
let k_WebServerUrl   = "\(APIBaseUrl)"



//
//enum AppURL
//{
//    case demo
//    case live
//    var instance :String {
//        switch  self
//        {
//        case .live:
//            return "https://makentspace.trioangle.com/"
//        case .demo :
//            return  "https://makentspace.trioangledemo.com/"
//        }
//    }
//}

enum k_AppNameType {
    case experience
    case home
    case all
}

// MARK: APP NAME AND BASE URL
let k_AppType:k_AppNameType = k_AppNameType.all
//let k_AppName =  "Makent Space"
let k_AppVersion: String = {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
}()
//let k_AppLogo = "applogo.png"
//let k_AppTabBar = "trips.png"
//let k_WebServerUrl   = AppURL.live.instance // AppURL.live.instance //
//let k_APIServerUrl   = "\(k_WebServerUrl)api/"
//let k_StripeKey = " -- Your Stipe Key ---"
//let k_PaypalClientID = " -- Your Paypal Key ---"//

//let GOOGLE_MAP_API_KEY = "ENTER YOUR MAP KEY HERE"


let k_MakentStoryboard : UIStoryboard = UIStoryboard(name: "MakentMainStoryboard", bundle: nil)

let k_ApplicationFontLight = "CircularAirPro-Light"
let k_ApplicationFontBook = "CircularAirPro-Book"
let k_ApplicationFontBold = "CircularAirPro-Bold"

enum k_isHomeType:String {
    case homeType
    var instance:String {
        switch  self {
        case .homeType:
            if k_AppType == .experience {
                return "experience"
            }else if k_AppType == .all {
               return "all"
            }else {
               return "stay"
            }
        }
    }

}

enum K_PipeNames: String{
    case reloadView
}

class Constants : NSObject
{
    static let guestThemeColor = UIColor.init(hex: "#E32250")
    static let hostThemeColor = UIColor.init(hex: "#FF5A5F")
    
    static let hostButtonColor = Constants.guestThemeColor
    static let guestButtonColor = Constants.hostThemeColor

    static let monsterFavouriteColor = UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    static let monsterLightColor = Constants.guestThemeColor.withAlphaComponent(0.5)
    
    static let instantBookColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    static let downarrowImage = UIImage(named: "down-arrow1")?.withRenderingMode(.alwaysTemplate)
    static let maplayer = UIImage(named: "map_layer")?.withRenderingMode(.alwaysTemplate)
    static let spaceImage = UIImage(named: "rooms")?.withRenderingMode(.alwaysTemplate)
    static let upArrow = UIImage(named: "upicon")?.withRenderingMode(.alwaysTemplate)
    
    private let lang = Language.getCurrentLanguage().getLocalizedInstance()

    func STOREVALUE(value : NSString , keyname : String)
    {
//        if !value.isEqual(to: ""){
        UserDefaults.standard.setValue(value , forKey: keyname as String)
        UserDefaults.standard.synchronize()
//        }
    }

    func GETVALUE(keyname : String) -> NSString
    {
        return UserDefaults.standard.value(forKey: keyname) as? NSString ?? ""
    }
    
    func REMOVEVALUE(keyname : String)
    {
            UserDefaults.standard.removeObject(forKey: keyname)
    }
    
    func setTripStatus(_ model:BaseBookingModel)->String {
        if model.reservationStatus == "Cancelled"{
            return self.lang.canld_Tit
        }
        else if model.reservationStatus == "Inquiry"{
            return self.lang.inq_Title
        }
        else if model.reservationStatus == "Declined"{
            return self.lang.decld_Tit
        }
        else if model.reservationStatus == "Expired"{
            return self.lang.exp_Tit
        }
        else if model.reservationStatus == "Accepted"{
            return self.lang.accep_Tit
        }
        else if model.reservationStatus == "Pre-Accepted"{
            return self.lang.preaccep_Tit
        }
        else if model.reservationStatus == "Pre-Approved" {
            return self.lang.prepproved_Title
        }
        else {
            return self.lang.pend_Tit
        }
    }
    
    func setTripStatusColor(_ model:BaseBookingModel)->UIColor {
        if model.reservationStatus == "Declined" || model.reservationStatus == "Expired"
        {
            return .appGuestThemeColor
        }
        else if model.reservationStatus == "Accepted"
        {
            return UIColor(red: 63.0 / 255.0, green: 179.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        }
        else if model.reservationStatus == "Pre-Accepted" || model.reservationStatus == "Inquiry" || model.reservationStatus == "Cancelled"
        {
            return UIColor.darkGray
        }
        else
        {
            return Constants.monsterFavouriteColor
        }
    }

}



extension UIColor {
    static var appGuestThemeColor = Constants.guestThemeColor
    static var appHostThemeColor = Constants.hostThemeColor
    
    static var appGuestButtonBG = Constants.guestButtonColor
    static var appHostButtonBG = Constants.hostButtonColor
    
    static var appTitleColor = Constants.guestThemeColor
    static var appHostTitleColor = Constants.hostThemeColor

    static var appFavouriteColor = Constants.monsterFavouriteColor

    static var appGuestLightColor = Constants.monsterLightColor
    static var instantBookColor = Constants.instantBookColor
    
}
struct lang{
    let langValue = Language.getCurrentLanguage().getLocalizedInstance()
}
extension UIView{
    func appGuestViewBGColor() {
        self.backgroundColor = UIColor.appGuestThemeColor
    }
    
    func appHostViewBGColor() {
        self.backgroundColor = UIColor.appHostThemeColor
    }

    func guestElevateBGColor(){
        self.backgroundColor = UIColor.appGuestLightColor
        self.elevate(3.0)
    }
    
    
}

enum CancelPolicy:String
{
    
    case flexible
    case moderate
    case strict
    
    var instance :String {
        switch self {
        case .flexible:
            return "<html><h3><font  face=\"verdana\"  color=\"#484848\">Flexible: Full refund 1 day prior to arrival, except fees</h3><ul><li>Cleaning fees are always refunded if the guest did not check in.</li><br><li>The \(k_AppName) service fee is non-refundable.</li><br><li>If there is a complaint from either party, notice must be given to \(k_AppName) within 24 hours of check-in.</li><br><li>\(k_AppName) will mediate when necessary, and has the final say in all disputes.</li><br><li>A reservation is officially canceled when the guest clicks the cancellation button on the cancellation confirmation page, which they can find in Dashboard &gt; Your Trips &gt; Change or Cancel.</li><br><li>Cancellation policies may be superseded by the Guest Refund Policy, safety cancellations, or extenuating circumstances. Please review these exceptions.</li><br><li>Applicable taxes will be retained and remitted.</li><br></ul><p>For a full refund, cancellation must be made a full 24 hours prior to listing’s local check in time (or 3:00 PM if not specified) on the day of check in.  For example, if check-in is on Friday, cancel by Thursday of that week before check in time.</p></div><div class=\"col-md-4\"><p>If the guest cancels less than 24 hours before check-in, the first night is non-refundable.</p></div><div class=\"col-md-4\"><p>If the guest arrives and decides to leave early, the nights not spent 24 hours after the official cancellation are 100% refunded.</p></div></html>"
        case .moderate:
            return "<html><h3><font  face=\"verdana\"  color=\"#484848\">Moderate: Full refund 5 days prior to arrival, except fees</h3><ul><li>Cleaning fees are always refunded if the guest did not check in.</li><br><li>The \(k_AppName) service fee is non-refundable.</li><br><li>If there is a complaint from either party, notice must be given to \(k_AppName) within 24 hours of check-in.</li><br><li>\(k_AppName) will mediate when necessary, and has the final say in all disputes.</li><br><li>A reservation is officially canceled when the guest clicks the cancellation button on the cancellation confirmation page, which they can find in Dashboard &gt; Your Trips &gt; Change or Cancel.</li><br><li>Cancellation policies may be superseded by the Guest Refund Policy, safety cancellations, or extenuating circumstances. Please review these exceptions.</li><br><li>Applicable taxes will be retained and remitted.</li></ul><p>For a full refund, cancellation must be made five full days prior to listing’s local check in time (or 3:00 PM if not specified) on the day of check in.  For example, if check-in is on Friday, cancel by the previous Sunday before check in time.</p></div><div class=\"col-md-4\"><p>If the guest cancels less than 5 days in advance, the first night is non-refundable but the remaining nights will be 50% refunded.</p></div><div class=\"col-md-4\"><p>If the guest arrives and decides to leave early, the nights not spent 24 hours after the cancellation occurs are 50% refunded.</p></div></html>"
        case .strict:
            return "<html><h3><font  face=\"verdana\"  color=\"#484848\">Strict: 50% refund up until 1 week prior to arrival, except fees</h3><ul><li>Cleaning fees are always refunded if the guest did not check in.</li><li>The \(k_AppName) service fee is non-refundable.</li><li>If there is a complaint from either party, notice must be given to \(k_AppName) within 24 hours of check-in.</li><li>\(k_AppName) will mediate when necessary, and has the final say in all disputes.</li><li>A reservation is officially canceled when the guest clicks the cancellation button on the cancellation confirmation page, which they can find in Dashboard &gt; Your Trips &gt; Change or Cancel.</li><li>Cancellation policies may be superseded by the Guest Refund Policy, safety cancellations, or extenuating circumstances. Please review these exceptions.</li><li>Applicable taxes will be retained and remitted.</li></ul><p>For a 50% refund, cancellation must be made seven full days prior to listing’s local check in time (or 3:00 PM if not specified) on the day of check in, otherwise no refund. For example, if check-in is on Friday, cancel by Friday of the previous week before check in time.</p></div><div class=\"col-md-4\"><p>If the guest cancels less than 7 days in advance, the nights not spent are not refunded.</p></div><div class=\"col-md-4\"><p>If the guest arrives and decides to leave early, the nights not spent are not refunded.</p></div></html>"
        
            
        }
    }
    
}

class APPURL : NSObject{
//MARK:- LIST OF EXPERIENCE METHODS
    static let API_EXPLORE_EXPERIENCE = "explore_experiences"
    static let API_EXPERIENCE_CONTACT_HOST = "experiences"
    static let API_HOST_EXPERIENCE_CATEGORY = "host_experience_categories"
    static let API_EXPERIENCE_PRE_PAYMENT = "experience_pre_payment"
    static let API_EXPERIENCE_PAYMENT = "experience_payment"
    static let API_EXPERIENCE_ROOM_DETAILS = "experience"
    static let API_EXPERIENCE_ROOM_AVAILABLE_STATUS = "choose_date"
    
    //MARK:- API NAME FOR TRAVEL
    static let API_SIGNUP = "signup"
    static let API_LOGIN = "login"
    static let API_EMAILVALIDATION = "emailvalidation"
    static let API_FORGOTPASSWORD = "forgotpassword"
    static let API_EXPLORE = "explore"
    static let API_ROOM_DETAIL = "rooms"
    static let API_MAPS_LIST = "maps"
    static let API_HOUSE_RULES = "house_rules"
    static let API_AMENITIES_LIST = "amenities_list"
    static let API_REVIEW_LIST = "review_detail"
    static let API_CALENDAR_AVAILABEL = "calendar_availability"
    static let API_ROOM_AVAILABLE_STATUS = "calendar_availability_status"
    static let API_COUNTRY_LIST = "country_list"
    static let API_CURRENCY_LIST = "currency_list"
    static let API_CHANGE_CURRENCY = "currency_change"
    static let API_VIEW_PROFILE = "view_profile"
    static let API_VIEW_OTHER_PROFILE = "user_profile_details"
    static let API_EDIT_PROFILE = "edit_profile"
    static let API_UPLOAD_PROFILE_IMAGE = "upload_profile_image"
    static let API_TRIPS_TYPE = "booking_types"
    static let API_ADD_PAYOUT_DETAILS = "add_payout_perference"
    static let API_TRIPS_DETAILS = "booking_details"
    static let API_INBOX_RESERVATION = "inbox"
    static let API_SEND_MESSAGE = "send_message"
    static let API_GET_CONVERSATION = "conversation_list"
    static let API_GET_RESERVATION = "reservation_list"
    static let API_GET_PAYOUT_LIST = "payout_details"
    static let API_MAKE_DEFAULT_DELETE_PAYOUT = "payout_changes"
    static let API_PRE_APPROVAL_OR_DECLINE = "pre_approve"
    static let API_BOOK_NOW = "book_now"
    static let API_PAY_NOW = "pay_now"
    static let API_PRE_PAYMENT = "pre_payment"
    static let API_CONTACT_HOST = "contact_request"
    static let API_ADD_TO_WISHLIST = "add_wishlist"
    static let API_GET_WISHLIST = "get_wishlist"
    static let API_GET_PARTICULAR_WISHLIST = "get_particular_wishlist"
    static let API_DELETE_WISHLIST = "delete_wishlist"
    static let API_DELETE_EXPERIENCE_WISHLIST = "delete_wishlist"
    static let API_CHANGE_PRIVACY_WISHLIST = "edit_wishlist"
    static let API_ADD_STRIPE_PAYOUT = "stripe_supported_country_list"
    static let API_GUEST_CANCEL_TRIP_AFTER_PAY = "guest_cancel_reservation"
    static let API_CANCEL_PENDING_TRIP_BY_GUEST = "guest_cancel_pending_reservation"

//MARK:- API NAME FOR HOST
    
    static let API_ADD_NEW_ROOM = "new_add_room"
    static let API_GET_LISTING = "listing"
    static let API_ADD_ROOM_PRICE = "add_rooms_price"
    static let API_ROOM_PROPERTY_TYPE = "room_property_type"
    static let API_UPDATE_ROOM_LOCATION = "update_location"
    static let API_VALIDATE_LOCATION = "validate_location"
    static let API_UPDATE_TITLE = "update_title_description"
    static let API_CALANDER_ROOMS_LIST = "rooms_list_calendar"
    static let API_BLOCK_DATES = "new_update_calendar"
    static let API_DISABLE_LISTING = "disable_listing"
    static let API_ROOMS_BEDS_LIST = "listing_rooms_beds"
    static let API_UPDATE_SELECTED_AMENITIES = "update_amenities"
    static let API_UPDATE_ROOM_DESC = "update_description"
    static let API_UPDATE_LONG_TERM_PRICE = "update_Long_term_prices"
    static let API_UPDATE_HOUSE_RULES = "update_house_rules"
    static let API_DELETE_ADDITIONAL_PRICE = "delete_price_rule"
    static let API_UPDATE_ADDITIONAL_PRICE = "update_price_rule"
    static let API_UPDATE_AVAILABILITY_RULE = "update_availability_rule"
    static let API_DELETE_AVAILABILITY_RULE = "delete_availability_rule"
    static let API_UPLOAD_ROOM_IMAGE = "room_image_upload"
    static let API_REMOVE_ROOM_IMAGE = "remove_uploaded_image"
    static let API_UPDATE_POLICY = "update_policy"
    static let API_UPDATE_ROOM_CURRENCY = "update_room_currency"
    static let API_UPDATE_BOOKING_TYPE = "update_booking_type"
    static let API_PRE_ACCEPT = "accept"
    static let API_CANCEL_RESERVATION = "host_cancel_reservation"
    static let API_DECLINE_RESERVATION = "decline"
    static let API_UPDATE_MIN_MAX_STAY = "update_minimum_maximum_stay"
    static let API_LOGOUT = "logout"


    //MARK:- API NAME FOR HOST
    static let METHOD_SIGNUP = "signup"
    static let METHOD_LOGIN = "login"
    static let METHOD_EMAIL_VALIDATION = "emailvalidation"
    static let METHOD_FORGOT_PASSWORD = "forgotpassword"
    static let METHOD_EXPLORE = "explorepage"
    static let METHOD_ROOM_DETAIL = "roomdetailpage"
    static let METHOD_MAPS = "maps"
    static let METHOD_HOUSE_RULES = "houserules"
    static let METHOD_AMENITIES_LIST = "amenitieslist"
    static let METHOD_ROOMTYPE_LIST = "room_property_type"
    static let METHOD_REVIEW_LIST = "review_detail"
    static let METHOD_CALENDAR_AVAILABEL = "calendar_availability"
    static let METHOD_ROOM_AVAILABLE_STATUS = "room_availability_status"
    static let METHOD_COUNTRY_LIST = "countrylist"
    static let METHOD_CURRENCY_LIST = "currencylist"
    static let METHOD_CHANGE_CURRENCY = "currencychange"
    static let METHOD_PRE_PAYMENT = "pre_payment"

    static let METHOD_GOOGLE_PLACE = "googleplace"
    static let METHOD_VIEW_PROFILE = "view_profile"
    static let METHOD_VIEW_OTHER_PROFILE = "view_other_profile"
    static let METHOD_EDIT_PROFILE = "edit_profile"
    static let METHOD_UPLOAD_PROFILE_IMAGE = "upload_profile_image"
    static let METHOD_TRIPS_TYPE = "booking_types"
    static let METHOD_GUEST_CANCEL_TRIP_AFTER_PAY = "guest_cancel_reservation"
    static let METHOD_CANCEL_PENDING_TRIP_BY_GUEST = "guest_cancel_pending_reservation"
    static let METHOD_ADD_GUEST = "add_guest_details"
    static let METHOD_REMOVE_GUEST = "remove_guest_details"
    static let METHOD_ADD_PAYOUT_DETAILS = "add_payout_perference"
    static let METHOD_TRIPS_DETAILS = "booking_details"
    static let METHOD_INBOX_RESERVATION = "inbox"
    static let METHOD_SEND_MESSAGE = "send_message"
    static let METHOD_GET_RESERVATION = "reservation_list"
    static let METHOD_GET_CONVERSATION = "conversation_list"
    static let METHOD_GET_PAYOUT_LIST = "payout_details"
    static let METHOD_DELETE_PAYOUT = "payout_delete"
    static let METHOD_MAKE_DEFAULT_PAYOUT = "payout_makedefault"
    static let METHOD_CONTACT_HOST = "contact_request"
    static let METHOD_ADD_TO_WISHLIST = "add_wishlist"
    static let METHOD_GET_WISHLIST = "get_wishlist"
    static let METHOD_GET_PARTICULAR_WISHLIST = "get_particular_wishlist"
    static let METHOD_PRICE_BREAKDOWN = "price_breakdown"
    static let METHOD_DELETE_WISHLIST = "delete_wishlist"
    static let METHOD_CHANGE_PRIVACY_WISHLIST = "edit_wishlist"
    static let METHOD_PRE_APPROVAL_OR_DECLINE = "pre_approve"
    static let METHOD_ADD_STRIPE_PAYOUT = "stripe_supported_country_list"

//MARK:- LIST OF EXPERIENCE METHODS

    static let METHOD_EXPERIENCE_CONTACTHOST = "contact_host"
    static let METHOD_EXPLORE_EXPERIENCE = "explore_experiences"
    static let METHOD_EXPERIENCE_PRE_PAYMENT = "experience_pre_payment"
    static let METHOD_EXPERIENCE = "experience"
    static let METHOD_HOST_EXPERIENCE_CATEGORY = "host_experience_categories"
    static let METHOD_EXPERIENCE_ROOM_AVAILABLE_STATUS = "choose_date"

//MARK:- LIST OF HOST METHODS

    static let METHOD_ADD_NEW_ROOM = "new_add_room"
    static let METHOD_GET_LISTING = "listing"
    static let METHOD_ADD_ROOM_PRICE = "add_rooms_price"
    static let METHOD_ROOM_PROPERTY_TYPE = "room_property_type"
    static let METHOD_UPDATE_ROOM_LOCATION = "update_location"
    static let METHOD_VALIDATE_LOCATION = "validate_location"
    static let METHOD_UPDATE_TITLE = "update_title_description"
    static let METHOD_CALANDER_ROOMS_LIST = "rooms_list_calendar"
    static let METHOD_BLOCK_DATES = "update_calendar"
    static let METHOD_DISABLE_LISTING = "disable_listing"
    static let METHOD_ROOMS_BEDS_LIST = "listing_rooms_beds"
    static let METHOD_UPDATE_SELECTED_AMENITIES = "update_amenities"
    static let METHOD_UPDATE_ROOM_DESC = "update_description"
    static let METHOD_UPDATE_LONG_TERM_PRICE = "update_Long_term_prices"
    static let METHOD_GET_ROOM_DESC = "get_room_description"
    static let METHOD_UPDATE_HOUSE_RULES = "update_house_rules"
    static let METHOD_DELETE_ADDITIONAL_PRICE = "delete_price_rule"
    static let METHOD_UPDATE_ADDITIONAL_PRICE = "update_price_rule"
    static let METHOD_REMOVE_ROOM_IMAGE = "remove_uploaded_image"
    static let METHOD_UPDATE_POLICY = "update_policy"
    static let METHOD_UPDATE_ROOM_CURRENCY = "update_room_currency"
    static let METHOD_UPDATE_BOOKING_TYPE = "update_booking_type"
    static let METHOD_UPLOAD_ROOM_IMAGE = "room_image_upload"
    static let METHOD_PRE_ACCEPT = "pre_accept"
    static let METHOD_CANCEL_RESERVATION = "host_cancel_reservation"
    static let METHOD_DECLINE_RESERVATION = "decline"
    static let METHOD_LOGOUT = "logout"
    static let METHOD_UPDATE_AVAILABILITY_RULE = "update_availability_rule"
    static let METHOD_UPDATE_MIN_MAX_STAY = "update_minimum_maximum_stay"
    static let METHOD_DELETE_AVAILABILITY_RULE = "delete_availability_rule"

    //MARK:- LIST OF CONSTANTS
    static let USER_ACCESS_TOKEN = "access_token"
    static let CEO_FacebookAccessToken = "FBAcessToken"
    static let USER_FULL_NAME = "full_name"
    static let USER_FIRST_NAME = "first_name"
    static let USER_LAST_NAME = "last_name"
    static let USER_IMAGE_THUMB = "user_image"
    static let USER_DOB = "user_birthday"
    static let USER_FB_ID = "user_fbid"
    static let USER_CURRENCY = "user_currency"
    static let USER_CURRENCY_SYMBOL = "user_currency_symbol"
    static let USER_ID = "user_id"
    static let SPACE_ID = "space_id"
    static let RELOAD = "reload"
    static let RELOADEXPLORE = "reloadExplore"
    static let USER_CURRENCY_ORG = "user_currency_org"
    static let USER_CURRENCY_SYMBOL_ORG = "user_currency_symbol_org"
    static let USER_START_DATE = "user_start_date"
    static let USER_END_DATE = "user_end_date"
    static let USER_LONGITUDE = "user_longitude"
    static let USER_LATITUDE = "user_latitude"
    static let USER_LOCATION = "user_location"
}

class COMMON:NSObject{
    static let PROGRESSVIEW_TAG = 99999
    static let GLOBAL_FONT_SIZE = 30
    static let GLOBAL_TITLE_FONT_SIZE = 17
    func RADIANS(_ degree: Any) -> Double {
        degree as! Double / 180.0 * .pi
    }


    let ORANGEBACKGROUNDCOLOR = UIColor(red :252.0/255.0,green:100.0/255.0,blue:45.0/255.0,alpha:1.0)
    let GREENCOLOR = UIColor(red: 0.0 / 255.0, green: 134.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    let NAVYBLUECOLOR = UIColor(red: 9.0 / 255.0, green: 26.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    let BACKGROUNDCOLOR = UIColor(red: 0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    let SHOWROOMBACKGROUNDCOLOR = UIColor(red: 229 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)

    let IOS7 = Int(UIDevice.current.systemVersion.components(separatedBy: ".")[0]) ?? 0 >= 7


    let iPhone6 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 750, height: 1334).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero) : false
    let iPhone5 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero) : false
    let iPhone4 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 960).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero) : false
    
    func GETVALUE(_ keyname: Any) -> Any? {
        UserDefaults.standard.value(forKey: keyname as! String)
    }
    func SETVALUE(_ value: Any, _ keyname: Any) {
        UserDefaults.standard.setValue(value, forKey: keyname as! String)
    }


    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        UIColor(
            red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((rgbValue & 0xff00) >> 8)) / 255.0),
            blue: CGFloat((Float(rgbValue & 0xff)) / 255.0),
            alpha: 1.0)
    }
    
    let kBgQueue = DispatchQueue.global(qos: .default)

    static let APPSTOREURL = "https://itunes.apple.com/us/app//id11118758?ls=1&mt=8"
    static let APPSTOREURLFORABOUTPAGE = "itunes.apple.com/us/app//id1875958?ls=1&mt=8"
    static let APPSTOREAPPS = "itunes.apple.com/us/artist//id20457467"
    static let SYNCHRONISE = UserDefaults.standard.synchronize()
}


class webPageUrl:NSObject{
    static let URL_WHY_HOST = "why_host"
    static let URL_TERMS_OF_SERVICE = "terms_of_service"
    static let URL_HELPS_SUPPORT = "help"
    static let URL_BOOK_ROOM = "payments/book/"
    static let URL_PAY_ROOM = "pay_now"
    static let URL_CANCELATION_POLICY_FLEXIBLE = "home/cancellation_policies#flexible"
    static let URL_CANCELATION_POLICY_MODERATE = "home/cancellation_policies#moderate"
    static let URL_CANCELATION_POLICY_STRICT = "home/cancellation_policies#strict"
}

class Fonts:NSObject{
    static let CIRCULAR_BOLD = "CircularAirPro-Bold"
    static let CIRCULAR_LIGHT = "CircularAirPro-Light"
    static let CIRCULAR_BOOK = "CircularAirPro-Book"
    static let MAKENT_LOGO_FONT1 = "makent1"
    static let MAKENT_LOGO_FONT2 = "makent2"
    static let MAKENT_LOGO_FONT3 = "makent3"
    static let MAKENT_AMENITIES_FONT = "makent-amenities"
    static let IMAGE_INSETS = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 21)
}
