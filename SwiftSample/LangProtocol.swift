//
//  LangProtocal.swift
//  Makent
//
//  Created by Trioangle on 30/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//


import Foundation

protocol LanguageProtocol {
    //Toast messages
    var preAccepted : String {get}
    var applyCoupon :String { get }
    var coupon :String { get }
    var removeCoupon :String { get }
    var pleaseSelectAddressFromList :String { get }
    var pleaseSelectTheStartTime :String { get }
    var pleaseSelectTheEndTime :String { get }
    var endTimeShouldBeGreaterThanTheStartTime :String { get }
    var pleaseEnterCardNumber :String { get }
    var pleaseEnterExpirationDate :String { get }
    var pleaseEnterCvcNumber :String { get }
    var pleaseEnterFirstName :String { get }
    var pleaseEnterLastName :String { get }
    var pleaseEnterPostCode :String { get }
    var serverErrorPleaseTryAgain :String { get }
    var pleaseFillAllMandatory :String { get }
    var pleaseProvideYourSpaceIsFurnishedOrNot :String { get }
    var pleaseEnterOrAddWorkStationValue :String { get }
    var pleaseSelectSharedOrPrivate :String { get }
    var pleaseProvideAreYouRentingNewOrExperience :String { get }
    var selectedSpaceTypeIsDeActivatedByAdmin :String { get }
    var pleaseEnterSpaceAddress :String { get }
    var pleaseEnterValidAddress :String { get }
    var pleaseFillMandatoryFields :String { get }
    var pleaseEnterListName :String { get }
    var pleaseEnterSummary :String { get }
    var pleaseEnterGuestCount :String { get }
    var pleaseSelectStartAndEndTime :String { get }
    var pleaseSelectStartTime :String { get }
    var pleaseSelectEndTime :String { get }
    var pleaseSelectAtleastOneActivityFromList :String { get }
    var pleaseFillAllFields :String { get }
    var pleaseEnterHourlyAmountGreaterThanOrEqualMinimumAmount :String { get }
    var pleaseEnterFullDayAmountGreaterThanHourlyAmount :String { get }
    var pleaseEnterWeeklyAmountGreaterThanFullDayAmount :String { get }
    var pleaseEnterMonthlyAmountGreaterThanWeeklyAmount :String { get }
    var minimumHourRange :String { get }
    var pleaseChooseValidTimes :String { get }
    var youCannotSelectThisTimeBecauseTimeIntervalIsAHourRequired :String { get }
    var authenticationIsNeeded : String {get} //Authentication
    var price_title : String {get} //Price
    var people_title : String {get} //People
    var check_inTitle : String {get} //Check-In time
    var check_outTitle : String {get} //Check-Out time
    var yourReserv_Title : String {get} //Your Reservation
    var wishList_Title : String {get} //Wishlist
    var booking_Title : String  {get} //Bookings
    var ExploreMakentSpace: String {get} //Explore Makent Space
    var per_Hours: String {get} //per hours
    var birth_Desc : String {get}//You Must be at least 18 years old to use
    var Homes : String {get}//Homes
    var addStr : String {get} // Add
    
    var Experiences: String {get}//Experiences
    var hom_Titt : String {get}//Home
    var Exp_Titt : String {get}//Experience
    
    //Mark:- HomeViewController
    var cant_RoomTit : String {get}//We couldn't find any spaces.
    var remfilt_Msg1 : String {get}//Try removing your filters
    var hi_Tit : String {get}//Hi
    var cant_ExpTit : String {get}//We couldn't find any Experiences.
    var curLaneng : String {get}//English
    var curLanarb : String {get}//Arabic
    var chsLan : String {get}//Choose Language
    var curLanspn : String {get}//Spanish
    var eventType : String {get}//Event Type
    var guestTitle : String {get}//Guest
    var maximumGuestTitle : String {get}//Maximum guest count within
    var selected_Dates : String {get}//Selected Dates
    var selected_Timings : String {get}//Selected Timings
    var chooseTiming     : String {get}//Choose Timing
    var noMoreDatas : String {get}//No more Datas are available to show
    
    //MARK:-ReviewsPageController
    var reviews_Title : String {get}//Reviews
    
    //MARK:-ExBookingController
    var steps_LeftTitle  : String {get}//steps left
    var step_LeftTitle  : String {get}//step left
    var network_ErrorIssue : String {get}//Server issue, Please try again.
    var hours_Tit : String {get}//Hours
    var book_Title : String {get}//Book nows
    var continue_Title : String {get}//Continue
    var read_Title : String {get}//Read
    var agreed_Title : String {get}//Agreed
    var other_Title : String {get}//Other
    var host_ByTitle : String {get}//host by
    var lblTotalExText : String {get}//Total
    
    //MARK:-RoomsHouseRules
    var agree_Titlle : String {get}//Accept
    
    
    
    //MARK:-IGCommon
    var could_LoadTitle : String {get}//Could not load view with type
    
    //MARK:-GuestPageCellTypeB -- TTTAttributedLabel
    
    var agree_GuestPage : String {get}//When you book, you agree to Makent Additional Terms of Service, Guest Release and Waiver, and Cancellation Policy
    var mak_AddTerms : String {get}//Makent Additional Terms of Service
    
    
    //MARK:-ProfileSettings
    var termser_Title : String {get}//Terms of Service
    var secTit : String {get}//Secure
    
    //MARK:-WhosComingController
    var who_ComingTitle : String {get}//Who's coming?
    var guest_Title : String {get}//Guest
    var addgues_Tit : String {get}//Add a guest
    var edtgues_Tit : String {get}//Edit a guest
    
    //MARK:-ExperienceDetailsController
    var send_MsgTit : String {get}//Send Message
    
    //MARK:-AddGuestController
    var addguest_Title : String {get}//Keep your guests in the loop. Add their email and we'll send them the itineary.
    var done_Title : String {get}//Done
    var edit_Title : String{get}// Edit
    var first_NameError : String {get}//First Name can't be empty
    var last_NameError : String {get}//Last Name can't be empty
    var email_Error : String {get}//Enter your correct email
    var want_DeleteAlert : String {get}//Are you sure want to delete
    var cancel_Title : String {get}//Cancel
    var delete_Title : String {get}//Delete
    var ok_Title : String {get}//OK
    var notmatch_Enum : String {get}//Does not match Enum
    
    //MARK:-WhatIProvide
    var fre_Tit : String {get}//"Free"
    
    //MARK:-GroupSizeInfoController
    var group_Title : String {get}//Group Size
    var thereare_Title : String {get}//There are
    var spotexp_Available : String {get}//spots available on this experience.
    var groupview_DontFill : String {get}//You don't have to fill all of them. Experiences are meant to be social, so other guests could join too
    var grpsize_Content : String {get}//You don't have to fill all of them. Experiences are meant to be social, so other travelers could join too
    
    //MARK:-GuestRequirementController
    var guestreq_Title : String {get}//Guest Requirements
    
    //MARK:-ReviewGuestRequirementsController
    var guestRequire_Title : String {get}//Review Guest Requirements
    
