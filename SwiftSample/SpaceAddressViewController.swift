//
//  SpaceAddressViewController.swift
//  Makent
//
//  Created by trioangle on 26/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import MapKit

class SpaceAddressViewController: UIViewController{
    @IBOutlet weak var FloorAddrsView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var guidanceView: UIView!
    
    @IBOutlet weak var chooseMapBtn: UIButton!
    
    @IBOutlet weak var addressStreetTxtFld: UITextField!
    
    @IBOutlet weak var addressFloorTxtFld: UITextField!
    
    @IBOutlet weak var checkinTextView: UITextView!
    
    var delegate: AddressPickerDelegate?
    
    
    @IBOutlet weak var lblHlpEvnt: UILabel!
    @IBOutlet weak var lblPplDesc: UILabel!
    
    @IBOutlet weak var lblListTitle: UILabel!
    
    @IBOutlet weak var lblAddrsDesc: UILabel!
    
    @IBOutlet weak var lblAddrsTit: UILabel!
    
    @IBOutlet weak var lblStrtTit: UILabel!
    
    @IBOutlet weak var lblAddrs2Title: UILabel!
    
    @IBOutlet weak var lblFlrTit: UILabel!
    
    @IBOutlet weak var lblChkTit: UILabel!
    
    @IBOutlet weak var lblShrDesc: UILabel!
    
    @IBOutlet weak var lblInfrmDesc: UILabel!
    
    @IBOutlet weak var lblMapNote: UILabel!
    
    
    var bsicStp = BasicStpData()
    var basicStp = BasicStpData()
    
    var strLocationName:String = ""
    var strSearchLoc:String = ""
    var isSelected : Bool = false
    
