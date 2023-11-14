//
//  BasicStepModel.swift
//  Makent
//
//  Created by trioangle on 26/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation



class BasicStpData{
    
    //Mark:- Number of Room Step Data
    enum RoomDataIndex : Int{
        case rooms
        case restRooms
        case floorNumber
        static let total = 3
    }
    var roomData = Array(0...RoomDataIndex.total).compactMap({$0*0})
    
    var footageSpace : Int = 0
    var spaceTypeVal =  String()
    
    var fullyFurnished = String()
    
    var noOfWorkstations = Int()
    
    var sharedPrivate = String()
    
    var rentingSpaceFirstTime = String()
    
    //Mark:- Number of Guest Step Data
    var noofGuest : Int = 0
    
    var guesAccessList = String()
    
    var amenitiesList = String()
    
    var servicesList = String()
    
    var extServices = String()
    
    var styleList = String()
    
    var featureList = String()
    
    var rulesList = String()
    
    //Mark:- Space Name Step Data
    var spaceName =  String()
    
    static let shared = BasicStpData()
    
    //Mark:- Space Id Step Data
    var spaceID = String()
    
    
    
    func getValue(_ roomKey : RoomDataIndex) -> Int{
        return roomData.value(atSafeIndex: roomKey.rawValue) ?? 0
    }
    
    func getJsonVal(_ json : JSONS, key : String) -> String{
        return json.string(key)
    }
    
    var currentScreenState : SpaceList?{
        didSet{
            guard let _state = self.currentScreenState else{return}
            UINavigationController.progressBar.setProgress(_state.getProgress, animated: true)
        }
    }
    
    var crntScreenSetupState : SpaceSetupList?{
        didSet{
            guard let _state = self.crntScreenSetupState else{return}
            UINavigationController.progressBar.setProgress(_state.getProgress, animated: true)
        }
    }
    
    var crntScreenHostState : SpaceReadyToHost?{
        didSet{
            guard let _state = self.crntScreenHostState else{return}
            UINavigationController.progressBar.setProgress(_state.getProgress, animated: true)
        }
    }
    
    var isSelected = false
    
    
    
    //Mark:-Edit or New Space Checking When List a Space
    var isEditSpace = Bool()
    var selectedVal = [Int]()
    
    //Mark:- Getting Selected Values While Edit
    func getVal(_ stringVal: String){
        
        let guestAccess = stringVal
        let StringRecordedArr = guestAccess.components(separatedBy: ",")
        print(StringRecordedArr.compactMap({($0 as NSString).integerValue}))
        self.selectedVal = StringRecordedArr.compactMap({($0 as NSString).integerValue})
        print("SelectedValues:",self.selectedVal)
        
    }
    
    
    
    
    
    var id = Int()
    var name =  String()
    var status =  String()
    var spaceType = JSONS()
    
    var description =  String()
    var icon =  String()
    var mobileIcon =  String()
    var imageName =  String()
    
    
    var adminStatus =  String()
    var countryName =  String()
    var photoName =  String()
    var spaceId = Int()
    var spaceTypeName =  String()
    var placeDescription =  String()
    
    
    var photoId = Int()
    var highlights =  String()
    var imageUrl =  String()
    
    var completed = Int()
    var remain_Stps = Int()
    
    //Basics
    var numberOfRooms = Int()
    var numberOfRestrooms = Int()
    var numberOfGuests = Int()
    var floorNumber = Int()
    var squareFeet = Int()
    
    var sizeType =  String()
    var amenities =  String()
    var services =  String()
    var spaceStyle =  String()
    var servicesExtra = String()
    //var spaceAddress = ExpLocationModel()
    var guestAccess = String()
    var spacePhotos = [JSONS]()
    var spaceFeatures = String()
    var spaceRules = String()
    var summary = String()
    
    
    var addressLine1 = String()
    var addressLine2 = String()
    var city = String()
    var state = String()
    var country = String()
    var postalCode = String()
    var guidance = String()
    var latitude = String()
    var longitude = String()
    var readyToHost:ReadyToHost!
    
   
    
    
    
   
    
