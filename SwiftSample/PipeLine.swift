//
//  PipeLine.swift
//  Makent
//
//  Created by trioangle on 10/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class PipeLine{
    
    private init(){}
    struct Event {
        var id : Int?
        var name : String?
        var action : ()->()
    }
    struct DataEvent {
        var id : Int?
        var name : String?
        var dataAction : (Any?)->()
    }
    private static var events = [Event]()
    private static var dataEvents = [DataEvent]()
    
    static func createEvent(withName name : K_PipeNames ,action : @escaping ()->()) -> Int{
        PipeLine.events.append(Event(id : PipeLine.events.count,name: name.rawValue, action: action))
        return PipeLine.events.last?.id ?? -1
    }
    static func fireEvent(withName name : K_PipeNames)-> Bool{
        let _events = PipeLine.events.filter({$0.name == name.rawValue})
        for event in _events{
            guard event.name != nil else {return false}
            event.action()
        }
        return true
    }
    static func deleteEvent(withName name : K_PipeNames)->Bool{
        let _events = PipeLine.events.filter({$0.name == name.rawValue})
        for event in _events{
            guard let id = event.id else{return false}
            PipeLine.events.remove(at: id)
        }
        return true
    }
    static func deleteEvent(withID id : Int)->Bool{
        let event = PipeLine.events.filter({$0.id == id}).first
        guard let index = PipeLine.events.index(where: { (_event) -> Bool in
            return _event.id == event?.id
        }) else {return false}
        PipeLine.events.remove(at: index)
        return true
    }
    static func createDataEvent(withName name : K_PipeNames ,dataAction : @escaping (Any?)->()) -> Int{
        PipeLine.dataEvents.append(DataEvent(id : PipeLine.events.count,
                                             name: name.rawValue,
                                             dataAction: dataAction))
        return PipeLine.dataEvents.last?.id ?? -1
    }
    static func fireDataEvent(withName name : K_PipeNames,data : Any?)-> Bool{
        let _events = PipeLine.dataEvents.filter({$0.name == name.rawValue})
        for event in _events{
            guard event.name != nil else {return false}
            event.dataAction(data)
        }
        return true
    }
}