    var selectedLocation: LocationModel!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
//    var dataLoader: GooglePlacesDataLoader?
    var islocationSelected : Bool = false
    var searchCountdownTimer: Timer?
//    var autocompletePredictions = [Any]()
    weak var locationAnnotation: MKAnnotation?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //var addressSelected = Bool()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    var googlePlaceSearchHandler : GoogleAutoCompleteHandler?
    var searchPredictions : [Prediction] = []

    
    var spaceId = ""
    var guestAcs = ""
    var noOfGust = ""
    var amntes = ""
    var serExt = ""
    var servs = ""
    var sqft = ""
    var siTyp = ""
    var noOfRms = ""
    var noOfResRms = ""
    var flrNo = ""
    var keyRespond: Bool = false
    var locationModelList = [GoogleTitleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     self.initViewLayoutAction()
        if self.basicStp.isEditSpace{
            self.addressStreetTxtFld.text = self.basicStp.addressLine1
            self.addressFloorTxtFld.text = self.basicStp.addressLine2
            self.checkinTextView.text = self.basicStp.guidance
            self.checkinTextView.textColor = .black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.basicStp.currentScreenState = .spaceAddress
        
    }
    
    class func InitWithStory()-> SpaceAddressViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceAddressViewController") as! SpaceAddressViewController
    }
    
    
    func initViewLayoutAction(){
        print("boolVal:",keyRespond)
        self.navigationController?.navigationBar.isHidden = false
        self.addressStreetTxtFld.delegate = self
        self.addressFloorTxtFld.delegate = self
        self.checkinTextView.delegate = self
        //self.StoreData() self.lang.address_Title
        self.lblAddrsTit.attributedText = self.coloredAttributedText(normal: "Address Line #1:", self.lang.asteriskSymbol)
        self.chooseMapBtn.titleLabel?.TitleFont()
        self.lblAddrs2Title.text = "Address Line #2:"//self.lang.address2_Title
        self.lblStrtTit.text = "House name, street number, road"
            //self.lang.street_Tit + "," + self.lang.city_Title + "," + self.lang.state_Title + "," + self.lang.country_Title
        self.lblChkTit.TitleFont()
        self.lblChkTit.text = "Any relevant check-in information your guests should know about ?"
            //self.lang.chkGuidance
        self.lblFlrTit.text = "Suburb, postal code, city"
            //self.lang.aptTitle
        
       
        self.lblShrDesc.text = "It's important for guests to know exactly where you are located, so the can make travel arrangements accordingly"
            //self.lang.shrDesc
        self.lblInfrmDesc.text = "Please be as specific as possible with your exact address."
            //self.lang.infrmDesc
        self.lblAddrsDesc.text = "Please provide the full physical address of your venue."
            //self.lang.fulladdDesc
        
        self.lblPplDesc.DescFont()
        self.lblListTitle.TextTitleFont()
        self.lblAddrsDesc.DescFont()
        self.lblShrDesc.DescFont()
        self.lblInfrmDesc.DescFont()
        self.continueBtn.setfontDesign()
        //self.lblHlpEvnt.text = self.lang.hlpEveOrg
        self.lblHlpEvnt.text = self.lang.getStartList
        self.lblPplDesc.text = self.lang.peopSearch + " " + k_AppName + " " + self.lang.mthNeeds
        self.lblListTitle.text = self.lang.listings_Title
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        self.addressStreetTxtFld.AlignText()
        self.addressFloorTxtFld.AlignText()
        self.checkinTextView.AlignText()
        self.continueBtn.addTap {
            if self.emptyAlert(){
            if self.basicStp.isEditSpace{
                self.ContinueAction()
            }else{
                self.ContinueAct()
            }
            }
        }
       
        if !self.basicStp.isEditSpace{
        self.bsicStp = self.basicStp.copy()
        self.continueBtn.alpha = 0.1
        self.chooseMapBtn.setTitle("", for: .normal)
        self.chooseMapBtn.isUserInteractionEnabled = false
        self.lblMapNote.text = ""
        self.continueBtn.isUserInteractionEnabled = false
        }
        print(basicStp.spaceName)
       
        self.checkinTextView.placeTextHolder(holdVal: self.lang.checkinDesc)
        FloorAddrsView.BorderView()
        addressView.BorderView()
        guidanceView.BorderView()
        self.basicStp.currentScreenState = .spaceAddress
        self.addtapEnd()
        self.addBackButton()
       
        addressStreetTxtFld.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        self.chooseMapBtn.addTarget(self, action: #selector(self.onTappedMapPinBtnAction), for: .touchUpInside)
        updateCurrentLocation()
        
//        dataLoader = GooglePlacesDataLoader.init(delegate: self)
        if let _selectedLocation = self.delegate?.getAvailableAddress(){
            selectedLocation = _selectedLocation
            addressStreetTxtFld.text = selectedLocation.searchedAddress
            
        }else{
            
            selectedLocation = LocationModel()
        }
    }
    
    func StoreData(){
        
        spaceId = self.basicStp.spaceId.description
        guestAcs =  self.basicStp.guesAccessList
        noOfGust = self.basicStp.noofGuest.description
        amntes = self.basicStp.amenitiesList
        serExt = self.basicStp.servicesExtra
        servs = self.basicStp.services
        sqft = self.basicStp.footageSpace.description
        siTyp = self.basicStp.sizeType
        noOfRms = (self.basicStp.getValue(.rooms)).description
        noOfResRms = (self.basicStp.getValue(.restRooms)).description
        flrNo = (self.basicStp.getValue(.floorNumber)).description
        
    }
    
    func ContinueAlphaAction()
    {
        let address1 = addressStreetTxtFld.text!
        let address2 = addressFloorTxtFld.text!
        let city = basicStp.city
        let country = basicStp.country
        let state = basicStp.state
        let guidance = self.checkinTextView.text!
        let latitude = basicStp.latitude
        let longitude = basicStp.longitude
        let locationData = "\(address1)," + "\(address2)," + "\(city)," + "\(country)," + "\(state)," + "\(latitude)," + "\(longitude)," + guidance
        print("LocationData:",locationData)
        
        var provideDict = [String:Any]()
        provideDict["address_line_1"] = self.basicStp.addressLine1
        provideDict["address_line_2"] = address2
        provideDict["city"] = self.basicStp.city
        provideDict["country"] = self.basicStp.country
        provideDict["country_name"] = self.basicStp.countryName
        provideDict["guidance"] = guidance
        provideDict["state"] = self.basicStp.state
        
        provideDict["latitude"] = latitude
        provideDict["longitude"] = longitude
        provideDict["postal_code"] = self.basicStp.postalCode
        
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["location_data"] = self.sharedUtility.getJsonFormattedString(provideDict)

        parameter["space_type"] = self.bsicStp.spaceId.description //self.spaceId
        parameter["guest_access"] = self.bsicStp.guesAccessList //self.guestAcs
        parameter["number_of_guests"] = self.bsicStp.noofGuest //self.noOfGust
        
        parameter ["amenities"] = self.bsicStp.amenitiesList //self.amntes
        parameter["services_extra"] = self.bsicStp.extServices //self.serExt
        parameter["services"] = self.bsicStp.servicesList //self.servs
        
        parameter["size_type"] = self.bsicStp.sizeType  == "" ? self.bsicStp.spaceTypeVal : self.bsicStp.sizeType
        parameter["sq_ft"] = self.bsicStp.footageSpace.description //self.sqft
    
        parameter["number_of_rooms"] = (self.bsicStp.getValue(.rooms)).description //noOfRms
        parameter["number_of_restrooms"] = (self.bsicStp.getValue(.restRooms)).description //noOfResRms
        parameter["floor_number"] = (self.bsicStp.getValue(.floorNumber)).description //flrNo
        parameter["space_id"] = self.bsicStp.spaceId.description
       
        
        print("Parameter",parameter)
        
        //APIMethodsEnum.createSpace
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    
                    MakentSupport().removeProgress(viewCtrl: self)
                    BasicStpData.shared.spaceID = _json.int("space_id").description
                    self.ContinueAct()
                    
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
 
                }
            }
            
        }
        
    }
    
    
    func ContinueAction(){


          self.basicStp.addressLine2 = addressFloorTxtFld.text!
        if self.checkinTextView.text != self.lang.checkinDesc{
            self.basicStp.guidance = self.checkinTextView.text!
        }
        

        
        var provideDict = [String:Any]()
        provideDict["address_line_1"] = self.basicStp.addressLine1
        provideDict["address_line_2"] = self.basicStp.addressLine2
        provideDict["city"] = self.basicStp.city
        provideDict["country"] = self.basicStp.country
        provideDict["country_name"] = self.basicStp.countryName
        provideDict["guidance"] = self.basicStp.guidance
        provideDict["state"] = self.basicStp.state
        provideDict["latitude"] = self.basicStp.latitude
        provideDict["longitude"] = self.basicStp.longitude
        provideDict["postal_code"] = self.basicStp.postalCode
        
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["location_data"] = self.sharedUtility.getJsonFormattedString(provideDict)
        print("Guidance:",self.basicStp.guidance)
            //self.getJsonFormattedString(provideDictArray)
        //locationData
       
        //APIMethodsEnum.createSpace
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.ContinueAct()
                    
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
                    
                    
                }
            }
            
        }
        
    }
    
    //Mark:- Alert Function
    func emptyAlert() -> Bool{
        if (self.addressStreetTxtFld.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            self.appDelegate.createToastMessage(self.lang.pleaseEnterSpaceAddress, isSuccess: false)
            return false
        }
        if (self.basicStp.latitude.trimmingCharacters(in: .whitespaces).isEmpty) || (self.basicStp.longitude.trimmingCharacters(in: .whitespaces).isEmpty){
            self.appDelegate.createToastMessage(self.lang.pleaseEnterValidAddress, isSuccess: false)
            return false
        }
        return true
    }
    
    
    func ContinueAct(){
        

        let guestView = AccessibilityViewController.InitWithStory()
      
        if self.basicStp.isEditSpace{
             guestView.bsicStp.isEditSpace = self.basicStp.isEditSpace
             guestView.bsicStp.guestAccess = self.bsicStp.guestAccess
        }
        
        //Mark:- Copied Data of Previous Views While Fetching Address
        guestView.bsicStp = self.bsicStp
        
        //Mark: Address Data
        guestView.basicStp = self.basicStp
        guestView.basicStp.guidance = self.checkinTextView.text
        guestView.basicStp.addressLine2 = self.addressFloorTxtFld.text!
        self.navigationController?.pushView(viewController: guestView)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        self.startCountdownTimer(forSearch: textField.text!)

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
            
        }
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
        let locName = Constants().GETVALUE(keyname: APPURL.USER_LOCATION)
        if (locName.length > 0)
        {
            self.strLocationName = locName as String
            addressStreetTxtFld.becomeFirstResponder()
        }
        else
        {
            self.strLocationName = locName as String
        }
        let settingsActionSheet: UIAlertController = UIAlertController(title:self.lang.locpermisson_Tit, message:"\(self.lang.grant_Tit) \(k_AppName.capitalized) \(self.lang.locset_Title)", preferredStyle:UIAlertController.Style.alert)
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.setting_Title, style:UIAlertAction.Style.default, handler:{ action in
            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            self.islocationSelected = true
        }))
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }
    

}


