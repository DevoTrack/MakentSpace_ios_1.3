/**
* AddRoomDetails.swift
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
import PhotosUI
import AVKit

class AddRoomTVC: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var selectedButtonOutlet: UIButton!
    
    
    
    func unSelectedButton() {
        
    }
}

class AddRoomDetails : UIViewController,UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,HostHouseRulesDelegate,HostRoomLocationDelegate,EditPriceDelegate,DescribePlaceDelegate,OptionalDetailDelegate,EditTitleDelegate,RoomImageAddedDelegate,CurrencyChangedDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tblRoomDetail: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var btnHeader:UIButton!
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var viewPhotoHolder: UIView!
    @IBOutlet var lblAddPhoto: UILabel!
    @IBOutlet var btnListSpace: UIButton!
    @IBOutlet var viewTblFooder: UIView!
    @IBOutlet var viewProgress: UIView!
    @IBOutlet var lblStepsLeftTitle:UILabel!
    @IBOutlet var imgRoom:UIImageView!
    @IBOutlet var btnAddPhotoMain:UIButton!
    
    @IBOutlet weak var preview_Btn: UIButton!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var assets:Array<UIImage>? = []
    var assetIdentifiers:Array<String>? = []
    var phImageFileUrls:Array<NSURL>? = []
    var quickView:MLImagePickerQuickView?
    var hideListButtonStatus = ""

    @IBOutlet weak var backButton: UIButton!
    var listModel : ListingModel!
    var strRemaingSteps = ""
    var isListUnlisted : Bool = false

    var imagePicker = UIImagePickerController()
    var stretchableTableHeaderView : HFStretchableTableHeaderView! = nil
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var titleArray = [String]()
    var subTitleArray = [String]()
    let isStepsCompleted = UserDefaults.standard.bool(forKey: "isStepsCompleted")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         self.lblAddPhoto.text = self.lang.addpht_Tit
        backButton.isChangeArabicButton()
        self.backButton.appHostTextColor()
        self.preview_Btn.appHostTextColor()
        viewProgress.appHostViewBGColor()
        
        
        btnListSpace.appHostBGColor()
        titleArray = [self.lang.desplac_Title, self.lang.set_Price, self.lang.set_Addr, self.lang.sethous_Rules, self.lang.setbook_Type]
        subTitleArray = [self.lang.summ_Highlight, self.lang.sug_Price, self.lang.conf_Price, self.lang.guest_Agree, self.lang.guest_Book]
        var rectViewProgress = viewProgress.frame
        rectViewProgress.size.width = 0
        viewProgress.frame = rectViewProgress
        viewTblFooder.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        MakentSupport().makeSquareBorder(btnLayer: btnHeader, color: UIColor.white, radius: 5.0)
        stretchableTableHeaderView = HFStretchableTableHeaderView()
        stretchableTableHeaderView.stretchHeader(for: tblRoomDetail, with: viewHeader)
        btnAddPhoto.layer.borderColor = UIColor.white.cgColor
        btnAddPhoto.layer.borderWidth = 2.0
        btnAddPhoto.layer.cornerRadius = btnAddPhoto.frame.size.height/2
        preview_Btn.setTitle(self.lang.prev_Tit, for: .normal)
        appDelegate.strRoomID = listModel.room_id as String
        if (strRemaingSteps.count > 0) && (strRemaingSteps != "0")
        {
            lblStepsLeftTitle.text = String(format:"%@ \(lang.steps_LeftTitle)",strRemaingSteps)
        }
        else if strRemaingSteps == "0"
        {
            lblStepsLeftTitle.text = listModel.isListEnabled  == "Yes" ? lang.lis_Title : lang.unlis_Title
        }
        if listModel.room_status == "Pending"{
            viewTblFooder.isHidden = false
            btnListSpace.isHidden = false
            viewTblFooder.isUserInteractionEnabled = false
        }else{
            viewTblFooder.isUserInteractionEnabled = true
        }
       // btnListSpace.isHidden = (listModel.remaining_steps  == "0" && hideListButtonStatus == "1") || (listModel.isListEnabled == "No") ? true : false
        //viewTblFooder.isHidden = (listModel.remaining_steps  == "0" && hideListButtonStatus == "1") || (listModel.isListEnabled == "No") ? true : false
        self.setHeaderRoomImage()
        
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.checkRemaingSteps()
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    /*
     IF IMAGE THUMB COUNT IS > 0 WE ARE SETTING IMAGE
     */
    func setHeaderRoomImage()
    {
//        let color = UIColor.appHostTitleColor
        btnHeader.layer.borderColor = UIColor.black.cgColor
        if listModel.room_thumb_images != nil
        {
            if(listModel.room_thumb_images?.count)! > 0
            {
                imgRoom.addRemoteImage(imageURL: listModel.room_thumb_images?[0] as! String, placeHolderURL: "")
                    //.sd_setImage(with: NSURL(string: listModel.room_thumb_images?[0] as! String) as URL?, placeholderImage:UIImage(named:""))
                btnAddPhoto.isHidden = true
                lblAddPhoto.isHidden = true
                btnHeader.selectedListingButton()
            }
            else{
                btnAddPhoto.isHidden = false
                lblAddPhoto.isHidden = false
                imgRoom.image = UIImage(named:"addphoto_bg.png")
                btnHeader.setTitle("", for: .normal)
            }
        }
        else
        {
            btnAddPhoto.isHidden = false
            lblAddPhoto.isHidden = false    
            imgRoom.image = UIImage(named:"addphoto_bg.png")
            btnHeader.setTitle("", for: .normal)
        }
    }
    
    func showRemainStepsProgress(remaingSteps: String)
    {
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(), animations: { () -> Void in
            let rect = UIScreen.main.bounds as CGRect
            let nRemaining = rect.size.width / 6
            var rectViewProgress = self.viewProgress.frame
            let remainingsteps = 6 - Int(remaingSteps)!
            rectViewProgress.size.width = CGFloat(remainingsteps) * nRemaining
            self.viewProgress.frame = rectViewProgress
            
            
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    func checkRemaingSteps()
    {
        var nTotalSteps = 5
        if (listModel.room_thumb_images?.count)! > 0
        {
            nTotalSteps -= 1
        }
        if(listModel.room_description as String).count > 0 && (listModel.room_title as String).count > 0
        {
            nTotalSteps -= 1
        }
        if(listModel.room_price as String).count > 0 && (listModel.room_price as String) != "0"
        {
            nTotalSteps -= 1
        }
        if(listModel.room_location as String).count > 0
        {
            nTotalSteps -= 1
        }
        //beds_count
        if(listModel.bedroom_count as String).count > 0
        {
            nTotalSteps -= 1
        }
        self.showRemainStepsProgress(remaingSteps: String(format:"%d",nTotalSteps))
        viewTblFooder.isUserInteractionEnabled = true
        if nTotalSteps == 0 && appDelegate.isStepsCompleted == false && listModel.isListEnabled == "No"
        {
            viewTblFooder.isHidden = false
            btnListSpace.isHidden  = false
//            self.onListSpace()
            lblStepsLeftTitle.text = listModel.isListEnabled == "Yes" ? self.lang.lis_Title : self.lang.ready_List
            tblRoomDetail.tableFooterView = viewTblFooder
            btnListSpace.setTitle((listModel.isListEnabled == "Yes") ? self.lang.unlis_Title : self.lang.pend_Tit, for: .normal)
            viewTblFooder.isUserInteractionEnabled = (listModel.isListEnabled == "Yes")
        }else if (listModel.room_status == "Pending"){
            viewTblFooder.isHidden = false
            viewTblFooder.isUserInteractionEnabled = false
            btnListSpace.isUserInteractionEnabled = false
            btnListSpace.isHidden  = false
            tblRoomDetail.tableFooterView = viewTblFooder
            btnListSpace.setTitle((listModel.isListEnabled == "Yes") ? self.lang.unlis_Title : self.lang.pend_Tit, for: .normal)
            viewTblFooder.isUserInteractionEnabled = (listModel.isListEnabled == "Yes")
        }
        else
        {
            tblRoomDetail.tableFooterView = nil
            lblStepsLeftTitle.text = listModel.isListEnabled == "Yes" ? lang.lis_Title : lang.unlis_Title
            lblStepsLeftTitle.text = (nTotalSteps == 0) ? (listModel.isListEnabled == "Yes" ? lang.lis_Title : lang.unlis_Title) : String(format:"%d \(self.lang.steps_LeftTitle)",nTotalSteps)
            viewTblFooder.isHidden = true
            btnListSpace.isHidden  = true
        }
    }
    
    //MARK: List or Unlist Your Space Btn Action
    
    func onListSpace(){
        var dicts = [AnyHashable: Any]()
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = appDelegate.strRoomID
        dicts["language"] = Language.getCurrentLanguage().rawValue
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_DISABLE_LISTING as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                
                if gModel.status_code == "1"
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAdded"), object: self, userInfo: nil)
                    self.changeRoomStatus()
                    //UserDefaults.standard.set(true, forKey: "isStepsCompleted")
                    self.appDelegate.isStepsCompleted = true
                    //                    self.hideListButtonStatus = "1"
                    //                    self.viewWillAppear(false)
                }
                else
                {
                    if gModel.success_message == "Room Listing Not Completed" {
                        self.appDelegate.createToastMessage(self.lang.nolis_Err, isSuccess: false)
                    }else{
                        self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    }
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
    
    
    @IBAction func onListSpaceTapped(_ sender:UIButton!)
    {
        var dicts = [AnyHashable: Any]()
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = appDelegate.strRoomID
        dicts["language"] = Language.getCurrentLanguage().rawValue
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_DISABLE_LISTING as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                
                if gModel.status_code == "1"
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAdded"), object: self, userInfo: nil)
                    self.changeRoomStatus()
                    //UserDefaults.standard.set(true, forKey: "isStepsCompleted")
                    self.appDelegate.isStepsCompleted = true
//                    self.hideListButtonStatus = "1"
//                    self.viewWillAppear(false)
                }
                else
                {
                    if gModel.success_message == "Room Listing Not Completed" {
                    self.appDelegate.createToastMessage(self.lang.nolis_Err, isSuccess: false)
                    }else{
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    }
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

    func changeRoomStatus()
    {
        
         lblStepsLeftTitle.text = listModel.isListEnabled == "Yes" ? self.lang.lis_Title : self.lang.ready_List
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.isListEnabled = listModel.isListEnabled == "Yes" ? "No" : "Yes"
        
        lblStepsLeftTitle.text = listModel.isListEnabled == "Yes" ? self.lang.lis_Title : self.lang.ready_List
        tblRoomDetail.tableFooterView = nil
        viewTblFooder.isHidden = true

        self.listModel = tempModel
    }
    
    //MARK: - ***********TABLEVIEW OPERATION************
    //MARK: Add aRoom Detail Table view Handling
    /*
     Add Room Detail View Table Datasource & Delegates
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {

        if indexPath.row < titleArray.count {
            return 75
        }else {
            return 60
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titleArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row < titleArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addRoomTVC") as! AddRoomTVC
            cell.titleLabel.appHostTextColor()
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.subTitleLabel.text = subTitleArray[indexPath.row]
            
           
            
            if cell.titleLabel.text == self.lang.desplac_Title {
                if(listModel.room_description as String).count > 0 && (listModel.room_title as String).count > 0
                {
                    cell.selectedButtonOutlet.selectedListingButton()
                    cell.subTitleLabel.text = listModel.room_description.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!
                }
            }
            else if cell.titleLabel.text == self.lang.set_Price {
                if(listModel.room_price as String).count > 0 && (listModel.room_price as String) != "0"
                {
                    cell.selectedButtonOutlet.selectedListingButton()
                    cell.subTitleLabel.text = String(format:"%@%@ \(self.lang.pernight_Title)",(listModel.currency_symbol as String).stringByDecodingHTMLEntities,listModel.room_price as String)
                }
            }
            else if cell.titleLabel.text == self.lang.set_Addr {
                if(listModel.room_location as String).count > 0
                {
                    if ((listModel.street_name as String).count)>0 && ((listModel.street_address as String).count)>0 && ((listModel.city_name as String).count)>0 && ((listModel.state_name as String).count)>0 && ((listModel.country_name as String).count)>0 && ((listModel.zipcode as String).count)>0
                    {
                        cell.subTitleLabel.text = String(format:"%@,%@,%@,%@,%@,%@",listModel.street_name,listModel.street_address,listModel.city_name,listModel.state_name,listModel.country_name,listModel.zipcode)
                    }
                    else
                    {
                        cell.subTitleLabel.text = listModel.room_location as String
                    }
                    
                     cell.selectedButtonOutlet.selectedListingButton()
                }
            }
            else if cell.titleLabel.text == self.lang.sethous_Rules {
                 cell.selectedButtonOutlet.isHidden = true
                if(listModel.additional_rules_msg as String).count > 0
                {
                    cell.selectedButtonOutlet.selectedListingButton()
                    cell.subTitleLabel.text = listModel.additional_rules_msg as String
                }
                else{
                    cell.selectedButtonOutlet.isHidden = true
                    cell.subTitleLabel.text = self.lang.guest_Agree
                }
            }
            else if cell.titleLabel.text == self.lang.setbook_Type {
                 cell.selectedButtonOutlet.isHidden = true
                if(listModel.booking_type as String).count > 0
                {
                     cell.selectedButtonOutlet.selectedListingButton()
                    // cell.lblBookType.text = self.lang.setbook_Type
                    if listModel.booking_type == "Instant Book"{
                    cell.subTitleLabel.text = self.lang.insbook_Title
                    }else{
                     cell.subTitleLabel.text = self.lang.reqbook_Title
                    }
                }
            }
            return cell
        }
        else
        {
            let cell:CellOptionalDetails = tblRoomDetail.dequeueReusableCell(withIdentifier: "CellOptionalDetails") as! CellOptionalDetails
            cell.opt_Det.text = self.lang.optidet_Title
            cell.cellimg.transform = Language.getCurrentLanguage().getAffine
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row >= titleArray.count
        {
            let optionalView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "OptionalDetailVC") as! OptionalDetailVC
            optionalView.delegate = self
            optionalView.strRoomId = listModel.room_id as String
            optionalView.listModel = listModel
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(optionalView, animated: true)
        }
        else {
            
            let cell = tableView.cellForRow(at: indexPath) as! AddRoomTVC
            if cell.titleLabel.text == self.lang.desplac_Title {
//                onAddressTapped(UIButton())
                onPlaceDetailTapped()
            }
            else if cell.titleLabel.text == self.lang.set_Price {
                onPriceTapped()
            }
            else if cell.titleLabel.text == self.lang.set_Addr {
                onAddressTapped(UIButton())
            }
            else if cell.titleLabel.text == self.lang.sethous_Rules {
                onHouseRulesTapped()
            }
            else if cell.titleLabel.text == self.lang.setbook_Type {
                onBookTypeTappped()
            }
        }
    }
    //MARK: *******************END**********************
    //MARK: -
    //MARK: AMENITIES CHANGED DELEGATE METHOD
    func AmenitiesChangedFrmOptional(strDescription: String)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.selected_amenities_id = strDescription as NSString
        self.listModel = tempModel
    }
    
    //MARK: ROOM CURRENCY CHANGE DELEGATE METHOD
    internal func RoomCurrencyChanged(listModel: ListingModel)
    {
        self.listModel = listModel
        tblRoomDetail.reloadData()
    }
    
    internal func listYourSpace(roomStatus:String)
    {
        if roomStatus == "Unlisted"
        {
            viewTblFooder.isHidden = false
            lblStepsLeftTitle.text = listModel.isListEnabled == "Yes" ? lang.lis_Title : lang.unlis_Title
            tblRoomDetail.tableFooterView = viewTblFooder
            btnListSpace.setTitle((listModel.isListEnabled == "Yes") ? lang.unlist_Space : lang.list_Space, for: .normal)
            self.hideListButtonStatus = "1"
            self.viewWillAppear(false)
            //UserDefaults.standard.set(true, forKey: "isStepsCompleted")
            appDelegate.isStepsCompleted = true
        }
        
    }

    internal func roomDisabled()
    {
        self.onBackTapped(nil)
    }
    
    //MARK: UPDATING LONG TERM PRICE - DELEGATE METHOD
    internal func UpdatedLongTermPrice(listModel:ListingModel)
    {
        self.listModel = listModel
    }
    
    //MARK: UPDATING ROOMS BEDS COUNT CHANGES - DELEGATE METHOD
    
    internal func RoomBedUpdatedFromOptional(listModel: ListingModel)
    {
        self.listModel = listModel
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        stretchableTableHeaderView.scrollViewDidScroll(scrollView)
    }
    
    override func viewDidLayoutSubviews()
    {
        stretchableTableHeaderView.resize()
    }
    
    // MARK: - HEADER IMAGE BTN TAPPED ACTION
    /*
      GOTO ADD ROOM IMAGE VIEW AND UPLODING ROOM IMAGE
     */
    @IBAction func onAddPhotoTapped(_ sender:UIButton!)
    {
        if listModel.room_thumb_images != nil
        {
            if (listModel.room_thumb_images?.count)! > 0
            {
//                let addImageVC = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomImageVC") as! AddRoomImageVC
                let addImageVC = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddRoomImageVC") as! AddRoomImageVC
                addImageVC.delegate = self
                //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
//                appDelegate.isStepsCompleted = false
                addImageVC.arrRoomImages = listModel.room_thumb_images?.mutableCopy() as! NSMutableArray
                addImageVC.arrRoomImageIds = listModel.room_thumb_image_ids?.mutableCopy() as! NSMutableArray
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addImageVC, animated: true)
            }
            else
            {
                let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: self.lang.cancel_Title, destructiveButtonTitle: nil, otherButtonTitles: self.lang.takephoto_Title, self.lang.choosephoto_Title)
                actionSheet.show(in: self.view)
            }
        }
        else
        {
            // DISPLAY ACTION SHEET
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: self.lang.cancel_Title, destructiveButtonTitle: nil, otherButtonTitles: self.lang.takephoto_Title, self.lang.choosephoto_Title)
            actionSheet.show(in: self.view)
        }
    }
    
    // MARK: ROOM IMAGE ADDED DELEGATE
    internal func RoomImageAdded(arrImgs:NSArray,arrImgIds:NSArray)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.room_thumb_images = arrImgs
        tempModel.room_thumb_image_ids = arrImgIds
        listModel = tempModel
        self.setHeaderRoomImage()
        self.appDelegate.isStepsCompleted = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAdded"), object: self, userInfo: nil)
    }
    
    // MARK: - ACTION SHEET DELEGATE METHOD
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            self.takePhoto()
        }
        else if buttonIndex == 2
        {
            self.choosePhoto()
        }
    }
    
    // MARK: - TAKE PHOTO
    func takePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let settingsActionSheet: UIAlertController = UIAlertController(title:self.lang.error_Tit, message:self.lang.nocam_Error, preferredStyle:UIAlertController.Style.alert)
            settingsActionSheet.addAction(UIAlertAction(title:self.lang.ok_Title, style:UIAlertAction.Style.cancel, handler:nil))
            present(settingsActionSheet, animated:true, completion:nil)
        }
      
    }
    
    // MARK: - CHOOSE PHOTO FROM GALLERY

    func choosePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let settingsActionSheet: UIAlertController = UIAlertController(title:self.lang.error_Tit, message:self.lang.nocam_Error, preferredStyle:UIAlertController.Style.alert)
            settingsActionSheet.addAction(UIAlertAction(title:self.lang.ok_Title, style:UIAlertAction.Style.cancel, handler:nil))
            present(settingsActionSheet, animated:true, completion:nil)
            
        }
        
    }
    
    // MARK: - UIImagePickerController Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) != nil {
            let pickedImageEdited: UIImage? = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage)
            let addImageVC = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddRoomImageVC") as! AddRoomImageVC
