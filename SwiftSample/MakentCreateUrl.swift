/**
 * MakentCreateUrl.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit

class MakentCreateUrl: NSObject
{
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    func serializeURL(params : NSDictionary , methodName : NSString) -> NSString
    {
        if methodName.isEqual(to: APPURL.METHOD_LOGIN)
        {
            return self.createLoginUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_SIGNUP)
        {
            return self.createSignUpUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EMAIL_VALIDATION)
        {
            return self.createEmailValidation(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_FORGOT_PASSWORD)
        {
            return self.forgotPassword(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPLORE)
        {
            return self.createExploreUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPLORE_EXPERIENCE)
        {
            return self.createExperienceRoomUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRICE_BREAKDOWN) {
            return self.priceBreakDownUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOM_DETAIL)
        {
            return self.createRoomDetailUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_MAPS)
        {
            return self.createMapsListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_HOUSE_RULES)
        {
            return self.createHouseRulesUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_AMENITIES_LIST)
        {
            return self.createAmenitiesListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_REVIEW_LIST)
        {
            return self.createReviewListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CALENDAR_AVAILABEL)
        {
            return self.createRoomAvailableDatesUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOM_AVAILABLE_STATUS)
        {
            return self.createRoomAvailableStatusUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_COUNTRY_LIST)
        {
            return self.createCountryListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CURRENCY_LIST)
        {
            return self.createCurrencyListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CHANGE_CURRENCY)
        {
            return self.createChangeCurrencyUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRE_PAYMENT)
        {
            return self.createPrePaymentUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_VIEW_PROFILE) || methodName.isEqual(to: APPURL.METHOD_VIEW_OTHER_PROFILE)
        {
            return self.createViewProfileUrl(params: params, methodName:methodName)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EDIT_PROFILE)
        {
            return self.createEditProfileUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_TRIPS_TYPE)
        {
            return self.createTripsTypesUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_TRIPS_DETAILS)
        {
            return self.createTripsDetailUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CANCEL_PENDING_TRIP_BY_GUEST) || methodName.isEqual(to: APPURL.METHOD_GUEST_CANCEL_TRIP_AFTER_PAY)
        {
            return self.createCancelTripUrl(params: params, methodName: methodName)
        }
        else if methodName.isEqual(to: APPURL.METHOD_INBOX_RESERVATION)
        {
            return self.createInboxReservationsUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_CONVERSATION)
        {
            return self.createConversationListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_SEND_MESSAGE)
        {
            return self.createSendMessageUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_PAYOUT_DETAILS)
        {
            return self.createAddPayoutDetailUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_LOGOUT)
        {
            return self.createLogoutUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOM_PROPERTY_TYPE)
        {
            return self.createRoomPropertyType(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_NEW_ROOM)
        {
            return self.createAddNewRoomUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_LISTING)
        {
            return self.createAddNewListingUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_ROOM_PRICE)
        {
            return self.createAddRoomPriceUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ROOM_LOCATION)
        {
            return self.createUpdateRoomLocationUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_TITLE)
        {
            return self.createUpdateTitleUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CALANDER_ROOMS_LIST)
        {
            return self.createCalendarRoomsListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_BLOCK_DATES)
        {
            return self.createRoomBlockedDatesUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DISABLE_LISTING)
        {
            return self.createDisableListingUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOMS_BEDS_LIST)
        {
            return self.createRoomsBedsListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_SELECTED_AMENITIES)
        {
            return self.createSelectedAmenitiesUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ROOM_DESC) || methodName.isEqual(to: APPURL.METHOD_GET_ROOM_DESC)
        {
            return self.createUpdateRoomDescUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_LONG_TERM_PRICE)
        {
            return self.createUpdateLongTermPriceUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_HOUSE_RULES)
        {
            return self.createUpdateHouseRulesUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_ADDITIONAL_PRICE)//c
        {
            return self.createDeleteAdditionalDiscountUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ADDITIONAL_PRICE)//c
        {
            return self.createAddorUpdateAdditionalDiscountUrl(params: params)//c
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_AVAILABILITY_RULE)//c
        {
            return self.createAddorUpdateAvailabilityRuleUrl(params: params)//c
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_MIN_MAX_STAY)//c
        {
            return self.createAddorUpdateMinMaxRuleUrl(params: params)//c
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_AVAILABILITY_RULE)
        {
            return self.createDeleteAvailabilityiscountUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ADDITIONAL_PRICE)
        {
            return self.createAddorUpdateAdditionalDiscountUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_POLICY)
        {
            return self.createUpdatePolicyUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ROOM_CURRENCY)
        {
            return self.createUpdateRoomCurrencyUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_BOOKING_TYPE)
        {
            return self.createUpdateBookingTypeUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_REMOVE_ROOM_IMAGE)
        {
            return self.createRemoveRoomImageUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_RESERVATION)
        {
            return self.createReservationListUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRE_ACCEPT)
        {
            return self.createPreAcceptRequestUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CANCEL_RESERVATION)
        {
            return self.createCancelReservationUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DECLINE_RESERVATION)
        {
            return self.createDeclineReservationUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_PAYOUT_LIST)
        {
            return self.createGetPayoutUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_PAYOUT) || methodName.isEqual(to: APPURL.METHOD_MAKE_DEFAULT_PAYOUT)
        {
            return self.createMakeDefaultAndDeletePayoutUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CONTACT_HOST)
        {
            return self.createContactHostUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_TO_WISHLIST)
        {
            return self.createAddToWishlistUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_WISHLIST)
        {
            return self.createGetWishlistUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_PARTICULAR_WISHLIST)
        {
            return self.createGetParticularWishlistUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_WISHLIST)
        {
            return self.createDeleteWishlistUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CHANGE_PRIVACY_WISHLIST)
        {
            return self.createChangeWishlistUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRE_APPROVAL_OR_DECLINE)
        {
            return self.createPreApprovalOrDeclineUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_GUEST)
        {
            return self.createSaveGuestUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_REMOVE_GUEST)
        {
            return self.createRemoveGuestUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_STRIPE_PAYOUT)
        {
            return self.createGetPayoutPerferenceUrl(params: params)
        }
            //* Experience Start *//
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE_PRE_PAYMENT)
        {
            return self.createExpereiencePrePaymentUrl(params:params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE_ROOM_AVAILABLE_STATUS)
        {
            return self.createExpereienceDateAvailableUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE_CONTACTHOST)
        {
            return self.createExpereienceContactHostUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE)
        {
            return self.createExperienceType(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_HOST_EXPERIENCE_CATEGORY)
        {
            return self.createHostExperienceCategories(params: params)
        }
        //* Experience End *//
        return ""
    }


    //MARK: - ******** HOST CREATE URL *********

    //MARK: Get Property type
    func createRoomPropertyType(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ROOM_PROPERTY_TYPE,query) as NSString)
    }

    //MARK: ADD_NEW_ROOM
    func createAddNewRoomUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_type=%@",params["room_type"]  as! NSString))
        pairs.add(String(format:"property_type=%@",params["property_type"]  as! NSString))
        //        pairs.add(String(format:"room_location=%@",params["room_location"]  as! NSString))
        pairs.add(String(format:"latitude=%@",params["latitude"]  as! NSString))
        pairs.add(String(format:"longitude=%@",params["longitude"]  as! NSString))
        pairs.add(String(format:"max_guest=%@",params["max_guest"]  as! NSString))
        pairs.add(String(format:"bedrooms_count=%@",params["bedrooms_count"]  as! NSString))
        pairs.add(String(format:"beds_count=%@",params["beds_count"]  as! NSString))
        pairs.add(String(format:"bathrooms=%@",params["bathrooms"]  as! NSString))
        pairs.add(String(format:"bed_type=%@",params["bed_type"]  as! NSString))
        if let bedroom = params["bedroom_bed_details"] as? String{
            pairs.add("bedroom_bed_details=\(bedroom)")
        }
        if let commonRoom = params["common_room_bed_details"] as? String{
            pairs.add("common_room_bed_details=\(commonRoom)")
        }
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ADD_NEW_ROOM,query) as NSString)
    }

    //MARK: GET_LISTING - ALready
    func createAddNewListingUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"page=%@",params["page"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_GET_LISTING,query) as NSString)
    }

    //MARK: ADD_ROOM_PRICE
    func createAddRoomPriceUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"room_price=%@",params["room_price"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ADD_ROOM_PRICE,query) as NSString)
    }

    //MARK: SELECTED_AMENITIES
    func createSelectedAmenitiesUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"selected_amenities=%@",params["selected_amenities"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_SELECTED_AMENITIES,query) as NSString)
    }

    //MARK: UPDATE_ROOM_DESC
    func createUpdateRoomDescUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))

        if params["space"] != nil
        {
            pairs.add(String(format:"space=%@",(params["space"]  as! NSString)))
        }
        else if params["guest_access"] != nil
        {
            pairs.add(String(format:"guest_access=%@",(params["guest_access"]  as! NSString)))
        }
        else if params["interaction_guests"] != nil
        {
            pairs.add(String(format:"interaction_guests=%@",(params["interaction_guests"]  as! NSString)))
        }
        else if params["neighborhood_overview"] != nil
        {
            pairs.add(String(format:"neighborhood_overview=%@",(params["neighborhood_overview"]  as! NSString)))
        }
        else if params["getting_arround"] != nil
        {
            pairs.add(String(format:"getting_arround=%@",(params["getting_arround"]  as! NSString)))
        }
        else if params["notes"] != nil
        {
            pairs.add(String(format:"notes=%@",(params["notes"]  as! NSString)))
        }

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_ROOM_DESC,query) as NSString)
    }

    //MARK: UPDATE_LONG_TERM_PRICE
    func createUpdateLongTermPriceUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"weekly_price=%@",params["weekly_price"]  as! NSString))
        pairs.add(String(format:"monthly_price=%@",params["monthly_price"]  as! NSString))
        pairs.add(String(format:"cleaning_fee=%@",params["cleaning_fee"]  as! NSString))
        pairs.add(String(format:"additional_guests=%@",params["additional_guests"]  as! NSString))
        pairs.add(String(format:"for_each_guest=%@",params["for_each_guest"]  as! NSString))
        pairs.add(String(format:"security_deposit=%@",params["security_deposit"]  as! NSString))
        pairs.add(String(format:"weekend_pricing=%@",params["weekend_pricing"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_LONG_TERM_PRICE,query) as NSString)
    }
    //MARK: UPDATE_MIN_MAX_RULES
    func createAddorUpdateMinMaxRuleUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"minimum_stay=%@",params["minimum_stay"]  as! NSString))
        pairs.add(String(format:"maximum_stay=%@",params["maximum_stay"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_MIN_MAX_STAY,query) as NSString)
    }
    //MARK: UPDATE_AVAILABILITY_RULES
    func createAddorUpdateAvailabilityRuleUrl(params : NSDictionary) -> NSString//c
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"id=%@",params["id"]  as! NSString))
        pairs.add(String(format:"type=%@",params["type"]  as! NSString))
        pairs.add(String(format:"minimum_stay=%@",params["minimum_stay"]  as! NSString))
        pairs.add(String(format:"maximum_stay=%@",params["maximum_stay"]  as! NSString))
        pairs.add(String(format:"start_date=%@",params["start_date"]  as! NSString))
        pairs.add(String(format:"end_date=%@",params["end_date"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_AVAILABILITY_RULE,query) as NSString)
    }
    //MARK: UPDATE ADDITIONAL DISCOUNT
    func createAddorUpdateAdditionalDiscountUrl(params : NSDictionary) -> NSString//c
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"id=%@",params["id"]  as! NSString))
        pairs.add(String(format:"type=%@",params["type"]  as! NSString))
        pairs.add(String(format:"period=%@",params["period"]  as! NSString))
        pairs.add(String(format:"discount=%@",params["discount"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_ADDITIONAL_PRICE,query) as NSString)
    }
    //MARK: DELETE AVAILABILITY DISCOUNT
    func createDeleteAvailabilityiscountUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"id=%@",params["id"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_DELETE_AVAILABILITY_RULE,query) as NSString)
    }
    //MARK: DELETE ADDITIONAL DISCOUNT
    func createDeleteAdditionalDiscountUrl(params : NSDictionary) -> NSString//c
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"id=%@",params["id"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_DELETE_ADDITIONAL_PRICE,query) as NSString)
    }
    //MARK: UPDATE_HOUSE_RULES
    func createUpdateHouseRulesUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"house_rules=%@",params["house_rules"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))


        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_HOUSE_RULES,query) as NSString)
    }

    //MARK: UPDATE_POLICY
    func createUpdatePolicyUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"policy_type=%@",params["policy_type"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_POLICY,query) as NSString)
    }

    //MARK: UPDATE_ROOM_CURRENCY
    func createUpdateRoomCurrencyUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"currency_code=%@",params["currency_code"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_ROOM_CURRENCY,query) as NSString)
    }

    //MARK: UPDATE_BOOKING_TYPE
    func createUpdateBookingTypeUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"booking_type=%@",params["booking_type"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_BOOKING_TYPE,query) as NSString)
    }

    //MARK: REMOVE_ROOM_IMAGE
    func createRemoveRoomImageUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"image_id=%@",params["image_id"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_REMOVE_ROOM_IMAGE,query) as NSString)
    }


    //MARK: BLOCK_DATES
    func createRoomBlockedDatesUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"blocked_dates=%@",params["blocked_dates"]  as! NSString))
        pairs.add(String(format:"is_avaliable_selected=%@",params["is_avaliable_selected"]  as! NSString))
        pairs.add(String(format:"nightly_price=%@",params["nightly_price"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_BLOCK_DATES,query) as NSString)
    }

    //MARK: DISABLE_LISTING
    func createDisableListingUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_DISABLE_LISTING,query) as NSString)
    }

    //MARK: ROOMS_BEDS_LIST
    func createRoomsBedsListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"person_capacity=%@",params["person_capacity"]  as! NSString))
