//
//  English.swift
//  Makent
//
//  Created by Trioangle on 19/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//lazy var AppName : String = {return k_AppName}()

import Foundation


class English:LanguageProtocol {
    
    lazy var pleaseSelectTheStartTime : String = {return "Please select the start time"}()
    lazy var pleaseSelectTheEndTime : String = {return "Please select the end time"}()
    lazy var endTimeShouldBeGreaterThanTheStartTime : String = {return "End time should be greater than the start time"}()
    lazy var pleaseEnterCardNumber : String = {return "Please enter card number"}()
    lazy var pleaseEnterExpirationDate : String = {return "Please enter expiration date"}()
    lazy var pleaseEnterCvcNumber : String = {return "Please enter cvc number"}()
    lazy var pleaseEnterFirstName : String = {return "Please enter first name"}()
    lazy var pleaseEnterLastName : String = {return "Please enter last name"}()
    lazy var pleaseEnterPostCode : String = {return "Please enter post code"}()
    lazy var serverErrorPleaseTryAgain : String = {return "Server error please try again!"}()
    lazy var pleaseFillAllMandatory : String = {return "Please Fill All Mandatory"}()
    lazy var pleaseProvideYourSpaceIsFurnishedOrNot : String = {return "Please Provide Your Space is Furnished or Not"}()
    lazy var pleaseEnterOrAddWorkStationValue : String = {return "Please Enter or Add work station Value"}()
    lazy var pleaseSelectSharedOrPrivate : String = {return "Please Select Shared or Private"}()
    lazy var pleaseProvideAreYouRentingNewOrExperience : String = {return "Please Provide are you renting new or experience"}()
    lazy var selectedSpaceTypeIsDeActivatedByAdmin : String = {return "Selected Space Type is de-activated by admin"}()
    lazy var pleaseEnterSpaceAddress : String = {return "Please Enter Space Address"}()
    lazy var pleaseEnterValidAddress : String = {return "Please Enter Valid Address"}()
    lazy var pleaseFillMandatoryFields : String = {return "Please Fill Mandatory Fields"}()
    lazy var pleaseEnterListName : String = {return "Please Enter List Name"}()
    lazy var pleaseEnterSummary : String = {return "Please Enter Summary"}()
    lazy var pleaseEnterGuestCount : String = {return "Please enter guest count"}()
    lazy var pleaseSelectStartAndEndTime : String = {return "Please Select Start and End Time"}()
    lazy var pleaseSelectStartTime : String = {return "Please Select Start Time"}()
    lazy var pleaseSelectEndTime : String = {return "Please Select End Time"}()
    lazy var pleaseSelectAtleastOneActivityFromList : String = {return "Please Select Atleast One Activity From List"}()
    lazy var pleaseFillAllFields : String = {return "Please Fill All Fields"}()
    lazy var pleaseEnterHourlyAmountGreaterThanOrEqualMinimumAmount : String = {return "Please Enter Hourly amount greater than Or Equal minimum amount"}()
    lazy var pleaseEnterFullDayAmountGreaterThanHourlyAmount : String = {return "Please Enter Full Day amount greater than Hourly amount"}()
    lazy var pleaseEnterWeeklyAmountGreaterThanFullDayAmount : String = {return "Please Enter Weekly amount greater than Full Day amount"}()
    lazy var pleaseEnterMonthlyAmountGreaterThanWeeklyAmount : String = {return "Please Enter Monthly amount greater than Weekly amount"}()
    lazy var minimumHourRange : String = {return "Minimum hour range"}()
    lazy var pleaseChooseValidTimes : String = {return "Please choose valid times"}()
    lazy var youCannotSelectThisTimeBecauseTimeIntervalIsAHourRequired : String = {return "you cannot select this time because time interval is a hour required"}()
    lazy var pleaseSelectAddressFromList : String = {return "Please Select Address From List"}()
    lazy var applyCoupon : String = {return "Apply Coupon"}()
    lazy var coupon : String = {return "Coupon"}()
    lazy var removeCoupon : String = {return "Remove Coupon"}()
    lazy var price_title : String = { return "Pricing"}()
    lazy var people_title : String = { return "People"}()
    lazy var check_inTitle : String = { return "Check-In time"}()
    lazy var check_outTitle : String = { return "Check-Out time"}()
    lazy var yourReserv_Title : String = { return "Your Reservation"}()
    lazy var wishList_Title : String = { return "Wishlist"}()
    lazy var booking_Title : String = { return "Bookings"}()
    lazy var birth_Desc : String = { return "You Must be at least 18 years old to use"}()
    lazy var legalDocError: String = {return "Please Upload Document"}()
    lazy var prepproved_Title : String = { return "Pre-Approved"}()
    lazy var ExploreMakentSpace: String = {return "Explore \(k_AppName)"}()
    lazy var per_Hours: String = {return "per hour"}()
    lazy var AppName : String = {return ""}()
    lazy var hom_Titt : String = {return "Stay"}()
    lazy var Exp_Titt : String = {return "Experience"}()
    lazy var Homes: String = {return "Stays"}()
    lazy var Experiences: String = {return "Experiences"}()
    lazy var curLaneng : String = { return "English"}()
    lazy var curLanarb : String = { return "Arabic"}()
    lazy var curLanspn : String = { return "Spanish"}()
    lazy var chsLan : String = { return "Choose Language"}()
    lazy var eventType : String = { return "Event Type"}()
    lazy var guestTitle : String = { return "Guest"}()
    lazy var maximumGuestTitle : String = { return "Maximum guest count within"}()
    lazy var chooseTiming : String = { return "Choose Timing"}()
    lazy var noMoreDatas : String = { "No more Datas are available to show" }()
    lazy var authenticationIsNeeded : String = { return "Authentication is needed to access your Home View."}()

    //Contact Host Vc
    lazy var addStr: String = { return "Add"}()
    
    //ReviewsPageController
    lazy var reviews_Title: String = {return "Reviews"}()
    
    //ExBookingController
    lazy var steps_LeftTitle: String = {return "steps left"}()
    lazy var step_LeftTitle : String = {return "step left"}()
    lazy var lblTotText1 : String = { return "Total"}()
    lazy var lblTotalExText: String = { return "Total"}()
    lazy var network_ErrorIssue: String = {return "Server issue, Please try again."}()
    lazy var hours_Tit : String = {return "Hours"}()
    lazy var book_Title : String = {return "Book nows"}()
    lazy var continue_Title: String = {return "Continue"}()
    lazy var read_Title: String = {return "Read"}()
    lazy var agreed_Title: String = {return "Agreed"}()
    lazy var other_Title : String = {return "Other"}()
    lazy var host_ByTitle: String = {return "host by"}()
    
    //IGCommon
    lazy var could_LoadTitle: String = {return "Could not load view with type "}()
    
    //GuestPageCellTypeB -- TTTAttributedLabel
    lazy var agree_GuestPage: String = {return "When you book, you agree to \(k_AppName) Additional Terms of Service, Guest Release and Waiver, and Cancellation Policy"}()
    lazy var termsserv_Title: String = {return "terms_of_service"}()
    lazy var mak_AddTerms: String = {return "\(k_AppName) Additional Terms of Service"}()
    lazy var guestrefund_Title: String = {return "guest_refund"}()
    
    //WhosComingViewController
    lazy var who_ComingTitle: String = {return "Who's coming?"}()
    lazy var guest_Title: String = {return "Guest"}()
    
    //AddGuestController
    lazy var addguest_Title: String = {return "Keep your guests in the loop. Add their email and we'll send them the itineary."}()
    lazy var done_Title: String = {return "Done"}()
    lazy var first_NameError: String = {return "First Name can't be empty"}()
    lazy var last_NameError: String = {return "Last Name can't be empty"}()
    lazy var email_Error : String = {return "Enter your correct email"}()
    lazy var want_DeleteAlert: String = {return "Are you sure want to delete"}()
    lazy var cancel_Title: String = {return "Cancel"}()
    lazy var delete_Title: String = {return "Delete"}()
    lazy var ok_Title: String = {return "OK"}()
    lazy var notmatch_Enum: String = {return "Does not match Enum"}()
    
    //GroupSizeInfoController
    lazy var group_Title: String = {return "Group Size"}()
    lazy var thereare_Title: String = {return "There are"}()
    lazy var spotexp_Available: String = {return "spots available on this experience."}()
    lazy var groupview_DontFill: String = {return "You don't have to fill all of them. Experiences are meant to be social, so other guests could join too"}()
    lazy var grpsize_Content: String = { return "You don't have to fill all of them. Experiences are meant to be social, so other travelers could join too"}()
    
    //GuestRequirementController
    lazy var guestreq_Title: String = {return "Guest Requirements"}()
    
    //ReviewGuestRequirementsController
    lazy var weather_Title: String = {return "Weather"}()
    
