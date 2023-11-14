//
//  HomeViewController.swift
//  Makent
//
//  Created by trioangle on 06/05/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol DynamicHeightCalculable {
    func height(forWidth: CGFloat) -> CGFloat
}
protocol ShowDetailDelegate {
    func didSelectDetailPage(detailDict:Detail)
}

protocol VariantSelectionDelegate {
    func didVariantSelected(_ categoryID: String?)
}
class filterCell : UICollectionViewCell
{
    
    @IBOutlet weak var titleLabel: UILabel!
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
}
class VariantListCVC: UICollectionViewCell {
    
    @IBOutlet weak var variantImageView: UIImageView!
    @IBOutlet weak var variantLabel: UILabel!
    let lang = Language.getCurrentLanguage()
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        variantLabel.textAlignment = lang.getTextAlignment(align: .center)
    }
}

//#Mark Variant TableCell
class HomeVariantTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var variantCollectionView: UICollectionView!
    
    var appDelegate = AppDelegate()
    
    var variantListDictArray = [ExploreCat]()
    
    var variantSelectionDelegate:VariantSelectionDelegate?
    
    var isPreparing : Bool = false
    
    let index = IndexPath(item: 0, section: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
//      variantCollectionView.transform = Language.getCurrentLanguage().getAffine
        print("HomeViewController")
        variantCollectionView.delegate = self
        variantCollectionView.dataSource = self
        if Language.getCurrentLanguage().isRTL{
            self.variantCollectionView.semanticContentAttribute = .forceRightToLeft
            if variantListDictArray.count > 2{
            self.variantCollectionView.scrollToItem(at: index, at: .top, animated: false)
            }
        }
//  variantCollectionView.reloadData()
    }
    
    override func prepareForReuse() {
//        self.isPreparing = true
//        variantCollectionView.reloadData()
        super.prepareForReuse()
        if Language.getCurrentLanguage().isRTL
        {
            self.variantCollectionView.semanticContentAttribute = .forceRightToLeft
            if variantListDictArray.count > 2
            {
                self.variantCollectionView.scrollToItem(at: index, at: .top, animated: false)
            }
        }
        print("∂ resuse : \(self.contentView.frame.height)")
    }
    
    //MARK: - CATEGORY COLLECTION VIEW
    // MARK: - CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      return variantListDictArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "variantListCVC", for: indexPath) as! VariantListCVC
        // cell.setCornerRadius(borderColor: .lightGray, borderWidth: 0.1, cornerRadius: 5)
        cell.variantImageView.addRemoteImage(imageURL: self.variantListDictArray[indexPath.row].image, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: self.variantListDictArray[indexPath.row].image )! as URL, placeholderImage:UIImage(named:""))
        cell.variantLabel.text = variantListDictArray[indexPath.row].name
//        Utilities.sharedInstance.addShadowToView(view: cell, radius: 3.0, ShadowColor: .black, shadowOpacity: 0.3)
        cell.variantImageView.cornerRadius = 3
        cell.cornerRadius = 15
        cell.clipsToBounds = true
        cell.variantImageView.clipsToBounds = true
        cell.layer.cornerRadius = 3.0
        cell.border(0.5, .lightGray)
        cell.elevate(1.5)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select")
        let cell = collectionView.cellForItem(at: indexPath) as! VariantListCVC
        cell.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        cell.isHighlighted = false
        if [HomeType.all,.onFilterSearch]
            .contains(SharedVariables.sharedInstance.homeType)
        {
            print("This is the home type")
            if indexPath.row == 0 {
                SharedVariables.sharedInstance.homeType = HomeType.home
            }
            else if indexPath.row == 1 {
                print("This is experience")
                SharedVariables.sharedInstance.homeType = HomeType.experiance
            }
            self.variantSelectionDelegate?.didVariantSelected(nil)
        }
        else if SharedVariables.sharedInstance.homeType == HomeType.experiance
        {
            
            print("This is the home type with experience")
            SharedVariables.sharedInstance.homeType = HomeType.experianceCategory(self.variantListDictArray[indexPath.item])
            SharedVariables.sharedInstance.categoryName = self.variantListDictArray[indexPath.item].name
            self.variantSelectionDelegate?.didVariantSelected(String(describing: self.variantListDictArray[indexPath.item].id))
        
            cell.layer.cornerRadius = 5.0
        }
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func viewController(responder: UIResponder) -> UIViewController? {
        if let vc = responder as? UIViewController {
            return vc
        }
        if let next = responder.next {
            return viewController(responder: next)
        }
        return nil
    }
}

extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 80.0)
    }
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, AddressPickerDelegate, WWCalendarTimeSelectorProtocol, AddGuestDelegate, VariantSelectionDelegate, NewFilterDelegate, MapFilterValuesDelegate, ShowDetailDelegate, createdWhisListDelegate, addWhisListDelegate {

    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet var headerSearchView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBackButtonOutlet: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var mapFilterView: UIView!
    @IBOutlet weak var searchAndBackImageView: UIImageView!
    
    @IBOutlet weak var mapFilterImageView: UIImageView!
    
    var filterListDictArray = [Detail]()
    var exploreListDictArray = [Detail]()
    var variantListDictArray = [ExploreCat]()
    var experienceCategoryModel = [Detail]()
    var homeListDictArray = [Detail]()
    var filterMinPrice = Int()
    var filterMaxPrice = Int()
    
    var filterTitleArray = [FilterStruct]()
    
    var searchedLocation : LocationModel?
    
    var guestCount = Int()
    var filterCount = Int()
    
    var homeType = String()
    
    var variantSelectionDelegate:VariantSelectionDelegate?
    
    var exploreModelData = [ExploreDataModel]()
    
    var homeModelData = [HomeModel]()
    
    var listVal = [List]()
    var detailVal = [Detail]()
    fileprivate var singleDate: Date = Date()
//    var exploreCategoryModel = [ExperienceCategoryModel]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let langAlignAff = Language.getCurrentLanguage()
    //ExploreDataValueModel
    var exploreDataValueModel = [ExploreDataValueModel]()
    
    var exploreListDataArray = [Any]()
    
    var filterDict = [String : Any]()
    
    var removeFilterButtonOutlet : UIButton = UIButton()
    var roomPageNumber = Int()
    var totalRoomPages = Int()
    var experiencePageNumber = Int()
    var totalExperiencePages = Int()
    var isLoadingMorePages = Bool()
    var selectedCategoryID = String()
    var whishListDict : Detail?
    var isNoHomeData = Bool()
//    var filterDict = String()
    var categoryFilterDict = [String:Any]()
    
    var shouldReloadViewOnAppear = false
    var categoryName: String = ""
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
//              NotificationCenter.default.addObserver(self, selector: #selector(self.didSelectFilterOptions(notification:)), name: NSNotification.Name(rawValue: "FromMapFilter"), object: nil)
        
       // getRoomsAndExperienceList()
        if self.shouldReloadViewOnAppear{
            self.shouldReloadViewOnAppear = false
//            self.homeTableView.reloadData()
            self.getRoomsAndExperienceList()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        filterCollectionView.showsVerticalScrollIndicator = false
        filterCollectionView.showsHorizontalScrollIndicator = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        homeTableView.register(UINib.init(nibName: "HomeTableCommonCell", bundle: nil), forCellReuseIdentifier: "exploreTVC")
        self.initNotifacationsAndGestures()
        self.initForLayout()
        self.reloadWholePage()
        
    }
    
    func reloadWholePage() {
        roomPageNumber = 1
        experiencePageNumber = 1
        
        guestCount = 1
        filterCount = 0
       
        self.setSearchLabelText()
        getRoomsAndExperienceList()
    }
    
    func initForLayout() {
        mapFilterImageView.image = UIImage(named: "mapFilter")?.withRenderingMode(.alwaysTemplate)
        mapFilterImageView.tintColor = UIColor.appGuestThemeColor
        self.mapFilterView.isHidden = false
        self.searchAndBackImageView.transform = langAlignAff.getAffine
        self.sharedAppDelegete.makentTabBarCtrler.tabBar.isHidden = false
        homeTableView.tableFooterView = UIView()
        self.mapFilterView.isHidden = false
        mapFilterView.clipsToBounds = true
        Utilities.sharedInstance.addShadowToMapView(view: mapFilterView, radius: mapFilterView.frame.width/2, ShadowColor: .black, shadowOpacity: 0.15)
        //mapFilterView.layer.cornerRadius = mapFilterView.frame.size.height / 2
//        self.filterCollectionView.reloadData()
        print("FilterTitleArray:",self.filterTitleArray)
        if self.filterTitleArray.count > 0{
            self.filterView.frame.size.height = 54.0
        }else{
            self.filterView.frame.size.height = 0.0
        }
        if Language.getCurrentLanguage().isRTL{
            filterCollectionView.semanticContentAttribute = .forceRightToLeft
        }
        homeTableView.estimatedRowHeight = 44
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.searchBackButtonOutlet.frame.size.width = self.searchBackButtonOutlet.frame.size.height
        }
        
        DispatchQueue.main.async {
            Utilities.sharedInstance.addShadowToSearchView(view: self.searchView, radius: 3.0, shadowRadius: 3.0, ShadowColor: .black, shadowOpacity: 0.6)
        }
    }
    
    func initNotifacationsAndGestures(){
        removeFilterButtonOutlet.addTap {
            print("Remove button actions")
            SharedVariables.sharedInstance.categoryName = ""
            self.setSearchLabelText()
            self.mapFilterView.isHidden = false
            self.filterCount = 0
            self.filterDict = [String:Any]()
            SharedVariables.sharedInstance.filterDict = [String:Any]()
            SharedVariables.sharedInstance.multipleDates.removeAll()
            //SharedVariables.sharedInstance.homeType = .all
            SharedVariables.sharedInstance.homeType = .experiance
            self.guestCount = 0
            self.filterView.frame.size.height = 0.0
            self.filterTitleArray.removeAll()
            self.filterCollectionView.reloadData()
            self.searchedLocation = nil
            Constants().REMOVEVALUE(keyname: "START_TIME")
            Constants().REMOVEVALUE(keyname: "END_TIME")
            self.getRoomsAndExperienceList()
        }
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchBarDidSelected))
        //        searchView.addGestureRecognizer(searchTap)
        searchLabel.addGestureRecognizer(searchTap)
        
        let mapFilterTap = UITapGestureRecognizer(target: self, action: #selector(mapFilterDidSelected))
        mapFilterView.addGestureRecognizer(mapFilterTap)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWhishListForHomeAndExperience), name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "resetWhishList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetWhistList), name: NSNotification.Name(rawValue: "resetWhishList"), object: nil)
   
        _ = PipeLine.createEvent(withName: K_PipeNames.reloadView, action: { [weak self] in
            self?.shouldReloadViewOnAppear = true
        })
    }
    //ToCalculate Dynamic height
    func dynamicHeight(tempModelArray:[Detail]) -> CGFloat{
        var text = ""
        let textArray = tempModelArray.map({$0.name.count})
        if let index = tempModelArray.index(where:{$0.name.count == textArray.max()}){
            text = tempModelArray[index].name
        }
        let customWidth = (self.view.frame.width / 2.0) - 5
        let customHeight = text.heightWithConstrainedWidth(width: customWidth, font: UIFont(name: Fonts.CIRCULAR_BOLD, size: 13.0)!) + customWidth + 5
        
        return customHeight
    }
    
    //Mark:- Getting Datas For Home Page Datas
    func getRoomsAndExperienceList(filterDict: [String:Any] = [String:Any]()) {
        print("getRoomsAndExperienceList")
        if SharedVariables.sharedInstance.homeType == .all{
            self.filterDict = [String:Any]()
            self.searchedLocation = nil
            SharedVariables.sharedInstance.filterDict = self.filterDict
        }
        
        self.filterDict.merge(dict: filterDict)
        var location = String()
        if let givenLocation = isLocationProvided() {
            location = givenLocation
        }
        switch  SharedVariables.sharedInstance.homeType {
        case .all,.onFilterSearch:
            print("callaction","onFilterSearch")
            print("Filter dictionary",self.filterDict)
            //  wsToGetServiceData(location: location, pageNumber: experiencePageNumber, filterDict: self.filterDict)
            wsToGetHomeData(location: location, filterDict: self.filterDict)
        case .showAll:
            print("callaction","showAll")
            wsToGetHomeData(location: location, filterDict: self.filterDict)
        case .home:
            print("callaction","home")
            self.wsToGetExploreData(location: location,
                                    pageNumber: roomPageNumber,
                                    filterParamDict: self.filterDict)
        case .experiance,.experianceCategory:
             print("callaction","experiance")
             print("Filter dictionary",self.filterDict)
            wsToGetServiceData(location: location, pageNumber: experiencePageNumber, filterDict: self.filterDict)
        }
    
    }
    
    func isLocationProvided() -> String?
    {
       if let searchLoc = self.searchedLocation,
          !(searchLoc.searchedAddress?.isEmpty ?? false)
       {
            return searchLoc.searchedAddress
       }
       else
       {
            return nil
       }
    }
    
    //MARK:- Button Actions
    
    @objc func searchBarDidSelected() {
        
        let searchVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        searchVC.delegate = self
        searchVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(searchVC, animated: true, completion: nil)
    }
    
    //Mark:- Map Filter Button Clicked
    @objc func mapFilterDidSelected() {
        print("selected categories Id",self.selectedCategoryID)
        //SharedVariables.sharedInstance.homeType == HomeType.experianceCategory(nil) || SharedVariables.sharedInstance.homeType == HomeType.showAll(nil)
        let mapFilterVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "mapFilterViewController") as! MapFilterViewController
            mapFilterVC.isShowFilterOption = true
        if SharedVariables.sharedInstance.homeType == HomeType.home {
            mapFilterVC.homeListDictArray = homeListDictArray
            mapFilterVC.isRoomSelected = true
        }
        else if SharedVariables.sharedInstance.homeType == HomeType.showAll(nil)
        {
            mapFilterVC.homeListDictArray = exploreListDictArray
            mapFilterVC.isRoomSelected = false
            mapFilterVC.isShowFilterOption = false
        }
        else
        {
            mapFilterVC.homeListDictArray = exploreListDictArray
            mapFilterVC.isRoomSelected = false
            mapFilterVC.categoryFilterDict = categoryFilterDict
        }
        for item in mapFilterVC.homeListDictArray
        {
            print("ø\(item.contentType) : \(item.type)")
        }
        mapFilterVC.hidesBottomBarWhenPushed = true
        mapFilterVC.filterMinPrice = filterMinPrice
        mapFilterVC.filterMaxPrice = filterMaxPrice
        mapFilterVC.filterDict = filterDict
        mapFilterVC.categoryeventTypeID = self.selectedCategoryID
        mapFilterVC.filterDictDelegate = self
        self.navigationController?.pushViewController(mapFilterVC, animated: true)
    }
    
    @IBAction func searchBackButtonAction(_ sender: Any) {
        print("searchBackButton")
        SharedVariables.sharedInstance.categoryName = ""
        if searchAndBackImageView.image == UIImage(named: "search.png") {
            let searchVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            searchVC.delegate = self
            
            self.navigationController?.present(searchVC, animated: true, completion: nil)
            return
        }
        else {
            // MARK:- BB
//            if SharedVariables.sharedInstance.homeType == .experianceCategory(nil){
//                print("search backbutton if")
//                    self.filterCollectionView.isHidden = true
//                    self.homeTableView.restore()
//                    self.filterDict.removeValue(forKey: "activity_type")
//                    self.filterDict.removeAll()
//                    self.filterView.frame.size.height = 0.0
//                    self.filterTitleArray.removeAll()
//
//                    SharedVariables.sharedInstance.homeType = .experiance
//
//            }else{
                print("search backbutton else")
                if SharedVariables.sharedInstance.homeType == .onFilterSearch{
                    self.searchedLocation = nil
                }
                // SharedVariables.sharedInstance.selectedDate = String()
                SharedVariables.sharedInstance.selectedListType = String()
                SharedVariables.sharedInstance.multipleDates = [Date]()
                //SharedVariables.sharedInstance.homeType = HomeType.all
                SharedVariables.sharedInstance.homeType = HomeType.experiance
                SharedVariables.sharedInstance.filterDict = [String:Any]()
            
            
            self.filterCollectionView.isHidden = true
            self.homeTableView.restore()
            self.filterDict.removeValue(forKey: "activity_type")
            self.filterDict.removeAll()
            self.filterView.frame.size.height = 0.0
            self.selectedCategoryID = String()
            self.filterTitleArray.removeAll()
            
                filterDict = [String:Any]()
//            }
           // self.viewDidLoad()
            self.reloadWholePage()
        }
    }
    
    
    //MARK:- WS Methods Getting Home Data 1st Service Fetch at load
    //MARK: Show All API && HOME ALL API
    
    func wsToGetHomeData(location: String, filterDict: [String:Any] = [String:Any]()) {
        print("Called WSGetHomeData")
        var paramDict = [String:Any]()
        if location.count > 0 && !location.contains(self.lang.anywhere_Tit){
            paramDict["location"] = location
        }
        paramDict["token"] = SharedVariables.sharedInstance.userToken
        paramDict["search_type"] = k_isHomeType.homeType.instance
        paramDict.merge(dict: filterDict)
        
        if !location.isEmpty{
            paramDict["location"] = location
        }
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_EXPLORE, paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            
            if responseDict.isSuccess {
                print("isSuccess")
                self.homeTableView.scrollToTop()
                self.homeTableView.setContentOffset(CGPoint.zero, animated: false)
                //self.mapFilterView.isHidden = SharedVariables.sharedInstance.homeType.shouldHideMapFilter
                self.searchAndBackImageView.image = UIImage(named: SharedVariables.sharedInstance.homeType.getIconName)
                
                self.filterListDictArray = [Detail]()
                self.exploreListDictArray = [Detail]()
                self.initForLayout()
//                self.variantListDictArray = [[String:Any]]()
                if let explore_List = responseDict["Explore list"] as? [[String : Any]]{
                    print("explore_List",explore_List)
                    self.variantListDictArray.removeAll()
                    explore_List.forEach({ (json) in
                        let model = ExploreCat(json)
                        print("variantListDictArray",model,"explore_List",explore_List)
                        self.variantListDictArray.append(model)
                    })
//                    let withOutExperience =  self.variantListDictArray.filter({$0.key != "Experiences"})
//                    if k_isRemoveExperience {
//                        self.variantListDictArray = withOutExperience
//                    }
                }
                if (responseDict["Lists"] as? [Any] ?? [Any]()).count > 0 {
                    print("DictValue:",(responseDict["Lists"]!))
                    if ![HomeType.all,.onFilterSearch]
                        .contains(SharedVariables.sharedInstance.homeType) {
                        let array = (((responseDict["Lists"] as! [Any])[0] as! JSONS))
                        if let dict = (array["Details"] as? [JSONS]) {
                            print("Explore particular category :",dict)
                            self.exploreListDictArray.removeAll()
                            dict.forEach({ (json) in
                                let model = ExperienceDetails(json)
                                print("Dict",dict)
                                self.exploreListDictArray.append(model)
                            })
                            
                        }
                    }else {
                        let listValue = responseDict.array("Lists")
                       
                        self.listVal.removeAll()
                        listValue.forEach({ (json) in
                            let detailsArray = json.array("Details")
                            self.detailVal.removeAll()
                            detailsArray.forEach({ (detailsJson) in
                                let details = Detail(detailsJson)
                                print("cat:",details.categoryName)
                                self.detailVal.append(details)
                            })
                            
                            let model = List(title: json.string("Title"),
                                             key : json.string("Key"),
                                             details: self.detailVal)
                            print("Title:",model.title)
                            print("Details:",model.details)
                            self.listVal.append(model)
                        })
//                        let withOutExperience = self.listVal.filter({$0.key != "Experiences"})
//                        if k_isRemoveExperience {
//                            self.listVal = withOutExperience
//                        }
                    }
                    //SharedVariables.sharedInstance.homeType != HomeType.showAll.rawValue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if SharedVariables.sharedInstance.homeType == HomeType.showAll(nil) {
                            self.homeTableView.isHidden = true
                            
                            self.homeTableView.reloadData()
                        }
                        self.homeTableView.isHidden = false
                       // self.filterCollectionView.isHidden = false
//                        self.homeTableView.setContentOffset(CGPoint.zero, animated: false)
                         self.homeTableView.restore()
                        self.homeTableView.reloadData()
//                        self.homeTableView.scrollToTop()
//                        self.homeTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//                        self.homeTableView.scrollsToTop = true
                        self.view.layoutIfNeeded()
                        //homeTableView.isHidden = true
                    }
                }
                else {
                    self.mapFilterView.isHidden = true
                    self.isNoHomeData = true
                    self.homeTableView.reloadData()
                   // self.homeTableView.scrollToTop()
                    self.homeTableView.setContentOffset(CGPoint.zero, animated: false)
                  //  self.filterCollectionView.isHidden = true
                    self.homeTableView.setEmptyMessage(title: self.lang.cant_RoomTit, subTitle: self.lang.remfilt_Msg1, attriSubTitle: self.lang.hi_Tit, attriSubTitleColor: UIColor.black, removeFilterButton: self.removeFilterButtonOutlet, imageWidth: 0.0, imageHeight: 0.0)
                }
                
            }
            else {
                //Utilities.showAlertMessage(message: responseDict["success_message"] as? String ?? String(), onView: self)
                print("notSuccess")
                self.mapFilterView.isHidden = true
                self.isNoHomeData = true
                self.homeTableView.reloadData()
                self.homeTableView.scrollToTop()
                self.homeTableView.setContentOffset(CGPoint.zero, animated: false)
               // self.filterCollectionView.isHidden = true
                self.homeTableView.setEmptyMessage(title: self.lang.cant_RoomTit, subTitle: self.lang.remfilt_Msg1, attriSubTitle: self.lang.hi_Tit, attriSubTitleColor: UIColor.black, removeFilterButton: self.removeFilterButtonOutlet, imageWidth: 0.0, imageHeight: 0.0)
                
            }
            self.setSearchLabelText()
