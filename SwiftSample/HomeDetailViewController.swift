/**
 * RoomDetailPage.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import MessageUI
import Social

protocol RoomDetailPageDelegate
{
    func updateExploreData(strStatus: String)
    func selectedDates()
}
extension UICollectionView {
    var currentIndexPath:IndexPath? {
        get{
            var visibleRect = CGRect()

            visibleRect.origin = self.contentOffset
            visibleRect.size = self.bounds.size

            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

            guard let indexPath = self.indexPathForItem(at: visiblePoint) else { return nil }
            
         
            return indexPath
            
        }
    }
}
    

class RoomPropertyTVC: UITableViewCell {
    
    @IBOutlet weak var spaceSizeTypeImgView: UIImageView!
    @IBOutlet weak var guestImgView: UIImageView!
    @IBOutlet weak var spaceTypeImgView: UIImageView!
    @IBOutlet weak var guestCountLabel: UILabel!
    @IBOutlet weak var spaceTypeLbl: UILabel!
    @IBOutlet weak var spaceSizeTypeLbl: UILabel!
 
}

class RoomAmenitiesListTVC: UITableViewCell {
    
    @IBOutlet weak var amenities4ImageView: UIImageView!
    @IBOutlet weak var amenities3ImageView: UIImageView!
    @IBOutlet weak var amenities2ImageView: UIImageView!
    @IBOutlet weak var amenities1ImageView: UIImageView!
    @IBOutlet weak var amenityCountLabel: UILabel!
    
    var totalAmenitieList = [Amenities]()
    
    func setAmenitiesDetails() {
        print("Amenities",totalAmenitieList.count)
        if totalAmenitieList.count > 0 {
            self.amenities1ImageView.setupImageViewHideOrShow(isHide: false)
            self.amenities2ImageView.setupImageViewHideOrShow(isHide: false)
            self.amenities3ImageView.setupImageViewHideOrShow(isHide: false)
            self.amenities4ImageView.setupImageViewHideOrShow(isHide: false)
            self.amenityCountLabel.isHidden = false
            amenities1ImageView.addRemoteImage(imageURL: totalAmenitieList[0].imageName, placeHolderURL: "")
            if totalAmenitieList.count > 1 {
                amenities2ImageView.addRemoteImage(imageURL: totalAmenitieList[1].imageName, placeHolderURL: "")
            }else {
                self.amenities2ImageView.setupImageViewHideOrShow(isHide: true)
            }
            if totalAmenitieList.count > 2 {
                amenities3ImageView.addRemoteImage(imageURL: totalAmenitieList[2].imageName, placeHolderURL: "")
            }else {
                self.amenities3ImageView.setupImageViewHideOrShow(isHide: true)
            }
            if totalAmenitieList.count > 3 {
                amenities4ImageView.addRemoteImage(imageURL: totalAmenitieList[3].imageName, placeHolderURL: "")
            }else {
                self.amenities4ImageView.setupImageViewHideOrShow(isHide: true)
            }
            if totalAmenitieList.count >= 4 {
                if (totalAmenitieList.count - 4) == 0
                {
                    self.amenityCountLabel.isHidden = true
                }
                else
                {
                    self.amenityCountLabel.text = "+\(totalAmenitieList.count - 4)"
                }
            }else {
                self.amenityCountLabel.isHidden = true
            }
        }
        else
        {
            self.amenities1ImageView.setupImageViewHideOrShow(isHide: true)
            self.amenities2ImageView.setupImageViewHideOrShow(isHide: true)
            self.amenities3ImageView.setupImageViewHideOrShow(isHide: true)
            self.amenities4ImageView.setupImageViewHideOrShow(isHide: true)
            self.amenityCountLabel.isHidden = true
        }
    }
}

extension UIImageView {
    func setupImageViewHideOrShow(isHide:Bool) {
        self.isHidden = isHide
    }
}
class ImageScrollCVC : UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
    
}
class HomeDetailViewController : UIViewController,UITableViewDelegate, UITableViewDataSource, WWCalendarTimeSelectorProtocol, SimilarListDelegate,RulesDelegate,AmenitiesCellDelegate,addWhisListDelegate,createdWhisListDelegate,ViewOfflineDelegate, SGSegmentedProgressBarDataSource, SGSegmentedProgressBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    var isFirstTime = false
    var lastContentOffset: CGFloat = 0
    
    var numberOfSegments: Int {
        return sampleImageArray.count
    }
    
    var segmentDuration: TimeInterval = 3
    
    var paddingBetweenSegments: CGFloat {
        return (sampleImageArray.count > 10) ? 3 : 5
    }
    
    var trackColor: UIColor {
        return UIColor.white.withAlphaComponent(0.2)
    }
    
    var progressColor: UIColor{
        return UIColor.white
    }
    
    var roundCornerType: SGCornerType{
        return .roundCornerBar(cornerRadious: 5)
    }
    func segmentedProgressBarFinished(finishedIndex: Int, isLastIndex: Bool) {
        var index = Int()
        print("finishied Index: \(finishedIndex)")
        if isFirstTime{
            index = 0
        }else{
            SharedVariables.sharedInstance.isFormAppdelefateFirstTime = false
            index = finishedIndex + 1
        }
        
        if finishedIndex == sampleImageArray.count - 1{
            index = 0
            SharedVariables.sharedInstance.isFormAppdelefateFirstTime = true
            self.segMentBar?.restart()
            imgCollectionView.reloadData()
        }
        isFirstTime = false
        self.imgCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        print("finishedIndex: \(finishedIndex)")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sampleImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageScrollCVC", for: indexPath) as! ImageScrollCVC
        cell.imgView.addRemoteImage(imageURL: sampleImageArray[indexPath.row], placeHolderURL: "")
        
        cell.imgView.contentMode = .scaleToFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let width = imageHeaderView.frame.width
        let yourHeight = imageHeaderView.frame.height
        print("::: width = \(width), hight = \(yourHeight)")
        return CGSize(width: width, height: yourHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func onRulesBlocksTapped(index: Int, title: String)
    {
    }
    //  @IBOutlet var roomDeatailHeaderImageScrollView: UIScrollView!
    //  @IBOutlet var checkAvalabilityButtonOutlet: UIButton!
    
    @IBOutlet var featureCollectionViewHeader: UIView!
    
    @IBOutlet weak var footerLineView: UIView!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet var imgFirstPage: UIImageView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var viewNavHeader: UIView?
    @IBOutlet var viewBottomHolder: UIView!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    @IBOutlet var btnWhishList: UIButton!
    @IBOutlet var btnWhishListH: UIButton!
    @IBOutlet var btnBookRoom: UIButton?
    @IBOutlet var animatedImageView: FLAnimatedImageView?
    @IBOutlet var animatedImgBooking: FLAnimatedImageView?
    
    // Mark:New Outlet Connections
    @IBOutlet weak var roomDetailBottomView: UIView!
    @IBOutlet weak var checkAvalabilityButtonOutlet:UIButton!
    @IBOutlet var lblReviewValue: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblRoomPrice: UILabel!
    @IBOutlet weak var roomDetailTableView: UITableView!
    
    @IBOutlet weak var bookButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var roomDetailTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var roomDeatailHeaderImageScrollView: UIScrollView!
    
    @IBOutlet var imageHeaderView: UIView!
    var strCheckInDate = ""
    var strCheckOutDate = ""
    var strCityName = ""
    var arrRoomData : NSMutableArray = NSMutableArray()
    var timerAutoScroll = Timer()
    
    var nCurrentIndex : Int = 0
    var roomIDString:String = ""
    var strShareUrl:String = ""
    var gothis:String = ""
    var isFromHostAddRoom : Bool = false
    var isSimilarlistTapped : Bool = false
    var isSimilarTapped : Bool = false
  //  var modelRoomDetails : RoomDetailModel!
    var modelRoomDetails : SpaceDetailData!
//    var roomDetailDict = [String:Any]()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    //    var wishListDetailsArray = [WishlistData]()
    var arrlengthStayData : NSMutableArray = NSMutableArray()
    var arrEarlybirdData : NSMutableArray = NSMutableArray()
    var arrLastMinData : NSMutableArray = NSMutableArray()
    var availability : NSMutableArray = NSMutableArray()
    var arraminities : NSMutableArray = NSMutableArray()
    fileprivate var singleDate: Date = Date()
    var multipleDates: [Date] = []
    var delegate: RoomDetailPageDelegate?
    var arrimg = ["A","B","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    var roomRulesTitle = [String]()
    var arrTitle = [String]()
    var arrTitleCheck = [String]() 
    var token = ""
     var totalBeds = Int()
    var detailAllignTitleArray = [String]()
    var whishListDict = BasicListDetails()
    var sampleImageArray = [String]()
    var featureArray = [DetailSectionHeader]()
    var segMentBar : SGSegmentedProgressBar?
    //create a globar uiview array
    var myProgressView = [ProgressIndicatorView]()
    var blockedDates = [String]()
    var bunchDays = [String]()
    var availabilityTimes   = [AvailabilityTime]()
    var notAvailableDays = [String]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        print("Home detail view controller")
        checkAvalabilityButtonOutlet.appGuestBGColor()
        //.backgroundColor =  k_AppThemeColor
        //lblRating?.backgroundColor =  k_AppThemeColor
//        self.navigationController?.isNavigationBarHidden = true
        //        checkAvalabilityButtonOutlet.titleLabel?.numberOfLines = 0
        //        checkAvalabilityButtonOutlet.titleLabel?.text = "Instant Book"
        checkAvalabilityButtonOutlet.titleLabel?.textAlignment = .center
        checkAvalabilityButtonOutlet.layer.cornerRadius = 5.0
        self.wsToGetRoomDetails(roomID: roomIDString)
        roomDeatailHeaderImageScrollView.backgroundColor = UIColor.lightGray
        roomDetailTableView.tableHeaderView = imageHeaderView
        roomDetailTableView.tableFooterView = UIView()
        roomDetailTableView.delegate = self
        roomDetailTableView.dataSource = self
//        self.viewBottomHolder?.isHidden = true
//        let rect = UIScreen.main.bounds as CGRect
//        var rectEmailView = roomDetailTableView.frame
//        rectEmailView.size.height = rect.size.height-(viewBottomHolder?.frame.size.height)!
//        roomDetailTableView.frame = rectEmailView
        roomDetailBottomView?.layer.shadowColor = UIColor.gray.cgColor;
        roomDetailBottomView?.layer.shadowOffset = CGSize(width:0, height:1.0);
        roomDetailBottomView?.layer.shadowOpacity = 1.5;
        roomDetailBottomView?.layer.shadowRadius = 2.0;

    }
    func navigationCustom(isApiCalled: Bool) {
        let sender = UIButton(type: .custom)
        sender.transform = self.getAffine
        sender.addTarget(self, action: #selector(self.onBackTapped(_:)), for: .touchUpInside)
        let likeButton1 = UIButton(type: .custom)
        likeButton1.addTarget(self, action: #selector(self.wishListButtonTapped(sender:)), for: .touchUpInside)
        
        let shareButton1 = UIButton(type: .custom)
        shareButton1.addTarget(self, action: #selector(self.onShareButtonTapped), for: .touchUpInside)
        
        print("Wishlist",modelRoomDetails.wishList)
        if isApiCalled {
            print("is api called")
            if (modelRoomDetails.wishList) != "Yes" {
                likeButton1.setImage(UIImage(named: "heart_normal"), for: .normal)
                self.addNavigationButtons(sender: [sender,likeButton1,shareButton1], senderTitle: ["f","","^"], senderFontName: [Fonts.MAKENT_LOGO_FONT1,Fonts.MAKENT_LOGO_FONT1,Fonts.MAKENT_LOGO_FONT2], senderTitleColor: [k_AlphaThemeColor,.darkGray,.darkGray])
            } else {
                likeButton1.setImage(UIImage(named: "heart_selected"), for: .normal)
                self.addNavigationButtons(sender: [sender,likeButton1,shareButton1], senderTitle: ["f","","^"], senderFontName: [Fonts.MAKENT_LOGO_FONT1,Fonts.MAKENT_LOGO_FONT1,Fonts.MAKENT_LOGO_FONT2], senderTitleColor: [k_AlphaThemeColor,k_AppThemeColor,.darkGray])
            }
        } else {
            print("is api not called")
            self.addNavigationButtons(sender: [sender,likeButton1,shareButton1], senderTitle: ["f","B","^"], senderFontName: [Fonts.MAKENT_LOGO_FONT1,Fonts.MAKENT_LOGO_FONT1,Fonts.MAKENT_LOGO_FONT2], senderTitleColor: [k_AlphaThemeColor,.darkGray,.darkGray])
        }
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.wsToGetRoomDetails(roomID: self.roomIDString)
    }
    
    // MARK: ***** ROOM DETAIL API CALL *****
    /*
     Here Getting Room Details
     */
    func wsToGetRoomDetails(roomID:String)
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        var dicts = [String: Any]()
        dicts["token"] = SharedVariables.sharedInstance.userToken
        //dicts["room_id = roomID
        dicts["space_id"] = roomID
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "space", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict ) in
            print("room details",responseDict)
            if responseDict.statusCode == 1
            {
                
                var responseTrunkDict = responseDict
                for (i,dict) in (responseTrunkDict["the_space"] as! [[String:Any]]).enumerated().reversed() {
                    if let value = (dict["value"] as? NSString)?.intValue,
                        value == 0,
                        (dict["value"] as? String)?.count == 1 {
                        var spaceDictArray = responseTrunkDict["the_space"] as! [[String:Any]]
                        let index = spaceDictArray.index(after: i)
                        spaceDictArray.remove(at: index - 1)
                        responseTrunkDict["the_space"] = spaceDictArray
                    }
                }
//                let preModel = SpaceDetailData(json: responseDict)
                let preModel = SpaceDetailData(json: responseTrunkDict)
                print("Model",preModel.spacePhoto)
//               for i in 0 ..< preModel.spacePhoto.count
//               {
//                self.sampleImageArray.append(preModel.spacePhoto[i].name)
//               }
                self.modelRoomDetails = SpaceDetailData(json: responseTrunkDict)
                
                self.featureArray = self.modelRoomDetails.getFeaturesData()
                
                
                self.availabilityTimes =  self.modelRoomDetails.availabilityTimes
               // let day = [String]()
                self.notAvailableDays.removeAll()
                for i in 0...self.availabilityTimes.count - 1 {
                    if self.availabilityTimes[i].status == "Closed" {
                        self.notAvailableDays.append(self.availabilityTimes[i].dayType)
                    }
                }
                if self.notAvailableDays.count > 0 {
                    for i in 0...self.notAvailableDays.count - 1 {
                        self.notAvailableDays[i] = "\(Int(self.notAvailableDays[i])! + 1)"
                    }
                }
             
                self.blockedDates = self.modelRoomDetails.notAvailableDates
                
                self.arrTitle.removeAll()
                self.arrTitleCheck.removeAll()
                self.arrTitle.append(self.lang.cancelpolicy_Title)
                self.arrTitleCheck.append(preModel.cancellationPolicy)
                if Constants().GETVALUE(keyname: APPURL.USER_ID) as String != self.modelRoomDetails.userId.description {
                    self.arrTitle.append(self.lang.conthost_Title)
                    self.arrTitleCheck.append(self.lang.mssg_Titt)
                }
                print("similarlisting",preModel.similarList.count)
                self.roomDetailTableView.reloadData()
                self.navigationCustom(isApiCalled: true)
                
//                self.setTableHeaderImages(imageArray: self.modelRoomDetails.spacePhoto.compactMap({$0.name}))
                self.imgCollectionView.delegate = self
                self.imgCollectionView.dataSource = self
                self.setUpSegmentBar()
                self.setRoomsInformation()
            }
            else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
            }
        }
    }
    