    //MARK:-EventCancellationPolicyController
    var weather_Title : String {get}//Weather
    var accountVerifi_Title : String {get}//Account Verification
    var makhostexpeve_Cancel : String {get}//Makent Hosts\nExperience & Event\nCancellation policy
    var general_Cancel : String {get}//General Cancellation
    var hrs24_Refund : String {get} //• Any experience or event, canceled within 24 hours of booking, is eligible for a full refund.
    var event30_Day : String {get}//• Any experience or event cancellation that is 30 days or more before the start date, is eligible for a full refund.
    var cancel30_Day : String {get}//• Cancellations less than 30 days before start date will not be eligible for a refund, unless your spot is booked and completed by another guest.
    var days14_Refund : String {get}//• Should your spot be booked and completed by another guest, a full refund will be processed within 14 days of the experience start date.
    var cancel_Reason : String {get}//• However, if the reason for cancellation meets out Extenuating Circumstances policy, you will be refunded in full.
    var account_Verif : String {get}//Should any member of your party be unable to complete the account verification process within 3 days of purchase, all portions and spots for the experience or event will be canceled and fully refunded.
    var hostoffr_Msg : String {get}//Hosts make every effort to continue, as scheduled, with experience or events. Should bad weather conditions create an unsafe scenario for guests or hosts, a change or partial cancellation of an itinerary or activity may be the result. Should an individual experience or event be canceled by host or guest, or should an itinerary substantially change or result in a cessation of the trip, Makent will work with your host to provide an appropriate refund. To officially request a cancellation of your experience or event, please contact us.
    
    //MARK:-ExRoomDetailCell
    var hours_Total : String {get}//hours total
    var offer_In : String    {get}//Offered in
    var exp_Title : String   {get}//experience
    var total_Hours: String  {get}//Total Hours
    var choose_your_country: String {get}//Choose your country
    var request_book : String {get} //"Request to Book"
    var instant_book : String {get} // "Instant Book"
    
    //MARK:-ExperienceDetails
    var meethost_Title : String {get}//Meet Your Host
    var whatwldo_Title : String {get}//What we'll do
    var whatwdo_Title : String {get}//What we'll provide
    var whatill_Title : String {get}//What i'll provide
    var notes_Title : String {get}//Notes
    var whocom_Title : String {get}//Who can come
    var whrwlbe_Title : String {get}//Where we'll be
    var grpsiz_Title : String {get}//Group size up to
    var seedates_Title : String {get}//See dates
    var addanogues_Title : String {get}//Add Another Guest
    //var guestreq_Title : String {get}//Guest requirements
    var expcan_Policy : String {get}//Experience cancellation policy
    var conthost_Title : String {get}//Contact host
    var insbook_Title : String {get}//Instant Book
    var reqbook_Title : String {get}//Request to book
    var checkout_Awesom : String {get}//Check out this awesome House on
    var rev_Title : String {get}//Review
    var revs_Title : String {get}//Reviews
    var perpers_Title : String {get}//per person
    var whatiprov_Title : String {get}//what i provide
    //MARK:-ExMeetYourHostCell attributed  ..Read More
    
    //MARK:-ExContactHostController
    var contreq_Send : String {get}//Contact request has send to
    var need_More : String {get}//Need more info about Instagram worthy hike in
    var write_Mess : String {get}//Write a message...
    
    //MARK:-ContactHostTypeACell -- TTTAttributedLabel
    var faq_Msg : String {get}//If you have general questions about how experience work, visit or FAQ
    var faq_Title : String {get}//visit or FAQ
    
    //MARK:-ExperienceCalenderController
    var whrlik_Msg : String {get}//When would you like to go ?
    var choos_Tit : String {get}//Choose
    var perprsn_Tit : String {get}//per person
    var sel_MulDat : String {get}//Select Multiple Dates
    var sun_Title : String {get}//Sunday
    var mon_Title : String {get}//Monday
    var tue_Title : String {get}//Tuesday
    var wed_Title : String {get}//Wednesday
    var thurs_Title : String {get}//Thursday
    var fri_Title : String {get}//Friday
    var sat_Title : String {get}//Saturdat
    var date_Error : String {get}//The date must be a date after today.
    
    //MARK:-ExperinceType2Cell attributed  ..Read More
    
    //MARK:-ExCellMapHolderView
    var wher_wlmeet : String {get}//Where we'll meet
    
    //MARK:-CategorySelectionController
    var sel_cats : String {get}//Select categories
    
    
    //MARK:-SplashVC
    var switch_Travel : String {get}//Switching to Travelling
    var switch_Host : String {get}//Switching to Hosting
    var reser_Title : String {get}//RESERVATIONS
    var cal_Title : String {get}//CALENDAR
    var list_Title : String {get}//LISTING
    var prof_Title : String {get}//PROFILE
    var expl_Title : String {get}//Explore
    var save_Title : String {get}//Saved
    var cont_Admin : String{get}//This user in Inactive status please contact admin
    var trip_Title : String {get}//Trips
    var inbox_Title : String {get}//Inbox
    var profl_Title : String {get}//Profile
    var login_Title : String {get}//Log In
    
    //MARK:-ForgotPassword
    var forpass_Tit : String {get}//Forgot your password?
    var emailadd_Tit : String {get}//EMAIL ADDRESS
    var enter_Email : String {get}//Enter your email to find your account.
    
    //MARK:-SignUpVC
    var wht_Name : String {get}//What's your name?
    var frstname_Tit : String {get}//FIRST NAME
    var lstname_Tit : String {get}//LAST NAME
    
    //MARK:-SignUpEmail
    var yremail_Tit : String {get}//And, your email?
    
    //MARK:-EditLengthOfDiscountsVC
    var selnigh_Tit : String {get}//Select nights
    var percen_Sym : String {get}//%
    
    //MARK:-SignUpPassword
    var shw_Tit : String {get}//Show
    var emp_Pass : String {get}//Please Enter Password
    var eight_Pass : String {get}//Password Must Contain 8 Characters
    var crt_Pass : String {get}//Create a password
    var remem_Tit : String {get}//Remember
    var pas_Tit : String {get}//PASSWORD
    
    //SignUpDOB
    var whn_Bith : String {get}//When is your birthday?
    var birth_Tit : String {get}//BIRTHDAY
    
    //MARK:-MLImagePickerController
    var allphoto_Title : String {get}//All Photos
    var back_Title : String {get}//Back
    var add_Title : String {get}//Add a Title
    var photoexeed_Title : String {get}//Choose a photo that can not be exceeded
    
    //MARK:-MainVC
    var welcm_To : String {get}//Welcome to
    var conti_Fb : String {get}//Continue with Facebook
    var conti_Google : String {get}//Continue With Google
    var crt_Acc : String {get}//Create Account
    var login_Tittle : String {get}//Log in
    var bysign_Agree : String {get} //By Signing up,I agree to
    var lugg_Terms : String {get} //Luggaru's Terms of Service,Privacy Policy,Guest Refund Policy,Host Guarantee Terms
    var regishere_Title : String {get}//REGISTER here
    var priv_Policy : String  {get}
    var guesrefun_Policy : String  {get}
    var hosguar_Terms : String  {get}
    var orr_Title : String {get}//OR
    var postals_Tit : String {get}//Postals
    var forg_Tit : String {get}//Forgot Password?
    var dont_Acc : String {get}//Don't have account yet?
    var confb_Title : String {get}//Connect with Facebook
    var congoog_Title : String {get}//Login with Google
    var somemp_Title : String {get}//Some fields are empty!!
    var crctval_Title : String {get}//Please enter correct value
    var errcongoog_Title : String {get}//Error configuring Google services:
    var email_Title : String {get}//Email
    var pass_Title : String {get}//Password
    
    //MARK:-SignUpPassword
    var hide_Title : String {get}//Hide
    var show_Title : String {get}//Show
    
    //MARK:-SignUpDOB
    var signuppass_Title : String {get}//SignUpPassword
    var otherppl_Title : String {get}//Other people won't see your birthday
    