//            self.variantListDictArray = responseDict["Lists"] as? [[String:Any]] ?? [[String:Any]]()
        }
    }
    
    func setSearchLabelText() {
        print("setSearchLabelText")
        if let location = self.isLocationProvided()
        {
            //SharedVariables.sharedInstance.homeType.getSearchLabelText
            self.searchLabel.text = location
            self.searchLabel.textColor = .black
        }
        else
        {
            if SharedVariables.sharedInstance.categoryName == "" {
                self.searchLabel.text = "\(self.lang.anywhere_Title)" + SharedVariables.sharedInstance.homeType.getSearchLabelText
            } else {
                self.searchLabel.text = SharedVariables.sharedInstance.categoryName
            }
         
          //   self.searchLabel.text = "\(self.lang.anywhere_Title)"
            self.searchLabel.textColor = .lightGray
        }
      print("SearchLabelTextValues",self.searchLabel.text)
    }
    
    //MARK: EXPLORE API RESPONSE FROM ROOM_ID NEED TO CHECK EMPTY
    func checkHomeOrOther(tempModel:Detail) -> Int
    {
//       if SharedVariables.sharedInstance.homeType == HomeType.home {
//        return tempModel.spaceid != 0 ? tempModel.spaceid : tempModel.id
//        }
//       else {
//            return tempModel.id
//        }
        return tempModel.spaceid != 0 ? tempModel.spaceid : tempModel.id
    }
    
    func wsToGetWhishList(exploreDict:Detail) {
        print("wishlist details")
        if SharedVariables.sharedInstance.userToken.count > 0 {
            var paramDict = [String:Any]()
            paramDict["token"] = SharedVariables.sharedInstance.userToken
            
            WebServiceHandler.sharedInstance.getToWebService(wsMethod: "get_wishlist", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
                 print("wishlist response",responseDict)
                
                if Utilities.sharedInstance.confirmAsInt(value: responseDict["status_code"]) > 0 && (Utilities.sharedInstance.unWrapDictArray(value: responseDict["wishlist_data"])).count > 0 {
                   print("if conditions")
                    let addWhishListVC = StoryBoard.account.instance.instantiateViewController(withIdentifier: "AddWhishListVC") as! AddWhishListVC
                    addWhishListVC.delegate = self
                    addWhishListVC.listType = exploreDict.type
                    addWhishListVC.strRoomName = exploreDict.cityName
//                    addWhishListVC.strRoomID = "\(String(describing: self.checkHomeOrOther(tempModel: exploreDict)))"
                    addWhishListVC.strRoomID = "\(String(describing: self.checkHomeOrOther(tempModel: exploreDict)))"
                    let whishListModelArray = MakentSeparateParam().separateParamForGetWishlist(params: responseDict as NSDictionary) as! GeneralModel

                    addWhishListVC.arrWishListData = whishListModelArray.arrTemp1
                    addWhishListVC.view.backgroundColor = UIColor.clear
                    addWhishListVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(addWhishListVC, animated: true, completion: nil)
                }
                else {
                    print("else conditions")
                    let createWhishListVC = StoryBoard.account.instance.instantiateViewController(withIdentifier: "CreateWhishList") as! CreateWhishList
                  createWhishListVC.strRoomID =  "\(String(describing: self.checkHomeOrOther(tempModel: exploreDict)))"
                        createWhishListVC.strRoomName = exploreDict.cityName
                     if SharedVariables.sharedInstance.homeType == HomeType.home
                     {
                        createWhishListVC.listType = "Rooms"
                     }
                     else
                     {
                       createWhishListVC.listType = exploreDict.type
                     }
                    createWhishListVC.delegate = self
                    self.present(createWhishListVC, animated: false, completion: nil)
                }
            }
        }
    }
    
    func wsToRemoveRoomFromWishList(strRoomID : String ,list_type: String) {
        
//        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [String: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        //dicts["room_id"]   = strRoomID
        dicts["space_id"]   = strRoomID
        dicts["list_type"]   = list_type
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_DELETE_WISHLIST, paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                SharedVariables.sharedInstance.lastWhistListRoomId = (strRoomID as NSString).integerValue
                self.onAddWhisListTapped(index: 1)
            }
            else{
                //responseDict.statusMessage as String
                Utilities.sharedInstance.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false, viewController: self)
                if responseDict.statusMessage == "token_invalid" || responseDict.statusMessage == "user_not_found" || responseDict.statusMessage == "Authentication Failed" {
                    AppDelegate.sharedInstance.logOutDidFinish()
                    return
                }
            }
        }
    }
        
    //Mark Explore Data Fetching While Clicking "Home" Category
    func wsToGetExploreData(location: String, pageNumber: Int, filterParamDict:[String:Any] = [String:Any]()) {
        print("wsToGetExploreData")
        var paramDict = [String:Any]()
        paramDict["page"] = "\(pageNumber)"
        
       // paramDict["token"] = SharedVariables.sharedInstance.userToken
        if filterParamDict.count > 0 {
            for key in filterParamDict.keys {
                paramDict[key] = filterParamDict[key]
            }
        }
         
        if !location.isEmpty
        {
            print("location count not empty")
            paramDict["location"] = location
        }
        print("FilterParamDict",paramDict)

        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "explore", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
             print(responseDict)
            
            self.isLoadingMorePages = false
            
            if responseDict.isSuccess {
                self.initForLayout()
                print("Explore isSuccess")
                print("mapFilter",SharedVariables.sharedInstance.homeType.shouldHideMapFilter)
                //self.mapFilterView.isHidden = SharedVariables.sharedInstance.homeType.shouldHideMapFilter
                self.searchAndBackImageView.image = UIImage(named: SharedVariables.sharedInstance.homeType.getIconName)
                
                if self.roomPageNumber == 1 {
                    print("roomPageNumber")
                    self.homeListDictArray = [Detail]()
                    self.filterMinPrice = Int()
                    self.filterMaxPrice = Int()
                    print("Response dicts",responseDict["data"])
                    if let dict = responseDict["data"] as? [JSONS] {
                        self.homeListDictArray.removeAll()
                        dict.forEach({ (json) in
                            let model = Detail(json)
                            self.homeListDictArray.append(model)
                        })
                    }
                    print("homeDetailValues",self.homeListDictArray)
                    self.exploreListDictArray = self.homeListDictArray
                    //self.filterMinPrice = self.homeListDictArray.
                    self.filterMinPrice = responseDict["min_price"] as? Int ?? Int()
                    self.filterMaxPrice = responseDict["max_price"] as? Int ?? Int()
                    self.totalRoomPages = responseDict["total_page"] as? Int ?? Int()
                    //self.filterCollectionView.isHidden = false
                    self.homeTableView.reloadData()
                    self.homeTableView.scrollToTop()
                    self.homeTableView.setContentOffset(CGPoint.zero, animated: false)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        self.homeTableView.reloadData()
                        self.view.layoutIfNeeded()
                    }
                }
                else {
//                    self.exploreModelData += responseDict["data"] as! [ExploreDataModel]
                    print("old page data count", self.homeListDictArray.count)
                    let tempDict = self.homeListDictArray //For remove duplicates
                    
                    if let dict = responseDict["data"] as? [JSONS] {
                        //For remove duplicates
                        dict.forEach({ (tempJson) in
                            if let index = tempDict.index(where:{$0.roomid == Detail(tempJson).roomid }){
                                self.homeListDictArray.remove(at: index)
                            }
                            let model = Detail(tempJson)
                            print(model.id)
                            self.homeListDictArray.append(model)
                        })
//                        dict.forEach({ (tempJson) in
//                            if let index = tempDict.index(where:{$0.id == Detail(tempJson).id}){
//                                self.exploreListDictArray.remove(at: index)
//                            }
//                            let model = ExperienceDetails(tempJson)
//                            print(model.id)
//                            self.exploreListDictArray.append(model)
//                        })
                    }
//                    self.homeListDictArray += responseDict["data"] as? [[String:Any]] ?? [[String:Any]]()
                    self.filterMinPrice += responseDict["min_price"] as? Int ?? Int()
                    self.filterMaxPrice += responseDict["max_price"] as? Int ?? Int()
                   // self.filterCollectionView.isHidden = false
                    self.homeTableView.reloadData()
                    self.homeTableView.scrollToTop()
                    self.initForLayout()
                self.homeTableView.setContentOffset(CGPoint.zero, animated: false)
                }
            }
            else if responseDict.statusCode == 0 && pageNumber != 1
            {
                
            }
            else {
                print("Explore is not success")
                //have to implementno data found for other page also
//                Utilities.showAlertMessage(message: responseDict["success_message"] as? String ?? String(), onView: self)
                self.mapFilterView.isHidden = true
                self.isNoHomeData = true
                self.homeTableView.reloadData()
               // self.filterCollectionView.isHidden = true
                self.homeTableView.setEmptyMessage(title: self.lang.cant_RoomTit, subTitle: self.lang.remfilt_Msg1, attriSubTitle: self.lang.hi_Tit, attriSubTitleColor: UIColor.black, removeFilterButton: self.removeFilterButtonOutlet, imageWidth: 0.0, imageHeight: 0.0)
            }
            self.setSearchLabelText()
        }
    }
    //MARK :- Clicking Experience Category Under Explore Makent Category
    //MARK: EXPERIENCE API CALLING
    func wsToGetServiceData(location: String, pageNumber: Int, filterDict: [String:Any] = [String:Any]())
    {
        print("Filter params",filterDict)
        var paramDict = [String:Any]()
        paramDict["page"] = pageNumber
        paramDict["token"] = SharedVariables.sharedInstance.userToken
        paramDict.merge(dict: filterDict)
        
        if !location.isEmpty
        {
            paramDict["location"] = location
        }
        //    WebServiceHandler.sharedInstance.getToWebService(wsMethod: METHOD_EXPLORE_EXPERIENCE, paramDict: paramDict,    viewController: self, isToShowProgress: true, isToStopInteraction: false)
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "explore", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            
            self.isLoadingMorePages = false
            print("ExploreExperienceValues:",responseDict)
            print("MapFilterPage",SharedVariables.sharedInstance.homeType.shouldHideMapFilter)
            if responseDict.isSuccess {
                self.initForLayout()
                self.homeTableView.restore()
                self.mapFilterView.isHidden = SharedVariables.sharedInstance.homeType.shouldHideMapFilter
                self.searchAndBackImageView.image = UIImage(named: SharedVariables.sharedInstance.homeType.getIconName)
                
                let array = (((responseDict["data"] as! [Any])[0] as! JSONS))
                print("ArrayValues",array.count)
                // let array = (((responseDict["Experiences"] as! [Any])[0] as! JSONS))
                if pageNumber == 1 {
                    if let dict = (responseDict["data"] as? [JSONS]) {
                        //                        responseDict["Experiences"] as? [[String:Any]]{
                        print("ExploreExperienceValues:",dict)
                        self.exploreListDictArray.removeAll()
                        dict.forEach({ (json) in
                            let model = Detail(json)
                            self.exploreListDictArray.append(model)
                        })
                    }
                    print("ExpoleList",self.exploreListDictArray.count)
                    
                    self.totalExperiencePages = responseDict.int("total_page")
                    self.filterMinPrice = responseDict.int("min_price")
                    self.filterMaxPrice = responseDict.int("max_price")
                    self.homeTableView.reloadData()
                    if self.filterDict.isEmpty == true
                    {
                        print("filterDict empty")
                        self.wsToGetExperienceCategoryList()
                    }
                    else
                    {
                        // self.filterCollectionView.isHidden = false
                        print("filterDict is not empty")
                    }
                }
                else {
                    print("old page data count", self.exploreListDictArray.count)
                    let tempDict = self.exploreListDictArray
                    
                    //                    if let dict = array["Experiences"] as? [JSONS] {
                    //                         //For remove duplicates
                    //                            dict.forEach({ (tempJson) in
                    //                                if let index = tempDict.index(where:{$0.id == Detail(tempJson).id}){
                    //                                    self.exploreListDictArray.remove(at: index)
                    //                                }
                    //                                let model = ExperienceDetails(tempJson)
                    //                                 print(model.id)
                    //                                self.exploreListDictArray.append(model)
                    //                            })
                    //                    }
                    if let dict = (responseDict["data"] as? [JSONS]) {
                        print("ExploreExperienceValues:",dict)
                        dict.forEach({ (json) in
                            let model = Detail(json)
                            self.exploreListDictArray.append(model)
                        })
                    }
                    self.homeTableView.reloadData()
//                    UIView.performWithoutAnimation {
//                        self.homeTableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .bottom, animated: true)
//                    }
                }
            }
            else if responseDict.statusCode == 0 && pageNumber != 1{
            }
            else {
                //Utilities.showAlertMessage(message: responseDict["success_message"] as? String ?? String(), onView: self)
                self.exploreListDictArray.removeAll()
                //self.mapFilterView.isHidden = true
                self.isNoHomeData = true
                self.homeTableView.reloadData()
                //self.filterCollectionView.isHidden = true
                //self.lang.cant_ExpTit
                self.homeTableView.setEmptyMessage(title: "We couldn't find any Spaces.", subTitle: self.lang.remfilt_Msg1, attriSubTitle: self.lang.hi_Tit, attriSubTitleColor: UIColor.black, removeFilterButton: self.removeFilterButtonOutlet, imageWidth: 0.0, imageHeight: 0.0)
            }
            self.setSearchLabelText()
        }
    }
    
    @objc func updateWhishListForHomeAndExperience() {
        print("Update Wishlist")
        isLoadingMorePages = false
        let roomId = SharedVariables.sharedInstance.lastWhistListRoomId
        print("room id :",roomId)
        var indexPath: IndexPath?
        print("indexPath",indexPath)
        if SharedVariables.sharedInstance.homeType == HomeType.home {
            print("HomeType")
            if let index = self.homeListDictArray.index(where:{self.checkHomeOrOther(tempModel: $0) == roomId}) {
                print("Home List")
                if  self.homeListDictArray[index].isWishlist == "Yes" {
                    self.homeListDictArray[index].isWishlist = "No"
                }else {
                    self.homeListDictArray[index].isWishlist = "Yes"
                }
                indexPath = IndexPath(row: index, section: 0)
            }
            
            if let indexValue = indexPath {
                print("Home index values",indexValue)
                self.homeTableView.reloadRows(at: [indexValue], with: .none)
            }else {
                print("Home index values not same")
                self.homeTableView.reloadData()
            }
        }
        else if SharedVariables.sharedInstance.homeType == HomeType.experiance {
            print("Experience")
            //            let index = self.exploreListDictArray.map({self.checkHomeOrOther(tempModel: $0)})
            //            if index.isEmpty {
            //                if let index = exploreListDictArray.index(where:{$0.name.count == textArray.max()}){
            //                    text = exploreListDictArray[index].name
            //                }
            if let index = self.exploreListDictArray.index(where:{self.checkHomeOrOther(tempModel: $0) == roomId}) {
                print("Index",index)
                print("experience List")
                if  self.exploreListDictArray[index].isWishlist == "Yes"
                {
                    self.exploreListDictArray[index].isWishlist = "No"
                }
                else
                {
                    self.exploreListDictArray[index].isWishlist = "Yes"
                }
                indexPath = IndexPath(row: index, section: 0)
                
            }
            if let indexValue = indexPath {
                print("Experience index values",indexValue)
                if let cell = self.homeTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? HomeTVC {
                    cell.homeProductCollectionView.reloadItems(at: [indexValue])
                }
//                self.homeTableView.reloadRows(at: [indexValue], with: .none)
            }else {
                print("Experience index values not same")
                self.homeTableView.reloadData()
            }
            //self.homeTableView.reloadData()
        }
        else
        {
            print("No index path matched")
           self.homeTableView.reloadData()
        }
        SharedVariables.sharedInstance.lastWhistListRoomId = 0
        return
    }
    
    @objc func resetWhistList() {
        print("Reset Wishlist")
        self.experiencePageNumber = 1
        self.roomPageNumber = 1
        self.getRoomsAndExperienceList()
    }
    
    //Mark :- Experience Category Click Action API