    //EventCancellationPolicyController
    lazy var guestRequire_Title: String = {return "Review Guest Requirements"}()
    lazy var accountVerifi_Title: String = {return "Account Verification"}()
    lazy var makhostexpeve_Cancel : String = {return "\(k_AppName) Hosts\nExperience & Event\nCancellation policy"}()
    lazy var general_Cancel : String = {return "General Cancellation"}()
    lazy var hrs24_Refund : String = {return "Any experience or event, canceled within 24 hours of booking, is eligible for a full refund."}()
    lazy var event30_Day : String = {return "Any experience or event cancellation that is 30 days or more before the start date, is eligible for a full refund."}()
    lazy var cancel30_Day : String = {return "Cancellations less than 30 days before start date will not be eligible for a refund, unless your spot is booked and completed by another guest."}()
    lazy var days14_Refund : String = {return "Should your spot be booked and completed by another guest, a full refund will be processed within 14 days of the experience start date."}()
    lazy var cancel_Reason : String = {return "However, if the reason for cancellation meets out Extenuating Circumstances policy, you will be refunded in full."}()
    lazy var account_Verif : String = {return " Should any member of your party be unable to complete the account verification process within 3 days of purchase, all portions and spots for the experience or event will be canceled and fully refunded."}()
    lazy var hostoffr_Msg : String = {return "Hosts make every effort to continue, as scheduled, with experience or events. Should bad weather conditions create an unsafe scenario for guests or hosts, a change or partial cancellation of an itinerary or activity may be the result. Should an individual experience or event be canceled by host or guest, or should an itinerary substantially change or result in a cessation of the trip, \(k_AppName) will work with your host to provide an appropriate refund. To officially request a cancellation of your experience or event, please contact us."}()
    
    //ExRoomDetailCell
    lazy var hours_Total: String = {return "hours total"}()
    lazy var offer_In: String = {return "Offered in"}()
    lazy var exp_Title: String = {return "experience"}()
    lazy var total_Hours: String = {return "Total Hours"}()
    lazy var choose_your_country = {return "Choose your country"}()
    lazy var request_book = {return "Request to Book"}()
    lazy var instant_book = {return "Instant Book"}()
    
    /// similarList Details
    lazy var hourly_Rate: String = {return "Hourly Rate"}()
    lazy var full_Day_Rate: String = {return "Full Day Price"}()
    lazy var minimum_Booking_Hours: String = {return "Minimum Booking Hours"}()
    
    //CancelRequestVC
    lazy var canres_Tit : String = {return "Cancel this Reservation"}()
    lazy var can_Reser : String = {return "Cancel My Reservation"}()
    
    //Pre-AcceptVC
    lazy var preacc_Req : String = {return "Pre-Accept this request"}()
    lazy var opt_Msg : String = {return "Type optional message to guest..."}()
    
    //AddPhotoVC
    lazy var edt_Title : String = {return "Edit"}()
    
    //Reservation
    lazy var view_Det : String = {return "View Details"}()

    //ReservationDetailVC
    lazy var whycancel_Tit :String = {return "Why are you Cancelling?"}()
    lazy var mypla_Long :String = {return "My place is longer available"}()
    lazy var wntoff_List :String = {return "I want to offer a different listing or change the price"}()
    lazy var need_Maintain :String = {return "My place needs maintenance"}()
    lazy var exten_Circum :String = {return "I have an extenuating circumstance"}()
    lazy var gues_Cancel :String = {return "My guest needs to cancel"}()
    lazy var why_Dec :String = {return "Why are you declining?"}()
    lazy var errorinCancel: String = { return "Select a Valid Reason"}()
    lazy var date_Avail :String = {return "Dates are not available"}()
    lazy var notfeel_Comfort :String = {return "I do not feel comfortable with this guest"}()
    lazy var list_NotGood :String = {return "My listing is not a good to fit for the guest's needs (children, pets, ets.)"}()
    lazy var wait_Attract :String = {return "I'm waiting for a more attractive reservation"}()
    lazy var ask_Diff :String = {return "The guest is asking for different dates than the ones selected in this request"}()
    lazy var msg_Spam :String = {return "This message is spam"}()
    lazy var nolong_Accom : String = {return "I no longer need accommodations"}()
    lazy var mytrav_Dat : String = {return "My travel dates changed"}()
    lazy var res_Acc : String = {return "I made the reservation by accident"}()
    lazy var hos_Cancel : String = {return "My host needs to cancel"}()
    lazy var uncomfor_Host : String = {return "I’m uncomfortable with the host"}()
    lazy var plc_Expect : String  = {return "The place isn't what I was expecting"}()
    
    //ExperienceDetailsController
    lazy var meethost_Title: String = {return "Meet Your Host"}()
    lazy var addanogues_Title : String = {return "Add Another Guest"}()
    lazy var whatwldo_Title: String = {return "What we'll do"}()
    lazy var whatill_Title : String = { return "What i'll provide"}()
    lazy var whatwdo_Title: String = {return "What we'll provide"}()
    lazy var notes_Title: String = {return "Notes"}()
    lazy var whocom_Title: String = {return "Who can come"}()
    lazy var whrwlbe_Title: String = {return "Where we'll be"}()
    lazy var grpsiz_Title: String = {return "Group size up to"}()
    lazy var seedates_Title: String = {return "See dates"}()
    lazy var expcan_Policy: String = {return "Experience cancellation policy"}()
    lazy var conthost_Title: String = {return "Contact host"}()
    lazy var insbook_Title: String = {return "Instant Book"}()
    lazy var reqbook_Title: String = {return "Request to book"}()
    lazy var checkout_Awesom: String = {return "Check out this awesome House on"}()
    lazy var rev_Title: String = {return "Review"}()
    lazy var revs_Title: String = {return "Reviews"}()
    lazy var perpers_Title: String = {return "per person"}()
    lazy var whatiprov_Title : String = {return "what i provide"}()
    
    //ExMeetYourHostCell attributed  ..Read More
    //ExContactHostController
    lazy var contreq_Send: String = {return "Contact request has send to"}()
    lazy var need_More: String = {return "Need more info about Instagram worthy hike in"}()
    lazy var write_Mess: String = {return "Write a message..."}()
    
    //ContactHostTypeACell -- TTTAttributedLabel
    lazy var faq_Msg : String = {return "If you have general questions about how experience work, visit or FAQ"}()
    lazy var faq_Title : String = {return "visit or FAQ"}()
    
    //ExperienceCalenderController
    lazy var sel_MulDat: String = {return "Select Multiple Dates"}()
    lazy var whrlik_Msg : String = {return "When would you like to go ?"}()
    lazy var choos_Tit : String = {return "Choose"}()
    lazy var perprsn_Tit : String = {return "per person"}()
    lazy var sun_Title: String = {return "Sunday"}()
    lazy var mon_Title: String = {return "Monday"}()
    lazy var tue_Title: String = {return "Tuesday"}()
    lazy var wed_Title: String = {return "Wednesday"}()
    lazy var thurs_Title: String = {return "Thursday"}()
    lazy var fri_Title: String = {return "Friday"}()
    lazy var sat_Title: String = {return "Saturday"}()
    lazy var date_Error: String = {return "The date must be a date after today."}()
    
    //ExCellMapHolderView
    lazy var wher_wlmeet: String = {return "ExCellMapHolderView"}()
    
    //CategorySelectionController
    lazy var sel_cats: String = {return "Select categories"}()
    
    //SearchVC
    lazy var where_To : String = {return "Where to?"}()
    lazy var nearby_Tit : String = {return "Nearby"}()
    lazy var crtlist_Tit : String = {return "CreatedList"}()
    lazy var anywhere_Tit : String = {return "Anywhere"}()
    lazy var clr_Tit : String = {return "Clear"}()
    
    //ProfileSettings
    lazy var termser_Title : String = {return "Terms of Service"}()
    
    //SplashVC
    lazy var switch_Travel: String = {return "Switching to Travelling"}()
    lazy var switch_Host: String =  {return "Switching to Hosting"}()
    lazy var reser_Title: String = {return "RESERVATIONS"}()
    lazy var cal_Title: String = {return "CALENDAR"}()
    lazy var list_Title: String = {return "LISTING"}()
    lazy var prof_Title: String = {return "PROFILE"}()
    lazy var expl_Title: String = {return "Explore"}()
    lazy var save_Title: String = {return "Saved"}()
    lazy var trip_Title: String = {return "Trips"}()
    lazy var inbox_Title: String = {return "Inbox"}()
    lazy var profl_Title: String = {return "Profile"}()
    lazy var login_Title: String = {return "Log In"}()
    
    //TripsVC
    lazy var Trips_Msg1 : String = {return "What will be  your first adventure?"}()
    lazy var Trips_Msg2 : String = {return "You'll find your trip itineraries here"}()
    lazy var pend_Trip : String = {return "Pending Trips"}()
    lazy var upcom_Trip : String = {return "Upcoming Trips"}()
    lazy var prev_Trip : String = {return "Previous Trips"}()
    lazy var curren_Trip : String = {return "Current Trips"}()
    
    //TripsDetailVC
    lazy var inq_Title : String = {return "Inquiry"}()
    
    lazy var canld_Tit : String = {return "Cancelled"}()
    lazy var decld_Tit : String = {return "Declined"}()
    lazy var exp_Tit : String = {return "Expired"}()
    lazy var accep_Tit : String = {return "Accepted"}()
    lazy var preaccep_Tit : String = {return "Pre-Accepted"}()
    lazy var pend_Tit : String = {return "Pending"}()
    
