//
//  AddSpacePhotoViewController.swift
//  Makent
//
//  Created by trioangle on 28/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol CollectionDataPass {
    func getHeight(_ heightVal : CGFloat)
}

class AddSpacePhotoViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,CollectionDataPass, UINavigationControllerDelegate {

    @IBOutlet weak var spacePhotoCollection: UICollectionView!
    
    @IBOutlet weak var continueBtn: UIButton!
    let lang = Language.localizedInstance()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imagePicker = UIImagePickerController()
    var photoDataModel = [BasicStpData]()
    var photoData = BasicStpData()
    var isReOrder = false
    
    @IBOutlet weak var lblPhotoTitle: UILabel!
    
    @IBOutlet weak var lblPhotoDesc: UILabel!
    
    @IBOutlet weak var viewAddPhotos: UIView!
    @IBOutlet weak var lblAddPhotos: UILabel!
    var btnLeftMenu = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. Please upload atleast one photo.
        self.initViewLayoutAction()
        if photoData.isEditSpace{
            self.getVal()
        }        
    }
    func getHeight(_ heightVal: CGFloat) {
        self.spacePhotoCollection.contentSize.height = heightVal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photoData.crntScreenSetupState = .addPhoto
        self.navigationController?.navigationBar.backgroundColor = .white
    }
   
    
    func initViewLayoutAction(){
        
        self.spacePhotoCollection.register(UINib.init(nibName: "PhotoViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoViewCell")
//        self.spacePhotoCollection.delegate = self
//        self.spacePhotoCollection.dataSource = self
//        self.spacePhotoCollection.dragDelegate = self
//        self.spacePhotoCollection.dropDelegate = self
        self.spacePhotoCollection.dragInteractionEnabled = true
        self.spacePhotoCollection.reloadData()
        self.navigationController?.addProgress()
        self.addBackButton()
        self.title = self.lang.spacePhotoTitle
        self.lblPhotoTitle.TitleFont()
        self.lblPhotoDesc.DescFont()
        
        self.lblPhotoTitle.attributedText = self.coloredAttributedText(normal: "Use images to bring your space to life!", "*")
        self.lblPhotoDesc.text = "Guests want to know what your space looks like. If you have photos, now's the time to share them! don't worry - you can always come back later."
        self.addSpacePhotoButton()
        self.photoData.crntScreenSetupState = .addPhoto
        self.continueBtn.setfontDesign()
        self.continueBtn.addTap {
            if self.emptyAlert(){
                self.isReOrder = false
                self.updatePhotoDesc()
            }
        }
        self.viewAddPhotos.layer.borderWidth = 0.5
        self.viewAddPhotos.addTap {
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: self.lang.cancel_Title, destructiveButtonTitle: nil, otherButtonTitles: self.lang.takephoto_Title, self.lang.choosephoto_Title)
            actionSheet.show(in: self.view)
        }
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        
        
        
    }
    
    
    //Mark:- Alert Function
    func emptyAlert() -> Bool{
        if self.photoDataModel.isEmpty {
            self.appDelegate.createToastMessage(self.lang.photoUploadAlert, isSuccess: false)
            return false
        }
        return true
    }
    
    //Mark:- Api Call After Data Enter
     func updateDesc(){
        self.isReOrder = true
        self.updatePhotoDesc()
    }
    
    //Mark:- AddPhoto Navigation Button
    func addSpacePhotoButton() {
        
        btnLeftMenu.titleLabel?.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 30)
        btnLeftMenu.setTitle("+", for: .normal)
        btnLeftMenu.setTitleColor(UIColor.appGuestButtonBG, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTap {
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: self.lang.cancel_Title, destructiveButtonTitle: nil, otherButtonTitles: self.lang.takephoto_Title, self.lang.choosephoto_Title)
            actionSheet.show(in: self.view)
        }
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //Mark:- Getting Already Photos While Edit
    func getVal(){
        //self.photoDataModel = self.photoData.spacePhotos.array("space_photos")
            //(photoData.array("space_photos").compactMap({BasicStpData($0)}))!
        self.photoDataModel = (self.photoData.spacePhotos.compactMap({BasicStpData($0)}))
        self.spacePhotoCollection.reloadData()
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
      
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            
            self.photoUploadApi(spaceImage:pickedImage.fixOrientation())
            }
        dismiss(animated: true, completion: nil)
    }
    
    func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
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
            
        }
        
    }
   
    func updatePhotoDesc(){
        
        let token = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        var parameter = [String : Any]()
        
        let photos : [[String:AnyObject]] = self.photoDataModel.map({["image_url": $0.imageUrl,"id":$0.photoId,"highlights":$0.highlights]}) as [[String : AnyObject]]
        print(photos.toJSONString)
        
        //"\(photos)"
        //["image_url":photos,"id":id,"highlights":highlights]
        
        var provideDictArray = [[String:Any]]()
        var provideDict = [String:Any]()
        self.photoDataModel.forEach{ (newModel) in
            provideDict["image_url"] = newModel.imageUrl
            provideDict["id"] = newModel.id
            provideDict["highlights"] = newModel.highlights
            provideDictArray.append(provideDict)
        }
//        print(self.getJsonFormattedString(provideDictArray))
        
        
        parameter["token"] = token
        parameter["step"] = "setup"
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["space_photos"] = self.sharedUtility.getJsonFormattedString(provideDictArray)
        self.btnLeftMenu.isUserInteractionEnabled = false
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            if let _ = error{
                self.btnLeftMenu.isUserInteractionEnabled = true
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    self.btnLeftMenu.isUserInteractionEnabled = true
                    MakentSupport().removeProgress(viewCtrl: self)
                    if !self.isReOrder{
                    self.MoveToNext()
                    }
                    
                }else{
                    self.btnLeftMenu.isUserInteractionEnabled = true
                    print(json)
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                }
            }
        }
    }
    
    func deleteSpacePhoto(imageId : String){
         let token = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        var parameter = [String : Any]()
        parameter["token"] = token
        parameter["step"] = "setup"
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["image_id"] = imageId
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .deleteImage, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    self.photoDataModel = (json?.array("photos_list").compactMap({BasicStpData($0)}))!
                    self.spacePhotoCollection.reloadData()
                    MakentSupport().removeProgress(viewCtrl: self)
                    
                    
                }else{
                    print(json)
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                }
            }
        }
    }
    
    func photoUploadApi(spaceImage:UIImage){
       
        let token = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().fileUpload(endUrl: .imageUpload, params: ["token":token,"step":"setup","space_id":BasicStpData.shared.spaceID], imageData: spaceImage.jpegRepresentationData) { (json, error) in
            if let err = error{
                print("Error",err)
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    self.photoDataModel.removeAll()
                    self.photoDataModel = (json?.array("photos_list").compactMap({BasicStpData($0)}))!
                    self.spacePhotoCollection.reloadData()
                    MakentSupport().removeProgress(viewCtrl: self)
                   
                    
                }else{
                    print(json)
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                }
            }
        }
       
    }
    
    func MoveToNext(){
        let spaceFeature = SpaceFeaturesViewController.InitWithStory()
        //if self.photoData.isEditSpace{
            spaceFeature.bsicStp = self.photoData
            //spaceFeature.bsicStp.isEditSpace = self.photoData.isEditSpace
        //}
        spaceFeature.setupSpc = .style
        self.navigationController?.pushViewController(spaceFeature, animated: true)
    }
    
    class func InitWithStory(isToEdit: Bool)-> AddSpacePhotoViewController{
        let view = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "AddSpacePhotoViewController") as! AddSpacePhotoViewController
        view.photoData.isEditSpace = isToEdit
        return view
    }
    
    
    func reOrderItems(_ coordinator: UICollectionViewDropCoordinator,_ destinationIndexPath:IndexPath,_ collectionView: UICollectionView){
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath{
            collectionView.performBatchUpdates({

                let source = self.photoDataModel[sourceIndexPath.item]
                self.photoDataModel.remove(at: sourceIndexPath.item)
                self.photoDataModel.insert(source, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
             self.updateDesc()
             coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            
        }
        
       
    }
    
    // Helper method
    func previewParameters(forItemAt indexPath:IndexPath,collectionView:UICollectionView) -> UIDragPreviewParameters?     {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoViewCell
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: cell.photoView.frame)
        return previewParameters
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
extension AddSpacePhotoViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photoDataModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoViewCell
        
        cell.photoView.layer.cornerRadius = 5
        cell.photoView.elevate(2.0)
        
        cell.spaceDesc.layer.borderWidth = 0.5
        cell.spaceDesc.layer.borderColor = UIColor.lightGray.cgColor
        cell.spaceDesc.tag = indexPath.row
        cell.parent = self
        cell.photoDataModel = self.photoDataModel
        
        guard self.photoDataModel.count > indexPath.item else {return cell}
        cell.spaceImage.addRemoteImage(imageURL: self.photoDataModel[indexPath.item].imageUrl, placeHolderURL: "")
        cell.spaceImage.contentMode = .scaleAspectFill
        let photoData = self.photoDataModel[indexPath.row]
        cell.spaceImage.clipsToBounds = true
        //cell.spaceDesc.scrollToTop()
        
        if self.photoDataModel[indexPath.item].highlights != ""{
        cell.spaceDesc.text = self.photoDataModel[indexPath.row].highlights
        cell.spaceDesc.textColor = .black
        }else{
        cell.spaceDesc.placeHolder(indexPath.item, holdVal: self.lang.spcHighlgt)
        }
        
        if indexPath.row == 0 && self.photoDataModel.count == 1 {
            cell.btnDeleteImage.isHidden = false
        }
        else {
            cell.btnDeleteImage.isHidden = false
        }

        cell.btnDeleteImage.addTap {
            
            

            let alert = UIAlertController(title: self.lang.dele_Tit,
                                          message: self.lang.spcPhtAlert,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: self.lang.dele_Tit, style: .default, handler: { (action) in
                self.deleteSpacePhoto(imageId: photoData.photoId.description)
            }))
            alert.addAction(UIAlertAction(title: self.lang.cancel_Title, style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
}
extension AddSpacePhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 16, height: 240)
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
 
}


extension AddSpacePhotoViewController :UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    
        
        var dragItems = [UIDragItem]()
        let photoData = self.photoDataModel[indexPath.row].imageUrl as NSString
        let provider = NSItemProvider.init(object: photoData)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = photoData
        dragItems.append(dragItem)
        return dragItems
    }
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return previewParameters(forItemAt:indexPath,collectionView: collectionView)
    }
 
}
extension AddSpacePhotoViewController : UICollectionViewDropDelegate{
   
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag{
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath : IndexPath
        if let indexPath = coordinator.destinationIndexPath{
            destinationIndexPath = indexPath
        }else{
            let section = 0
            let itemsCount = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(item: itemsCount - 1, section: section)
        }
        
        if coordinator.proposal.operation == .move{
            self.reOrderItems(coordinator, destinationIndexPath, collectionView)
            
        }

        
    }
    
    
}
extension PhotoViewCell : UITextViewDelegate {
    
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //constrtDescText.constant = textView.contentSize.height
        