    //MARK:-ForgotPassVC
    var checkem_Title : String {get}//Check Your Email
    var wesen_Email : String {get}//We sent an email to
    var tap_Link : String {get}//Tap the link in that email to reset your password.
    var acc_Title : String {get}//Accounts
    var pls_Log : String {get}//Please login to a Facebook account to share.
    var email_NotSend : String {get}//Could Not Send Email
    var email_NotSendMsg : String {get}//Your device could not send e-mail. Please check e-mail configuration and try again.
    var sprd_Msg : String {get}//Spread the words of lord by sharing this
    var holy_Title : String {get}//Holy
    var offline_Title : String {get}//Offline V1.0
    
    //MARK:-ExploreVC
    var inter_Error : String {get} //Please check your Internet Connection
    var pullref_Title : String {get}//Pull to refresh
    var anytime_Title : String {get}//Anytime
    var anywhere_Title : String {get}//AnyWhere
    var nomore_DataErr : String {get}//No more data available...
    var unexp_KindErr : String {get}//Unexpected element kind
    var opentim_Title : String {get}//Open Time
    var clstim_Title : String {get}//Close Time
    var retry_Title : String {get}//Retry
    var caphome_Tit : String {get}//HOMES
    var capexp_Tit : String {get}//EXPERIENCES
    var caprest_Tit : String {get}//RESTAURANT
    var remfilt_Tit : String {get}//Remove all filters
    var remfilt_Msg : String {get}//We couldn't find any listings. Try removing your filters.
    var map_Tit : String  {get}//"MAP"
    var filt_Tit : String  {get}//"FILTER"
    var clrall_Tit : String {get}//Clear All
    
    //MARK:-AlertView
    var offerr_Title : String {get}//Error: You are currently offline
    var off_Err : String {get}//You are currently offline
    var error_Tit : String {get}//Error:
    
    //MARK:-FilterVC
    var amenit_Tit : String {get}//Amenities
    var bedd_Title : String {get}//Bed
    var beddrm_Title : String {get}//Bedroom
    var beddrms_Title : String {get}//Bedrooms
    var baths_Tit : String {get}//Bathrooms
    var beds_Tit : String {get}//beds
    var rese_Titl : String {get}//Reset
    var bedroom_Tit : String {get}//bedrooms
    var bath_Tit : String {get}//bathrooms
    var filts_Tit : String {get}//Filters
    var instbk_Msg : String {get}//Book without waiting for the host to respond
    var instbk_Only : String {get}//Instant Book Only
    var seeall_Ameniti : String {get}//See all amenities
    
    //MARK:-MapRoomCell
    var nothing_Title : String {get}//Nothing saved yet
    var listing_Title : String {get}//Listing
    var listings_Title : String {get}//Listings
    
    //MARK:-SearchVC
    var locpermisson_Tit : String {get}//Location Permission
    var grant_Tit : String {get}//Please grant
    var locset_Title : String {get}//access to your location through settings > privacy > location services.
    var setting_Title : String {get}//Settings
    var popdest_Title : String {get}//Popular Destinations
    
    
    //MARK:-RoomDetailPage
    var checkavail_Title : String {get}//Check availability
    var chk_Tit : String {get}//Check
    var mssg_Titt : String {get}//Message
    var cnthst_Tit : String {get}//Contact Host
    var ament_Tit : String {get}//"Amenity"
    var smap_Tit : String {get}//"Map"
    var features_Tit : String {get}//"Fearture"
    var space_Tit    : String {get}// "Space"
    var available_TimeTit : String {get}//"AvailableTime"
    var festievnt_Tit : String {get}//"Festival"
    var abt_Tit : String {get}//"About"
    var abt_SerTit : String {get}//"About this Service"
    var availb_Tit : String {get}//"Availabilty"
    var prop_Tit : String {get}//"Property"
    var stexp_Title : String {get}//Start exploring
    var descs_Title : String {get}//"Descriptions"
    var pernight_Title : String {get}//per night
    var perday_Title : String {get}//per day
    var cancelpolicy_Title : String {get}//Cancellation Policy
    var houserules_Title : String {get}//House Rules
    var simlist_Title : String {get}//Similar Listing
    var additionalprice_Title : String {get}//Additional Prices
    var checkavailab_Title : String {get}//Check Availability
    var contachost_Title : String {get}//Contact to Host
    var triplength_Title : String {get}//Trip Length
    var sleep_Tit: String {get} // Sleeping arrangements
    var bed_Tit: String{get} //Bedroom
    
    /// Event Error Message
    var choose_Activity: String{get} //Please Choose your Activity
    var choose_Dates: String{get} //Please Choose your Dates
    var add_GuestCount: String{get} //Please add your guest count
    
    var startTime: String{get} //"Start time"
    var endTime  : String{get} //"End time"
    
    /// similarList Details
    var hourly_Rate: String{get} //Hourly Rate
    var full_Day_Rate: String{get} //Full Day Price
    var minimum_Booking_Hours: String{get} //Minimum Booking Hours
   
    //MARK:-GuestDetailCell
    var caproom_Title : String {get}//Rooms
    var capguest_Title : String {get}//Guests
    var capbed_Title : String {get}//Beds
    
    var capbath_Title : String {get}//Bathroom
    var redmore_Title : String {get}//..Read More
    var hostby_Title : String {get}//Hosted by
    
    //MARK:-WWCalendarTimeSelector
    var strtdat_Title : String {get}//Start date
    var enddat_Title : String {get}//End date
    var checkin_Title : String {get}//Check-in
    var checkout_Title : String {get}//Check-out
    var save_Tit : String {get}//Save
    var thosdate_Err : String {get}//Those dates are not available
    var date_Req : String {get}
    
    //Choose Time Error Message
    var endTimeErrorMsg : String {get}//Please select start time
    var maximum_guestcount : String {get}//Maximum guest cound should be
    
    //MARK:-Review Cell
    var readall_Title : String {get}//Read all
    
    //MARK:-ShareVC
    var twitlog_Err : String {get}//Please login to a Twitter account to share.
    var checkout_Msg : String {get}//Check out this great place to stay in
    var hey_Title : String {get}//Hey,
    var grt_Place : String {get}//I found a great place to stay in
    var whtthnk_Title : String {get}//What do you think?
    var on_Tit : String{get}//on
    
    //MARK:-ContactHostVC
    var hostedby_Title : String {get}//hosted by
    var yourmsg_Title : String {get}//Your Message
    var msghst_Tit : String {get}//Message Host
    var aapreciate_Msg : String {get}//Hosts appreciate a thoughtful hello
    var change_Title : String {get}//Change
    var dat_Title : String{get}//Date
    var guess_Tit : String{get}//Guests
    
    //MARK:-Error Messages
    var nodat_Found : String {get}//"No Data Found"
    
    //MARK:-AddMessageVC
    var stps_Lftbk : String {get}//Steps left to book
    var lblTotText1 : String{get}//Total
    var seepric_Dwn : String {get}//See price breakdown
    //close to public transportation 30 minutes from
    
    //
    //MARK:-PriceBreakdown
    var price_Msg : String {get}//This helps us run our platform and offer services like 24/7 support on your trip.
    var pay_Brk : String {get}//Payment Breakdown
    
    //MARK:-AddHostMessageVC
    var int_Yrslf : String {get}//Introduce yourself
    var tel_Tit : String {get}//Tell
    var tel_Desc : String {get}//a bit about yourself and your trip.
    
    //LoadWebView
    var pay_Succes : String {get}//Payment Successfully Paid
    var prepy_Succes : String {get}//Pre payment data listed successfully
    var paymnt_Succes : String {get}//"Payment has Successfully Completed."
    