//    func disableScrollsToTopPropertyOnAllSubviewsOf(view: UIView) {
//        for subview in view.subviews {
//            if let scrollView = subview as? UIScrollView {
//                (scrollView as UIScrollView).scrollsToTop = false
//            }
//            self.disableScrollsToTopPropertyOnAllSubviewsOf(view: subview as UIView)
//        }
//    }
    
    func checkSameUser() -> Bool {
        if (Constants().GETVALUE(keyname: APPURL.USER_ID) as String != "\((modelRoomDetails.userId))" as String) {
            return true
        }
        return false
    }
    
    func addBottomView() {
        self.roomDetailTableViewBottomConstraint.constant = 74
        if !self.view.subviews.contains(self.roomDetailBottomView) {
            var frame = self.roomDetailBottomView.frame
            frame = CGRect(x: 0, y: self.roomDetailTableView.frame.height - 26, width: self.view.frame.width, height: 74)
            self.roomDetailBottomView.frame = frame
            self.view.addSubview(self.roomDetailBottomView)
        }
        
        self.roomDetailBottomView.isHidden = false
    }
    
    func removeBottomView() {
        self.roomDetailTableViewBottomConstraint.constant = 0
        self.roomDetailBottomView.isHidden = true
        self.roomDetailBottomView.removeFromSuperview()
    }
    
    func setRoomsInformation()
    {
        if (Constants().GETVALUE(keyname: APPURL.USER_ID) as String == "\((modelRoomDetails.userId))" as String)
        {
            self.removeBottomView()
        }
        else
        {
            self.addBottomView()
        }
        lblRating?.appGuestTextColor()
        lblReviewValue?.appGuestTextColor()
        
        lblReviewValue?.text = "\((modelRoomDetails.reviewCount))" == "0" ? "" : "\((modelRoomDetails.reviewCount))"
        
        lblRating?.isHidden = ("\((modelRoomDetails.reviewCount))" == "0" || "\((modelRoomDetails.reviewCount))" == "") ? true : false
        self.setButtonTitle()
        
        
//            ("\((modelRoomDetails.review_count as? Int ?? Int()))" == "0" || "\((modelRoomDetails.review_count as? Int ?? Int()))" == "")
        if Int(modelRoomDetails.reviewCount) == 0 {
            var rectEmailView = lblRoomPrice?.frame
            rectEmailView?.size.height = 40
            lblRoomPrice?.frame = rectEmailView!
        }
        else
        {
            let rateVal = modelRoomDetails.rating
            lblRating?.text = MakentSupport().createRatingStar(ratingValue: rateVal as NSString) as String
            lblRating.appGuestTextColor()
            lblRating.appGuestTextColor()
        }
        let orginalTxt = "\(Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL)) \(modelRoomDetails.hourly) \(self.lang.per_Hours)"
        lblRoomPrice?.attributedText = MakentSupport().addAttributeFont(originalText: orginalTxt, attributedText: modelRoomDetails.hourly.description, attributedFontName: Fonts.CIRCULAR_BOOK, attributedColor: lblRoomPrice.textColor, attributedFontSize: 18)
    }
    
    func setButtonTitle()  {
        var buttonTitle = String()
        if !self.checkButtonText() {
            buttonTitle = self.lang.checkavail_Title
            self.bookButtonWidthConstraint.constant = 145
        }
        else if modelRoomDetails.instantBook == "Yes" {
            buttonTitle = self.lang.insbook_Title
            self.bookButtonWidthConstraint.constant = 130
        } else {
            buttonTitle = self.lang.reqbook_Title
            self.bookButtonWidthConstraint.constant = 140
        }
        self.checkAvalabilityButtonOutlet.setTitle(buttonTitle, for: .normal)
        //        self.checkButtonWidthConstraint.constant = CGFloat(buttonTitle.count * 9)
        self.checkAvalabilityButtonOutlet?.isHidden = (modelRoomDetails.canBook == "Yes") ? false : true
    }
    
    func resetView()
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "back")
        userDefaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