extension SpaceAddressViewController:CLLocationManagerDelegate{
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
//        self.googlePlaceSearchHandler = GoogleAutoCompleteHandler(searchTextField: self.addressStreetTxtFld,
//                                  delegate: self,
//                                  userCurrentLatLng: (coord.latitude,
//                                                      coord.longitude))
        
        self.currentLocation = locationObj
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

extension SpaceAddressViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.addressStreetTxtFld{
            self.addressStreetTxtFld.becomeFirstResponder()
            
        }else{
            self.view.endEditing(true)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == addressStreetTxtFld{
            self.continueBtn.alpha = 0.1
            self.chooseMapBtn.setTitle("", for: .normal)
            self.chooseMapBtn.isUserInteractionEnabled = false
            self.lblMapNote.text = ""
            self.continueBtn.isUserInteractionEnabled = false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.addressStreetTxtFld.text = nil
//        dataLoader?.cancelAllRequests()
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.addressStreetTxtFld.text = nil
//        self.startCountdownTimer(forSearch: textField.text!)
//        dataLoader?.cancelAllRequests()
    }
}

extension SpaceAddressViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
       
            if textView.text == self.lang.checkinDesc{
            checkinTextView.text = ""
            checkinTextView.textColor = .black
            }else{
            
             checkinTextView.textColor = .black
            }
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
            if textView.text == ""{
                checkinTextView.text = self.lang.checkinDesc
                checkinTextView.textColor = .lightGray
                self.basicStp.guidance = ""
            }else{
                self.basicStp.guidance = textView.text
            }
       