    init() {
        
    }
    
    init(_ json : JSONS) {
        
        self.id = json.int("id")
        self.name = json.string("name")
        self.status = json.string("status")
        self.description = json.string("description")
        self.spaceType = json.json("space_type")
        self.icon = json.string("icon")
        self.remain_Stps = json.int("remaining_steps")
        self.mobileIcon = json.string("mobile_icon")
        self.imageName = json.string("image_name")
        //self.spaceAddress = ExpLocationModel(json: json)
        
        self.numberOfRooms = json.int("number_of_rooms")
        self.numberOfRestrooms = json.int("number_of_restrooms")
        self.floorNumber = json.int("floor_number")
        
        self.roomData.removeAll()
        self.roomData.append(self.numberOfRooms)
        self.roomData.append(self.numberOfRestrooms)
        self.roomData.append(self.floorNumber)
        
        self.fullyFurnished = json.string("fully_furnished")
        
        self.noOfWorkstations = json.int("no_of_workstations")
        
        self.sharedPrivate = json.string("shared_or_private")
        
        self.rentingSpaceFirstTime = json.string("renting_space_firsttime")
        
        self.squareFeet = json.int("sq_ft")
        self.sizeType = json.string("size_type")
        self.adminStatus = json.string("admin_status")
        self.countryName = json.string("country_name")
        
        self.guestAccess = json.string("guest_access")
        self.numberOfGuests = json.int("number_of_guests")
        self.amenities =  json.string("amenities")
        self.services =  json.string("services")
        self.spaceStyle =  json.string("space_style")
        self.servicesExtra = json.string("services_extra")
       
       
        self.spacePhotos = json.array("space_photos")
        self.photoName = json.string("photo_name")
        self.spaceId = json.int("space_id")
        self.spaceTypeName = json.string("space_type_name")
        self.placeDescription = json.string("description")
        self.spaceFeatures = json.string("special_feature")
        self.spaceRules = json.string("space_rules")
        self.summary = json.string("summary")
        
        self.photoId = json.int("id")
        self.highlights = json.string("highlights")
        self.imageUrl = json.string("image_url")
        
         self.addressLine1 = json.string("address_line_1")
         self.addressLine2 = json.string("address_line_2")
         self.city = json.string("city")
         self.state = json.string("state")
         self.country = json.string("country")
         self.countryName = json.string("country_name")
         self.postalCode = json.string("postal_code")
         self.latitude = json.string("latitude")
         self.longitude = json.string("longitude")
        self.guidance = json.string("guidance")
        self.completed = json.int("completed")
        self.readyToHost = ReadyToHost(json.json("ready_to_host"))
        
        
    }
    
}
//extension BasicStpData:NSItemProviderWriting{
//
//
//
//    static var writableTypeIdentifiersForItemProvider: [String] {
//        return []
//    }
//
//    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//        return nil
//    }
//
//
//}
extension BasicStpData{
    
    
    