//        self.roomDetailTableView.setContentOffset(.zero, animated: true)
//        self.roomDetailTableView.scrollToTop() == No
      //  self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        print("viewwillappear",roomIDString)
        self.wsToGetRoomDetails(roomID: roomIDString)
        if MakentSupport().isPad()
        {
            NotificationCenter.default.addObserver(self, selector: #selector(self.adjustSubViewFrames), name: UIDevice.orientationDidChangeNotification, object: nil)
            self.adjustSubViewFrames()
            
        }
    }
   
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        timerAutoScroll.invalidate()
        
//        self.navigationController?.isNavigationBarHidden = false
        //        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: ------ ADJUST FRAMES FOR IPAD
    /*
     Here Adjusting Table Headerview while rotation happening
     */
    @objc func adjustSubViewFrames()
    {
        let rect = MakentSupport().getScreenSize()
        
        var rectEmailView = tblHeaderView.frame
        rectEmailView.size.width = rect.size.width
        rectEmailView.size.height = 500
        tblHeaderView.frame = rectEmailView
        
        roomDetailTableView.reloadData()
    }
    
    func setHeaderInfomation()
    {
        
    }
    
    func wsToGetWhishList(exploreDict:BasicListDetails) {
        
        if SharedVariables.sharedInstance.userToken.count > 0 {
            var paramDict = [String:Any]()
            paramDict["token"] = SharedVariables.sharedInstance.userToken
            
            WebServiceHandler.sharedInstance.getToWebService(wsMethod: "get_wishlist", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
                print(responseDict)
                
                if Utilities.sharedInstance.confirmAsInt(value: responseDict["status_code"]) > 0 && (Utilities.sharedInstance.unWrapDictArray(value: responseDict["wishlist_data"])).count > 0 {
                    self.whishListDict.spaceId = exploreDict.spaceId
                    let addWhishListVC = StoryBoard.account.instance.instantiateViewController(withIdentifier: "AddWhishListVC") as! AddWhishListVC
                    addWhishListVC.delegate = self
                    addWhishListVC.listType = exploreDict.type
                    addWhishListVC.strRoomName = exploreDict.name
//                    if let id = exploreDict.spaceId {
                        addWhishListVC.strRoomID = exploreDict.spaceId.description
//                    }
//                    else if let id = exploreDict["room_id"] {
//                        addWhishListVC.strRoomID = "\(String(describing: id))"
//                    }
                    if let city = self.modelRoomDetails.locationData?.city as? String{
                        addWhishListVC.strRoomName = city
                    }
//                    else if let cityname = self.modelRoomDetails.city_name as? String{
//                        addWhishListVC.strRoomName = cityname
//                    }
                    let whishListModelArray = MakentSeparateParam().separateParamForGetWishlist(params: responseDict as NSDictionary) as! GeneralModel
                    //                    addWhishListVC.arrWishListData = NSMutableArray(array: Utilities.sharedInstance.unWrapDictArray(value: responseDict["wishlist_data))
                    addWhishListVC.arrWishListData = whishListModelArray.arrTemp1
                    addWhishListVC.view.backgroundColor = UIColor.clear
                    addWhishListVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(addWhishListVC, animated: true, completion: nil)
                    
                }
                else {
                    let createWhishListVC = StoryBoard.account.instance.instantiateViewController(withIdentifier: "CreateWhishList") as! CreateWhishList
                    self.segMentBar?.pause()
                        createWhishListVC.strRoomID = exploreDict.spaceId.description
                    self.whishListDict.spaceId = exploreDict.spaceId
                    if let city = self.modelRoomDetails.locationData?.city as? String{
                    createWhishListVC.strRoomName = city
                    }
//                    else if let cityname = self.modelRoomDetails.city_name as? String{
//                    createWhishListVC.strRoomName = cityname
//                    }
                    //createWhishListVC.strRoomID = (exploreModel?.room_id as String?)!
                    createWhishListVC.listType = "Rooms"
                    createWhishListVC.delegate = self
                    self.present(createWhishListVC, animated: false, completion: nil)
                }
            }
        }
    }
    
    func wsToRemoveRoomFromWishList(strRoomID : String ,list_type: String, sender : UIButton)
    {
        
        // MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        print("Remove wishlist space id",strRoomID)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["space_id"]   = strRoomID
        dicts["list_type"]   = list_type
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_DELETE_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                //                DispatchQueue.main.async {
                ////                    MakentSupport().removeProgressInWindow(viewCtrl: self)
                //                    MakentSupport().removeProgress(viewCtrl: self)
                //                }
                if gModel.status_code == "1" {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
////                        self.getRoomsAndExperienceList()
//                    })
                    self.viewDidLoad()
                    sender.isUserInteractionEnabled = true
                    return
                }
                else {
                    if gModel.status_code == "0" && gModel.success_message == "Wishlists Not Found"
                    {
                        // self.updateWishListIcon(strStatus: "No")
                    }
                    else
                    {
                        Utilities.sharedInstance.createToastMessage(gModel.success_message as String, isSuccess: false, viewController: self)
                        if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed" {
                            AppDelegate.sharedInstance.logOutDidFinish()
                            return
                        }
                    }
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                Utilities.sharedInstance.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false, viewController: self)
            }
        })
    }
    
    //MARK: -------------------------------------------------------------------
    
    // MARK: CELL SIMILAR LIST DELEGATE METHODS
    internal func onSimilarListTapped(strRoomID: String)
    {
        //        let roomDetailView = StoryBoard.guest.instance.instantiateViewController(withIdentifier: "RoomDetailPage") as! RoomDetailPage
        //        roomDetailView.strRoomID = strRoomID
        //        let navController = UINavigationController(rootViewController: roomDetailView)
        //        self.present(navController, animated:true, completion: nil)
        
        //   self.navigationController?.pushViewController(roomDetailView, animated: true)
        
        let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
        homeDetailVC.roomIDString = strRoomID
        homeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeDetailVC, animated: true)
    }
    
    internal func onWishList(index: Int, sender: UIButton)
    {
        if modelRoomDetails == nil{
            return
        }
        isSimilarTapped = true
        
        whishListDict = modelRoomDetails.similarList[index]
        
        if SharedVariables.sharedInstance.userToken.count == 0 {
            let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            
            mainPage.hidesBottomBarWhenPushed = true
            //            appDelegate.lastPageMaintain = "explore"
            let nav = UINavigationController(rootViewController: mainPage)
            self.present(nav, animated: true, completion: nil)
        }
        else{
            print("Else conditions")
            if sender.imageView?.image == UIImage(named: "heart_selected") {
              //  wsToRemoveRoomFromWishList(strRoomID: whishListDict.spaceId.description, list_type: whishListDict.type)
                wsToRemoveRoomFromWishList(strRoomID: whishListDict.spaceId.description, list_type: whishListDict.type, sender: sender)
                sender.isUserInteractionEnabled = false
            }
            else {
                wsToGetWhishList(exploreDict: whishListDict)
            }
        }
        
    }
    
    //MARK: CREATE NEW WISHLIST DELEGATE METHOD
    func onCreateNewWishList(listName: String, privacy: String, listType: String) {
        print("\(listName) \(privacy) \(listType)")
        
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
//        let room_id = "\(String(describing: whishListDict["room_id"] ?? "0"))"
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["space_id"]   = whishListDict.spaceId.description
        dicts["list_name"]   = listName.replacingOccurrences(of: "%20", with: " ")
        dicts["privacy_settings"]   = privacy
        dicts["list_type"]   = listType
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ADD_TO_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    SharedVariables.sharedInstance.lastWhistListRoomId = self.whishListDict.spaceId
                    
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
    
    //MARK: CELL REVIEW DELEGATE METHOD
    internal func onReviewListTapped(index: Int) {
        let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "ReviewDetailVC") as! ReviewDetailVC
        viewHouseRule.hidesBottomBarWhenPushed = true
        viewHouseRule.strRoomId = modelRoomDetails.spaceId.description
        present(viewHouseRule, animated: true, completion: nil)
    }
    
    //MARK: CELL AMENITIES DELEGATE METHOD
    internal func onAmenitiesTapped(index:Int)
    {
        print("onAmenitiesTapped")
        let viewHouseRule = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AmenitiesVC") as! AmenitiesVC
        viewHouseRule.hidesBottomBarWhenPushed = true
        //viewHouseRule.arrCurrentAmenities.addObjects(from: (modelRoomDetails.amenities_values as NSArray) as! [Any])
        present(viewHouseRule, animated: true, completion: nil)
    }
    
    //MARK: CELL ROOM DETAIL DELEGATE METHOD
    internal func onHostProfileTapped()
    {
        print("On host Prifile Clicked")
        let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        viewProfile.strOtherUserId = String(describing: modelRoomDetails.userId)
        viewProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewProfile, animated: true)
    }
    // MARK: ------ CONVERT PRICE FORMAT --------
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = "IND"
        if #available(iOS 9.0, *) {
            formatter.numberStyle = NumberFormatter.Style.currencyAccounting
        } else {
            // Fallback on earlier versions
        }
        return formatter
    }()
    
    func showCalander()
    {
        print("Checkavailability")
        let selector = k_MakentStoryboard.instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector
        if checkAvalabilityButtonOutlet?.titleLabel?.text == self.lang.insbook_Title
        {
            gothis = "1"
        }
        else
        {
            gothis = "2"
        }
        appDelegate.day = "1"
        appDelegate.gothis = "1"
        //selector.car_Id = "\(modelRoomDetails.room_id)" as String
        selector.room_Id = modelRoomDetails.spaceId.description
        selector.btntype = gothis
        selector.callAPI = true
        //selector.showPickuptime = true
        selector.delegate = self
        
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(SharedVariables.sharedInstance.multipleDates)
        appDelegate.multipleDates = SharedVariables.sharedInstance.multipleDates
        
        
        selector.arrBlockedDates.removeAll()
        if self.notAvailableDays.count > 0 {
            selector.notAvailableDays.append(contentsOf: self.notAvailableDays)
        }
        if self.blockedDates.count > 0 {
            selector.arrBlockedDates.append(contentsOf: self.blockedDates)
            //(from: self.blockedDates as [Any])
        }
//        if (modelRoomDetails.blocked_dates as? [String] ?? [String]()).count > 0 {
//            selector.arrBlockedDates.addObjects(from:(modelRoomDetails.blocked_dates as? [String] ?? [String]()))
//        }
        //        if (modelRoomDetails.reserved_dates as? [String] ?? [String]()).count > 0 {
        //            selector.arrBlockedDates.addObjects(from: (modelRoomDetails.reserved_dates as? [String] ?? [String]()))
        //        }
        selector.optionCurrentDateRange.setStartDate(SharedVariables.sharedInstance.multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(SharedVariables.sharedInstance.multipleDates.last ?? singleDate)
        selector.optionSelectionType = .range
        
        //        self.present(selector, animated: true, completion: nil)
        let navController = UINavigationController(rootViewController: selector)
       // self.present(navController, animated:true, completion: nil)
        self.navigationController?.pushViewController(selector, animated: true)
    }
    func conactOwner() {
        if checkAvalabilityButtonOutlet?.titleLabel?.text == self.lang.insbook_Title
        {
            gothis = "1"
        }
        else
        {
            gothis = "2"
        }
        if SharedVariables.sharedInstance.userToken == ""
        {
            let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            let navController = UINavigationController(rootViewController: mainPage)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {
            let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ContactHostVC") as! ContactHostVC
            appDelegate.btntype = self.gothis
//            contactView.strHostUserName = modelRoomDetails.host_user_name as String
//            contactView.strHostThumbUrl = modelRoomDetails.host_user_image as String
//            contactView.strHostUserId = (modelRoomDetails.host_user_id as? Int ?? Int()).description
                //"\(modelRoomDetails.host_user_id)" as String
            //contactView.modelRoomDetails = modelRoomDetails
//            contactView.delegate = self
//            contactView.strRoomID = "\(modelRoomDetails.roomid)" as String
            contactView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(contactView, animated: true)
        }
    }
    func checkButtonText() -> Bool {
//                if appDelegate.multipleDates.count > 0 && SharedVariables.sharedInstance.pickup_time.count > 0 && SharedVariables.sharedInstance.return_time.count > 0 {
//                    return true
//                }
        if checkAvalabilityButtonOutlet.titleLabel?.text == self.lang.reqbook_Title || checkAvalabilityButtonOutlet.titleLabel?.text == self.lang.Book_Now {
            return true
        }
        return false
    }
    
    // MARK: CHECK ROOMS AVAILABILITY
    @IBAction func onCheckAvailabilityTapped(_ sender:UIButton!)
    {

            let eventView     = k_MakentStoryboard.instantiateViewController(withIdentifier: "EventVCID") as! EventViewController
            eventView.spaceID = self.roomIDString
        
        eventView.arrBlockedDates = self.blockedDates
        eventView.notAvailableDays = self.notAvailableDays
            eventView.spaceDetails = self.modelRoomDetails
            print("Instant Book",self.modelRoomDetails.instantBook)
            eventView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(eventView, animated: true)
    }
    
   
    
    // MARK: ****** WWCalendar Delegate Methods ******
    
    internal func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    {
        appDelegate.multipleDates = dates
        //        appDelegate.page = "1"
         self.wsToGetRoomDetails(roomID: self.roomIDString)
        let formalDates = dates
        //        appDelegate.multipleDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd-MM-yyy"
        strCheckInDate = dateFormatter.string(from: startDay)
        strCheckOutDate = dateFormatter.string(from: lastDay!)
        
        if appDelegate.day == "1"{
            appDelegate.s_date = strCheckInDate
            appDelegate.e_date = strCheckOutDate
        }
        if modelRoomDetails.instantBook == "Yes"
        {
            UserDefaults.standard.set(lang.insbook_Title, forKey: "BookingType")
            checkAvalabilityButtonOutlet?.setTitle(self.lang.insbook_Title, for: UIControl.State.normal)
        }
        else
        {
            UserDefaults.standard.set(lang.reqbook_Title, forKey: "BookingType")
            checkAvalabilityButtonOutlet?.setTitle(self.lang.reqbook_Title, for: UIControl.State.normal)
        }
        checkAvalabilityButtonOutlet.appGuestBGColor()
        
    }
    // MARK: ------ CREATE TABLE HEADER IMAGES
    /*
     Here we are adding UIImageView according to Image count
     Then adding subview of ScrollView
     */
    func setTableHeaderImages(imageArray : [String]) {
//        print("ImageArray",imageArray[0])
        self.sampleImageArray = imageArray
        if imageArray.count == 0
        {
            return
        }
        for view in roomDeatailHeaderImageScrollView.subviews
        {
            view.removeFromSuperview()
        }
        var xPosition:CGFloat = 0
        
        let newView = UIView()
        newView.backgroundColor = UIColor.clear
        roomDeatailHeaderImageScrollView.superview?.addSubview(newView)
        roomDeatailHeaderImageScrollView.superview?.bringSubviewToFront(newView)
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.bottomAnchor.constraint(equalTo: self.roomDeatailHeaderImageScrollView.bottomAnchor, constant: -20).isActive = true
        newView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        newView.widthAnchor.constraint(equalTo: self.roomDeatailHeaderImageScrollView.widthAnchor, constant: -40).isActive = true

        newView.leadingAnchor.constraint(equalTo: self.roomDeatailHeaderImageScrollView.leadingAnchor, constant: 20).isActive = true
        newView.trailingAnchor.constraint(equalTo: self.roomDeatailHeaderImageScrollView.trailingAnchor, constant: -20).isActive = true
        let stackViewIndi = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-60, height: 10))

        stackViewIndi.axis  = NSLayoutConstraint.Axis.horizontal
        
        stackViewIndi.alignment = .fill
        stackViewIndi.spacing = 2
        stackViewIndi.distribution = .fill
        stackViewIndi.translatesAutoresizingMaskIntoConstraints = false
        stackViewIndi.backgroundColor = .lightGray
        newView.addSubview(stackViewIndi)
        newView.bringSubviewToFront(stackViewIndi)
      
        stackViewIndi.bottomAnchor.constraint(equalTo: newView.bottomAnchor, constant: 0).isActive = true
        stackViewIndi.heightAnchor.constraint(equalToConstant: 5).isActive = true
        stackViewIndi.widthAnchor.constraint(equalTo: newView.widthAnchor, constant: 0).isActive = true
        stackViewIndi.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 0).isActive = true
        stackViewIndi.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: 0).isActive = true
        stackViewIndi.center = newView.center
        print("ImageArray",imageArray)
        for i in 0 ..< imageArray.count {
            print("For inside Imagearray",imageArray[i])
            let myImage = UIImage(named: imageArray[i] )
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            myImageView.frame =  CGRect(x: xPosition, y:0, width: roomDeatailHeaderImageScrollView.frame.size.width+1 ,height: roomDeatailHeaderImageScrollView.frame.size.height)
            let myButton:UIButton = UIButton()
            myButton.frame =  CGRect(x: xPosition, y:0, width: self.view.frame.size.width ,height: roomDeatailHeaderImageScrollView.frame.size.height)
            myButton.tag = i
            myButton.addTarget(self, action: #selector(self.onImageTapped), for: .touchUpInside)
            
            roomDeatailHeaderImageScrollView.addSubview(myImageView)
            roomDeatailHeaderImageScrollView.addSubview(myButton)
            xPosition += roomDeatailHeaderImageScrollView.frame.size.width
            myImageView.addRemoteImage(imageURL: imageArray[i], placeHolderURL: "")
           
            
            let width = (self.view.frame.width+stackViewIndi.spacing)-40
            let viewIndicator = HomeDetailViewController.instanceFromNib(nibName: "ProgressIndicatorView") as! ProgressIndicatorView
            
            viewIndicator.progressBarWidth.constant = (width/CGFloat(imageArray.count))
            self.myProgressView.append(viewIndicator)
            stackViewIndi.addArrangedSubview(viewIndicator)
        }
        if imageArray.isEmpty || imageArray.count == 1
        {
             self.myProgressView.removeAll()
            stackViewIndi.isHidden = true
            newView.isHidden = true
        }
        let widht = CGFloat(self.view.frame.size.width) * CGFloat(imageArray.count)
        roomDeatailHeaderImageScrollView.contentSize = CGSize(width: widht, height:  roomDeatailHeaderImageScrollView.frame.size.height)
        
        timerAutoScroll = Timer.scheduledTimer(timeInterval: Double(myProgressView.count/2)+0.5, target: self, selector: #selector(self.makeAutoScrollAnimation), userInfo: nil, repeats: true)
        roomDeatailHeaderImageScrollView.isUserInteractionEnabled = true
    }
    func setUpSegmentBar () {
        self.sampleImageArray = self.modelRoomDetails.spacePhoto.compactMap({$0.name})
        if self.sampleImageArray.count > 1{
            if self.segMentBar == nil {
                let newRect = CGRect(x: self.imageHeaderView.frame.origin.x + 5, y: self.imageHeaderView.frame.height - 30, width: self.imageHeaderView.frame.width - 10, height: 3)
                let rect = CGRect(x: self.imageHeaderView.frame.origin.x + 10 , y:self.imageHeaderView.frame.origin.y , width: self.segmentView.frame.size.width - 20, height: 3)
                self.segmentView.frame = newRect
                self.segMentBar = SGSegmentedProgressBar(frame: rect, delegate: self, dataSource: self)
                self.segmentView.addSubview(self.segMentBar!)
                self.imageHeaderView.bringSubviewToFront(self.segmentView!)
                self.segmentView.bringSubviewToFront(self.segMentBar!)
                self.segMentBar?.start()
            }
        
        }
    }
    @objc func setProgressBar(currentIndex : Int)
    {
//        if let indexArray = self.modelRoomDetails.room_images as? [String] ,indexArray.count > 1 {
//            self.myProgressView[currentIndex].progressBar.setProgress(1.0,animated:true)
//        }
        let divisor = myProgressView.count/2
        print("Total index", myProgressView.count)
        if (self.nCurrentIndex > currentIndex+divisor)
        {
          return
        }else if self.sampleImageArray.count > 1 {
                        self.myProgressView[currentIndex+divisor].progressBar.setProgress(1.0,animated:true)
                        print(currentIndex+divisor,"Progress")
                }
            }
    
    @objc func makeAutoScrollAnimation()
    {

        if self.sampleImageArray.count == 0
        {
            return
        }
           
    DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
        UIView.animate(withDuration: Double(self.myProgressView.count/2), delay: 0, options: [.curveLinear], animations: { () -> Void in
            let rect = MakentSupport().getScreenSize()
            self.roomDeatailHeaderImageScrollView.setContentOffset(CGPoint(x: rect.size.width * CGFloat(self.nCurrentIndex), y: 0), animated: true)
            self.myProgressView[self.nCurrentIndex].progressBar.layoutIfNeeded()
        }, completion: { (finished: Bool) -> Void in
            if finished {
                self.setProgressBar(currentIndex: self.nCurrentIndex)
                if (self.nCurrentIndex > self.myProgressView.count/2 - 1)
                {
                    self.nCurrentIndex = 0
                    for i in 0..<self.myProgressView.count
                    {
                        self.myProgressView[i].progressBar.setProgress(0.0,animated:false)
                    }
                } else {
                    self.nCurrentIndex += 1
                }
            }
        })
    })
    }
    
    // MARK: ------ IMAGE VIEW FOR ROOM HEADER IMAGES --------
    @objc func onImageTapped(sender:UIButton)
    {
        let photoBrowser = SYPhotoBrowser(imageSourceArray: self.sampleImageArray, caption: "", delegate: self)
        photoBrowser?.initialPageIndex = UInt(sender.tag)
        photoBrowser?.pageControlStyle = SYPhotoBrowserPageControlStyle.label
        photoBrowser?.enableStatusBarHidden = false
        self.present((photoBrowser)!, animated: true, completion: nil)
    }
    
    // MARK: SHARE BUTTON ACTION
    @objc func onShareButtonTapped() {
        if modelRoomDetails == nil{
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [self.getDefaultShareContent()], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    
    func getDefaultShareContent() -> NSString
    {
            let shareContent = String(format:"\(self.lang.checkout_Awesom) \(k_AppName.capitalized): \(modelRoomDetails.name)\n\(modelRoomDetails.spaceUrl )")
        return shareContent as NSString
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {


        if let indexPath = self.imgCollectionView.currentIndexPath {

            DispatchQueue.main.async {
                self.segMentBar?.move(to: indexPath.row)
            }
            self.lastContentOffset = scrollView.contentOffset.x
        }
    }
    // MARK: BACK BUTTON ACTION
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.segMentBar?.pause()
        print("onBack Button Tapped")
        SharedVariables.sharedInstance.multipleDates.removeAll()
//        timerAutoScroll = Timer.invalidate()
        timerAutoScroll.invalidate()
    
        self.appDelegate.pricepertnight = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        modelRoomDetails = nil
        roomDetailTableView = nil
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ---------------------------------------------------------------
    //MARK: ***** Room Detail Table view Datasource Methods *****
    /*
     Room Detail List View Table Datasource & Delegates
     */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if modelRoomDetails != nil
        {
            if modelRoomDetails.similarList.count > 0
            {
                return 3
            }
            else
            {
                 return 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection",modelRoomDetails)
        if modelRoomDetails == nil {
            return 0
        }
        if section == 0 {
            print("number of sections")
            var returnValue = 3
            detailAllignTitleArray.removeAll()
            detailAllignTitleArray = [self.lang.abt_Tit, self.lang.prop_Tit, self.lang.descript_Title]
//            if self.checkBedsTypes() {
//                returnValue += 1
//                detailAllignTitleArray.append(self.lang.sleep_Tit)
//            }
            returnValue += 1
            detailAllignTitleArray.append(self.lang.space_Tit)
            
            returnValue += 1
            detailAllignTitleArray.append(self.lang.festievnt_Tit)
            if self.modelRoomDetails.amenities.count > 0 {
                returnValue += 1
                detailAllignTitleArray.append(self.lang.ament_Tit)
            }
//            returnValue += 1
//            detailAllignTitleArray.append(self.lang.ament_Tit)
            
            returnValue += 1
            detailAllignTitleArray.append(self.lang.features_Tit)
            
            returnValue += 1
            detailAllignTitleArray.append(self.lang.available_TimeTit)
           
            returnValue += 1
            detailAllignTitleArray.append(self.lang.smap_Tit)
            if let model = self.modelRoomDetails {
                let reviewUser = model.reviewUserName
                let reviewCount = model.reviewCount
                if( reviewCount != 0 && !reviewUser.isEmpty) {
//                !((modelRoomDetails?.reviewCount) != nil) == 0 && !modelRoomDetails.reviewUserName.isEmpty {
                returnValue += 1
                detailAllignTitleArray.append(self.lang.rev_Title)
                }
            }
            print("Return values",returnValue)
            return returnValue
        }
        else if section == 1
        {
            return arrTitle.count
        }
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("uitableview index",indexPath)
        let cell:OwnerTitleTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "ownerTitleTVC")! as! OwnerTitleTVC
        if indexPath.section == 0 {
            print("indexpath section", indexPath.section)
            // cell.delegate = self
            // detailAllignTitleArray = ["About", "Property", "Description", "Amenity", "Map", "Review
            cell.ownerTitleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            
            if detailAllignTitleArray[indexPath.row] == self.lang.abt_Tit {
                print("about title")
                cell.displayOwnerDetails(roomDetailDict: modelRoomDetails)
                return cell
            }
            else if detailAllignTitleArray[indexPath.row] == self.lang.prop_Tit {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "roomPropertyTVC") as! RoomPropertyTVC
                cell.spaceTypeLbl.customFont(.medium)
                cell.spaceSizeTypeLbl.customFont(.medium)
                cell.guestCountLabel.customFont(.medium)
                cell.spaceSizeTypeLbl.text = "\(modelRoomDetails.squareFeet)\(modelRoomDetails.sizeType)"
                cell.spaceTypeLbl.text = "\(modelRoomDetails.theSpace[0].name)"
                cell.guestCountLabel.text = "\(modelRoomDetails.theSpace[1].name) \(self.lang.people_title)"//"\(roomDetailDict.string("no_of_beds"))"

                return cell
            }
            else if detailAllignTitleArray[indexPath.row] == self.lang.descript_Title {
                print("Title",self.lang.descript_Title)
                let cell = tableView.dequeueReusableCell(withIdentifier: "aboutServiceTVC")
                let aboutLabel = cell?.contentView.viewWithTag(2) as! UILabel
                let abtlbl_Text = cell?.contentView.viewWithTag(1) as! UILabel
                abtlbl_Text.text = self.lang.abt_SerTit
                aboutLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                
                let str = modelRoomDetails.summary
                let nsString = str as NSString
                if nsString.length >= 100
                {
                        print("SplitedText",nsString.substring(with: NSRange(location: 0, length: nsString.length > 100 ? 100 : nsString.length)))
                        
                        aboutLabel.text = nsString.substring(with: NSRange(location: 0, length: nsString.length > 100 ? 100 : nsString.length)) + self.lang.redmore_Title
                    
                     aboutLabel.attributedText = MakentSupport.instance.addAttributeText(originalText: aboutLabel.text!, attributedText: self.lang.redmore_Title, attributedColor: UIColor.appTitleColor)
                }
                else
                {
                    aboutLabel.text = modelRoomDetails.summary
//                     aboutLabel.attributedText = MakentSupport.instance.addAttributeText(originalText: aboutLabel.text!, attributedText: self.lang.redmore_Title, attributedColor: UIColor.appTitleColor)
                }
                //aboutLabel.text = (modelRoomDetails.room_detail) + self.lang.redmore_Title
               
                return cell!
            }
            
            else if detailAllignTitleArray[indexPath.row] == self.lang.ament_Tit {
                print("Title",self.lang.ament_Tit)
                let cell = roomDetailTableView.dequeueReusableCell(withIdentifier: "roomAmenitiesListTVC")! as! RoomAmenitiesListTVC
                cell.amenityCountLabel.appGuestTextColor()
                cell.totalAmenitieList = modelRoomDetails.amenities
                cell.setAmenitiesDetails()
                return cell
            }
                
            else if detailAllignTitleArray[indexPath.row] == self.lang.space_Tit {
                let cell:FeaturesTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "FeaturesTVC")! as! FeaturesTVC
                cell.spaceDetailsModel = modelRoomDetails
                cell.selectedTitleValues = .theSpace
                cell.addedHeaderTitle()
                cell.featureCV.reloadData()
                cell.featureCVheight.constant = cell.featureCV.collectionViewLayout.collectionViewContentSize.height
                cell.featureCV.reloadData()
                //cell.displayReviewDetails(roomDetailDict: roomDetailDict)
                return cell
            }
            
            else if detailAllignTitleArray[indexPath.row] == self.lang.festievnt_Tit
            {
                print("Festival Title")
                let cell:FestivalTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "FestivalTVC")! as! FestivalTVC
                cell.priceParentView.addTap {
                    self.showAlertView(sender: cell.priceParentView)
                }
                cell.priceTitleLbl.text = self.lang.price_title
                cell.festivalData = modelRoomDetails
                cell.festivalCVC.reloadData()
                cell.festivalHeightCVC.constant = cell.festivalCVC.collectionViewLayout.collectionViewContentSize.height
                cell.festivalCVC.reloadData()
                return cell
            }

            else if detailAllignTitleArray[indexPath.row] == self.lang.features_Tit {
                print("Title",self.lang.features_Tit)
                let cell:FeaturesTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "FeaturesTVC")! as! FeaturesTVC
                cell.spaceDetailsModel = modelRoomDetails
                cell.selectedTitleValues = .features
                cell.delegate = self
                cell.headerTitleArray = self.featureArray
                cell.featureCV.reloadData()
                cell.featureCVheight.constant = cell.featureCV.collectionViewLayout.collectionViewContentSize.height
                cell.featureCV.reloadData()
               
                return cell
            }
                
            else if detailAllignTitleArray[indexPath.row] == self.lang.available_TimeTit {
               
                let cell:FeaturesTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "FeaturesTVC")! as! FeaturesTVC
                cell.spaceDetailsModel = modelRoomDetails
                cell.selectedTitleValues = .theSpaceAvailability
                cell.addedHeaderTitle()
                cell.featureCV.reloadData()
                cell.featureCVheight.constant = cell.featureCV.collectionViewLayout.collectionViewContentSize.height
                cell.featureCV.reloadData()
                //cell.displayReviewDetails(roomDetailDict: roomDetailDict)
                return cell
            }