        textView.resignFirstResponder()
    }
}

extension SpaceAddressViewController:GoogleAutoCompleteDelegate {
    
    func googleAutoComplete(failedWithError error: String) {
        print("Error",error)
    }
    
    func googleAutoComplete(predictionsFetched predictions: [Prediction]) {
        self.searchPredictions = predictions
        self.locationModelList.removeAll()
        if self.searchPredictions.isEmpty {
            
        } else {
            for index in 0...searchPredictions.count-1 {
                var tempJson = JSONS()
                guard let prediction = self.searchPredictions.value(atSafeIndex: index) else{return }

                tempJson["title"] = prediction.structuredFormatting.mainText
                tempJson["sub_title"] = prediction.structuredFormatting.secondaryText
                tempJson["place_id"] = prediction.placeID
                let model = GoogleTitleModel(json: tempJson)
                self.locationModelList.append(model)
            }
        }
  

        //        toget parent view from the scroll view for set y position popup
        let selectionVC = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "exprienceMeetSelectionViewController") as! ExprienceMeetSelectionViewController

        selectionVC.googleDelegate = self
        selectionVC.totalModelArray = self.locationModelList

        selectionVC.preferredContentSize = CGSize(width: self.view.frame.width, height: 300)
        selectionVC.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = selectionVC.popoverPresentationController!
        popover.delegate = self
        let barBtnItem =  UIBarButtonItem(customView: addressView)
        popover.barButtonItem = barBtnItem
        //        self.present(selectionVC, animated: true, completion: nil)
        self.addressStreetTxtFld.resignFirstResponder()

        self.present(selectionVC, animated: true) {

        }

    }
    
    func googleAutoComplete(didBeginEditing searchBar: UISearchBar) {
        searchBar.text = nil
    }
    func googleAutoComplete(didBeginEditing searchBar: UITextField) {
        searchBar.text = nil
    }
    