    func copy() -> BasicStpData {
        
        
        let bsic = BasicStpData()
        
        //bsic.isEditSpace = self.isEditSpace
        
        bsic.footageSpace = self.footageSpace
        bsic.spaceTypeVal = self.spaceTypeVal
        bsic.noofGuest = self.noofGuest
        bsic.guesAccessList = self.guesAccessList
        bsic.amenitiesList = self.amenitiesList
        bsic.servicesList = self.servicesList
        bsic.extServices = self.extServices
        bsic.styleList = self.styleList
        bsic.featureList = self.featureList
        bsic.rulesList = self.rulesList
        bsic.spaceName = self.spaceName
        bsic.selectedVal = self.selectedVal
        
        bsic.id = self.id
        bsic.name = self.name
        bsic.status =  self.status
        bsic.description = self.description
        bsic.spaceType = self.spaceType
        bsic.icon = self.icon
        bsic.remain_Stps = self.remain_Stps
        bsic.mobileIcon = self.mobileIcon
        bsic.imageName = self.imageName
        
        
        bsic.numberOfRooms = self.numberOfRooms
        bsic.numberOfRestrooms = self.numberOfRestrooms
        bsic.floorNumber = self.floorNumber
        bsic.roomData = self.roomData
        
        bsic.fullyFurnished = self.fullyFurnished
        bsic.noOfWorkstations = self.noOfWorkstations
        bsic.sharedPrivate = self.sharedPrivate
        bsic.rentingSpaceFirstTime = self.rentingSpaceFirstTime
        bsic.squareFeet = self.squareFeet
        bsic.sizeType = self.sizeType
        
        bsic.adminStatus = self.adminStatus
        bsic.countryName = self.countryName
        
        bsic.guestAccess = self.guestAccess
        bsic.numberOfGuests = self.numberOfGuests
        bsic.amenities =  self.amenities
        bsic.services =  self.services
        bsic.spaceStyle =  self.spaceStyle
        bsic.servicesExtra = self.servicesExtra
        
        
        bsic.spacePhotos = self.spacePhotos
        bsic.photoName = self.photoName
        bsic.spaceId = self.spaceId
        bsic.spaceTypeName = self.spaceTypeName
        bsic.placeDescription = self.placeDescription
        bsic.spaceFeatures = self.spaceFeatures
        bsic.spaceRules = self.spaceRules
        bsic.summary = self.summary
        
        bsic.photoId = self.photoId
        bsic.highlights = self.highlights
        bsic.imageUrl = self.imageUrl
        
        bsic.addressLine1 = self.addressLine1
        bsic.addressLine2 = self.addressLine2
        bsic.city = self.city
        bsic.state = self.state
        bsic.country = self.country
        bsic.countryName = self.countryName
        bsic.postalCode = self.postalCode
        bsic.latitude = self.latitude
        bsic.longitude = self.longitude
        bsic.guidance = self.guidance
        bsic.completed = self.completed
        
        return bsic
    }
    
}


//extension BasicStpData : NSItemProviderWriting,NSItemProviderReading,codable{}




class ReadyToHost {
    
    var status  = String()
    var remaining_steps = Int()
    var booking_type = String()
    var cancellation_policy = [Space3Type]()
    var activityPriceModel:HostStepPriceModel!

    var security = String()
    var activity_types = [ActivitiesType]()
    
    var availability_times = [MainAvailableTimes]()
    var calendarData = JSONS()
    var available_times = [TimeData]()
    var not_available_times = JSONS()
    
    init(_ json:JSONS) {
         self.status = json.string("status")
         self.booking_type = json.string("booking_type")

         self.security = json.string("security")
         self.remaining_steps = json.int("remaining_steps")

         self.cancellation_policy.removeAll()
        json.array("cancellation_policy").forEach { (tempJSONS) in
            let model = Space3Type(tempJSONS)
            self.cancellation_policy.append(model)
        }
        self.activity_types.removeAll()
        json.array("activity_types").forEach { (tempJSON) in
            let model = ActivitiesType(tempJSON)
            self.activity_types.append(model)
        }
        self.activityPriceModel = HostStepPriceModel(json: json)
        
        self.calendarData = json.json("calendar_data")
        self.not_available_times = self.calendarData.json("not_available_times")
        self.available_times.removeAll()
        self.calendarData.array("available_times").forEach { (tempJSON) in
            let model = TimeData(tempJSON, type: .available)
            self.available_times.append(model)
        }
        self.calendarData.array("blocked_times").forEach { (tempJSON) in
            let model = TimeData(tempJSON, type: .block)
            self.available_times.append(model)
        }
        self.availability_times.removeAll()
        json.array("availability_times").forEach { (tempJSON) in
            let model = MainAvailableTimes(tempJSON)
            self.availability_times.append(model)
        }
       
        
    }
    
    init(){}
}
class Space3Type {
    var title = String()
    var key = String()
    var is_selected = Bool()
    
    init(_ json:JSONS) {
        self.title = json.string("title")
        self.key = json.string("key")
        self.is_selected = json.bool("is_selected")
    }
}




class MainAvailableTimes {
    