//
            else if detailAllignTitleArray[indexPath.row] == self.lang.smap_Tit {
                print("Title",self.lang.smap_Tit)
                let cell:OwnerDetailMapTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "ownerDetailMapTVC")! as! OwnerDetailMapTVC
                cell.setMapInfo(roomDetailDict: modelRoomDetails)
                return cell
            }
            
            else if detailAllignTitleArray[indexPath.row] == self.lang.rev_Title {
                print("Title",self.lang.rev_Title)
                let cell:OwnerReviewTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "ownerReviewTVC")! as! OwnerReviewTVC
                cell.displayReviewDetails(roomDetailDict: modelRoomDetails)
                return cell
            }
//            else
//            {
//                print("Title","No Titles")
//                let cell:FeaturesTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "FeaturesTVC")! as! FeaturesTVC
//                //cell.displayReviewDetails(roomDetailDict: roomDetailDict)
//                return cell
//            }
        }
        if indexPath.section == 1 {
            let cell = roomDetailTableView.dequeueReusableCell(withIdentifier: "carListTVC") as! CarListTVC
            //            let  serviceListLabel = cell?.contentView.viewWithTag(1) as! UILabel
            //            let serviceCheckLabel = cell?.contentView.viewWithTag(2) as! UILabel
            cell.titleLabel.text = arrTitle[indexPath.row]
            cell.titleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            cell.descriptionLabel.text = arrTitleCheck[indexPath.row]
            cell.descriptionLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            return cell
        }
        else if indexPath.section == 2 {
            print("Third Sections")
            
            let cell:SimilarListTVC = roomDetailTableView.dequeueReusableCell(withIdentifier: "similarListTVC")! as! SimilarListTVC
            cell.delegate = self
            print("similarList",modelRoomDetails.similarList.count)
            if modelRoomDetails.similarList.count > 0
            {
                cell.similarListDictArray = modelRoomDetails
                cell.currencyCode = modelRoomDetails.currencyCode as NSString
                cell.similarListTitleLabel.text = self.lang.simlist_Title
                cell.similarListTitleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.similarListCollectionView.reloadData()
            }
            return cell
        }
        
        return cell
        
    }
    
    func showAlertView(sender:UIView){
        
//        let imageEdit = k_MakentStoryboard.instantiateViewController(withIdentifier: "PricePopUpViewController") as! PricePopUpViewController
//        imageEdit.modalPresentationStyle = .popover
//        imageEdit.popupText = "Hia dsfs fjslfjalf fdslf dsfkls ljls flsdfsfkl dsjfkl"
//        let height = MakentSupport().onGetStringHeight(sender.frame.size.width, strContent: imageEdit.popupText as NSString, font: UIFont(name: Fonts.CIRCULAR_BOOK, size: 16)!)
//        imageEdit.preferredContentSize = CGSize(width: sender.frame.size.width + 20, height: height+30)
//        if let popover: UIPopoverPresentationController = imageEdit.popoverPresentationController {
//            popover.delegate = self
//            let barBtnItem =  UIBarButtonItem(customView: sender)
//            popover.barButtonItem = barBtnItem
//            popover.permittedArrowDirections = .down
//            popover.sourceView = sender
//            popover.sourceRect = sender.frame
//        }
//        self.present(imageEdit, animated: true, completion: nil)
        self.showTimeFilter(startTimeView: sender)
        
    }
    
    func dynamicHeight(tempModelArray:[BedTypeModel],_ width:CGFloat) -> CGFloat{
        var text = ""
        let textArray = tempModelArray.map({"\($0.count) \($0.name)".count})
        if let index = tempModelArray.index(where:{"\($0.count) \($0.name)".count == textArray.max()}){
            text = "\(tempModelArray[index].count) \(tempModelArray[index].name)"
        }
        let customWidth = width
        let customHeight = text.heightWithConstrainedWidth(width: customWidth, font: UIFont(name: Fonts.CIRCULAR_BOLD, size: 13.0)!) + customWidth + 5
        
        return customHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    //MARK: ---- Table View Delegate Methods ----
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            if detailAllignTitleArray[indexPath.row] == self.lang.abt_Tit {
                self.onHostProfileTapped()
            }
            else if detailAllignTitleArray[indexPath.row] == self.lang.descript_Title {
                
//                let storyBoard = UIStoryboard(name: "DetailDescripition", bundle: nil)
//                let descriptionDetailVC = storyBoard.instantiateViewController(withIdentifier: "DescriptionsDetailPageVC") as! DescriptionsDetailPageVC
//
//                descriptionDetailVC.arrTempDescription = [modelRoomDetails.room_detail as? String ?? "
//                descriptionDetailVC.arrTempTitle = ["Detail
//                //                descriptionDetailVC.navTitle = "Details Description"
//                let navController = UINavigationController(rootViewController: descriptionDetailVC)
//                self.present(navController, animated:true, completion: nil)
                onReadMoreTapped()
            }
            else if detailAllignTitleArray[indexPath.row] == self.lang.rev_Title {
                let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "ReviewDetailVC") as! ReviewDetailVC
                viewHouseRule.hidesBottomBarWhenPushed = true
                viewHouseRule.strRoomId = "\(modelRoomDetails.spaceId)"
                present(viewHouseRule, animated: true, completion: nil)
            }
            else if detailAllignTitleArray[indexPath.row] == self.lang.ament_Tit {
                print("AmenitiesVC did select")
                let viewHouseRule = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AmenitiesVC") as! AmenitiesVC
                viewHouseRule.hidesBottomBarWhenPushed = true
//                viewHouseRule.arrCurrentAmenities.addObjects(from: (modelRoomDetails.amenities_values as? NSArray ?? NSArray()) as! [Any])
//                viewHouseRule.arrCurrentAmenities.addObjects(from: (self.modelRoomDetails.amenities as? NSArray ?? NSArray()) as! [Any])
                viewHouseRule.arrCurrentAmenities = self.modelRoomDetails.amenities
                present(viewHouseRule, animated: true, completion: nil)
            }
        }
        else if indexPath.section == 1 {
            //            let descriptionDetailVC = self.storyboard!.instantiateViewController(withIdentifier: "DescriptionsDetailPageVC") as! DescriptionsDetailPageVC
            if indexPath.row == 0 {
                let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
                viewWeb.hidesBottomBarWhenPushed = true
                viewWeb.strPageTitle = self.lang.cancelpolicy_Title
                viewWeb.strCancellationFlexible = ((modelRoomDetails.cancellationPolicy ) == "Flexible") ? CancelPolicy.flexible.instance : ((modelRoomDetails.cancellationPolicy ) == "Moderate") ? CancelPolicy.moderate.instance : CancelPolicy.strict.instance
                self.navigationController?.pushViewController(viewWeb, animated: true)
            }
            if arrTitle[indexPath.row] == self.lang.conthost_Title || arrTitle[indexPath.row] == self.lang.cnthst_Tit {
                
                if checkAvalabilityButtonOutlet?.titleLabel?.text == self.lang.insbook_Title
                {
                    gothis = "1"
                }
                else{
                    gothis = "2"
                }
                if appDelegate.userToken == "" {
                    let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                    appDelegate.lastPageMaintain = "contact"
                    let navController = UINavigationController(rootViewController: mainPage)
                    self.present(navController, animated:true, completion: nil)
                    
                }
                else{
                    let eventView     = k_MakentStoryboard.instantiateViewController(withIdentifier: "EventVCID") as! EventViewController
                    eventView.spaceID = self.roomIDString
                    eventView.arrBlockedDates = self.blockedDates
                    eventView.spaceDetails = self.modelRoomDetails
                    eventView.isFromContactHost = true
                    print("Instant Book",self.modelRoomDetails.instantBook)
                    eventView.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(eventView, animated: true)
//                    let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ContactHostVC") as! ContactHostVC
//                    appDelegate.btntype = self.gothis
////                    contactView.strRoomType = modelRoomDetails.room_type
//                    contactView.btntype = gothis
//                    contactView.strHostUserName = modelRoomDetails.hostName
//                    contactView.strHostThumbUrl = modelRoomDetails.hostProfilePic
//
////                    contactView.strHostUserId = modelRoomDetails.id
//
//
////                    contactView.strHostUserId = roomDetailDict.int("host_user_id").description
//
////                    contactView.blockedDates = (modelRoomDetails.blocked_dates as? [String])
//                    contactView.strTotalGuest = modelRoomDetails.numberOfGuests.description
//                    contactView.strRoomId = modelRoomDetails.spaceId.description
//                    contactView.hidesBottomBarWhenPushed = true
//                    self.navigationController?.pushViewController(contactView, animated: true)
                }
            }
            else if arrTitle[indexPath.row] == self.lang.availb_Tit {
                showCalander()
            }
            else if arrTitle[indexPath.row] == self.lang.houserules_Title {
                
//                let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "RoomsHouseRules") as! RoomsHouseRules
//                viewHouseRule.hidesBottomBarWhenPushed = true
//                viewHouseRule.isFromRoomDetails = true
//                viewHouseRule.strHouseRules = modelRoomDetails.house_rules
//                viewHouseRule.strHostUserName = modelRoomDetails.hostName
//                present(viewHouseRule, animated: true, completion: nil)
            }
            else if arrTitle[indexPath.row] == self.lang.additionalprice_Title // ADDITIONAL PRICE
            {
//                let viewAdditionalPrice = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AdditionalPrice") as! AdditionalPrice
//                let currencySymbol = (modelRoomDetails.currencySymbol ).stringByDecodingHTMLEntities
//                let strAdditionalGuest = String(format:"%@ %@",currencySymbol,modelRoomDetails.numberOfGuests)
//                let strweekly_price = String(format:"%@ %@",currencySymbol,modelRoomDetails.hourly)
//                let strmonthly_price = String(format:"%@ %@",currencySymbol,modelRoomDetails.monthly_price)
//                let strsecurity_deposit = String(format:"%@ %@",currencySymbol,modelRoomDetails.security_deposit)
//                let strcleaning_fee = String(format:"%@ %@",currencySymbol,modelRoomDetails.cleaning_fee)
//                var arrTemp = [String]()
//                var arrTempTitle = [String]()
//                var arrTempOffer = [String]()
//
//                if modelRoomDetails.additional_guests != "0" && modelRoomDetails.additional_guests != ""
//                {
//                    arrTemp.append(strAdditionalGuest)
//                    arrTempTitle.append("Extra People")
//                }
//
//                if modelRoomDetails.weekly_price != "0" && modelRoomDetails.weekly_price != ""
//                {
//                    arrTemp.append(strweekly_price)
//                    arrTempTitle.append("Weekend Price")
//                }
//
//                if modelRoomDetails.monthly_price != "0" && modelRoomDetails.monthly_price != ""
//                {
//                    arrTemp.append(strmonthly_price)
//                    arrTempTitle.append("Monthly Price")
//                }
//
//                if modelRoomDetails.security_deposit != "0" && modelRoomDetails.security_deposit != ""
//                {
//                    arrTemp.append(strsecurity_deposit)
//                    arrTempTitle.append("Security Deposit")
//                }
//
//                if modelRoomDetails.cleaning_fee != "0" && modelRoomDetails.cleaning_fee != ""
//                {
//                    arrTemp.append(strcleaning_fee)
//                    arrTempTitle.append("Cleaning Fee")
//                }
//                viewAdditionalPrice.arrSpecialPrices = arrTempTitle
//                viewAdditionalPrice.extrapeople = strAdditionalGuest
//                viewAdditionalPrice.security = strsecurity_deposit
//                viewAdditionalPrice.cleaningfee = strcleaning_fee
//                viewAdditionalPrice.arrlengthStayData = arrlengthStayData
//                viewAdditionalPrice.arrRoomTypeData = arrlengthStayData as NSArray
//                viewAdditionalPrice.arrLastMinData = arrLastMinData
//                viewAdditionalPrice.arrEarlybirdData = arrEarlybirdData
//                viewAdditionalPrice.arrPrices = arrTemp
//                viewAdditionalPrice.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewAdditionalPrice, animated: true)
            }
            else if arrTitle[indexPath.row] == self.lang.triplength_Title {
//                let viewAdditionalPrice = self.storyboard?.instantiateViewController(withIdentifier: "TripLengthVC") as! TripLengthVC
//                let maximumStay = "\(modelRoomDetails.maximum_stay ?? "")"
//                let minimamstay = "\(modelRoomDetails.minimum_stay ?? "")"
//                var arrTemp = [String]()
//                var arrTempTitle = [String]()
//                var arrTempOffer = [String]()
//
//                if minimamstay != "" && minimamstay != " "
//                {
//                    arrTemp.append(minimamstay)
//                    arrTempTitle.append("Minimum Stay")
//                }
//                if maximumStay != "" && maximumStay != " "
//                {
//                    arrTemp.append(maximumStay)
//                    arrTempTitle.append("Maximum Stay")
//                }
//                if availability.count != 0 {
//                    arrTemp.append("")
//                    arrTempTitle.append("Availability")
//                }
//                viewAdditionalPrice.arrSpecialPrices = arrTempTitle
//                viewAdditionalPrice.arrPrices = arrTemp
//                viewAdditionalPrice.availability = availability
//                viewAdditionalPrice.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewAdditionalPrice, animated: true)
            }
            
        }
    }
    
    func onReadMoreTapped()
    {
        var arrTempDescription = [String]()
        var arrTempTitle = [String]()
        let getStoryBoardName = "DetailDescripition"
        let storyBoard : UIStoryboard = UIStoryboard(name: getStoryBoardName, bundle: nil)
        let viewHouseRule = storyBoard.instantiateViewController(withIdentifier: "DescriptionsDetailPageVC") as! DescriptionsDetailPageVC
        viewHouseRule.hidesBottomBarWhenPushed = true
        
        /// This is for show the
        if modelRoomDetails.summary != "" {
            arrTempTitle.append(self.lang.det_Title)
            arrTempDescription.append(modelRoomDetails.summary)
        }
        
        /// This is for show the space service also
//        if modelRoomDetails.serviceExtra  != "" {
//            arrTempTitle.append(self.lang.thespac_Tit)
//            arrTempDescription.append(modelRoomDetails.serviceExtra)
//        }
        
//        if modelRoomDetails.room_detail != "" {
//            arrTempTitle.append(self.lang.det_Title)
//            arrTempDescription.append(modelRoomDetails.room_detail as String)
//        }
//        if modelRoomDetails.space != "" {
//            arrTempTitle.append(self.lang.thespac_Tit)
//            arrTempDescription.append(modelRoomDetails.space as String)
//        }
//        if modelRoomDetails.access != "" {
//            arrTempTitle.append(self.lang.guesacc_Tit)
//            arrTempDescription.append(modelRoomDetails.access as String)
//        }
//        if modelRoomDetails.interaction != "" {
//            arrTempTitle.append(self.lang.interact_Guest)
//            arrTempDescription.append(modelRoomDetails.interaction as String)
//        }
//        if modelRoomDetails.neighborhood_overview != "" {
//            arrTempTitle.append(self.lang.tneigh_Title)
//            arrTempDescription.append(modelRoomDetails.neighborhood_overview as String)
//        }
//        if modelRoomDetails.getting_around != "" {
//            arrTempTitle.append(self.lang.getarnd_Tit)
//            arrTempDescription.append(modelRoomDetails.getting_around as String)
//        }
//        if modelRoomDetails.notes != "" {
//            arrTempTitle.append(self.lang.otherthng_Tit)
//            arrTempDescription.append(modelRoomDetails.notes as String)
//        }
//        if modelRoomDetails.house_rules != "" {
//            arrTempTitle.append(self.lang.descs_Title)
//            arrTempDescription.append(modelRoomDetails.house_rules as String)
//        }
        viewHouseRule.arrTempDescription = arrTempDescription
        viewHouseRule.arrTempTitle = arrTempTitle
        present(viewHouseRule, animated: true, completion: nil)
        
    }
    
    //MARK: - ******** WISHLIST OPERATION ********
    @objc func wishListButtonTapped(sender:UIButton) {
        print("Wishlist button clicked")
        if SharedVariables.sharedInstance.userToken.count == 0 {
            let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            mainPage.hidesBottomBarWhenPushed = true
            //            appDelegate.lastPageMaintain = "explore"
            let navigation = UINavigationController(rootViewController: mainPage)
            self.present(navigation, animated: true, completion: nil)
        }
        else{
//            if sender.imageView?.image == UIImage(named: "heart_selected") {
//                print("heart selected")
//                wsToRemoveRoomFromWishList(strRoomID: (modelRoomDetails?.spaceId.description)!, list_type: modelRoomDetails.type)
////                if let id = modelRoomDetails.id {
////                    wsToRemoveRoomFromWishList(strRoomID: "\(String(describing: id))", list_type: modelRoomDetails.type)
////                }
////                else if let id = modelRoomDetails.room_id {
////                    wsToRemoveRoomFromWishList(strRoomID: "\(String(describing: id))", list_type: modelRoomDetails.type)
////                }
//            }
//            else {
//                print("heart not selected")
//                wsToGetWhishList(exploreDict: modelRoomDetails)
//            }
            if self.modelRoomDetails.wishList == "Yes" {
                print("heart selected")
//                wsToRemoveRoomFromWishList(strRoomID: (modelRoomDetails?.spaceId.description)!, list_type: modelRoomDetails.type)
                
                wsToRemoveRoomFromWishList(strRoomID:(modelRoomDetails?.spaceId.description)! , list_type: modelRoomDetails.type, sender: sender)
                sender.isUserInteractionEnabled = false
                
            }
            else {
                print("heart not selected")
                wsToGetWhishList(exploreDict: modelRoomDetails)
            }
        }
    }
    
    func checkHomeOrOther(tempModel:RoomDetailModel) -> String{
        if SharedVariables.sharedInstance.homeType == HomeType.home {
            return tempModel.roomid.description == "0" ? tempModel.roomid.description : tempModel.id.description
        }
        else {
            return tempModel.id.description
        }
    }
    
    internal func onAddWhisListTapped(index:Int)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
        if !isSimilarTapped
        {
            self.updateWishListIcon(strStatus: "Yes")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAddedInWhishlist"), object: self, userInfo: nil)
        
        self.isSimilarlistTapped = true
        self.wsToGetRoomDetails(roomID: self.roomIDString)
    }
    
    func updateWishListIcon(strStatus: String) {
        
//        var tempModel = RoomDetailModel()
//        tempModel = modelRoomDetails!
//        tempModel.is_whishlist = strStatus as NSString
//        modelRoomDetails = tempModel
//        delegate?.updateExploreData(strStatus: strStatus)
//        self.navigationCustom(isApiCalled: true)
//        roomDetailTableView.reloadData()
    }
    
  
    //MARK: - DELETE ROOM FROM WISHLIST
    func removeRoomFromWishList(strRoomID : String)
    {
        //        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [String: Any]()
        
        dicts["token"]   = SharedVariables.sharedInstance.userToken
        dicts["car_id"]   = strRoomID
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_DELETE_WISHLIST, paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            if responseDict.statusCode == 1
            {
                SharedVariables.sharedInstance.lastWhistListRoomId = (strRoomID as NSString).integerValue
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAddedInWhishlist"), object: self, userInfo: nil)
                self.updateWishListIcon(strStatus: "No")
                if self.isSimilarlistTapped
                {
                    self.wsToGetRoomDetails(roomID: self.roomIDString)
                }
            }
            else
            {
                Utilities.sharedInstance.createToastMessage(responseDict.statusMessage, isSuccess: false, viewController: self)
            }
        }
    }
}