    //ForgotPassword
    lazy var forpass_Tit : String = {return "Forgot your password?"}()
    lazy var emailadd_Tit : String = {return "EMAIL ADDRESS"}()
    lazy var enter_Email : String = {return "Enter your email to find your account."}()
    
    //SignUpVC
    lazy var wht_Name : String = {return "What's your name?"}()
    lazy var frstname_Tit : String = {return "FIRST NAME"}()
    lazy var lstname_Tit : String = {return "LAST NAME"}()
    
    //SignUpEmail
    lazy var yremail_Tit : String = {return "And, your email?"}()
    lazy var remem_Tit : String = { return "Remember me"}()
    
    //SignUpPassword
    lazy var shw_Tit : String = {return "Show"}()
    lazy var emp_Pass : String = { return "Please Enter Password"}()
    lazy var eight_Pass : String = { return "Password Must Contain 8 Characters"}()
    lazy var crt_Pass : String = {return "Create a password"}()
    lazy var pas_Tit : String = {return "PASSWORD"}()
    
    //SignUpDOB
    lazy var whn_Bith : String = {return "When is your birthday?"}()
    lazy var birth_Tit : String = {return "BIRTHDAY"}()
    
    //MLImagePickerController
    lazy var allphoto_Title : String = {return "All Photos"}()
    lazy var back_Title: String = {return "Back"}()
    lazy var add_Title: String = {return "Add"}()
    lazy var photoexeed_Title: String = {return "Choose a photo that can not be exceeded"}()
    
    //LoadWebView
    lazy var pay_Succes : String = {return "Payment Successfully Paid"}()
    lazy var prepy_Succes : String = {return "Pre payment data listed successfully"}()
    lazy var paymnt_Succes : String = {return "Payment has Successfully Completed."}()
    
    //MainVC
    lazy var bysign_Agree : String = {return "By Signing up,I agree to"}()
    lazy var lugg_Terms : String = {return "\(k_AppName) Terms of Service,Privacy Policy,Guest Refund Policy,Host Guarantee Terms"}()
    lazy  var priv_Policy : String = {return "Privacy Policy"}()
    lazy  var guesrefun_Policy : String = {return "Guest Refund Policy"}()
    lazy  var hosguar_Terms : String = {return "Host Guarantee Terms"}()
    lazy var conti_Fb : String = {return "Continue with Facebook"}()
    lazy var login_Tittle : String = {return "Log in"}()
    lazy var conti_Google : String = {return "Continue With Google"}()
    lazy var crt_Acc : String = {return "Create Account"}()
    lazy var welcm_To : String = {return "Welcome to"}()
    lazy var confb_Title: String = {return "Connect with Facebook"}()
    lazy var postals_Tit : String = {return "Postals"}()
    lazy var congoog_Title: String = {return "Login with Google"}()
    lazy var dont_Acc : String = {return "Don't have account yet?"}()
    lazy var forg_Tit : String = {return "Forgot Password?"}()
    lazy var regishere_Title : String = {return "REGISTER here"}()
    lazy var orr_Title : String = {return "OR"}()
    lazy var somemp_Title : String = {return "Some fields are empty!!"}()
    lazy var crctval_Title : String = {return "Please enter correct value"}()
    lazy var errcongoog_Title : String = {return "Error configuring Google services:"}()
    lazy var email_Title: String = {return "Email"}()
    lazy var pass_Title: String = {return "Password"}()
    
    //SignUpPassword
    lazy var show_Title: String = {return "Show"}()
    lazy var hide_Title: String = {return "Hide"}()
    
    
    //SignUpDOB
    lazy var signuppass_Title : String = {return "SignUpPassword"}()
    lazy var otherppl_Title : String = {return "Other people won't see your birthday"}()
    
    //ForgotPassVC
    lazy var checkem_Title: String = {return "Check Your Email"}()
    lazy var wesen_Email: String = {return "We sent an email to"}()
    lazy var tap_Link: String = {return "Tap the link in that email to reset your password."}()
    lazy var acc_Title: String = {return "Accounts"}()
    lazy var pls_Log: String = {return "Please login to a Facebook account to share."}()
    lazy var email_NotSend: String = {return "Could Not Send Email"}()
    lazy var email_NotSendMsg: String = {return "your device could not send e-mail. Please check e-mail configuration and try again."}()
    lazy var sprd_Msg: String = {return "Spread the words of lord by sharing this"}()
    lazy var holy_Title: String = {return "Holy"}()
    lazy var offline_Title: String = {return "Offline V1.0"}()
    
    //ExploreVC
    lazy var inter_Error: String = {return "Please check your Internet Connection"}()
    lazy var pullref_Title: String = {return "Pull to refresh"}()
    lazy var anytime_Title: String = {return "Anytime"}()
    lazy var anywhere_Title: String = {return "AnyWhere"}()
    lazy var nomore_DataErr: String = {return "No more data available..."}()
    lazy var unexp_KindErr: String = {return "Unexpected element kind"}()
    lazy var opentim_Title: String = {return "Open Time"}()
    lazy var clstim_Title: String = {return "Close Time"}()
    lazy var retry_Title: String = {return "Retry"}()
    lazy var caphome_Tit : String = {return "HOMES"}()
    lazy var capexp_Tit : String = {return "EXPERIENCES"}()
    lazy var caprest_Tit : String = {return "RESTAURANT"}()
    lazy var remfilt_Tit : String = {return "Remove all filters"}()
    lazy var remfilt_Msg : String = {return "We couldn't find any listings. Try removing your filters."}()
    lazy var map_Tit : String = {return "MAP"}()
    lazy var filt_Tit : String = {return "FILTER"}()
    lazy var clrall_Tit : String = {return "Clear All"}()
    
    //CategorySelection
    lazy var whattodo_Tit : String = {return "What to do?"}()
    
    //AlertView
    lazy var offerr_Title: String = {return "Error: You are currently offline"}()
    lazy var off_Err: String = {return "You are currently offline"}()
    lazy var error_Tit: String = {return "Error:"}()
    
    //FilterVC
    lazy var amenit_Tit : String = {return "Amenities"}()
    lazy var baths_Tit : String = {return "Bathrooms"}()
    lazy var beddrms_Title : String = {return "Bedrooms"}()
    lazy var rese_Titl : String = {return "Reset"}()
    lazy var seeall_Ameniti : String = {return "See all amenities"}()
    lazy var instbk_Only : String = {return "Instant Book Only"}()
    lazy var instbk_Msg : String = {return "Book without waiting for the host to respond"}()
    lazy var filts_Tit : String = {return "Filters"}()
    lazy var beds_Tit: String = {return "beds"}()
    lazy var bedroom_Tit: String = {return "bedrooms"}()
    lazy var bath_Tit: String = {return "bathrooms"}()
    
    //MapRoomCell
    lazy var nothing_Title : String = {return "Nothing saved yet"}()
    lazy var listing_Title : String = {return "Listing"}()
    lazy var listings_Title: String = {return "Listings"}()
    
    //SearchVC
    lazy var locpermisson_Tit : String = {return "Location Permission"}()
    lazy var grant_Tit: String = {return "Please grant"}()
    lazy var locset_Title: String = {return "access to your location through settings > privacy > location services."}()
    lazy var setting_Title: String = {return "Settings"}()
    lazy var popdest_Title: String = {return "Popular Destinations"}()
    
    //HostInboxVC
    lazy var nores_Req : String = {return "No Reservation Requests"}()
    lazy var nores_mess : String = {return "You have no reservation requests or booking inquiries to respond to right now."}()
    lazy var resers_Title: String = {return "Reservations"}()
    lazy var preacc_Title : String = {return "Pre-Accepted"}()
    lazy var preAccepted: String = {return "Pre-Accept"}()
    //SpaceType
    lazy var listsp_Tit : String = {return "List Your Space"}()
    lazy var listsp_Mes : String = {return "What type of space do you want to list?"}()
    
    //PropertyType
    lazy var proptyp_Tit : String = {return "Property Type"}()
    lazy var proptyp_Msg : String = {return "Nice What type of place is your entire home in?"}()
    lazy var mr_Tit : String = {return "more"}()
    
    //FilterRoomTypes
    lazy var rom_Typs : String = {return "Space Types"}()
    
    //Location
    lazy var loc_Tit : String = {return "Location"}()
    lazy var loc_Msg : String = {return "What city is your appartment located in"}()
    lazy var next_Tit : String = {return "Next"}()
    
    //DescriptionsDetailPageVC
    lazy var det_Desc : String = {return "Detail Descriptions"}()
    