    //MARK:-AdditionalPrice
    var staydiscount_Title : String {get}//Length of stay discounts
    var earlydiscount_Title : String {get}//Early bird discounts
    var lastdisc_Title : String {get}//Last min discounts
    var ext_Peop : String {get}//Extra People
    var sec_Dep : String {get}//Security Deposit
    var clean_Fee : String {get}//Cleaning Fee
    var addpric_Msg: String {get}//You can give discounts for your list from our website
    var mnthly_Title : String {get}//monthly
    var wekly_Title : String {get}//weekly
    var nigt_Title : String {get}//night
    var dayy_Title : String {get}//day
    var dayys_Title : String {get}//days
    
    //MARK:-RoomHouseRules
    var abthome_Title : String {get}//About this home
    
    //MARK:-Amenties
    var wifi_Tit : String {get}//"Wifi"
    var aircond_Tit : String {get}//"Air Conditioning"
    var pool_Tit : String {get}//"Pool"
    var kit_Tit : String {get}//"Kitchen"
    var park_Tit : String {get}//"Parking"
    var brkfst_Tit : String {get}//"Breakfast"
    var indoor_Tit : String {get}//"Indoor fireplace"
    var heat_Tit : String {get}//"Heating"
    var fam_Tit : String {get}//"Family Friendly"
    var wash_Tit : String {get}//"Washer"
    var dry_Tit : String {get}//"Dryer"
    var esst_Tit : String {get}//"Essentials"
    var shmp_Tit : String {get}//"Shampoo"
    var hairdry_Tit : String {get}//"Hair dryer"
    var iron_Tit : String {get}//"Iron"
    
    //MARK:-WhishListVC
    var notlog_WishMsg : String {get}//Collect places to stay and things to do by tapping the heart icon
    var nowish_Tit : String {get}//No Wish Lists
    var nowish_Msg : String {get}//You have no wish lists right now.
    var find_HomeTit : String {get}//Find homes
    
    //MARK:-TripsVC
    var Trips_Msg1 : String {get}//What will be  your first adventure?
    var Trips_Msg2 : String {get}//You'll find your trip itineraries here
    var pend_Trip : String {get}//Pending Trips
    var upcom_Trip : String {get}//Upcoming Trips
    var prev_Trip : String {get}//Previous Trips
    var curren_Trip : String {get}//Current Trips
    
    
    
    //MARK:-AddWhishListVC
    var pub_Title : String {get}//Public
    var pri_Title : String {get}//Private
    var chs_Tit : String {get}//Choose a list
    var visible_Msg : String {get}//Visible to everyone and included on\nyour public
    var profi_Title : String {get}//profile.
    var visiblefrnd_Msg : String {get}//Visible only to you and any friends you invite
    
    //MARK:-WhishListDetailsVC
    var avail_exps : String {get}//available experiences
    var avail_hom : String {get}//available home
    var nothingsave_Desc : String {get}//When you see something you link, tap on the heart to save it. If you're planning a trip with others, invite them so they can saved and vote on their favorites.
    var avail_homs : String {get}//available homes
    var wish_name : String {get}//Please enter the wishlist name
    var sav_Chgs : String {get}//Save Changes
    var tit_Titl : String {get}//Title
    var wis_Name : String {get}//Wish List Name...
    var wis_Updt : String {get}//"WishList Updated Successfully"
    var wislis_Every : String {get}//"The list is now visible to everyone"
    var wislis_Vis : String {get}//"The list is now visible to you only"
    
    var mak_Pub : String {get}//"Make Public"
    var mak_Priv : String {get}//"Make Private"
    var del_List : String {get}//Delete This List
    var rem_List : String {get}//Remove Listing
    var rem_Tit : String {get}//Remove
    
    //MARK:-ExpReceiptHeaderView
    var hourexp_Title : String {get}//hours experience
    var tott_Tit : String {get}//Total
    
    //MARK:-PriceBreakDown
    var nights_Title : String {get}//nights
    var nightsin_Title : String {get}//nights in
    var totalpayout_Title : String {get}//Total payout
    var hostfee_Title : String {get}//Host Fee
    var servicefee_Title : String {get}//Service fee
    var totlaprice_Title : String {get}//Total price
    
    //MARK:-FilterRoomTypes
    var shareroom_Msg : String {get}//\nNote: This is a shared room
    
    
    //MARK:-HostMessageVC
    var editmsg_Title : String {get}//Edit Message
    var addmsg_Title : String {get}//Add Message
    
    //MARK:-SpaceType
    var listsp_Tit : String {get} //"List Your Space"}()
    var listsp_Mes : String {get}// "What type of space do you want to list?"}()
    
    //MARK:-PropertyType
    var proptyp_Tit : String  {get}//return "Property Type"}()
    var mr_Tit : String {get}//more
    var proptyp_Msg : String  {get}//return "Nice What type of place is your entire home in?"}()
    
    //MARK:-Location
    var loc_Tit : String  {get}//return "Location"}()
    var loc_Msg : String {get}//return "What city is your appartment located in"}()
    var next_Tit : String {get}//Next
    
    
    //MARK:-CountryListVC
    var sel_Coun : String {get}//Select Country
    
    //MARK:-MakePaymentVC
    var select_Pay : String {get}//Select your payment method
    var add_Pay : String {get}//Add Payment
    var paypal_Tit : String {get}//PayPal
    var crdit_Titlt : String {get}//Credit Card
    
    //MARK:-HostInboxVC
    var nores_Req : String {get}//No Reservation Requests
    var nores_mess : String {get}//You have no reservation requests or booking inquiries to respond to right now.
    var resers_Title: String {get}//Reservations
    var preacc_Title : String {get}//Pre-Accept
    
    //MARK:-Pre-AcceptVC
    var preacc_Req : String {get}//Pre-Accept this request
    var opt_Msg : String {get}//Type optional message to guest...
    
    //MARK:-HouseRulesVC
    var houserule_Msg1 : String {get}//When you stay in an
    var houserule_Msg2 : String {get}//,you're staying in someone's home. You'll need to agree to Simon & Wendy's house rules before you can book.
    
    //MARK:-BookingVC
    var Book_Now : String  {get}//Book now
    var hostmsg_Title : String {get}//Host Message
    var chkin_Tit : String {get}//Check in
    var chkout_Tit : String {get}//Check out
    
    //MARK:-DiscountPageVC
    var nostay_Disc : String {get}//"No Length of Stay Discounts Found"
    var nobir_Disc : String {get}//"No Early Bird Discounts Found"
    var nolst_Disc : String {get}//"No Last Minute Discounts Found"
    var night_Tit : String {get}//"Nights"
    var percen_Tit : String {get}//"Percentage"
    
    //MARK:-InboxVC
    var msghost_Msg : String {get}//Messages from your host will appear here
    var nomsg_Msg : String {get}//You have no messages
    var resub_Tit : String {get}//Resubmit
    var youhav_No : String {get}//You have no
    var youhave_Title : String {get}//You have
    var unreadmsg_Title : String {get}//unread messages
    var nounread_Msg : String {get}//You have no unread messages
    
    //MARK:-InboxDetailVC
    var payment_Title : String {get}//Payment
    var discount_Title : String {get}//discount
    var guesss_Tit : String {get}//guest
    var guessts_Tit : String {get}//guests
    var lengthdis_Title : String {get}//length of stay discount
    var customer_Title : String {get}//Customer Receipt
    var Cancelreq_Title : String {get}//"Cancel Request"
    var MsgHis_Title : String {get}//"Message History"
    
