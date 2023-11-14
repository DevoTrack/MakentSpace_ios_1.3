//
//  MapFilterViewController.swift
//  Makent
//
//  Created by trioangle on 21/05/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications

protocol MapFilterValuesDelegate {
    func didReceiveMapFilter(filterDict: [String:Any])
    func exitingMapFilter()
}

class MapFilterRoomCVC: UICollectionViewCell {
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var whishListButtonOutlet: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var grayView: UIView!
}

class MapFilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewFilterDelegate, addWhisListDelegate, createdWhisListDelegate {
    
    @IBOutlet weak var gradView: UIView!
    let pinIdentifier = "amount_pin_marker"
    
    @IBOutlet weak var filt_Lbl: UILabel!
    @IBOutlet weak var googleMapView : GMSMapView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var roomListView: UIView!
    @IBOutlet weak var roomListCollectionView: UICollectionView!
    @IBOutlet weak var progressLoaderImageView: FLAnimatedImageView!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    var categoryeventTypeID = ""
    
    let mapZoom : Float = 2
    var token = String()
    var googleMarkers = [GMSMarker]()
    var homeListDictArray = [Detail]()
    var currentIndex = Int()
    var nAnnotationSeletedIndex = Int()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var filterMinPrice = Int()
    var filterMaxPrice = Int()
    var filterCount = Int()
    var filterCountLabel = UILabel()
    var filterDict = [String:Any]()
    var filterDictDelegate:MapFilterValuesDelegate?
    var isRoomSelected = Bool()
    var whishListDict : Detail?//[String:Any]()
    var categoryFilterDict = [String:Any]()
    var shouldReloadAPIOnAppear = false
    var isShowFilterOption = Bool()
    var spaceID = Int()
    override func viewWillAppear(_ animated: Bool) {
        
        self.gradView.setGradient([gradient(UIColor.black.withAlphaComponent(0.4), 0.1),
                                   gradient(UIColor.black.withAlphaComponent(0.2), 0.3),
                                   gradient(UIColor.black.withAlphaComponent(0.0), 1)],
                                  GradientPoint.topBottom)
        if filterCount > 0 {
            filterCountLabel.backgroundColor = UIColor.appGuestThemeColor
            filterCountLabel.textColor = UIColor.white
            filterCountLabel.text = "\(filterCount)"
            filterCountLabel.layer.cornerRadius = filterCountLabel.frame.height / 2
            filterCountLabel.clipsToBounds = true
            filterCountLabel.font = UIFont (name: Fonts.CIRCULAR_LIGHT, size: 12)!
            filterCountLabel.textAlignment = .center
            if !(filterView.subviews.contains(filterCountLabel)) {
                filterImageView.isHidden = true
                filterView.addSubview(filterCountLabel)
            }
        }
        else {
            if (filterView.subviews.contains(filterCountLabel)) {
                filterCountLabel.removeFromSuperview()
                filterImageView.isHidden = false
            }
        }
        if self.shouldReloadAPIOnAppear{
            if self.homeListDictArray.allSatisfy({$0.contentType == .room}){//self.isRoomSelected {
                self.wsToGetExploreData(location: "", filterParamDict: self.filterDict)
            }
            else {
                self.wsToGetServiceData(location: "", pageNumber: 1, filterDict: categoryFilterDict)
            }
            self.shouldReloadAPIOnAppear = false
        }
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //insertSublayer(gradient, atIndex: 0) .layer.backgroundColor = Colors().gl as! CGColor
        print("MapViewController")
        if self.homeListDictArray.allSatisfy({$0.contentType == .room})
        {//isRoomSelected {
            filterView.isHidden = false
        }
        else
        {
            filterView.isHidden = true
        }
        if self.isShowFilterOption
        {
            filterView.isHidden = false
        }
        else
        {
            filterView.isHidden = true
        }
        
        filterCount = filterDict["FilterCount"] as? Int ?? Int()
        
        self.addBackButton()
        
        filterCountLabel = UILabel(frame: filterImageView.frame)
        self.filt_Lbl.text = self.lang.filt_Tit
        self.filt_Lbl.textAlignment = .center
        
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        self.navigationController?.isNavigationBarHidden = true
        
        filterView.layer.shadowColor = UIColor.black.cgColor;
        filterView.layer.shadowOffset = CGSize(width:0, height:1.0);
        filterView.layer.shadowOpacity = 0.5;
        filterView.layer.shadowRadius = 2.0;
        filterView.layer.cornerRadius = filterView.frame.size.height/2
        
        let filterTap = UITapGestureRecognizer(target: self, action: #selector(filterDidSelected))
        filterView.addGestureRecognizer(filterTap)
        
        if homeListDictArray.count > 2 {
            
            let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeinRight))
            if self.rawVal == "ar"{
                roomListCollectionView.semanticContentAttribute = .forceRightToLeft
                swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            }else{
                swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            }
            roomListCollectionView.addGestureRecognizer(swipeRight)
            let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeinLeft))
            if self.rawVal == "ar"{
                swipeLeft.direction = UISwipeGestureRecognizer.Direction.right
            }else{
                swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            }
            roomListCollectionView.addGestureRecognizer(swipeLeft)
        }
        
        self.refreshMapMarkers(andFocusItemAt: currentIndex)
        self.refreshMapMarkers(andFocusItemAt: 0)
        self.initPipeLines()
        print("View Did Load Called")
        self.refreshMapMarkers(andFocusItemAt: 0)
    }
    
    /**
     Refresh map with new set of markers highlighting selcted marker with zIndex
     
     - Warning: map camera will be focused to the parsed index
     - Author: Abishek Robin
     - Parameters:
     - selecting: the marker index which has to be selected
     - Returns: void return
     */
    func refreshMapMarkers(andFocusItemAt index : Int){
        self.googleMarkers.forEach({ (marker) in
            marker.map = nil
            marker.iconView = nil
        })
        self.googleMarkers.removeAll()
        self.googleMapView.delegate = self
        for (offset,item) in self.homeListDictArray.enumerated(){
            let marker : GMSMarker
            if self.googleMarkers.compactMap({$0.position}).contains(obj: item.location.coordinate){
                let coords = item.location.coordinate
                marker = GMSMarker(position: CLLocationCoordinate2D(latitude: coords.latitude + 0.00006,
                                                                    longitude: coords.longitude ))
            }else{
                marker = GMSMarker(position: item.location.coordinate)
            }
            
            self.googleMarkers.append(marker)
            //if selected add offset
            marker.zIndex = offset == index ? 5 : 1
            let markerView = PriceMarkerView.initNibView(CGRect(x: 0, y: 0, width: 70, height: 30))
            
            if (item.instantBook == "Yes"){
                let instantPriceVal = Utilities.attributeForInstantBookMap(normalText: item.getMarkerPrice , boldText: "", fontSize: 11.0)
                markerView.setAttributePrice(instantPriceVal)
            }else{
                markerView.setPrice(item.getMarkerPrice)
            }
            print("Price :",item.getMarkerPrice)
            
            markerView.isSelected = offset == index
            marker.map = self.googleMapView
            //            marker.iconView = markerView
            marker.icon = markerView.asImage()
        }
        guard let homeListDict = self.homeListDictArray.value(atSafeIndex: index) else{return}
        let camera = GMSCameraPosition(target: homeListDict.location.coordinate,
                                       zoom: self.mapZoom)
        
        self.googleMapView.animate(to: camera)
        
        nAnnotationSeletedIndex = index
        roomListCollectionView.reloadData()
        let selectedIndex = IndexPath(item: index, section: 0)
        if index == self.homeListDictArray.count - 1{
            roomListCollectionView.scrollToItem(at: selectedIndex, at: .right, animated: true)
        }else{
            roomListCollectionView.scrollToItem(at: selectedIndex, at: .left, animated: true)
        }
    }
    func initPipeLines(){
        _ = PipeLine.createEvent(withName: .reloadView, action: { [weak self] in
            self?.shouldReloadAPIOnAppear = true
        })
    }
    @objc func filterDidSelected() {
        self.wsToGetAmenitiesList()
        
    }
    
    // MARK: - Handle Right Swipe GestureRecognizer
    @objc func handleSwipeinRight(recognizer: UISwipeGestureRecognizer) {
        if currentIndex == 0 {
            return
        }
        if currentIndex >= homeListDictArray.count - 2 {
            currentIndex -= 1
        }
        else
        {
            currentIndex -= 1
            roomListCollectionView.isScrollEnabled = true
            
            roomListCollectionView.setContentOffset(CGPoint(x: (currentIndex==1) ? 175 : 180 * currentIndex,y :0), animated: true)
            roomListCollectionView.isScrollEnabled = false
        }
        roomListCollectionView.isScrollEnabled = true
        let xOrigin = 180 * currentIndex
        
        roomListCollectionView.setContentOffset(CGPoint(x: (xOrigin == 0) ? -15 : xOrigin, y :0), animated: true)
        roomListCollectionView.isScrollEnabled = false
        //        self.selectDetail(atIndex : currentIndex)
        self.refreshMapMarkers(andFocusItemAt: currentIndex)
    }
    
    // MARK: - Handle Left Swipe GestureRecognizer
    @objc func handleSwipeinLeft(recognizer: UISwipeGestureRecognizer) {
        if currentIndex >= homeListDictArray.count - 1 {
            if currentIndex == homeListDictArray.count - 1 {
                currentIndex = homeListDictArray.count - 1
                return
            }
            currentIndex += 1
            return
        }
        if currentIndex >= homeListDictArray.count - 2
        {
            currentIndex += 1
        }
        else
        {
            currentIndex += 1
            roomListCollectionView.isScrollEnabled = true
            roomListCollectionView.setContentOffset(CGPoint(x: (currentIndex==1) ? 175 : 180 * currentIndex,y :0), animated: true)
            roomListCollectionView.isScrollEnabled = false
        }
        //        self.selectDetail(atIndex : currentIndex)
        self.refreshMapMarkers(andFocusItemAt: currentIndex)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        //        if self.homeListDictArray.allSatisfy({$0.contentType == .room}){//} isRoomSelected {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.filterDictDelegate?.exitingMapFilter()
    }
    
    // MARK: - UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeListDictArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapFilterRoomCVC", for: indexPath) as! MapFilterRoomCVC
        let detail = homeListDictArray[indexPath.row]
        cell.titleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.subTitleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.priceLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
       
        
        if detail.contentType == .room{//isRoomSelected {
            if detail.photoName != ""{
                cell.roomImageView.addRemoteImage(imageURL: detail.photoName, placeHolderURL: "")
            }else{
                cell.roomImageView.addRemoteImage(imageURL: detail.roomThumbImage, placeHolderURL: "")
            }
            if detail.categoryName != ""{
                if detail.bedCount > 0 {
                    if detail.bedCount == 1 {
                        cell.titleLabel.text = "\(detail.categoryName) • " + detail.bedCount.description + " \(self.lang.bedd_Title)"
                    }else{
                        cell.titleLabel.text = "\(detail.categoryName) • " + detail.bedCount.description + " \(self.lang.capbed_Title)"
                    }
                }else{
                    cell.titleLabel.text = "\(detail.name) • \(detail.countryName)"
                }
                
            }else{
                if detail.bedCount > 0 {
                    if detail.bedCount == 1 {
                        cell.titleLabel.text = "\(detail.roomType) • " + detail.bedCount.description + " \(self.lang.bedd_Title)"
                    }else{
                        cell.titleLabel.text = "\(detail.roomType) • " + detail.bedCount.description + " \(self.lang.capbed_Title)"
                    }
                }else{
                    cell.titleLabel.text = "\(detail.roomType) • \(detail.countryName)"
                }
            }
            cell.titleLabel.textColor = Utilities.sharedInstance.randomColor(seed: cell.titleLabel.text ?? "")
            if detail.name != ""{
                cell.subTitleLabel.text = detail.name
            }else{
                cell.subTitleLabel.text = detail.roomname
            }
            if (detail.instantBook) == "No" {
                if (detail.price != 0){
                    cell.priceLabel.text = "\(detail.currencySymbol) \(detail.price) \(self.lang.pernight_Title)"
                }else{
                    cell.priceLabel.text = "\(detail.currencySymbol) \(detail.hourly) \(self.lang.pernight_Title)"
                }
            }else {
                if (detail.price != 0){
                    cell.priceLabel.attributedText = Utilities.attributeForInstantBook(normalText:"\(detail.currencySymbol) \(detail.price) \(self.lang.pernight_Title)", boldText: "", fontSize: 11.0)
                }else{
                    cell.priceLabel.attributedText = Utilities.attributeForInstantBook(normalText:"\(detail.currencySymbol) \(detail.hourly) \(self.lang.pernight_Title)", boldText: "", fontSize: 11.0)
                }
            }
        }
        else {
            cell.roomImageView.addRemoteImage(imageURL: detail.photoName, placeHolderURL: "")
            if detail.cityName != ""{
                cell.titleLabel.text = "\(detail.spaceType) • \(detail.cityName)"
            }else{
                cell.titleLabel.text = "\(detail.spaceType)"
            }
            
            cell.titleLabel.textColor = Utilities.sharedInstance.randomColor(seed: cell.titleLabel.text ?? "")
            
            if detail.roomname != ""{
                cell.subTitleLabel.text = detail.roomname
            }else{
                cell.subTitleLabel.text = detail.name
            }
            
            if (detail.instantBook) == "No" {
                if (detail.price != 0){
                    cell.priceLabel.text = "\(detail.currencySymbol) \(detail.price) per hour"
                }else{
                    cell.priceLabel.text = "\(detail.currencySymbol) \(detail.hourly) per hour"
                }
            }else {
                if (detail.price != 0){
                    cell.priceLabel.attributedText = Utilities.attributeForInstantBook(normalText:"\(detail.currencySymbol) \(detail.price) per hour", boldText: "", fontSize: 11.0)
                }else{
                    cell.priceLabel.attributedText = Utilities.attributeForInstantBook(normalText:"\(detail.currencySymbol) \(detail.hourly) per hour", boldText: "", fontSize: 11.0)
                }
            }
        }
        
        cell.selectionLabel.appGuestViewBGColor()
        cell.selectionLabel.isHidden = (indexPath.row == nAnnotationSeletedIndex) ? false : true
        
        let reviewCount = (detail.reviewsCount)
        if reviewCount > 0 {
            cell.ratingLabel.text = MakentSupport().createRatingStar(ratingValue: detail.rating.description as NSString) as String
            if reviewCount > 1 {
                cell.reviewCountLabel.text = "\(reviewCount)" //\(self.lang.revs_Title)
            }else{
                cell.reviewCountLabel.text = "\(reviewCount)" //\(self.lang.rev_Title)
            }
            cell.ratingLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            cell.reviewCountLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        }
        else {
            cell.ratingLabel.text = ""
            cell.reviewCountLabel.text = ""
        }