extension UICollectionViewCell {
    func changeColor() {
        let oldColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
        let label = self.subviews.compactMap({$0 as? UILabel}).first
        if label?.textColor == oldColor {
            label?.textColor = k_AppThemeColor
        }
        if label?.backgroundColor == oldColor {
            label?.backgroundColor = k_AppThemeColor
        }
    }
}

extension HomeDetailViewController:BedTypeShowAllClickedDelegate,FeatureCellDelegate,UIPopoverPresentationControllerDelegate {
  
    func updateMoreModel(section: sectionHeader) {
        for (index,model) in self.featureArray.enumerated() {
            if model.title == section {
                self.featureArray[index].isMoreTapped = true
                if let index = self.detailAllignTitleArray.index(where:({$0 == self.lang.features_Tit})){
                    let indexPath = IndexPath(row: index, section: 0)
                    UIView.performWithoutAnimation {
                         self.roomDetailTableView.reloadRows(at: [indexPath], with: .top)
                    }
                   
                }
            }
        }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func showTimeFilter(startTimeView:UIView)
    {
        //        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "TimeFilterVCID") as! TimeFilterViewController
        //        let nav = UINavigationController(rootViewController: popoverContent)
        //        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        //        let popover = nav.popoverPresentationController
        //        popoverContent.preferredContentSize = CGSize(width: 200, height: 600)
        //        popover?.delegate = self as UIPopoverPresentationControllerDelegate
        //        popover?.sourceView = self.view
        //        popover?.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 64)
        //        self.present(nav, animated: true, completion: nil)
        
        let selectionVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "TimeFilterVCID") as! TimeFilterViewController
        print("width",self.view.bounds.width/4)
        
        //        selectionVC.size
        selectionVC.modalPresentationStyle = .popover
        selectionVC.preferredContentSize = CGSize(width: 100, height: 100)
        if let popover: UIPopoverPresentationController = selectionVC.popoverPresentationController{
            popover.delegate = self
            let barBtnItem =  UIBarButtonItem(customView: startTimeView)
            popover.barButtonItem = barBtnItem
            popover.permittedArrowDirections = .any
            popover.sourceView = startTimeView
            popover.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 64)
            
        }
        self.present(selectionVC, animated: true, completion: nil)
        
        
    }
    
    func tappedShowAll(_ model: [BedTypeModel], title: String) {
        let country_list = k_MakentStoryboard.instantiateViewController(withIdentifier: "selectionViewController") as! SelectionViewController
        country_list.listModelArray = model
        country_list.title = title
        let navController = UINavigationController(rootViewController: country_list)
        self.present(navController, animated:true, completion: nil)

    }
    
    class func instanceFromNib(nibName:String) -> UIView {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}