//    MARK: EXPERIENCE CATEGORY API
    func wsToGetExperienceCategoryList(location: String = String(), filterParamDict:[String:Any] = [String:Any]()) {
        print("HomeDatas")
        var paramDict = [String:Any]()
        paramDict["page"] = "1"
        paramDict["token"] = SharedVariables.sharedInstance.userToken
        
        if !location.isEmpty
        {
            paramDict["location"] = location
        }
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "search_filters", paramDict: paramDict, viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
            // print(responseDict)
            
            self.isLoadingMorePages = false
            print(responseDict)
            
            if responseDict.isSuccess {
                self.initForLayout()
                print("ExperienceCategoryList","isSuccess")
                //if let experience = responseDict["activities"] as? [JSONS]
//                if let experience = responseDict["space_types"] as? [JSONS]
                if let experience = responseDict["activities"] as? [JSONS]
                {
                    self.variantListDictArray.removeAll()
                    experience.forEach({ (json) in
                        let model = ExploreCat(json)
                        self.variantListDictArray.append(model)
                        // self.exploreListDictArray.append(model)
                    })
                }
                print("varientListDictnary",self.variantListDictArray)
                self.homeTableView.reloadData()
//                self.experienceCategoryModel = responseDict["host_experience_categories"] as! [ExploreDataModel]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    self.homeTableView.setContentOffset(CGPoint.zero, animated: false)
//                    self.homeTableView.scrollToTop()
//                    self.homeTableView.reloadData()
                }
            }
            else {
                print("isSuccess not")
                // Utilities.showAlertMessage(message: responseDict["success_message"] as? String ?? String(), onView: self)
                
                self.mapFilterView.isHidden = true
                self.isNoHomeData = true
                self.homeTableView.reloadData()
                //self.filterCollectionView.isHidden = true self.lang.cant_ExpTit
                self.homeTableView.setEmptyMessage(title: "We couldn't find any Spaces.", subTitle: self.lang.remfilt_Msg1, attriSubTitle: self.lang.hi_Tit, attriSubTitleColor: UIColor.black, removeFilterButton: self.removeFilterButtonOutlet, imageWidth: 0.0, imageHeight: 0.0)
                
            }
        }
    }
    
   //Initial Home TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isNoHomeData {
            isNoHomeData = false
            return 0
        }
        switch SharedVariables.sharedInstance.homeType {
        case .all,.onFilterSearch:
            self.homeTableView.restore()
            return 1 + self.listVal.count//exploreListDictArray.count
        case .experiance:
            self.homeTableView.restore()
            return 2
        case .experianceCategory,.showAll:
            self.homeTableView.restore()
            return 1
        default:
            self.homeTableView.restore()
            return homeListDictArray.count
        }
