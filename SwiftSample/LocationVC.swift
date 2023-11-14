/**
 * LocationVC.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import MessageUI
import Social
import MapKit

protocol HostRoomLocationDelegate
{
    func onHostRoomLocaitonChanged(modelList:ListingModel)
}

class LocationVC : UIViewController,UITextFieldDelegate, CLLocationManagerDelegate , UITableViewDelegate, UITableViewDataSource,UpdateLocationDelegate
{
    @IBOutlet var viewMainHolder: UIView!
    @IBOutlet var viewTxtFldHolder: UIView!
    @IBOutlet var mapLocation: MKMapView!
    @IBOutlet var txtFldLocation : UITextField!
//    @IBOutlet var lblPlaceHoder : UILabel!
    
    @IBOutlet weak var lblPlaceHolder: UILabel!
    
    @IBOutlet var lblCallOut : UILabel!
    
    @IBOutlet var tblLocationSearch: UITableView!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    
    var bedTypes : [BedType]?
    @IBOutlet var btnNext : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var btnClearText : UIButton!
    
    var dictLocation = [AnyHashable: Any]()
    
    var listModel : ListingModel!
    var googleModel : GoogleLocationModel!
    var delegateHost: HostRoomLocationDelegate?
    
    var strRoomType = ""
    var strPropertyType = ""
    var strPropertyName = ""
    
    var strRoomLocation = ""
    var strLatitude = ""
    var strLongitude = ""
    var strLatitude1 = ""
    var strLongitude1 = ""
    var loadpage = ""
    var movemap = ""
    var pinadd = ""
    let annotation = MKPointAnnotation()
    
    //var samVal = ""

    @IBOutlet weak var back_Btn: UIButton!
    var isSearchStarted : Bool = false
    var isLocationPicked : Bool = false
    var isFirstTime : Bool = true
    
    var isFromAddRoomDetail : Bool = false
    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: AddressPickerDelegate?
    var isCalled : Bool = false
    //MARK: GOOGLE PLACE SEARCH
//    var dataLoader: GooglePlacesDataLoader?
    var selectedLocation = LocationModel()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var searchCountdownTimer: Timer?
    weak var locationAnnotation: MKAnnotation?
    var arrBedData : NSArray!
    
    var googlePlaceSearchHandler : GoogleAutoCompleteHandler?
    var searchPredictions : [Prediction] = []

//    @IBOutlet weak var loc_Label: UILabel!
    
    @IBOutlet weak var loc_Label: UILabel!
    var strLocationName:String = ""
    var strSearchLoc:String = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //mapLocation.semanticContentAttribute = .forceLeftToRight
        animatedLoader?.isHidden = true
        txtFldLocation.delegate = self
        txtFldLocation.AlignText()
        txtFldLocation.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        btnClearText.titleLabel?.font = UIFont(name: Fonts.MAKENT_LOGO_FONT2, size: 17)
        btnNext.isHidden = true
        self.back_Btn.transform = self.getAffine
        self.back_Btn.appHostTextColor()
        self.btnCancel.appHostTextColor()
        lblCallOut.appGuestTextColor()
        btnNext.appGuestSideBtnBG()
        self.loc_Label.text = self.lang.loc_Tit
        
        self.lblPlaceHolder.text = self.lang.loc_Msg
        self.lblPlaceHolder.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.btnNext.setTitle(self.lang.next_Tit, for: .normal)
        self.txtFldLocation.placeholder = self.lang.city_Title
        self.btnCancel.setTitle(self.lang.cancel_Title, for: .normal)
        
        //        updateCurrentLocation()
        
        tblLocationSearch.isHidden = true
//        dataLoader = GooglePlacesDataLoader.init(delegate: self)
        selectedLocation = LocationModel()
        lblCallOut.isHidden = true
        viewTxtFldHolder.layer.borderColor =  UIColor(red: 223.0 / 255.0, green: 224.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0).cgColor
        viewTxtFldHolder.layer.borderWidth = 1.0
        viewTxtFldHolder.layer.cornerRadius = 3.0
        
        viewMainHolder.layer.shadowColor = UIColor.gray.cgColor;
        viewMainHolder.layer.shadowOffset = CGSize(width:0, height:1.0);
        viewMainHolder.layer.shadowOpacity = 0.5;
        viewMainHolder.layer.shadowRadius = 2.0;
        
        let rect = MakentSupport().getScreenSize()
        var rectMapView = mapLocation.frame
        //        btnNext.isHidden = true
        
        var rectTableView = tblLocationSearch.frame
        rectTableView.size.height = 250
       
        print(strLongitude)
        
        if isFromAddRoomDetail
        {
            self.loc_Label.text = self.lang.loc_Tit
            self.lblPlaceHolder.text = self.lang.loc_Msg
            self.btnNext.setTitle(self.lang.next_Tit, for: .normal)
            self.txtFldLocation.placeholder = self.lang.city_Title
            self.btnCancel.setTitle(self.lang.cancel_Title, for: .normal)
            var rectTxtView = viewMainHolder.frame
            rectTxtView.origin.y = -20
            viewMainHolder.frame = rectTxtView
            lblPlaceHolder.isHidden = true
            rectMapView.origin.y = rectTxtView.origin.y  + viewMainHolder.frame.size.height
            rectMapView.size.height = rect.size.height-viewMainHolder.frame.size.height + 20
            
            isSearchStarted = true
            let longitude1 :CLLocationDegrees = Double(strLongitude) as! CLLocationDegrees
            let latitude1 :CLLocationDegrees = Double(strLatitude) as! CLLocationDegrees
            UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
                let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude1 , longitude: longitude1)
                let viewRegion: MKCoordinateRegion = MKCoordinateRegion.init(center: BostonCoordinates, latitudinalMeters: 35500, longitudinalMeters: 35500)
                let adjustedRegion: MKCoordinateRegion = self.mapLocation.regionThatFits(viewRegion)
                self.mapLocation.setRegion(adjustedRegion, animated: true)
            }, completion: { (finished: Bool) -> Void in
            })
            rectTableView.origin.y = rectMapView.origin.y
            self.setClearButton()
            
            if(appDelegate.samVal == "1"){
                
                txtFldLocation.text = strRoomLocation
                let longitude1 :CLLocationDegrees = Double(strLongitude)!
                let latitude1 :CLLocationDegrees = Double(strLatitude)!
                
                print(longitude1)
                print(latitude1)
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude1, longitude: longitude1)
                mapLocation.addAnnotation(annotation)
            }
          
        }
        else
        {
            updateCurrentLocation()
            btnCancel.isHidden = true
//            rectMapView.origin.y = viewMainHolder.frame.size.height + 50
//            rectMapView.size.height = rect.size.height-viewMainHolder.frame.size.height - 50
        }
        
        tblLocationSearch.frame = rectTableView
        
        //mapLocation.frame = rectMapView
        
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.onZoom), userInfo: nil, repeats: false)
    }
    
    @objc func onZoom()
    {
       if appDelegate.samVal == "1"{
        
        lblCallOut.isHidden = true

        }
       else{
       
        lblCallOut.isHidden = false
        }

        lblCallOut.center = mapLocation.center
        isSearchStarted = false
        //        self.zoomtoLocationWithlongitude(-87.62980, latitude: 41.87811)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    func showAlert() {
        let locName = Constants().GETVALUE(keyname: APPURL.USER_LOCATION)
        if (locName.length > 0)
        {
            self.strLocationName = locName as String
            txtFldLocation.becomeFirstResponder()
        }
        else
        {
            self.strLocationName = locName as String
        }
        
        let settingsActionSheet: UIAlertController = UIAlertController(title:self.lang.locpermisson_Tit, message:"\(self.lang.grant_Tit) \(k_AppName.capitalized) \(self.lang.locset_Title)", preferredStyle:UIAlertController.Style.alert)
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.setting_Title, style:UIAlertAction.Style.default, handler:{ action in
            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if !isFromAddRoomDetail
        {
            isSearchStarted = true
            self.updateCurrentLocation()
        }
        else
        {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isSearchStarted = false
//        dataLoader?.cancelAllRequests()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if((textField.text?.count)! > 0)
        {
            
        }
        else
        {
            
        }
        
        if isFromAddRoomDetail
        {
            btnNext.isHidden = true
        }
        else
        {
            self.btnNext.isHidden = ((textField.text?.count)! > 0) ? false : true
        }
        
      //  self.startCountdownTimer(forSearch: textField.text!)
    }
    
    func moveToUpdateLocationView()
    {
        self.view.endEditing(true)
        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "UpdateLocation") as! UpdateLocation
        locView.strStreetName = listModel.street_name as String
        locView.strAbtName = listModel.street_address as String
        locView.strCityName = listModel.city_name as String
        locView.strStateName = listModel.state_name as String
        locView.strZipcode = listModel.zipcode as String
        locView.strCountryName = listModel.country_name as String
        locView.strLatitude  =  strLatitude
        locView.strLongitude = strLongitude
        locView.delegate = self
        //        self.navigationController?.hidesBottomBarWhenPushed = true
        self.present(locView, animated: true, completion: {
        })
        //        self.navigationController?.pushViewController(locView, animated: false)
    }
    
//    func startCountdownTimer(forSearch searchString: String) {
//        //stop the current countdown
//        if (self.searchCountdownTimer != nil) {
//            self.searchCountdownTimer?.invalidate()
//        }
//        //cancel all pending requests
//        self.dataLoader?.cancelAllRequests()
//        let fireDate = Date(timeIntervalSinceNow: 1.0)
//        // add search data to the userinfo dictionary so it can be retrieved when the timer fires
//        let info: [AnyHashable: Any] = [
//            "searchString" : searchString,
//            //            "location" : location
//        ]
//
//        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.searchCountdownTimerFired), userInfo: info, repeats: false)
//
//        RunLoop.main.add(self.searchCountdownTimer!, forMode: RunLoop.Mode.default)
//    }
    
    
//    @objc func searchCountdownTimerFired(_ countdownTimer: Timer) {
//        let searchString = countdownTimer.userInfo as! NSDictionary
//        let newsearchString: String? = searchString["searchString"] as? String// (countdownTimer.userInfo?["searchString"] as? String)
//        self.dataLoader?.sendAutocompleteRequest(withSearch: newsearchString, andLocation: nil)
//        //        self.searchProgressView.startAnimating()
//    }
    
    //    func startCountdownTimer(forSearch searchString: String, andLocation location: CLLocation) {
    //        //stop the current countdown
    //        if (self.searchCountdownTimer != nil) {
    //            self.searchCountdownTimer?.invalidate()
    //        }
    //        //cancel all pending requests
    //        self.dataLoader?.cancelAllRequests()
    //        let fireDate = Date(timeIntervalSinceNow: 1.0)
    //        // add search data to the userinfo dictionary so it can be retrieved when the timer fires
    //        let info: [AnyHashable: Any] = [
    //            "searchString" : searchString,
    //            "location" : location
    //        ]
    //
    //        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.searchCountdownTimerFired), userInfo: info, repeats: false)
    //
    //        RunLoop.main.add(self.searchCountdownTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    //
    //    }
    //
    //
    //    func searchCountdownTimerFired(_ countdownTimer: Timer) {
    //        let searchString = countdownTimer.userInfo as! NSDictionary
    //        let newsearchString: String? = searchString["searchString"] as? String// (countdownTimer.userInfo?["searchString"] as? String)
    //        let newlocation: CLLocation? = searchString["location"] as? CLLocation
    //        self.dataLoader?.sendAutocompleteRequest(withSearch: newsearchString, andLocation: nil)
    //        //        self.searchProgressView.startAnimating()
    //    }
    
    
    // MARK: - GooglePlacesDataLoaderDelegate methods
    
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadAutocompletePredictions predictions: [Any]) {
//        self.autocompletePredictions = predictions
//        //[self setFrameOfTableview];
//        tblLocationSearch.isHidden = false
//        tblLocationSearch.reloadData()
//        //        self.searchProgressView.stopAnimating()
//    }
//
//
//
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadPlaceDetails placeDetails: [AnyHashable: Any], withAttributions htmlAttributions: String) {
//        //   [self setActive:NO animated:YES];
//        self.searchDidComplete(withPlaceDetails: placeDetails, andAttributions: htmlAttributions)
//        //        self.searchProgressView.stopAnimating()
//    }
//
//
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, autocompletePredictionsDidFailToLoad error: Error?) {
//        //        self.searchProgressView.stopAnimating()
//    }
//
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, placeDetailsDidFailToLoad error: Error?) {
//        //        self.searchProgressView.stopAnimating()
//    }
    
    
    //   func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, placeDetailsDidFailToLoad error: Error?) {
    //        self.searchProgressView.stopAnimating()
    // }
    
//    internal func locationDescription(at index: Int) -> [AnyHashable: Any] {
//        let jsonData: [AnyHashable: Any] = self.autocompletePredictions[index] as! [AnyHashable : Any]
//        return jsonData
//    }
//
    
    // MARK: **** Location Manager Delegate methods ****
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        print(error)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        Constants().STOREVALUE(value: String(format: "%f", coord.longitude) as NSString, keyname: APPURL.USER_LONGITUDE)
        Constants().STOREVALUE(value: String(format: "%f", coord.latitude) as NSString, keyname: APPURL.USER_LATITUDE)
        //        print(coord.latitude, coord.latitude)
        self.getLocationName(lat: coord.latitude, long: coord.longitude)
        strLatitude = String(format:"%f",coord.latitude)
        strLongitude = String(format:"%f",coord.longitude)
        
        self.googlePlaceSearchHandler = GoogleAutoCompleteHandler(searchTextField: self.txtFldLocation,
                                  delegate: self,
                                  userCurrentLatLng: (coord.latitude,
                                                      coord.longitude))

        
        self.currentLocation = locationObj
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func getAddressForLatLng(latitude: String, longitude: String) {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        let apikey = GOOGLE_MAP_PLACE_KEY
        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
        let param = ["latlng":"\(latitude),\(longitude)","key":"\(apikey)"]
        print(url!)
//        var results = NSArray()
       
//        let data = NSData(contentsOf: url! as URL)
//
//        let json = try! JSONSerialization.jsonObject(with:data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//        results = (json["results"] as? NSArray)!
        WebServiceHandler.sharedInstance.getThirdPartyAPIWebService(wsURL: baseUrl, paramDict: param, viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
            if let results = responseDict["results"] as? [JSONS] {
                guard let result = results.first else {
                    return
                }
                //                selectedAddress["latitude"] = result.json("geometry").json("location").double("lat")
                //
                //                selectedAddress["longitude"] = result.json("geometry").json("location").double("lng")
                
                self.pinadd = result.string("formatted_address")
                self.txtFldLocation.text = self.pinadd
            }
        }
        
//        if results.count != 0 {
//            if let result1 : NSDictionary = results[0] as? NSDictionary{
//
//                if let formatted_address : String = result1["formatted_address"] as? String{
//                    self.pinadd = formatted_address
//                    if let address_components : NSArray = result1["address_components"] as? NSArray{
//
//                        let addressArray : NSMutableArray = NSMutableArray()
//
//                        for i in 0..<address_components.count {
//
//                            if let citydic : NSDictionary = address_components[i] as? NSDictionary{
//
//                                if let long_name : String = citydic["long_name"] as? String{
//                                    let short_name : String = (citydic["short_name"] as? String)!
//
//
//                                }
//
//                            }
//
//                        }
//
//                    }
//
//
//                }
//
//            }
//        }
        
            
     //   }
        
        

    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.dragging {
        }
        if newState == MKAnnotationView.DragState.ending {
            let ann = view.annotation
            print("annotation dropped at: \(ann!.coordinate.latitude),\(ann!.coordinate.longitude)")
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        if isSearchStarted
        {
            return
        }
        
        if isFromAddRoomDetail && !isFirstTime
        {
            isLocationPicked = false
            btnNext.isHidden = false
            return
        }
        
        if isFromAddRoomDetail
        {
            isLocationPicked = false
            btnNext.isHidden = true
            return
        }
        
        strLatitude = String(format:"%f",mapView.centerCoordinate.latitude)
        strLongitude = String(format:"%f",mapView.centerCoordinate.longitude)
        
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            guard let placemarks = placemarks, error == nil else {return}
            
            guard (placemarks.count) > 0 else {return}
            let pm = (placemarks[0])
            guard pm != nil else{return}
            let strLoc = self.stringPlaceMark(placemark: pm)
            
            guard strLoc.count>0 else{return}
           
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.getAddressForLatLng(latitude: self.strLatitude, longitude: self.strLongitude)
                })
            
            
            self.movemap = "1"
            self.strLatitude1 = String(format:"%f",mapView.centerCoordinate.latitude)
            self.strLongitude1 = String(format:"%f",mapView.centerCoordinate.longitude)
            self.txtFldLocation.text =  self.pinadd
            self.appDelegate.addrss =  self.pinadd
            self.btnNext.isHidden = false
            
            
        })
    }
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
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
    
    // MARK:  ****Location Manager Delegate End ****
    
    // MARK: - **** Get Current Location Name ****
    
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
                if self.appDelegate.samVal != "1"{
                //self.txtFldLocation.text = String(format:"%@, %@",pm.locality!,pm.country!)
                }
                self.btnNext.isHidden = false
                if let locality = pm.locality, let country = pm.country {
                    self.strLocationName = String(format:"%@, %@",locality,country)
                }else {
                    self.getAddressForLocation(latitude: lat.description, longitude: long.description)
                }
                
                Constants().STOREVALUE(value: self.strLocationName as NSString, keyname: APPURL.USER_LOCATION)
                self.btnCancel.isHidden = true
                self.setClearButton()
                
                UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions(), animations: { () -> Void in
                    let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat , longitude: long)
                    let viewRegion: MKCoordinateRegion = MKCoordinateRegion.init(center: BostonCoordinates, latitudinalMeters: 35500, longitudinalMeters: 35500)
                   

                   
                         let adjustedRegion: MKCoordinateRegion = self.mapLocation.regionThatFits(viewRegion)
                        self.mapLocation.setRegion(adjustedRegion, animated: true)
                    
                }, completion: { (finished: Bool) -> Void in
                })
            }
            else {
            }
        })
    }
    
    
    func getAddressForLocation(latitude: String, longitude: String) {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        let apikey = GOOGLE_MAP_API_KEY
        
        let params = JSONS()
        let finalStr = "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)"
        var selectedAddress = JSONS()
        
        WebServiceHandler.sharedInstance.getThirdPartyAPIWebService(wsURL: finalStr, paramDict: params, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            if let results = responseDict["results"] as? [JSONS] {
                guard let result = results.first else {
                    return
                }
                
                selectedAddress["Lat"] = result.json("geometry").json("location").double("lat").description
                
                selectedAddress["Long"] = result.json("geometry").json("location").double("lng").description
                
                
                for component in result.array("address_components")
                {
                    
                    if let city = (component["types"] as? [String]),city[0] == "locality" || city[0] == "administrative_area_level_2" {
                        self.strLocationName = component.string("long_name")
                        
                    }
//                    else if let state = (component["types"] as? [String]),state[0] == "administrative_area_level_1" {
//                        selectedAddress["State"] = component.string("long_name")
//
//                    }
                    else if let country = (component["types"] as? [String]), country[0] == "sublocality_level_1" {
                        selectedAddress["Country"] = component.string("short_name")//long_name
                        self.strLocationName = self.strLocationName + ", \(component.string("long_name"))"
                        
                        
                    }
//                    else if let state = (component["types"] as? [String]),state[0] == "postal_code" {
//                        selectedAddress["PostalCode"] = component.string("long_name")
//
//                    }
                }
                
                
            }
            
        }
        
    }
    // MARK: - **** Get Current Location Name ****
    
//    func searchDidComplete(withPlaceDetails placeDetails: [AnyHashable: Any], andAttributions htmlAttributions: String) {
//        locationAnnotation = PlaceDetailsAnnotation(placeDetails: placeDetails)
//        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)
//
//        self.selectedLocation.longitude = String(format: "%2f", (self.locationAnnotation?.coordinate.longitude)!)
//        self.selectedLocation.latitude = String(format: "%2f", (self.locationAnnotation?.coordinate.latitude)!)
//        self.selectedLocation.currentLocation = CLLocation(latitude: (self.locationAnnotation?.coordinate.latitude)!, longitude: (self.locationAnnotation?.coordinate.longitude)!)
//        delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : "")
//        self.onBackTapped(nil)
//    }
//
//
//    func searchDidComplete(withCurrentLocationSelected currentLocation: CLLocation) {
//        if currentLocation != nil {
//            self.locationAnnotation = CurrentLocationAnnotation(location: currentLocation)
//            self.selectedLocation.longitude = String(format: "%2f", currentLocation.coordinate.longitude)
//            self.selectedLocation.latitude = String(format: "%2f", currentLocation.coordinate.latitude)
//            self.selectedLocation.currentLocation = currentLocation
//        }
//        else
//        {
//        }
//    }
    
    
    
    func zoomtoLocationWithlongitude(_ longitude: Double, latitude: Double)
    {
        var region = MKCoordinateRegion()
        //Set Zoom level using Span
        var span = MKCoordinateSpan.init(latitudeDelta: 0.075, longitudeDelta: 0.075)
        region.center = mapLocation.region.center;
        
        span.latitudeDelta=mapLocation.region.span.latitudeDelta / 2.0002;
        span.longitudeDelta=mapLocation.region.span.longitudeDelta / 2.0002;
        region.span=span;
        
        mapLocation.setRegion(region, animated: true)
    }
    
    // MARK: TextField Delegate Method
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if self.searchPredictions.count == 0
        {
            return (MakentSupport().isPad()) ? 50 : 50
        }
        else
        {
            return (MakentSupport().isPad()) ? 50 : 50
        }
    }
    
    // MARK: - **** Table View Data Source ****
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.searchPredictions.count == 0) ? 0 : self.searchPredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        var adict: [AnyHashable: Any] = self.locationDescription(at: indexPath.row)
//        let titleString: String? = (adict[RESPONSE_KEY_DESCRIPTION] as? String)
//        var addresArray  = titleString?.components(separatedBy: ",")
//        let finalTitle: String? = ((addresArray?.count)! > 0) ? addresArray?[0] : ""
//        var finalSubTitle: String = ""
//        let count = (addresArray?.count)! as Int
//        for i in 1 ..< count
//        {
//            finalSubTitle = finalSubTitle + (addresArray?[i])!
//            if i < (addresArray?.count)! - 1 {
//                if i == 1
//                {
//                    finalSubTitle = finalSubTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//                }
//
//                finalSubTitle = finalSubTitle + ","
//            }
//        }
        
        let cell:CellLocation = tblLocationSearch.dequeueReusableCell(withIdentifier: "CellLocation") as! CellLocation
        guard let prediction = self.searchPredictions.value(atSafeIndex: indexPath.row) else{return cell}
        cell.lblName?.text = String(format:"%@ %@",prediction.structuredFormatting.mainText,prediction.structuredFormatting.secondaryText)
        cell.lblName?.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: (MakentSupport().isPad()) ? 25 : 17)
        return cell
    }
    
    // MARK:  **** Table View Data Source End ****
    
    // MARK:  **** Table View Delegate ****
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CellLocation
        txtFldLocation.text =  (selectedCell.lblName?.text)!
        gotoUpdateLocationView()
//        let selPrediction = self.autocompletePredictions[indexPath.row] as! NSDictionary
//        let referenceID: String? = (selPrediction[RESPONSE_KEY_REFERENCE] as? String)
//        self.dataLoader?.cancelAllRequests()
//        self.getLocationCoordinates(withReferenceID: referenceID!)
    }
    
    func getLocatinName()
    {
        let longitude1 :CLLocationDegrees = Double(strLongitude)!
        let latitude1 :CLLocationDegrees = Double(strLatitude)!
        let location = CLLocation(latitude: latitude1, longitude: longitude1)
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
                    OperationQueue.main.addOperation {
                        //                        self.gotoUpdateLocationView(placemark: pm!)
                    }
                }
            }
        })
    }
    
    //MARK: GOTO UPDATE LOCATION WHILE SELECTING LOC TABLEVIEW
    func gotoUpdateLocationView()
    {
        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "UpdateLocation") as! UpdateLocation
        locView.googleModel = googleModel
        locView.delegate = self
        locView.strLatitude  =  strLatitude
        locView.strLongitude = strLongitude
        print(strLatitude)
        print(strLongitude)
        self.present(locView, animated: true, completion: {
        })
    }
    func updatemap(){
        
            let latitude1 = appDelegate.latt
            let longitude1 = appDelegate.longg
            let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude1 , longitude: longitude1)
            let viewRegion: MKCoordinateRegion = MKCoordinateRegion.init(center: BostonCoordinates, latitudinalMeters: 45500, longitudinalMeters: 45500)
            let adjustedRegion: MKCoordinateRegion = mapLocation.regionThatFits(viewRegion)
            mapLocation.setRegion(adjustedRegion, animated: true)

        
            }
    //MARK: UPDATE LOCATION DELEGATE METHOD
    internal func saveLocationName(dicts : [AnyHashable: Any], isSuccess: Bool)
    {
        
        print(isSuccess)
        
        if appDelegate.samVal == "2" && appDelegate.test == "1"{
            
            txtFldLocation.text! = appDelegate.addaddress
            self.updatemap()
        }
        var title = ""
        if appDelegate.s_types == "Found"{
            
            title = "Exact Location Found"
        }
        else{
            
            title = "Exact Location Not Found"
        }
        
        let settingsActionSheet: UIAlertController = UIAlertController(title: (isSuccess) ? self.lang.locfound_Title : self.lang.exactlocnot_Title, message:self.lang.manualpin_Title, preferredStyle:UIAlertController.Style.alert)
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.edtAdd_Title, style:UIAlertAction.Style.default, handler:{ action in
            self.changeAddress(dicts)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.pinMap_Title, style:UIAlertAction.Style.default, handler:{ action in
            self.onZoom()
            self.isFromAddRoomDetail = false
            self.loadpage = "1"
            self.mapLocation.removeAnnotation(self.annotation)

        }))
        //settingsActionSheet.addAction(UIAlertAction(title:"Pin on Map", style:UIAlertActionStyle.destructive, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
        dictLocation = dicts
        isFirstTime = false
        if isSuccess
        {
            btnNext.isHidden = false
            isLocationPicked = true
        }
        else
        {
            isLocationPicked = false
            btnNext.isHidden = true
        }
        
        //        updateLocationFromAddRoomDetail(dicts)
    }
    
    func changeAddress(_ dicts: [AnyHashable: Any])
    {
        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "UpdateLocation") as! UpdateLocation
        locView.strStreetName = dicts["street_name"] as! String
        locView.strAbtName = dicts["street_address"] as! String
        locView.strCityName = dicts["city"] as! String
        locView.strStateName = dicts["state"] as! String
        locView.strZipcode = dicts["zip"] as! String
        locView.strCountryName = dicts["country"] as! String
        locView.strLatitude  =  strLatitude
        locView.strLongitude = strLongitude
        locView.isFromFromEditing = true
        locView.delegate = self
        self.present(locView, animated: true, completion: {
        })
    }
    
    //MARK: UPDATE LOCATION DELEGATE METHOD
    internal func goBack()
    {
        self.navigationController!.popViewController(animated: false)
    }
    
//    func getLocationCoordinates(withReferenceID referenceID: String)
//    {
//        self.view.endEditing(true)
//        var dicts = [AnyHashable: Any]()
//
//        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//
//        self.GetGoogleRequest(dicts,methodName: referenceID as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
//            let gModel = response as! GoogleLocationModel
//            OperationQueue.main.addOperation {
//                if gModel.status_code == "1"
//                {
//                    self.googleModel = gModel
//                    let dictsTempsss = gModel.dictTemp[RESPONSE_KEY_RESULT] as! NSDictionary
//                    self.googleData(didLoadPlaceDetails: dictsTempsss)
//                }
//                else
//                {
//                }
//            }
//        }, andFailureBlock: {(_ error: Error) -> Void in
//            OperationQueue.main.addOperation {
//            }
//        })
//    }
//
//    func googleData(didLoadPlaceDetails placeDetails: NSDictionary) {
//        self.searchDidComplete(withPlaceDetails: placeDetails)
//    }
    
//    func searchDidComplete(withPlaceDetails placeDetails: NSDictionary)
//    {
//        let placeGeometry =  (placeDetails[RESPONSE_KEY_GEOMETRY]) as? NSDictionary
//        let locationDetails  = (placeGeometry?[RESPONSE_KEY_LOCATION]) as? NSDictionary
//        let lat = (locationDetails?[RESPONSE_KEY_LATITUDE] as? Double)
//        let lng = (locationDetails?[RESPONSE_KEY_LONGITUDE] as? Double)
//
//
//        let longitude1 :CLLocationDegrees = lng!
//        let latitude1 :CLLocationDegrees = lat!
//
//        let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude1 , longitude: longitude1)
//        let viewRegion: MKCoordinateRegion = MKCoordinateRegion.init(center: BostonCoordinates, latitudinalMeters: 45500, longitudinalMeters: 45500)
//        let adjustedRegion: MKCoordinateRegion = mapLocation.regionThatFits(viewRegion)
//        mapLocation.setRegion(adjustedRegion, animated: true)
//
//        btnNext.isHidden = false
//
//        self.selectedLocation.longitude = String(format: "%2f", lng!)
//        self.selectedLocation.latitude = String(format: "%2f", lat!)
//
//        strLatitude = String(format: "%2f", lat!)
//        strLongitude = String(format: "%2f", lng!)
//
//        if isFromAddRoomDetail
//        {
//            //            getLocatinName()
//            gotoUpdateLocationView()
//        }
//        tblLocationSearch.isHidden = true
//        //        delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : (selectedCell.lblName?.text)!)
//        //        self.onBackTapped(nil)
//    }
//
//    func GetGoogleRequest(_ dict: [AnyHashable: Any], methodName : NSString, forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
//        //        if !self.isNetworkRechable() {
//        //            return
//        //        }
//        self.getBlockServerResponseForparam(dict, method: methodName, withSuccessionBlock: {(_ response: Any) -> Void in
//            successBlock(response)
//        }, andFailureBlock: {(_ error: Error) -> Void in
//            failureBlock(error)
//        })
//    }
//
//    func getBlockServerResponseForparam(_ params: [AnyHashable: Any], method: NSString, withSuccessionBlock successBlock: @escaping (_ response: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void)
//    {
//        let paramsComponent: String = "?key=\(GOOGLE_PLACES_API_KEY)&reference=\(method)&sensor=\("true")"
//
//        let url = URL(string: GOOGLE_MAP_DETAILS_URL + paramsComponent.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)
//        var items = NSDictionary()
//
//        let request = NSMutableURLRequest(url:url!);
//
//        URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
//            if !(data != nil) {
//                failureBlock(error!)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult : Dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary as Dictionary
//                    items = jsonResult as NSDictionary
//
//                    if (items.count>0)
//                    {
//                        successBlock(MakentSeparateParam().separate(params:  items, methodName: METHOD_GOOGLE_PLACE as NSString))
//                    }
//                    else {
//                        failureBlock(error!)
//                    }
//                }
//                catch _ {
//                    //                    print(response!)
//                }
//            }
//            }.resume()
//    }
    
    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        if !isFromAddRoomDetail
        {
            if loadpage == "1"{
                if isLocationPicked
                {
                   
                    
                    var dicts = [AnyHashable: Any]()
                    dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
                    dicts["room_id"]   = appDelegate.strRoomID
                    dicts["is_success"]   = "No"
                    if movemap == "1"{
                        dicts["latitude"]   = strLatitude1
                        dicts["longitude"]   = strLongitude1
                    }
                    else{
                        dicts["latitude"]   = strLatitude
                        dicts["longitude"]   = strLongitude
                    }
                    
                    updateLocationFromAddRoomDetail(dicts)
                }
                else
                {
                    var dicts = [AnyHashable: Any]()
                    dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
                    dicts["room_id"]   = appDelegate.strRoomID
                   
                     if appDelegate.samVal == "2" && appDelegate.test == "1"{
                        let lll = String(appDelegate.latt)
                        let lgg = String(appDelegate.longg)
                        
                        if lll == "0.0" && lgg == "0.0"{
                           
                            dicts["latitude"]   = strLatitude
                            dicts["longitude"]   = strLongitude
                           
                        }
                        else{
                            strLatitude = lll
                            strLongitude = String(lgg)
                            if movemap == "1"{
                                dicts["latitude"]   = strLatitude1
                                dicts["longitude"]   = strLongitude1
                            }
                            else{
                                dicts["latitude"]   = strLatitude
                                dicts["longitude"]   = strLongitude
                            }
                            //print(strLongitude)
                            //print(strLatitude)
                        }
                      
                    }
                    else{

                        if movemap == "1"{
                            dicts["latitude"]   = strLatitude1
                            dicts["longitude"]   = strLongitude1
                        }
                        else{
                            dicts["latitude"]   = strLatitude
                            dicts["longitude"]   = strLongitude
                        }
                    }
                    dicts["is_success"]   = "No"
                    updateLocationFromAddRoomDetail(dicts)
                }
            }
            else{
                if let _bedTypes = self.bedTypes{
                    let addBedVC = AddRoomBedVC.initWithStory(_bedTypes)
                    //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
                    appDelegate.isStepsCompleted = false
                    addBedVC.strRoomType = strRoomType
                    addBedVC.strRoomType = strRoomType
                    addBedVC.strPropertyType = strPropertyType
                    
                    addBedVC.latitude = strLatitude
                    addBedVC.longitude = strLongitude
                    addBedVC.strPropertyName = strPropertyName
                    addBedVC.strRoomLocation = (txtFldLocation.text?.replacingOccurrences(of: " ", with: "%20")) ?? ""
                    self.navigationController?.pushViewController(addBedVC,
                                                              animated: true)
                }
           /*
                let locView = k_MakentStoryboard.instantiateViewController(withIdentifier: "RoomAndBeds") as! RoomAndBeds
                locView.strRoomType = strRoomType
                locView.strPropertyType = strPropertyType
                
                locView.latitude = strLatitude
                locView.longitude = strLongitude
                locView.strPropertyName = strPropertyName
                 locView.strRoomLocation = (txtFldLocation.text?.replacingOccurrences(of: " ", with: "%20"))!
                
                if arrBedData != nil
                {
                    locView.arrBedData = arrBedData
                }
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(locView, animated: true)*/
            }
        }
        else{
            
            if isLocationPicked
            {
                updateLocationFromAddRoomDetail(dictLocation)
            }
            else
            {
                var dicts = [AnyHashable: Any]()
                dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
                dicts["room_id"]   = appDelegate.strRoomID

                 if appDelegate.samVal == "2"{
                    strLatitude = String(appDelegate.latt)
                    strLongitude = String(appDelegate.longg)
                }
                 else{
                  dicts["latitude"]   = strLatitude
                  dicts["longitude"]   = strLongitude
                }
                dicts["is_success"]   = "No"
                updateLocationFromAddRoomDetail(dicts)
            }
        }
    }
    
    func updateNewLocation(_ dicts : [AnyHashable: Any], location_name:NSString)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.room_location = location_name
        print(location_name)
        if isLocationPicked
        {
            /*tempModel.street_name = dicts["street_name"] as! NSString
            tempModel.street_address = dicts["street_address"] as! NSString
            tempModel.city_name = dicts["city"] as! NSString
            tempModel.state_name = dicts["state"] as! NSString
            tempModel.zipcode = dicts["zip"] as! NSString
            tempModel.country_name = dicts["country"] as! NSString
            print(tempModel.street_name)
            print(tempModel.street_address)
            print(tempModel.city_name)
            print(tempModel.country_name)*/
            tempModel.street_name = dicts["address_line_1"] as! NSString
            tempModel.street_address = dicts["address_line_2"] as! NSString
            tempModel.city_name = dicts["city"] as! NSString
            tempModel.state_name = dicts["state"] as! NSString
            tempModel.zipcode = dicts["postal_code"] as! NSString
            tempModel.country_name = dicts["country"] as! NSString

        }
        else
        {
            tempModel.street_name = dicts["address_line_1"] as! NSString
            tempModel.street_address = dicts["address_line_2"] as! NSString
            tempModel.city_name = dicts["city"] as! NSString
            tempModel.state_name = dicts["state"] as! NSString
            tempModel.zipcode = dicts["postal_code"] as! NSString
            tempModel.country_name = dicts["country"] as! NSString
        }
       
        if movemap == "1"{
        tempModel.latitude = strLatitude1 as NSString
        tempModel.longitude = strLongitude1 as NSString
       }else{
        
        tempModel.latitude = strLatitude as NSString
        tempModel.longitude = strLongitude as NSString
        }
        
        listModel = tempModel
        delegateHost?.onHostRoomLocaitonChanged(modelList:listModel)
    }
    
    func updateLocationFromAddRoomDetail(_ dicts : [AnyHashable: Any])
    {
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        
        self.animatedLoader?.isHidden = false
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_ROOM_LOCATION as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
             
                if gModel.status_code == "1"
                {
                    self.appDelegate.test = ""
                    self.appDelegate.samVal = ""
                    self.appDelegate.s_types = ""
                    
                    if gModel.dictTemp.count > 0 && self.isLocationPicked
                    {
                        //self.updateNewLocation(dicts ,location_name:gModel.room_location)
                        self.updateNewLocation((gModel.dictTemp as NSDictionary) as! [AnyHashable : Any],location_name:gModel.room_location)
                    }
                    else{
                        self.updateNewLocation((gModel.dictTemp as NSDictionary) as! [AnyHashable : Any],location_name:gModel.room_location)
                    }
                    self.navigationController!.popViewController(animated: true)
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                
                MakentSupport().removeProgressInWindow(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    
    @IBAction func onTextClearTapped(_ sender:UIButton!)
    {
        if (txtFldLocation.text?.count)! > 0
        {
            btnClearText.titleLabel?.font = UIFont(name: Fonts.MAKENT_LOGO_FONT2, size: 11)
            txtFldLocation.text = ""
            self.setLocationbutton()
            btnNext.isHidden = true
        }
        else
        {
            if strLocationName.count > 0
            {
                txtFldLocation.text = strLocationName
                setClearButton()
                btnNext.isHidden = false
                
                let longitude = Constants().GETVALUE(keyname: APPURL.USER_LONGITUDE)
                let latitude = Constants().GETVALUE(keyname: APPURL.USER_LATITUDE)
                if (longitude.length > 0 && latitude.length > 0)
                {
                    let longitude1 :CLLocationDegrees = Double(longitude as String)!
                    let latitude1 :CLLocationDegrees = Double(latitude as String)!
                    UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
                        
                        let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude1 , longitude: longitude1)
                        let viewRegion: MKCoordinateRegion = MKCoordinateRegion.init(center: BostonCoordinates, latitudinalMeters: 35500, longitudinalMeters: 35500)
                        let adjustedRegion: MKCoordinateRegion = self.mapLocation.regionThatFits(viewRegion)
                        self.mapLocation.setRegion(adjustedRegion, animated: true)
                    }, completion: { (finished: Bool) -> Void in
                    })
                }
            }
        }
    }
    
    func setClearButton()
    {
        btnClearText.titleLabel?.font = UIFont(name: Fonts.MAKENT_LOGO_FONT2, size: 11)
        btnClearText.layer.borderColor = UIColor.darkGray.cgColor
        btnClearText.layer.borderWidth = 1.0
        btnClearText.layer.cornerRadius = self.btnClearText.frame.size.height/2
        btnClearText.setTitle("=", for: .normal)
        btnClearText.titleLabel?.text = "="
    }
    
    func setLocationbutton()
    {
        if !isFromAddRoomDetail
        {
            btnClearText.titleLabel?.font = UIFont(name: Fonts.MAKENT_LOGO_FONT2, size: 17)
            btnClearText.setTitle("2", for: .normal)
            btnClearText.titleLabel?.text = "2"
            btnClearText.layer.borderColor = UIColor.clear.cgColor
            btnClearText.layer.borderWidth = 0.0
            btnClearText.layer.cornerRadius = 0.0
        }
        else
        {
            btnClearText.titleLabel?.font = UIFont(name: Fonts.MAKENT_LOGO_FONT2, size: 17)
            btnClearText.setTitle("", for: .normal)
            btnClearText.titleLabel?.text = ""
            btnClearText.layer.borderColor = UIColor.clear.cgColor
            btnClearText.layer.borderWidth = 0.0
            btnClearText.layer.cornerRadius = 0.0
        }
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.onZoom()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension LocationVC : MKMapViewDelegate{
    
    func mapView(_ mapLocation: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "ProfilePinView"
        var pinView = mapLocation.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
        pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        pinView!.canShowCallout = true
        pinView?.isDraggable = true
        pinView!.image = UIImage(named: "pinmarker.png")?.withRenderingMode(.alwaysTemplate)
        pinView?.tintColor = UIColor.appGuestThemeColor
        
        return pinView
        
    }
}


extension LocationVC:GoogleAutoCompleteDelegate{
    func googleAutoComplete(failedWithError error: String) {
        print("Error",error)
    }
    
    func googleAutoComplete(predictionsFetched predictions: [Prediction]) {
        self.searchPredictions = predictions
        if let text = txtFldLocation.text,
           text.isEmpty {
            self.searchPredictions.removeAll()
        }
        self.tblLocationSearch.reloadData()
    }
    
    func googleAutoComplete(didBeginEditing searchBar: UISearchBar) {
        searchBar.text = nil
    }
    func googleAutoComplete(didBeginEditing searchBar: UITextField) {
        searchBar.text = nil
    }
}
