//
//  ExperienceDetailsController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/19/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//


import UIKit
import MessageUI
import Social

enum ExperienceType2Order: Int {
    case BasicDetailsShow = 0
    case MeetYourHost = 1
    case WhatWeWillDo = 2
    case WhatIWillProvide = 3
    case WhoCanCome = 4
    case Notes = 5
    case WhereWeWillBe = 6
    case MapView = 7
    case GroupSizeUpTo = 8
    case GuestRequirements = 9
    case ExperienceCancellationPolicy = 10
    case ContactHost = 11
    case Review = 12
    var language : LanguageProtocol{
        return Language.getCurrentLanguage().getLocalizedInstance()
    }

    var keyToDisplay: String {
        switch self {
        case .MeetYourHost: return "host_user_description"
        case .WhatWeWillDo: return "what_will_do"
        case .WhatIWillProvide: return "what_i_provide"
        case .Notes: return "notes"
        case .WhoCanCome: return "who_can_come"
        case .WhereWeWillBe: return "where_will_be"
        case .Review: return "reviews_count"
        
        
        default: break
        }
        return ""
    }
    var title: String {
        switch self {
        case .MeetYourHost: return self.language.meethost_Title//"Meet Your Host"
        case .WhatWeWillDo: return self.language.whatwldo_Title//"What we'll do"
        case .WhatIWillProvide: return self.language.whatill_Title//"What i'll provide"
        case .Notes: return self.language.notes_Title//"Notes"
        case .WhoCanCome: return self.language.whocom_Title//"Who can come"
        case .WhereWeWillBe: return self.language.whrwlbe_Title//"Where we'll be"
        case .GroupSizeUpTo: return self.language.grpsiz_Title//"Group size up to "
        case .GuestRequirements: return self.language.guestreq_Title//"Guest requirements"
        case .ExperienceCancellationPolicy: return self.language.expcan_Policy//"Experience cancellation policy"
        case .ContactHost: return self.language.conthost_Title//"Contact host"
        
        default: break
        }
        return ""
    }
}

protocol ExRoomDetailPageDelegate
{
    func updateExploreData(strStatus: String)
}

class ExperienceDetailsController : UIViewController,UITableViewDelegate, UITableViewDataSource, ExWWCalendarTimeSelectorProtocol,ViewOfflineDelegate,addWhisListDelegate,createdWhisListDelegate,WWCalendarTimeSelectorProtocol
{
    
    @IBOutlet var tblRoomDetail: UITableView!
    @IBOutlet var scrollObjHolder: UIScrollView!
    @IBOutlet weak var cls_Btn: UIButton!
    
    @IBOutlet var imgFirstPage: UIImageView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var viewNavHeader: UIView?
    @IBOutlet var viewBottomHolder: UIView?
    @IBOutlet var lblReviewValue: UILabel?
    @IBOutlet var lblRating: UILabel?
    @IBOutlet var lblRoomPrice: UILabel?
    @IBOutlet var btnWhishList: UIButton!
    @IBOutlet var btnWhishListH: UIButton!
    @IBOutlet var btnBookRoom: UIButton?
    @IBOutlet var animatedImageView: FLAnimatedImageView?
    @IBOutlet var animatedImgBooking: FLAnimatedImageView?
    
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var strCheckInDate = ""
    var strCheckOutDate = ""
    var strCityName = ""
    var token = ""
    var arrRoomData : NSMutableArray = NSMutableArray()
    var timerAutoScroll = Timer()
    var selectedCell : ExRoomDetailCell!
    var nCurrentIndex : Int = 0
    var strRoomId:Int = 0
    var strShareUrl:String = ""
    var gothis:String = ""
    var isFromHostAddRoom : Bool = false
    var isSimilarlistTapped : Bool = false
    var isSimilarTapped : Bool = false
    var isFromExplore : Bool = false
    var isFromCal : Bool = false
    
    var isWillAppear : Bool = false
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var modelRoomDetails : ExperienceRoomDetails!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrWishListData : NSMutableArray = NSMutableArray()
    var arrlengthStayData : NSMutableArray = NSMutableArray()
    var arrEarlybirdData : NSMutableArray = NSMutableArray()
    var arrLastMinData : NSMutableArray = NSMutableArray()
    var availability : NSMutableArray = NSMutableArray()
    var arraminities : NSMutableArray = NSMutableArray()
    fileprivate var singleDate: Date = Date()
    var multipleDates: [Date] = []
    var delegate: ExRoomDetailPageDelegate?
    
    //create a globar uiview array
    var myProgressView = [ProgressIndicatorView]()
    
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet weak var share_Btn: UIButton!
    