//        if [HomeType.all,.onFilterSearch].contains(SharedVariables.sharedInstance.homeType ) {
//        }
//        else if SharedVariables.sharedInstance.homeType == HomeType.experiance {
//            return 2
//        }
//        else if SharedVariables.sharedInstance.homeType == HomeType.experianceCategory(nil) || SharedVariables.sharedInstance.homeType == HomeType.showAll(nil) {
//            return 1
//        }
//        else {
//            return homeListDictArray.count
//        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "homeVariantTVC") as! HomeVariantTVC
        cell.contentView.tag = indexPath.row
        cell.variantSelectionDelegate = self
        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        if Language.getCurrentLanguage().isRTL
        {
            cell.variantCollectionView.semanticContentAttribute = .forceRightToLeft
            //cell.variantCollectionView.scrollToItem(at: [0,0], at: .right, animated: false)
            //flipsHorizontallyInOppositeLayoutDirection  effectiveUserInterfaceLayoutDirection
        }
        if [HomeType.all,.onFilterSearch].contains(SharedVariables.sharedInstance.homeType ) {
           print("Filter data called")
            if indexPath.row == 0 {
                //MARK :- Variant List ("Explore","Home")
                
                cell.titleLabel.text = "\(lang.expl_Title) \(k_AppName)"
                cell.titleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.variantListDictArray = variantListDictArray
                cell.variantCollectionView.reloadData()
                
            }
            else if indexPath.row > 0 {
                  //MARK :- Home Data Values at Initial Load
                print("∂Index,Height",indexPath.row,cell.contentView.frame.height)
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeTVC") as! HomeTVC
                guard self.listVal.indices.contains(indexPath.row - 1) else{return cell}
                cell.titleLabelText = self.listVal[indexPath.row - 1].title//Array(((exploreListDictArray[indexPath.row - 1] as? [String:Any] ?? [String:Any]())).keys)[0]
                
                cell.subTitleLabel.text = ""
                cell.exploreListDictArray = self.listVal[indexPath.row - 1].details//exploreListDictArray
                cell.indexValue = indexPath.row - 1
                cell.delegate = self
                
                //MARK: SET DYNAMIC HEIGHT
                let tempArray = cell.exploreListDictArray.count
       
                //Dont remove on any case
                //
                
                cell.homeProductCollectionView.reloadData()
                cell.collectionViewHeightConstraint.constant = cell.homeProductCollectionView.collectionViewLayout.collectionViewContentSize.height
                cell.homeProductCollectionView.reloadData()
                cell.showAllButtonOutlet.borderWidth = 0.5
                cell.showAllButtonOutlet.layer.cornerRadius = 2.0
                cell.showAllButtonOutlet.borderColor = UIColor.appGuestThemeColor
                cell.showAllButtonHeightConstraint.constant = 40.0
                cell.showAllButtonOutlet.isHidden = false
                cell.showAllButtonOutlet.setTitle(self.lang.showAll, for: .normal)
                cell.showAllButtonOutlet.addAction(for: .tap) {
                    self.showAllItems(forList: self.listVal[indexPath.row - 1])
                }
                return cell
            }
        }
        else if SharedVariables.sharedInstance.homeType == .home {

//             let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreTVC", for: indexPath) as! ExploreTVC
                if homeListDictArray[indexPath.row].bedCount > 0 {
                    if homeListDictArray[indexPath.row].bedCount == 1 {
                         cell.homeTitleLabel.text = "\(self.homeListDictArray[indexPath.row].roomType ) • " + homeListDictArray[indexPath.row].bedCount.description + " \(self.lang.bedd_Title)"
                        cell.homeTitleLabel.textColor = Utilities.sharedInstance.staticColours()
                    }else{
                    cell.homeTitleLabel.text = "\(self.homeListDictArray[indexPath.row].roomType ) • " + homeListDictArray[indexPath.row].bedCount.description + " \(self.lang.capbed_Title)"
                    cell.homeTitleLabel.textColor = Utilities.sharedInstance.staticColours()
                    }
                }else{
                    cell.homeTitleLabel.text = "\(self.homeListDictArray[indexPath.row].roomType ) • \(self.homeListDictArray[indexPath.row].cityName)"
                    cell.homeTitleLabel.textColor = Utilities.sharedInstance.staticColours()
                }
                cell.homeSubTitleLabel.text = homeListDictArray[indexPath.row].roomname
            
//            if (self.homeListDictArray[indexPath.row].instantBook ) == "No" {
               
//            }
//            else {
//                cell.homeSubTitleLabel.attributedText = MakentSupport().attributedInstantBookText(originalText: "G \(((self.homeListDictArray[indexPath.row].roomname ) as NSString) as String)" as NSString, boldText: ((self.homeListDictArray[indexPath.row].roomname ) as NSString) as String, fontSize: 13.0)
//            }

            setTableViewCellImages(roomDictArray: homeListDictArray[indexPath.row], scrollView: cell.homeImageListScrollView)
            
            
            if (self.homeListDictArray[indexPath.row].instantBook ) == "No" {
                cell.homePriceLabel.text = "\(self.homeListDictArray[indexPath.row].currencySymbol) \(self.homeListDictArray[indexPath.row].roomprice) \(self.lang.pernight_Title)"
            }else{
                cell.homePriceLabel.attributedText = Utilities.attributeForInstantBook(normalText: "\("\(self.homeListDictArray[indexPath.row].currencySymbol) \(self.homeListDictArray[indexPath.row].roomprice) \(self.lang.pernight_Title)" as String)", boldText: "", fontSize: 11.0)
                //cell.homePriceLabel.minimumScaleFactor = 8.0
                
            }


            let reviewCount = homeListDictArray[indexPath.row].reviewsCount
            let ratingCount = homeListDictArray[indexPath.row].rating
            if reviewCount !=  0 {
                
                cell.homeRatingLabel.text = MakentSupport().createRatingStar(ratingValue: ratingCount as NSString) as String
//                    Utilities.sharedInstance.setRatingImage(rating: (ratingCount as NSString).floatValue).withRenderingMode(.alwaysTemplate)
                cell.homeRatingLabel.textColor = UIColor.appGuestThemeColor
                
                cell.homeRatingCountLabel.text = "\(reviewCount)"
            }
            else {
                cell.homeRatingLabel.text = ""
                cell.homeRatingCountLabel.text = ""
            }
            
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0)
//            Utilities.sharedInstance.addShadowToView(view: cell, radius: 3.0, ShadowColor: .black)

