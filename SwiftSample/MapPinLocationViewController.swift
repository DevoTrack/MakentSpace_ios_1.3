//
//  MapPinLocationViewController.swift
//  Slawomir
//
//  Created by trioangle on 05/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import MapKit

protocol ExpLocationUpdateDelegate {
    func updatWhereWillMeet(_ model: BasicStpData, copyData : BasicStpData)
}

class MapPinLocationViewController: UIViewController {

    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeBtnOutlet: UIButton!
    
    var strLatitude = ""
    var strLongitude = ""
    var strLatitude1 = ""
    var strLongitude1 = ""
    var locationManager: CLLocationManager!
    var isCalled : Bool = false
    var selectedLocationModel = BasicStpData()
    var dataCopy = BasicStpData()
    let lang = Language.localizedInstance()
    
    var locationDelegate: ExpLocationUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocation()
        self.closeBtnOutlet.setImage(self.closeImage, for: .normal)
        self.closeBtnOutlet.tintColor = UIColor.appHostThemeColor
        self.nextBtnOutlet.setTitle(self.lang.next_Tit, for: .normal)
        if selectedLocationModel != nil {
            self.getLocationName(lat: (selectedLocationModel.latitude as! NSString).doubleValue , long: (selectedLocationModel.longitude as! NSString).doubleValue ?? 0.0)
        }
        self.nextBtnOutlet.addTarget(self, action: #selector(self.onTapNextBtnAction(_:)), for: .touchUpInside)
        self.closeBtnOutlet.addTarget(self, action: #selector(self.onTapCloseBtnAction(_:)), for: .touchUpInside)

    }
    
    @objc func onTapNextBtnAction(_ sender:UIButton) {
        self.dismiss(animated: true) {
            self.locationDelegate?.updatWhereWillMeet(self.selectedLocationModel,copyData: self.dataCopy)
        }
    }
    
    @objc func onTapCloseBtnAction(_ sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    func updateCurrentLocation()
    {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    locationManager.requestWhenInUseAuthorization()
                    break
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.requestAlwaysAuthorization()
                }
            } else {
                self.showAlert()
            }
            locationManager.delegate = self
            
        }
        
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
 
    func showAlert() {
       
        
        let settingsActionSheet: UIAlertController = UIAlertController(title:"Location Permission", message:"Please grant \(k_AppName.capitalized) access to your location through settings > privacy > location services.", preferredStyle:.alert)
        settingsActionSheet.addAction(UIAlertAction(title:"Settings", style:UIAlertAction.Style.default, handler:{ action in
            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }

}


extension MapPinLocationViewController: CLLocationManagerDelegate {
    
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        

        strLatitude = String(format:"%f",mapView.centerCoordinate.latitude)
        strLongitude = String(format:"%f",mapView.centerCoordinate.longitude)
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if placemarks == nil
            {
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])
                if pm != nil
                {
                    let strLoc = self.stringPlaceMark(placemark: pm!)
                    
                    if strLoc.count>0
                    {
                        self.getAddressForLatLng(latitude: self.strLatitude, longitude: self.strLongitude)
                       
                        self.strLatitude1 = String(format:"%f",mapView.centerCoordinate.latitude)
                        self.strLongitude1 = String(format:"%f",mapView.centerCoordinate.longitude)
                        self.nextBtnOutlet.isHidden = false
                      
                    }
                }
            }
        })
    }
    
    
    func stringPlaceMark(placemark: CLPlacemark) -> String {
        var string = String()
        
        //        print(placemark.addressDictionary as Any)
        
        if (placemark.locality != nil) {
            string += placemark.locality!
        }
        
        if (placemark.administrativeArea != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            
            string += placemark.administrativeArea!
            
        }
        
        
        if (placemark.country != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            string += placemark.country!
            
        }
        
        if (string.count  == 0 && placemark.name != nil) {
            string += placemark.name!
            
        }
        
        if (placemark.thoroughfare != nil) {
            
        }
        
        return string
    }
    
    
    func getAddressForLatLng(latitude: String, longitude: String) {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        let apikey = GOOGLE_MAP_PLACE_KEY
//        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
//        print(url!)
        let params = JSONS()
        let finalStr = "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)"
        var selectedAddress = JSONS()
        
        WebServiceHandler.sharedInstance.getThirdPartyAPIWebService(wsURL: finalStr, paramDict: params, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            if let results = responseDict["results"] as? [JSONS] {
                guard let result = results.first else {
                    return
                }
                
                selectedAddress["latitude"] = result.json("geometry").json("location").double("lat")

                selectedAddress["longitude"] = result.json("geometry").json("location").double("lng")

                selectedAddress["address_line_1"] = result.string("formatted_address")
                for component in result.array("address_components")
                {
                    if let country = (component["types"] as? [String]), country[0] == "country" {
                        selectedAddress["country"] = component.string("short_name")//long_name
                    }
                    else if let city = (component["types"] as? [String]),city[0] == "administrative_area_level_2" {
                        selectedAddress["city"] = component.string("long_name")
                    }
                    else if let state = (component["types"] as? [String]),state[0] == "administrative_area_level_1" {
                        selectedAddress["state"] = component.string("long_name")
                    }
                    else if let state = (component["types"] as? [String]),state[0] == "postal_code" {
                        selectedAddress["postal_code"] = component.string("long_name")
                    }
                }
                print(self.dataCopy.spaceId)
                if self.selectedLocationModel.isEditSpace{
                if self.selectedLocationModel.guestAccess != ""{
                 self.dataCopy.guestAccess = self.selectedLocationModel.guestAccess
                }
                    print("CopyGuest",self.dataCopy.guestAccess)
                    print("LM",self.selectedLocationModel.guestAccess)
                 self.selectedLocationModel = BasicStpData(selectedAddress)
                 self.selectedLocationModel.isEditSpace = true
                }else{
                self.selectedLocationModel = BasicStpData(selectedAddress)
                }
            }
            
        }
    }
    
    func getLocationName(lat: CLLocationDegrees, long: CLLocationDegrees)
    {
        if isCalled
        {
            return
        }
        
        isCalled = true
        let longitude :CLLocationDegrees = long
        let latitude :CLLocationDegrees = lat
        
        let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])!
                
                self.nextBtnOutlet.isHidden = false
