/**
* WhishListDetailsVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol WhishListDetailDelegate
{
    func wishListChanged()
}

class WhishListDetailsVC : UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIActionSheetDelegate, ViewOfflineDelegate
{
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet var collectionWhishList: UICollectionView!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet weak var viewTapped: UIView!
    @IBOutlet weak var experienceBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var wishListDeleteButton: UIButton!
    var delegate: WhishListDetailDelegate?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var selectedCell : CustomRentCell!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrWishListData : NSMutableArray = NSMutableArray()

    var strListPrivacy = ""
    var strListId = ""
    var strListType = ""
    var strRoomId = ""
    var strListName = ""
    var strNewListName = ""

    @IBOutlet weak var bck_Btn: UIButton!
    @IBOutlet weak var nothing_Desc: UILabel!
    @IBOutlet weak var nothing_Title: UILabel!
    // For API Calls
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.strListType = "Rooms"
        self.emptyView.isHidden = true
        self.viewTapped.backgroundColor = .gray
        //self.swipeOption() // ****HIDE HOST EXPLERIENCE****
        self.wishListDeleteButton.isHidden = true
        self.nothing_Desc.text = self.lang.nothingsave_Desc
        self.nothing_Title.text = self.lang.nothing_Title
        self.homeBtn.setTitle(self.lang.Homes, for: .normal)
        self.experienceBtn.appGuestTextColor()
        self.experienceBtn.setTitle(self.lang.Experiences
            , for: .normal)
        self.bck_Btn.transform = Language.getCurrentLanguage().getAffine
/* ####### SHOW ONLY ROOMS ####### @START */
        /*experienceBtn.isHidden = true
        homeBtn.isHidden = true
        viewTapped.isHidden = true*/
/* ####### SHOW ONLY ROOMS ####### @END */
//        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
/* ####### HIDE HOST EXPLERIENCE ####### @START */
    func swipeOption(){
        self.view.addAction(for: closureActions.swipe_left) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [UIView.AnimationOptions.allowUserInteraction,UIView.AnimationOptions.layoutSubviews], animations: { () -> Void in
                
                if Language.getCurrentLanguage().isRTL{
                  self.viewTapped.transform = CGAffineTransform(translationX: self.viewTapped.frame.width - self.view.frame.width, y: 0)
                }else{
                self.viewTapped.transform = CGAffineTransform(translationX: self.viewTapped.frame.width, y: 0)
                }
                self.strListType = "Experience"
                self.experienceBtn.setTitleColor(UIColor.gray, for: .normal)
                
                self.homeBtn.appGuestTextColor()
                
                self.getParticularWishList()
            }, completion: { (finished: Bool) -> Void in
            })
        }
        self.view.addAction(for: closureActions.swipe_right) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                if Language.getCurrentLanguage().isRTL{
                    self.viewTapped.transform = CGAffineTransform(translationX: 0, y: 0)
                }else{
                    self.viewTapped.transform = CGAffineTransform.identity
                }
                self.strListType = "Rooms"
                self.homeBtn.setTitleColor(UIColor.gray, for: .normal)
                self.experienceBtn.appGuestTextColor()
                self.getParticularWishList()
            }, completion: { (finished: Bool) -> Void in
            })
        }
    }
/* ####### HIDE HOST EXPLERIENCE ####### @END */
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.isNavigationBarHidden = false
//        appDelegate.makentTabBarCtrler.hidesBottomBarWhenPushed = true
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.getParticularWishList()
        
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        getParticularWishList()
    }

    // MARK: - PARTICULAR WISHLIST API CALL
   