    //MARK:-Reservation
    var view_Det : String {get}//"View Details"
    
    //MARK:-ReservationDetailVC
    var whycancel_Tit :String {get}//"Why are you Cancelling?"
    var mypla_Long :String {get}//"My place is longer available"
    var wntoff_List :String {get}//"I want to offer a different listing or change the price"
    var need_Maintain :String {get}//"My place needs maintenance"
    var exten_Circum :String {get}//"I have an extenuating circumstance"
    var gues_Cancel :String {get}//"My guest needs to cancel"
    var why_Dec :String {get}//"Why are you declining?",
    var date_Avail :String {get}//"Dates are not available",
    var notfeel_Comfort :String {get}//"I do not feel comfortable with this guest",
    var list_NotGood :String {get}//"My listing is not a good to fit for the guest's needs (children, pets, ets.)",
    var wait_Attract :String {get}//"I'm waiting for a more attractive reservation",
    var ask_Diff :String {get}//"The guest is asking for different dates than the ones selected in this request",
    var msg_Spam :String {get}//"This message is spam"
    var nolong_Accom : String {get}//"I no longer need accommodations",
    var mytrav_Dat : String {get}//"My travel dates changed",
    var res_Acc : String {get}//"I made the reservation by accident",
    var hos_Cancel : String {get}//"My host needs to cancel",
    var uncomfor_Host : String {get}//"I’m uncomfortable with the host",
    var plc_Expect : String {get}//"The place isn't what I was expecting"
    var errorinCancel : String {get}//"Enter a Valid Reason"
    
    //MARK:-CancelRequestVC
    var canres_Tit : String {get}//Cancel this Reservation
    var can_Reser : String {get}//Cancel My Reservation
    
    //MARK:-ConversationVC
    var preapprove_Title : String {get}//Pre-Approve
    var prepproved_Title : String {get}//Pre-Approved
    var cancelreser_Title : String {get}//Cancel Reservation
    var archive_Title : String {get}//Archive
    var help_Title : String {get}//Help
    var write_Msg : String {get}//"Write a message"
    
    //MARK:-HostInboxVC
    var noreser_Msg : String {get}//You have no reservation
    var expires_Title : String {get}//Expires
    var discuss_Title : String {get}//Discuss
    var msghist_Title : String {get}//Message History
    var totalcost_Title : String {get}//TotalCost
    var decline_Title : String {get}//Decline
    var addguestfee_Title : String {get}//Additional Guest fee
    var secfee_Title : String {get}//Security fee
    var reser_Tit : String {get}//reservation
    var resers_Tit : String {get}//reservations
    var cleanfee_Title : String {get}//Cleaning fee
    
    //MARK:-TripsDetailVC
    var inq_Title : String {get}//Inquiry
    var no_Tit : String {get}//no
    var canld_Tit : String {get}//Cancelled
    var decld_Tit : String {get}//Declined
    var exp_Tit : String {get}//Expired
    var accep_Tit : String {get}//Accepted
    var preaccep_Tit : String {get}//Pre-Accepted
    var pend_Tit : String {get}//Pending
    
    //MARK:-PreAcceptVC
    var thisreq_Title : String {get}//this request
    
    //MARK:-TripsHistoryVC
    var send_Title : String {get}//Send
    
    //MARK:-ViewReceipt
    var hostapp_Msg : String {get}//Host appreciate a thoughtful hello
    
    //MARK:-StripeVC
    var male_Title : String {get}//Male
    var legalDocError : String {get}//Please Upload Document
    var female_Title : String {get}//Female
    var acc_NumTit : String {get}//Account Number
    var bankst_Tit : String {get}//BSB
    var clrcod_Tit : String {get}//"Clearing Code"
    var brnch_Tit : String {get}//"Branch Code"
    var brnch_Nam : String {get}//"Branch Name"
    var bank_Cd : String {get}//"Bank Code"
    var acc_OwnName : String {get}//Account Owner Name
    var pls_Ent : String {get}//Please Enter the
    var phn_Num : String {get}//"Phone Number"
    var trnas_Num : String {get}//"Transit Number"
    var acc_OwnNa : String {get}//Account Owner Name
    var intnum_Tit : String {get}//"Institution Number"
    var rount_Num : String {get}//"Rounting Number"
    var ssn4_Tit : String {get}//"SSN Last 4 Digits"
    var bnk_namme : String {get}//"Bank Name"
    var bnk_Code : String {get}//"Bank Code"
    var srtcd_Tit : String {get}//"Sort Code"
    var takephoto_Title : String {get}//Take Photo
    var choosephoto_Title : String {get}//Choose Photo
    var legal_Doc : String {get}//Legal Document
    var additional_Doc : String {get}//Additional Document
    var acc_HoldName : String {get}//Account Holder Name
    var add1_Val : String {get}//Address1
    var stat_Prov : String {get}//State/Province
    var iban_Num : String {get}//IBAN Number
    var strip_Det : String {get}//Stripe Details
    
    var error_Title : String {get}//Error
    var nocam_Error : String {get}//Device has no camera
    var updatlegal_Error : String {get}//Please update a legal document.
    var updatAddition_Error : String {get}//Please update a additional document.
    
    //MARK:-ProfileVC
    var travel_Title : String {get}//travel
    var viewedt_Tit : String {get}//
    var swit_Tit : String {get}//switch
    var switchhost_Title : String {get}//Switch to Host
    var switchtravel_Title : String {get}//Switch to Travel
    var helpandsup_Title : String {get}//Help & Support
    var whyhost_Title : String {get}//Why host
    var editprof_Title : String {get}//Edit Profile
    
    //MARK:-AddPhotoVC
    var edt_Title : String {get}//Edit
    
    //MARK:-ViewProfileVC
    var memsin_Tit : String {get}//Member Since
    var verif_Info : String {get}//Verify Info
    
    //ProfileSettings
    var profset_Payout : String {get}//Payout Methods
    var vers_Tit : String {get}//Version
    var logot_Tit : String {get}//Logout
    
    //MARK:-AddGuestEmailCell
    var email_Opt : String {get}//Email address (optional)
    
    //MARK:-EditProfileVC
    var upload_Error : String {get}//Upload failed. Please try again
    var notspeci_Title : String {get}//Not Specified
    var firstname_Tit : String {get}//"First name"
    var lastname_Tit : String {get}//"Last name"
    var abtme_Tit : String {get}//"About me"
    var gender_Tit : String {get}//"Gender"
    var bithdt_Tit : String {get}//"Birth date"
    var loca_Tit : String {get}//"Location"
    var schl_Tit : String {get}//"School"
    var wrk_Tit : String {get}//"Work"
    
    var frst_Nam : String {get}//"Enter First name"
    var lst_Nam : String {get}//"Enter Last name"
    var abt_Me : String {get}//"About me"
    var sel_Gen : String {get}//"Select Gender"
    var sel_DOb : String {get}//"Select Birth date"
    var ent_Email : String {get}//"Enter Email"
    var ent_Loc : String {get}//"Enter Location"
    var ent_Sch : String {get}//"Enter School"
    var ent_wrk : String {get}//"Enter Work"
    var edt_Titl : String {get}//"Edit Title"
    
    //MARK:-DescriptionsDetailPageVC
    var det_Desc : String {get}//Detail Descriptions
    
