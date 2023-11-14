/**
* AddRoomImageVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol RoomImageAddedDelegate
{
    func RoomImageAdded(arrImgs:NSArray,arrImgIds:NSArray)
}


class AddRoomImageVC : UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate//,MLImagePickerControllerDelegate
{
    @IBOutlet var collectionRent: UICollectionView!
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var btnEditPhoto: UIButton!

    @IBOutlet weak var back_Btn: UIButton!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var imagePicker = UIImagePickerController()
    var delegate: RoomImageAddedDelegate?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var direction = 1.0
    // For API Calls
    
    @IBOutlet weak var add_Pht: UILabel!
    var roomImage:UIImage!
    var arrRoomImages : NSMutableArray = NSMutableArray()
    var arrRoomImageIds : NSMutableArray = NSMutableArray()
    var nSelectedIndex : Int = 0
    var isRemoveTapped : Bool = false
    var isImageIsUploading : Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.delegate = self
        btnAddPhoto.appHostSideBtnBG()
        btnEditPhoto.appHostTextColor()
        back_Btn.appHostTextColor()
        let rect = UIScreen.main.bounds as CGRect
        var rectCollection = collectionRent.frame
        rectCollection.size.height = rect.size.height-btnAddPhoto.frame.size.height-120
        collectionRent.frame = rectCollection
        
        self.add_Pht.text = self.lang.addpht_Tit
        self.btnEditPhoto.setTitle(self.lang.edt_Title, for: .normal)
        self.btnAddPhoto.setTitle(self.lang.addpht_Tit, for: .normal)
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine

        var rectAddPhotoBtn = btnAddPhoto.frame
        rectAddPhotoBtn.origin.y = rect.size.height-btnAddPhoto.frame.size.height-60
        btnAddPhoto.frame = rectAddPhotoBtn
        self.btnEditPhoto.isHidden = (self.arrRoomImages.count > 0) ? false : true

        // IF ROOM IMAGE HAS NO IMAGE & USER PASSING IMAGE FROM ADD ROOM DETAIL
        /*
          HERE WE ARE GOING TO UPLOAD FIRST IMAGE
         */
        if roomImage != nil && arrRoomImages.count == 0
        {
            uploadRoomImage(displayPic:roomImage.fixOrientation())
        }
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    // MARK: ***** UICollectionViewDataSource ******
    
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
            
            headerView.btnClearAll?.isHidden = isRemoveTapped ? false : true
            headerView.btnClearAll?.addTarget(self, action: #selector(self.onDeletePhotoInHeader), for: UIControl.Event.touchUpInside)

//            headerView.imgHeader?.image = UIImage(named:"addphoto_bg.png")
            if isRemoveTapped
            {
                YTAnimation.vibrateAnimation(headerView.viewImgHolder)
            }
            else{
                headerView.viewImgHolder?.layer.removeAnimation(forKey: "shake")
            }

            if arrRoomImages.count > 0
            {
                headerView.imgHeader?.addRemoteImage(imageURL: arrRoomImages[0] as! String, placeHolderURL: "")
                //sd_setImage(with: NSURL(string: arrRoomImages[0] as! String)as URL?, placeholderImage:UIImage(named:""))
                headerView.imgHeader?.backgroundColor = UIColor.lightGray
            }
            else
            {
                headerView.imgHeader?.backgroundColor = UIColor.clear
                headerView.imgHeader?.image = UIImage.init(named: "")
            }
            headerView.makeGradient()
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        if isImageIsUploading
//        {
//            (arrRoomImages.count>1) ? arrRoomImages.count-1 : 0
//        }
        return (arrRoomImages.count>1) ? arrRoomImages.count-1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let rect = MakentSupport().getScreenSize()
        return CGSize(width: (rect.size.width/3)-15, height: (rect.size.width/3)-15)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionRent.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CustomRentCell
        
        if isRemoveTapped
        {
            YTAnimation.vibrateAnimation(cell)
        }
        else
        {
            cell.layer.removeAnimation(forKey: "shake")
        }
        
        cell.btnBookmark?.tag = indexPath.row+1
        cell.btnBookmark?.isHidden = isRemoveTapped ? false : true
        cell.btnBookmark?.addTarget(self, action: #selector(self.onDeletePhotoTapped), for: UIControl.Event.touchUpInside)
        cell.animatedImageView?.isHidden = true
        
        cell.imageView?.backgroundColor = UIColor.lightGray
        cell.animatedImageView?.isHidden = true

        cell.imageView?.addRemoteImage(imageURL: arrRoomImages[indexPath.row+1] as! String, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: arrRoomImages[indexPath.row+1] as! String) as URL?, placeholderImage:UIImage(named:""))
        
        return cell
    }
    