    var id = Int()
    var day = Int()
    var status = String()
    var toggleOn = Bool()
    var sub_availability_times = [SubAvailableTimes]()
//    var not_available_times = [SubAvailableTimes]()
//    var blocked_times = [SubAvailableTimes]()
//    var available = String()
    var currentAvaliableStatus:Availability {
        switch self.status {
        case "All":
            return .All
        case "Closed":
            return .Closed
        case "Open":
            return .Open
        case "Set hours":
            return .SetHours
        default:
            return .Closed
        }
    }
    
    func copy() -> MainAvailableTimes{
        let avail = MainAvailableTimes()
        avail.id = self.id
        avail.day = self.day
        avail.status = self.status
        avail.toggleOn = self.toggleOn
        avail.sub_availability_times = self.sub_availability_times
       return avail
    }
    
    init() {
           
       }
  
//    var getDict : String{
//        return "{\"id\":\(self.id),\"day\":\(self.day),\"status\":\"\(self.status)\",\"availability_times\":\(self.subTimes)}"
//    }
    init(_ json:JSONS) {
        self.id = json.int("id")
        self.day = json.int("day")
        self.status = json.string("status")
        self.sub_availability_times.removeAll()
        json.array("availability_times").forEach { (tempJSON) in
            let model = SubAvailableTimes(tempJSON)
            self.sub_availability_times.append(model)
        }

         self.toggleOn = self.status == "Open" ? true : false
        
        //Mark:- Checking Space Availablity Type
       
        
    }
    
   
    
    
   
}

extension MainAvailableTimes {
    func getDict()->JSONS{
        var param = JSONS()
        param["id"] = self.id
        param["day"] = self.day
        param["status"] = self.currentAvaliableStatus.text
        var subAvalibleParam = [JSONS]()
        self.sub_availability_times.forEach({subAvalibleParam.append($0.getDict())})
        param["availability_times"] = subAvalibleParam
        return param
    }
}

class SubAvailableTimes{
//    static func == (lhs: SubAvailableTimes, rhs: SubAvailableTimes) -> Bool {
//         return lhs.start_time == "" || rhs.end_time == ""
//    }
    
    var id = Int()
    var start_time = String()
    var end_time = String()
    var isSelected = Bool()
    init(_ json:JSONS) {
        self.id = json.int("id")
        self.start_time = json.string("start_time")
        self.end_time = json.string("end_time")
    }
    
    init(){
        
    }
}

extension SubAvailableTimes {
    func getDict()->JSONS {
        var param = JSONS()
        param["id"] = self.id
        param["start_time"] = self.start_time.getFormattedDate()
        param["end_time"] = self.end_time.getFormattedDate()
        return param
    }
}
class CalendarData{
    var availabletimes = [TimeData]()
    var notAvailableTimes = [TimeData]()
   // var blockedTimes = [TimeData]() //[String: [String]]()
   // var blockedTimes = [String: [String]]()
    init(_ json:JSONS) {
        json.array("availability_times").forEach { (tempJSON) in
            let model = TimeData(tempJSON, type: .available)
            self.availabletimes.append(model)
        }
        json.array("blocked_times").forEach { (tempJSON) in
            let model = TimeData(tempJSON, type: .block)
            self.notAvailableTimes.append(model)
        }
        //self.blockedTimes = json.json("blocked_times")
//        json.array("blocked_times").forEach { (tempJSON) in
//            let model = TimeData(tempJSON)
//            self.blockedTimes.append(model)
//        }
    }
    init(){}
}

class TimeData{
    enum TimeDataType{
        case block
        case available
        case notavailable
        
    }
    var endDate = String()
    var endTime = String()
    var notes = String()
    var source = String()
    var startTime = String()
    var startDate = String()
    var type : TimeDataType = .available
    
    init(_ json:JSONS,type: TimeDataType) {
        self.endDate = json.string("end_date")
        self.endTime = json.string("end_time")
        self.notes = json.string("notes")
        self.source = json.string("source")
        self.startDate = json.string("start_date")
        self.startTime = json.string("start_time")
        self.type = type
        
    }
    
    
    
}