    //MARK:-AboutPayout
    var setup_Title : String {get}//Set up your
    var def_Tit : String {get}//Default
    var mk_Deftit : String {get}//Make Default
    var dele_Tit : String {get}//Delete
    var payoutmeth_Title : String {get}//payout method
    var payout_Tit : String {get}//Payouts
    var paypal_Meth : String {get}//"Add Paypal Payout"
    var stripe_Meth : String {get}//"Add Stripe Payout"
    var submit_Tit : String {get}//Submit
    var updatedob_Error: String {get}//Please update the DOB In EditProfile
    var payot_Msg : String {get}//"Your payout is what you earn from hosting a guest. Payouts are sent 24 hours after each check-in."
    
    //MARK:-PayoutDetails
    var address_Title : String {get}//Address
    var addresspay_Title : String {get}//Address for Payout
    var address2_Title : String {get}//Address2
    var city_Title : String {get}//City
    var state_Title : String {get}//State
    var paypal_EmailId : String {get}//Paypal Email Id
    var postal_Title : String {get}//Postal Code
    var country_Title : String {get}//Country
    var paypal_EmailErr : String {get}//Please enter Paypal email id
    var addr_FieldErr : String {get}//Please fill Address field
    var city_FieldErr : String {get}//Please fill City field
    var state_FieldErr : String {get}//Please fill State field
    var postalcode_FieldErr : String {get}//Please fill Postal Code field
    var country_FieldErr : String {get}//Please fill Country field
    
    //MARK:-TripLengthVC
    var guestmin_Title : String {get}//Guest Stay For Minimum
    var during_Title : String {get}//During
    var night_Title : String {get}//Nights
    var guestmax_Title : String {get}//Guest Stay For Maximum
    
    //MARK:-MaxMinStay1
    var minmx_Stay : String {get}//Min and Max Stay
    var min_Stay : String {get}//Minimum stay
    var max_Stay : String {get}//Maximum stay
    var req_Msg : String {get}//Add requirements for seasons or weekends
    
    
    
    //MARK:-CustomMinMax
    var  reser_Sett : String {get}//Reservation Settings
    var sel_Dat : String {get}//Select Dates
    var close_Tit : String {get}//Close
    var cus_Tit : String {get}//Custom
    var ent_Sdt : String {get}//Enter Start Date
    var ent_Edt : String {get}//Enter End Date
    
    //MARK:-EditEarliyDiscountsVc
    var earlybird_Disc : String {get}//Early Bird Discounts
    var lastmin_Disc : String {get}//Last min Discounts
    var discpercent_Err : String {get}//Please enter the discount percentage
    var numofnight_Err : String {get}//Please enter the number of nights
    
    //MARK:-EditLengthOfDiscountsVC
    var choosenight_Error : String {get}//"Please choose a nights"
    
    //MARK:-CustomMinMaxVC
    var edt_Tit : String {get}//"edit"
    var choosestdate_Error : String {get}//"Please choose Start date"
    var chooseeddate_Error : String {get}//"Please choose End date"
    var minsty_Error : String {get}//"Please enter the minimum stay field"
    var maxsty_Error : String {get}//"Please enter the maximum stay field"
    var choose_DtError : String {get}//Please choose a Dates
    
    //MARK:-SSCalendarTimeSelector Days,done,cancel
    var datealready_Reser : String {get}//This Date already Reserved
    var noliss_Tit : String {get}//No Listing
    var mon_Sym : String {get}//M
    var tues_Sym : String {get}//T
    var wednes_Sym : String {get}//W
    var thrus_Sym : String {get}//T
    var fri_Sym : String {get}//F
    var sat_Sym : String {get}//S
    var sun_Sym : String {get}//S
    var noliss_Msg : String {get}//You have no listing right now.
    var saving_Title : String {get}//Saving...
    var svd_Title : String {get}//Saved...
    var addlist_Title : String {get}//Add Listing
    var sve_Chngs : String {get} //Save Changes
    var avail_Tit : String {get}//Available
    var blck_Tit : String {get}//Blocked
    var night_Pric : String {get}//Nightly Price
    
    
    //MARK:-CreateWhishList
    var creat_List : String {get}//Create a list
    var privacy_Tit : String {get}//Privacy
    var creat_Tit : String {get}//Create >
    
    //MARK:-SearchVC
    var where_To : String {get}//Where to?
    var nearby_Tit : String {get}//Nearby
    var crtlist_Tit : String {get}//CreatedList
    var anywhere_Tit : String {get}//Anywhere
    var clr_Tit : String {get}//Clear
    
    var steps_Title : String {get}//steps
    
    //MARK:-HostHome
    var noreser_Req : String {get}//No Reservation Requests
    
    //MARK:-HostListing
    var unlis_Title : String {get}//Unlisted
    var addnw_List : String  {get}//Add New Listing
    var host_List : String {get}//Your Listings
    var in_Title : String {get}//in
    var lis_Title : String {get}//Listed
    var stplis_Title : String {get}//steps to list
    
    //MARK:-LocationVC
    var exactloc_Title : String {get}//"Exact Location Found"
    var exactlocnot_Title : String {get}//"Exact Location Not Found"
    var locfound_Title : String {get}//Location Found
    var manualpin_Title : String {get}//Would you like to manually pin this listing's location on a map?
    var edtAdd_Title : String {get}//Edit Address
    var pinMap_Title : String {get}//Pin on Map
    
    //MARK:-RoomBedSelection
    var homtyp_Title : String {get}//Home Type
    var bedtyp_Title : String {get}//Bed Type
    var rom_Typ : String {get}//Space Type
    var some_Titt: String {get}//"Some"
    var bdrms_Tit : String {get}//"Bedrooms"
    var maxgues_Tit : String {get}//"Max Guests"
    
    //MARK:-FilterRoomTypes
    var rom_Typs : String {get}//Room Types
    
    //MARK:-AddRoomDetails
    var desplac_Title : String {get}//"Describe your place"
    var optidet_Title : String {get}//"Optional Details"
    var addpht_Tit : String {get}//Add Photos
    var addphts_Tit : String {get}//Add photo
    var prev_Tit : String {get}//Preview
    var set_Price : String {get}//"Set Price"
    var set_Addr : String {get}//"Set Address"
    var booktyp_Tit : String {get}//Booking Type
    var sethous_Rules : String {get}//"Set House Rules"
    var setbook_Type : String {get}//"Set Booktype"
    var summ_Highlight : String {get}//"Summarize the highlights of your  listing"
    var sug_Price : String {get}//"Try our suggested  price to start"
    var conf_Price : String {get}//"Only confirmed guests see your address"
    var guest_Agree : String {get}//"Guests agree to rules before booking"
    var guest_Book : String {get}//"How guests can book"
    var ready_List : String {get}//Ready to List
    var list_Space : String {get}//List your space
    var unlist_Space : String {get}//Unlist your space
    var nolis_Err : String {get}//Room Listing Waiting For Admin Approval
    var expect_Behave : String {get}//How do you expect guests to behave?
    
    //MARK:-AddRoomImageVC
    var internal_Err : String {get} //"Inter error occured, please try again..."
    var imglarge_Error : String {get}//"Upload failed!!!. Image is too large"
    
    //MARK:-SmartPricing
    var minprice_Trip : String {get}//"Min Price Tip: ₹1,084"
    var maxprice_Trip : String {get}//"Max Price Tip: ₹4,644"
    var whyimp_Setting : String {get}//"Why is this setting important"
    
    //MARK:-DescripePlace
    var add_Tit : String {get}//Add a title

    var clr_Desc : String {get}//Be clear and descriptive.
    var writ_Summ : String {get}//Write a summary
    var travabt_Space : String {get}//Tell travelers what you love about the space. You can include details about the decor, the amenities it includes, and the neighborhood.
    var edit_Tit : String {get}//Edit Title
    var edit_Summ : String {get}//Edit Summary
    