//    func setCellVibrate(_ cell: CustomRentCell, indexPath: IndexPath) {
//        cell.indexPath = indexPath
//        cell.deleteBtn.isHidden = deleteBtnFlag ? true : false
//        if !vibrateAniFlag {
//            YTAnimation.vibrateAnimation(cell)
//        }
//        else {
//            cell.layer.removeAnimation(forKey: "shake")
//        }
//        cell.delegate = self
//    }
    
    
    // MARK: ****** CollectionView Delegate ******
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // ADD FEATURE REQUIREMENT
    }
    
    @objc func onDeletePhotoTapped(_ sender:UIButton!)
    {
        nSelectedIndex = sender.tag
        onDeletePhotoFromServer(strImgId: arrRoomImageIds[sender.tag] as! String)
    }
    
    @objc func onDeletePhotoInHeader()
    {
        nSelectedIndex = 0
        onDeletePhotoFromServer(strImgId: arrRoomImageIds[0] as! String)
    }
    
    // MARK: API CALL - DELETE IMAGE
    /*
     AFTER SELECTING IMAGE, PASSING IMAGE ID & ROOM_ID TO API CALL
     */
    func onDeletePhotoFromServer(strImgId: String)
    {
        MakentSupport().showProgressInWindow(viewCtrl:self , showAnimation:true)
        var dicts = [AnyHashable: Any]()
        
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]    = appDelegate.strRoomID
        dicts["image_id"]    = strImgId

        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_REMOVE_ROOM_IMAGE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                if gModel.status_code == "1"
                {
                    self.removeImageFromCollectionView()
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
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                self.collectionRent.reloadData()
            }
        })
    }
    
    
    // UPDATING COLLECTION VIEW AFTER DELETING IMAGE
    func removeImageFromCollectionView()
    {
        self.arrRoomImages.removeObject(at: self.nSelectedIndex)
        self.arrRoomImageIds.removeObject(at: self.nSelectedIndex)
        self.delegate?.RoomImageAdded(arrImgs:self.arrRoomImages.mutableCopy() as! NSArray, arrImgIds:self.arrRoomImageIds.mutableCopy() as! NSArray)
        isRemoveTapped = false
        self.collectionRent.reloadData()
        self.btnEditPhoto.isHidden = (self.arrRoomImages.count > 0) ? false : true
    }
    
    func makeCurrencySymbols(encodedString : String) -> String
    {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
    
    //MARK: ADD/TAKE PHOTO ACTIONSHEET
    @IBAction func onAddPhotoTapped(_ sender:UIButton!)
    {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: self.lang.cancel_Title, destructiveButtonTitle: nil, otherButtonTitles: self.lang.takephoto_Title, self.lang.choosephoto_Title)
        actionSheet.show(in: self.view)
    }
    
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
    
    func takePhoto()
    {
        //        let auth : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        //        if auth == AVAuthorizationStatus.authorized
        //        {
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
        //        }
        //        else if(auth == AVAuthorizationStatus.denied)
        //        {
        //            let settingsActionSheet: UIAlertController = UIAlertController(title:"Makent", message:"Please Allow Access to your Camera", preferredStyle:UIAlertControllerStyle.alert)
        //            settingsActionSheet.addAction(UIAlertAction(title:"Access", style:UIAlertActionStyle.default, handler:{ action in
        ////                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
        //                UIApplication.shared.openURL(URL(string: "app-settings:")!)
        //            }))
        //            settingsActionSheet.addAction(UIAlertAction(title:"Denied", style:UIAlertActionStyle.cancel, handler:nil))
        //            present(settingsActionSheet, animated:true, completion:nil)
        //        }
        //        else if auth == .notDetermined {
        //            // not determined?!
        //            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(_ granted: Bool) -> Void in
        //                if granted {
        //                    self.takePhoto()
        //                }
        //                else {
        //                }
        //            })
        //        }
    }
    
    func choosePhoto()
    {
        //        let auth : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        //        if auth == AVAuthorizationStatus.authorized
        //        {
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
            
        }
       
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    /*
        AFTER SELECTING IMAGE, PASSING IMAGE DATA TO API CALL
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
//            let pickedImageEdited: UIImage? = (info[UIImagePickerControllerEditedImage] as? UIImage)
//            let pickedImageEdited: UIImage? = (info[UIImagePickerControllerOriginalImage] as? UIImage)
            self.uploadRoomImage(displayPic:pickedImage.fixOrientation())
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UPLOAD ROOM IMAGE TO SERVER
    /*
        HERE WE ARE PASSING LOGIN USER ACCESS_TOKEN, ROOM_ID, IMAGE DATA
    */
    func uploadRoomImage(displayPic:UIImage)
    {
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        isImageIsUploading = true
        let url = URL(string:String(format:"%@%@",k_APIServerUrl,APPURL.API_UPLOAD_ROOM_IMAGE))
        var request = URLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        let image_data:NSData =  displayPic.jpegData(compressionQuality: 0.6)! as NSData
        let body = NSMutableData()
        let fname = String(format:"%@.jpg",appDelegate.strRoomID)  // need to change
        
        // Append Logged-In User Access Token
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"token\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN).data(using: String.Encoding.utf8.rawValue)!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)

        // Append Logged-In User Room ID
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"room_id\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append((appDelegate.strRoomID as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        // Appnend Image Data
        body.append("Content-Disposition:form-data; name=\"image\";filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpg\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Transfer-Encoding: binary\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard let _:Data = data, let _:URLResponse = response , error
                == nil else {
                    OperationQueue.main.addOperation {
                    MakentSupport().removeProgressInWindow(viewCtrl: self)
                    self.isImageIsUploading = false
                    }
                          print("error!")
                    return
            }
            
            do
            {
                let jsonResult : Dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary as Dictionary
                let items = jsonResult as NSDictionary
               
                OperationQueue.main.addOperation {
                    if (items.count>0)
                    {
                        let params = MakentSeparateParam().separate(params:  items, methodName: APPURL.METHOD_UPLOAD_PROFILE_IMAGE as NSString) as! NSDictionary
                        
                        let sts = params["success_message"] as! String
                        if params["image_urls"] != nil
                        {
                            self.arrRoomImages.add(params["image_urls"] as! String)
                            self.arrRoomImageIds.add(params["room_image_id"] as! String)
                            self.delegate?.RoomImageAdded(arrImgs:self.arrRoomImages.mutableCopy() as! NSArray, arrImgIds:self.arrRoomImageIds.mutableCopy() as! NSArray)
                            self.collectionRent.reloadData()
                            self.btnEditPhoto.isHidden = (self.arrRoomImages.count > 0) ? false : true
                        }
                        else{
                            var status = sts.components(separatedBy: ".")
                            let s1 = status[0]
                            //print(s1)
                            if s1 == "File size too large"{
                                
                            self.appDelegate.createToastMessage(self.lang.imglarge_Error, isSuccess: false)
                                
                            }
                            else{
                               
                               self.appDelegate.createToastMessage(self.lang.upload_Error, isSuccess: false)
                            }
                           
                        }
                        
                    }
                    else {
                          //print("error!!!")
                        self.appDelegate.createToastMessage(self.lang.upload_Error, isSuccess: false)
                       
                    }
                     MakentSupport().removeProgressInWindow(viewCtrl: self)
                    self.isImageIsUploading = false
                }
            }
            catch _ {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                
                self.appDelegate.createToastMessage(self.lang.upload_Error, isSuccess: false)
                self.isImageIsUploading = false
                
                //print("response!")
            }
        }
        
        task.resume()
    }
    // GETTING BOUNDARY STRING
    func generateBoundaryString() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: EDIT BTN ACTION
    // IF IMAGE COUNT IS 0, USER CAN VIEW EDIT BUTTON
    @IBAction func onRemovePhotoTapped(_ sender:UIButton!)
    {
        if btnEditPhoto.titleLabel?.text == self.lang.edt_Title
        {
            isRemoveTapped = true
            btnEditPhoto.titleLabel?.text = self.lang.done_Title
            btnEditPhoto.setTitle(self.lang.done_Title, for: .normal)
        }
        else
        {
            isRemoveTapped = false
            btnEditPhoto.titleLabel?.text = self.lang.edt_Title
            btnEditPhoto.setTitle(self.lang.edt_Title, for: .normal)
        }
        collectionRent.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
