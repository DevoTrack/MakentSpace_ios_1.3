//
//  BasicStpDataModel.swift
//  Makent
//
//  Created by trioangle on 27/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class BasicStpData {
    
    //Mark:- Space Name Step Data
    var spaceName : String?
    
    //Mark:- Number of Room Step Data
    enum RoomDataIndex : Int{
        case rooms
        case restRooms
        case floorNumber
    }
    var roomData = [0,0,0]
    var footageSpace : Int = 0
    var spaceType : String?
    
    //Mark:- GuestAccess Step Data
    var guestAccess : [String]?
    
    //Mark:- Number of Guest Step Data
    var noofGuest : Int = 0
    
    //Mark:- Amenities Name Step Data
    var amenitiesName : [String]?
    
    //Mark:- Extra Services Step Data
    var extraServices : [String]?
    
    //Mark:- Address Step Data
    var addressOne : String?
    var addressTwo : String?
    var checkinGuidance : String?
    
    //Mark:- Step And Progress
    var stepCount : Int?
    
    var currentScreenState : SpaceList?{
        didSet{
            guard let _state = self.currentScreenState else{return}
            UINavigationController.progressBar.setProgress(_state.getProgress, animated: true)
        }
    }
    
}