//            appDelegate.isStepsCompleted = false
            //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
            addImageVC.delegate = self
            addImageVC.roomImage = pickedImageEdited!
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addImageVC, animated: true)
            
        }
        dismiss(animated: false, completion: nil)
        
    }

    // MARK: - EDIT PLACE DETAIL
    func onPlaceDetailTapped()
    {
        let descView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DescripePlace") as! DescripePlace
        descView.delegate = self
//        appDelegate.isStepsCompleted = false
        //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
        descView.strTitle = (listModel.room_title as String).count > 0 ? listModel.room_title as String : ""
        descView.strRoomDesc = (listModel.room_description as String).count > 0 ? listModel.room_description as String : ""
        descView.strRoomId = listModel.room_id as String
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(descView, animated: true)
    }
    
    // MARK: - EDIT TITLE DELEGATE METHOD
    internal func roomDescriptionChanged(strDescription: NSString, isTitle: Bool)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        
        if isTitle
        {
            tempModel.room_title = strDescription as NSString
        }
        else
        {
            tempModel.room_description = strDescription as NSString
        }
        
        listModel = tempModel
        tblRoomDetail.reloadData()
        
    }
    
    // MARK: - GOTO UPDATE PRICE

    func onPriceTapped()
    {
//        let priceEditView = self.storyboard?.instantiateViewController(withIdentifier: "EditPriceVC") as! EditPriceVC
        let priceEditView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditPriceVC") as! EditPriceVC
        priceEditView.delegate = self
//        appDelegate.isStepsCompleted = false
        //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
        priceEditView.room_currency_code = listModel.currency_code as String
        priceEditView.room_currency_symbol = listModel.currency_symbol as String
        priceEditView.strPrice = listModel.room_price as String
        priceEditView.strRoomId = listModel.room_id as String
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(priceEditView, animated: true)
    }
    
    internal func updateAllRoomPrice(modelList : ListingModel)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.additionGuestFee = modelList.additionGuestFee
        tempModel.cleaningFee = modelList.cleaningFee
        tempModel.monthly_price = modelList.monthly_price
        tempModel.room_price = modelList.room_price
        tempModel.securityDeposit = modelList.securityDeposit
        tempModel.weekendPrice = modelList.weekendPrice
        tempModel.weekly_price = modelList.weekly_price
        self.appDelegate.isStepsCompleted = false
        listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    //MARK: EDIT BOOKING TYPE
    func onBookTypeTappped()
    {
//        let coutryView = self.storyboard?.instantiateViewController(withIdentifier: "CountryVC") as! CountryVC
        let coutryView = k_MakentStoryboard.instantiateViewController(withIdentifier: "CountryVC") as! CountryVC
        coutryView.delegate = self
        coutryView.isFromAddRoom = true
        coutryView.strApiMethodName = APPURL.METHOD_UPDATE_BOOKING_TYPE
        coutryView.strTitle = lang.booktyp_Tit
        coutryView.arrCurrencyData = ([self.lang.insbook_Title,self.lang.reqbook_Title] as NSArray).mutableCopy() as! NSMutableArray
        coutryView.strCurrentCurrency = listModel.booking_type as String
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(coutryView, animated: true)
    }
    
    internal func roomCurrencyChanged(strCurrencyCode: String, strCurrencySymbol: String)
    {
        // No need to implement
    }
    
    //MARK: EDIT BOOKING TYPE - DELEGATE METHOD
    internal func updateBookTypeOrPolicy(strDescription: String)
    {
        var tempModel = ListingModel()
        tempModel = self.listModel
        tempModel.booking_type = strDescription as NSString
        self.listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    //MARK: UPDATING CURRENCY - EDIT PRICE DELEGATE METHOD
    internal func currencyChangedInEditPrice(strCurrencyCode: String, strCurrencySymbol: String)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.currency_symbol = strCurrencySymbol as NSString
        tempModel.currency_code = strCurrencyCode as NSString
        listModel = tempModel
        self.appDelegate.isStepsCompleted = false
        tblRoomDetail.reloadData()
    }
    
    // EDIT PRICE CHANGED/ADDED DELEGATE
    internal func PriceEditted(strDescription: String)
    {
        if strDescription.count > 0
        {
            var tempModel = ListingModel()
            tempModel = listModel
            tempModel.room_price = strDescription as NSString
            listModel = tempModel
            tblRoomDetail.reloadData()
            self.appDelegate.isStepsCompleted = false
        }
    }
    
    //MARK: GOTO - SEDIT HOUSE RULES
    func onHouseRulesTapped()
    {
//        let propertyView = self.storyboard?.instantiateViewController(withIdentifier: "EditTitleVC") as! EditTitleVC
        let propertyView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditTitleVC") as! EditTitleVC
//        appDelegate.isStepsCompleted = false
        //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
        propertyView.strPlaceHolder = self.lang.expect_Behave
        propertyView.strTitle = self.lang.houserul_Titl
        propertyView.delegate = self
        propertyView.isFromRoomDesc = true
        propertyView.strAboutMe = listModel.additional_rules_msg as String
        propertyView.strRoomId = listModel.room_id as String
        self.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    //MARK: HOUSE RULES CHANGED - DELEGATE METHOD
    internal func EditTitleTapped(strDescription: NSString)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.additional_rules_msg = strDescription
        listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    
    // MARK:HOUSE RULES MESSGE ADDED DELEGATE
    internal func onHostHouserulesChanged(message : String)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.additional_rules_msg = message as NSString
        listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    // MARK:EDIT LOCATION CHANGED DELEGATE
    internal func onHostRoomLocaitonChanged(modelList:ListingModel)
    {
        listModel = modelList
       
        tblRoomDetail.reloadData()
    }
    
    //MARK: GOTO TO EDIT LOCATION
    @IBAction func onAddressTapped(_ sender:UIButton!)
    {
//        let locView = k_MainStoryboard.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        locView.delegateHost = self
        if ((listModel.street_name as String).count)>0 && ((listModel.street_address as String).count)>0 && ((listModel.city_name as String).count)>0 && ((listModel.state_name as String).count)>0 && ((listModel.country_name as String).count)>0 && ((listModel.zipcode as String).count)>0
        {
            locView.strRoomLocation = String(format:"%@,%@,%@,%@,%@,%@",listModel.street_name,listModel.street_address,listModel.city_name,listModel.state_name,listModel.country_name,listModel.zipcode)
            appDelegate.samVal = "1"
        }
        else
        {
            locView.strRoomLocation = listModel.room_location as String
             appDelegate.samVal = "1"
        }
        locView.strLongitude = listModel.longitude as String
        locView.strLatitude = listModel.latitude as String
        locView.listModel = listModel
        locView.isFromAddRoomDetail = true
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(locView, animated: true)
    }
    
    //MARK: GOTO TO PREVIEW - ROOM DETAIL PAGE

    @IBAction func onPreviewTapped(_ sender:UIButton!)
    {
//        let roomDetailView = self.storyboard?.instantiateViewController(withIdentifier: "RoomDetailPage") as! RoomDetailPage
//        roomDetailView.strRoomId = listModel.room_id as String
//        roomDetailView.hidesBottomBarWhenPushed = true
//        appDelegate.lastPageMaintain = ""
//        self.navigationController?.pushViewController(roomDetailView, animated: true)
        
        let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
        homeDetailVC.roomIDString = listModel.room_id as String
        homeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeDetailVC, animated: true)
        
        
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}


