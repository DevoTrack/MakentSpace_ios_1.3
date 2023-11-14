//
//  LocationModel.swift
//  Makent
//
//  Created by trioangle on 25/11/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import MapKit

class LocationModel: NSObject {
    var searchedAddress: String?
    var longitude: String?
    var latitude: String?
    var currentLocation: CLLocation?
}