//    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, didLoadAutocompletePredictions predictions: [Any]!) {
//        self.autocompletePredictions = predictions
//        self.locationModelList.removeAll()
//        for index in 0...autocompletePredictions.count-1 {
//            var adict: JSONS = self.locationDescription(at: index)
//            var tempJson = JSONS()
//
//
//
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
//            tempJson["title"] = finalTitle
//            tempJson["sub_title"] = finalSubTitle
//            tempJson["place_id"] = adict.string("place_id")
//            let model = GoogleTitleModel(json: tempJson)
//            self.locationModelList.append(model)
//        }
//
//        //        toget parent view from the scroll view for set y position popup
//        let selectionVC = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "exprienceMeetSelectionViewController") as! ExprienceMeetSelectionViewController
//
//        selectionVC.googleDelegate = self
//        selectionVC.totalModelArray = self.locationModelList
//
//        selectionVC.preferredContentSize = CGSize(width: self.view.frame.width, height: 300)
//        selectionVC.modalPresentationStyle = .popover
//        let popover: UIPopoverPresentationController = selectionVC.popoverPresentationController!
//        popover.delegate = self
//        let barBtnItem =  UIBarButtonItem(customView: addressView)
//        popover.barButtonItem = barBtnItem
//        //        self.present(selectionVC, animated: true, completion: nil)
//        self.addressStreetTxtFld.resignFirstResponder()
//
//        self.present(selectionVC, animated: true) {
//
//        }
//
//    }
    
    
    func getLocationCoordinates(withReferenceID placeId: String)
    {
        
        
        var paramDict = [String:Any]()
        paramDict["placeid"] = placeId
        paramDict["key"] = GOOGLE_MAP_API_KEY//GOOGLE_MAP_API_KEY
        paramDict["fields"] = ""
        var selectedAddress = JSONS()
        WebServiceHandler.sharedInstance.getThirdPartyAPIWebService(wsURL: "https://maps.googleapis.com/maps/api/place/details/json", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false, complete: { (responseDict) in
            print(responseDict)
            
            if let result = responseDict["result"] as? JSONS {
                
                
                selectedAddress["latitude"] = result.json("geometry").json("location").double("lat")
                
                selectedAddress["longitude"] = result.json("geometry").json("location").double("lng")
                
                selectedAddress["address_line_1"] = result.string("formatted_address")
                for component in result.array("address_components")
                {
                    if let country = (component["types"] as? [String]), country[0] == "country" {
                        selectedAddress["country"] = component.string("short_name") //long_name
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
                
                //Mark:- Avoiding isEdit Option Change while setting address data to model
                if self.basicStp.isEditSpace{
                    if self.basicStp.guestAccess != ""{
                        self.bsicStp.guestAccess = self.basicStp.guestAccess
                        
                    }
                   self.basicStp = BasicStpData(selectedAddress)
                   self.basicStp.isEditSpace = true
                }else{
                   
                    self.basicStp = BasicStpData(selectedAddress)
                    self.basicStp.isEditSpace = false
                }
                
                self.setExPLocationData()
            }
            
        })
    }
    
    
//    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, didLoadPlaceDetails placeDetails: [AnyHashable : Any]!, withAttributions htmlAttributions: String!) {
//
//    }
//
//    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, autocompletePredictionsDidFailToLoad error: Error!) {
//
//        //        self.view.endEditing(true)
//    }
//
//    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, placeDetailsDidFailToLoad error: Error!) {
//
//    }
    
  
    
//    internal func locationDescription(at index: Int) -> JSONS {
//        let jsonData: JSONS = self.autocompletePredictions[index] as! JSONS
//        return jsonData
//    }
    
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
        ]
        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.searchCountdownTimerFired), userInfo: info, repeats: false)
        RunLoop.main.add(self.searchCountdownTimer!, forMode: .default)

    }
//
    func setExPLocationData() {

        
        self.addressStreetTxtFld.text = self.basicStp.addressLine1
        self.chooseMapBtn.setTitle(self.lang.chsOnMap, for: .normal)
        self.chooseMapBtn.isUserInteractionEnabled = true
        self.lblMapNote.text = "** Note: Please mark your exact geo location in map"
        self.selectTextForInput(input: self.addressStreetTxtFld, range: 0)
        self.addressStreetTxtFld.resignFirstResponder()
    }
    
    func selectTextForInput(input: UITextField, range: Int) {
        let start: UITextPosition = input.position(from: input.beginningOfDocument, offset: range)!
        let end: UITextPosition = input.position(from: start, offset: range)!
        input.selectedTextRange = input.textRange(from: start, to: end)
    }
    
    @objc func searchCountdownTimerFired(_ countdownTimer: Timer) {
        let searchString = countdownTimer.userInfo as! NSDictionary
        let newsearchString: String? = searchString["searchString"] as? String
        self.googlePlaceSearchHandler = GoogleAutoCompleteHandler(searchTextField: addressStreetTxtFld,
                                  delegate: self,userCurrentLatLng: (currentLocation.coordinate.latitude,currentLocation.coordinate.longitude))
//        self.dataLoader?.sendAutocompleteRequest(withSearch: newsearchString, andLocation: nil)
    }
    @objc func onTappedMapPinBtnAction(){
        // call map Label
       
        let MapVc = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "mapPinLocationViewController") as! MapPinLocationViewController
        MapVc.locationDelegate = self
        if  self.basicStp != nil {
            MapVc.selectedLocationModel = self.basicStp
            MapVc.selectedLocationModel.isEditSpace = self.basicStp.isEditSpace
            MapVc.selectedLocationModel.guestAccess = self.bsicStp.guestAccess
        }
        if !self.basicStp.isEditSpace{
            MapVc.dataCopy = self.bsicStp
        }
        self.continueBtn.alpha = 1.0
        self.continueBtn.isUserInteractionEnabled = true
        self.present(MapVc, animated:true, completion: nil)
    }
    
}