//            cell.layer.cornerRadius = 3.0

            if  self.homeListDictArray[indexPath.row].isWishlist == "Yes" {
                cell.whishListButtonOutlet.setImage(UIImage(named: "heart_selected"), for: .normal)
            }
            else {
                cell.whishListButtonOutlet.setImage(UIImage(named: "heart_normal"), for: .normal)
            }

            cell.whishListButtonOutlet.clipsToBounds = true
            cell.whishListButtonOutlet.addTarget(self, action: #selector(whishListButtonAction(_:)), for: .touchUpInside)
            Utilities.sharedInstance.addShadowToView(view: cell.whishListButtonOutlet, radius: 7.0, ShadowColor: .black, shadowOpacity: 0.3)

            return cell

        }
        else if SharedVariables.sharedInstance.homeType == HomeType.experiance {
            
             print("Experience home data called")
            if indexPath.row == 0 {
                //cell.titleLabel.text = self.lang.categories
                cell.titleLabel.text =  self.lang.ExploreMakentSpace
                cell.variantListDictArray = variantListDictArray
                cell.variantCollectionView.reloadData()
            }
            else if indexPath.row > 0 {
                print("Indexpath greater than zero",self.exploreListDictArray.count)
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
//                cell.homeCollectionView.reloadData()
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeTVC") as! HomeTVC
//                cell.titleLabelText = exploreListDictArray[indexPath.row-1].categoryName
                //Array(((exploreListDictArray[indexPath.row - 1] as? [String:Any] ?? [String:Any]())).keys)[0]
                //cell.titleLabelText = self.lang.ExploreMakentSpace
                cell.subTitleLabel.text = ""
                cell.exploreListDictArray = self.exploreListDictArray

                cell.indexValue = indexPath.row
                cell.delegate = self
                cell.homeProductCollectionView.reloadData()
                cell.collectionViewHeightConstraint.constant = cell.homeProductCollectionView.collectionViewLayout.collectionViewContentSize.height
                cell.showAllButtonOutlet.borderWidth = 0.5
                cell.showAllButtonOutlet.layer.cornerRadius = 2.0
                cell.showAllButtonOutlet.borderColor = UIColor.appGuestThemeColor
                cell.showAllButtonHeightConstraint.constant = 0.0
                cell.showAllButtonOutlet.isHidden = true
                return cell
            }
        }
        else if SharedVariables.sharedInstance.homeType == HomeType.experianceCategory(nil) || SharedVariables.sharedInstance.homeType == HomeType.showAll(nil) {

            print("ExploreData:",exploreListDictArray)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTVC") as! HomeTVC
            guard exploreListDictArray.indices ~= (indexPath.row) else{ return cell }
            cell.titleLabelText = ""
            cell.exploreListDictArray = self.exploreListDictArray
            cell.indexValue = indexPath.row
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
            cell.delegate = self
            cell.homeProductCollectionView.reloadData()
            cell.collectionViewHeightConstraint.constant = cell.homeProductCollectionView.collectionViewLayout.collectionViewContentSize.height
            cell.showAllButtonOutlet.borderWidth = 0.5
            cell.showAllButtonOutlet.layer.cornerRadius = 2.0
            cell.showAllButtonOutlet.borderColor = UIColor.appGuestThemeColor
            cell.showAllButtonHeightConstraint.constant = 0.0
            cell.showAllButtonOutlet.isHidden = true
            return cell
        }

        return cell
    }
    
    
    func showAllItems(forList list : List)
    {
        print("ShowALL : \(list.title),\(list.key)")
        print("ShowALLKey : ,\(list.key)")
            if searchLabel.text! == self.lang.anywhere_Tit {
                searchLabel.text = "\(self.lang.anywhere_Tit) • \(list.title)"
            }
            mapFilterView.isHidden = true
            SharedVariables.sharedInstance.homeType = HomeType.showAll("\(list.title)")
            getRoomsAndExperienceList(filterDict: ["list": list.key])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if homeListDictArray.count > 0 {
            let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
            homeDetailVC.roomIDString = "\(String(describing: homeListDictArray[indexPath.row].roomid))"
            homeDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // if let cell = cell as? HomeTVC{
          //  let tHeight = cell.contentView.frame.height
//            print("åTHeight \(indexPath.row) : \(tHeight)")
        //}
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView
//    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height)) {
            print("SCROLL ENDED")
        }
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height && !isLoadingMorePages)){
            for view in scrollView.subviews {
                if view.isKind(of: UITableViewCell.self) {
                    if SharedVariables.sharedInstance.homeType == HomeType.home {
                        if roomPageNumber < totalRoomPages {
                            roomPageNumber = roomPageNumber + 1
                            isLoadingMorePages = true
                            getRoomsAndExperienceList()
                        }
                        else {
                            Utilities.sharedInstance.createToastMessage(self.lang.noMoreDatas, isSuccess: false, viewController: self)
                        }
                    }
                    else if SharedVariables.sharedInstance.homeType == HomeType.experiance {
                        if experiencePageNumber < totalExperiencePages {
                            experiencePageNumber = experiencePageNumber + 1
                            isLoadingMorePages = true
                            getRoomsAndExperienceList()
                        }
                        else {
                            Utilities.sharedInstance.createToastMessage(self.lang.noMoreDatas, isSuccess: false, viewController: self)
                        }
                    }
                    break
                }
            }
        }
    }
    
    func setTableViewCellImages(roomDictArray : Detail, scrollView:UIScrollView) {
        
        let imageArray = [roomDictArray.roomThumbImage]
        
        if imageArray.count==0
        {
            return
        }
        
        for view in scrollView.subviews
        {
            view.removeFromSuperview()
        }
        
        var xPosition:CGFloat = 0
        
        for i in 0 ..< imageArray.count {
            let myImage = UIImage(named: imageArray[i] )
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            
            let myButton:UIButton = UIButton()
            myImageView.frame =  CGRect(x: xPosition, y:0, width: scrollView.frame.size.width+2 ,height: scrollView.frame.size.height)
            myButton.frame =  CGRect(x: xPosition, y:0, width: self.view.frame.size.width + 2 ,height: scrollView.frame.size.height)
            
            
            
            myButton.tag = i
            myButton.addTarget(self, action: #selector(self.onImageTapped), for: UIControl.Event.touchUpInside)
            
            scrollView.addSubview(myImageView)
            scrollView.addSubview(myButton)
            xPosition += scrollView.frame.size.width
            let avatarURL : URL? = URL(string: imageArray[i])
            
            if let url = avatarURL {
                myImageView.sd_setImage(with: url, placeholderImage:UIImage(named:""))//avatar_placeholder.png
            }
           // myImageView.sd_setImage(with: NSURL(string: imageArray[i])! as URL, placeholderImage:UIImage(named:""))
            myImageView.isUserInteractionEnabled = true
        }
        
        let widht = CGFloat(self.view.frame.size.width) * CGFloat(imageArray.count)
        scrollView.contentSize = CGSize(width: widht, height:  scrollView.frame.size.height)
        
//        timerAutoScroll = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.makeAutoScrollAnimation), userInfo: nil, repeats: true)
        scrollView.isUserInteractionEnabled = true

        if imageArray.count == 1 {
            scrollView.isScrollEnabled = false
        }
    }
    
    @objc func onImageTapped(sender: UIButton) {
        print(sender)
        if let cell = sender.superview?.superview?.superview as? ExploreTVC {
            let indexPath = homeTableView.indexPath(for: cell)
            let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
            homeDetailVC.roomIDString = "\(String(describing: homeListDictArray[(indexPath?.row)!].roomid))"
            homeDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeDetailVC, animated: true)
        }
    }
    
//    func makeAutoScrollAnimation(imageArray : [String]?)
//    {
//        if imageArray == nil || imageArray.count == 0 {
//            return
//        }
//
//        if (nCurrentIndex > imageArray.count - 1)
//        {
//            nCurrentIndex = 0
//        }
//
//        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions(), animations: { () -> Void in
//            let rect = MakentSupport().getScreenSize()
//            self.roomDeatailHeaderImageScrollView.setContentOffset(CGPoint(x:  rect.size.width * CGFloat(self.nCurrentIndex), y: 0), animated: true)
//        }, completion: { (finished: Bool) -> Void in
//            self.nCurrentIndex += 1
//        })
//    }
    
    
    //MARK:- CollectionView Delegates
    //MARK: FILTER COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("FilterCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! filterCell
//        if Language.getCurrentLanguage().isRTL{
//            cell.semanticContentAttribute = Language.getCurrentLanguage().getSemantic
//        }
//        let titleLabel = cell.viewWithTag(1) as! UILabel
        
//        titleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        
        let reverse = filterTitleArray.localize()
        
        let model = reverse[indexPath.row]