    //MARK:-AboutListing
    var thespac_Tit : String {get}//The Space
    var guesacc_Tit : String {get}//Guest Access
    var interact_Guest : String {get}//Interaction with Guests
    var overview_Tit : String {get}//Overview
    var getarnd_Tit : String {get}//Getting Around
    var otherthng_Tit : String {get}//Other Things to Note
    var houserul_Titl : String {get}//House Rules
    var addinf_Space : String {get}//"You can add more information about what makes your space unique."
    var trav_Access : String {get}//"Let travelers know what parts of the space they’ll be able to access."
    var availgues_Stay : String {get}//"Tell guests if you’ll be available to offer help throughout their stay."
    var shwpeop_Uniq : String {get}//"Show people looking at your listing page what makes your neighborhood unique."
    var pub_Trans : String {get}//"You can let travelers know if your listing is close to public transportation (or far from it). You can also mention nearby parking options."
    var trav_Othr : String {get}//"Let travelers know if there are other details that will impact their stay."
    var beh_Expt : String {get}//"How do you expect your guests to behave?"
    
    var travoth_Dets : String {get}//"Let travelers know if there are other details that will impact their stay."
    var det_Title : String {get}//Details
    var tneigh_Title : String {get}//"The Neighborhood"
    var exdet_Title : String {get}//"Extra Details"
    
    //MARK:-CategorySelection
    var whattodo_Tit : String {get}//What to do?
    
    //MARK:-EditTitleVC
    var chlef_Tit : String {get}//Characters left
    var edittit_Tit : String {get}//Edit Title
    var tspc_Title : String {get}//"The Space"
    var gustAcc_Title : String {get}//"Guest Access"
    var interac_Guest : String {get}//"Interaction with Guests"
    var overv_Title : String {get}//"Overview"
    var getarnd_Title : String {get}//"Getting Around"
    var othtin_Title : String {get}//"Other Things to Note"
    var housrul_Title : String {get}//"House Rules"
    
    //MARK:-EditPriceVC
    var romadpri_Tit : String {get}//"Room and Additional Prices changed to Minimum Price"
    var yes_Tit : String {get}//Yes
    
    var edtpric_Tit : String {get}//Edit Price
    var fixpric_Msg : String {get}//Fixed price is your default nightly rate
    var chng_Curr : String {get}//Change Currency
    var learn_Mre : String {get}//Learn More
    
    //Update Location
    var street_Tit : String {get}//Street
    var aptbuild_Tit : String {get}//Apt/Building
    var zip_Titt : String {get}//zip
    
        //MARK:-Rooms&Beds
        var roomandbeds:String {get}//Rooms&Beds
        var room_Desc : String {get}//Just a little more about your house...
        var created_List : String {get}//You've Created Your Listing
        var morestps_Msg : String {get}//more steps to list your space
        var finish_List : String {get}//Finish My Listing
    //
    
    
    //MARK:-Describe your place
    var descpl_Title : String {get}//Describe your place
    var addtit_Title : String {get}//Add a title
    var writsum_Title : String {get}//write a summary
    

    
    //MARK:-AllAmentiesVC
    var estent_Title : String {get}//"Essentials~~~1"
    var tv_Title : String {get}//"TV~~~2"
    var cabltv_Title : String {get}//"Cable TV~~~3"
    var aircon_Title : String {get}//"Air Conditioning~~~4"
    var heating_Title : String {get}//"Heating~~~5"
    var kitchen_Title : String {get}//"Kitchen~~~6"
    var internet_Title : String {get}//"Internet~~~7"
    var wifi_Title : String {get}//"Wireless Internet~~~8"
    var hottub_Title : String {get}//"Hot tub~~~9"
    var washer_Title : String {get}//"Washer~~~10"
    var pool_Title : String {get}//"Pool~~~11"
    var dryer_Title : String {get}//"Dryer~~~12"
    var brkfst_Title : String {get}//"Breakfast~~~13"
    var freprk_Title : String {get}//"Free Parking on Premises~~~14"
    var gym_Title : String {get}//"Gym~~~15"
    var elev_Title : String {get}//"Elevator in Building~~~16"
    var indoor_Title : String {get}//"Indoor Fireplace~~~17"
    var buzz_Title : String {get}//"Buzzer/Wireless Intercom~~~18"
    var doorman_Title : String {get}//"Doorman~~~19"
    var shamp_Title : String {get}//"Shampoo~~~20"
    var famkid_Title : String {get}//"Family/Kid Friendly~~~21"
    var smoking_Title : String {get}//"Smoking allowed~~~22"
    var suitevnt_Title : String {get}//"Suitable for events~~~23"
    var petallow_Title : String {get}//"Pets Allowed~~~24"
    var petliv_Title : String {get}//"Pets live on this property~~~25"
    var whelchr_Title : String {get}//"Wheelchair Accessible~~~26"
    var smkdet_Title : String {get}//"Smoke Detector~~~27"
    var crbndet_Title : String {get}//"Carbon Monoxide Detector~~~28"
    var firstaid_Title : String {get}//"First Aid Kit~~~29"
    var sftcrd_Title : String {get}//"Safety Card~~~30"
    var firext_Title : String {get}//"Fire Extinguisher~~~31"
    
    //MARK:-DiscountPrice
    var clenfee_Title : String {get}//"Cleaning fee"
    var addgues_Title : String {get}//"Additional guests"
    var echgues_Title : String {get}//"For each guest after"
    var secdep_Title : String {get}//"Security deposit"
    var weekendpric_Title : String {get}//"Weekend pricing"
    var mnthly : String {get}//monthly
    var wkly : String {get}//weekly
    var addpri : String {get}//"Additional Prices"
    var setpric_Msg : String {get}//You can set a price to reflect the space, amenities, and hospitality you'll be providing
    var givdis_Msg : String {get}//You can give discounts for your list from our website
    
    //MARK:-OptionalDetailVC
    var reserset_Title : String {get}//Reservation Settings
    var curren_Title : String {get}//Currency
    var rombed_Title : String {get}//Rooms & Beds
    var descript_Title : String {get}//Description
    var ament_Title : String {get}//Amenities
    var policy_Title : String {get}//Policy
    var pric_Title : String {get}//Price
    var flexi_Title : String {get}//"Flexible"
    
    var mod_Title : String {get}//"Moderate"
    var strt_Title : String {get}//"Strict"
    
    //MARK:-HostRulesVC
    var suit_Child : String {get}//"Suitable for children\n(Age 2-12)"
    var suit_Infant : String {get}//"Suitable for infants\n(Under 2)"
    var pet_Allow : String {get}//"Pets allowed"
    var smok_Allow : String {get}//"Smoking allowed"
    var parties_Allow : String {get}//"Parties allowed"
    var Add_Rules : String {get}//Addtional Rules
    var list_Suit : String {get}//"Is my listing suitable for children?"
    