  var datasourceOrder = [ExperienceType2Order]()
//    = {
//        return [
//            .BasicDetailsShow,
//            .MeetYourHost,
//            .WhatWeWillDo,
//            .WhatIWillProvide,
//            .WhoCanCome,
//            .Notes,
//            .WhereWeWillBe,
//            .MapView,
//            .GroupSizeUpTo,
//            .GuestRequirements,
//            .ExperienceCancellationPolicy,
//            .ContactHost]
//    }()
    
    
    func setGradientBackground(viewToAdd: UIView) {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = viewToAdd.frame.size
        gradientLayer.colors =
            [UIColor.clear.cgColor,UIColor.clear.cgColor,UIColor.black.withAlphaComponent(1).cgColor]
//        gradientLayer.locations = [0,0]
        //Use diffrent colors
        viewToAdd.layer.addSublayer(gradientLayer)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        tblRoomDetail.tableHeaderView = tblHeaderView
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine
        self.cls_Btn.transform = self.getAffine
        self.navigationController?.isNavigationBarHidden = true
        viewNavHeader?.alpha = 0.0
        tblRoomDetail.register(UINib(nibName: "ExRoomDetailCell", bundle: nil), forCellReuseIdentifier: "ExRoomDetailCell")
        tblRoomDetail.register(UINib(nibName: "ExMeetYourHostCell", bundle: nil), forCellReuseIdentifier: "ExMeetYourHostCell")
        tblRoomDetail.register(UINib(nibName: "ExperinceType2Cell", bundle: nil), forCellReuseIdentifier: "ExperinceType2Cell")
        tblRoomDetail.register(UINib(nibName: "ExCellMapHolderView", bundle: nil), forCellReuseIdentifier: "ExCellMapHolderView")
        tblRoomDetail.register(UINib(nibName: "ExperienceType3Cell", bundle: nil), forCellReuseIdentifier: "ExperienceType3Cell")
        tblRoomDetail.register(UINib(nibName: "ExWhatIProvideCell", bundle: nil), forCellReuseIdentifier: "ExWhatIProvideCell")
        tblRoomDetail.estimatedRowHeight = 44.0
        tblRoomDetail.rowHeight = UITableView.automaticDimension
        btnBookRoom?.titleLabel?.numberOfLines = 0
        btnBookRoom?.titleLabel?.text = lang.insbook_Title
        btnBookRoom?.titleLabel?.textAlignment = NSTextAlignment.center
        btnBookRoom?.layer.cornerRadius = 5.0
        viewBottomHolder?.isHidden = true
        animatedImgBooking?.isHidden = true
        let rect = UIScreen.main.bounds as CGRect
        var rectEmailView = tblRoomDetail.frame
        rectEmailView.size.height = rect.size.height-(viewBottomHolder?.frame.size.height)!
        tblRoomDetail.frame = rectEmailView
        
        self.getRoomDetails(room_id: strRoomId)
        
        viewNavHeader?.layer.shadowColor = UIColor.gray.cgColor;
        viewNavHeader?.layer.shadowOffset = CGSize(width:0, height:1.0);
        viewNavHeader?.layer.shadowOpacity = 0.5;
        viewNavHeader?.layer.shadowRadius = 1.0;
        viewBottomHolder?.layer.shadowColor = UIColor.gray.cgColor;
        viewBottomHolder?.layer.shadowOffset = CGSize(width:0, height:1.0);
        viewBottomHolder?.layer.shadowOpacity = 1.5;
        viewBottomHolder?.layer.shadowRadius = 2.0;
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.resetView), userInfo: nil, repeats: false)
        appDelegate.strRoomID = String(strRoomId)
        btnBookRoom?.appGuestSideBtnBG()
        self.lblRating?.appGuestTextColor()
        
    }

    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.getRoomDetails(room_id: self.strRoomId)
    }

    // MARK: ***** ROOM DETAIL API CALL *****
    /*
     Here Getting Room Details
     */
    func getRoomDetails(room_id:Int)
    {
        let viewProgress = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        viewProgress.isShowLoaderAnimaiton = true
        viewProgress.view.tag = Int(123456)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = true
        self.view.addSubview(viewProgress.view)
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        if appDelegate.lastPageMaintain == "ExpContact"{
            dicts["host_experience_id"] = appDelegate.expRoomID
        }
        else{
            dicts["host_experience_id"] = room_id
        }
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_EXPERIENCE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let roomModel = response as! ExperienceRoomDetails
            OperationQueue.main.addOperation {
                if roomModel.statusCode == "1"
                {
                    self.modelRoomDetails = roomModel
                    var images:[String] = []
                    self.modelRoomDetails.experienceImages?.forEach{
                        images.append($0.name!)
                    }
                    
                        //            .BasicDetailsShow,
                        //            .MeetYourHost,
                        //            .WhatWeWillDo,
                        //            .WhatIWillProvide,
                        //            .WhoCanCome,
                        //            .Notes,
                        //            .WhereWeWillBe,
                        //            .MapView,
                        //            .GroupSizeUpTo,
                        //            .GuestRequirements,
                        //            .ExperienceCancellationPolicy,
                        //            .ContactHost]
                    self.datasourceOrder.removeAll()
                    self.datasourceOrder.append(.BasicDetailsShow)
                    self.datasourceOrder.append(.MeetYourHost)
                    self.datasourceOrder.append(.WhatWeWillDo)
                    self.datasourceOrder.append(.WhatIWillProvide)
                    self.datasourceOrder.append(.WhoCanCome)
                    if !(self.modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.Notes.keyToDisplay] as? String)!.isEmpty{
                        self.datasourceOrder.append(.Notes)
                    }
                    
                    self.datasourceOrder.append(.WhereWeWillBe)
                    self.datasourceOrder.append(.MapView)
                    let rating = self.modelRoomDetails.dictionaryRepresentation().string("rating_value")
                    let review = self.modelRoomDetails.dictionaryRepresentation().int("reviews_count")
                    if rating.isEmpty && rating != "0" || review != 0  {
                        self.datasourceOrder.append(.Review)
                    }
                    self.datasourceOrder.append(.GroupSizeUpTo)
                     self.datasourceOrder.append(.GuestRequirements)
                     self.datasourceOrder.append(.ExperienceCancellationPolicy)
                    self.datasourceOrder.append(.ContactHost)
                    self.titleLabel.text = roomModel.experienceName
                    self.cityLabel.text = roomModel.categoryType
                    self.setTableHeaderImages(arrHeaderImgs: images as NSArray)
                    self.setRoomsInformation(ModelRooms: roomModel)
                    self.arrlengthStayData.removeAllObjects()
                    self.arrEarlybirdData.removeAllObjects()
                    self.arrLastMinData.removeAllObjects()
                    self.availability.removeAllObjects()
                    self.arraminities.removeAllObjects()
                    self.tblRoomDetail.reloadData()
                }
                else
                {
                    if roomModel.successMessage == "token_invalid" || roomModel.successMessage == "user_not_found" || roomModel.successMessage == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }

                if self.isSimilarlistTapped
                {
                    DispatchQueue.main.async {
                    self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                    self.appDelegate.window?.isUserInteractionEnabled = true
                    }
                    self.isSimilarlistTapped = false
                }
                else
                {
                    self.animatedImageView?.isHidden = true
                }
            }
            DispatchQueue.main.async {
                self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                self.appDelegate.window?.isUserInteractionEnabled = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                DispatchQueue.main.async {
                    self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                    self.appDelegate.window?.isUserInteractionEnabled = true
                }
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }



    // MARK: ************************************
    // MARK: MAKE AUTO SCROLL ANIMAITON FOR TABLE HEADER IMAGES

    @objc func makeAutoScrollAnimation()
    {
        if modelRoomDetails == nil
        {
            return
        }

        if (nCurrentIndex>myProgressView.count/2 - 1)
        {
            nCurrentIndex = 0
            let imageArray = self.modelRoomDetails.experienceImages ?? [ExperienceImages]()
            for i in 0..<imageArray.count
            {
                if imageArray.count > 1 {
                    self.myProgressView[i].progressBar.setProgress(0.0,animated:true)
                }
                
            }
        }

        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            let rect = MakentSupport().getScreenSize()
            self.scrollObjHolder.setContentOffset(CGPoint(x:  rect.size.width * CGFloat(self.nCurrentIndex), y: 0), animated: true)
            self.setProgressBar(currentIndex: self.nCurrentIndex)
        }, completion: { (finished: Bool) -> Void in
            self.nCurrentIndex += 1
        })
       
        
    }

    @objc func resetView()
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "back")
        userDefaults.synchronize()
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
      tblRoomDetail.delaysContentTouches = false
        if MakentSupport().isPad()
        {
            NotificationCenter.default.addObserver(self, selector: #selector(self.adjustSubViewFrames), name: UIDevice.orientationDidChangeNotification, object: nil)
            self.adjustSubViewFrames()
        }

        if appDelegate.day1 == "1"{
            if gothis == "1"{
                btnBookRoom?.setTitle(lang.insbook_Title, for: UIControl.State.normal)
            }
            else{
                btnBookRoom?.setTitle(lang.reqbook_Title, for: UIControl.State.normal)
            }
            appDelegate.gothis = "1"

        }
        
        if appDelegate.userToken != "" && !isWillAppear {
            self.getRoomDetails(room_id: strRoomId)
            isWillAppear = true
        }
        
    }

    // MARK: ****** WWCalendar Delegate Methods ******

    @nonobjc internal func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    {
        appDelegate.multipleDates = dates
        print(dates)
        appDelegate.page = "1"
        self.getRoomDetails(room_id: self.strRoomId)
        let formalDates = dates
        appDelegate.multipleDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        strCheckInDate = dateFormatter.string(from: startDay)
        strCheckOutDate = dateFormatter.string(from: lastDay!)
        if appDelegate.day == "1"{
            appDelegate.s_date = strCheckInDate
            appDelegate.e_date = strCheckOutDate
        }
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        timerAutoScroll.invalidate()
        NotificationCenter.default.removeObserver(self)
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
        tblRoomDetail.reloadData()
    }

    func setHeaderInfomation()
    {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //        scrollView.canCancelContentTouches = true
        //        scrollView.delaysContentTouches = false
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y >= 70 {
            print("Reached")
        }
        let y = -scrollView.contentOffset.y as CGFloat;
        if (y > 0){
        }else
        {
            let offsetY = scrollView.contentOffset.y as CGFloat;

            let val1 = (((tblHeaderView.frame.size.height-150) + 110 - offsetY) / 84)
            let alpha = min(1, 1 - val1)
//            if (offsetY > (tblHeaderView.frame.size.height-150))
//            {
//                viewNavHeader?.alpha = alpha
//            } else  {
//                viewNavHeader?.alpha = alpha
//            }
            viewNavHeader?.alpha = alpha
        }
    }



    // MARK: ------ CREATE TABLE HEADER IMAGES
    /*
     Here we are adding UIImageView according to Image count
     Then adding subview of ScrollView
     */
    func setTableHeaderImages(arrHeaderImgs : NSArray)
    {
        if arrHeaderImgs.count==0
        {
            return
        }

        for view in scrollObjHolder.subviews
        {
            view.removeFromSuperview()
        }

        var xPosition:CGFloat = 0
        let newView = UIView()
        newView.backgroundColor = UIColor.clear
        scrollObjHolder.superview?.addSubview(newView)
        scrollObjHolder.superview?.bringSubviewToFront(newView)
        
      
        
        
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -20).isActive = true
        newView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        newView.widthAnchor.constraint(equalTo: self.scrollObjHolder.widthAnchor, constant: -40).isActive = true
        
        newView.leadingAnchor.constraint(equalTo: self.scrollObjHolder.leadingAnchor, constant: 20).isActive = true
        newView.trailingAnchor.constraint(equalTo: self.scrollObjHolder.trailingAnchor, constant: -20).isActive = true
        let stackViewIndi = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-60, height: 10))
        
        stackViewIndi.axis  = NSLayoutConstraint.Axis.horizontal
        
        stackViewIndi.alignment = .fill
        stackViewIndi.spacing = 2
        stackViewIndi.distribution = .fill
        stackViewIndi.translatesAutoresizingMaskIntoConstraints = false
        stackViewIndi.backgroundColor = .lightGray
        newView.addSubview(stackViewIndi)
        newView.bringSubviewToFront(stackViewIndi)
        stackViewIndi.center = newView.center
        
        stackViewIndi.bottomAnchor.constraint(equalTo: newView.bottomAnchor, constant: 0).isActive = true
        stackViewIndi.heightAnchor.constraint(equalToConstant: 5).isActive = true
        stackViewIndi.widthAnchor.constraint(equalTo: newView.widthAnchor, constant: 0).isActive = true
        stackViewIndi.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 0).isActive = true
        stackViewIndi.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: 0).isActive = true
       
        
        
        for i in 0 ..< arrHeaderImgs.count {
            let myImage = UIImage(named: arrHeaderImgs[i] as! String )
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            myImageView.frame =  CGRect(x: xPosition, y:0, width: scrollObjHolder.frame.size.width+1 ,height: scrollObjHolder.frame.size.height)
            
            setGradientBackground(viewToAdd: myImageView)
            let myButton:UIButton = UIButton()
            myButton.frame =  CGRect(x: xPosition, y:0, width: self.view.frame.size.width ,height: scrollObjHolder.frame.size.height)
            myButton.tag = i
            myButton.addTarget(self, action: #selector(self.onImageTapped), for: UIControl.Event.touchUpInside)
            
            scrollObjHolder.addSubview(myImageView)
            scrollObjHolder.addSubview(myButton)
            xPosition += scrollObjHolder.frame.size.width
            myImageView.addRemoteImage(imageURL: arrHeaderImgs[i] as! String, placeHolderURL: "")
          
            let width = (self.view.frame.width+stackViewIndi.spacing)-40
            let viewIndicator = HomeDetailViewController.instanceFromNib(nibName: "ProgressIndicatorView") as! ProgressIndicatorView
            
            
            viewIndicator.progressBarWidth.constant = (width/CGFloat(arrHeaderImgs.count))
            viewIndicator.backgroundColor = .clear
            self.myProgressView.append(viewIndicator)
           
            stackViewIndi.addArrangedSubview(viewIndicator)
        }
        if  let indexArray = arrHeaderImgs as? [String],indexArray.isEmpty || indexArray.count == 1 {
            self.myProgressView.removeAll()
            stackViewIndi.removeFromSuperview()
            newView.removeFromSuperview()
        }


        let widht = CGFloat(self.view.frame.size.width) * CGFloat(arrHeaderImgs.count)
        scrollObjHolder.contentSize = CGSize(width: widht, height:  scrollObjHolder.frame.size.height)

        timerAutoScroll = Timer.scheduledTimer(timeInterval: Double(myProgressView.count/2), target: self, selector: #selector(self.makeAutoScrollAnimation), userInfo: nil, repeats: true)
    }
    
    @objc func setProgressBar(currentIndex : Int)
    {
        let divisor = myProgressView.count/2
        if let indexArray = modelRoomDetails.experienceImages,indexArray.count > 1 {
             self.myProgressView[currentIndex+divisor].progressBar.setProgress(1.0,animated:true)
        }
    }

    // MARK: ------ IMAGE VIEW FOR ROOM HEADER IMAGES --------
    @objc func onImageTapped(sender:UIButton)
    {
        var images:[String] = []
        self.modelRoomDetails.experienceImages?.forEach{
            images.append($0.name!)
        }
        let photoBrowser = SYPhotoBrowser(imageSourceArray: images, caption: "", delegate: self)
        photoBrowser?.initialPageIndex = UInt(sender.tag)
        photoBrowser?.pageControlStyle = SYPhotoBrowserPageControlStyle.label
        photoBrowser?.enableStatusBarHidden = true
        self.present((photoBrowser)!, animated: true, completion: nil)
    }

    // MARK: SHARE BUTTON ACTION
    @IBAction func onShareTapped(_ sender:UIButton!)
    {
        if modelRoomDetails == nil{
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [self.getDefaultShareContent()], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }

    func getDefaultShareContent() -> NSString
    {
        let shareContent = String(format:"\(lang.checkout_Awesom) \(k_AppName.capitalized): %@\n%@",modelRoomDetails.experienceName!,modelRoomDetails.experienceShareUrl!)
        return shareContent as NSString
    }
    //MARK: - ******** WISHLIST OPERATION ********
    
    @IBAction func onWishListAction(_ sender: Any) {
        isSimilarTapped = false
        if modelRoomDetails == nil{
            return
        }
        
        arrWishListData = self.appDelegate.arrWishListData
        if modelRoomDetails.isWhishlist == "Yes" {
            
            removeRoomFromWishList(strRoomID : appDelegate.strRoomID)
            return
        }
        if arrWishListData.count == 0
        {
            if token == "" || self.appDelegate.userToken == "" {
                let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                
                mainPage.hidesBottomBarWhenPushed = true
                appDelegate.strRoomID = String(strRoomId)
                appDelegate.lastPageMaintain = "roomDetail"
                let navController = UINavigationController(rootViewController: mainPage)
                self.present(navController, animated:true, completion: nil)
//                self.navigationController?.pushViewController(mainPage, animated: false)
            }
            else{
                let viewCreateList = StoryBoard.account.instance.instantiateViewController(withIdentifier: "CreateWhishList") as! CreateWhishList
                viewCreateList.strRoomName = strCityName
                viewCreateList.strRoomID = String(strRoomId)
                appDelegate.strRoomID = String(strRoomId)
                viewCreateList.listType = "Experiences"
                viewCreateList.delegate = self
                present(viewCreateList, animated: false, completion: nil)
            }
        }
        else if arrWishListData.count > 0
        {
            let viewCreateList = StoryBoard.account.instance.instantiateViewController(withIdentifier: "AddWhishListVC") as! AddWhishListVC
            viewCreateList.delegate = self
            viewCreateList.listType = "Experiences"
            viewCreateList.strRoomName = strCityName
            viewCreateList.strRoomID = String(strRoomId)
            appDelegate.strRoomID = String(strRoomId)
            viewCreateList.arrWishListData = arrWishListData
            viewCreateList.view.backgroundColor = UIColor.clear
            viewCreateList.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            present(viewCreateList, animated: true, completion: nil)
        }
    }
    
    internal func onAddWhisListTapped(index:Int)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
        if !isSimilarTapped
        {
            self.updateWishListIcon(strStatus: "Yes")
        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAddedInWhishlist"), object: self, userInfo: nil)
        self.isSimilarlistTapped = true
        self.getRoomDetails(room_id:strRoomId)
    }
    
    func updateWishListIcon(strStatus: String)
    {

        delegate?.updateExploreData(strStatus: strStatus)
//        if strStatus == "No"{
//            self.btnWhishList.setTitle("B",for: .normal)
//            self.btnWhishListH.setTitle("B",for: .normal)
//            self.btnWhishList.setTitleColor(UIColor.white, for: .normal)
//            self.btnWhishListH.setTitleColor(UIColor.darkGray, for: .normal)
//        }
//        else{
        
            if (modelRoomDetails.isWhishlist == "Yes")
            {
                btnWhishList.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
                btnWhishListH.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
                btnWhishList.setTitle("C", for: .normal)
                btnWhishListH.setTitle("C", for: .normal)
            }
            else
            {
                btnWhishList.setTitle("B", for: .normal)
                btnWhishListH.setTitle("B", for: .normal)
                btnWhishList.setTitleColor(UIColor.white, for: .normal)
                btnWhishListH.setTitleColor(UIColor.darkGray, for: .normal)
            }
//        }
        tblRoomDetail.reloadData()

    }
    
    
    //MARK: - DELETE ROOM FROM WISHLIST
    func removeRoomFromWishList(strRoomID : String)
    {
        let viewProgress = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        viewProgress.isShowLoaderAnimaiton = true
        viewProgress.view.tag = Int(123456)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = true
        self.view.addSubview(viewProgress.view)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = token
        dicts["room_id"]   = appdelegate.strRoomID
        dicts["list_type"]   = "Experiences"
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_DELETE_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    SharedVariables.sharedInstance.lastWhistListRoomId = self.strRoomId
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
                    DispatchQueue.main.async {
                        self.getRoomDetails(room_id:self.strRoomId)
                    }
                    self.updateWishListIcon(strStatus: "No")
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAddedInWhishlist"), object: self, userInfo: nil)
                    if self.isSimilarlistTapped
                    {
                        self.getRoomDetails(room_id:self.strRoomId)
                    }

                }
                else
                {
                    if gModel.status_code == "0" && gModel.success_message == "Wishlists Not Found"
                    {
//                        self.updateWishListIcon(strStatus: "No")
                        
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
                }
                DispatchQueue.main.async {
                    self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                    self.appDelegate.window?.isUserInteractionEnabled = true
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                DispatchQueue.main.async {
                    self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                    self.appDelegate.window?.isUserInteractionEnabled = true
                }
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    //MARK: CREATE NEW WISHLIST DELEGATE METHOD
    internal func onCreateNewWishList(listName : String, privacy : String,listType : String)
    {
        let viewProgress = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        viewProgress.isShowLoaderAnimaiton = true
        viewProgress.view.tag = Int(123456)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = true
        self.view.addSubview(viewProgress.view)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = token
        dicts["room_id"]   = appDelegate.strRoomID
        dicts["list_name"]   = listName.replacingOccurrences(of: "%20", with: " ")
        dicts["privacy_settings"]   = privacy
        dicts["list_type"]   = listType
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ADD_TO_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    SharedVariables.sharedInstance.lastWhistListRoomId = self.strRoomId
                    
                    self.onAddWhisListTapped(index: 1)
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
                DispatchQueue.main.async {
                    self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                    self.appDelegate.window?.isUserInteractionEnabled = true
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                DispatchQueue.main.async {
                    self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                    self.appDelegate.window?.isUserInteractionEnabled = true
                }
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    // MARK: BACK BUTTON ACTION
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "back")
        userDefaults.synchronize()
//        modelRoomDetails = nil
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
       
        if token == "" {
            if isFromExplore {
                 self.navigationController!.popViewController(animated: true)
            }else{
                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
            }
        }
        else{
            self.navigationController!.popViewController(animated: true)
            
        }
        if appDelegate.gothis == "1" {
            appDelegate.multipleDates = []
            strCheckInDate =  ""
            strCheckOutDate = ""
            appDelegate.e_date = ""
            appDelegate.s_date = ""
            appDelegate.day = ""
            appDelegate.startdate = ""
            appDelegate.enddate = ""
            appDelegate.searchguest = ""
        }
    }

    override func didReceiveMemoryWarning() {
        modelRoomDetails = nil
        tblRoomDetail = nil
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setRoomsInformation(ModelRooms: ExperienceRoomDetails)
    {
        
        if (Constants().GETVALUE(keyname: APPURL.USER_ID) as String == ("\(modelRoomDetails.hostUserId!)") as String){
            viewBottomHolder?.isHidden = true
            self.bottomHeightConstraint.constant = 0
        }
        else{
            viewBottomHolder?.isHidden = false //75
            self.bottomHeightConstraint.constant = 75
        }

        let reviewsCount = ModelRooms.reviewsCount ?? 0
        lblReviewValue?.text = (reviewsCount == 0) ? "" : String(format:(reviewsCount == 1) ? "%@ \(self.lang.rev_Title)" : "%@ \(self.lang.reviews_Title)", String(reviewsCount))

        lblRating?.isHidden = (ModelRooms.reviewsCount == 0 || ModelRooms.reviewsCount == nil) ? true : false
        btnBookRoom?.setTitle(self.lang.seedates_Title, for: .normal)

        if (ModelRooms.reviewsCount == 0 || ModelRooms.reviewsCount == nil)
        {
            var rectEmailView = lblRoomPrice?.frame
            rectEmailView?.size.height = 40
            lblRoomPrice?.frame = rectEmailView!
        }
        else
        {
            lblRating?.text = MakentSupport().createRatingStar(ratingValue: (ModelRooms.ratingValue! as NSString)) as String
            //MakentSupport().createRatingStar(ratingValue: "5") as String
            lblRating?.appGuestTextColor()
            //(ModelRooms.ratingValue! as NSString)
        }
        btnBookRoom?.isHidden = (ModelRooms.canBook == "Yes") ? false : true
        btnWhishList.setTitle((ModelRooms.isWhishlist == "Yes") ? "C" : "B", for: .normal)
        btnWhishListH.setTitle((ModelRooms.isWhishlist == "Yes") ? "C" : "B", for: .normal)
        if (ModelRooms.isWhishlist == "Yes")
        {
            btnWhishList.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
            btnWhishListH.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
        }
        else{
            btnWhishList.setTitleColor(UIColor.white, for: .normal)
            btnWhishListH.setTitleColor(UIColor.darkGray, for: .normal)
        }
//        if appDelegate.page == "1"{
//            lblRoomPrice?.attributedText = MakentSupport().getBigAndNormalString(originalText: String(format: "%@ %@ per person",(ModelRooms.currencySymbol! as String).stringByDecodingHTMLEntities, appDelegate.pricepertnight as String) as NSString, normalText: "per person", attributeText: appDelegate.pricepertnight as NSString, font: (lblRoomPrice?.font)!)
//        }
       // else{
        lblRoomPrice?.attributedText = MakentSupport().getBigAndNormalString(originalText: String(format: "%@ %@ \(self.lang.perpers_Title)",(ModelRooms.currencySymbol! as String).stringByDecodingHTMLEntities, "\(ModelRooms.experiencePrice!)" as String) as NSString, normalText: "\(self.lang.perpers_Title)" as NSString, attributeText: "\(ModelRooms.experiencePrice!)" as NSString, font: (lblRoomPrice?.font)!)
       // }
    }

    @IBAction func onCheckAvailabilityTapped(_ sender:UIButton!){
        appDelegate.gothis = "1"
        showCalander()
    }
    
  

    func showCalander(){

        let selector = UIStoryboard(name: "ExperienceDetails", bundle: nil).instantiateViewController(withIdentifier: "ExperienceCalenderController") as! ExperienceCalenderController
        selector.experienceDetails = self.modelRoomDetails

        if btnBookRoom?.titleLabel?.text == lang.insbook_Title//"Instant Book"
        {
            gothis = "1"
        }
        else{
            gothis = "2"
        }
        appDelegate.day = "1"
        appDelegate.gothis = "1"
        selector.room_Id = "\(modelRoomDetails.experienceId!)" as String
//        selector
//        selector.btntype = gothis
        selector.callAPI = true
        selector.delegate = self
        selector.optionCurrentDate = singleDate
//        selector.optionCurrentDates = Set(appDelegate.multipleDates)
//        appDelegate.multipleDates = appDelegate.multipleDates
        if modelRoomDetails.blockedDates != nil{
            if (modelRoomDetails.blockedDates?.count)! > 0{
                selector.arrBlockedDates = modelRoomDetails.blockedDates!
                //NSMutableArray(array: modelRoomDetails.blockedDates!)
            }
        }
//        selector.optionCurrentDateRange.setStartDate(appDelegate.multipleDates.first ?? singleDate)
//        selector.optionCurrentDateRange.setEndDate(appDelegate.multipleDates.last ?? singleDate)
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.single
        self.navigationController?.pushViewController(selector, animated: true)
    }

    //MARK: ---------------------------------------------------------------
    //MARK: ***** Room Detail Table view Datasource Methods *****
    /*
     Room Detail List View Table Datasource & Delegates
     */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return (modelRoomDetails == nil) ? 0 : datasourceOrder.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ExperienceType2Order.WhatIWillProvide.rawValue {
            return (modelRoomDetails.whatIProvide?.count)!
        }
        return 1
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var title: String?
        var subtitle: String = ""
        let section = self.datasourceOrder[indexPath.section]
        if section == .BasicDetailsShow {
            let cell:ExRoomDetailCell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExRoomDetailCell")! as! ExRoomDetailCell
            cell.populate(data: modelRoomDetails)
            return cell
        }else if section == .MapView {
            let cell:ExCellMapHolderView = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExCellMapHolderView")! as! ExCellMapHolderView
            cell.setMapInfo(modelRooms: modelRoomDetails)
            return cell
        }
        else if section == .GuestRequirements {
            let cell:ExperienceType3Cell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExperienceType3Cell")! as! ExperienceType3Cell
            cell.captionLabel.text = ExperienceType2Order.GuestRequirements.title
            return cell
        }
        else if section == .Review {
            let cell:ExprienceReviewTVC = tblRoomDetail.dequeueReusableCell(withIdentifier: "exprienceReviewTVC")! as! ExprienceReviewTVC
            if let review = modelRoomDetails.reviewsCount {
                cell.reviewLbl.text = "\(self.lang.read_Title) " + (modelRoomDetails.reviewsCount == 1 ? "1 \(self.lang.rev_Title)" : "\(review.description) \(self.lang.revs_Title)")
            }else {
                cell.reviewLbl.text = ""
            }
            if let ratingValue = modelRoomDetails.ratingValue, !ratingValue.isEmpty {
                cell.ratingLbl.text = MakentSupport().createRatingStar(ratingValue: ratingValue as NSString) as String
            }else {
                cell.ratingLbl.text = ""
            }
            
           
            return cell
        }
        else if section == .GroupSizeUpTo{
            let cell:ExperienceType3Cell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExperienceType3Cell")! as! ExperienceType3Cell
            cell.captionLabel.text = ExperienceType2Order.GroupSizeUpTo.title + " \(modelRoomDetails.noOfGuest!)  \(self.lang.guess_Tit)"
            return cell
        }
        else if section == .ExperienceCancellationPolicy{
            let cell:ExperienceType3Cell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExperienceType3Cell")! as! ExperienceType3Cell
            cell.captionLabel.text = ExperienceType2Order.ExperienceCancellationPolicy.title
            return cell
        }
        else if section == .ContactHost{
            let cell:ExperienceType3Cell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExperienceType3Cell")! as! ExperienceType3Cell
            cell.captionLabel.text = ExperienceType2Order.ContactHost.title
            return cell
        }
        else if section == .MeetYourHost{
            let cell:ExMeetYourHostCell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExMeetYourHostCell")! as! ExMeetYourHostCell
            title = ExperienceType2Order.MeetYourHost.title + ", \(modelRoomDetails.hostUserName!)"
            subtitle = modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.MeetYourHost.keyToDisplay] as! String
            cell.userImageView.addRemoteImage(imageURL: modelRoomDetails.hostUserImage ?? "", placeHolderURL: "")
            //.sd_setImage(with: URL(string: modelRoomDetails.hostUserImage!))
            //            cell.delegate = self
            cell.populateData(title: title!, subTitle: subtitle)
            return cell
        }
        else if section == .WhatWeWillDo{
            title  = ExperienceType2Order.WhatWeWillDo.title
            subtitle = modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.WhatWeWillDo.keyToDisplay] as! String
        }
        else if section == .WhatIWillProvide{
            let cell:ExWhatIProvideCell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExWhatIProvideCell")! as! ExWhatIProvideCell
            let model = modelRoomDetails.whatIProvide?[indexPath.row]
            if (modelRoomDetails.whatIProvide?.count)! > 0 {
                cell.titleLabel.text = ExperienceType2Order.WhatIWillProvide.title
                cell.subTitleLabel.text = model?.name
                cell.contentLabel.text = model?.descriptionValue != "" ? model?.descriptionValue : ""
                cell.contentLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.subTitleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.contentImageView.addRemoteImage(imageURL: model?.image ?? "", placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: model?.image as String? ?? "")! as URL?, placeholderImage:UIImage(named:""))
                cell.bottomView.isHidden = indexPath.row == (modelRoomDetails.whatIProvide?.count)! - 1 ? false : true
                cell.titleContsHight.constant = indexPath.row == 0 ? 20 : 0
            }
            else{
                cell.titleLabel.text = ExperienceType2Order.WhatIWillProvide.title
                cell.contentLabel.text = " "
                cell.contentImageView.image = UIImage(named:"")
            }
            cell.titleLabel.isHidden = indexPath.row == 0 ? false : true
            return cell
        } else if section == .Notes{
            
            title  = ExperienceType2Order.Notes.title
            subtitle = (modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.Notes.keyToDisplay] as? String)!
            
        }
        else if section == .WhoCanCome{
            title  = ExperienceType2Order.WhoCanCome.title
            subtitle = "\(modelRoomDetails.whoCanCome ?? "")"
            
            
        }
        else if section == .WhereWeWillBe {
            title  = ExperienceType2Order.WhereWeWillBe.title
            subtitle = modelRoomDetails.whereWillBe!
        }
        let cell:ExperinceType2Cell = tblRoomDetail.dequeueReusableCell(withIdentifier: "ExperinceType2Cell")! as! ExperinceType2Cell
                cell.populateData(title: title!, subTitle: subtitle)
        //        cell.delegate = self
                return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.datasourceOrder[indexPath.section] == .MapView {
            return 310
        }
//        if indexPath.section == ExperienceType2Order.MapView.rawValue {
//            return 310
//        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            print("black to white")
        }
    }
    


    //MARK: ---- Table View Delegate Methods ----

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let section = self.datasourceOrder[indexPath.section]
        if section == .GuestRequirements {
            let guestRequirementScene = UIStoryboard(name: "GuestPage", bundle: nil).instantiateViewController(withIdentifier: "GuestRequirementController") as! GuestRequirementController
                        guestRequirementScene.experienceDetails = self.modelRoomDetails
                        self.navigationController?.pushViewController(guestRequirementScene, animated: true)
        } else if section == .GroupSizeUpTo{
            let guestSizeInfoScene = UIStoryboard(name: "GuestPage", bundle: nil).instantiateViewController(withIdentifier: "GroupSizeInfoController") as! GroupSizeInfoController
            guestSizeInfoScene.experienceDetails = modelRoomDetails
            self.navigationController?.pushViewController(guestSizeInfoScene, animated: true)
        } else if section == .ExperienceCancellationPolicy {
            let eventCancellationPolicyScene = UIStoryboard(name: "EventCancellation", bundle: nil).instantiateViewController(withIdentifier: "EventCancellationPolicyController")
            self.navigationController?.pushViewController(eventCancellationPolicyScene, animated: true)
        } else if section == .ContactHost{
            if token != "" || appDelegate.userToken != "" {
                let exContactHostController = UIStoryboard(name: "ExperienceDetails", bundle: nil).instantiateViewController(withIdentifier: "ExContactHostController") as! ExContactHostController
                exContactHostController.modelRoomDetails = modelRoomDetails
                self.navigationController?.pushViewController(exContactHostController, animated: true)
            }
            else{
                let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                mainPage.hidesBottomBarWhenPushed = true
                appDelegate.expRoomID = strRoomId
                appDelegate.lastPageMaintain = "ExpContact"
                let navController = UINavigationController(rootViewController: mainPage)
                self.present(navController, animated:true, completion: nil)
            }

            
        }
        else if section == .Notes{
            
            let title  = ExperienceType2Order.Notes.title
                        let subtitle = (modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.Notes.keyToDisplay] as? String)!
                        let readMoreScreen = ExperienceReadMoreController()
                        readMoreScreen.titleString = title
                        readMoreScreen.subTitle = subtitle
                        self.navigationController?.pushViewController(readMoreScreen, animated: true)
            
        }
        else if section == .WhoCanCome{
            let title  = ExperienceType2Order.WhoCanCome.title
                        let subtitle = "\(modelRoomDetails.whoCanCome ?? "")"
                        let readMoreScreen = ExperienceReadMoreController()
                        readMoreScreen.titleString = title
                        readMoreScreen.subTitle = subtitle
                        self.navigationController?.pushViewController(readMoreScreen, animated: true)
            
        }
        else if section == .WhereWeWillBe {
            let title  = ExperienceType2Order.WhereWeWillBe.title
                        let subtitle = modelRoomDetails.whereWillBe!
                        let readMoreScreen = ExperienceReadMoreController()
                        readMoreScreen.titleString = title
                        readMoreScreen.subTitle = subtitle
                        self.navigationController?.pushViewController(readMoreScreen, animated: true)
        }
        else if section == .MeetYourHost {
                        let title = ExperienceType2Order.MeetYourHost.title + ", \(modelRoomDetails.hostUserName!)"
                    let subtitle = modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.MeetYourHost.keyToDisplay] as! String
                    let readMoreScreen = ExperienceReadMoreController()
                    readMoreScreen.titleString = title
                    readMoreScreen.subTitle = subtitle
                    self.navigationController?.pushViewController(readMoreScreen, animated: true)
        } else if section == .WhatWeWillDo {
            let title  = ExperienceType2Order.WhatWeWillDo.title
                        let subtitle = modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.WhatWeWillDo.keyToDisplay] as! String
                        let readMoreScreen = ExperienceReadMoreController()
                        readMoreScreen.titleString = title
                        readMoreScreen.subTitle = subtitle
                        self.navigationController?.pushViewController(readMoreScreen, animated: true)
        }else if section == .Review {
            let viewHouseRule = k_MakentStoryboard.instantiateViewController(withIdentifier: "ReviewDetailVC") as! ReviewDetailVC
            viewHouseRule.hidesBottomBarWhenPushed = true
            viewHouseRule.isFromExprience = true
            viewHouseRule.strRoomId = (modelRoomDetails.experienceId?.description ?? "")
            present(viewHouseRule, animated: true, completion: nil)
        }
        
        
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        switch indexPath.section {
//        case ExperienceType2Order.GuestRequirements.rawValue:
//            let guestRequirementScene = UIStoryboard(name: "GuestPage", bundle: nil).instantiateViewController(withIdentifier: "GuestRequirementController") as! GuestRequirementController
//            guestRequirementScene.experienceDetails = self.modelRoomDetails
//            self.navigationController?.pushViewController(guestRequirementScene, animated: true)
//        case ExperienceType2Order.GroupSizeUpTo.rawValue:
//            let guestSizeInfoScene = UIStoryboard(name: "GuestPage", bundle: nil).instantiateViewController(withIdentifier: "GroupSizeInfoController") as! GroupSizeInfoController
//            guestSizeInfoScene.experienceDetails = modelRoomDetails
//            self.navigationController?.pushViewController(guestSizeInfoScene, animated: true)
//        case ExperienceType2Order.ExperienceCancellationPolicy.rawValue:
//            let eventCancellationPolicyScene = UIStoryboard(name: "EventCancellation", bundle: nil).instantiateViewController(withIdentifier: "EventCancellationPolicyController")
//            self.navigationController?.pushViewController(eventCancellationPolicyScene, animated: true)
//        case ExperienceType2Order.ContactHost.rawValue:
//            if token != "" || appDelegate.userToken != "" {
//                let exContactHostController = UIStoryboard(name: "ExperienceDetails", bundle: nil).instantiateViewController(withIdentifier: "ExContactHostController") as! ExContactHostController
//                exContactHostController.modelRoomDetails = modelRoomDetails
//                self.navigationController?.pushViewController(exContactHostController, animated: true)
//            }
//            else{
//                let mainPage = k_MakentStoryboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
//                mainPage.hidesBottomBarWhenPushed = true
//                appDelegate.expRoomID = strRoomId
//                appDelegate.lastPageMaintain = "ExpContact"
//                let navController = UINavigationController(rootViewController: mainPage)
//                self.present(navController, animated:true, completion: nil)
//            }
//        case ExperienceType2Order.Notes.rawValue:
//            let title  = ExperienceType2Order.Notes.title
//            let subtitle = (modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.Notes.keyToDisplay] as? String)!
//            let readMoreScreen = ExperienceReadMoreController()
//            readMoreScreen.titleString = title
//            readMoreScreen.subTitle = subtitle
//            self.navigationController?.pushViewController(readMoreScreen, animated: true)
//            break
//        case ExperienceType2Order.WhoCanCome.rawValue:
//            let title  = ExperienceType2Order.WhoCanCome.title
//            let subtitle = "\(modelRoomDetails.whoCanCome ?? "")"
//            let readMoreScreen = ExperienceReadMoreController()
//            readMoreScreen.titleString = title
//            readMoreScreen.subTitle = subtitle
//            self.navigationController?.pushViewController(readMoreScreen, animated: true)
//            break
//        case ExperienceType2Order.WhereWeWillBe.rawValue:
//            let title  = ExperienceType2Order.WhereWeWillBe.title
//            let subtitle = modelRoomDetails.whereWillBe!
//            let readMoreScreen = ExperienceReadMoreController()
//            readMoreScreen.titleString = title
//            readMoreScreen.subTitle = subtitle
//            self.navigationController?.pushViewController(readMoreScreen, animated: true)
//            break
//        case ExperienceType2Order.MeetYourHost.rawValue:
//            let title = ExperienceType2Order.MeetYourHost.title + ", \(modelRoomDetails.hostUserName!)"
//            let subtitle = modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.MeetYourHost.keyToDisplay] as! String
//            let readMoreScreen = ExperienceReadMoreController()
//            readMoreScreen.titleString = title
//            readMoreScreen.subTitle = subtitle
//            self.navigationController?.pushViewController(readMoreScreen, animated: true)
//        case ExperienceType2Order.WhatWeWillDo.rawValue:
//            let title  = ExperienceType2Order.WhatWeWillDo.title
//            let subtitle = modelRoomDetails.dictionaryRepresentation()[ExperienceType2Order.WhatWeWillDo.keyToDisplay] as! String
//            let readMoreScreen = ExperienceReadMoreController()
//            readMoreScreen.titleString = title
//            readMoreScreen.subTitle = subtitle
//            self.navigationController?.pushViewController(readMoreScreen, animated: true)
//        default:
//            break
//        }
//    }

}

}
extension ExperienceDetailsController: ReadMoreClickable {
    func didTapReadMoreButton(title: String, subTitle: String) {
        let readMoreScreen = ExperienceReadMoreController()
        readMoreScreen.titleString = title
        readMoreScreen.subTitle = subTitle
        self.navigationController?.pushViewController(readMoreScreen, animated: true)
    }
}

class ExprienceReviewTVC: UITableViewCell {
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
}
