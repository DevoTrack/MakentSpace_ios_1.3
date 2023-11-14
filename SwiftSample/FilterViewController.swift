//
//  FilterViewController.swift
//  Makent
//
//  Created by trioangle on 16/05/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import ZMSwiftRangeSlider
import RangeSeekSlider

class RoomTypeTVC: UITableViewCell {
    
    @IBOutlet weak var roomTypeTitleLabel: UILabel!
    @IBOutlet weak var minusButtonOutlet: UIButton!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        self.plusButtonOutlet.alpha = 1.0
        self.minusButtonOutlet.alpha = 0.5
    }
    
    override func prepareForReuse() {
        
    }
}

class SeekerFilterTVC: UITableViewCell {
    
    @IBOutlet weak var seekerHeaderLabel: UILabel!
    @IBOutlet weak var filterLimitValueLabel: UILabel!
    @IBOutlet weak var sliderOutlet: RangeSlider!
    
    var minPrice = Int()
    var maxPrice = Int()
    var minMiles = Int()
    var maxMiles = Int()
    var filterMinValue = Int()
    var filterMaxValue = Int()
    var filterMinMiles = Int()
    var filterMaxMiles = Int()
    var seekerType = String()
}

class FilterOptionsTVC: UITableViewCell {
    
    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var optionValueLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
}

protocol NewFilterDelegate {
    func didSelectFilterOptions(filterDict: [String:Any])
}



class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterAmenitiesDelegate, RangeSeekSliderDelegate, FilterRoomTypeDelegate {

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var instantBookSwitchView: UIView!
    @IBOutlet weak var instantBookStatusLabel: UILabel!
    
    @IBOutlet weak var seekerHeaderLabel: UILabel!
    @IBOutlet weak var filterLimitValueLabel: UILabel!
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var sliderOutlet: RangeSeekSlider!
    
    @IBOutlet weak var instbk_Msg: UILabel!
    @IBOutlet weak var roomTypeView: UIView!
    
    @IBOutlet weak var spaceTypeCount: UILabel!
    
    @IBOutlet weak var eventTypeName: UILabel!
    
    @IBOutlet weak var eventTypeView: UIView!
    
    var roomTypeArray = [String]()
    var headerTitleArray = [sectionHeader]()
    var bedCount = 0, bedRoomCount = 0, bathRoomCount = 0
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var minPrice = Int()
    var maxPrice = Int()
    var maxPriceValue = Int()
    var bedTit = ""
    var bedroomTit = ""
    var bathTit = ""
    var eventTypeID = ""
    @IBOutlet weak var room_Typ: UILabel!
    @IBOutlet weak var insbook_Lbl: UILabel!
    var filterMinPrice = Int()
    var filterMaxPrice = Int()
    var fromMapFilterView = ""
    
    var amenitiesListDictArray = [[String:Any]]()
    var spaceTypesListDictArray = [[String:Any]]()
    var servicesListDictArray   = [[String:Any]]()
    var spaceStylesListDictArray = [[String:Any]]()
    var specialFeatureListDictArray = [[String:Any]]()
    var spaceRulesListDictArray    = [[String:Any]]()
    var filterTableListDictArray    = [[String:Any]]()
    var activityListDictArray       = [[String:Any]]()
    
    var selectedAmenitiesArray = [String]()
    var selectedSpaceTypesArray = [String]()
    var selectedServicesArray   = [String]()
    var selectedSpaceStylesArray = [String]()
    var selectedSpecialFeatureArray = [String]()
    var selectedSpaceRulesArray    = [String]()
    var selectedActivityArray    = [String]()
   // var selectedRoomTypeArray = [String]()
    var selectedEventTypeArray = [String]()
    
    var isInstantBookSelected = Bool()
    var newFilterDelegate:NewFilterDelegate?
    
    var filterResponse = [String: Any]()
    
    private let checkedImage = UIImage(named: "check_selected.png")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    private let unCheckedImage = UIImage(named: "check_deselected.png")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    
    var localFilter = JSONS()
    