class CellRoomDetails: UITableViewCell
{
    @IBOutlet var lblPlaceDetail: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblSubAddress: UILabel!
    @IBOutlet var lblHouseRules: UILabel!
    @IBOutlet var lblBookType: UILabel!
    @IBOutlet var btnPlaceDetail: UIButton!
    @IBOutlet var btnPrice: UIButton!
    @IBOutlet var btnAddress: UIButton!
    @IBOutlet var btnHouseRules: UIButton!
    
    @IBOutlet var btnAddLocation: UIButton!
    @IBOutlet var btnBookType: UIButton!
    @IBOutlet var btnPlaceDetailMain: UIButton!
    @IBOutlet var btnPriceMain: UIButton!
    @IBOutlet var btnAddressMain: UIButton!
    @IBOutlet var btnHouseRulesMain: UIButton!
    @IBOutlet var btnBookTypeMain: UIButton!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func setDetails(modelList: ListingModel)
    {
        let color = UIColor(red: 255.0 / 255.0, green: 15.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0).cgColor
        
        if(modelList.room_description as String).count > 0 && (modelList.room_title as String).count > 0
        {
            btnPlaceDetail.layer.borderColor = color
            btnPlaceDetail.setTitle("9", for: .normal)
            lblPlaceDetail.text = modelList.room_description.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        }
        if(modelList.room_price as String).count > 0 && (modelList.room_price as String) != "0"
        {
            btnPrice.layer.borderColor = color
            btnPrice.setTitle("9", for: .normal)
            lblPrice.text = String(format:"%@%@ \(self.lang.pernight_Title)",(modelList.currency_symbol as String).stringByDecodingHTMLEntities,modelList.room_price as String)
        }
        if(modelList.room_location as String).count > 0
        {
            if ((modelList.street_name as String).count)>0 && ((modelList.street_address as String).count)>0 && ((modelList.city_name as String).count)>0 && ((modelList.state_name as String).count)>0 && ((modelList.country_name as String).count)>0 && ((modelList.zipcode as String).count)>0
            {
                lblSubAddress.text = String(format:"%@,%@,%@,%@,%@,%@",modelList.street_name,modelList.street_address,modelList.city_name,modelList.state_name,modelList.country_name,modelList.zipcode)
            }
            else
            {
                lblSubAddress.text = modelList.room_location as String
            }

            btnAddress.layer.borderColor = color
            btnAddress.setTitle("9", for: .normal)
        }
        if(modelList.additional_rules_msg as String).count > 0
        {
            btnHouseRules.layer.borderColor = color
            btnHouseRules.setTitle("9", for: .normal)
            lblHouseRules.text = modelList.additional_rules_msg as String
        }
        else{
            lblHouseRules.text = lang.guest_Agree
        }
        if(modelList.booking_type as String).count > 0
        {
            btnBookType.layer.borderColor = color
            btnBookType.setTitle("9", for: .normal)
            lblBookType.text = modelList.booking_type as String
        }
    }
}

class CellOptionalDetails: UITableViewCell
{
    @IBOutlet weak var cellimg: UIImageView!
    @IBOutlet weak var opt_Det: UILabel!
    @IBOutlet var lblPlaceDetail: UILabel!
}

class CellPricingDetails: UITableViewCell
{
    @IBOutlet var lblPlaceDetail: UILabel!
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
extension UIButton {
    func selectedListingButton() {
        let color = UIColor.appHostTitleColor
        self.backgroundColor = color
        self.isHidden = false
        self.layer.borderColor = color.cgColor
        self.setTitle("9", for: .normal)
        self.setTitleColor(.white, for: .normal)
    }
}