extension SpaceAddressViewController:ExpLocationUpdateDelegate,GoogleLocationUpdateExperience ,UIPopoverPresentationControllerDelegate{
    func getGoogledata(_ model: GoogleTitleModel) {
        self.getLocationCoordinates(withReferenceID: model.placeId)
    }
    
   
    
    func updatWhereWillMeet(_ model: BasicStpData, copyData:BasicStpData) {
        if copyData.guestAccess != ""{
            self.bsicStp.guestAccess = copyData.guestAccess
        }
        self.bsicStp = copyData
        self.basicStp = model
        self.setExPLocationData()
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if !self.isSelected{
            self.lblMapNote.text = ""
            self.chooseMapBtn.setTitle("", for: .normal)
            self.chooseMapBtn.isUserInteractionEnabled = false
            self.continueBtn.alpha = 0.1
            self.continueBtn.isUserInteractionEnabled = false
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseSelectAddressFromList, isSuccess: false)
        }
            
        
    }
    
}




//MARK: LOCATION MODEL

class GoogleTitleModel {
    var title: String
    var subTitle:String
    var placeId:String
    
    init(json:JSONS) {
        self.title = json.string("title")
        self.subTitle = json.string("sub_title")
        self.placeId = json.string("place_id")
    }
}
extension GoogleTitleModel {
    convenience init(currencyJSONS: JSONS) {
        self.init(json: currencyJSONS)
        title = currencyJSONS.string("code")
        //            self.checkParamTypes(params: responseDict, keys:"code")
        subTitle = currencyJSONS.string("symbol").stringByDecodingHTMLEntities
    }
}


class ExpLocationModel {
    
    var id = Int()
    var addressLine1 = String()
    var addressLine2 = String()
    var city = String()
    var state = String()
    var country = String()
    var postalCode = String()
    var latitude = Double()
    var longitude = Double()
    var locationName = String()
    var directions = String()
    var apt = String()
    var jsonModel:JSONS!
    
    init() {
    }
    
    init(json:JSONS) {
        
        self.addressLine1 = json.string("address_line_1")
        self.addressLine2 = json.string("address_line_2")
        self.city = json.string("city")
        self.state = json.string("state")
        self.country = json.string("country")
        self.postalCode = json.string("postal_code")
        self.latitude = json.double("latitude")
        self.longitude = json.double("longitude")
        self.directions = ""
        self.locationName = ""
        self.id = 0
        self.apt = ""
        self.jsonModel = json
        
    }
    
}
extension ExpLocationModel :NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copyModel = ExpLocationModel(apiJson: jsonModel)
        return copyModel
    }
    
    convenience init(apiJson:JSONS) {
        self.init(json: apiJson)
        self.addressLine1 = apiJson.string("street_address")
        self.addressLine2 = apiJson.string("address_line_2")
        self.city = apiJson.string("city")
        self.state = apiJson.string("state")
        self.country = apiJson.string("country")
        self.postalCode = apiJson.string("postal_code")
        
        if apiJson.string("latitude") != "" && apiJson.string("longitude") != ""  {
            
            self.latitude = (apiJson.string("latitude") as NSString).doubleValue
            self.longitude = (apiJson.string("longitude") as NSString).doubleValue
        }else {
            self.latitude = apiJson.double("latitude")
            self.longitude = apiJson.double("longitude")
        }
        self.directions = apiJson.string("directions")
        self.locationName = apiJson.string("location_name")
        self.apt = apiJson.string("apt")
        self.id = apiJson.int("id")
        self.jsonModel = apiJson
    }
}

/* var provideDictArray = [[String:Any]]()
 var provideDict = [String:Any]()
 //self.basicSteps.forEach{ (newModel) in
 provideDict["address_line_1"] = self.basicStp.addressLine1
 provideDict["address_line_2"] = self.basicStp.addressLine2
 provideDict["city"] = self.basicStp.city
 provideDict["country"] = self.basicStp.country
 provideDict["country_name"] = self.basicStp.countryName
 provideDict["guidance"] = self.basicStp.guidance
 provideDict["state"] = self.basicStp.state
 provideDict["latitude"] = self.basicStp.latitude
 provideDict["longitude"] = self.basicStp.longitude
 provideDict["postal_code"] = self.basicStp.postalCode
 provideDictArray.append(provideDict)
 //}*/