/* ####### HIDE HOST EXPLERIENCE ####### @START */
    func getParticularWishList()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        self.animatedLoader?.isHidden = false
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["list_id"]    = strListId
        if(strListType == "Experience"){
            dicts["list_type"]  = "Experiences"
        }else{
           dicts["list_type"]  = strListType
        }
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_GET_PARTICULAR_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                self.arrWishListData.removeAllObjects()
                if gModel.status_code == "1"
                {
                    
                    if gModel.arrTemp1.count>0
                    {
                        self.wishListDeleteButton.isHidden = false
                        self.arrWishListData.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                        if self.arrWishListData.count != 0 {
                            self.emptyView.isHidden = true
                            self.collectionWhishList.isHidden = false
                            self.collectionWhishList.reloadData()
                        }
                        else{
                            self.collectionWhishList.isHidden = true
                            self.emptyView.isHidden = false
                        }
                    }
                    else{
                        self.wishListDeleteButton.isHidden = true
                        self.collectionWhishList.isHidden = true
                        self.emptyView.isHidden = false
                    }
                }
                else
                {
                   // _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.animatedLoader?.isHidden = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
/* ####### HIDE HOST EXPLERIENCE ####### @END */
    
    
    // MARK: Filter or Map Action Tapped
    /*
     */
    @IBAction func onFilterOrMapTapped(sender:UIButton)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ExploreHeaderView",
                                                                             for: indexPath) as! ExploreHeaderView
            headerView.btnEdit?.addTarget(self, action: #selector(self.onEditTapped(_:)), for: UIControl.Event.touchUpInside)
            if strListType == "Experience"{
                headerView.lblRoomInfo?.text = (arrWishListData.count > 0) ? (String(format: (arrWishListData.count == 1) ? "%d Space" : "%d Spaces",arrWishListData.count)) : ""
            }
            else{
                headerView.lblRoomInfo?.text = (arrWishListData.count > 0) ? (String(format: (arrWishListData.count == 1) ? "%d Space" : "%d Spaces",arrWishListData.count)) : ""
            }
            
//            headerView.btnInvite.isHidden = true

            headerView.lblRoomInfo?.isHidden = (arrWishListData.count > 0) ? false : true

            headerView.lblHeaderTitle?.text = strListName
            return headerView
        default:
            fatalError(self.lang.unexp_KindErr)
        }
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return (arrWishListData.count>0) ? arrWishListData.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let rect = MakentSupport().getScreenSize()
        let modelWishList = arrWishListData[indexPath.row] as? ExploreModel
        return (modelWishList?.reviews_count == "0" || modelWishList?.reviews_count == "") ? CGSize(width: rect.size.width-20, height: 311-30) : CGSize(width: rect.size.width-20, height: 311)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionWhishList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CustomRentCell
        let modelWishList = arrWishListData[indexPath.row] as? ExploreModel
        let strSymbol = self.makeCurrencySymbols(encodedString: ((modelWishList?.currency_symbol as String?)!))
        if modelWishList?.instant_book != ""{
        if modelWishList?.instant_book.description == "No" || modelWishList?.instant_book.description == "0"
        {
            cell.lblRoomDetail?.text = ""
            cell.lblSpcname.text = "\(strSymbol)\((modelWishList?.room_price)!) \((modelWishList?.room_name.replacingOccurrences(of: "%20", with: " "))!)"
            cell.lblGuestCount.text = "\(modelWishList!.room_type.description) . \((modelWishList?.number_of_guest.description)!) People"
//            cell.lblRoomDetail?.text = "\(strSymbol)\((modelWishList?.room_price)!) Per Hour \((modelWishList?.room_name.replacingOccurrences(of: "%20", with: " "))!)\n\(modelWishList!.room_type.description) . \((modelWishList?.number_of_guest.description)!) People"



        }
        else{
            
            cell.lblSpcname.attributedText = Utilities.attributeForWishInstantBook(normalText: (String(format: "%@ %@",strSymbol,(modelWishList?.room_price)!)), spaceName:  String.init(format: "%@", (modelWishList?.room_name.replacingOccurrences(of: "%20", with: " "))!) ,boldText: "", fontSize: 18.0, isFirst: true)
            
            cell.lblGuestCount.attributedText = Utilities.attributeForWishInstantBook(normalText: "", spaceName:  "" ,boldText: (String(format: "%@ %@ %@ %@",(modelWishList?.room_type)!,".",(modelWishList?.number_of_guest.description)!,"People")), fontSize: 18.0, isFirst: false)
            
            

                

            }
        }
        else{
            cell.lblSpcname.text = ""
            cell.lblGuestCount.text = ""
            cell.lblRoomDetail?.attributedText =  MakentSupport().attributedInstantBookText(originalText: (String(format: "%@ %@ %@",strSymbol,(modelWishList?.room_price)!, (modelWishList?.room_name.replacingOccurrences(of: "%20", with: " "))!) as NSString), boldText: (String(format: "%@ %@",strSymbol,(modelWishList?.room_price)!) as NSString) as String, fontSize: 18.0)
        }
       
        appDelegate.strRoomID = modelWishList?.room_id as! String
        
        cell.imageView?.addRemoteImage(imageURL: modelWishList?.room_thumb_image as! String, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: modelWishList?.room_thumb_image as! String) as! URL, placeholderImage:UIImage(named:""))
        //(modelWishList?.rating_value)!
        cell.lblRating?.text = MakentSupport().createRatingStar(ratingValue: (modelWishList?.rating_value)!) as String
        //MakentSupport().createRatingStar(ratingValue: "5") as String
        cell.lblRating?.appGuestTextColor()
        cell.btnBookmark?.setBackgroundImage(UIImage(named: (modelWishList?.is_whishlist == "Yes") ? "heart_selected.png" : "heart_normal.png"), for: UIControl.State.normal)
        cell.lblRatingValue?.text = String(format: (modelWishList?.reviews_count == "1") ? "%@ \(lang.rev_Title)" : "%@ \(lang.revs_Title)", modelWishList?.reviews_count as! String)
        cell.lblRating?.isHidden = (modelWishList?.reviews_count == "0" || modelWishList?.reviews_count == "") ? true : false
        cell.lblRatingValue?.isHidden = (modelWishList?.reviews_count == "0" || modelWishList?.reviews_count == "") ? true : false
        cell.btnBookmark?.tag = indexPath.row
        cell.btnBookmark?.addTarget(self, action: #selector(self.onRemoveBookmarkTapped), for: UIControl.Event.touchUpInside)
        cell.setExploreData(ratingCount : modelWishList?.reviews_count as! String);
        return cell
    }
    
    // MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if strListType == "Experience"{
             //* Experience Start *//
            selectedCell = (collectionView.cellForItem(at: indexPath)! as! CustomRentCell)
            let experienceDetailsStoryboard = UIStoryboard(name: "ExperienceDetails", bundle: nil)
            let experienceDetails = experienceDetailsStoryboard.instantiateViewController(withIdentifier: "ExperienceDetailsController") as! ExperienceDetailsController
            selectedCell = (collectionView.cellForItem(at: indexPath)! as! CustomRentCell)
            let modelWishList = arrWishListData[indexPath.row] as? ExploreModel
            experienceDetails.hidesBottomBarWhenPushed = true
            experienceDetails.strRoomId = (modelWishList?.wishroom_id)!
            self.navigationController?.pushViewController(experienceDetails, animated: true)
             //* Experience End *//

        }
        else{
            selectedCell = (collectionView.cellForItem(at: indexPath)! as! CustomRentCell)
            let modelWishList = arrWishListData[indexPath.row] as? ExploreModel
//            let roomDetailView = self.storyboard?.instantiateViewController(withIdentifier: "RoomDetailPage") as! RoomDetailPage
//            roomDetailView.strRoomId = (modelWishList?.room_id as Any as! NSString) as String
//            roomDetailView.appDelegate.multipleDates = appDelegate.multipleDates
//            roomDetailView.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(roomDetailView, animated: true)
            
            let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
            homeDetailVC.roomIDString = (modelWishList?.room_id as Any as! NSString) as String
            homeDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeDetailVC, animated: true)
        }
    }
    
    func makeCurrencySymbols(encodedString : String) -> String
    {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }

    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func ExperiencTapped(_ sender:UIButton!)
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [UIView.AnimationOptions.allowUserInteraction,UIView.AnimationOptions.layoutSubviews], animations: { () -> Void in
            if Language.getCurrentLanguage().isRTL{
                self.viewTapped.transform = CGAffineTransform(translationX: self.viewTapped.frame.width - self.view.frame.width, y: 0)
            }else{
                self.viewTapped.transform = CGAffineTransform(translationX: self.viewTapped.frame.width, y: 0)
            }
        }, completion: { (finished: Bool) -> Void in
        })
        self.experienceBtn.setTitleColor(UIColor.gray, for: .normal)
        self.homeBtn.appGuestTextColor()
        self.strListType = "Experience"
        self.getParticularWishList()
    }
    
    @IBAction func HomeTapped(_ sender:UIButton!)
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            if Language.getCurrentLanguage().isRTL{
                self.viewTapped.transform = CGAffineTransform(translationX: 0, y: 0)
            }else{
                self.viewTapped.transform = CGAffineTransform.identity
            }
            
        }, completion: { (finished: Bool) -> Void in
        })
        self.homeBtn.setTitleColor(UIColor.gray, for: .normal)
        self.experienceBtn.appGuestTextColor()
        self.strListType = "Rooms"
        self.getParticularWishList()
        
    }
    func configurationTextField(textField: UITextField!)
    {
    }
    
    // MARK: When User Edit Button in header
    @objc func onEditTapped(_ sender:UIButton!)
    {
        let alertController = UIAlertController(title: self.lang.tit_Titl, message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: self.lang.sav_Chgs, style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                if field.text! != "" {
                    self.strNewListName = field.text!
                    self.strListName = field.text!
                    self.changePrivacyOrListname(isChangeListName:true)
               }
                else{
                    self.appDelegate.createToastMessage(self.lang.wish_name, isSuccess: false)
                }
            } else {
                // user did not fill field
                self.appDelegate.createToastMessage(self.lang.wish_name, isSuccess: false)
            }
        }
        let cancelAction = UIAlertAction(title: self.lang.cancel_Title, style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = self.lang.wis_Name
            textField.text = self.strListName
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: When User Press Share Button
    @IBAction func onShareTapped(_ sender:UIButton!)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        selectedCell = (collectionWhishList.cellForItem(at: indexPath)! as! CustomRentCell)
        let viewShare = k_MakentStoryboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        viewShare.hidesBottomBarWhenPushed = true
        viewShare.strRoomTitle = (selectedCell.lblRoomDetail?.text)!
        viewShare.strRoomUrl = ""
        viewShare.strShareUrl = "www.google.com"
        viewShare.strLocationName = strListName
        present(viewShare, animated: true, completion: nil)
    }
    
    @objc func onRemoveBookmarkTapped(sender:UIButton)
    {
        let modelWishList = arrWishListData[sender.tag] as? ExploreModel
        strRoomId = modelWishList?.room_id as? String ?? ""
        appDelegate.nSelectedIndex = sender.tag
        appDelegate.strRoomID = strRoomId
        let settingsActionSheet: UIAlertController = UIAlertController(title:self.lang.rem_List, message:String(format:"\(self.lang.want_DeleteAlert) \"%@\"?",(modelWishList?.room_name)!), preferredStyle:UIAlertController.Style.alert)
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.rem_Tit, style:UIAlertAction.Style.destructive, handler:{ action in
            self.deleteList(isDeleteSingleRoom : true)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }
    
    @IBAction func onMoreTapped(sender:UIButton)
    {
        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        settingsActionSheet.addAction(UIAlertAction(title:(strListPrivacy == "1") ? self.lang.mak_Pub : self.lang.mak_Priv, style:UIAlertAction.Style.default, handler:{ action in
            self.changePrivacyOrListname(isChangeListName:false)
            
        }))

        settingsActionSheet.addAction(UIAlertAction(title:self.lang.del_List, style:UIAlertAction.Style.destructive, handler:{ action in
            let editGuestAlert = UIAlertController(title: self.lang.del_List, message: "\(self.lang.want_DeleteAlert)\"\(self.strListName)\"?", preferredStyle: .alert)
            editGuestAlert.addAction(UIAlertAction(title: self.lang.cancel_Title, style: .cancel, handler: nil))
            editGuestAlert.addAction(UIAlertAction(title: self.lang.delete_Title, style: .destructive, handler: { alert -> Void in
                self.deleteList(isDeleteSingleRoom : false)
            }))
            self.present(editGuestAlert, animated: true, completion: nil)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:self.lang.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
        
        
        
    }
    
    //MARK: CHANGE PARTICULAR WISHLIST PRIVACY SETTINGS
    /*
     PRIVACY TYPE -> 0 - PUBLIC, 1 - PRIVATE
     */
    func changePrivacyOrListname(isChangeListName:Bool)
    {
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["list_id"]   = strListId
        dicts["list_type"]  =  strListType
        if isChangeListName
        {
            dicts["list_name"]   = YSSupport.escapedValue(strNewListName)
        }
        else
        {
            dicts["privacy_type"] = (strListPrivacy == "1") ? "0" : "1"
        }
        self.callAPIForWishlist(dicts:dicts,methodName: APPURL.METHOD_CHANGE_PRIVACY_WISHLIST,isChangeListName: isChangeListName)
    }
    
    //MARK: DELETE WISHLIST ALL ROOMS
    func deleteList(isDeleteSingleRoom : Bool)
    {
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//        if strListType == "Experience"{
//            dicts["list_type"]   = "Experiences"
//        }else{
//            dicts["list_type"]   = "Rooms"
//        }
        //dicts["list_type"]   = "Experiences"
        dicts["space_id"]   = strRoomId
        if isDeleteSingleRoom
        {
            dicts["space_id"]   = strRoomId
            
        }
        else
        {
            dicts["list_id"]   = strListId
        }
        callAPIForWishlist(dicts:dicts,methodName: APPURL.METHOD_DELETE_WISHLIST, isChangeListName: false)
    }
    
    func callAPIForWishlist(dicts : [AnyHashable: Any], methodName : String, isChangeListName:Bool)
    {
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        MakentAPICalls().GetRequest(dicts,methodName: methodName as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    if methodName == APPURL.METHOD_DELETE_WISHLIST
                    {
                        if dicts["list_id"] != nil {
                             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetWhishList"), object: nil)
                        }else {
                             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateWishlistForHomeandExperience"), object: nil)
                        }
                        SharedVariables.sharedInstance.lastWhistListRoomId = (self.strRoomId as NSString).integerValue
                       
                        self.appDelegate.isDeleteListing = true
                        self.updateCollectionView()
                        self.getParticularWishList()
                        
                    }
                    else if methodName ==  APPURL.METHOD_CHANGE_PRIVACY_WISHLIST
                    {
                        if !isChangeListName{
                        self.strListPrivacy = (self.strListPrivacy == "1") ? "0" : "1"
                        if (self.strListPrivacy == "1"){
                            self.appDelegate.createToastMessage(self.lang.wislis_Vis, isSuccess: false)
                            
                        }
                        else if(self.strListPrivacy == "0"){
                            self.appDelegate.createToastMessage(self.lang.wislis_Every, isSuccess: false)
                            
                        }
                            
                        }
                        if isChangeListName{
                       if gModel.success_message ==  "WishList Updated Successfully"{
                             self.appDelegate.createToastMessage(self.lang.wis_Updt, isSuccess: false)
                        }
                        }
                        
                    }
                    else{
                        self.strListName = self.strNewListName
                        self.collectionWhishList.reloadData()
                        if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                        {
                            self.appDelegate.logOutDidFinish()
                            return
                        }
                    }
                    self.delegate?.wishListChanged()

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAddedInWhishlist"), object: self, userInfo: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removesingleroomfromwhishlist"), object: self, userInfo: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Wishlist Deleted Successfully"), object: self, userInfo: nil)
                    
                    self.collectionWhishList.reloadData()
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
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
    
    func updateCollectionView()
    {
        if self.strRoomId.count > 0
        {
//            YTAnimation.suckEffectAnimation(selectedCell)
            self.strRoomId = ""
//            Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
            arrWishListData.removeObject(at: appDelegate.nSelectedIndex)
            collectionWhishList.reloadData()

        }
        else
        {
            arrWishListData.removeAllObjects()
            self.onBackTapped(nil)
        }
        
    }
    
    func update()
    {
        
        
        arrWishListData.removeObject(at: appDelegate.nSelectedIndex)
        collectionWhishList.reloadData()
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        switch (buttonIndex){
        case 1:
            break
        case 2:
            //            let alert = UIAlertController(title: "Delete this list", message: "Are you sure you want to delete \"Makawao\"?", preferredStyle: UIAlertControllerStyle.alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            //            self.present(alert, animated: true, completion: nil)
            break
            //            let sendMailErrorAlert = UIAlertView(title: "Delete this list", message: "Are you sure you want to delete \"Makawao\"?", delegate: self, cancelButtonTitle: "OK")
            //            sendMailErrorAlert.show()
            
        default:
            print("")
            break;
            //Some code here..
            
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
    }
    
    func shallMoveToNextPage() -> Bool {
        let yOffset: CGFloat = collectionWhishList.contentOffset.y
        let height: CGFloat = collectionWhishList.contentSize.height - collectionWhishList.frame.height
        return yOffset / height > 0.89
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        //        if isDataFinishedFromServer || isApiCalling
        //        {
        //            return
        //        }
        //
        //        let shouldLoadNextPage = shallMoveToNextPage() // When Scroll Reach Bottom Position
        //        if shouldLoadNextPage {
        //            nPageNumber += 1
        //            self.getRoomList(pageNumber: nPageNumber, isDelete: false)
        //            isApiCalling = true
        //        }
    }
    
    
    internal func onAddWhisListTapped(index:Int)
    {
        //        print(index)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
