/**
 * MakentSeparateParam.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit

class MakentSeparateParam: NSObject {
    
    static let paramInstance = MakentSeparateParam()

    func separate(params : NSDictionary , methodName : NSString) -> Any
    {
        print(params)
        if methodName.isEqual(to: APPURL.METHOD_LOGIN)
        {
            return self.separateParamForLogin(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_SIGNUP)
        {
            return self.separateParamForLogin(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRICE_BREAKDOWN){
            return self.separateParamForBreakDown(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EMAIL_VALIDATION)
        {
            return self.separateParamForEmailValidation(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_FORGOT_PASSWORD)
        {
            return self.separateParamForForgotPassword(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPLORE)
        {
            return self.separateParamForExploreList(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPLORE_EXPERIENCE)
        {
            return self.separateParamForExperienceList(params: params)
        }
//        else if methodName.isEqual(to: APPURL.METHOD_EXPLORE_EXPERIENCE) {
//            if let parameters = params as? [String: Any] {
//                return self.separateParamsForExploreExperience(params: parameters)
//            }
//        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOM_DETAIL)
        {
            return self.separateParamForRoomDetail(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_MAPS)
        {
            return self.separateParamForMapsList(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_HOUSE_RULES)
        {
            return self.separateParamForHouseRules(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_AMENITIES_LIST)
        {
            return self.separateParamForAmenitiesList(params: params)
        }

        else if methodName.isEqual(to: APPURL.METHOD_REVIEW_LIST)
        {
            return self.separateParamForReviewsList(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CALENDAR_AVAILABEL)
        {
            return self.separateParamForRoomAvailableDatesUrl(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOM_AVAILABLE_STATUS)
        {
            return self.separateParamForRoomAvailableStatusUrl(params: params)
        }
        
        else if methodName.isEqual(to: APPURL.METHOD_COUNTRY_LIST)
        {
            return self.separateParamForCountryList(params: params)
        }
//        else if methodName.isEqual(to: APPURL.METHOD_CURRENCY_LIST)
//        {
//            return self.separateParamForCurrencyList(params: params)
//        }
        else if methodName.isEqual(to: APPURL.METHOD_CHANGE_CURRENCY)
        {
            return self.separateParamForChangeCurrency(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRE_PAYMENT)
        {
            return self.separateParamForChangePrePayment(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GOOGLE_PLACE)
        {
            return self.separateParamForGooglePlaceSearch(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_VIEW_PROFILE) || methodName.isEqual(to: APPURL.METHOD_VIEW_OTHER_PROFILE)
        {
            return self.separateParamForViewProfile(params: params, method: methodName)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EDIT_PROFILE)
        {
            return self.separateParamForEditProfile(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_TRIPS_TYPE)
        {
            return self.separateParamForTripsTypes(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_TRIPS_DETAILS)
        {
            return self.separateParamForTripsDetails(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GUEST_CANCEL_TRIP_AFTER_PAY) || methodName.isEqual(to: APPURL.METHOD_CANCEL_PENDING_TRIP_BY_GUEST)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_INBOX_RESERVATION)
        {
            return self.separateParamForInboxReservation(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_CONVERSATION)
        {
            return self.separateParamForConversationList(params: params as! JSONS)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_RESERVATION)
        {
            return self.separateParamForReservationList(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_SEND_MESSAGE)
        {
            return self.separateParamForSendMessage(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_PAYOUT_DETAILS)
        {
            return self.separateParamForAddPayout(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPLOAD_PROFILE_IMAGE)
        {
            return self.separateParamForUploadProfileImage(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_LOGOUT)
        {
            return self.separateParamForLogout(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOM_PROPERTY_TYPE)
        {
            return self.separateParamForRoomPropertyType(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_NEW_ROOM)
        {
            return self.separateParamForAddNewRoom(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_LISTING)
        {
            return self.separateParamForAddNewListing(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_ROOM_PRICE)
        {
            return self.separateParamForAddRoomPrice(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ROOM_LOCATION)
        {
            return self.separateParamForUpdateRoomLocation(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_TITLE)
        {
            return self.separateParamForUpdateTitle(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CALANDER_ROOMS_LIST)
        {
            return self.separateParamForAddNewListing(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_BLOCK_DATES)
        {
            return self.separateParamForRoomBlockedDates(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DISABLE_LISTING)
        {
            return self.separateParamForDisableListing(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ROOMS_BEDS_LIST)
        {
            return self.separateParamForRoomsBedsList(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_SELECTED_AMENITIES)
        {
            return self.separateParamForSelectedAmenities(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ROOM_DESC) || methodName.isEqual(to: APPURL.METHOD_GET_ROOM_DESC)
        {
            return self.separateParamForUpdateRoomDesc(params: params, methodName: methodName)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_LONG_TERM_PRICE)
        {
            return self.separateParamForUpdateLongTermPrice(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_HOUSE_RULES)
        {
            return self.separateParamForUpdateHouseRules(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_ADDITIONAL_PRICE)
        {
            return self.separateParamForDeleteAdditionalPrice(params: params)
        }

        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ADDITIONAL_PRICE)
        {
            return self.separateParamForDeleteAdditionalPrice(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_AVAILABILITY_RULE)
        {
            return self.separateParamForDeleteAvailabilityRule(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_AVAILABILITY_RULE)
        {
            return self.separateParamForUpdateAvailabilityPrice(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_MIN_MAX_STAY)
        {
            return self.separateParamForUpdateLongTermPrice(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_POLICY)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_ROOM_CURRENCY)
        {
            return self.separateParamForCurrencyChangesModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_UPDATE_BOOKING_TYPE)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_REMOVE_ROOM_IMAGE)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CANCEL_RESERVATION)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DECLINE_RESERVATION)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRE_ACCEPT)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_PAYOUT_LIST)
        {
            return self.separateParamForGetPayout(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_PAYOUT) || methodName.isEqual(to: APPURL.METHOD_MAKE_DEFAULT_PAYOUT)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CONTACT_HOST)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_TO_WISHLIST)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_WISHLIST)
        {
            return self.separateParamForGetWishlist(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_GET_PARTICULAR_WISHLIST)
        {
            return self.separateParamForExploreList(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_DELETE_WISHLIST)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_CHANGE_PRIVACY_WISHLIST)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_PRE_APPROVAL_OR_DECLINE)
        {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_ADD_STRIPE_PAYOUT)
        {
            return self.separateParamForStripeType(params: params) // MOUNIKA
        }
     //* Experience Start *//
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE) {
            return self.separateParamForExperienceDetailModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_HOST_EXPERIENCE_CATEGORY) {
            return self.separateParamForHostExperienceCategoryModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE_PRE_PAYMENT) {
            return self.separateParamForExperiencePrePayment(params: params as! [String : Any])
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE_CONTACTHOST) {
            return self.separateParamForGeneralModel(params: params)
        }
        else if methodName.isEqual(to: APPURL.METHOD_EXPERIENCE_ROOM_AVAILABLE_STATUS) {
            return self.separateParamForExperienceRoomAvailableStatusUrl(params: params)
        }
         //* Experience End *//
        return ""
    }

    //MARK: ************ SEPARATE PARAMS FOR HOST ************

    func separateParamForStripeType(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                if params["country_list"] != nil
                {
                    let arrCountryListedData = params["country_list"] as! NSArray
                    if arrCountryListedData.count > 0
                    {
                        generalModel.arrTemp1 = NSMutableArray()
                        for i in 0 ..< arrCountryListedData.count
                        {
                            generalModel.arrTemp1.addObjects(from: ([PayoutPerferenceModel().initiateListingData(responseDict: arrCountryListedData[i] as! NSDictionary)]))
                        }
                    }
                }


            }
        }
        return generalModel
    }

    //MARK: GET ROOM PROPERTY TYPE
    func separateParamForRoomPropertyType(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            generalModel.arrTemp1 = NSMutableArray()

            if generalModel.status_code == "1"
            {
                let arrData = params["room_type"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([RoomPropertyModel().initiatePropertyData(responseDict: arrData[i] as! NSDictionary)]))
                }
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

                let path = String(format:"%@/roomtype.plist",paths)

                arrData.write(toFile: path, atomically: true)
            }

            generalModel.arrTemp2 = NSMutableArray()
            if generalModel.status_code == "1"
            {
                let arrData = params["property_type"] as! NSArray

                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp2.addObjects(from: ([RoomPropertyModel().initiatePropertyData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }
            if generalModel.status_code == "1"
            {
                let arrData = params["bed_type"] as! NSArray
                if arrData.count > 0
                {
                    generalModel.arrTemp3 = NSMutableArray()
                }

                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp3.addObjects(from: ([RoomPropertyModel().initiatePropertyData(responseDict: arrData[i] as! NSDictionary)]))
                }
                if let json = params as? JSONS{
                    let bedTypes = json.array("bed_type").compactMap({BedType($0)})
                    generalModel.bedTypes = bedTypes
                }
                
                if let json = params as? JSONS{
                    let bedTypes = json.array("bed_type").compactMap({BedType($0)})
                    generalModel.bedTypes = bedTypes
                }
            }
            generalModel.arrTemp4 = NSMutableArray()
            if generalModel.status_code == "1"
            {
                let arrData = params["length_of_stay_options"] as! NSArray

                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp4.addObjects(from: ([RoomPropertyModel().initiatePriceData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }
            generalModel.arrTemp5 = NSMutableArray()
            if generalModel.status_code == "1"
            {
                let arrData = params["availability_rules_options"] as! NSArray

                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp5.addObjects(from: ([RoomPropertyModel().initiateReservationData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }
            
        }
        return generalModel
    }

    //MARK: ADD NEW ROOM
    func separateParamForAddNewRoom(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                generalModel.room_location = params["location"] as! NSString
                generalModel.room_id = self.checkParamTypes(params: params, keys:"room_id")

                if params["length_of_stay_options"] != nil
                {
                    let arrListedData = params["length_of_stay_options"] as! NSArray
                    if arrListedData.count > 0
                    {
                        generalModel.arrTemp2 = NSMutableArray()
                        for i in 0 ..< arrListedData.count
                        {
                            generalModel.arrTemp2.addObjects(from: ([RoomDetailModel().initiateDiscountlengthData(responseDict: arrListedData[i] as! NSDictionary)]))

                        }
                    }
                }
            }

        }
        return generalModel
    }

    func separateParamForCurrencyChangesModel(params : NSDictionary) -> Any
    {
        let generalModel = ListingModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                generalModel.additionGuestFee = self.checkParamTypes(params: params, keys:"additional_guests_fee")
                generalModel.cleaningFee = self.checkParamTypes(params: params, keys:"cleaning_fee")
                generalModel.monthly_price = self.checkParamTypes(params: params, keys:"monthly_price")
                generalModel.room_price = self.checkParamTypes(params: params, keys:"room_price")
                generalModel.securityDeposit = self.checkParamTypes(params: params, keys:"security_deposit")
                generalModel.weekendPrice = self.checkParamTypes(params: params, keys:"weekend_pricing")
                generalModel.weekly_price = self.checkParamTypes(params: params, keys:"weekly_price")
            }

        }
        return generalModel
    }

    //MARK: ADD NEW ROOM PRICE
    func separateParamForGeneralModel(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }
        return generalModel
    }

    

    func separateParamForGetWishlist(params: NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                generalModel.arrTemp1 = NSMutableArray()

                let arrData = params["wishlist_data"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([WishListModel().initiateWishListData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }
        }
        return generalModel
    }

    func separateParamForGetParticularWishlist(params: NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }
        return generalModel
    }


    //MARK: ADD NEW LISTING
    func separateParamForGetPayout(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                if params["payout_details"] != nil
                {
                    let arrListedData = params["payout_details"] as! NSArray
                    if arrListedData.count > 0
                    {
                        generalModel.arrTemp1 = NSMutableArray()
                        for i in 0 ..< arrListedData.count
                        {
                            generalModel.arrTemp1.addObjects(from: ([PayoutModel().initiatePayoutData(responseDict: arrListedData[i] as! NSDictionary)]))
                        }
                    }
                }
            }
        }
        return generalModel
    }

    //MARK: ADD NEW LISTING
    func separateParamForAddNewListing(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                if params["data"] != nil
                {
                    let arrListedData = params["data"] as! NSArray
                    if arrListedData.count > 0
                    {
                        generalModel.arrTemp1 = NSMutableArray()
                        for i in 0 ..< arrListedData.count
                        {
                            generalModel.arrTemp1.addObjects(from: ([ListingModel().initiateListingData(responseDict: arrListedData[i] as! NSDictionary)]))
                        }
                    }
                }

                if params["listed"] != nil
                {
                    let arrListedData = params["listed"] as! NSArray
                    if arrListedData.count > 0
                    {
                        generalModel.arrTemp2 = NSMutableArray()
                        for i in 0 ..< arrListedData.count
                        {
                            generalModel.arrTemp2.addObjects(from: ([ListingModel().initiateListingData(responseDict: arrListedData[i] as! NSDictionary)]))
                        }
                    }
                }

                if params["unlisted"] != nil
                {
                    let arrUnListedData = params["unlisted"] as! NSArray
                    if arrUnListedData.count > 0
                    {
                        generalModel.arrTemp3 = NSMutableArray()
                        for i in 0 ..< arrUnListedData.count
                        {
                            generalModel.arrTemp3.addObjects(from: ([ListingModel().initiateListingData(responseDict: arrUnListedData[i] as! NSDictionary)]))
                        }
                    }
                }

            }
        }
        return generalModel
    }

    //MARK: ADD NEW ROOM PRICE
    func separateParamForAddRoomPrice(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }
        return generalModel
    }

    //MARK: UPDATE ROOM LOCATION
    func separateParamForUpdateRoomLocation(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            if generalModel.status_code == "1"
            {
                if params["location_name"] != nil
                {
                    generalModel.room_location = params["location_name"] as! NSString
                    generalModel.dictTemp = NSMutableDictionary(dictionary:params["location_details"] as! Dictionary)
                }
            }
        }
        return generalModel
    }

    //MARK: UPDATE ROOM TITLE
    func separateParamForUpdateTitle(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }
        return generalModel
    }

    //MARK: CALENDAR ROOM LIST
    func separateParamForCalendarRoomsList(params : NSDictionary) -> Any
    {
        return params
    }

    //MARK:  BLOCKED / AVAILABLE DATES
    func separateParamForRoomBlockedDates(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                let arrData = params["blocked_dates"] as! NSArray
                if arrData.count > 0
                {
                    generalModel.arrTemp3 = NSMutableArray()
                }
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp3.add(arrData[i] as! String)
                }

                if params["reserved_dates"] != nil
                {
                    let arrReservedData = params["reserved_dates"] as! NSArray
                    if arrReservedData.count > 0
                    {
                        generalModel.arrTemp1 = NSMutableArray()
                    }
                    for i in 0 ..< arrReservedData.count
                    {
                        generalModel.arrTemp1.add(arrReservedData[i] as! String)
                    }
                }

                if params["nightly_price"] != nil
                {
                    let arrNightlyData = params["nightly_price"] as! NSArray
                    if arrNightlyData.count > 0
                    {
                        generalModel.arrTemp2 = NSMutableArray()
                    }
                    for i in 0 ..< arrNightlyData.count
                    {
                        generalModel.arrTemp2.add(arrNightlyData[i] as! String)
                    }
                }
            }
        }

        return generalModel
    }

    //MARK: DISABLE LISTING
    func separateParamForDisableListing(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: ROOMS BEDS LIST
    func separateParamForRoomsBedsList(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: SELECTED AMENITIES
    func separateParamForSelectedAmenities(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: UPDATE ROOM DESC
    func separateParamForUpdateRoomDesc(params : NSDictionary,methodName: NSString) -> Any
    {
        let abtModel = AboutListingModel()
        if params["error"] != nil
        {
            abtModel.success_message = params["error"] as! NSString
            abtModel.status_code = "0"
        }
        else
        {
            abtModel.success_message = params["success_message"] as! NSString
            abtModel.status_code = params["status_code"] as! NSString
            if abtModel.status_code as String == "1" && methodName as String == APPURL.METHOD_GET_ROOM_DESC
            {
                abtModel.space_msg = self.checkParamTypes(params: params, keys:"space_msg")
                abtModel.guest_access_msg = self.checkParamTypes(params: params, keys:"guest_access_msg")
                abtModel.interaction_with_guest_msg = self.checkParamTypes(params: params, keys:"interaction_with_guest_msg")
                abtModel.overview_msg = self.checkParamTypes(params: params, keys:"overview_msg")
                abtModel.getting_arround_msg = self.checkParamTypes(params: params, keys:"getting_arround_msg")
                abtModel.other_things_to_note_msg = self.checkParamTypes(params: params, keys:"other_things_to_note_msg")
                abtModel.house_rules_msg = self.checkParamTypes(params: params, keys:"house_rules_msg")
            }
        }
        return abtModel
    }

    //MARK: UPDATE LONG TERM PRICE
    func separateParamForUpdateLongTermPrice(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }
    //MARK: UDPATE AVAILABILITY RULE
    func separateParamForUpdateAvailabilityPrice(params : NSDictionary) -> Any
    {//com
        let generalModel = RoomDetailModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                if params["availability_rules"] != nil
                {
                    let arrListedData = params["availability_rules"] as! NSArray
                    if arrListedData.count > 0
                    {
                        generalModel.arrTemp2 = NSMutableArray()
                        for i in 0 ..< arrListedData.count
                        {
                            generalModel.arrTemp2.addObjects(from: ([RoomDetailModel().initiateAvailabilityData(responseDict: arrListedData[i] as! NSDictionary)]))
                        }
                    }
                }
            }
        }
        return generalModel

    }

    //MARK: DELETE ADDITIONAL PRICE
    func separateParamForDeleteAdditionalPrice(params : NSDictionary) -> Any
    {
        let generalModel = RoomDetailModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                if params["price_rules"] != nil
                {
                    let arrListedData = params["price_rules"] as! NSArray
                    if arrListedData.count > 0
                    {
                        generalModel.arrTemp2 = NSMutableArray()
                        for i in 0 ..< arrListedData.count
                        {
                            generalModel.arrTemp2.addObjects(from: ([RoomDetailModel().initiateEditlengthData(responseDict: arrListedData[i] as! NSDictionary)]))
                        }
                    }
                }
            }
        }
        return generalModel

    }
    //MARK: DELETE AVAILABILITY RULES
    func separateParamForDeleteAvailabilityRule(params : NSDictionary) -> Any
    {//com
        let generalModel = RoomDetailModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                if params["availability_rules"] != nil
                {
                    let arrListedData = params["availability_rules"] as! NSArray
                    if arrListedData.count > 0
                    {
                        generalModel.arrTemp2 = NSMutableArray()
                        for i in 0 ..< arrListedData.count
                        {
                            generalModel.arrTemp2.addObjects(from: ([RoomDetailModel().initiateAvailabilityData(responseDict: arrListedData[i] as! NSDictionary)]))
                        }
                    }
                }
            }
        }
        return generalModel

    }
    //MARK: UDPATE HOUSE RULES
    func separateParamForUpdateHouseRules(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: ************ SEPARATE PARAMS FOR HOST END ************






    //MARK: TRIPS TYPE
    func separateParamForTripsTypes(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                if params["booking_types"] != nil
                {
                    generalModel.arrTemp1 = NSMutableArray()
                    
                    if let bookTypes = params["booking_types"] as? [JSONS]{
    
                        generalModel.trpModel = bookTypes.compactMap({tripList($0)})
                        
                    }
                    
                    //((params["booking_types"] as! NSArray) as! [Any])
                }
            }
        }

        return generalModel
    }

    //MARK: TRIPS TYPE
    func separateParamForBreakDown(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            
            if generalModel.status_code == "1"
            {
                if params["data"] != nil
                {
                    generalModel.arrTemp1 = NSMutableArray()
                    
                    if let bookTypes = params["data"] as? [JSONS]{
                        
                        generalModel.trpModel = bookTypes.compactMap({tripList($0)})
                        
                    }
                    
                    //((params["booking_types"] as! NSArray) as! [Any])
                }
            }
        }
        
        return generalModel
    }
    
    
    //MARK: UPLOAD PROFILE IMAGE
    func separateParamForUploadProfileImage(params : NSDictionary) -> Any
    {
        return params
    }
    //MARK: ADD_PAYOUT DETAILS
    func separateParamForAddPayout(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }
        return generalModel
    }

    //MARK: TRIPS DETAILS
    func separateParamForTripsDetails(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["status_code"] as! NSString == "1"
        {
            generalModel.arrTemp1 = NSMutableArray()
            if params["bookings"] != nil
            {
                generalModel.arrTemp1 = NSMutableArray()

                let arrData = params["bookings"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([TripsModel().initiateTripsData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }

            if params["current_bookings"] != nil
            {
                generalModel.arrTemp1 = NSMutableArray()

                let arrData = params["current_bookings"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([TripsModel().initiateTripsData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }

            if params["upcoming_bookings"] != nil
            {
                generalModel.arrTemp1 = NSMutableArray()

                let arrData = params["upcoming_bookings"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([TripsModel().initiateTripsData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }

            if params["previous_bookings"] != nil
            {
                generalModel.arrTemp1 = NSMutableArray()

                let arrData = params["previous_bookings"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([TripsModel().initiateTripsData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }

            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: METHOD_CANCEL_TRIP_BY_GUEST
    func separateParamForCancelTrip(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["status_code"] as! NSString == "1"
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: METHOD_INBOX_RESERVATION
    func separateParamForInboxReservation(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else if params["status_code"] as! NSString == "1"
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            generalModel.unread_message_count = MakentSupport().checkParamTypes(params: params, keys:"is_message_read")
            
            print("un read msg",MakentSupport().checkParamTypes(params: params, keys:"is_message_read"))

            generalModel.arrTemp1 = NSMutableArray()
            if params["data"] != nil
            {
                generalModel.arrTemp3 = NSMutableArray()

                let arrData = params["data"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp3.addObjects(from: ([InboxModel().initiateInboxData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }
        }
        else
        {
            //(params as! JSONS).statusMessage as NSString
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: GET CONVERSATION LIST
    func separateParamForConversationList(params : JSONS) -> ConversationChatModel
    {
        let conversationModel = ConversationChatModel(responseJSON: params)
//        if params["error"] != nil
//        {
//            generalModel.success_message = params["error"] as! NSString
//            generalModel.status_code = "0"
//        }
//        else
//        {
//            generalModel.success_message = params["success_message"] as! NSString
//            generalModel.status_code = params["status_code"] as! NSString
//
//            if generalModel.status_code == "1"
//            {
//                generalModel.arrTemp1 = NSMutableArray()
//                generalModel.receiver_thumb_image = self.checkParamTypes(params: params, keys:"receiver_thumb_image")
//                generalModel.sender_thumb_image = self.checkParamTypes(params: params, keys:"sender_thumb_image")
//
//                let arrData = params["data"] as! NSArray
//                for i in 0 ..< arrData.count
//                {
//                    generalModel.arrTemp1.addObjects(from: ([ConversationModel().initiateConversationData(responseDict: arrData[i] as! NSDictionary)]))
//                }
//            }
//
//        }
        return conversationModel
    }

    //MARK: GET RESERVATION LIST
    func separateParamForReservationList(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = (params as! JSONS).statusMessage as NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                generalModel.arrTemp1 = NSMutableArray()

                let arrData = params["data"] as! NSArray
                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([ReservationModel().initiateReservationData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }

        }
        return generalModel
    }


    //MARK: SEND MESSAGE
    func separateParamForSendMessage(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            generalModel.message = MakentSupport().checkParamTypes(params: params, keys:"message") as NSString
            generalModel.message_time = MakentSupport().checkParamTypes(params: params, keys:"message_time") as NSString
        }
        return generalModel
    }

    //MARK: Login - Separate Params
    func separateParamForLogin(params : NSDictionary) -> Any
    {
        return LoginModel(jsons: params as! JSONS)
    }

    //MARK: SignUp
    func separateParamForSignUp(params : NSDictionary) -> Any
    {

        return ""
    }


    //MARK: Google Place Search
    func separateParamForGooglePlaceSearch(params : NSDictionary) -> Any
    {
        let locModel = GoogleLocationModel()
        if ((params["status"] as! NSString)) as String == "RESPONSE_STATUS_OK"
        {
            locModel.dictTemp = NSMutableDictionary(dictionary:params)

            locModel.success_message = "Success"
            locModel.status_code = "1"

            let dictMainResult = params.value(forKeyPath: "result.address_components") as! NSArray

            for i in 0 ..< dictMainResult.count
            {
                let dictOrgResult = dictMainResult[i] as! NSDictionary
                let arrResult = dictOrgResult["types"] as! NSArray
                let strType = arrResult[0] as! String

                if strType == "street_number"
                {
                    locModel.street_address = dictOrgResult["long_name"] as! String
                }
                else if strType == "route"
                {
                    if ((locModel.street_address as String).count > 0)
                    {
                        locModel.street_address = String(format:"%@, %@",locModel.street_address,dictOrgResult["long_name"] as! String)
                    }
                    else
                    {
                        locModel.street_address = String(format: "%@",dictOrgResult["long_name"] as! String)
                    }
                }
                else if strType == "locality"
                {
                    locModel.city_name = dictOrgResult["long_name"] as! String
                }
                else if strType == "premise"
                {
                    locModel.premise_name = dictOrgResult["long_name"] as! String
                }
                else if strType == "administrative_area_level_1"
                {
                    locModel.state_name = dictOrgResult["long_name"] as! String
                }
                else if strType == "country"
                {
                    locModel.country_name = dictOrgResult["long_name"] as! String
                }
                else if strType == "postal_code"
                {
                    locModel.postal_code = dictOrgResult["long_name"] as! String
                }
            }
        }
        else
        {
            locModel.success_message = "Failure"
            locModel.status_code = "0"
        }

        return locModel
    }

    func separateParamForViewProfile(params : NSDictionary, method: NSString) -> Any
    {
       var profileData =  ProfileModel(json: params as! JSONS)
        if params["error"] != nil
        {
            profileData.success_message = params["error"] as! NSString
            profileData.status_code = "0"
        }
        else
        {
            profileData.success_message = params["success_message"] as! NSString
            profileData.status_code = params["status_code"] as! NSString
            if method.isEqual(to: APPURL.METHOD_VIEW_OTHER_PROFILE) && params["user_details"] != nil
            {
                let newParams = params["user_details"] as! NSDictionary
                profileData = ProfileModel(json: params as! JSONS).initiateOtherProfileData(responseDict:newParams) as! ProfileModel
                profileData.success_message = params["success_message"] as! NSString
                profileData.status_code = params["status_code"] as! NSString

            }
            else if params["user_details"] != nil
            {
                let newParams = params["user_details"] as! NSDictionary
                profileData.user_name =  String(format:"%@ %@",newParams["first_name"] as! NSString,newParams["last_name"] as! NSString) as NSString
                profileData.first_name = newParams["first_name"] as! NSString
                profileData.last_name = newParams["last_name"] as! NSString
                //                profileData.user_thumb_image = newParams["user_thumb_image"] as! NSString
                profileData.dob = MakentSupport().checkParamTypes(params: newParams, keys:"dob")
                profileData.email_id =  MakentSupport().checkParamTypes(params: newParams, keys:"email")
                profileData.user_location = newParams["user_location"] as! NSString
                profileData.member_from = MakentSupport().checkParamTypes(params: newParams, keys:"member_from")
                profileData.about_me = MakentSupport().checkParamTypes(params: newParams, keys:"about_me")
                profileData.school = MakentSupport().checkParamTypes(params: newParams, keys:"school")
                profileData.gender = MakentSupport().checkParamTypes(params: newParams, keys:"gender")
                profileData.phone = MakentSupport().checkParamTypes(params: newParams, keys:"phone")
                profileData.work = MakentSupport().checkParamTypes(params: newParams, keys:"work")
                profileData.is_email_connect = newParams["is_email_connect"] as! NSString
                profileData.is_facebook_connect = newParams["is_facebook_connect"] as! NSString
                profileData.is_google_connect = newParams["is_google_connect"] as! NSString
                profileData.is_linkedin_connect = newParams["is_linkedin_connect"] as! NSString
                profileData.user_id = self.checkParamTypes(params: newParams, keys:"user_id")
                profileData.user_normal_image_url = newParams["normal_image_url"] as! NSString
                profileData.user_large_image_url = newParams["large_image_url"] as! NSString
                profileData.user_small_image_url = newParams["small_image_url"] as! NSString

            }
        }
        return profileData
    }

    func separateParamForEditProfile(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        generalModel.status_code = params["status_code"] as! NSString

        if generalModel.status_code == "1"
        {
            generalModel.success_message = "Success"
            generalModel.status_code = "1"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = "0"
        }

        return generalModel
    }

    //MARK: LogOut
    func separateParamForLogout(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }

        return generalModel
    }

    //MARK: Email Validation
    func separateParamForEmailValidation(params : NSDictionary) -> Any
    {
        return params
    }

    //MARK: Login
    func separateParamForForgotPassword(params : NSDictionary) -> Any
    {
        return params
    }
    //MARK: Explore
    func separateParamForExperienceList(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            
            if generalModel.status_code == "1"
            {
                generalModel.arrTemp1 = NSMutableArray()
               
                if params["data"] != nil
                {
                    let arrData = params["data"] as! NSArray
                    for i in 0 ..< arrData.count
                    {
                        generalModel.arrTemp1.addObjects(from: ([ExploreModel().initiateExperienceData(responseDict: arrData[i] as! NSDictionary)]))
                    }
                }
            }
        }
        return generalModel
    }
    //MARK: Explore
    func separateParamForExploreList(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                generalModel.arrTemp1 = NSMutableArray()
                generalModel.max_price = self.checkParamTypes(params: params, keys:"max_price")
                generalModel.min_price = self.checkParamTypes(params: params, keys:"min_price")
                generalModel.total_page = params["total_page"] as? Int ?? 0

                if params["data"] != nil
                {
                    let arrData = params["data"] as! NSArray
                    for i in 0 ..< arrData.count
                    {
                        generalModel.arrTemp1.addObjects(from: ([ExploreModel().initiateExploreData(responseDict: arrData[i] as! NSDictionary)]))
                    }
                }

                if params["wishlist_details"] != nil
                {
                    let arrData = params["wishlist_details"] as! NSArray
                    for i in 0 ..< arrData.count
                    {
                        generalModel.arrTemp1.addObjects(from: ([ExploreModel().initiateExploreData(responseDict: arrData[i] as! NSDictionary)]))
                    }
                }
            }
        }
        return generalModel
    }
    

    //MARK: Maps
    func separateParamForMapsList(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            generalModel.arrTemp1 = NSMutableArray()

            if generalModel.status_code == "1"
            {
                let arrData = params["maps_details"] as! NSArray

                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([MapModel().initiateMapData(responseDict: arrData[i] as! NSDictionary)]))
                }
            }
        }
        return generalModel
    }


    //MARK: Room Detail Page
    func separateParamForRoomDetail(params : NSDictionary) -> Any
    {
        let roomModel = RoomDetailModel()
        if params["error"] != nil
        {
            roomModel.success_message = params["error"] as! NSString
            roomModel.status_code = "0"
            return roomModel
        }
        roomModel.success_message = params["success_message"] as! NSString
        roomModel.status_code =  params["status_code"] as! NSString

        if roomModel.status_code == "1"
        {

            let arrData = params["length_of_stay_rules"] as? NSArray
            let arrData1 = params["early_bird_rules"] as? NSArray
            let arrData2 = params["last_min_rules"] as? NSArray
            let arrData3 = params["availability_rules"] as? NSArray
            let arrData4 = params["amenities_values"] as? NSArray

            if let arr = arrData,arr.count > 0 {

                for i in 0 ..< arr.count
                {
                    roomModel.arrTemp1.addObjects(from: ([RoomDetailModel().initiateDiscountData(responseDict: arr[i] as! NSDictionary)]))
                }

                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let path = String(format:"%@/roomtype.plist",paths)
                arr.write(toFile: path, atomically: true)
            }

            if let arr1 = arrData1,arr1.count > 0 {

                for i in 0 ..< arr1.count
                {
                    roomModel.arrTemp2.addObjects(from: ([RoomDetailModel().initiateDiscountData(responseDict: arr1[i] as! NSDictionary)]))
                }
            }

            if let arr2 = arrData2,arr2.count > 0 {

                for i in 0 ..< arr2.count
                {
                    roomModel.arrTemp3.addObjects(from: ([RoomDetailModel().initiateDiscountData(responseDict: arr2[i] as! NSDictionary)]))
                }
            }


            if let arr3 = arrData3,arr3.count > 0 {

                for i in 0 ..< arr3.count
                {
                    roomModel.arrTemp4.addObjects(from: ([RoomDetailModel().initiateAvailabilityData(responseDict: arr3[i] as! NSDictionary)]))
                }
            }

            if let arr4 = arrData4,arr4.count > 0 {

                for i in 0 ..< arr4.count
                {
                    roomModel.arrTemp5.addObjects(from: ([RoomDetailModel().initiateAminitiesData(responseDict: arr4[i] as! NSDictionary)]))
                }
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let path = String(format:"%@/amenities.plist",paths)
                arr4.write(toFile: path, atomically: true)
            }

            roomModel.review_date = self.checkParamTypes(params: params, keys:"review_date")
            roomModel.room_id = self.checkParamTypes(params: params, keys:"room_id")
            roomModel.room_price = self.checkParamTypes(params: params, keys:"room_price")
            roomModel.room_name = params["room_name"] as! NSString
            roomModel.space = params["space"] as! NSString
            roomModel.access = params["access"] as! NSString
            roomModel.interaction = params["interaction"] as! NSString
            roomModel.neighborhood_overview = params["neighborhood_overview"] as! NSString
            roomModel.getting_around = params["getting_around"] as! NSString
            roomModel.notes = params["notes"] as! NSString
            roomModel.room_images = params["room_images"] as! NSArray
            roomModel.rating_value = self.checkParamTypes(params: params, keys:"rating_value")
            roomModel.reviews_count = self.checkParamTypes(params: params, keys:"review_count")
            roomModel.is_whishlist = params["is_whishlist"] as! NSString
            roomModel.is_shared = params["is_shared"] as! NSString
            roomModel.room_share_url = params["room_share_url"] as! NSString
            roomModel.host_user_id = self.checkParamTypes(params: params, keys:"host_user_id")
            roomModel.host_user_name = params["host_user_name"] as! NSString
            roomModel.room_type = self.checkParamTypes(params: params, keys:"room_type")
            roomModel.host_user_image = params["host_user_image"] as! NSString
            roomModel.no_of_guest = self.checkParamTypes(params: params, keys:"no_of_guest")
            roomModel.no_of_beds = self.checkParamTypes(params: params, keys:"no_of_beds")
            roomModel.no_of_bedrooms = self.checkParamTypes(params: params, keys:"no_of_bedrooms")
            roomModel.no_of_bathrooms = self.checkParamTypes(params: params, keys:"no_of_bathrooms")
            roomModel.locaiton_name = params["locaiton_name"] as! NSString
            roomModel.loc_latidude = self.checkParamTypes(params: params, keys:"loc_latidude")
            roomModel.loc_longidude = self.checkParamTypes(params: params, keys:"loc_longidude")
            roomModel.review_user_name = self.checkParamTypes(params: params, keys:"review_user_name")
            roomModel.review_user_image = self.checkParamTypes(params: params, keys:"review_user_image")
            roomModel.review_message = self.checkParamTypes(params: params, keys:"review_message")
            roomModel.review_value = self.checkParamTypes(params: params, keys:"review_count")
            roomModel.room_detail = params["room_detail"] as! NSString
            roomModel.can_book = params["can_book"] as! NSString
            roomModel.check_in_time = self.checkParamTypes(params: params, keys:"check_in_time")
            roomModel.check_out_time = self.checkParamTypes(params: params, keys:"check_out_time")
            roomModel.amenities_values =  params["amenities_values"] as! NSArray
            roomModel.weekly_price = self.checkParamTypes(params: params, keys:"weekend")
            roomModel.monthly_price = self.checkParamTypes(params: params, keys:"monthly_price")
            roomModel.security_deposit = self.checkParamTypes(params: params, keys:"security")
            roomModel.additional_guests = self.checkParamTypes(params: params, keys:"additional_guest")
            roomModel.cleaning_fee = self.checkParamTypes(params: params, keys:"cleaning")
            roomModel.currency_symbol = self.checkParamTypes(params: params, keys:"currency_symbol")
            roomModel.currency_code = self.checkParamTypes(params: params, keys:"currency_code")
            roomModel.house_rules = self.checkParamTypes(params: params, keys:"house_rules")
            roomModel.cancellation_policy = self.checkParamTypes(params: params, keys:"cancellation_policy")
            roomModel.instant_book = self.checkParamTypes(params: params, keys:"instant_book")
            roomModel.maximum_stay = self.checkParamTypes(params: params, keys:"maximum_stay")
            roomModel.minimum_stay = self.checkParamTypes(params: params, keys:"minimum_stay")
            if let latestValue = params["similar_list_details"] as? NSArray
            {
                roomModel.similar_list_details = latestValue
            }
            if let latestValue = params["blocked_dates"] as? NSArray
            {
                roomModel.blocked_dates = latestValue
            }
        }
        return roomModel
    }
    
    func separateParamForHomeDetail(params : JSONS) -> Any
    {
        let roomModel = RoomDetailModel()
        
//        if params.string("error").count != 0  {
//            roomModel.successMessage = params.string("error")
//            roomModel.statusCode = 0
//            return roomModel
//        }
//        roomModel.successMessage = params.status_message
//        roomModel.statusCode = params.status_code
//        if params.status_code == 1 {
//            roomModel.canBook = params.string("can_book")
//            roomModel.instantBook = params.string("instant_book")
//            roomModel.carID = params.int("car_id")
//            roomModel.carPrice = params.int("car_price")
//            roomModel.carName = params.string("car_name")
//            roomModel.carImages = params.array("car_images")
//            roomModel.make = params.string("make")
//            roomModel.model = params.string("model")
//            roomModel.year = params.int("year")
//            roomModel.fuelType = params.string("fuel_type")
//            roomModel.mileage = params.string("mileage")
//            roomModel.airbag = params.int("airbag")
//            roomModel.seatingCapacity = params.int("seating_capacity")
//            roomModel.numberOfGears = params.int("number_of_gears")
//            roomModel.fuelTankCapacity = params.int("fuel_tank_capacity")
//            roomModel.fuelTankType = params.string("fuel_tank_type")
//            roomModel.doors = params.int("doors")
//            roomModel.carMileagePerDay = params.int("car_mileage_per_day")
//            roomModel.carMileagePerWeek = params.int("car_mileage_per_week")
//            roomModel.carMileagePerMonth = "\(params.int("car_mileage_per_month"))"
//            roomModel.carMileageExtraFee = params.int("car_mileage_extra_fee")
//            roomModel.carMileageIn = params.string("car_mileage_in")
//            roomModel.carShareURL = params.string("car_share_url")
//            roomModel.isWhishlist = params.string("is_whishlist")
//            roomModel.ratingValue = params.string("rating_value")
//            roomModel.ownerUserID = params.int("owner_user_id")
//            roomModel.ownerUserName = params.string("owner_user_name")
//            roomModel.ownerUserImage = params.string("owner_user_image")
//            roomModel.carType = params.string("car_type")
//            roomModel.transmission = params.string("transmission")
//            roomModel.transmissionImage = params.string("transmission_image")
//
//            //                for amenities in params.array("amenities_values")  {
//            //                    print(amenities)
//            //                }
//            //            }
//            if params.array("amenities_values").count > 0 {
//                roomModel.amenitiesValues.removeAll()
//                for ameniti in params.array("amenities_values") as [JSON] {
//                    let amenitiValue = AmenitiesValue(id: ameniti.int("id"), name: ameniti.string("name"))
//                    roomModel.amenitiesValues.append(amenitiValue)
//                }
//            }
//
//
//            roomModel.locationName = params.string("location_name")
//            roomModel.locLatidude = params.string("loc_latidude")
//            roomModel.locLongidude = params.string("loc_longidude")
//            roomModel.reviewUserName = params.string("review_user_name")
//            roomModel.reviewUserImage = params.string("review_user_image")
//            roomModel.reviewDate = params.string("review_date")
//            roomModel.reviewCount = "\(params.int("review_count"))"
//            roomModel.reviewMessage = params.string("review_message")
//            roomModel.carDetail = params.string("car_detail")
//            roomModel.cancellationPolicy = params.string("cancellation_policy")
//            roomModel.security = params.int("security")
//            roomModel.weekend = params.int("weekend")
//            roomModel.carRules = params.string("car_rules")
//            roomModel.car = params.string("car")
//            roomModel.notes = params.string("notes")
//            roomModel.currencyCode = params.string("currency_code")
//            roomModel.currencySymbol = params.string("currency_symbol").stringByDecodingHTMLEntities
//            SharedVariables.sharedInstance.currencySymbol = roomModel.currencySymbol
//            roomModel.blockedDates = params.array("blocked_dates")
//            roomModel.reservedDates = params.array("reserved_dates")
//
//            if (params.array("similar_list_details").count) > 0 {
//                roomModel.similarListDetails.removeAll()
//                for similarList in params.array("similar_list_details") as [JSON] {
//                    let similar = SimilarListDetail().initForSimilarList(similarListDict: similarList) as! SimilarListDetail
//                    roomModel.similarListDetails.append(similar)
//                }
//            }
//            if (params.array("availability_rules").count) > 0 {
//                roomModel.availabilityRules.removeAll()
//                for json in params.array("availability_rules") as [JSON] {
//                    let availabilityRules = AvailabilityRule(responseJson: json)
//                    roomModel.availabilityRules.append(availabilityRules)
//                }
//            }
//            if (params.array("length_of_rent_rules").count) > 0 {
//                roomModel.lengthOfRentRules.removeAll()
//                for json in params.array("length_of_rent_rules") as [JSON] {
//                    let rule = Rule(responseJson: json)
//                    roomModel.lengthOfRentRules.append(rule)
//                }
//            }
//            if (params.array("early_bird_rules").count) > 0 {
//                roomModel.earlyBirdRules.removeAll()
//                for json in params.array("early_bird_rules") as [JSON] {
//                    let rule = Rule(responseJson: json)
//                    roomModel.earlyBirdRules.append(rule)
//                }
//            }
//            if (params.array("last_min_rules").count) > 0 {
//                roomModel.lastMinRules.removeAll()
//                for json in params.array("last_min_rules") as [JSON] {
//                    let rule = Rule(responseJson: json)
//                    roomModel.lastMinRules.append(rule)
//                }
//            }
//
//
//            roomModel.minimumDay = params.int("minimum_day")
//            roomModel.maximumDay = params.int("maximum_day")
//        }
//
        return roomModel
    }


    //MARK: House Rules
    func separateParamForHouseRules(params : NSDictionary) -> Any
    {
        return params
    }

    //MARK: Aminities List
    func separateParamForAmenitiesList(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            generalModel.arrTemp2 = NSMutableArray()
            if generalModel.status_code == "1"
            {
                let arrData = params["data"] as! NSArray
                let path1 = Bundle.main.path(forResource: "amenities", ofType: "plist")
                let dictAmenitiesData = NSArray.init(contentsOfFile: path1!)!
                print(arrData.count,dictAmenitiesData.count)
                for i in 0 ..< arrData.count
                {
                    if arrData.count >= dictAmenitiesData.count{
                        let dict = dictAmenitiesData[dictAmenitiesData.count-1] as! NSDictionary
                        generalModel.arrTemp2.addObjects(from: ([AmenitiesModel().initiateAmenitiesData(responseDict:dict ,iconName:arrData[31] as! NSDictionary)]))

                    }
                    else{
                        let dict = dictAmenitiesData[i] as! NSDictionary
                        generalModel.arrTemp2.addObjects(from: ([AmenitiesModel().initiateAmenitiesData(responseDict:dict ,iconName:arrData[i] as! NSDictionary)]))
                    }
                }

                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let path = String(format:"%@/amenities.plist",paths)
                arrData.write(toFile: path, atomically: true)
            }
        }
        return generalModel
    }

    //MARK: RoomList List
    /*  func separateParamForRoomTypeList(params : NSDictionary) -> Any
     {
     let generalModel = GeneralModel()
     if params["error"] != nil
     {
     generalModel.success_message = params["error"] as! NSString
     generalModel.status_code = "0"
     }
     else
     {
     generalModel.success_message = params["success_message"] as! NSString
     generalModel.status_code = params["status_code"] as! NSString
     generalModel.arrTemp2 = NSMutableArray()
     if generalModel.status_code == "1"
     {
     let arrData = params["room_type"] as! NSArray
     // let arr = ["j", "z", "f", "b", "o", "s", "r", "B", "p", "A", "w", "n", "e", "u", "m", "i", "l", "q", "g", "x", "k", "y", "c", "v", "t", "a", "t", "t", "t", "t", "t"]
     let path1 = Bundle.main.path(forResource: "amenities", ofType: "plist")
     let dictAmenitiesData = NSArray.init(contentsOfFile: path1!)!

     for i in 0 ..< arrData.count
     {
     let dict = dictAmenitiesData[i] as! NSDictionary
     //                    print([AmenitiesModel().initiateAmenitiesData(responseDict:dict ,iconName:arrData[i] as! NSDictionary)])
     generalModel.arrTemp2.addObjects(from: ([AmenitiesModel().initiateAmenitiesData(responseDict:dict ,iconName:arrData[i] as! NSDictionary)]))
     }

     let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
     let path = String(format:"%@/amenities.plist",paths)
     arrData.write(toFile: path, atomically: true)
     print(path)
     }
     }
     return generalModel
     }*/
    //MARK: Reviews List
    func separateParamForReviewsList(params : NSDictionary) -> Any
    {
        let reviewModel = ReviewsModel(json: params as! JSONS)
//        if params["error"] != nil
//        {
//            reviewModel.success_message = params["error"] as! NSString
//            reviewModel.status_code = "0"
//        }
//        reviewModel.success_message = params["success_message"] as! NSString
//        reviewModel.status_code =  params["status_code"] as! NSString
//
//        if reviewModel.status_code == "1"
//        {
//            reviewModel.accuracy_value = self.checkParamTypes(params: params, keys:"accuracy_value")
//            reviewModel.check_in_value = self.checkParamTypes(params: params, keys:"check_in_value")
//            reviewModel.cleanliness_value = self.checkParamTypes(params: params, keys:"cleanliness_value")
//            reviewModel.communication_value = self.checkParamTypes(params: params, keys:"communication_value")
//            reviewModel.location_value =  self.checkParamTypes(params: params, keys:"location_value")
//            reviewModel.value =  self.checkParamTypes(params: params, keys:"value")
//            reviewModel.total_review = self.checkParamTypes(params: params, keys:"total_review")
//            reviewModel.ratingValue = self.checkParamTypes(params: params, keys: "rating_value")
//
//            reviewModel.arrReviewData = NSMutableArray()
//
//            let arrData = params["data"] as! NSArray
//
//            for i in 0 ..< arrData.count
//            {
//                reviewModel.arrReviewData.addObjects(from: ([ReviewsModel().initiateReviewData(responseDict: arrData[i] as! NSDictionary)]))
//            }
//        }

        return reviewModel
    }



    //MARK: Room Available Dates
    func separateParamForRoomAvailableDatesUrl(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            if generalModel.status_code == "1"
            {
                generalModel.arrTemp2 = NSMutableArray()
                let arrData = params["blocked_dates"] as! NSArray

                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp2.addObjects(from: [arrData[i]])
                }
            }
        }
        return generalModel
    }

    //MARK: Room Available Status
    func separateParamForRoomAvailableStatusUrl(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil && (params["error"] is String)
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString

            if generalModel.status_code == "1"
            {
                generalModel.availability_msg = params["availability_msg"] as! NSString
                generalModel.pernight_price = self.checkParamTypes(params: params, keys:"pernight_price")
            }
        }
        return generalModel
    }

    

    //MARK: Contry List
    func separateParamForCountryList(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
            generalModel.arrTemp1 = NSMutableArray()

            if generalModel.status_code == "1"
            {
                let arrData = params["country_list"] as! NSArray

                for i in 0 ..< arrData.count
                {
                    generalModel.arrTemp1.addObjects(from: ([CountryModel().initiateCountryData(responseDict: arrData[i] as! NSDictionary)]))
                }

                //                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                //                let path = String(format:"%@/country.plist",paths)//s paths.stringByAppendingString("/bookmark.plist")
                //                arrData.write(toFile: path, atomically: true)
                //                print(path)

            }
        }
        return generalModel
    }


    //MARK: Currency List
//    func separateParamForCurrencyList(params : JSONS)
//    {
////        let generalModel = GeneralModel()
////        if params["error"] != nil
////        {
////            generalModel.success_message = params["error"] as! NSString
////            generalModel.status_code = "0"
////        }
////        else
////        {
//////            generalModel.success_message = params["success_message"] as! NSString
////            generalModel.status_code = params["status_code"] as! NSString
////            generalModel.arrTemp1 = NSMutableArray()
////
////            if generalModel.status_code == "1"
////            {
//                let arrData = params["currency_list"] as! NSArray
//
//                for i in 0 ..< arrData.count
//                {
//                    generalModel.arrTemp1.addObjects(from: ([CurrencyModel(responseDict: arrData[i] as! JSONS)]))
//                }
//            }
//        }
//
//    }


    //MARK: Change Currency Type
    func separateParamForChangeCurrency(params : NSDictionary) -> Any
    {
        let generalModel = GeneralModel()
        if params["error"] != nil
        {
            generalModel.success_message = params["error"] as! NSString
            generalModel.status_code = "0"
        }
        else
        {
            generalModel.success_message = params["success_message"] as! NSString
            generalModel.status_code = params["status_code"] as! NSString
        }
        return generalModel
    }


    //MARK: Change Currency Type
    func separateParamForChangePrePayment(params : NSDictionary) -> Any
    {
        let roomModel = PrePaymentModel()
        if params["error"] != nil
        {
            roomModel.success_message = params["error"] as! NSString
            roomModel.status_code = "0"
        }
        else
        {
            roomModel.success_message = params["success_message"] as! NSString
            roomModel.status_code = params["status_code"] as! NSString

            if roomModel.status_code == "1"
            {
                roomModel.no_of_bathrooms = self.checkParamTypes(params: params, keys:"bathrooms")
                roomModel.no_of_bedrooms = self.checkParamTypes(params: params, keys:"bedrooms")
                roomModel.currency_code = self.checkParamTypes(params: params, keys:"currency_code")
                roomModel.currency_symbol = self.checkParamTypes(params: params, keys:"currency_symbol")
                roomModel.description_details = self.checkParamTypes(params: params, keys:"description")
                roomModel.end_date = self.checkParamTypes(params: params, keys:"end_date")
                roomModel.host_user_name = params["host_user_name"] as! NSString
                roomModel.host_user_image = params["host_user_thumb_image"] as! NSString
                roomModel.nights_count = self.checkParamTypes(params: params, keys:"nights_count")
                roomModel.per_night_price = self.checkParamTypes(params: params, keys:"per_night_price")
                roomModel.policy_name = self.checkParamTypes(params: params, keys:"policy_name")
                roomModel.room_name = params["room_name"] as! NSString
                roomModel.room_type = self.checkParamTypes(params: params, keys:"room_type")
                roomModel.service_fee = self.checkParamTypes(params: params, keys:"service_fee")
                roomModel.start_date = self.checkParamTypes(params: params, keys:"start_date")
                roomModel.total_price = self.checkParamTypes(params: params, keys:"total_price")
                roomModel.cleaning_fee = self.checkParamTypes(params: params, keys:"cleaning_fee")
                roomModel.addition_guest_fee = self.checkParamTypes(params: params, keys:"additional_guest")
                roomModel.security_fee = self.checkParamTypes(params: params, keys:"security_fee")
                roomModel.rooms_total_guest = self.checkParamTypes(params: params, keys:"rooms_total_guest")
                roomModel.length_of_stay_discount = self.checkParamTypes(params: params, keys:"length_of_stay_discount")
                roomModel.length_of_stay_discount_price = self.checkParamTypes(params: params, keys:"length_of_stay_discount_price")
                roomModel.length_of_stay_type = self.checkParamTypes(params: params, keys:"length_of_stay_type")
                roomModel.booked_period_type = self.checkParamTypes(params: params, keys:"booked_period_type")
                roomModel.booked_period_discount = self.checkParamTypes(params: params, keys:"booked_period_discount")
                roomModel.booked_period_discount_price = self.checkParamTypes(params: params, keys:"booked_period_discount_price")

            }
        }
        return roomModel
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
    //* Experience Start *//
    func separateParamForExperienceDetailModel(params : NSDictionary) -> Any
    {
        let experienceRoomDetails = ExperienceRoomDetails.init(object: params)
        return experienceRoomDetails
    }
    
    func separateParamForHostExperienceCategoryModel(params: NSDictionary) -> Any {
        return ExCategoryModel.init(object: params)
    }
    
    func separateParamsForExploreExperience(params: [String: Any]) -> Any {
        return ExploreExperienceModel(response: params)
    }
    
    func separateParamForExperiencePrePayment(params: [String: Any]) -> Any {
        return ExPrepaymentResponse.init(object: params)
    }
    
    func separateParamForExperienceRoomAvailableStatusUrl(params: NSDictionary) -> Any {
        return CheckDateAvailablity(object: params)
    }
    //* Experience End *//
}

