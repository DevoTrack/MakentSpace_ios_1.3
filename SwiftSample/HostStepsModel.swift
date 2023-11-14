//
//  HostStepsModel.swift
//  Makent
//
//  Created by trioangle on 04/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation


class HostStepBasicmodel:ArrayModel
    
{
   
    var id = Int()
    var name = String()
    var isSelected = Bool()
    
    init(_ json: JSONS) {
        self.id =  json.int("id")
        self.name = json.string("name")
        self.isSelected = json.bool("is_selected")
    }
}


extension HostStepBasicmodel {
    func getAPIDict() -> JSONS {
        var params = JSONS()
        params["id"] = self.id
        params["name"] = self.name
        params["is_selected"] = self.isSelected
        return params
    }
}

class ActivitiesType:HostStepBasicmodel
{
    
    var mainActivities = [MainActivitiesModel]()
    var isColapsed = Bool()
    var imageUrl = String()
    
    override init(_ json: JSONS) {
        super.init(json)

        self.imageUrl = json.string("image_url")
        self.mainActivities.removeAll()
        json.array("activities").forEach { (tempJSON) in
            let model = MainActivitiesModel(tempJSON)
            self.mainActivities.append(model)
        }
       
    }
    
    func updateSelected(){
         self.isSelected = self.mainActivities.filter({$0.isSelected}).count > 0
    }
    
    
}



class MainActivitiesModel:HostStepBasicmodel{
    
    var subActivities = [HostStepBasicmodel]()
    
    override init(_ json:JSONS) {
        super.init(json)
        self.subActivities.removeAll()
        json.array("sub_activities").forEach { (tempJSON) in
            let model = HostStepBasicmodel(tempJSON)
            self.subActivities.append(model)
        }
        
    }
}