//        cell.layer.cornerRadius = 3.0
        cell.roomImageView.cornerRadius = 75
        if Language.getCurrentLanguage().isRTL {
            cell.roomImageView.layer.maskedCorners = .layerMinXMinYCorner
        } else {
            cell.roomImageView.layer.maskedCorners = .layerMaxXMinYCorner
        }
        
        cell.grayView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        if  detail.isWishlist == "Yes" {
            cell.whishListButtonOutlet.setImage(UIImage(named: "heart_selected"), for: .normal)
        }
        else {
            cell.whishListButtonOutlet.setImage(UIImage(named: "heart_normal"), for: .normal)
        }
        cell.whishListButtonOutlet.addTarget(self, action: #selector(whishListSelected), for: .touchUpInside)
        cell.ratingLabel.appGuestTextColor()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailDict = homeListDictArray[indexPath.row]
        let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
        if detailDict.spaceid != 0 {
            homeDetailVC.roomIDString = String(describing: detailDict.spaceid)
        }
        else {
            homeDetailVC.roomIDString = String(describing: detailDict.id)
        }
        homeDetailVC.strCityName = detailDict.cityName
        homeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeDetailVC, animated: true)
        
        
    }
    
    @objc func whishListSelected(sender: UIButton) {
        if let cell = sender.superview?.superview as? MapFilterRoomCVC {
            let indexPath = roomListCollectionView.indexPath(for: cell)
            self.spaceID = indexPath!.row
            whishListDict = homeListDictArray[(indexPath?.row)!]
            if whishListDict?.contentType == .room
            {
                whishListDict!.type = "Rooms"
            }
            else
            {
                whishListDict!.type = "Experiences"
            }
            if SharedVariables.sharedInstance.userToken.count == 0 {
                let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                mainPage.hidesBottomBarWhenPushed = true
                let nav = UINavigationController(rootViewController: mainPage)
                self.present(nav, animated: true, completion: nil)
            }
            else{
                
                if sender.imageView?.image == UIImage(named: "heart_selected") {
                    if whishListDict!.spaceid != 0 {
                        wsToRemoveRoomFromWishList(strRoomID: "\(String(describing: whishListDict!.spaceid))", list_type: whishListDict!.type)
                    }
                    else  if whishListDict!.spaceid  != 0 {
                        wsToRemoveRoomFromWishList(strRoomID: "\(String(describing: whishListDict!.spaceid))", list_type: whishListDict!.type)
                    }
                }
                else {
                    wsToGetWhishList(exploreDict: whishListDict!)
                }
            }
        }
    }
    
    func wsToGetWhishList(exploreDict:Detail) {
        
        if SharedVariables.sharedInstance.userToken.count > 0 {
            var paramDict = [String:Any]()
            paramDict["token"] = SharedVariables.sharedInstance.userToken
            WebServiceHandler.sharedInstance.getToWebService(wsMethod: "get_wishlist", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
                print(responseDict)
                
                if Utilities.sharedInstance.confirmAsInt(value: responseDict["status_code"]) > 0 && (Utilities.sharedInstance.unWrapDictArray(value: responseDict["wishlist_data"])).count > 0 {
                    let addWhishListVC = StoryBoard.account.instance.instantiateViewController(withIdentifier: "AddWhishListVC") as! AddWhishListVC
                    addWhishListVC.delegate = self
                    
                    addWhishListVC.listType = exploreDict.contentType == .room ? "Rooms" : "Experiences"
                    //exploreDict.type//["type"] as? String ?? ""
                    addWhishListVC.strRoomName = exploreDict.cityName//["name"] as? String ?? ""
                    if exploreDict.id != 0{
                        //["id"] {
                        addWhishListVC.strRoomID = exploreDict.id.description
                    }
                    else if exploreDict.spaceid != 0{
                        //["room_id"] {
                        addWhishListVC.strRoomID = exploreDict.spaceid.description
                    }
                    let whishListModelArray = MakentSeparateParam().separateParamForGetWishlist(params: responseDict as NSDictionary) as! GeneralModel
                    //                    addWhishListVC.arrWishListData = NSMutableArray(array: Utilities.sharedInstance.unWrapDictArray(value: responseDict["wishlist_data"]))
                    addWhishListVC.arrWishListData = whishListModelArray.arrTemp1
                    addWhishListVC.view.backgroundColor = UIColor.clear
                    addWhishListVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(addWhishListVC, animated: true, completion: nil)
                }
                else {
                    let createWhishListVC = StoryBoard.account.instance.instantiateViewController(withIdentifier: "CreateWhishList") as! CreateWhishList
                    //createWhishListVC.strRoomName = (exploreModel?.city_name as String?)!
                    //createWhishListVC.strRoomID = (exploreModel?.room_id as String?)!
                    createWhishListVC.strRoomName = exploreDict.cityName
                    createWhishListVC.listType = "Rooms"
                    createWhishListVC.delegate = self
                    self.present(createWhishListVC, animated: false, completion: nil)
                }
            }
        }
    }
    
    internal func onAddWhisListTapped(index:Int)
    {
        //        if !isSimilarTapped
        //        {
        //            self.updateWishListIcon(strStatus: "Yes")
        //        }
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAddedInWhishlist"), object: self, userInfo: nil)
        //        self.isSimilarlistTapped = true
        //        self.wsToGetRoomDetails(roomID: self.roomIDString)
        
        if self.homeListDictArray.allSatisfy({$0.contentType == .room}){//self.isRoomSelected {
            self.wsToGetExploreData(location: "", filterParamDict: self.filterDict)
        }
        else {
            self.wsToGetServiceData(location: "", pageNumber: 1, filterDict: categoryFilterDict)
        }
    }
    
    func wsToRemoveRoomFromWishList(strRoomID : String ,list_type: String) {
        print("Map Remove Filter",strRoomID)
        //        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [String: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["space_id"]   = strRoomID
        dicts["list_type"]   = list_type
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_DELETE_WISHLIST, paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                if self.homeListDictArray.allSatisfy({$0.contentType == .room}){//self.isRoomSelected {
                    self.wsToGetExploreData(location: "", filterParamDict: self.filterDict)
                }
                else {
                    self.wsToGetServiceData(location: "", pageNumber: 1, filterDict: self.categoryFilterDict)
                }
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
    
    func wsToGetExploreData(location: String, filterParamDict:[String:Any] = [String:Any]()) {
        
        var paramDict = [String:Any]()
        
        paramDict["page"] = "1"
        paramDict["token"] = SharedVariables.sharedInstance.userToken
        if filterParamDict.count > 0 {
            for key in filterParamDict.keys {
                paramDict[key] = filterParamDict[key]
            }
        }
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "explore", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            // print(responseDict)
            print(responseDict)
            if responseDict["status_code"]  as? String ?? String() != "0" {
                if let dict = responseDict["data"] as? [JSONS]{
                    self.homeListDictArray.removeAll()
                    
                    dict.forEach({ (json) in
                        let model = Detail(json)
                        self.homeListDictArray.append(model)
                    })
                    self.refreshMapMarkers(andFocusItemAt: 0)
                }
                //                self.homeListDictArray = responseDict["data"] as! [Detail]
                self.filterMinPrice = responseDict["min_price"] as? Int ?? Int()
                self.filterMaxPrice = responseDict["max_price"] as? Int ?? Int()
                self.roomListCollectionView.reloadData()
                //            self.variantListDictArray = responseDict["Lists"] as? [[String:Any]] ?? [[String:Any]]()
            }
            else {
                Utilities.showAlertMessage(message: responseDict["success_message"] as? String ?? String(), onView: self)
            }
        }
    }
    
    func wsToGetServiceData(location: String, pageNumber: Int, filterDict: [String:Any] = [String:Any]())
    {
        print("WebserviceToGetServiceData")
        var paramDict = [String:Any]()
        paramDict["page"] = pageNumber
        paramDict["token"] = SharedVariables.sharedInstance.userToken
        paramDict.merge(dict: filterDict)
        var indexPath: IndexPath?
        
        //WebServiceHandler.sharedInstance.getToWebService(wsMethod: METHOD_EXPLORE_EXPERIENCE, paramDict:
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "explore", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            // print(responseDict)
            print(responseDict)
            if responseDict["status_code"]  as? String ?? String() != "0" {
                
                if let dict1 = responseDict["data"] as? [[String : Any]] {
                    self.homeListDictArray.removeAll()
                    dict1.forEach({ (json) in
                        let model = Detail(json)
                        self.homeListDictArray.append(model)
                    })
                    indexPath = IndexPath(row: self.spaceID, section: 0)
                    self.roomListCollectionView.reloadItems(at: [indexPath!])
                }
            }
            else {
                print("Else Conditions")
            }
        }
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
                filterVC.minPrice = self.filterMinPrice
                filterVC.maxPrice = self.filterMaxPrice
                filterVC.filterResponse = responseDict
                filterVC.eventTypeID = self.categoryeventTypeID
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
    
    func didSelectFilterOptions(filterDict: [String : Any]) {
        print("didSelectFilterOptions")
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
        self.filterDictDelegate?.didReceiveMapFilter(filterDict: filterDict)
    }
    
    func checkHomeOrOther(tempModel:Detail) -> String
    {
        if SharedVariables.sharedInstance.homeType == HomeType.home
        {
            return tempModel.spaceid.description != "0" ? tempModel.spaceid.description : tempModel.spaceid.description
        }
        else
        {
            return tempModel.spaceid.description
        }
    }
    
    func onCreateNewWishList(listName: String, privacy: String, listType: String) {
        print("\(listName) \(privacy) \(listType)")
        
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["space_id"]   = self.checkHomeOrOther(tempModel: whishListDict!)
        dicts["list_name"]   = listName.replacingOccurrences(of: "%20", with: " ")
        dicts["privacy_settings"]   = privacy
        dicts["list_type"]   = listType
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ADD_TO_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    self.onAddWhisListTapped(index: 1)
                }
                else
                {
                    Utilities.sharedInstance.createToastMessage(gModel.success_message as String, isSuccess: false, viewController: self)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        AppDelegate.sharedInstance.logOutDidFinish()
                        return
                    }
                }
                OperationQueue.main.addOperation {
                    MakentSupport().removeProgressInWindow(viewCtrl: self)
                }
                self.viewDidLoad()
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                Utilities.sharedInstance.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false, viewController: self)
            }
        })
    }
    
}
extension MapFilterViewController : GMSMapViewDelegate, CategorySelectable{
    
    func didSelectCategory(categories: [HostExperienceCategories]) {
        SharedVariables.sharedInstance.homeType = HomeType.experiance
        let categoryIdCollection:[String] = categories.compactMap{$0.internalIdentifier?.description}
        let categoryValues = categoryIdCollection.joined(separator: ",")
        filterDict["category"] = categoryValues
        self.backButtonAction(self.closeButtonOutlet)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let index = self.googleMarkers.find(includedElement: {$0 == marker}) else{return false}
        //        self.selectDetail(atIndex : index)
        self.refreshMapMarkers(andFocusItemAt: index)
        return false
    }
    
}
extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