        if textView.text == self.lang.spcHighlgt{
            spaceDesc.text = ""
            spaceDesc.textColor = .black
        }else{
            spaceDesc.textColor = .black
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
       //constrtDescText.constant = textView.contentSize.height
    
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            spaceDesc.text = self.lang.spcHighlgt
            spaceDesc.textColor = .lightGray
        }else{
            self.photoDataModel[textView.tag].highlights = spaceDesc.text
            //Mark:- Calling Update photo function to update photo highlights to server
            if let myParent = self.parent as? AddSpacePhotoViewController {
                myParent.isReOrder = true
                myParent.updatePhotoDesc()
            }
        }
        
        textView.resignFirstResponder()
    }
    
}
//        cell.spaceImage.addTap {
//            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: self.lang.cancel_Title, destructiveButtonTitle: nil, otherButtonTitles: self.lang.takephoto_Title, self.lang.choosephoto_Title)
//            actionSheet.show(in: self.view)
//        }

extension UIImage {
    
    func btnSetImage(_ name : String) -> UIImage{
        let buttonImage = (UIImage(named: name)?.withRenderingMode(.alwaysTemplate))!
        return buttonImage
    }
   
    var pngRepresentationData: Data? {
        return self.pngData()
    }
    
    var jpegRepresentationData: Data? {
        return self.jpegData(compressionQuality: 1.0)
    }
}