//        pairs.add(String(format:"bedrooms=%@",params["bedrooms"]  as! NSString))
//        pairs.add(String(format:"beds=%@",params["beds"]  as! NSString))
        pairs.add(String(format:"bathrooms=%@",params["bathrooms"]  as! NSString))
        pairs.add(String(format:"room_type=%@",params["room_type"]  as! NSString))
        pairs.add(String(format:"property_type=%@",params["property_type"]  as! NSString))
//        pairs.add(String(format:"bed_type=%@",params["bed_type"]  as! NSString))


        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ROOMS_BEDS_LIST,query) as NSString)
    }

    //MARK: UPDATE_ROOM_LOCATION
    func createUpdateRoomLocationUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"latitude=%@",params["latitude"]  as! NSString))
        pairs.add(String(format:"longitude=%@",params["longitude"]  as! NSString))
        pairs.add(String(format:"is_success=%@",params["is_success"]  as! NSString))

        if (params["is_success"]  as! String == "Yes")
        {
            pairs.add(String(format:"street_name=%@",YSSupport.escapedValue((params["street_name"] as! String))))
            pairs.add(String(format:"street_address=%@",YSSupport.escapedValue((params["street_address"] as! String))))
            pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! String))))
            pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! String))))
            pairs.add(String(format:"zip=%@",YSSupport.escapedValue((params["zip"]  as! String))))
            pairs.add(String(format:"country=%@",YSSupport.escapedValue((params["country"]  as! String))))
        }
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_ROOM_LOCATION,query) as NSString)
    }

    //MARK: METHOD_VALIDATE_LOCATION
    func createValidateLocationUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"latitude=%@",params["latitude"]  as! NSString))
        pairs.add(String(format:"longitude=%@",params["longitude"]  as! NSString))
        pairs.add(String(format:"street_name=%@",YSSupport.escapedValue((params["street_name"] as! String))))
        pairs.add(String(format:"street_address=%@",YSSupport.escapedValue((params["street_address"] as! String))))
        pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! String))))
        pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! String))))
        pairs.add(String(format:"zip=%@",YSSupport.escapedValue((params["zip"]  as! String))))
        pairs.add(String(format:"country=%@",YSSupport.escapedValue((params["country"]  as! String))))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_VALIDATE_LOCATION,query) as NSString)
    }

    //MARK: UPDATE_TITLE
    func createUpdateTitleUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))

        if params["room_title"] != nil
        {
            pairs.add(String(format:"room_title=%@",(params["room_title"]  as! NSString)))
        }
        else if params["room_description"] != nil
        {
            pairs.add(String(format:"room_description=%@",(params["room_description"]  as! NSString)))
        }
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_UPDATE_TITLE,query) as NSString)
    }

    //MARK: CALANDER_ROOMS_LIST
    func createCalendarRoomsListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CALANDER_ROOMS_LIST,query) as NSString)
    }

    //MARK: ******** HOST CREATE URL END *********


    //MARK: - GET TRIPS TYPES
    func createTripsTypesUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_TRIPS_TYPE,query) as NSString)


    }

    //MARK: GET TRIPS DETAILS
    func createTripsDetailUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"booking_type=%@",params["booking_type"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_TRIPS_DETAILS,query) as NSString)
    }

    //MARK: CANCEL_TRIP
    func createCancelTripUrl(params : NSDictionary, methodName : NSString) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))
        pairs.add(String(format:"cancel_message=%@",params["cancel_message"]  as! NSString))
        pairs.add(String(format:"cancel_reason=%@",params["cancel_reason"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")


        if methodName.isEqual(to: APPURL.METHOD_CANCEL_PENDING_TRIP_BY_GUEST)
        {
            return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CANCEL_PENDING_TRIP_BY_GUEST,query) as NSString)
        }
        else
        {
            return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_GUEST_CANCEL_TRIP_AFTER_PAY,query) as NSString)
        }
    }

    //MARK: ADD PAYOUT DETAILS
    func createAddPayoutDetailUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"payout_method=%@",params["payout_method"]  as! NSString))
        let payout_method = params["payout_method"] as! String
        if payout_method != "stripe"{
            pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
            pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
            pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
            pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
            pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))
            pairs.add(String(format:"country=%@",YSSupport.escapedValue((params["country"]  as! NSString) as String?)))
            pairs.add(String(format:"paypal_email=%@",params["paypal_email"]  as! NSString))
        }
        else{
            pairs.add(String(format:"country=%@",YSSupport.escapedValue((params["country"]  as! NSString) as String?)))
            let country = params["country"] as! String
            if country == "Australia" {

                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))

                pairs.add(String(format:"bsb=%@",YSSupport.escapedValue((params["bsb"]  as! NSString) as String?)))
                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))

                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else if country == "Canada" {
                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))

                pairs.add(String(format:"transit_number=%@",YSSupport.escapedValue((params["transit_number"]  as! NSString) as String?)))
                pairs.add(String(format:"institution_number=%@",YSSupport.escapedValue((params["institution_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))

                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))

                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else if country == "New Zealand" {
                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))

                pairs.add(String(format:"routing_number=%@",YSSupport.escapedValue((params["routing_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))

                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else if country == "United States" {
                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))

                pairs.add(String(format:"routing_number=%@",YSSupport.escapedValue((params["routing_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))

                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else if country == "Singapore" {
                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))

                pairs.add(String(format:"bank_code=%@",YSSupport.escapedValue((params["bank_code"]  as! NSString) as String?)))

                pairs.add(String(format:"branch_code=%@",YSSupport.escapedValue((params["branch_code"]  as! NSString) as String?)))

                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))

                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))

                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else if country == "United Kingdom" {
                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))

                pairs.add(String(format:"sort_code=%@",YSSupport.escapedValue((params["sort_code"]  as! NSString) as String?)))
                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))

                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))

                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else if country == "Hong Kong" {
                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))

                pairs.add(String(format:"clearing_code=%@",YSSupport.escapedValue((params["clearing_code"]  as! NSString) as String?)))

                pairs.add(String(format:"branch_code=%@",YSSupport.escapedValue((params["branch_code"]  as! NSString) as String?)))
                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))
                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else if country == "Japan" {
                pairs.add(String(format:"currency=%@",YSSupport.escapedValue((params["currency"]  as! NSString) as String?)))
                pairs.add(String(format:"clearing_code=%@",YSSupport.escapedValue((params["clearing_code"]  as! NSString) as String?)))

                pairs.add(String(format:"branch_code=%@",YSSupport.escapedValue((params["branch_code"]  as! NSString) as String?)))
                pairs.add(String(format:"account_number=%@",YSSupport.escapedValue((params["account_number"]  as! NSString) as String?)))
                pairs.add(String(format:"account_holder_name=%@",YSSupport.escapedValue((params["account_holder_name"]  as! NSString) as String?)))

                pairs.add(String(format:"address1=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"address2=%@",YSSupport.escapedValue((params["address2"]  as! NSString) as String?)))
                pairs.add(String(format:"city=%@",YSSupport.escapedValue((params["city"]  as! NSString) as String?)))
                pairs.add(String(format:"state=%@",YSSupport.escapedValue((params["state"]  as! NSString) as String?)))
                pairs.add(String(format:"postal_code=%@",YSSupport.escapedValue((params["postal_code"]  as! NSString) as String?)))

            }
            else{

            }


        }
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ADD_PAYOUT_DETAILS,query) as NSString)
    }

    //MARK: GET INBOX RESERVATION
    func createInboxReservationsUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"type=%@",params["type"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_INBOX_RESERVATION,query) as NSString)
    }

    //MARK: GET RESERVATION LIST
    func createReservationListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_GET_RESERVATION,query) as NSString)
    }

    //MARK: PRE_ACCEPT
    func createPreAcceptRequestUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))
        pairs.add(String(format:"message_to_guest=%@",params["message_to_guest"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_PRE_ACCEPT,query) as NSString)
    }

    //MARK: METHOD_CANCEL_RESERVATION
    func createCancelReservationUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))
        pairs.add(String(format:"cancel_reason=%@",params["cancel_reason"]  as! NSString))
        pairs.add(String(format:"cancel_message=%@",params["cancel_message"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CANCEL_RESERVATION,query) as NSString)
    }

    //MARK: METHOD_DECLINE_RESERVATION
    func createDeclineReservationUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))
        pairs.add(String(format:"decline_reason=%@",params["decline_reason"]  as! NSString))
        pairs.add(String(format:"decline_message=%@",params["decline_message"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_DECLINE_RESERVATION,query) as NSString)
    }

    //MARK: GET_CONVERSATION
    func createConversationListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"host_user_id=%@",params["host_user_id"]  as! NSString))
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))

        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_GET_CONVERSATION,query) as NSString)
    }


    //MARK: SEND MESSAGE
    func createSendMessageUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"message=%@",params["message"]  as! NSString))
        pairs.add(String(format:"host_user_id=%@",params["host_user_id"]  as! NSString))
        pairs.add(String(format:"message_type=%@",params["message_type"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"list_type=%@",params["list_type"]  as! NSString))
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")

        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_SEND_MESSAGE,query) as NSString)
    }


    //MARK: LOGIN PAGE
    func createLoginUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"email=%@",params["email"]  as! NSString))
        pairs.add(String(format:"password=%@",params["password"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_LOGIN,query) as NSString)
    }

    //MARK: SIGNUP PAGE
    func createSignUpUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")

        let firstName = (params["first_name"]  as! NSString).replacingOccurrences(of: "#", with: "%23")
        let lastName = (params["last_name"]  as? NSString)?.replacingOccurrences(of: "#", with: "%23") ?? ""

        pairs.add(String(format:"email=%@",params["email"]  as! NSString))
        pairs.add(String(format:"first_name=%@",firstName))
        pairs.add(String(format:"last_name=%@",lastName))
        pairs.add(String(format:"password=%@",params["password"]  as! NSString))
        pairs.add(String(format:"dob=%@",params["dob"]  as! NSString))
        //        pairs.add(String(format:"ip_address=%@",params["ip_address"]  as! NSString))

        if params["gpid"] != nil
        {
            pairs.add(String(format:"gpid=%@",params["gpid"]  as! NSString))
        }
        else if params["auth_id"] != nil
        {
            pairs.add(String(format:"auth_id=%@",params["auth_id"]  as! NSString))
        }
        
        if params["auth_type"] != nil
        {
            pairs.add(String(format:"auth_type=%@",params["auth_type"]  as! NSString))
        }
        

        if params["profile_pic"] != nil
        {
            let strProfileUrl = YSSupport.escapedValue((params["profile_pic"]  as! NSString) as String?)
            pairs.add(String(format:"profile_pic=%@",(params["profile_pic"]  as! NSString)))
        }

        let query = pairs.componentsJoined(by: "&")
        return ((String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_SIGNUP,query) as NSString).replacingOccurrences(of: " ", with: "%20") as NSString)
    }

    //MARK: VALIDATE EMAIL
    func createEmailValidation(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"email=%@",params["email"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_EMAILVALIDATION,query) as NSString)
    }

    //MARK: FORGOT PASSWORD PAGE
    func forgotPassword(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"email=%@",params["email"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_FORGOTPASSWORD,query) as NSString)
    }
    //MARK: EXPLORE PAGE
    func createExperienceRoomUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        pairs.add(String(format:"page=%@",params["page_number"]  as! NSString))
        if params["latitude"] != nil || params["longitude"] != nil
        {
            pairs.add(String(format:"latitude=%@",params["latitude"]  as! NSString))
            pairs.add(String(format:"longitude=%@",params["longitude"]  as! NSString))
        }
        if params["location"] != nil
        {
            pairs.add(String(format:"location=%@",params["location"]  as! NSString))
        }
        if params["guests"] != nil
        {
            pairs.add(String(format:"guests=%@",params["guests"]  as! NSString))
        }
        if params["category"] != nil
        {
            pairs.add(String(format:"category=%@",params["category"]  as! NSString))
        }
        if params["checkin"] != nil
        {
            pairs.add(String(format:"checkin=%@",params["checkin"]  as! NSString))
        }
        if params["checkout"] != nil
        {
            pairs.add(String(format:"checkout=%@",params["checkout"]  as! NSString))
        }
        let query = pairs.componentsJoined(by: "&")
        let url = (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_EXPLORE_EXPERIENCE,query) as NSString)
        print("\nÅ experiance : \(url)")
        return url
    }
    //MARK: EXPLORE PAGE
    func createExploreUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }


        pairs.add(String(format:"page=%@",params["page_number"]  as! NSString))

        if params["latitude"] != nil || params["longitude"] != nil
        {
            pairs.add(String(format:"latitude=%@",params["latitude"]  as! NSString))
            pairs.add(String(format:"longitude=%@",params["longitude"]  as! NSString))
        }
        if params["location"] != nil
        {
            pairs.add(String(format:"location=%@",params["location"]  as! NSString))
        }

        if params["guests"] != nil
        {
            pairs.add(String(format:"guests=%@",params["guests"]  as! NSString))
        }

        if params["checkin"] != nil || params["checkout"] != nil
        {
            pairs.add(String(format:"checkin=%@",params["checkin"]  as! NSString))
            pairs.add(String(format:"checkout=%@",params["checkout"]  as! NSString))
        }

        if params["instant_book"] != nil
        {
            pairs.add(String(format:"instant_book=%@",params["instant_book"]  as! NSString))
        }

        if params["min_price"] != nil || params["max_price"] != nil
        {
            pairs.add(String(format:"min_price=%@",params["min_price"]  as! NSString))
            pairs.add(String(format:"max_price=%@",params["max_price"]  as! NSString))
        }

        if params["beds"] != nil
        {
            pairs.add(String(format:"beds=%@",params["beds"]  as! NSString))
        }

        if params["bedrooms"] != nil
        {
            pairs.add(String(format:"bedrooms=%@",params["bedrooms"]  as! NSString))
        }

        if params["bathrooms"] != nil
        {
            pairs.add(String(format:"bathrooms=%@",params["bathrooms"]  as! NSString))
        }

        if params["amenities"] != nil
        {
            pairs.add(String(format:"amenities=%@",params["amenities"]  as! NSString))
        }

        if params["room_type"] != nil
        {
            pairs.add(String(format:"room_type=%@",params["room_type"]  as! NSString))
        }

        let query = pairs.componentsJoined(by: "&")
        let url = (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_EXPLORE,query) as NSString)
        print("Å Explore : \(url)")
        return url
    }

    //MARK: EXPLORE EXPERIENCE PAGE
    func createExploreExperienceUrl(params: [String: Any]) -> String {
        var pairs =  [String]()
        if let accessToken = params["token"] {
            pairs.append("token=\(accessToken)")
        }
        if let pageNumber = params["page_number"] {
            pairs.append("page=\(pageNumber)")
        }
        if let latitude = params["latitude"], let longitude = params["longitude"] {
            pairs.append("latitude:\(latitude)")
            pairs.append("longitude:\(longitude)")
        }
        if let location = params["location"] {
            pairs.append("location=\(location)")
        }
        if let guests = params["guests"] {
            pairs.append("guests=\(guests)")
        }
        if let checkin = params["checkin"], let checkout = params["checkout"] {
            pairs.append("checkin=\(checkin)")
            pairs.append("checkout=\(checkout)")
        }
        if let instantBook = params["instant_book"] {
            pairs.append("instant_book=\(instantBook)")
        }
        if let minPrice = params["min_price"], let maxPrice = params["max_price"] {
            pairs.append("min_price=\(minPrice)")
            pairs.append("max_price=\(maxPrice)")
        }
        if let beds = params["beds"] {
            pairs.append("beds=\(beds)")
        }
        if let bedrooms = params["bedrooms"] {
            pairs.append("bedrooms=\(bedrooms)")
        }
        if let bathrooms = params["bathrooms"] {
            pairs.append("bathrooms=\(bathrooms)")
        }
        if let amenities = params["amenities"] {
            pairs.append("amenities=\(amenities)")
        }
        if let roomType = params["room_type"] {
            pairs.append("room_type=\(roomType)")
        }
        if let filter = params["category"]{
            pairs.append("category=\(filter)")
        }
        let query = pairs.joined(separator: "&")
        return "\(k_APIServerUrl)\(APPURL.API_EXPLORE_EXPERIENCE)?\(query)"
    }

    //MARK: ROOM DETAILS PAGE
    func createRoomDetailUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil
        {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ROOM_DETAIL,query) as NSString)
    }

    //MARK: MAPS LIST
    func createMapsListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_MAPS_LIST,query) as NSString)
    }


    //MARK: HOUSE RULES PAGE
    func createHouseRulesUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_HOUSE_RULES,query) as NSString)
    }

    //MARK: AMENITIES LIST
    func createAmenitiesListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_AMENITIES_LIST,query) as NSString)
    }

    //MARK: REVIEW LIST PAGE
    func createReviewListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil
        {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        pairs.add(String(format:"space_id=%@",params["space_id"]  as! NSString))
        pairs.add(String(format:"page=%@",params["page"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_REVIEW_LIST,query) as NSString)
    }

    //MARK: CHECK ROOM AVAILABLE DATES API
    func createRoomAvailableDatesUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CALENDAR_AVAILABEL,query) as NSString)
    }

    //MARK: CHECK ROOM AVAILABLE STATUS API
    func createRoomAvailableStatusUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil
        {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        pairs.add(String(format:"start_date=%@",params["start_date"]  as! NSString))
        pairs.add(String(format:"end_date=%@",params["end_date"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"total_guest=%@",params["total_guest"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ROOM_AVAILABLE_STATUS,query) as NSString)
    }


    //MARK: CURRENCY LIST PAGE
    func createCountryListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_COUNTRY_LIST,query) as NSString)
    }


    //MARK: CURRENCY LIST PAGE
    func createCurrencyListUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CURRENCY_LIST,query) as NSString)
    }

    //MARK: CHANGE CURRENCY TYPE
    func createChangeCurrencyUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"currency_code=%@",params["currency_code"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CHANGE_CURRENCY,query) as NSString)
    }

    //MARK: CHANGE CURRENCY TYPE
    func createPrePaymentUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
        pairs.add(String(format:"start_date=%@",params["start_date"]  as! NSString))
        pairs.add(String(format:"end_date=%@",params["end_date"]  as! NSString))
        pairs.add(String(format:"total_guest=%@",params["total_guest"]  as! NSString))
        print(pairs.add(String(format:"total_guest=%@",params["total_guest"]  as! NSString)))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_PRE_PAYMENT,query) as NSString)
    }

    //MARK: VIEW PROFILE PAGE
    func createViewProfileUrl(params : NSDictionary, methodName:NSString) -> NSString {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        if params["other_user_id"] != nil
        {
            pairs.add(String(format:"other_user_id=%@",params["other_user_id"]  as! NSString))
        }
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,(methodName.isEqual(to: APPURL.METHOD_VIEW_OTHER_PROFILE)) ? APPURL.API_VIEW_OTHER_PROFILE : APPURL.API_VIEW_PROFILE,query) as NSString)
    }

    //MARK: METHOD_GET_PAYOUT_LIST
    func createGetPayoutUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_GET_PAYOUT_LIST,query) as NSString)
    }

    //MARK: METHOD_CONTACT_HOST
    func createContactHostUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"check_in_date=%@",params["check_in_date"]  as! NSString))
        pairs.add(String(format:"check_out_date=%@",params["check_out_date"]  as! NSString))
        pairs.add(String(format:"no_of_guest=%@",params["no_of_guest"]  as! NSString))
        pairs.add(String(format:"message_to_host=%@",params["message_to_host"]  as! NSString))
        pairs.add(String(format:"room_id=%@",params["room_id"]  as! NSString))
         pairs.add(String(format:"list_type=%@",params["list_type"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CONTACT_HOST,query) as NSString)
    }


    //MARK: METHOD_ADD_TO_WISHLIST
    func createAddToWishlistUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        print("Params",params)
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        if params["space_id"] != nil
        {
        pairs.add(String(format:"space_id=%@",params["space_id"]  as! NSString))
        }
        pairs.add(String(format:"list_type=%@",params["list_type"]  as! NSString))
        if params["list_name"] != nil
        {
            /*
             if let name = params["list_name"] as? String{
                        //.replacingOccurrences(of: "%20", with: " ")
                            pairs.add(String(format:"list_name=%@",name.replacingOccurrences(of: "%20", with: " ")  as! NSString))
                        }
             */
            //.replacingOccurrences(of: "%20", with: " ")
            pairs.add(String(format:"list_name=%@",params["list_name"]  as! NSString))
        }
        if params["list_id"] != nil
        {
            pairs.add(String(format:"list_id=%@",params["list_id"]  as! NSString))
        }
        pairs.add(String(format:"privacy_settings=%@",params["privacy_settings"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ADD_TO_WISHLIST,query) as NSString)
    }

    //MARK: METHOD_CHANGE_PRIVACY_WISHLIST  / CHANGE LIST NAME
    func createChangeWishlistUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"list_id=%@",params["list_id"]  as! NSString))
        pairs.add(String(format:"list_type=%@",params["list_type"]  as! NSString))
        if params["list_name"] != nil
        {
            pairs.add(String(format:"list_name=%@",params["list_name"]  as! NSString))
        }
        if params["privacy_type"] != nil
        {
            pairs.add(String(format:"privacy_type=%@",params["privacy_type"]  as! NSString))
        }
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_CHANGE_PRIVACY_WISHLIST,query) as NSString)
    }


    //MARK: METHOD_PRE_APPROVAL_OR_DECLINE
    func createPreApprovalOrDeclineUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))
        pairs.add(String(format:"template=%@",params["template"]  as! NSString))
        pairs.add(String(format:"message=%@",params["message"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_PRE_APPROVAL_OR_DECLINE,query) as NSString)
    }
    //MARK: METHOD_ADD_PAYOUT_PERFERENCE
    func createGetPayoutPerferenceUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_ADD_STRIPE_PAYOUT,query) as NSString)
    }
    

   

    //MARK: METHOD_GET_WISHLIST
    func createGetWishlistUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_GET_WISHLIST,query) as NSString)
    }

    //MARK: METHOD_GET_PARTICULAR_WISHLIST
    func createGetParticularWishlistUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"list_id=%@",params["list_id"]  as! NSString))
        pairs.add(String(format:"list_type=%@",params["list_type"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_GET_PARTICULAR_WISHLIST,query) as NSString)
    }

    //MARK: METHOD_DELETE_WISHLIST
    func createDeleteWishlistUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["space_id"] != nil
        {
            pairs.add(String(format:"space_id=%@",params["space_id"]  as! NSString))
        }
        if params["list_id"] != nil
        {
            pairs.add(String(format:"list_id=%@",params["list_id"]  as! NSString))
        }
        if params["list_type"] != nil
        {
            pairs.add(String(format:"list_type=%@",params["list_type"]  as! NSString))
        }
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_DELETE_WISHLIST,query) as NSString)
    }

    //MARK: METHOD_GET_PAYOUT_LIST
    func createMakeDefaultAndDeletePayoutUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"type=%@",params["type"]  as! NSString))
        pairs.add(String(format:"payout_id=%@",params["payout_id"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_MAKE_DEFAULT_DELETE_PAYOUT,query) as NSString)
    }

    //MARK: EDIT PROFILE PAGE
    func createEditProfileUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        if params["user_thumb_url"] != nil
        {
            pairs.add(String(format:"user_thumb_url=%@",params["user_thumb_url"]  as! NSString))
        }
        pairs.add(String(format:"dob=%@",YSSupport.escapedValue((params["dob"]  as! NSString) as String?)))
        pairs.add(String(format:"first_name=%@",YSSupport.escapedValue((params["first_name"]  as! NSString) as String?)))
        pairs.add(String(format:"last_name=%@",YSSupport.escapedValue((params["last_name"]  as! NSString) as String?)))
        pairs.add(String(format:"school=%@",YSSupport.escapedValue((params["school"]  as! NSString) as String?)))
        pairs.add(String(format:"about_me=%@",YSSupport.escapedValue((params["about_me"]  as! NSString) as String?)))
        pairs.add(String(format:"work=%@",YSSupport.escapedValue((params["work"]  as! NSString) as String?)))
        pairs.add(String(format:"user_location=%@",YSSupport.escapedValue((params["user_location"]  as! NSString) as String?)))
        pairs.add(String(format:"gender=%@",YSSupport.escapedValue((params["gender"]  as! NSString) as String?)))
        pairs.add(String(format:"email=%@",params["email"]  as! NSString))
        pairs.add(String(format:"phone=%@",YSSupport.escapedValue((params["phone"]  as! NSString) as String?)))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_EDIT_PROFILE,query) as NSString)
    }

    //MARK: LOGOUT
    func createLogoutUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_LOGOUT,query) as NSString)
    }

    func priceBreakDownUrl(params: NSDictionary) -> NSString{
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"reservation_id=%@",params["reservation_id"]  as! NSString))
        pairs.add(String(format:"user_type=%@",params["user_type"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.METHOD_PRICE_BREAKDOWN,query) as NSString)
    }

    func createSaveGuestUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.METHOD_ADD_GUEST,query) as NSString)
    }
    func createRemoveGuestUrl(params : NSDictionary) -> NSString
    {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.METHOD_REMOVE_GUEST,query) as NSString)
    }
     //* Experience Start *//
    func createExperienceType(params: NSDictionary) -> NSString {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"host_experience_id=%d",params["host_experience_id"] as! Int))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_EXPERIENCE_ROOM_DETAILS,query) as NSString)
    }
    
    func createHostExperienceCategories(params: NSDictionary) -> NSString {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_HOST_EXPERIENCE_CATEGORY,query) as NSString)
    }
    
    func createExpereiencePrePaymentUrl(params: NSDictionary) -> NSString {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"host_experience_id=%d",params["host_experience_id"]  as! Int))
        pairs.add(String(format:"scheduled_id=%@",params["scheduled_id"]  as! NSString))
        pairs.add(String(format:"guest_details=%@",params["guest_details"]  as! NSString)) //as! [[String:String]]))
        pairs.add(String(format:"date=%@",params["date"]  as! String))
        //        params["guest_details"]
        pairs.add(String(format:"guest_details=%@",params["guest_details"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_EXPERIENCE_PRE_PAYMENT,query) as NSString)
    }
    
    func createExpereienceDateAvailableUrl(params: NSDictionary) -> NSString {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        pairs.add(String(format:"host_experience_id=%@",params["host_experience_id"]  as! NSString))
        pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        pairs.add(String(format:"date=%@",params["date"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        return (String(format:"%@%@?%@",k_APIServerUrl,APPURL.API_EXPERIENCE_ROOM_AVAILABLE_STATUS,query) as NSString)
    }
    
    func createExpereienceContactHostUrl(params: NSDictionary) -> NSString {
        let pairs : NSMutableArray =  []
        pairs.add("language=\(Language.getCurrentLanguage().rawValue)")
        if params["token"] != nil {
            pairs.add(String(format:"token=%@",params["token"]  as! NSString))
        }
        pairs.add(String(format:"host_experience_id=%@",params["host_experience_id"]  as! NSString))
        pairs.add(String(format:"message=%@",params["message"]  as! NSString))
        pairs.add(String(format:"list_type=%@",params["list_type"]  as! NSString))
        let query = pairs.componentsJoined(by: "&")
        
        return (String(format:"%@%@/contact_host?%@",k_APIServerUrl,APPURL.API_EXPERIENCE_CONTACT_HOST,query) as NSString)
    }
     //* Experience End *//
}