    //RoomDetailPage
    lazy var checkavail_Title: String = {return "Check availability"}()
    lazy var ament_Tit : String = {return "Amenity"}()
    lazy var mssg_Titt : String = {return "Message"}()
    lazy var cnthst_Tit : String = {return "Contact Host"}()
    lazy var smap_Tit : String = {return "Map"}()
    lazy var features_Tit: String = {return "Feature"}()
    lazy var space_Tit: String = {return "Space"}()
    lazy var available_TimeTit: String = {return "AvailableTime"}()
    lazy var festievnt_Tit: String = {return "Festival"}()
    lazy var abt_Tit : String = {return "About"}()
    lazy var prop_Tit : String = {return "Property"}()
    lazy var descs_Title : String = {return "Descriptions"}()
    lazy var availb_Tit : String = {return "Availability"}()
    lazy var abt_SerTit : String = {return "About this Listing"}()
    lazy var chk_Tit : String = {return "Check"}()
    lazy var simlist_Title : String = {return "Similar Listing"}()
    lazy var stexp_Title : String = {return "Start exploring"}()
    lazy var pernight_Title: String = {return "per night"}()
    lazy var perday_Title : String = {return "per day"}()
    lazy var cancelpolicy_Title: String = {return "Cancellation Policy"}()
    lazy var houserules_Title: String = {return "House Rules"}()
    lazy var additionalprice_Title: String = {return "Additional Prices"}()
    lazy var checkavailab_Title: String = {return "Check Availability"}()
    lazy var contachost_Title: String = {return "Contact to Host"}()
    lazy var triplength_Title: String = {return "Trip Length"}()
    lazy var caproom_Title: String = {return "Rooms"}()
    lazy var capguest_Title: String = {return "Guests"}()
    lazy var capbed_Title: String = {return "Beds"}()
    lazy var capbath_Title: String = {return "Bathroom"}()
    lazy var redmore_Title: String = {return "..read more"}()
    lazy var hostby_Title: String = {return "Hosted by"}()
    
    
    /// Event Page Error Message
    lazy var choose_Activity: String = {return "Please Choose your Activity"}()
    lazy var choose_Dates: String = {return "Please Choose your Dates"}()
    lazy var add_GuestCount: String = {return "Please add your guest count"}()
    lazy var maximum_guestcount: String = {return "Maximum guest cound should be"}()
    
    //Choose Time Error Message
    lazy var endTimeErrorMsg : String = {return "Please select start time"}()
    
    /// TimeChoosing Page Hints
    lazy var startTime: String = {return "Start time"}()
    lazy var endTime: String = {return "End time"}()

    //Error Messages
    lazy var nodat_Found : String = {return "No Data Found"}()
    
    //PriceBreakdown
    lazy var price_Msg : String = {return "This helps us run our platform and offer services like 24/7 support on your trip."}()
    lazy var pay_Brk : String = {return "Payment Breakdown"}()
    
    //WWCalendarTimeSelector
    lazy var strtdat_Title: String = {return "Start date"}()
    lazy var enddat_Title: String = {return "End date"}()
    lazy var checkin_Title: String = {return "Check-in"}()
    lazy var date_Req: String = { return "Check In Date is required"}()
    lazy var checkout_Title: String = {return "Check-out"}()
    lazy var save_Tit: String = {return "Save"}()
    lazy var thosdate_Err: String = {return "Those dates are not available"}()
    
    //ReviewCell
    lazy var readall_Title: String = {return "Read all"}()
    
    //ShareVC
    lazy var twitlog_Err: String = {return "Please login to a Twitter account to share."}()
    lazy var checkout_Msg: String = {return "Check out this great place to stay in"}()
    lazy var hey_Title : String = {return "Hey,"}()
    lazy var grt_Place : String = {return "I found a great place to stay in"}()
    lazy var whtthnk_Title : String = {return "What do you think?"}()
    lazy var on_Tit : String = {return "on"}()
    
    //ContactHostVC
    lazy var hostedby_Title: String = {return "hosted by"}()
    lazy var yourmsg_Title: String = {return "Your Message"}()
    lazy var aapreciate_Msg: String = {return "Hosts appreciate a thoughtful hello"}()
    lazy var change_Title: String = {return "Change"}()
    lazy var msghst_Tit : String = {return "Message Host"}()
    lazy var dat_Title : String = {return "Date"}()
    lazy var guess_Tit : String = {return "Guests"}()
    lazy var mnthly_Title : String = {return "monthly"}()
    lazy var wekly_Title : String = {return "weekly"}()
    lazy var nigt_Title : String = {return "night"}()
    lazy var dayy_Title : String = {return "day"}()
    lazy var dayys_Title : String = {return "days"}()
    
    //AddHostMessageVC
    lazy var int_Yrslf : String = {return "Introduce yourself"}()
    lazy var tel_Tit : String = {return "Tell"}()
    lazy var tel_Desc : String = {return "a bit about yourself and your trip."}()
    
    //AddMessageVC
    lazy var stps_Lftbk : String = {return "Steps left to book"}()
    lazy var seepric_Dwn : String = {return "See price breakdown"}()
    
    //AdditionalPrice
    lazy var ext_Peop : String = {return "Extra People"}()
    lazy var sec_Dep : String = {return "Security Deposit"}()
    lazy var clean_Fee : String = {return "Cleaning Fee"}()
    lazy var addpric_Msg: String = {return "You can give discounts for your list from our website"}()
    lazy var staydiscount_Title: String = {return "Length of stay discounts"}()
    lazy var earlydiscount_Title: String = {return "Early bird discounts"}()
    lazy var lastdisc_Title: String = {return "Last min discounts"}()
    
    //RoomsHouseRules
    lazy var abthome_Title: String = {return "About this home"}()
    lazy var agree_Titlle : String = {return "Accept"}()
    
    //AmenitiesVC
    lazy var wifi_Tit : String = {return "Wifi"}()
    lazy var aircond_Tit : String = {return "Air Conditioning"}()
    lazy var pool_Tit : String = {return "Pool"}()
    lazy var kit_Tit : String = {return "Kitchen"}()
    lazy var park_Tit : String = {return "Parking"}()
    lazy var brkfst_Tit : String = {return "Breakfast"}()
    lazy var indoor_Tit : String = {return "Indoor fireplace"}()
    lazy var heat_Tit : String = {return "Heating"}()
    lazy var fam_Tit : String = {return "Family Friendly"}()
    lazy var wash_Tit : String = {return "Washer"}()
    lazy var dry_Tit : String = {return "Dryer"}()
    lazy var esst_Tit : String = {return "Essentials"}()
    lazy var shmp_Tit : String = {return "Shampoo"}()
    lazy var hairdry_Tit : String = {return "Hair dryer"}()
    lazy var iron_Tit : String = {return "Iron"}()
    
    //WhishListVC
    lazy var notlog_WishMsg : String = {return "Collect places to stay and things to do by tapping the heart icon"}()
    lazy var nowish_Tit : String = {return "No Wish Lists"}()
    lazy var nowish_Msg : String = {return "You have no wish lists right now."}()
    lazy var find_HomeTit : String = {return "Find homes"}()
    
    //CreateWhishList
    lazy var creat_List : String = {return "Create a list"}()
    lazy var creat_Tit : String = {return "Create >"}()
    lazy var privacy_Tit : String = {return "Privacy"}()
    
    //AddGuestEmailCell
    lazy var email_Opt : String = {return "Email address (optional)"}()
    
    //AddWhishListVC
    lazy var pub_Title : String = {return "Public"}()
    lazy var pri_Title : String = {return "Private"}()
    lazy var chs_Tit : String = {return "Choose a list"}()
    lazy var visible_Msg: String = {return "Visible to everyone and included on\nyour public"}()
    lazy var profi_Title: String = {return "Profile"}()
    lazy var visiblefrnd_Msg: String = {return "Visible only to you and any friends you invite"}()
    
    //ExpReceiptHeaderView
    lazy var hourexp_Title: String = {return "hours experience"}()
    lazy var tott_Tit : String = {return "Total"}()
    
    //WhishListDetailsVC
    lazy var avail_exps : String = {return "available experiences"}()
    lazy var avail_hom : String = {return "available home"}()
    lazy var nothingsave_Desc : String = {return "When you see something you link, tap on the heart to save it. If you're planning a trip with others, invite them so they can saved and vote on their favorites."}()
    lazy var avail_homs : String = {return "available homes"}()
    lazy var wish_name : String = {return "Please enter the wishlist name"}()
    lazy var sav_Chgs : String = {return "Save Changes"}()
    lazy var tit_Titl : String = {return "Title"}()
    lazy var wis_Name : String = {return "Wish List Name..."}()
    lazy var wis_Updt : String = {return "WishList Updated Successfully"}()
    lazy var wislis_Every : String = {return "The list is now visible to everyone"}()
    lazy var wislis_Vis : String = {return "The list is now visible to you only"}()
    lazy var mak_Pub : String = {return "Make Public"}()
    lazy var mak_Priv : String = {return "Make Private"}()
    lazy var del_List : String = {return "Delete This List"}()
    lazy var rem_List : String = {return "Remove Listing"}()
    lazy var rem_Tit : String = {return "Remove"}()
    
    //PriceBreakDown
    lazy var nights_Title: String = {return "nights"}()
    lazy var nightsin_Title: String = {return "nights in"}()
    lazy var totalpayout_Title: String = {return "Total payout"}()
    lazy var hostfee_Title: String = {return "Host Fee"}()
    lazy var servicefee_Title: String = {return "Service fee"}()
    lazy var totlaprice_Title: String = {return "Total price"}()
    
    //DiscountPageVC
    lazy var nostay_Disc : String = {return "No Length of Stay Discounts Found"}()
    lazy var nobir_Disc : String = {return "No Early Bird Discounts Found"}()
    lazy var nolst_Disc : String = {return "No Last Minute Discounts Found"}()
    lazy var night_Tit : String = {return "Nights"}()
    lazy var percen_Tit : String = {return "Percentage"}()
    lazy var setpric_Msg : String = {return "You can set a price to reflect the space, amenities, and hospitality you'll be providing"}()
    lazy var givdis_Msg : String = {return "You can give discounts for your list from our website"}()
    
