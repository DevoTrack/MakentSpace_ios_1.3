/**
 * SearchVC.swift
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

protocol AddressPickerDelegate
{
    func aaddressPickingDidFinish(_ searchedLocation: LocationModel, searchedString : String)
    func getAvailableAddress() -> LocationModel?
}

class SearchVC : UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet var tblLocationSearch: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var btnClear: UIButton!
    @IBOutlet var txtFldSearch: UITextField!
    
    var strLocationName:String = ""
//    var strSearchLoc:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let arrPopularPlace: [String] = ["New York", "Paris", "Berlin", "London", "San Francisco","Rome","Barcelona"]
    var selectedCell : CellLocation!
    var delegate: AddressPickerDelegate?
    var isCalled : Bool = false
    var islocationSelected : Bool = false
    //MARK: GOOGLE PLACE SEARCH
//    var dataLoader: GooglePlacesDataLoader?
    var selectedLocation = LocationModel()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var searchCountdownTimer: Timer?
//    var autocompletePredictions = [Any]()
    weak var locationAnnotation: MKAnnotation?
    let language = Language.getCurrentLanguage().getLocalizedInstance()
    
    var googlePlaceSearchHandler : GoogleAutoCompleteHandler?
    var searchPredictions : [Prediction] = []

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        updateCurrentLocation()
        let longitude = Constants().GETVALUE(keyname: APPURL.USER_LONGITUDE)
        let latitude = Constants().GETVALUE(keyname: APPURL.USER_LATITUDE)
        if (longitude.length > 0 && latitude.length > 0)
        {
            let longitude1 :CLLocationDegrees = Double(longitude as String)!
            let latitude1 :CLLocationDegrees = Double(latitude as String)!
            let location = CLLocation(latitude: latitude1, longitude: longitude1)
            self.currentLocation = location
        }
//        if strSearchLoc.count>0
//        {
//            if ![self.language.nearby_Tit,
//                 self.language.anywhere_Tit].contains(strSearchLoc){
//                //strSearchLoc != "Nearby" && strSearchLoc != "Anywhere"
//
//                txtFldSearch.text = strSearchLoc
//                self.startCountdownTimer(forSearch: txtFldSearch.text!)
//            }
//        }
        let locName = Constants().GETVALUE(keyname: APPURL.USER_LOCATION)
        if (locName.length > 0)
        {
            self.strLocationName = locName as String
            txtFldSearch.becomeFirstResponder()
        }
//        txtFldSearch.textColor = UIColor.white
        txtFldSearch.delegate = self
//        txtFldSearch.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        btnClear.isHidden = true
        UITextField.appearance().tintColor = UIColor.black
        tblLocationSearch.tableHeaderView = tblHeaderView
//        dataLoader = GooglePlacesDataLoader.init(delegate: self)
//        if let _selectedLocation = self.delegate?.getAvailableAddress(){
//            selectedLocation = _selectedLocation
//            txtFldSearch.text = selectedLocation.searchedAddress
//            self.btnClear.isHidden = false
//        }else{
//            self.btnClear.isHidden = true
//            selectedLocation = LocationModel()
//        }
        self.localize()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    func localize(){
        self.txtFldSearch.placeholder = self.language.where_To
        self.btnClear.setTitle(self.language.clr_Tit, for: .normal)
        self.txtFldSearch.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
    }
    func checkLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                self.showAlert()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                self.updateCurrentLocation()
            }
        } else {
            //       self.showAlert()
        }
    }
    
    func showAlert() {
        let locName = Constants().GETVALUE(keyname: APPURL.USER_LOCATION)
        if (locName.length > 0)
        {
            self.strLocationName = locName as String
            txtFldSearch.becomeFirstResponder()
        }
        else
        {
            self.strLocationName = locName as String
        }
        let settingsActionSheet: UIAlertController = UIAlertController(title:self.language.locpermisson_Tit, message:"\(self.language.grant_Tit) \(k_AppName.capitalized) \(self.language.locset_Title)", preferredStyle:UIAlertController.Style.alert)
        settingsActionSheet.addAction(UIAlertAction(title:self.language.setting_Title, style:UIAlertAction.Style.default, handler:{ action in
            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            self.islocationSelected = true
        }))
        settingsActionSheet.addAction(UIAlertAction(title:self.language.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @IBAction func onClearTapped(_ sender:UIButton!)
    {
        self.btnClear.isHidden = true
        txtFldSearch.text = ""
        self.searchPredictions.removeAll()
        tblLocationSearch.reloadData()
    }
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.updateCurrentLocation()
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        dataLoader?.cancelAllRequests()
//    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        btnClear.isHidden = ((textField.text?.count)! > 0) ? false : true
//        self.startCountdownTimer(forSearch: textField.text!)
//    }
//
//
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
//            ]
//        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.searchCountdownTimerFired), userInfo: info, repeats: false)
//        RunLoop.main.add(self.searchCountdownTimer!, forMode: RunLoop.Mode.default)
//
//    }
    
//
//    @objc func searchCountdownTimerFired(_ countdownTimer: Timer) {
//        let searchString = countdownTimer.userInfo as! NSDictionary
//        let newsearchString: String? = searchString["searchString"] as? String
//        self.dataLoader?.sendAutocompleteRequest(withSearch: newsearchString, andLocation: nil)
//    }
    
    
    // MARK: - GooglePlacesDataLoaderDelegate methods
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadAutocompletePredictions predictions: [Any]) {
//        self.autocompletePredictions = predictions
//        tblLocationSearch.reloadData()
//    }
//
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadPlaceDetails placeDetails: [AnyHashable: Any], withAttributions htmlAttributions: String) {
//        self.searchDidComplete(withPlaceDetails: placeDetails, andAttributions: htmlAttributions)
//    }
//
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, autocompletePredictionsDidFailToLoad error: Error?) {
//    }
//
//    internal func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, placeDetailsDidFailToLoad error: Error?) {
//    }
//
//    internal func locationDescription(at index: Int) -> [AnyHashable: Any] {
//        let jsonData: [AnyHashable: Any] = self.searchPredictions[index] as! [AnyHashable : Any]
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
        let locName = Constants().GETVALUE(keyname: APPURL.USER_LOCATION)
        if (locName == "") //  NO NEED TO CALL AFTER GETTING CURRENT LOCATION NAME
        {
            self.getLocationName(lat: coord.latitude, long: coord.longitude)
        }
        
        self.googlePlaceSearchHandler = GoogleAutoCompleteHandler(searchTextField: self.txtFldSearch,
                                  delegate: self,
                                  userCurrentLatLng: (coord.latitude,
                                                      coord.longitude))
        
        self.currentLocation = locationObj
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
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
                if let locality = pm.locality {
                    self.strLocationName = locality
                }else {
                    self.getAddressForLatLng(latitude: lat.description, longitude: long.description)
                }
                Constants().STOREVALUE(value: self.strLocationName as NSString, keyname: APPURL.USER_LOCATION)
            }
            else {
            }
        })
        
    }
    func getAddressForLatLng(latitude: String, longitude: String) {
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
                    else if let state = (component["types"] as? [String]),state[0] == "administrative_area_level_1" {
                        selectedAddress["State"] = component.string("long_name")
                    }
                    else if let country = (component["types"] as? [String]), country[0] == "sublocality_level_1" {
                        selectedAddress["Country"] = component.string("short_name")//long_name
                        
                    }
                    else if let state = (component["types"] as? [String]),state[0] == "postal_code" {
                        selectedAddress["PostalCode"] = component.string("long_name")
                    }
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
    
    
//    func searchDidComplete(withCurrentLocationSelected currentLocation: CLLocation) {
//        if currentLocation != nil {
//            self.locationAnnotation = CurrentLocationAnnotation(location: currentLocation)
//            self.selectedLocation.longitude = String(format: "%2f", currentLocation.coordinate.longitude)
//            self.selectedLocation.latitude = String(format: "%2f", currentLocation.coordinate.latitude)
//            self.selectedLocation.currentLocation = currentLocation
//        }
//        else
//        {
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if self.searchPredictions.count == 0
        {
            return (MakentSupport().isPad()) ? 50 : 65
        }
        else
        {
            return (MakentSupport().isPad()) ? 50 : 76
        }
    }
    
    // MARK: - **** Table View Data Source ****
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if(section != 0) {
            let viewHolder:UIView = UIView()
            viewHolder.frame =  CGRect(x: 0, y:0, width: (self.view.frame.size.width) ,height: 40)
            let lblSeparator:UILabel = UILabel()
            lblSeparator.frame =  CGRect(x: 0, y:20, width: viewHolder.frame.size.width ,height: 1)
            lblSeparator.backgroundColor = UIColor.lightGray
            viewHolder.addSubview(lblSeparator)
            let lblRoomName:UILabel = UILabel()
            lblRoomName.frame =  CGRect(x: 50, y:30, width: viewHolder.frame.size.width-100 ,height: 40)
            lblRoomName.text="Popular Destinations"
            lblRoomName.textColor = UIColor.lightGray
            viewHolder.addSubview(lblRoomName)
            return viewHolder
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0) {
            return 70
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.searchPredictions.count == 0) ? 2 : self.searchPredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.searchPredictions.count == 0{
            let cell:CellNearBy = tblLocationSearch.dequeueReusableCell(withIdentifier: "CellNearBy") as! CellNearBy
            cell.lblName?.text = (indexPath.row==0) ? self.language.anywhere_Tit : self.language.nearby_Tit
            cell.lblName?.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: (MakentSupport().isPad()) ? 25 : 18)
            cell.lblName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            return cell
        }else{
//            var adict: [AnyHashable: Any] = self.locationDescription(at: indexPath.row)
//            let titleString: String? = (adict[RESPONSE_KEY_DESCRIPTION] as? String)
//            var addresArray  = titleString?.components(separatedBy: ",")
//            let finalTitle: String? = ((addresArray?.count)! > 0) ? addresArray?[0] : ""
//            var finalSubTitle: String = ""
//            let count = (addresArray?.count)! as Int
//            for i in 1 ..< count
//            {
//                finalSubTitle = finalSubTitle + (addresArray?[i])!
//                if i < (addresArray?.count)! - 1 {
//                    if i == 1
//                    {
//                        finalSubTitle = finalSubTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//                    }
//
//                    finalSubTitle = finalSubTitle + ","
//                }
//            }
            
            let cell:CellLocation = tblLocationSearch.dequeueReusableCell(withIdentifier: "CellLocation") as! CellLocation
            guard let prediction = self.searchPredictions.value(atSafeIndex: indexPath.row) else{return cell}
            cell.lblName?.text = prediction.structuredFormatting.mainText
            cell.lblName?.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: (MakentSupport().isPad()) ? 25 : 18)
            cell.lblSubName?.text = prediction.structuredFormatting.secondaryText
            return cell
        }
    }
    
    // MARK:  **** Table View Data Source End ****
    // MARK:  **** Table View Delegate ****
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.searchPredictions.count == 0
        {
            let longitude = Constants().GETVALUE(keyname: APPURL.USER_LONGITUDE)
            let latitude = Constants().GETVALUE(keyname: APPURL.USER_LATITUDE)
            if (longitude.length > 0 && latitude.length > 0) && indexPath.row > 0
            {
                selectedLocation.searchedAddress = strLocationName
                self.selectedLocation.longitude = String(format: "%2f", self.currentLocation.coordinate.longitude)
                self.selectedLocation.latitude = String(format: "%2f", self.currentLocation.coordinate.latitude)
            }
            else
            {
                selectedLocation.searchedAddress = ""
                self.selectedLocation.longitude = ""
                self.selectedLocation.latitude = ""
            }
            if (indexPath.row == 1) {self.checkLocationPermission()}
            
            if islocationSelected || CLLocationManager.locationServicesEnabled(){
                if CLLocationManager.locationServicesEnabled() {
                    switch(CLLocationManager.authorizationStatus()) {
                    case .notDetermined, .restricted, .denied:
                        locationManager.requestWhenInUseAuthorization()
                        break
                    case .authorizedAlways, .authorizedWhenInUse:
                        delegate?.aaddressPickingDidFinish(self.selectedLocation ?? LocationModel(),searchedString : (indexPath.row == 0) ? self.language.anywhere_Tit : self.language.nearby_Tit)
                        selectedCell = tableView.cellForRow(at: indexPath) as? CellLocation
                        self.onBackTapped(nil)
                    }
                }
            }
        }
        else{
            guard let prediction = self.searchPredictions.value(atSafe: indexPath.row) else{return}
            selectedLocation.searchedAddress = prediction.structuredFormatting.mainText + "," + prediction.structuredFormatting.secondaryText
            delegate?.aaddressPickingDidFinish(self.selectedLocation ?? LocationModel(),searchedString : prediction.structuredFormatting.mainText as! String)
            self.onBackTapped(nil)
        }
    }
    
//    // MARK: - **** Table View Delegate End ****
//    func getLocationCoordinates(withReferenceID referenceID: String)
//    {
//        var dicts = [AnyHashable: Any]()
//        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//        self.GetGoogleRequest(dicts,methodName: referenceID as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
//            let gModel = response as! GoogleLocationModel
//            OperationQueue.main.addOperation {
//                if gModel.status_code == "1"
//                {
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
    
//    func googleData(didLoadPlaceDetails placeDetails: NSDictionary) {
//        self.searchDidComplete(withPlaceDetails: placeDetails)
//    }
    
//    func searchDidComplete(withPlaceDetails placeDetails: NSDictionary)
//    {
//        let placeGeometry =  (placeDetails[RESPONSE_KEY_GEOMETRY]) as? NSDictionary
//        let locationDetails  = (placeGeometry?[RESPONSE_KEY_LOCATION]) as? NSDictionary
//        let lat = (locationDetails?[RESPONSE_KEY_LATITUDE] as? Double)
//        let lng = (locationDetails?[RESPONSE_KEY_LONGITUDE] as? Double)
//        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)
//        self.selectedLocation.longitude = String(format: "%2f", lng!)
//        self.selectedLocation.latitude = String(format: "%2f", lat!)
//        delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : (selectedCell.lblName?.text)!)
//        self.onBackTapped(nil)
//    }
    
//    func GetGoogleRequest(_ dict: [AnyHashable: Any], methodName : NSString, forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
//        self.getBlockServerResponseForparam(dict, method: methodName, withSuccessionBlock: {(_ response: Any) -> Void in
//            successBlock(response)
//        }, andFailureBlock: {(_ error: Error) -> Void in
//            failureBlock(error)
//        })
//    }
    
//    func getBlockServerResponseForparam(_ params: [AnyHashable: Any], method: NSString, withSuccessionBlock successBlock: @escaping (_ response: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void)
//    {
//        let paramsComponent: String = "?key=\(GOOGLE_PLACES_API_KEY)&reference=\(method)&sensor=\("true")"
//
//        let url = URL(string: GOOGLE_MAP_DETAILS_URL + paramsComponent.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)
//        var items = NSDictionary()
//
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
//                }
//            }
//            }.resume()
//    }
    
    @IBAction func onBackTapped(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchVC:GoogleAutoCompleteDelegate{
    func googleAutoComplete(failedWithError error: String) {
        print("Error",error)
    }
    
    func googleAutoComplete(predictionsFetched predictions: [Prediction]) {
        self.searchPredictions = predictions
        if let text = txtFldSearch.text,
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

class CellNearBy: UITableViewCell
{
    @IBOutlet var lblName: UILabel?
}

class CellLocation: UITableViewCell
{
    @IBOutlet var lblName: UILabel?
    @IBOutlet var lblSubName: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let alignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.lblName?.textAlignment = alignment
        self.lblSubName?.textAlignment = alignment
        
        
        
    }
}


extension Array{
    func value(atSafe index : Int) -> Element?{
        guard self.indices.contains(index) else {return nil}
        return self[index]
    }
}