//        titleLabel.text = model.title
//        titleLabel.clipsToBounds = true
//        titleLabel.layer.cornerRadius = 5.0
        cell.titleLabel.layer.borderWidth = 0.3
        cell.titleLabel.text = model.title
        cell.titleLabel.clipsToBounds = true
        cell.titleLabel.cornerRadius = 5.0
            if !model.isApplyFilter {
                cell.titleLabel.backgroundColor = UIColor.white
                cell.titleLabel.textColor = UIColor.black
                
                cell.titleLabel.layer.borderColor = UIColor.gray.cgColor
            }
            else {
                cell.titleLabel.backgroundColor = UIColor.appGuestThemeColor
                cell.titleLabel.textColor = UIColor.white
                //titleLabel.frame.size.width = titleLabel.intrinsicContentSize.width - 5
                cell.titleLabel.layer.borderColor = UIColor.appGuestThemeColor.cgColor
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard filterTitleArray.count > 0 else {
            return CGSize.init(width: 0.0, height: 0.0)
        }
        var width : CGFloat = 0
        let reverse = filterTitleArray.localize()
        let text = reverse[indexPath.row].title
        if text.count == 0{
            width = 0
        }
        else{
            width = CGFloat(text.count * 10) + 4
        }
        var size = CGSize()
        //if indexPath.row == 0 {
        //            if text != self.lang.date {
        //               width = width + 5;
        //            }else{
        width = width + 20;
        //            }
        //        }else{
        //        width = width + 25;
        //}
        size = CGSize(width: width, height: 55.0)
        return size
////        var width : CGFloat = 0
////        let reverse = filterTitleArray.localize()
////        let text = reverse[indexPath.row].title
////        print("ضيوف".count)
////        if text.count == 0{
////            width = 0
////        }
////        else{
////            width = CGFloat(text.count * 10) + 4
////        }
////        var size = CGSize()
////        if indexPath.row == 0 {
////            if text != self.lang.date {
////               width = width + 5;
////            }else{
////                width = width + 25;
////            }
////        }else{
////        width = width + 25;
////        }
////        size = CGSize(width: width, height: 50.0)
////        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! filterCell
        print("Filter search")
        cell.isHighlighted = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell.isHighlighted = false
            let reverse = self.filterTitleArray.localize()
            if reverse[indexPath.row].type == .date {
                self.onShowCalendar()
            }else if reverse[indexPath.row].type == .guest {
                self.callAddGuestSelectin()
            }else {
                print("Filter section")
                 self.callFilterSelection()
            }
        }
        
    }
    
    func callAddGuestSelectin() {
        let viewGuest = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddGuestVC") as! AddGuestVC
        viewGuest.nCurrentGuest = self.guestCount
        viewGuest.delegate = self
        if SharedVariables.sharedInstance.homeType == HomeType.experiance
        {
            viewGuest.isfromExplore = false
            viewGuest.nMaxGuestCount = 10
        }
        else
        {
            viewGuest.isfromExplore = true
//            viewGuest.nMaxGuestCount = 16
        }
        self.present(viewGuest, animated: true, completion: nil)
    }
    
    func callFilterSelection() {
        
        self.wsToGetAmenitiesList()
    }
    
    
    func wsToGetAmenitiesList() {

        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "search_filters", paramDict: [String:Any](), viewController: self, isToShowProgress: true, isToStopInteraction: true, complete: { (responseDict) in
            print("Filter Array",responseDict)
            print("success code",responseDict["status_code"] as! String)
            if (responseDict["status_code"] as! String) == "2" {
                Utilities.showAlertMessage(message: (responseDict["success_message"] as! String), onView: self)
            }
            else if (responseDict["status_code"] as! String) == "1" {
                
                let filterVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "filterViewController") as! FilterViewController
                 filterVC.newFilterDelegate = self
                // filterVC.fromMapFilterView = "FromHome"
                 filterVC.minPrice = self.filterMinPrice
                 filterVC.maxPrice = self.filterMaxPrice
                 filterVC.eventTypeID = self.selectedCategoryID
                filterVC.filterResponse = responseDict
                 let navController = UINavigationController(rootViewController: filterVC)
                 navController.modalPresentationStyle = .fullScreen
                 self.present(navController, animated: true, completion: nil)
                
            }
            else
            {
                Utilities.showAlertMessage(message: (responseDict["success_message"] as! String), onView: self)
            }
        })
    }
    
    
    //Wish List Button Action
    @IBAction func whishListButtonAction(_ sender: Any) {
        print("WishlistButton clicked")
        var tableIndexPath: IndexPath?
        var collectionIndexPath: IndexPath?
        var indexValue = Int()
        if SharedVariables.sharedInstance.homeType == HomeType.home {
            print("HomeType")
            let exploreCell = (sender as! UIButton).superview!.superview as! ExploreTVC
            tableIndexPath = (exploreCell.superview! as! UITableView).indexPath(for: exploreCell)
        }
        else {
            print("Non HomeType")
            let collectionCell = (sender as! UIButton).superview!.superview?.superview as! HomeExploreListCVC
            let tableCell = (sender as! UIButton).superview!.superview?.superview?.superview?.superview?.superview as! HomeTVC
            tableIndexPath = (tableCell.superview! as! UITableView).indexPath(for: tableCell)
            collectionIndexPath = (collectionCell.superview! as! UICollectionView).indexPath(for: collectionCell)
        }
        
        //Show ALL
        if [HomeType.all,.onFilterSearch].contains(SharedVariables.sharedInstance.homeType ) {
            indexValue = (tableIndexPath?.row ?? 1) - 1
        }//Experience
        else if SharedVariables.sharedInstance.homeType == HomeType.experiance
        {
            print("Wishlist clicked")
            indexValue = (tableIndexPath?.row ?? 1) - 1
        }//ExperienceCategory
        else if SharedVariables.sharedInstance.homeType == HomeType.experianceCategory(nil) || SharedVariables.sharedInstance.homeType == HomeType.showAll(nil) {
            indexValue = (tableIndexPath?.row ?? 1)
        }
        //WishList Type Param Values Setting
        if SharedVariables.sharedInstance.homeType == HomeType.home {
            whishListDict = self.homeListDictArray[(tableIndexPath?.row)!]
            whishListDict?.type = "Rooms"
            print("room type: ", whishListDict?.type as Any)
        }else if [HomeType.all,.onFilterSearch].contains(SharedVariables.sharedInstance.homeType )  {
            whishListDict = self.listVal[indexValue].details[(collectionIndexPath?.row)!]
            print("room type: ", whishListDict?.type as Any)
        }
        else {
            print("exploreList",self.exploreListDataArray.count)
            whishListDict = self.exploreListDictArray[(collectionIndexPath?.row)!]
            print("room type: ", whishListDict?.type as Any)
        }
        
        if SharedVariables.sharedInstance.userToken.count == 0 {
            let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            mainPage.hidesBottomBarWhenPushed = true
            let nav = UINavigationController(rootViewController: mainPage)
            self.present(nav, animated: true, completion: nil)
        }
        else{
            if (sender as! UIButton).imageView?.image == UIImage(named: "heart_selected")
            {
                print("heart_selected")
                self.wsToRemoveRoomFromWishList(strRoomID: self.checkHomeOrOther(tempModel: whishListDict!).description, list_type: whishListDict?.type ?? "")
            }
            else {
                print("heart_not_selected")
                //Getting WishList Data Function
                wsToGetWhishList(exploreDict: whishListDict!)
            }
        }
        self.homeTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        let storyBoard1 : UIStoryboard = UIStoryboard(name: "MakentMainStoryboard", bundle: nil)
        let searchVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        searchVC.delegate = self
        self.navigationController?.present(searchVC, animated: true, completion: nil)
        return false
    }
    
    func onShowCalendar() {
        print("start time",Constants().GETVALUE(keyname: "START_TIME"))
        print("end time",Constants().GETVALUE(keyname: "END_TIME"))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let selector = k_MakentStoryboard.instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector
        
        selector.isFromExplorePage = true
        selector.delegate = self
        
        print("multiple dates",SharedVariables.sharedInstance.multipleDates)
        print("single dates",SharedVariables.sharedInstance.multipleDates)
        print("multipledaterange",SharedVariables.sharedInstance.multipleDates.first)
        
        selector.optionCurrentDate = SharedVariables.sharedInstance.multipleDates.first ??  singleDate
        selector.optionCurrentDates = Set(SharedVariables.sharedInstance.multipleDates)
        appDelegate.multipleDates = SharedVariables.sharedInstance.multipleDates
        selector.optionCurrentDateRange.setStartDate(SharedVariables.sharedInstance.multipleDates.first ??  singleDate)
        selector.optionCurrentDateRange.setEndDate(SharedVariables.sharedInstance.multipleDates.last ??  singleDate)
        
        selector.optionSelectionType = .range
        selector.strTime  = Constants().GETVALUE(keyname: "START_TIME") as String
        selector.edTime   = Constants().GETVALUE(keyname: "END_TIME") as String
        selector.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(selector, animated: true)
    }

    // MARK:- WWCalendar Delegates
    //For Getting dates after done pressed in calendar page
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
//        appDelegate.multipleDates = dates
        let formalDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        SharedVariables.sharedInstance.multipleDates = dates
        
        print(dateFormatter.string(from: startDay))
        
        var checkInDict = [String:Any]()
        
        if dateFormatter.string(from: startDay).count > 0 && dateFormatter.string(from: lastDay!).count > 0 {
            dateFormatter.dateFormat = "dd-MM-yyy"
            dateFormatter.locale = Locale.init(identifier: "en_US")
//            let tomorrow1 = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
            checkInDict["checkin"] = dateFormatter.string(from: startDay)
//            checkInDict["checkout"] = dateFormatter.string(from: tomorrow1)
            checkInDict["checkout"] = dateFormatter.string(from: startDay)
            

            dateFormatter.dateFormat = "dd-MM-yyy hh:mm a"
            let startTime = dateFormatter.date(from: "\(checkInDict["checkin"]!) \(Constants().GETVALUE(keyname: "START_TIME") as String)")
            let endTime = dateFormatter.date(from: "\(checkInDict["checkout"]!) \(Constants().GETVALUE(keyname: "END_TIME") as String)")
            
            dateFormatter.dateFormat = "HH:mm"
            checkInDict["start_time"] = dateFormatter.string(from: startTime!)
            checkInDict["end_time"] = dateFormatter.string(from: endTime!)
            
            dateFormatter.dateFormat = "dd MMM"
            dateFormatter.locale = Language.getCurrentLanguage().locale
            
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
            let startDateString = dateFormatter.string(from: startDay)
            let endDateString = dateFormatter.string(from: lastDay!)
            self.setFilterData(title: "", isApply: false, type: .date)
//            filterTitleArray[0] = FilterStruct(title: "", isApplyFilter: false, type: .date)
            //            ""
            if startDateString == endDateString
            {
              let endDate = dateFormatter.string(from: tomorrow)
              self.setFilterData(title: "\(startDateString) - \(startDateString)", isApply: true, type: .date)
             //   self.setFilterData(title: "\(startDateString) - \(endDate)", isApply: true, type: .date)
//                filterTitleArray[0] = FilterStruct(title: "\(startDateString) - \(endDate)", isApplyFilter: true, type: .date)
            }
            else
            {
                self.setFilterData(title: "\(startDateString) - \(endDateString)", isApply: true, type: .date)
//                filterTitleArray[0] = FilterStruct(title: "\(startDateString) - \(endDateString)", isApplyFilter: true, type: .date)
                //                 "\(startDateString) - \(endDateString)"
            }
        }
        if SharedVariables.sharedInstance.homeType == .all{
            SharedVariables.sharedInstance.homeType = .onFilterSearch
        }
        getRoomsAndExperienceList(filterDict: checkInDict)
    }
    
    
    func setFilterData(title:String,isApply:Bool,type:FilterType) {
        print("serFilterData")
        self.filterCollectionView.reloadData()
        if let index = self.filterTitleArray.index(where:{$0.type == type}) {
            filterTitleArray[index].title = title
            filterTitleArray[index].isApplyFilter = isApply
            filterTitleArray[index].type = type
           // FilterStruct(title: title, isApplyFilter: isApply, type: type)
            let indexPath = IndexPath(item: index, section: 0)
            print("applied filter index :", index)
            self.filterCollectionView.reloadData()
           
        }
    }
    
    //For Getting dates after done pressed in calendar page
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let formalDates = date
        let startDay = formalDates
        let lastDay = formalDates
        let dateFormatter = DateFormatter()
        let starttime = Constants().GETVALUE(keyname: "START_TIME")
        print("Receiving start time",starttime)
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        SharedVariables.sharedInstance.multipleDates = [date]
        
        print(dateFormatter.string(from: startDay))
        var checkInDict = [String:Any]()
        
        if dateFormatter.string(from: startDay).count > 0 && dateFormatter.string(from: lastDay).count > 0 {
            
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "dd-MM-yyy"
            let tomorrow1 = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
            checkInDict["checkin"] = dateFormatter.string(from: startDay)
            checkInDict["checkout"] = dateFormatter.string(from: tomorrow1)
            
            dateFormatter.dateFormat = "dd MMM"
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
            let startDateString = dateFormatter.string(from: startDay)
            let endDateString = dateFormatter.string(from: lastDay)
            if startDateString == endDateString{
                let endDate = dateFormatter.string(from: tomorrow)
                self.setFilterData(title: "\(startDateString) - \(endDate)", isApply: true, type: .date)

            }else{
                self.setFilterData(title: "\(startDateString) - \(endDateString)", isApply: true, type: .date)

            }
        }
        if SharedVariables.sharedInstance.homeType == .all{
            SharedVariables.sharedInstance.homeType = .onFilterSearch
        }
        
        getRoomsAndExperienceList(filterDict: checkInDict)
    }
    
    func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, dates: [Date]) {

    }
    
    //MARK:- Callback Delegates
    
    func aaddressPickingDidFinish(_ searchedLocation: LocationModel, searchedString: String) {
        
        self.searchedLocation = searchedLocation
        print(searchedLocation.currentLocation)
        print(searchedLocation.latitude)
        print(searchedLocation.longitude)
        print(searchedLocation.searchedAddress)
        self.roomPageNumber = 1
        self.experiencePageNumber = 1

        if searchedString == self.lang.anywhere_Tit {
            self.searchedLocation = nil
        }
        else
        {
            if SharedVariables.sharedInstance.homeType == .all
            {
                SharedVariables.sharedInstance.homeType = .onFilterSearch
            }
        }

        self.setSearchLabelText()
        
        self.getRoomsAndExperienceList(filterDict: self.filterDict)
        self.filterTitleArray = SharedVariables.sharedInstance.homeType.getFilterTitleArray
        self.filterView.frame.size.height = 54.0
        self.filterCollectionView.isHidden = false
      //  filterCollectionView.reloadData()
    }
    func getAvailableAddress() -> LocationModel? {
        return self.searchedLocation
    }
    func onGuestAdded(index: Int) {
        print("Guest count: \(index)")
        guestCount = index
         print("guest count",guestCount)
            if guestCount > 1 {
                print("Guest count greater than one")
                let guest = "\(guestCount.localize) \(self.lang.guests)"
                self.setFilterData(title: guest, isApply: true, type: .guest)
            }
            else {
                 print("Guest count lesser than one")
                self.setFilterData(title: self.lang.guests, isApply: false, type: .guest)
            }

        if SharedVariables.sharedInstance.homeType == .all{
            SharedVariables.sharedInstance.homeType = .onFilterSearch
        }
        getRoomsAndExperienceList(filterDict: ["guests": "\(guestCount)"])
    }
    
    func didVariantSelected(_ categoryID : String?) {
        print("didVariantSelected")
        //print("selectedCategoriesID",categoryID)
        if SharedVariables.sharedInstance.homeType == HomeType.experianceCategory(nil) {
            filterCount = 1
            selectedCategoryID = categoryID ?? ""
            let title = variantListDictArray.map {
                (tempModel) -> String in
                if  tempModel.id.description == categoryID {
                    return tempModel.name
                }
                return ""
            }
            title.forEach {
                (text) in
                if text.count > 1
                {
                    searchLabel.text = text
                   
                }
            }
            searchLabel.text = SharedVariables.sharedInstance.categoryName
            categoryFilterDict = ["activity_type": categoryID ?? ""]
            self.experiencePageNumber = 1
            print("categoryFilterDict",categoryFilterDict)
            //Selecting Experience Category:-
            self.filterTitleArray = SharedVariables.sharedInstance.homeType.getFilterTitleArray
            let filterres = "\(self.lang.filter) • \(String(describing: filterCount.localize))"
                       self.setFilterData(title: filterres, isApply: true, type: .filter)
            self.filterCollectionView.isHidden = false
            self.filterView.frame.size.height = 54.0
            filterCollectionView.reloadData()
            getRoomsAndExperienceList(filterDict: ["activity_type": categoryID ?? ""])
            //getRoomsAndExperienceList(filterDict: ["activity_type": categoryID ?? ""])
        }
        else {
           // self.viewDidLoad()
            self.reloadWholePage()
        }
    }
    
    func mapFilter(notification : NSNotification)
    {
        print("Notification Received")
        let info = notification.userInfo
        print("userInfo",notification.userInfo)
//        self.didSelectDetailPage(detailDict: notification.userInfo )
    }
    
    func didSelectFilterOptions(filterDict: [String : Any]) {
        
        filterCount = 0
        print("home didSelectFilterOptions",filterDict)
        print("filterDict",filterDict)
        print("filterDict",filterDict.count)
        print("amenitiesArray",filterDict.string("amenities").count)
        print("amenitiesArray",filterDict.string("FilterCount"))
        
        self.selectedCategoryID = filterDict.string("activity_type")

        filterCount = Int(filterDict.string("FilterCount")) ?? 0
        print("filter count",filterCount)
        self.filterDict = filterDict
        //Mark:- Return Array while filterTitleArray pop from mapfilterview "Showall" option
        if filterCount > 0 {
            if filterCount > 1 {
                let filterres = "\(self.lang.filts_Tit) • \(String(describing: filterCount.localize))"
                self.setFilterData(title: filterres, isApply: true, type: .filter)

            }
            let filterres = "\(self.lang.filter) • \(String(describing: filterCount.localize))"
            self.setFilterData(title: filterres, isApply: true, type: .filter)
            self.filterCollectionView.isHidden = false
            self.filterView.frame.size.height = 54.0
            filterCollectionView.reloadData()

        }
        else {
            if filterTitleArray.indices.contains(1)
            {
                self.setFilterData(title: self.lang.filter, isApply: false, type: .filter)
            }
        }
        var location = ""
        if let givenLocation = isLocationProvided() {
            location = givenLocation
        }
        wsToGetExploreData(location: location, pageNumber: roomPageNumber, filterParamDict: filterDict)
    }
    
    func didReceiveMapFilter(filterDict: [String : Any]) {
        self.filterTitleArray = SharedVariables.sharedInstance.homeType.getFilterTitleArray
        SharedVariables.sharedInstance.homeType = .experianceCategory(nil)
        didSelectFilterOptions(filterDict: filterDict)
    }
    func exitingMapFilter() {
        self.getRoomsAndExperienceList()
    }
    
    func didSelectDetailPage(detailDict: Detail) {
        
           print("Detail page clicked")
            let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
            homeDetailVC.roomIDString = String(describing: detailDict.spaceid)
            homeDetailVC.strCityName = detailDict.cityName
            //            "\(detailDict["id"] ?? "")"
            homeDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeDetailVC, animated: true)
    }
    
    func onCreateNewWishList(listName: String, privacy: String, listType: String) {
        print("\(listName) \(privacy) \(listType)")
        var dicts = [String: Any]()
        let room_id = "\(String(describing: self.checkHomeOrOther(tempModel: whishListDict!)))"
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        //dicts["room_id"]   = room_id
        dicts["space_id"]   = room_id
        dicts["list_name"]   = listName
        dicts["privacy_settings"] = privacy
        dicts["list_type"]   = listType
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_ADD_TO_WISHLIST, paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess
            {
                SharedVariables.sharedInstance.lastWhistListRoomId = (room_id as NSString).integerValue
                self.onAddWhisListTapped(index: 1)
            }
            else
            {
                //responseDict.statusMessage
                Utilities.sharedInstance.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false, viewController: self)
                if responseDict.statusMessage == "token_invalid" || responseDict.statusMessage == "user_not_found" || responseDict.statusMessage == "Authentication Failed"
                {
                    AppDelegate.sharedInstance.logOutDidFinish()
                    return
                }
            }
        }
    }
    
    func onAddWhisListTapped(index: Int) {
        print(index)
        print("Wishlist Added")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
            if SharedVariables.sharedInstance.homeType != .experiance &&  SharedVariables.sharedInstance.homeType != .home {
                self.getRoomsAndExperienceList()
            }
        }
    }
}
extension Array {
    
    func localize()->[Element] {
        if Language.getCurrentLanguage().isRTL {
            return self.reversed()
        }else {
            return self
        }
        
    }
}