    //MaxMinStay1
    lazy var minmx_Stay : String = {return "Min and Max Stay"}()
    lazy var min_Stay : String = {return "Minimum stay"}()
    lazy var max_Stay : String = {return "Maximum stay"}()
    lazy var req_Msg : String = {return "Add requirements for seasons or weekends"}()
    
    //CustomMinMax
    lazy var  reser_Sett : String = {return "Reservation Settings"}()
    lazy var cus_Tit : String = {return "Custom"}()
    lazy var sel_Dat : String = {return "Select Dates"}()
    lazy var close_Tit : String = {return "Close"}()
    lazy var ent_Sdt : String = {return "Enter Start Date"}()
    lazy var ent_Edt : String = {return "Enter End Date"}()
    
    //FilterRoomTypes
    lazy var shareroom_Msg: String = {return "\nNote: This is a shared room"}()
    
    //BookingVC
    lazy var Book_Now : String = {return "Book now"}()
    lazy var hostmsg_Title : String = {return "Host Message"}()
    lazy var chkin_Tit : String = {return "Check in"}()
    lazy var chkout_Tit : String = {return "Check out"}()
    lazy var edit_Title: String = { return "Edit"}()
    
    //SelectionCountryVC
    lazy var sel_Coun : String = {return "Select Country"}()
    
    //MakePaymentVC
    lazy var select_Pay : String = {return "Select your payment method"}()
    lazy var add_Pay : String = {return "Add Payment"}()
    lazy var paypal_Tit : String = {return "PayPal"}()
    lazy var crdit_Titlt : String = {return "Credit Card"}()
    
    //HostMessageVC
    lazy var editmsg_Title : String = {return "Edit Message"}()
    lazy var addmsg_Title : String = {return "Add Message"}()
    
    //HouseRulesVC
    lazy var houserule_Msg1: String = {return "When you stay in an "}()
    lazy var houserule_Msg2: String = {return "you're staying in someone's home. You'll need to agree to Simon & Wendy's house rules before you can book."}()
    
    //inboxVC
    lazy var msghost_Msg: String = {return "Messages from your host will appear here"}()
    lazy var resub_Tit : String = { return "Resubmit"}()
    lazy var nomsg_Msg: String = {return "You have no messages"}()
    lazy var youhav_No : String = {return "You have no"}()
    lazy var youhave_Title: String = {return "You have"}()
    lazy var unreadmsg_Title: String = {return "unread messages"}()
    lazy var nounread_Msg: String = {return "You have no unread messages"}()
    lazy var guessts_Tit : String = {return "guests"}()
    lazy var guesss_Tit : String = {return "guest"}()
    
    //Update Location
    lazy var street_Tit : String = {return "Street"}()
    lazy var aptbuild_Tit : String = {return "Apt/Building"}()
    lazy var zip_Titt : String = {return "zip"}()
    
    //Inbox DetailVC
    lazy var payment_Title: String = {return "Payment"}()
    lazy var discount_Title: String = {return "discount"}()
    lazy var lengthdis_Title: String = {return "length of stay discount"}()
    lazy var customer_Title: String = {return "Customer Receipt"}()
    lazy var Cancelreq_Title : String = {return "Cancel Request"}()
    lazy var MsgHis_Title : String = {return "Message History"}()
    
    //ConversationVC
    lazy var preapprove_Title: String = {return "Pre-Approve"}()
    lazy var cancelreser_Title: String = {return "Cancel Reservation"}()
    lazy var archive_Title: String = {return "Archive"}()
    lazy var help_Title: String = {return "Help"}()
    lazy var write_Msg : String = {return "Write a message"}()
    
    //HostinboxVC
    lazy var noreser_Msg: String = {return "You have no reservation"}()
    lazy var expires_Title: String = {return "Expires"}()
    lazy var discuss_Title: String = {return "Discuss"}()
    lazy var msghist_Title: String = {return "Message History"}()
    lazy var totalcost_Title: String = {return "TotalCost"}()
    lazy var decline_Title: String = {return "Decline"}()
    lazy var addguestfee_Title: String = {return "Additional Guest fee"}()
    lazy var secfee_Title: String = {return "Security fee"}()
    lazy var cleanfee_Title: String = {return "Cleaning fee"}()
    lazy var reser_Tit : String = {return "reservation"}()
    lazy var resers_Tit : String = {return "reservations"}()
    lazy var yes_Tit : String = {return "Yes"}()
    lazy var no_Tit : String = {return "No"}()
    
    //PreAcceptVC
    lazy var thisreq_Title : String = {return "this request"}()
    
    //TripHistoryVC
    lazy var send_Title : String = {return "Send"}()
    
    //ViewReceipt
    lazy var hostapp_Msg : String = {return "Host appreciate a thoughtful hello"}()
    
    //StripeVC
    lazy var male_Title: String = {return "Male"}()
    lazy var female_Title: String = {return "Female"}()
    lazy var acc_NumTit: String = {return "Account Number"}()
    lazy var brnch_Nam : String = {return "Branch Name"}()
    lazy var bank_Cd : String = {return "Bank Code"}()
    lazy var acc_OwnName : String = {return "Account Owner Name"}()
    lazy var bankst_Tit : String = {return "BSB"}()
    lazy var clrcod_Tit : String = {return "Clearing Code"}()
    lazy var brnch_Tit : String = {return "Branch Code"}()
    lazy var phn_Num : String = {return "Phone Number"}()
    lazy var trnas_Num : String = {return "Transit Number"}()
    lazy var acc_OwnNa : String = {return "Account Owner Name"}()
    lazy var intnum_Tit : String = {return "Institution Number"}()
    lazy var rount_Num : String = {return "Rounting Number"}()
    lazy var ssn4_Tit : String = {return "SSN Last 4 Digits"}()
    lazy var bnk_namme : String = {return "Bank Name"}()
    lazy var bnk_Code : String = {return "Bank Code"}()
    var srtcd_Tit : String  = {return "Sort Code"}()
    lazy var takephoto_Title: String = {return "Take Photo"}()
    lazy var choosephoto_Title: String = {return "Choose Photo"}()
    lazy var error_Title: String = {return "Error"}()
    lazy var legal_Doc : String = {return "Legal Document"}()
    lazy var additional_Doc : String = { return "Additional Document"}()
    lazy var nocam_Error: String = {return "Device has no camera"}()
    lazy var updatlegal_Error: String = {return "Please update a legal document."}()
    lazy var updatAddition_Error: String = {return "Please update a additional document."}()
    lazy var acc_HoldName : String = {return "Account Holder Name"}()
    lazy var add1_Val : String = {return "Address1"}()
    lazy var strip_Det : String = {return "Stripe Details"}()
    lazy var stat_Prov : String = {return "State/Province"}()
    lazy var iban_Num : String = {return "IBAN Number"}()
    
    //ProfileSettings
    lazy var profset_Payout : String = {return "Payout Methods"}()
    lazy var vers_Tit : String = {return "Version"}()
    lazy var logot_Tit : String = {return "Logout"}()
    
    //ViewProfileVC
    lazy var memsin_Tit : String = {return "Member Since"}()
    lazy var verif_Info : String = {return "Verify Info"}()
    lazy var firstname_Tit : String = {return "First name"}()
    lazy var lastname_Tit : String = {return "Last name"}()
    lazy var abtme_Tit : String = {return "About me"}()
    lazy var gender_Tit : String = {return "Gender"}()
    lazy var bithdt_Tit : String  = {return "Birth date"}()
    lazy var loca_Tit : String = {return "Location"}()
    lazy var schl_Tit : String = {return "School"}()
    lazy var wrk_Tit : String = {return "Work"}()
    
    lazy var frst_Nam : String = {return "Enter First name"}()
    lazy var lst_Nam : String = {return "Enter Last name"}()
    lazy var abt_Me : String = {return "About me"}()
    lazy var sel_Gen : String = {return "Select Gender"}()
    lazy var sel_DOb : String = {return "Select Birth date"}()
    lazy var ent_Email : String = {return "Enter Email"}()
    lazy var ent_Loc : String = {return "Enter Location"}()
    lazy var ent_Sch : String = {return "Enter School"}()
    lazy var ent_wrk : String = {return "Enter Work"}()
    lazy var edt_Titl : String = {return "Edit Title"}()
    
    //ProfileVC
    lazy var travel_Title: String = {return "travel"}()
    lazy var swit_Tit : String = {return "switch"}()
    lazy var switchhost_Title: String = {return "Switch to Host"}()
    lazy var switchtravel_Title: String = {return "Switch to Travel"}()
    lazy var viewedt_Tit : String = {return "View and edit profile"}()
    lazy var helpandsup_Title: String = {return "Help & Support"}()
    lazy var whyhost_Title: String = {return "Why host"}()
    lazy var editprof_Title: String = {return "Edit Profile"}()
    
    //EditProfileVC
    lazy var upload_Error : String = {return "Upload failed. Please try again"}()
    lazy var notspeci_Title : String = {return "Not Specified"}()
    