//                self.strLocationName = String(format:"%@, %@",pm.locality!,pm.country!)
//                Constants().STOREVALUE(value: self.strLocationName as NSString, keyname: USER_LOCATION)
//                self.btnCancel.isHidden = true
//                self.setClearButton()
                
                UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
                    let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat , longitude: long)
                    let viewRegion: MKCoordinateRegion = MKCoordinateRegion(center: BostonCoordinates, latitudinalMeters: 300, longitudinalMeters: 300)
                    let adjustedRegion: MKCoordinateRegion = self.mapView.regionThatFits(viewRegion)
                    self.mapView.setRegion(adjustedRegion, animated: true)
                }, completion: { (finished: Bool) -> Void in
                })
            }
            else {
            }
        })
    }
}
extension MapPinLocationViewController : MKMapViewDelegate
{
    
    func mapView(_ mapLocation: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        let reuseId = "ProfilePinView"
        var pinView = mapLocation.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        pinView!.canShowCallout = true
        pinView!.image = UIImage(named: "pinmarker.png")
        return pinView
        
    }
}

//extension String {
//    var optional:String {
//        return
//    }
//}
//MARK: SHARED VARIABLE CREATE FOR GET ONLY

extension UIViewController {
    var sharedAppDelegete: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var sharedHostSteps:ReadyToHost {
        return SharedVariables.sharedInstance.readyToHostStep
    }
    var sharedVariable:SharedVariables {
        return SharedVariables.sharedInstance
    }
    
    var sharedUtility:Utilities {
        return Utilities.sharedInstance
    }
    
    var roundBox : CheckImage{
        return .round
        //            (UIImage(named: "check_selected")?.withRenderingMode(.alwaysTemplate))!
    }
    
    var checkBox :CheckImage {
        return .checkBox
        //            (UIImage(named: "check_deselected")?.withRenderingMode(.alwaysTemplate))!
    }
    
    var dropDownImage:UIImage {
        return (UIImage(named: "down-arrow1.png")?.withRenderingMode(.alwaysTemplate))!
    }
    
    var closeImage:UIImage {
        return (UIImage(named: "close_icon.png")?.withRenderingMode(.alwaysTemplate))!
    }
    
}
//MARK: SHARED VARIABLE CREATE FOR CHECK IMAGE
enum CheckImage:String {
    case round
    case checkBox
    var instance:[UIImage] {
        switch self {
        case .checkBox:
            return [(UIImage(named: "check_selected")?.withRenderingMode(.alwaysTemplate))!,(UIImage(named: "check_deselected")?.withRenderingMode(.alwaysTemplate))!]
        case .round:
            return [(UIImage(named: "selectedButton")?.withRenderingMode(.alwaysTemplate))!,(UIImage(named: "unSelectedButton")?.withRenderingMode(.alwaysTemplate))!]
        }
    }
}
