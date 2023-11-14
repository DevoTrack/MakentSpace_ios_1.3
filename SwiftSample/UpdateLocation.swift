/**
 * UpdateLocation.swift
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

@objc protocol UpdateLocationDelegate
{
    func saveLocationName(dicts : [AnyHashable: Any], isSuccess: Bool)
    func goBack()
}


class UpdateLocation : UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate
{
    
    
    @IBOutlet var viewHeader: UILabel!
    @IBOutlet var txtFldStreet: UITextField!
    @IBOutlet var txtFldHomeAddress: UITextField!
    @IBOutlet var txtFlcCity: UITextField!
    @IBOutlet var txtFldState: UITextField!
    @IBOutlet var txtFldCountry: UITextField!
    @IBOutlet var txtFldZipCode: UITextField!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var pickerView:UIPickerView?
    @IBOutlet var viewPickerHolder:UIView?
    @IBOutlet weak var cancel_Butn : UIButton!
    @IBOutlet weak var cls_Butn : UIButton!
    
    @IBOutlet weak var tblLocationSearch: UITableView!
    
    var arrPickerData : NSArray!
    
    var googleModel : GoogleLocationModel!
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var delegate : UpdateLocationDelegate?
    
    var strRoomID = ""
    var strRoomType = ""
    var strPropertyType = ""
    var isFromFromEditing:Bool = false
    
    var strLatitude = ""
    var strLongitude = ""
    var strStreetName = ""
    var strAbtName = ""
    var strCityName = ""
    var strStateName = ""
    var strZipcode = ""
    var strCountryName = ""
    var dictLocation = [AnyHashable: Any]()
    var refreshControl: UIRefreshControl!

    
    
    
    //new added
    var isSearchStarted : Bool = false

    weak var locationAnnotation: MKAnnotation?
//    var dataLoader: GooglePlacesDataLoader?
    var selectedLocation: LocationModel!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var searchCountdownTimer: Timer?
    var autocompletePredictions = [Any]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    var googlePlaceSearchHandler : GoogleAutoCompleteHandler?
    var searchPredictions : [Prediction] = []

    
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        dataLoader = GooglePlacesDataLoader.init(delegate: self)

        tblLocationSearch.isHidden = true
        let rect = MakentSupport().getScreenSize()
        var rectMapView = view.frame
        txtFldStreet.delegate = self
        txtFldStreet.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        var rectTableView = tblLocationSearch.frame
        rectTableView.size.height = 250
        tblLocationSearch.frame = rectTableView
        
        self.viewHeader.text = self.lang.loc_Tit
        cancel_Butn.appHostTextColor()
        
        
        
//        txtFldStreet.contentHorizontalAlignment = UITextField.ContentHorizontalAlignment.center
        
        txtFldStreet.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        txtFldHomeAddress.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        txtFlcCity.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        txtFldState.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        txtFldZipCode.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        txtFldCountry.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        
        txtFldStreet.placeholder = self.lang.street_Tit
        txtFldHomeAddress.placeholder = self.lang.aptbuild_Tit
        txtFlcCity.placeholder = self.lang.city_Title
        txtFldState.placeholder = self.lang.state_Title
        txtFldZipCode.placeholder = self.lang.zip_Titt
        txtFldCountry.placeholder = self.lang.country_Title
        
        let path = Bundle.main.path(forResource: "country", ofType: "plist")
        arrPickerData = NSMutableArray(contentsOfFile: path!)!
        viewPickerHolder?.isHidden = true
        
        viewHeader.layer.shadowColor = UIColor.gray.cgColor;
        viewHeader.layer.shadowOffset = CGSize(width:0, height:1.0);
        viewHeader.layer.shadowOpacity = 0.5;
        viewHeader.layer.shadowRadius = 2.0;
        
        if isFromFromEditing
        {
            self.setEditField()
        }
        else
        {
            self.setAddressField()
        }
        
        
        self.cancel_Butn.setTitle(self.lang.cancel_Title, for: .normal)
        self.btnSave.setTitle(self.lang.save_Tit, for: .normal)
        self.cls_Butn.setTitle(self.lang.close_Tit, for: .normal)
    }
    
 
    
    func setEditField()
    {
        let tempModel = GoogleLocationModel()
        tempModel.street_address = strStreetName
        tempModel.premise_name = strAbtName
        tempModel.city_name = strCityName
        tempModel.state_name = strStateName
        tempModel.postal_code = strZipcode
        tempModel.country_name = strCountryName
        googleModel = tempModel
        self.setAddressField()
    }
    
    func setAddressField()
    {
        
        txtFldStreet.text = googleModel.street_address
        txtFldHomeAddress.text = googleModel.premise_name
        txtFlcCity.text = googleModel.city_name
        txtFldState.text = googleModel.state_name
        txtFldZipCode.text = googleModel.postal_code
        txtFldCountry.text = googleModel.country_name
        checkLoginButtonStatus()
        self.makeScroll(strSelection: strCountryName)
    }
    
    func makeScroll(strSelection:String)
    {
        if strSelection.count == 0
        {
            return
        }
        for i in 0 ..< arrPickerData.count
        {
            let str = ((arrPickerData[i] as AnyObject).value(forKey: "country_name") as! String)
            if str == strSelection
            {
                pickerView?.selectRow(i, inComponent: 0, animated: true)
            }
        }
    }
    
    
    // Following are the delegate and datasource implementation for picker view :
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return  ((arrPickerData[row] as AnyObject).value(forKey: "country_name") as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        strCountryName = ((arrPickerData[row] as AnyObject).value(forKey: "country_name") as! String)
        txtFldCountry.text = ((arrPickerData[row] as AnyObject).value(forKey: "country_name") as! String)
    }
    
    @IBAction func closePickerView()
    {
        viewPickerHolder?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        self.checkLoginButtonStatus()
        if((textField.text?.count)! > 0)
        {
            
        }
        else
        {
        }
        self.startCountdownTimer(forSearch: textField.text!)
        
    }
    
    func startCountdownTimer(forSearch searchString: String) {
        //stop the current countdown
        if (self.searchCountdownTimer != nil) {
            self.searchCountdownTimer?.invalidate()
        }
        //cancel all pending requests
//        self.dataLoader?.cancelAllRequests()
        let fireDate = Date(timeIntervalSinceNow: 1.0)
        // add search data to the userinfo dictionary so it can be retrieved when the timer fires
        let info: [AnyHashable: Any] = [
            "searchString" : searchString,
            //            "location" : location
        ]
        
        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.searchCountdownTimerFired), userInfo: info, repeats: false)
        
        RunLoop.main.add(self.searchCountdownTimer!, forMode: RunLoop.Mode.default)
    }
    
    @objc func searchCountdownTimerFired(_ countdownTimer: Timer) {
        let searchString = countdownTimer.userInfo as! NSDictionary
        let newsearchString: String? = searchString["searchString"] as? String// (countdownTimer.userInfo?["searchString"] as? String)
//        self.dataLoader?.sendAutocompleteRequest(withSearch: newsearchString, andLocation: nil)
        //        self.searchProgressView.startAnimating()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtFldCountry
        {
            self.view.endEditing(true)
            textField.inputView = pickerView
            viewPickerHolder?.isHidden = false
            pickerView?.reloadAllComponents()
            self.makeScroll(strSelection: strCountryName)
        }
        else
        {
            textField.inputView = nil
            viewPickerHolder?.isHidden = true
            textField.becomeFirstResponder()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        isSearchStarted = false
//        dataLoader?.cancelAllRequests()
    }
    
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
    
    // MARK: Checking Login Button status
    /*
     
     */
    func checkLoginButtonStatus()
    {
        if (txtFlcCity.text?.count)!>0 && (txtFldState.text?.count)!>0 && (txtFldCountry.text?.count)!>0
        {
            btnSave.setTitleColor(UIColor.red, for: .normal)
            btnSave.isUserInteractionEnabled = true
        }
        else
        {
            btnSave.isUserInteractionEnabled = false
            btnSave.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
    //MARK: NEXT BTN ACTION
    //MARK: API CALL - CREATE NEW ROOM
    /*
     HERE WE ARE PASSING PREVIOUS DETAILS (i.e - > room_type,property_type,latitude,longitude,max_guest_coun etc.,)
     */
    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        //updateLocationFromAddRoomDetail(dictLocation)
        
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        dictLocation["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dictLocation["room_id"]   = appDelegate.strRoomID
        dictLocation["street_name"]    = txtFldStreet.text
        dictLocation["street_address"] = txtFldHomeAddress.text
        dictLocation["city"]           = txtFlcCity.text
        dictLocation["state"]          = txtFldState.text
        dictLocation["zip"]            = txtFldZipCode.text
        dictLocation["country"]        = txtFldCountry.text
        if ((txtFldStreet.text != "") && (txtFlcCity.text != "") && (txtFldState.text != "") && (txtFldZipCode.text != "") && (txtFldCountry.text != nil)){
            appDelegate.s_types = "Found"
        }
        if appDelegate.test == "1"{
            
            dictLocation["latitude" ]      = String(appDelegate.latt)
            dictLocation["longitude"]      = String(appDelegate.longg)
            print(appDelegate.latt)
            strLatitude = String(appDelegate.latt)
            strLongitude = String(appDelegate.longg)
            appDelegate.lat1 = strLatitude
            appDelegate.long1 = strLongitude
        }
        else{
            
         dictLocation["latitude" ]    = strLatitude
         dictLocation["longitude"]    = strLongitude

        }
        
        dictLocation["is_success"]   = "No"
        validateLocation()
     
    }
    
    func updateLocationFromAddRoomDetail(_ dicts : [AnyHashable: Any])
    {
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        
       
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_ROOM_LOCATION as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                
                if gModel.status_code == "1"
                {
                    if gModel.dictTemp.count > 0
                    {
                       // self.updateNewLocation(dicts ,location_name:gModel.room_location)
                    }
                    else{
                       // self.updateNewLocation((gModel.dictTemp as NSDictionary) as! [AnyHashable : Any],location_name:gModel.room_location)
                    }
                  // self.navigationController!.popViewController(animated: true)
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
    
    func validateLocation()
    {
        let addressString = String(format:"%@, %@, %@, %@, %@, %@",txtFldStreet.text!,txtFldHomeAddress.text!,txtFlcCity.text!,txtFldState.text!,txtFldCountry.text!,txtFldZipCode.text!)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks, error) -> Void in
            OperationQueue.main.addOperation {
                if placemarks == nil
                {
                    self.dictLocation["is_success"]   = "No"
                    self.goBack(isSuccess : false)
                    return
                }
                if (placemarks?.count)! > 0 {
                    let pm = (placemarks?[0])
                    if pm != nil
                    {
                        self.stringPlaceMark(pm!)
                        
                    }
                }
            }
        })
    }
    
    func stringPlaceMark(_ placemark: CLPlacemark)
    {
        var isSuccess = false
        dictLocation["is_success"]   = "No"
        
        if (placemark.thoroughfare != nil) {
            print(placemark.thoroughfare! as String)
            isSuccess = true
            dictLocation["is_success"]   = "Yes"
        }
        
        goBack(isSuccess : isSuccess)
    }
    
    func goBack(isSuccess : Bool)
    {
        //print("didloc \(dictLocation as NSDictionary)")
        appDelegate.samVal = "2"
        dismiss(animated: true, completion: {
            self.delegate?.saveLocationName(dicts : self.dictLocation, isSuccess: isSuccess)
        })
    }
    
    //MARK: ------------ DELEGATE METHODS END ------------
    
    @IBAction func onCancelTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: {
            self.delegate?.goBack()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
       
         if isFromFromEditing
        {
            self.setEditField()
        }
        else
        {
            self.setAddressField()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //auto sussegtion
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if self.autocompletePredictions.count == 0
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
        let address =  (selectedCell.lblName?.text)!
        appDelegate.addaddress = address
        let selPrediction = self.autocompletePredictions[indexPath.row] as! NSDictionary
//        let referenceID: String? = (selPrediction[RESPONSE_KEY_REFERENCE] as? String)
//        self.dataLoader?.cancelAllRequests()
//        self.getLocationCoordinates(withReferenceID: referenceID!)
    }
    
//    internal func locationDescription(at index: Int) -> [AnyHashable: Any] {
//        let jsonData: [AnyHashable: Any] = self.autocompletePredictions[index] as! [AnyHashable : Any]
//        return jsonData
//    }
    
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
//
//                    self.googleModel = gModel
//                    self.isFromFromEditing = false
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
//        appDelegate.placeDetails = placeDetails as NSDictionary
//        self.searchDidComplete(withPlaceDetails: placeDetails)
//    }
//
//    func searchDidComplete(withPlaceDetails placeDetails: NSDictionary)
//    {
//        appDelegate.test = "1"
//        let placeGeometry =  (placeDetails[RESPONSE_KEY_GEOMETRY]) as? NSDictionary
//        let locationDetails  = (placeGeometry?[RESPONSE_KEY_LOCATION]) as? NSDictionary
//        let lat = (locationDetails?[RESPONSE_KEY_LATITUDE] as? Double)
//        let lng = (locationDetails?[RESPONSE_KEY_LONGITUDE] as? Double)
//
//        let longitude1 :CLLocationDegrees = lng!
//        let latitude1 :CLLocationDegrees = lat!
//        appDelegate.latt = latitude1
//        appDelegate.longg = longitude1
//        tblLocationSearch.isHidden = true
//        gotoUpdateLocationView()
//
//
//    }
    func gotoUpdateLocationView()
    {
       // self.dismiss(animated: true, completion: nil)
        self.viewWillAppear(true)
     
    }
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
//
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
//        print(url!)
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
//                    print(items.count)
//
//                    if (items.count>0)
//                    {
//                        successBlock(MakentSeparateParam().separate(params:  items, methodName: METHOD_GOOGLE_PLACE as NSString))
//
//                    }
//                    else {
//                        failureBlock(error!)
//                    }
//                }
//                catch _ {
//
//                }
//            }
//            }.resume()
//    }
//
//    func searchDidComplete(withPlaceDetails placeDetails: [AnyHashable: Any], andAttributions htmlAttributions: String) {
//        locationAnnotation = PlaceDetailsAnnotation(placeDetails: placeDetails)
//        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)
//
//        self.selectedLocation.longitude = String(format: "%2f", (self.locationAnnotation?.coordinate.longitude)!)
//        self.selectedLocation.latitude = String(format: "%2f", (self.locationAnnotation?.coordinate.latitude)!)
//        self.selectedLocation.currentLocation = CLLocation(latitude: (self.locationAnnotation?.coordinate.latitude)!, longitude: (self.locationAnnotation?.coordinate.longitude)!)
//
//    }
}


extension UpdateLocation:GoogleAutoCompleteDelegate{
    func googleAutoComplete(failedWithError error: String) {
        print("Error",error)
    }
    
    func googleAutoComplete(predictionsFetched predictions: [Prediction]) {
        self.searchPredictions = predictions
        if let text = txtFldStreet.text,
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