    //AboutPayout
    lazy var payout_Tit : String = {return "Payouts"}()
    lazy var setup_Title : String = {return "Set up your"}()
    lazy var def_Tit : String = {return "Default"}()
    lazy var mk_Deftit : String = {return "Make Default"}()
    lazy var dele_Tit : String = {return "Delete"}()
    lazy var paypal_Meth : String = {return "Add Paypal Payout"}()
    lazy var submit_Tit : String = {return "Submit"}()
    lazy var stripe_Meth : String = {return "Add Stripe Payout"}()
    lazy var payoutmeth_Title : String = {return "payout method"}()
    lazy var updatedob_Error: String =  {return "Please update the DOB In EditProfile"}()
    lazy var payot_Msg : String = {return "Your payout is what you earn from hosting a guest. Payouts are sent 24 hours after each check-in."}()
    
    //PayoutDetails
    lazy var address_Title : String = {return "Address"}()
    lazy var paypal_EmailId : String = {return "Paypal Email Id"}()
    lazy var addresspay_Title : String = {return "Address for PAYPAL"}()
    lazy var address2_Title : String = {return "Address 2"}()
    lazy var city_Title : String = {return "City"}()
    lazy var state_Title : String = {return "State"}()
    lazy var postal_Title : String = {return "Postal Code"}()
    lazy var country_Title : String = {return "Country"}()
    lazy var paypal_EmailErr : String = {return "Please enter Paypal email id"}()
    lazy var addr_FieldErr : String = {return "Please fill Address field"}()
    lazy var city_FieldErr : String = {return "Please fill City field"}()
    lazy var state_FieldErr : String = {return "Please fill State field"}()
    lazy var postalcode_FieldErr : String = {return "Please fill Postal Code field"}()
    lazy var country_FieldErr : String = {return "Please fill Country field"}()
    
    //TripLengthVC
    lazy var guestmin_Title : String = {return "Guest Stay For Minimum"}()
    lazy var during_Title : String = {return "During"}()
    lazy var night_Title : String = {return "Nights"}()
    lazy var guestmax_Title : String = {return "Guest Stay For Maximum"}()
    
    //EditEarliyDiscountsVc
    lazy var earlybird_Disc : String = {return "Early Bird Discounts"}()
    lazy var lastmin_Disc : String = {return "Last min Discounts"}()
    lazy var discpercent_Err : String = {return "Please enter the discount percentage"}()
    lazy var numofnight_Err : String = {return "Please enter the number of nights"}()
    
    //EditLengthOfDiscountsVC
    lazy var choosenight_Error : String = {return "Please choose a nights"}()
    lazy var selnigh_Tit : String = {return "Select nights"}()
    
    //CustomMinMaxVC
    lazy var edt_Tit : String  = {return "edit"}()
    lazy var choose_DtError : String = {return "Please choose a Dates"}()
    lazy var choosestdate_Error : String = {return "Please choose Start date"}()
    lazy var chooseeddate_Error : String = {return "Please choose End date"}()
    lazy var minsty_Error : String = {return "Please enter the minimum stay field"}()
    lazy var maxsty_Error : String = {return "Please enter the maximum stay field"}()
    
    //SSCalendarTimeSelector Days,done,cancel
    lazy var datealready_Reser : String = {return "This Date already Reserved"}()
    lazy var saving_Title : String = {return "Saving..."}()
    lazy var svd_Title : String = {return "Saved..."}()
    lazy var addlist_Title : String = {return "Add Listing"}()
    lazy var sve_Chngs : String = {return "Save Changes"}()
    lazy var avail_Tit : String = {return "Available"}()
    lazy var blck_Tit : String = {return "Blocked"}()
    lazy var night_Pric : String = {return "Nightly Price"}()
    lazy var noliss_Tit : String = {return "No Listing"}()
    lazy var noliss_Msg : String = {return "You have no listing right now."}()
    lazy var mon_Sym : String = {return "M"}()
    lazy var tues_Sym : String  = {return "T"}()
    lazy var wednes_Sym : String = {return "W"}()
    lazy var thrus_Sym : String = {return "T"}()
    lazy var fri_Sym : String = {return "F"}()
    lazy var sat_Sym : String = {return "S"}()
    lazy var sun_Sym : String = {return "S"}()
    
    //Mark:- WhatIProvide
    lazy var fre_Tit : String = {return "Free"}()
    
    //Mark:- Rooms&Beds
    lazy var roomandbeds:String = {return "Rooms&Beds"}()
    lazy var room_Desc : String = {return "Just a little more about your house..."}()
    lazy var created_List : String = {return "You've Created Your Listing"}()
    lazy var morestps_Msg : String = {return "more steps to list your space"}()
    lazy var finish_List : String = {return "Finish My Listing"}()
    lazy var pls_Ent : String = {return "Please Enter the"}()
    lazy var noBedsErr : String = { return "has no beds in it."}()
    //CreatedList
    lazy var steps_Title : String = {return "steps"}()
    
    //HostHome
    lazy var noreser_Req : String = {return "No Reservation Requests"}()
    
    //HostListing
    lazy var unlis_Title : String = {return "Unlisted"}()
    lazy var addnw_List : String =  { return "Add New Listing"}()
    lazy var in_Title : String = {return "in"}()
    
    lazy var lis_Title : String = {return "Listed"}()
    lazy var host_List : String = {return "Your Listings"}()
    lazy var stplis_Title : String = {return "steps to list"}()
    
    //LocationVC
    lazy var exactloc_Title : String = {return "Exact Location Found"}()
    lazy var exactlocnot_Title : String = {return "Exact Location Not Found"}()
    lazy var locfound_Title : String = {return "Location Found"}()
    lazy var manualpin_Title : String = {return "Would you like to manually pin this listing's location on a map?"}()
    lazy var edtAdd_Title : String = {return "Edit Address"}()
    lazy var pinMap_Title : String = {return "Pin on Map"}()
    
    //RoomBedSelection
    lazy var homtyp_Title : String = {return "Home Type"}()
    lazy var some_Titt : String = { return "Some"}()
    lazy var bedtyp_Title : String = {return "Bed Type"}()
    lazy var rom_Typ : String = {return "Space Type"}()
    lazy var bdrms_Tit : String = {return "Bedrooms"}()
    lazy var maxgues_Tit : String = {return "Max Guests"}()
    
    //AddRoomDetails
    lazy var desplac_Title : String = {return "Describe your place"}()
    lazy var nolis_Err : String = { return "Room Listing Waiting For Admin Approval"}()
    lazy var prev_Tit : String = {return "Preview"}()
    lazy var optidet_Title : String = {return "Optional Details"}()
    lazy var addpht_Tit : String = {return "Add Photos"}()
    lazy var addphts_Tit : String = {return "Add photo"}()
    lazy var set_Price : String = {return "Set Price"}()
    lazy var set_Addr : String = {return "Set Address"}()
    lazy var sethous_Rules : String = {return "Set House Rules"}()
    lazy var setbook_Type : String = {return "Set Book type"}()
    lazy var summ_Highlight : String = {return "Summarize the highlights of your  listing"}()
    lazy var sug_Price : String = {return "Try our suggested  price to start"}()
    lazy var conf_Price : String = {return "Only confirmed guests see your address"}()
    lazy var guest_Agree : String = {return "Guests agree to rules before booking"}()
    lazy var guest_Book : String = {return "How guests can book"}()
    lazy var ready_List : String = {return "Ready to List"}()
    lazy var list_Space : String = {return "List your space"}()
    lazy var unlist_Space : String = {return "Unlist your space"}()
    lazy var expect_Behave : String = {return "How do you expect guests to behave?"}()
    lazy var rom_Sucess : String = { return "Rooms Details Added Successfully."}()
    lazy var booktyp_Tit : String = {return "Booking Type"}()
    lazy var addBedTypeError : String = { return "Please Add Atleast One Bed Type With Bed"}()
    
    //AddRoomImageVC
    lazy var internal_Err : String = {return "Inter error occured, please try again..."}()
    lazy var imglarge_Error : String = {return "Upload failed!!!. Image is too large"}()
    
    //SmartPricing
    lazy var minprice_Trip : String = {return "Min Price Tip: ₹1,084"}()
    lazy var maxprice_Trip : String  = {return "Max Price Tip: ₹4,644"}()
    lazy var whyimp_Setting : String  = {return "Why is this setting important"}()
    
    //DescripePlace
    lazy var add_Tit : String  = {return "Add a title"}()
    lazy var clr_Desc : String  = {return "Be clear and descriptive."}()
    lazy var writ_Summ : String  = {return "Write a summary"}()
    lazy var travabt_Space : String  = {return "Tell travelers what you love about the space. You can include details about the decor, the amenities it includes, and the neighborhood."}()
    lazy var edit_Tit : String  = {return "Edit Title"}()
    lazy var edit_Summ : String  = {return "Edit Summary"}()
    
