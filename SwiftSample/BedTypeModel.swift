//
//  BedTypeModel.swift
//  Makent
//
//  Created by trioangle on 17/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class BedType {
    let id : Int
    let name : String
    let icon : String
    
    var count = 0
    
    var iconURL : URL?{
        return URL(string: self.icon)
    }
    var getDisplayName : String?{
        if count == 0 {return nil}
        return "\(count.localize) \(self.name)"
    }
    init(_ json : JSONS) {
        self.id = json.int("id")
        self.name = json.string("name")
        self.icon = json.string("icon")
        self.count = json.int("count")
    
    }
    init(id : Int,name : String,icon : String,count : Int){
        self.id = id
        self.name = name
        self.icon = icon
        self.count = count
    }
    func copy()->BedType{
        return BedType(id: self.id,
                       name: self.name,
                       icon: self.icon,
                       count : self.count)
    }
    func override(usingBed bed : BedType){
        self.count = bed.count
    }
    var getDict : String{
        return "{\"id\":\(self.id),\"count\":\(self.count)}"
    }
}
extension BedType : Equatable{
    static func == (lhs: BedType, rhs: BedType) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
class BedRoom{
    var beds : [BedType]
    var headerview : AddRoomSHView
    var isValid : Bool{
        
        for bed in beds{
            if bed.count != 0{
               return true
            }
        }
     return false
    }
    init(beds : [BedType],headerview : AddRoomSHView){
        self.beds = beds
        self.headerview = headerview
    }
    var getDict : String{
        guard !beds.isEmpty else {
            return ""
        }
        var str = "["
        for bed in beds{
            str += "\(bed.getDict),"
        }
        str.removeLast()
        str.append("]")
        return str
    }
}