    func navigationCustom() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = self.lang.filter
        self.navigationItem.backBarButtonItem?.title = ""
        self.seekerHeaderLabel.text = self.lang.pric_Title
        self.sliderOutlet.hideLabels = true
        self.sliderOutlet.transform = self.getAffine
        self.room_Typ.text = self.lang.rom_Typ
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.saveButtonOutlet.setTitle(self.lang.save_Tit, for: .normal)
        self.instbk_Msg.text = self.lang.instbk_Msg
        self.instbk_Msg.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        let backButton = UIButton(type: .custom)
        backButton.setTitle("e", for: .normal)
        backButton.transform = Language.getCurrentLanguage().getAffine
        backButton.titleLabel?.font = UIFont(name: Fonts.MAKENT_LOGO_FONT1, size: 20)
        backButton.setTitleColor(.black, for: .normal)
//        setImage(UIImage(named: "Back"), for: .normal)
        backButton.frame = CGRect(x: 0.0, y: 0.0, width: 15.0, height: 15.0)
        backButton.addTarget(self, action:  #selector(goBack), for: .touchUpInside)
        backButton.isChangeArabicButton()
        let bacButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = bacButton
       
        //        navigationItem.leftBarButtonItem?.tintColor = Utilities.sharedInstance.hexStringToUIColor(hex: "FF0F29")
        
        self.insbook_Lbl.text = self.lang.instbk_Only
        
        let clearAllButton = UIBarButtonItem(title: self.lang.clrall_Tit, style: UIBarButtonItem.Style.plain, target: self, action: #selector(clearAllSelected))
        navigationItem.rightBarButtonItem = clearAllButton
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Circular Air Pro", size: 15)!]), for: .normal)
    }
    
    @objc func goBack() {
        if !self.localFilter.isEmpty
        {
            SharedVariables.sharedInstance.filterDict = localFilter
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.sharedAppDelegete.makentTabBarCtrler.tabBar.isHidden = false
    }
    
    @objc func clearAllSelected() {
        self.localFilter = SharedVariables.sharedInstance.filterDict
        SharedVariables.sharedInstance.filterDict = [String:Any]()
        
        selectedAmenitiesArray = [String]()
        selectedSpaceTypesArray = [String]()
        selectedServicesArray   = [String]()
        selectedSpaceStylesArray = [String]()
        selectedSpecialFeatureArray = [String]()
        selectedSpaceRulesArray    = [String]()
        selectedActivityArray     = [String]()
        self.spaceTypeCount.text    = ""
        bedCount = Int()
        bedRoomCount = Int()
        bathRoomCount = Int()
        filterMinPrice = Int()
        filterMaxPrice = Int()
        self.eventTypeID = ""
        self.eventTypeName.text = ""
        self.headerTitleArray = [sectionHeader]()
            self.sliderOutlet.selectedMinValue = CGFloat(self.minPrice)
            self.sliderOutlet.selectedMaxValue = CGFloat(self.maxPrice)
            self.sliderOutlet.resignFirstResponder()
            self.sliderOutlet.becomeFirstResponder()
        
        isInstantBookSelected = true
        roomTypeArray = ["\(bedCount) \(self.lang.bedd_Title)", "\(bedRoomCount) \(self.lang.beddrm_Title)", "\(bathRoomCount) \(self.lang.capbath_Title)"]
        instantBookSelected()
        filterTableView.reloadData()
        
        self.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // navigationCustom()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("FilterViewController")
        sliderOutlet.delegate = self
        self.navigationCustom()
        saveButtonOutlet.appHostSideBtnBG()
        instantBookSwitchView.clipsToBounds = true
        instantBookSwitchView.layer.cornerRadius = instantBookSwitchView.frame.size.height / 2
        
        instantBookStatusLabel.text = ""
        instantBookStatusLabel.backgroundColor = UIColor.appGuestThemeColor
        
        let instantBookTapped:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.instantBookSelected))
        instantBookSwitchView.addGestureRecognizer(instantBookTapped)
        
        let roomTypeTapped:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.roomTypeSelected))
        roomTypeView.addGestureRecognizer(roomTypeTapped)
        
        let eventTypeTapped:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.eventTypeSelected))
        
        eventTypeView.addGestureRecognizer(eventTypeTapped)
        
        if (1...15).contains(bedCount)
        {
            bedTit = "+ " + "\(self.lang.capbed_Title)"
        }
        else
        {
            if bedCount == 16
            {
                bedTit = self.lang.capbed_Title
            }
            else
            {
                bedTit = self.lang.bedd_Title
            }
        }
        
        if (1...10).contains(bedRoomCount){
            bedroomTit = "+ " + "\(self.lang.beddrms_Title)"
        }else{
            bedroomTit = self.lang.beddrm_Title
        }
        if (1...8).contains(bathRoomCount){
            bathTit = "+ " + "\(self.lang.baths_Tit)"
        }else{
            bathTit =  self.lang.capbath_Title
        }
        
        roomTypeArray = ["\(bedCount) \(bedTit)", "\(bedRoomCount) \(bedroomTit)", "\(bathRoomCount) \(bathTit)"]
        sliderOutlet.delegate = self
        sliderOutlet.minValue = CGFloat(minPrice)
        sliderOutlet.maxValue = CGFloat(maxPrice)
        let minPriceValue = Int(minPrice)
        maxPriceValue = Int(maxPrice)
       self.updatePrice(minPriceValue, maxPriceValue)
        filterTableView.reloadData()
        // Do any additional setup after loading the view.
        self.updateData()
    }
    
    func updatePrice(_ minPrice:Int, _ maxPrice:Int) {
        let currency = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL) as String

        if  Language.arabic.isRTL {
            if maxPriceValue == maxPrice {
                self.filterLimitValueLabel.text = "+\(maxPrice)\(currency) - \(minPrice)\(currency)"
            }else {
                self.filterLimitValueLabel.text = "\(maxPrice)\(currency) - \(minPrice)\(currency)"
            }
        }else {
            if maxPriceValue == maxPrice {
                self.filterLimitValueLabel.text = "\(currency)\(minPrice) - \(currency)\(maxPrice)+"
            }else {
                self.filterLimitValueLabel.text = "\(currency)\(minPrice) - \(currency)\(maxPrice)"
            }
        }
        sliderOutlet.selectedMinValue = CGFloat(minPrice)
        sliderOutlet.selectedMaxValue = CGFloat(maxPrice)
        rangeView.reloadInputViews()
        rangeView.reloadWithoutAnimation()
    }
    
    func setPreviousValues() {
        print("set previous values")
        var filterRestoreDict = [String:Any]()
        filterRestoreDict = SharedVariables.sharedInstance.filterDict
        print("FilterDict",SharedVariables.sharedInstance.filterDict)
        print("MaxPrice",filterRestoreDict.int("FilterMinPrice"))
        print("MinPrice",filterRestoreDict.int("FilterMaxPrice"))
        print("filterRestoreDict",filterRestoreDict["AmenitiesListDictArray"]!)
        print("AmenitiesListDictArray",self.amenitiesListDictArray.count)
       
        if self.eventTypeID.count == 0 {
            self.eventTypeID = filterRestoreDict["EventID"] as! String
        }
        
        
        if filterRestoreDict["AmenitiesListDictArray"] != nil
        {
            for item in filterRestoreDict["AmenitiesListDictArray"] as! [AnyObject] {
                //Do stuff
                selectedAmenitiesArray.append(item as! String)
            }
            print("selectedAmenitiesArray",selectedAmenitiesArray.count)
        }
        
        if filterRestoreDict["serviceEventArray"] != nil
        {
            for item in filterRestoreDict["serviceEventArray"] as! [AnyObject]
            {
                //Do stuff
                selectedActivityArray.append(item as! String)
            }
            print("serviceEventArray",selectedAmenitiesArray.count)
            
            for i in 0..<self.activityListDictArray.count
               {
               print("activityListDictArray",String(describing: self.activityListDictArray[i]["id"]!))
                if !selectedActivityArray.isEmpty
                {
                    if String(describing: self.activityListDictArray[i]["id"]!) == selectedActivityArray[0]
                    {
                     print("if conditions success")
                     self.eventTypeName.text = String(describing: self.activityListDictArray[i]["name"]!)
                    }
                    else
                    {
                       print("else conditions")
                    }
                }
            }
        
        }
       // self.selectedSpaceTypesArray.removeAll()
        
        if filterRestoreDict["spaceTypesListDictArray"] != nil
        {
            for item in filterRestoreDict["spaceTypesListDictArray"] as! [AnyObject] {
                //Do stuff
                selectedSpaceTypesArray.append(item as! String)
            }
            if self.selectedSpaceTypesArray.count > 0
            {
                self.spaceTypeCount.text = String(self.selectedSpaceTypesArray.count)
            }
            else
            {
                self.spaceTypeCount.text = ""
            }
        }

        if filterRestoreDict["spaceStylesListDictArray"] != nil
               {
                   for item in filterRestoreDict["spaceStylesListDictArray"] as! [AnyObject] {
                       //Do stuff
                       selectedSpaceStylesArray.append(item as! String)
                   }
               }
        if filterRestoreDict["spaceRulesListDictArray"] != nil
        {
            for item in filterRestoreDict["spaceRulesListDictArray"] as! [AnyObject] {
                //Do stuff
                selectedSpaceRulesArray.append(item as! String)
            }
           
        }
        if filterRestoreDict["specialFeatureListDictArray"] != nil
        {
            for item in filterRestoreDict["specialFeatureListDictArray"] as! [AnyObject] {
                //Do stuff
                selectedSpecialFeatureArray.append(item as! String)
            }
        }
        if filterRestoreDict["servicesListDictArray"] != nil
        {
            for item in filterRestoreDict["servicesListDictArray"] as! [AnyObject] {
                //Do stuff
                selectedServicesArray.append(item as! String)
            }
        }
        print("selectedAmenitiesArray",self.selectedAmenitiesArray.count)
        if (filterMinPrice != 0 && filterMinPrice != minPrice)
        {
            sliderOutlet.selectedMinValue = CGFloat(filterMinPrice)
        }
        else
        {
            self.filterMinPrice = self.minPrice
            sliderOutlet.selectedMinValue = CGFloat(minPrice)
        }
        if (filterMaxPrice != 0 && filterMaxPrice != maxPrice)
        {
            sliderOutlet.selectedMaxValue = CGFloat(filterMaxPrice)
        }
        else
        {
            filterMaxPrice = maxPrice
            sliderOutlet.selectedMaxValue = CGFloat(maxPrice)
        }
        self.view.setNeedsDisplay()
        let min = filterRestoreDict.int("FilterMinPrice")
        let max = filterRestoreDict.int("FilterMaxPrice")
        if filterRestoreDict.int("FilterMinPrice") != 0 && filterRestoreDict.int("FilterMaxPrice") != 0{
        self.updatePrice(min, max)
            self.filterMinPrice = min
            self.filterMaxPrice = max
        }
        isInstantBookSelected = !(filterRestoreDict["InstantBook"] as? Bool ?? Bool())
        
        if (1...15).contains(bedCount){
            bedTit = "+ " + "\(self.lang.capbed_Title)"
        }else{
            if bedCount == 16{
                bedTit = self.lang.capbed_Title
            }else{
                bedTit = self.lang.bedd_Title
            }
        }
        
        if (1...10).contains(bedRoomCount){
            bedroomTit = "+ " + "\(self.lang.beddrms_Title)"
        }else{
            bedroomTit = self.lang.beddrm_Title
        }
        if (1...8).contains(bathRoomCount){
            bathTit = "+ " + "\(self.lang.baths_Tit)"
        }else{
            bathTit =  self.lang.capbath_Title
        }
        roomTypeArray = ["\(bedCount) \(bedTit)", "\(bedRoomCount) \(bedroomTit)", "\(bathRoomCount) \(bathTit)"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.instantBookSelected()
        }
        filterTableView.reloadData()
    }
    
    func wsToGetAmenitiesList() {

        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "search_filters", paramDict: [String:Any](), viewController: self, isToShowProgress: true, isToStopInteraction: true, complete: { (filterResponse) in
            print("Filter Array",filterResponse)
            print("success code",filterResponse["status_code"] as! String)
            if (filterResponse["status_code"] as! String) == "2" {
                Utilities.showAlertMessage(message: (filterResponse["success_message"] as! String), onView: self)
            }
            else if (filterResponse["status_code"] as! String) == "1" {

                print("headertitle",self.headerTitleArray)
                self.amenitiesListDictArray      = filterResponse["amenities"] as? [[String:Any]] ?? [[String:Any]]()
                self.spaceTypesListDictArray     = filterResponse["space_types"] as? [[String:Any]] ?? [[String:Any]]()
                self.servicesListDictArray       = filterResponse["services"] as? [[String:Any]] ?? [[String:Any]]()
                self.spaceStylesListDictArray    = filterResponse["space_styles"] as? [[String:Any]] ?? [[String:Any]]()
                self.specialFeatureListDictArray = filterResponse["special_features"] as? [[String:Any]] ?? [[String:Any]]()
                self.spaceRulesListDictArray     = filterResponse["space_rules"] as? [[String:Any]] ?? [[String:Any]]()
                self.activityListDictArray       = filterResponse["activities"] as? [[String:Any]] ?? [[String:Any]]()
                
                print("activityListArray",self.activityListDictArray)
                

                if !self.amenitiesListDictArray.isEmpty {
                    self.headerTitleArray.append(.amenities)
                }
                 if !self.servicesListDictArray.isEmpty
                {
                    self.headerTitleArray.append(.service)
                }
                 if !self.spaceStylesListDictArray.isEmpty
                {
                    self.headerTitleArray.append(.spaceStyle)
                }
                 if !self.specialFeatureListDictArray.isEmpty
                {
                    self.headerTitleArray.append(.specialFeatures)
                }
                 if !self.spaceRulesListDictArray.isEmpty
                {
                    self.headerTitleArray.append(.spaceRules)
                }
                
                print("amenitiesListArray",self.amenitiesListDictArray)
                print("space_types",self.amenitiesListDictArray)
                print("services",self.amenitiesListDictArray)
                print("space_styles",self.amenitiesListDictArray)
                print("special_features",self.amenitiesListDictArray)
                print("space_rules",self.amenitiesListDictArray)
                self.filterTableView.reloadData()
                
                let minPriceValue = Int(self.minPrice)
                self.maxPriceValue = Int(self.maxPrice)
                if SharedVariables.sharedInstance.filterDict.count > 0
                        {
                            print("previous values not zero")
                                self.setPreviousValues()
                        }
                        else
                        {
                             print("previous values zero")
                            self.sliderOutlet.selectedMinValue = CGFloat(self.minPrice)
                            self.sliderOutlet.selectedMaxValue = CGFloat(self.maxPrice)
                            self.updatePrice(minPriceValue, self.maxPriceValue)
                            
                            
                            
                            if self.eventTypeID != ""
                            {
                                self.selectedActivityArray.append(self.eventTypeID)
                            }
                            for activity in self.activityListDictArray {
                                if (activity["id"] as! Int) == (self.eventTypeID as NSString).intValue {
                                    self.eventTypeName.text = activity["name"] as? String
                                }
                            }
                        }
            }
            else
            {
                Utilities.showAlertMessage(message: (filterResponse["success_message"] as! String), onView: self)
            }
        })
    }
    
    func updateData() {
        print("headertitle",self.headerTitleArray)
        self.amenitiesListDictArray      = self.filterResponse["amenities"] as? [[String:Any]] ?? [[String:Any]]()
        self.spaceTypesListDictArray     = self.filterResponse["space_types"] as? [[String:Any]] ?? [[String:Any]]()
        self.servicesListDictArray       = self.filterResponse["services"] as? [[String:Any]] ?? [[String:Any]]()
        self.spaceStylesListDictArray    = self.filterResponse["space_styles"] as? [[String:Any]] ?? [[String:Any]]()
        self.specialFeatureListDictArray = self.filterResponse["special_features"] as? [[String:Any]] ?? [[String:Any]]()
        self.spaceRulesListDictArray     = self.filterResponse["space_rules"] as? [[String:Any]] ?? [[String:Any]]()
        self.activityListDictArray       = self.filterResponse["activities"] as? [[String:Any]] ?? [[String:Any]]()
        
        print("activityListArray",self.activityListDictArray)
        

        if !self.amenitiesListDictArray.isEmpty {
            self.headerTitleArray.append(.amenities)
        }
         if !self.servicesListDictArray.isEmpty
        {
            self.headerTitleArray.append(.service)
        }
         if !self.spaceStylesListDictArray.isEmpty
        {
            self.headerTitleArray.append(.spaceStyle)
        }
         if !self.specialFeatureListDictArray.isEmpty
        {
            self.headerTitleArray.append(.specialFeatures)
        }
         if !self.spaceRulesListDictArray.isEmpty
        {
            self.headerTitleArray.append(.spaceRules)
        }
        
        print("amenitiesListArray",self.amenitiesListDictArray)
        print("space_types",self.amenitiesListDictArray)
        print("services",self.amenitiesListDictArray)
        print("space_styles",self.amenitiesListDictArray)
        print("special_features",self.amenitiesListDictArray)
        print("space_rules",self.amenitiesListDictArray)
        self.filterTableView.reloadData()
        
        let minPriceValue = Int(self.minPrice)
        self.maxPriceValue = Int(self.maxPrice)
        if SharedVariables.sharedInstance.filterDict.count > 0
                {
                    print("previous values not zero")
                        self.setPreviousValues()
                }
                else
                {
                     print("previous values zero")
                    self.sliderOutlet.selectedMinValue = CGFloat(self.minPrice)
                    self.sliderOutlet.selectedMaxValue = CGFloat(self.maxPrice)
                    self.updatePrice(minPriceValue, self.maxPriceValue)
                    
                    if self.eventTypeID != ""
                    {
                        self.selectedActivityArray.append(self.eventTypeID)
                    }
                    for activity in self.activityListDictArray {
                        if (activity["id"] as! Int) == (self.eventTypeID as NSString).intValue {
                            self.eventTypeName.text = activity["name"] as? String
                        }
                    }
                    
                }
    }
    
    enum sectionHeader: String
    {
        //case spaceType       =  "space_types"
        case amenities       =  "Amenities"
        case service         =  "Services"
        case spaceStyle      =  "Space Styles"
        case specialFeatures =  "Special Features"
        case spaceRules      =  "Space Rules"
    }
    
    @objc func instantBookSelected() {
        
        if !isInstantBookSelected
        {
            if self.rawVal == "ar"{
                makeProgressAnimaiton(percentage:2)
            }else{
                makeProgressAnimaiton(percentage:16)
            }
            isInstantBookSelected = true
            instantBookStatusLabel.font = UIFont (name: Fonts.MAKENT_LOGO_FONT2, size: 10)!
            
            //            instantBookStatusLabel.setTitle("9", for: .normal)
            instantBookStatusLabel.backgroundColor = UIColor.appGuestThemeColor
            instantBookStatusLabel.text = "9"
            
            instantBookStatusLabel.textColor = UIColor.white
        }
        else
        {
            // btnPets.setImage(UIImage(named:"beds.png"), for: UIControlState.normal)
            if self.rawVal == "ar"{
                makeProgressAnimaiton(percentage:16)
            }else{
                makeProgressAnimaiton(percentage:2)
            }
            
            isInstantBookSelected = false
            //            instantBookStatusLabel.backgroundColor = UIColor.clear
            instantBookStatusLabel.text = ""
            //            instantBookStatusLabel.setTitle("", for: .selected)
        }
        //        isResetTapped = false
    }
    
    @objc func roomTypeSelected() {

        print("call the roomTyped")
        
        /// changed at 12/10/2019 by murugeswari
        let viewAmenities = k_MakentStoryboard.instantiateViewController(withIdentifier: "FilterAmenities") as! FilterAmenities
        //arrSelectedAmenities =  removeDuplicates(array: arrSelectedAmenities.mutableCopy() as! [String]) as NSArray
        print("selectedspaceTypeArray",selectedSpaceTypesArray)
        viewAmenities.arrAmenitiesData = spaceTypesListDictArray as NSArray
        viewAmenities.arrSelectedItems =  NSMutableArray(array: selectedSpaceTypesArray)
        viewAmenities.filterTitle = "Space Type"
        viewAmenities.delegate = self
        present(viewAmenities, animated: true, completion: nil)
    }
    
    @objc func eventTypeSelected() {
        /// changed at 12/10/2019 by murugeswari
        let viewAmenities = k_MakentStoryboard.instantiateViewController(withIdentifier: "FilterAmenities") as! FilterAmenities
        //arrSelectedAmenities =  removeDuplicates(array: arrSelectedAmenities.mutableCopy() as! [String]) as NSArray
        viewAmenities.arrAmenitiesData = activityListDictArray as NSArray
        viewAmenities.arrSelectedItems =  NSMutableArray(array: selectedActivityArray)
        viewAmenities.filterTitle = "Event Type"
        viewAmenities.delegate = self
        present(viewAmenities, animated: true, completion: nil)
    }
    
    // MARK:- Button Actions
    
    @IBAction func saveButtonAction(_ sender: Any) {
        var filterCount = Int()
        if isInstantBookSelected
        {
            filterCount += 1
        }
        if (filterMinPrice > 0 && filterMinPrice != minPrice) || (filterMaxPrice > 0 && filterMaxPrice != maxPrice)
        {
            filterCount += 1
        }
        filterCount += selectedAmenitiesArray.count
       // filterCount += selectedRoomTypeArray.count
        filterCount += selectedSpaceTypesArray.count
        filterCount += selectedSpaceRulesArray.count
        filterCount += selectedSpecialFeatureArray.count
        filterCount += selectedSpaceStylesArray.count
        filterCount += selectedServicesArray.count
        
        if self.eventTypeID != ""
        {
            filterCount += 1
        }
        
         var filterRestoreDict = [String:Any]()
         filterRestoreDict["AmenitiesListDictArray"] = selectedAmenitiesArray
         filterRestoreDict["spaceTypesListDictArray"] = selectedSpaceTypesArray
         filterRestoreDict["spaceRulesListDictArray"] = selectedSpaceRulesArray
         filterRestoreDict["spaceStylesListDictArray"] =  selectedSpaceStylesArray
         filterRestoreDict["specialFeatureListDictArray"] = selectedSpecialFeatureArray
         filterRestoreDict["servicesListDictArray"] = selectedServicesArray
         filterRestoreDict["serviceEventArray"] = selectedActivityArray
         
        filterRestoreDict["FilterMinPrice"] = filterMinPrice == 0 ? self.minPrice : filterMinPrice
        filterRestoreDict["FilterMaxPrice"] = filterMaxPrice == 0 ? self.maxPrice : filterMaxPrice
        
        filterRestoreDict["InstantBook"] = isInstantBookSelected
        filterRestoreDict["EventID"] = self.eventTypeID
        
        if filterCount > 0 {
            SharedVariables.sharedInstance.filterDict = filterRestoreDict
        }
        else {
            SharedVariables.sharedInstance.filterDict = [String:Any]()
        }
        
        
        print("DictVal:",filterRestoreDict)
        print("StorePreviousVal",SharedVariables.sharedInstance.filterDict)
        self.localFilter.removeAll()
        
        var filterParamDict = [String:Any]()
        if isInstantBookSelected
        {
            filterParamDict["instant_book"] = "1"
        }
        else
        {
            filterParamDict["instant_book"] = "0"
        }
        
        filterParamDict["amenities"] = selectedAmenitiesArray.joined(separator: ",")
        filterParamDict["page"] = "1"
        //filterParamDict["space_type"] = selectedSpaceTypesArray.joined(separator: ",")
        filterParamDict["services"] = selectedServicesArray.joined(separator: ",")
        filterParamDict["space_style"] = selectedSpaceStylesArray.joined(separator: ",")
        filterParamDict["special_feature"] = selectedSpecialFeatureArray.joined(separator: ",")
        filterParamDict["space_rules"] = selectedSpaceRulesArray.joined(separator: ",")

        filterParamDict["min_price"] = "\(filterMinPrice)"
        filterParamDict["max_price"] = "\(filterMaxPrice)"
        filterParamDict["space_type"] = selectedSpaceTypesArray.joined(separator: ",")
//      filterParamDict["beds"] = bedCount
//      filterParamDict["bedrooms"] = bedRoomCount
//      filterParamDict["bathrooms"] = bathRoomCount
        filterParamDict["FilterCount"] = filterCount
        if !selectedActivityArray.isEmpty
        {
             filterParamDict["activity_type"] = selectedActivityArray[0]
        }
        else {
            filterParamDict["activity_type"] = ""
        }
        self.dismiss(animated: true, completion: nil)
        newFilterDelegate?.didSelectFilterOptions(filterDict: filterParamDict)
        

        
    }
    
    // MARK: Setting Progress value and Animation
    func makeProgressAnimaiton(percentage:Int)
    {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
            
            var rectEmailView = self.instantBookStatusLabel.frame
            if percentage==2
            {
                rectEmailView.origin.x =  0
            }
            else
            {
                rectEmailView.origin.x = self.instantBookSwitchView.frame.size.width - self.instantBookStatusLabel.frame.size.width
            }
            self.instantBookStatusLabel.frame = rectEmailView
            
        }, completion: { (finished: Bool) -> Void in
            
            self.instantBookStatusLabel.backgroundColor = UIColor.appGuestThemeColor
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitleArray[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if amenitiesListDictArray.count > 0 {
            if amenitiesListDictArray.count >= 4 {
                return 5
            }
            return amenitiesListDictArray.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterOptionsTVC") as! FilterOptionsTVC
        cell.optionValueLabel.isHidden = true
        cell.optionTitleLabel.text = self.lang.amenit_Tit
        cell.checkBoxImageView.tintColor = UIColor.appGuestThemeColor
        cell.optionTitleLabel.font = UIFont(name: "CircularAirPro-Book", size: 16)
        cell.checkBoxImageView.image = unCheckedImage
        
        cell.checkBoxImageView.isHidden = false
        let sectionTitle = headerTitleArray[indexPath.section]

        if indexPath.row < 4 {
            if sectionTitle == .amenities
            {
                cell.optionTitleLabel.text = amenitiesListDictArray[indexPath.row]["name"] as? String ?? ""
                if selectedAmenitiesArray.contains("\(amenitiesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                    cell.checkBoxImageView.image = checkedImage
                }
            }

            else if sectionTitle == .spaceStyle
            {
                
                cell.optionTitleLabel.text = spaceStylesListDictArray[indexPath.row]["name"] as? String ?? ""
                if selectedSpaceStylesArray.contains("\(spaceStylesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                    cell.checkBoxImageView.image = checkedImage
                }
                
            }
                
            else if sectionTitle == .spaceRules
            {
                cell.optionTitleLabel.text = spaceRulesListDictArray[indexPath.row]["name"] as? String ?? ""
                if selectedSpaceRulesArray.contains("\(spaceRulesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                    cell.checkBoxImageView.image = checkedImage
                }
            }
                
            else if sectionTitle == .specialFeatures
            {
                cell.optionTitleLabel.text = specialFeatureListDictArray[indexPath.row]["name"] as? String ?? ""
                if selectedSpecialFeatureArray.contains("\(specialFeatureListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                    cell.checkBoxImageView.image = checkedImage
                }
            }
            else if sectionTitle == .service
            {
                cell.optionTitleLabel.text = servicesListDictArray[indexPath.row]["name"] as? String ?? ""
                if selectedServicesArray.contains("\(servicesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                    cell.checkBoxImageView.image = checkedImage
                }
            }
        }
        else {
            //cell.optionTitleLabel.text = self.lang.seeall_Ameniti
            cell.optionTitleLabel.text = "see all" + " " + sectionTitle.rawValue
            cell.optionTitleLabel.font = UIFont(name: Fonts.CIRCULAR_LIGHT, size: 15)
            cell.checkBoxImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var sectionTitle = headerTitleArray[indexPath.section]
        
            if sectionTitle == .amenities
            {
                
                if indexPath.row < 4 {
                    
                    if selectedAmenitiesArray.contains("\(amenitiesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                        for i in 0 ..< selectedAmenitiesArray.count {
                            if selectedAmenitiesArray[i] == "\(amenitiesListDictArray[indexPath.row]["id"] as? Int ?? Int())" {
                                selectedAmenitiesArray.remove(at: i)
                                break
                            }
                        }
                    }
                    else {
                        selectedAmenitiesArray.append("\(amenitiesListDictArray[indexPath.row]["id"] as? Int ?? Int())")
                    }
                    UIView.performWithoutAnimation {
                        // UIView.setAnimationsEnabled(false)
                        tableView.beginUpdates()
                        //self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.none)
                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                        tableView.endUpdates()
                        //UIView.setAnimationsEnabled(true)
                    }
                }
                else {
                    let viewAmenities = k_MakentStoryboard.instantiateViewController(withIdentifier: "FilterAmenities") as! FilterAmenities
                    viewAmenities.arrAmenitiesData = amenitiesListDictArray as NSArray
                    viewAmenities.arrSelectedItems =  NSMutableArray(array: selectedAmenitiesArray)
                    viewAmenities.filterTitle = sectionTitle.rawValue
                    viewAmenities.delegate = self
                    present(viewAmenities, animated: true, completion: nil)
                }
                
            }
                

                
            else if sectionTitle == .spaceStyle
            {
                
                if indexPath.row < 4 {
                    
                    if selectedSpaceStylesArray.contains("\(spaceStylesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                        for i in 0 ..< selectedSpaceStylesArray.count {
                            if selectedSpaceStylesArray[i] == "\(spaceStylesListDictArray[indexPath.row]["id"] as? Int ?? Int())" {
                                selectedSpaceStylesArray.remove(at: i)
                                break
                            }
                        }
                    }
                    else {
                        selectedSpaceStylesArray.append("\(spaceStylesListDictArray[indexPath.row]["id"] as? Int ?? Int())")
                    }
                    UIView.performWithoutAnimation {
                        tableView.beginUpdates()
                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                        tableView.endUpdates()
                    }
                }
                else {
                    let viewAmenities = k_MakentStoryboard.instantiateViewController(withIdentifier: "FilterAmenities") as! FilterAmenities
                    //                arrSelectedAmenities =  removeDuplicates(array: arrSelectedAmenities.mutableCopy() as! [String]) as NSArray
                    viewAmenities.arrAmenitiesData = spaceStylesListDictArray as NSArray
                    viewAmenities.filterTitle = sectionTitle.rawValue
                    viewAmenities.arrSelectedItems =  NSMutableArray(array: selectedSpaceStylesArray)
                    viewAmenities.delegate = self
                    present(viewAmenities, animated: true, completion: nil)
                }
            }
                
            else if sectionTitle == .spaceRules
            {
                if indexPath.row < 4 {
                    
                    if selectedSpaceRulesArray.contains("\(spaceRulesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                        for i in 0 ..< selectedSpaceRulesArray.count {
                            if selectedSpaceRulesArray[i] == "\(spaceRulesListDictArray[indexPath.row]["id"] as? Int ?? Int())" {
                                selectedSpaceRulesArray.remove(at: i)
                                break
                            }
                        }
                    }
                    else {
                        selectedSpaceRulesArray.append("\(spaceRulesListDictArray[indexPath.row]["id"] as? Int ?? Int())")
                    }
                    UIView.performWithoutAnimation {
                        tableView.beginUpdates()
                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                        tableView.endUpdates()
                    }
                }
                else {
                    let viewAmenities = k_MakentStoryboard.instantiateViewController(withIdentifier: "FilterAmenities") as! FilterAmenities
                    //                arrSelectedAmenities =  removeDuplicates(array: arrSelectedAmenities.mutableCopy() as! [String]) as NSArray
                    viewAmenities.arrAmenitiesData = spaceRulesListDictArray as NSArray
                    viewAmenities.arrSelectedItems =  NSMutableArray(array: selectedSpaceRulesArray)
                    viewAmenities.delegate = self
                    viewAmenities.filterTitle = sectionTitle.rawValue
                    present(viewAmenities, animated: true, completion: nil)
                }
            }
                
            else if sectionTitle == .specialFeatures
            {
                
                if indexPath.row < 4 {
                    
                    if selectedSpecialFeatureArray.contains("\(specialFeatureListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                        for i in 0 ..< selectedSpecialFeatureArray.count {
                            if selectedSpecialFeatureArray[i] == "\(specialFeatureListDictArray[indexPath.row]["id"] as? Int ?? Int())" {
                                selectedSpecialFeatureArray.remove(at: i)
                                break
                            }
                        }
                    }
                    else {
                        selectedSpecialFeatureArray.append("\(specialFeatureListDictArray[indexPath.row]["id"] as? Int ?? Int())")
                    }
                    UIView.performWithoutAnimation {
                        tableView.beginUpdates()
                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                        tableView.endUpdates()
                    }
                }
                else {
                    let viewAmenities = k_MakentStoryboard.instantiateViewController(withIdentifier: "FilterAmenities") as! FilterAmenities
                    viewAmenities.arrAmenitiesData = specialFeatureListDictArray as NSArray
                    viewAmenities.arrSelectedItems =  NSMutableArray(array: selectedSpecialFeatureArray)
                    viewAmenities.filterTitle = sectionTitle.rawValue
                    viewAmenities.delegate = self
                    present(viewAmenities, animated: true, completion: nil)
                }
            }
                
            else if sectionTitle == .service
            {
                if indexPath.row < 4 {
                    
                    if selectedServicesArray.contains("\(servicesListDictArray[indexPath.row]["id"] as? Int ?? Int())") {
                        for i in 0 ..< selectedServicesArray.count {
                            if selectedServicesArray[i] == "\(servicesListDictArray[indexPath.row]["id"] as? Int ?? Int())" {
                                selectedServicesArray.remove(at: i)
                                break
                            }
                        }
                    }
                    else {
                        selectedServicesArray.append("\(servicesListDictArray[indexPath.row]["id"] as? Int ?? Int())")
                    }
                    UIView.performWithoutAnimation {
                        tableView.beginUpdates()
                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                        tableView.endUpdates()
                    }
                }
                else {
                    let viewAmenities = k_MakentStoryboard.instantiateViewController(withIdentifier: "FilterAmenities") as! FilterAmenities
                    //                arrSelectedAmenities =  removeDuplicates(array: arrSelectedAmenities.mutableCopy() as! [String]) as NSArray
                    viewAmenities.arrAmenitiesData = servicesListDictArray as NSArray
                    viewAmenities.filterTitle = sectionTitle.rawValue
                    viewAmenities.arrSelectedItems =  NSMutableArray(array: selectedServicesArray)
                    viewAmenities.delegate = self
                    present(viewAmenities, animated: true, completion: nil)
                }
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    @IBAction func roomTypeAddAction(_ sender: Any) {
        let cell = (sender as! UIButton).superview?.superview as! RoomTypeTVC
        print(cell)
        
        let indexPath = filterTableView.indexPath(for: cell)
        
        print("ValuesCount:",bedCount,bedRoomCount, bathRoomCount)
        
        let tag = cell.plusButtonOutlet.tag
        
        switch tag {
        case 0:
            if (0...16).contains(bedCount + 1)
            {
                bedCount += 1
            }
        case 1:
            if (0...10).contains(bedRoomCount + 1)
            {
                bedRoomCount += 1
            }
        case 2:
            if (0...8).contains(bathRoomCount + 1)
            {
                bathRoomCount += 1
            }
        default:
            print("Default")
        }
        self.setRoomCount()
        UIView.performWithoutAnimation {
            filterTableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.none)
        }
    }
    
    func setRoomCount() {
        //MARK: BEDS COUNT INCREASE
        if (1...15).contains(bedCount){
            bedTit = "+ " + "\(self.lang.capbed_Title)"
        }else{
            bedTit = bedCount == 16 ? " \(self.lang.capbed_Title)" : " \(self.lang.bedd_Title)"
        }
        //MARK: BEDROOMS COUNT INCREASE
        if (1...10).contains(bedRoomCount){
            bedroomTit = "+ " + "\(self.lang.beddrms_Title)"
        }else{
            bedroomTit = bedRoomCount == 10 ? " \(self.lang.beddrms_Title)" : " \(self.lang.beddrm_Title)"
        }
        
        //MARK: BATHROOMS COUNT INCREASE
        if (1...8).contains(bathRoomCount){
            bathTit = "+ " + "\(self.lang.baths_Tit)"
        }else{
            bathTit =  bathRoomCount == 8 ? " \(self.lang.baths_Tit)" : " \(self.lang.capbath_Title)"
        }
        roomTypeArray = ["\(bedCount)\(bedTit)", "\(bedRoomCount)\(bedroomTit)", "\(bathRoomCount)\(bathTit)"]
    }
    
    @IBAction func roomTypeMinusAction(_ sender: Any) {
        
        let cell = (sender as! UIButton).superview?.superview as! RoomTypeTVC
        print(cell)
        
        let indexPath = filterTableView.indexPath(for: cell)
        
        let tag = cell.minusButtonOutlet.tag
        
        switch tag {
        case 0:
            if (0...16).contains(bedCount - 1){
                bedCount -= 1
            }
        case 1:
            if (0...10).contains(bedRoomCount - 1){
                bedRoomCount -= 1
            }
        case 2:
            if (0...8).contains(bathRoomCount - 1){
                bathRoomCount -= 1
            }
        default:
            print("Default")
        }
        self.setRoomCount()
        UIView.performWithoutAnimation {
             filterTableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.none)
        }
       
    }
    
    //MARK:- Range Slider Delegate
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === sliderOutlet {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        }
        
        print("˜max",sliderOutlet.minDistance)
        print("µmin",sliderOutlet.maxDistance)
        
        filterMinPrice = Int(minValue)
        filterMaxPrice = Int(maxValue)
        self.updatePrice(filterMinPrice, filterMaxPrice)
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
    
    //MARK:- Filter Delegate
    
    func onFilterAmenitiesAdded(index: NSArray, filterTitle : String)
    {
        print("Filter selection button action", filterTitle)
        
        if filterTitle == "Event Type"
        {
            selectedActivityArray = index as! [String]
            for i in 0..<self.activityListDictArray.count
             {
             print("activityListDictArray",String(describing: self.activityListDictArray[i]["id"]!))
             if String(describing: self.activityListDictArray[i]["id"]!) == selectedActivityArray[0]
             {
              print("if conditions success")
              self.eventTypeName.text = String(describing: self.activityListDictArray[i]["name"]!)
             }
             else
             {
                print("else conditions")
             }
          }
        }
        
        if filterTitle == "Space Type"
        {
            selectedSpaceTypesArray = index as! [String]
            print("selectedSpaceTypesArray",self.selectedSpaceTypesArray.count)
            UIView.performWithoutAnimation {
                filterTableView.reloadData()
            }
            if self.selectedSpaceTypesArray.count > 0
            {
                self.spaceTypeCount.text = String(self.selectedSpaceTypesArray.count)
            }
            else
            {
                self.spaceTypeCount.text = ""
            }
        }
        
        if filterTitle == "Amenities"
        {
            selectedAmenitiesArray = index as! [String]
            UIView.performWithoutAnimation {
                filterTableView.reloadData()
            }
        }
        else if filterTitle == "Services"
        {
            selectedServicesArray = index as! [String]
            UIView.performWithoutAnimation {
                filterTableView.reloadData()
            }
        }
        else if filterTitle == "Space Styles"
        {
            selectedSpaceStylesArray = index as! [String]
            UIView.performWithoutAnimation {
                filterTableView.reloadData()
            }
        }
        
        else if filterTitle == "Special Features"
        {
            selectedSpecialFeatureArray = index as! [String]
            UIView.performWithoutAnimation {
                filterTableView.reloadData()
            }
        }
        
        else if filterTitle == "Space Rules"
        {
            selectedSpaceRulesArray = index as! [String]
            UIView.performWithoutAnimation {
                filterTableView.reloadData()
            }
        }
        else if filterTitle == "Event Type"
        {
            print("Filter Title Received")
        }

    }
    func onFilterRoomTypeAdded(index: NSArray) {
        selectedSpaceTypesArray = index as? [String] ?? [String]()
        print(selectedSpaceTypesArray)
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
extension UIView {
    func isChangeArabicButton() {
        
        if Language.getCurrentLanguage().getSemantic == .forceRightToLeft {
            self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
        }else {
            self.transform = .identity
            
        }
    }
}