    //MARK:-CalenderSettings
    var adnot_Title : String {get}//"Advance Notice"
    var preptim_Title : String {get}//"Preparation Time"
    var disreq_Title : String {get}//"Distant requests"
    var arok_Title : String {get}//"Are okay"
    var minmax_Title : String {get}//"Minimum and maximum stay"
    var nig1min_Title : String {get}//"1 night minimum"
    var samdy_Title : String {get}//"Same day (customizable cutoff hour)"
    var notic1dy_Msg : String {get}//"Atleast 1 day's notice"
    var notic2dy_Msg : String {get}//"Atleast 2 day's notice"
    var notic3dy_Msg : String {get}//"Atleast 3 day's notice"
    var notic7dy_Msg : String {get}//"Atleast 7 day's notice"
    var howtim_Msg : String {get}//"Set how much time you need before a guest checks in."
    var non_Title : String {get}//"None"
    var blk1nig_Msg : String {get}//"Block 1 night before and after reservations"
    var blktim_Msg : String {get}//"Let you block time between reservations to clean your space or relax."
    var guearr_Msg : String {get} //"Guest arriving any time are okay"
    var wnt3mnths_Msg : String {get}//"I want guests who arrive within 3 months"
    var wnt6mths_Msg : String {get}//"I want guests who arrive within 6 months"
    var wnt1yr_Msg : String {get}//"I want guests who arrive within 1 year"
    var blocreq_Msg : String {get}//"You can block requests for reservations that are too far off to plan for."
    
    //MARK:-AdvanceNotice
   // var samedy_Title : String {get}//"Same day (customizable cutoff hour)"
    //MARK:- Makent sAss NewHome
    var date : String {get} //Dates
    var guests : String {get} //Guests
    var filter : String {get} //Filter
    var showAll : String{get} //Show All
    var coupamnt_Tit : String {get}//Coupon Amount
    
    //MARK:- homeVariantTVC
    var categories : String{get}//Categories
    
    //MARK:- AddRoomBedVC
    var rom_Sucess : String{get}//Rooms Details Added Successfully.
    var commonSpace : String{get}//Common Space
    var addBeds : String{get}//Add Beds
    var addBedTypeError : String {get}//Please Add Atleast One Bed Type With Bed
    var alert : String {get} //Alert
    var discardMessage : String {get}//All the changes you have made will be discared !
    var discard : String{get}//Discard
    var noBedsErr : String{get}//has no beds in it.
    //Mark:- OwnerTitleVC
    var ownby_Title : String{get}//Owned By
    
    //Mark:- CouponVC
    var ent_Coup : String {get}//Enter your coupon code
    var app_Tit : String {get}//Apply
    var coup_Tit : String {get}//COUPON CODE
    
    //Mark:- AddSpaceViewController
    var hostspc_Title : String {get}//Host User, tell about your space
    var hostspc_Desc : String {get}//The more you share, the faster you can get a booking
    var hostspc_Done : String {get}//Your listing is
    var basic_Title : String {get}//The Basics
    var set_Title : String {get}//Setup
    var readytohost_Title : String {get}//Get ready to host
    var spacegues_Title : String{get}//Space details, guests
    var photospac_Title : String{get}//Photos, Space description
    var pricavail_Title : String{get}//Pricing, availablity, booking settings
    var select_Title : String{get}//Select
    
    //Mark:- SpaceListViewController
    var spcListDesc : String{get}//Your Listings will appear here
    var youarTitle : String{get}//You're
    var ofthrTitle : String{get}//of the way there
    var fnshTitle : String{get}//Finish your listing
    var mrStpTit : String{get}//More Step to Complete
    var mrStpsTit : String{get}//More Steps to Complete
    var addAnthrSpc : String{get}//Add Another Space
    
    //Mark:- TypeSpaceViewController
    var typeSpaceTitle : String{get}//What type of space do you have?
    var asteriskSymbol : String{get}//*
    var spcAlert : String{get}//Please Select Space Type
    var hlpEveOrg : String{get}//Help Event Organizer to Find the Right Fit
    var getStartList : String {get}//return "Lets get started listing your space
    var peopSearch : String{get}//People searching on
    var peopSearchNew : String {get}// return "People all over the country are searching for a space like yours! When they use Spaciko to find you, they'll have the option to filter search results by listing basic information to find a match. By carefully completing the questions in this section, you can help them achieve their goals and, in turn, maximize your chances of begin found!
    var mthNeeds : String{get}//can filter by listing basics to find a space that matches their needs.
    
    //Mark:- AccessibilityViewController
    var spaceAccessTitle : String{get}//How can guests access your space
    var spaceAccessAlert : String{get}//Please Select Atleast One Access From List
    
    //Mark:- GuestAccessViewController
    var noOfRooms : String{get}//Number of Rooms
    var noOfResRooms : String{get}//Number of Restrooms
    var flrNum : String{get}//Floor number (if applicable)
    var estFootSpc : String{get}//Estimated square footage of the available Space
    var footSpcAlert : String{get}//Please Enter or Add Footage Space Value
    
    //Mark:- SpaceAmenitiesViewController
    var amentiesDesc : String{get}//What amenities does your space offer?
    
    //Mark:- SpaceGuestViewController
    var maxGuestDesc : String{get}//Maximum number of guests
    var guesCountAlert : String{get}//Please Enter or Add Guest Count
    
    //Mark:- ExtraServicesViewcontroller
    var servDesc : String{get}//What services and extras do you offer
    var addInfDesc : String{get}//Additional information about services, packages and rates:
    var additionalInf : String{get}//Enter Additional Information
    
    //Mark:- SpaceAddressViewController
    var chkGuidance : String{get}//Check-In Guidance
    var aptTitle : String{get}//Apt #, Floor #, etc.
    var chsOnMap : String{get}//Choose on Map
    var shrDesc : String{get}//Share any special instructions needed for organizers to access the space. e.g. door lock code, on-site manager.
    var infrmDesc : String{get}//This information will only be shared upon booking confirmation.
    var spcAddressAlert : String{get}//Please Enter Space Address
    var fulladdDesc : String{get}//What is the full address of your space?
    var checkinDesc : String{get}//Enter Check-In Guidance Description
    
    //Mark:- AddSpacePhotoViewController
    var spacePhotoTitle : String{get}//Add Space Photo
    var photoUploadAlert : String{get}//Please upload atleast one photo.
    var spcHighlgt : String{get}//Enter Space Highlights
    var spcPhtAlert : String{get}//Are you sure you wish to delete this photo? It is a nice one!
    
    //Mark:- SpaceFeaturesViewController
    var spcStyleDesc : String{get}//"The style of your space can be described as"
    var spcFeatDesc : String{get}//"What special features does your space have?"
    var spcRulesDesc : String{get}//"Set your Space Rules"
    
    //Mark:- SpaceDescriptionViewController
    var travelTitle : String{get}//Tell Travelers About Your Space
    var travelDesc1 : String{get}//"Every space on"
    var travelDesc2 : String{get}//is unique. Highlight what makes your listing welcoming so that it stands out to guests who want to stay in your area
    var lisNameTit : String{get}//Listing Name
    var sumTit : String{get}//Summary
    var charsLeft : String{get}//characters left
    var charLeft : String{get}//character left
    var signInWith : String {get}
    
    //Delete account
    
    var accDelete : String {get}

    var confirm : String {get}
    var close : String {get}
    var confrimationDlt : String {get}
    
    
    var deleteUser1 : String {get}
    var deleteUser2 : String {get}
    var deleteUser3 : String {get}
    var deleteUser4 : String {get}
    var deleteUser5 : String {get}
    var deleteUser6 : String {get}
    var deleteUser7 : String {get}

    var confirmationText : String {get}
    var payoutContent : String {get}

    var DeltedTxt : String {get}
    var DeleteConfirmation : String {get}
    var add_Title_Describtion : String {get}
    
    var Tax : String {get}
    
    var addPhoto: String {get}
    var aboutFirstPt: String {get}
    var aboutSecondPt: String {get}
    var aboutThirdPt: String {get}
    var aboutFourthPt: String {get}
    var delete_acc_content : String { get }
    
}