    //AboutListing
    lazy var thespac_Tit : String  = {return "The Space"}()
    lazy var guesacc_Tit : String  = {return "Guest Access"}()
    lazy var interact_Guest : String  = {return "Interaction with Guests"}()
    lazy var overview_Tit : String  = {return "Overview"}()
    lazy var getarnd_Tit : String  = {return "Getting Around"}()
    lazy var otherthng_Tit : String  = {return "Other Things to Note"}()
    lazy var houserul_Titl : String  = {return "House Rules"}()
    lazy var addinf_Space : String  = {return "You can add more information about what makes your space unique."}()
    lazy var trav_Access : String = {return "Let travelers know what parts of the space they’ll be able to access."}()
    lazy var availgues_Stay : String  = {return "Tell guests if you’ll be available to offer help throughout their stay."}()
    lazy var shwpeop_Uniq : String  = {return "Show people looking at your listing page what makes your neighborhood unique."}()
    lazy var pub_Trans : String   = {return "You can let travelers know if your listing is close to public transportation (or far from it). You can also mention nearby parking options."}()
    lazy var trav_Othr : String   = {return "Let travelers know if there are other details that will impact their stay."}()
    lazy var beh_Expt : String   = {return "How do you expect your guests to behave?"}()
    
    lazy var travoth_Dets : String   = {return "Let travelers know if there are other details that will impact their stay."}()
    lazy var det_Title : String   = {return "Details"}()
    lazy var tneigh_Title : String   = {return "The Neighborhood"}()
    lazy var exdet_Title : String   = {return "Extra Details"}()
    
    //Describe your place
    lazy var descpl_Title : String = {return "Describe your place"}()
    lazy var addtit_Title : String = {return "Add a title"}()
    lazy var writsum_Title : String = {return "write a summary"}()
    
    //ExperienceDetailsController
    lazy var send_MsgTit : String = {return "Send Message"}()
    
    //EditTitleVC
    lazy var chlef_Tit : String   = {return "Characters left"}()
    lazy var edittit_Tit : String = {return "Edit Title"}()
    lazy var tspc_Title : String   = {return "The Space"}()
    lazy var gustAcc_Title : String   = {return "Guest Access"}()
    lazy var interac_Guest : String   = {return "Interaction with Guests"}()
    lazy var overv_Title : String  = {return "Overview"}()
    lazy var getarnd_Title : String   = {return "Getting Around"}()
    lazy var othtin_Title : String   = {return "Other Things to Note"}()
    lazy var housrul_Title : String   = {return "House Rules"}()
    
    //EditPriceVC
    lazy var romadpri_Tit : String   = {return "Room and Additional Prices changed to Minimum Price"}()
    lazy var edtpric_Tit : String = {return "Edit Price"}()
    lazy var fixpric_Msg : String = {return "Fixed price is your default nightly rate"}()
    lazy var chng_Curr : String = {return "Change Currency"}()
    lazy var learn_Mre : String = {return "Learn More"}()
    
    //AllAmentiesVC
    lazy var estent_Title : String   = {return "Essentials~~~1"}()
    lazy var tv_Title : String   = {return "TV~~~2"}()
    lazy var cabltv_Title : String   = {return "Cable TV~~~3"}()
    lazy var aircon_Title : String   = {return "Air Conditioning~~~4"}()
    lazy var heating_Title : String   = {return "Heating~~~5"}()
    lazy var kitchen_Title : String   = {return "Kitchen~~~6"}()
    lazy var internet_Title : String   = {return "Internet~~~7"}()
    lazy var wifi_Title : String   = {return "Wireless Internet~~~8"}()
    lazy var hottub_Title : String   = {return "Hot tub~~~9"}()
    lazy var washer_Title : String   = {return "Washer~~~10"}()
    lazy var pool_Title : String   = {return "Pool~~~11"}()
    lazy var dryer_Title : String   = {return "Dryer~~~12"}()
    lazy var brkfst_Title : String   = {return "Breakfast~~~13"}()
    lazy var freprk_Title : String   = {return "Free Parking on Premises~~~14"}()
    lazy var gym_Title : String   = {return "Gym~~~15"}()
    lazy var elev_Title : String   = {return "Elevator in Building~~~16"}()
    lazy var indoor_Title : String   = {return "Indoor Fireplace~~~17"}()
    lazy var buzz_Title : String   = {return "Buzzer/Wireless Intercom~~~18"}()
    lazy var doorman_Title : String   = {return "Doorman~~~19"}()
    lazy var shamp_Title : String   = {return "Shampoo~~~20"}()
    lazy var famkid_Title : String   = {return "Family/Kid Friendly~~~21"}()
    lazy var smoking_Title : String   = {return "Smoking allowed~~~22"}()
    lazy var suitevnt_Title : String   = {return "Suitable for events~~~23"}()
    lazy var petallow_Title : String   = {return "Pets Allowed~~~24"}()
    lazy var petliv_Title : String   = {return "Pets live on this property~~~25"}()
    lazy var whelchr_Title : String   = {return "Wheelchair Accessible~~~26"}()
    lazy var smkdet_Title : String   = {return "Smoke Detector~~~27"}()
    lazy var crbndet_Title : String   = {return "Carbon Monoxide Detector~~~28"}()
    lazy var firstaid_Title : String   = {return "First Aid Kit~~~29"}()
    lazy var sftcrd_Title : String   = {return "Safety Card~~~30"}()
    lazy var firext_Title : String   = {return "Fire Extinguisher~~~31"}()
    lazy var bedd_Title : String = {return "Bed"}()
    lazy var beddrm_Title : String = {return "Bedroom"}()
    lazy var selected_Dates : String = {return "Select Dates"}()
    lazy var selected_Timings : String = {return "Select Timings"}()
    
    //DiscountPrice
    lazy var clenfee_Title : String   = {return "Cleaning fee"}()
    lazy var addgues_Title : String   = {return "Additional guests"}()
    lazy var echgues_Title : String   = {return "For each guest after"}()
    lazy var secdep_Title : String   = {return "Security deposit"}()
    lazy var weekendpric_Title : String   = {return "Weekend pricing"}()
    lazy var mnthly : String = {return "monthly"}()
    lazy var wkly : String = {return "weekly"}()
    lazy var addpri : String = {return "Additional Prices"}()
    
    //OptionalDetailVC
    lazy var reserset_Title : String  = {return "Reservation Settings"}()
    lazy var curren_Title : String   = {return "Currency"}()
    lazy var rombed_Title : String   = {return "Rooms & Beds"}()
    lazy var descript_Title : String   = {return "Description"}()
    lazy var ament_Title : String   = {return "Amenities"}()
    lazy var policy_Title : String   = {return "Policy"}()
    lazy var pric_Title : String   = {return "Price"}()
    lazy var flexi_Title : String   = {return "Flexible"}()
    lazy var mod_Title : String   = {return "Moderate"}()
    lazy var strt_Title : String   = {return "Strict"}()
    
    //HostRulesVC
    lazy var suit_Child : String   = {return "Suitable for children\n(Age 2-12)"}()
    lazy var suit_Infant : String   = {return "Suitable for infants\n(Under 2)"}()
    lazy var pet_Allow : String   = {return "Pets allowed"}()
    lazy var smok_Allow : String   = {return "Smoking allowed"}()
    lazy var parties_Allow : String   = {return "Parties allowed"}()
    lazy var Add_Rules : String   = {return "Addtional Rules"}()
    lazy var list_Suit : String   = {return "Is my listing suitable for children?"}()
    
    //CalenderSettings
    lazy var adnot_Title : String   = {return "Advance Notice"}()
    lazy var preptim_Title : String   = {return "Preparation Time"}()
    lazy var disreq_Title : String   = {return "Distant requests"}()
    lazy var arok_Title : String   = {return "Are okay"}()
    
    lazy var minmax_Title : String = {return "Minimum and maximum stay"}()
    
    lazy var nig1min_Title : String = {return "1 night minimum"}()
    
    lazy var samdy_Title : String = {return "Same day (customizable cutoff hour)"}()
    
    lazy var notic1dy_Msg : String = {return "Atleast 1 day's notice"}()
    
    lazy var notic2dy_Msg : String = {return "Atleast 2 day's notice"}()
    
    lazy var notic3dy_Msg : String = {return "Atleast 3 day's notice"}()
    
    lazy var notic7dy_Msg : String = {return "Atleast 7 day's notice"}()
    
    lazy var howtim_Msg : String = {return "Set how much time you need before a guest checks in."}()
    
    lazy var non_Title : String = {return "None"}()
    
    lazy var blk1nig_Msg : String = {return "Block 1 night before and after reservations"}()
    
    lazy var blktim_Msg : String = {return "Let you block time between reservations to clean your space or relax."}()
    
    lazy var guearr_Msg : String = {return "Guest arriving any time are okay"}()
    
    lazy var wnt3mnths_Msg : String = {return "I want guests who arrive within 3 months"}()
    
    lazy var wnt6mths_Msg : String = {return "I want guests who arrive within 6 months"}()
    
    lazy var wnt1yr_Msg : String = {return "I want guests who arrive within 1 year"}()
    
    lazy var blocreq_Msg : String = {return "You can block requests for reservations that are too far off to plan for."}()
    
    
    //AdvanceNotice
    //lazy var samedy_Title : String = {return "Same day (customizable cutoff hour)"}()
    lazy var coupamnt_Tit : String = { return "Coupon Amount"}()
    
    //MARK:- Makent sAss NewHome
    lazy var date : String = { return "Dates"}()
    lazy var guests : String = { return "Guests"}()
    lazy var filter : String = { return "Filter"}()
    lazy var showAll : String = { return "Show All"}()
    
    //MARK:- homeVariantTVC
    lazy var categories : String = { return "Categories"}()
    lazy var commonSpace : String = { return "Common Space"}()
    lazy var sleep_Tit : String =  { return "Sleeping arrangements"}()
    lazy var bed_Tit: String =  { return "Bedroom"}()
    
    //Mark:- HomeViewController
    
    lazy var cant_RoomTit : String = { return "We couldn't find any Spaces."}()
    lazy var cant_ExpTit : String = { return "We couldn't find any Experiences."}()
    lazy var remfilt_Msg1 : String = { return "Try removing your filters"}()
    lazy var hi_Tit : String = { return "Hi"}()
        lazy var addBeds : String = { return "Add Beds"}()
    lazy var alert : String = { return "Alert"}()
    lazy var discardMessage : String = { return "All the changes you have made will be discared !"}()
    lazy var discard : String = { return "Discard"}()
    //Mark:- OwnerTitleVC
    lazy var ownby_Title : String = { return "Owned By"}()
    
    //CouponVC
    lazy var ent_Coup : String = { return "Enter your coupon code"}()
    lazy var app_Tit : String = { return "Apply"}()
    lazy var coup_Tit : String = { return "Coupon Code"}()
    
    
    lazy var addgues_Tit : String = {return "Add a guest"}()
    lazy var edtgues_Tit : String = {return "Edit a guest"}()
    
    lazy var percen_Sym : String = { return "%"}()
    lazy var cont_Admin : String = { return "Account disabled please contact admin"}()
    
//    //AddSpaceViewController
//    lazy var hostspc_Title : String = { return ", tell about your space"}()
    lazy var hostspc_Desc : String = { return "The more you share, the faster you can get a booking"}()
    //AddSpaceViewController
    lazy var hostspc_Title : String = { return "\(k_AppName), we're almost done"}()
//    lazy var hostspc_Desc : String = { return "There are just a few more thing we need to know"}()
    lazy var hostspc_Done : String = { return "Your listing is"}()
    
    lazy var basic_Title : String = { return "The Basics"}()
    lazy var set_Title : String = { return "Setup"}()
    lazy var readytohost_Title : String = { return "Get ready to host"}()
    lazy var spacegues_Title : String = { return "Space details, guests"}()
    lazy var photospac_Title : String = { return "Photos, Space description"}()
    lazy var pricavail_Title : String = { return "Pricing, availablity, booking settings"}()
    lazy var select_Title : String = { return "Select"}()
    
    lazy var typeSpaceTitle: String = {return "What type of space do you have?"}()
    lazy var asteriskSymbol: String = {return "*"}()
    
   
    lazy var spaceAccessTitle : String = {return "How can guests access your space"}()
    lazy var spcListDesc : String = {return "Your Listings will appear here"}()
    
    lazy var youarTitle : String = {return "You're"}()
    lazy var ofthrTitle : String = {return "of the way there"}()
    lazy var fnshTitle : String = {return "Finish your listing"}()
    lazy var mrStpTit : String = {return "More Step to Complete"}()
    lazy var mrStpsTit : String = {return "More Steps to Complete"}()
    lazy var addAnthrSpc : String = {return "Add Another Space"}()
    
    lazy var noOfRooms : String = {return "Number of Rooms"}()
    lazy var noOfResRooms : String = {return "Number of Restrooms"}()
    lazy var flrNum : String = {return "Floor number (if applicable)"}()
    lazy var estFootSpc : String = {return "Estimated square footage of the available Space"}()
    
    lazy var peopSearch : String = { return "People searching on"}()
    lazy var peopSearchNew : String = { return "People all over the country are searching for a space like yours! When they use \(k_AppName) to find you, they'll have the option to filter search results by listing basic information to find a match. By carefully completing the questions in this section, you can help them achieve their goals and, in turn, maximize your chances of begin found!"}()
    lazy var mthNeeds : String = {return "can filter by listing basics to find a space that matches their needs."}()
    //lazy var hlpEveOrg : String = {return "Help Event Organizer to Find the Right Fit"}()
    lazy var hlpEveOrg : String = {return "Ready to place your space in the spotlight"}()
    lazy var getStartList : String = {return "Lets get started listing your space"}()
    lazy var amentiesDesc : String = {return "What amenities does your space offer?"}()
    lazy var maxGuestDesc : String = {return "Maximum number of guests"}()
    
    lazy var servDesc : String = {return "What services and extras do you offer"}()
    lazy var addInfDesc : String = {return "Additional information about services, packages and rates:"}()
    lazy var additionalInf : String = {return "Enter Additional Information"}()
    
    lazy var chkGuidance : String = {return "Check-In Guidance"}()
    lazy var checkinDesc : String = {return "Enter Check-In Guidance Description"}()
    lazy var aptTitle : String = {return "Apt #, Floor #, etc."}()
    lazy var fulladdDesc : String = {return "What is the full address of your space?"}()
    lazy var chsOnMap : String = {return "Choose on Map"}()
    lazy var shrDesc : String = {return "Share any special instructions needed for organizers to access the space. e.g. door lock code, on-site manager."}()
    lazy var infrmDesc : String = {return "This information will only be shared upon booking confirmation."}()
    
    lazy var spcAlert : String = {return "Please Select Space Type"}()
    lazy var footSpcAlert : String = {return "Please Enter or Add Footage Space Value"}()
    lazy var spaceAccessAlert : String = {return "Please Select Atleast One Access From List"}()
    lazy var guesCountAlert : String = {return "Please Enter or Add Guest Count"}()
    lazy var spcAddressAlert : String = {return "Please Enter Space Address"}()
    
    lazy var spacePhotoTitle : String = {return "Add Space Photo"}()
    lazy var photoUploadAlert : String = {return "Please upload atleast one photo."}()
    lazy var spcHighlgt : String = {return "Enter Space Highlights"}()
    lazy var spcPhtAlert : String = {return "Are you sure you wish to delete this photo? It is a nice one!"}()
    
    lazy var spcStyleDesc : String = {return "The style of your space can be described as"}()
    lazy var spcFeatDesc : String = {return "What special features does your space have?"}()
    lazy var spcRulesDesc : String = {return "Set your Space Rules"}()
    
    lazy var travelTitle : String = {return "Tell Travelers About Your Space"}()
    lazy var travelDesc1 : String = {return "Every space on"}()
    lazy var travelDesc2 : String = {return "is unique. Highlight what makes your listing welcoming so that it stands out to guests who want to stay in your area"}()
    lazy var lisNameTit : String = {return "Listing Name"}()
    lazy var sumTit : String = {return "Summary"}()
    lazy var charsLeft : String = {return "characters left"}()
    lazy var charLeft : String = {return "character left"}()
    lazy var secTit: String = {return "Secure"}()
    lazy var signInWith : String =  { return "Sign in with"}()
    
    lazy var accDelete : String = { return "Delete Account"}()
    lazy var confirm : String = { return "Confirm"}()
    lazy var close : String = { return "Close"}()
    lazy var confrimationDlt : String = { return "All your trips, reservation, transaction history, listing will be deleted permanently"}()
    lazy var do_you_want_to_continue : String = {return "Do you want to continue with Available SpotsLeft"}()
    lazy var deleteUser1 : String = { return "The user you're looking for is deleted"}()
    lazy var deleteUser2 : String = { return "The room you're looking for is deleted"}()
    lazy var deleteUser3 : String = { return "Booking website issue"}()
    lazy var deleteUser4 : String = { return "Mobile-newtork issue"}()
    lazy var deleteUser5 : String = { return "App-link is unAvailable"}()
    lazy var deleteUser6 : String = { return "Oh No! This is annoying - Sorry for the incovenience ! This could because"}()
    lazy var deleteUser7 : String = { return "For more information, Kindly contact Admin"}()
    
    lazy var confirmationText : String = { return "All your trips, reservation, transaction history, listing will be deleted permanently"}()
    lazy var payoutContent : String = { return "Your pending payout or refund is yet to be collected. Are you sure you want to delete this account?"}()

    lazy var DeltedTxt : String = { return "Delete"}()
    lazy var DeleteConfirmation : String = { return "Account deleted sucessfully"}()
    
    lazy var add_Title_Describtion : String = { return "Makent is build on relationships. Help other people get to know you. \n\nTell them about the things you like: Share your favorite travel destinations, books, movies, shows, music, food. \n\nTell them what it's like to have you as a guest or host: What's your style of travelling? Of Makent hosting? \n\nTell them about you: Do you have a life motto?"}()
    
    
    lazy var Tax : String = { return "Tax"}()
    
    lazy var addPhoto : String = { return "Add Photos"}()
    
    lazy var aboutFirstPt : String = { return "Makent is build on relationships. Help other people get to know you."}()
    lazy var aboutSecondPt : String = { return "Tell them about the things you like: Share your favorite travel destinations, books, movies, shows, music, food."}()
    lazy var aboutThirdPt :  String = { return "Tell them what it's like to have you as a guest or host: What's your style of travelling? Of Makent hosting?"}()
    lazy var aboutFourthPt : String = { return "Cuéntales sobre ti: ¿Tienes un lema de vida?"}()
    lazy var delete_acc_content : String = {return "All your trips, reservation, transaction history, listing will be deleted permanently"}()
}

