/**
* EditProfileVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import AVFoundation

protocol EditProfileDelegate
{
    func profileInfoChanged()
}

class EditProfileVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,EditTitleDelegate, ViewOfflineDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet var imgUserThumb : UIImageView!
    @IBOutlet var viewHeader : UIView!
    @IBOutlet var tblViewProfile : UITableView!

    @IBOutlet var viewPickerHolder:UIView?
    @IBOutlet var btnSave : UIButton!
    @IBOutlet var btnCamera : UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var datePickerView:UIDatePicker? = UIDatePicker()
    var pickerView:UIPickerView? = UIPickerView()
    
    
    var delegate: EditProfileDelegate?
    
    var imagePicker = UIImagePickerController()
    var strOriginalDate = ""
    var imgUser : UIImage!
    
    var proImageModel : ProfileImageModel!
    
    var arrTitle = ["First name","Last name","About me","Gender","Birth date","Email","Location","School","Work"]
    var arrPlaceHolderTitle = ["Enter First name","Enter Last name","About me","Select Gender","Select Birth date","Enter Email","Enter Location","Enter School","Enter Work"]
    
    var arrValues = [String]()
    var arrDummyValues = [String]()
    var strFirstName:String = ""
    var strLastName:String = ""
    var strGender:String = ""
    var strDob:String = ""
    var strEmail:String = ""
    var strLocation:String = ""
    var strSchool:String = ""
    var strWork:String = ""
    var strAboutMe:String = ""
    var strPhoneNo:String = ""
    var strUserImgUrl:String = ""
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    
    var arrPickerData : NSArray!
    var selectedCell : CellEditProfile!
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var modelProfileData : ProfileModel!
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
         self.lblTitle.text = self.lang.editprof_Title
        lblTitle?.layer.shadowColor = UIColor.gray.cgColor;
        lblTitle?.layer.shadowOffset = CGSize(width:1.0, height:1.0);
        lblTitle?.layer.shadowOpacity = 1.5;
        lblTitle?.layer.shadowRadius = 1.0;
        self.navigationController?.isNavigationBarHidden = true
        btnSave.isHidden = true
        datePickerView?.locale = Language.getCurrentLanguage().locale
        btnSave.setTitle(self.lang.save_Tit, for: .normal)
        arrTitle = [self.lang.firstname_Tit,self.lang.lastname_Tit,self.lang.abtme_Tit,self.lang.gender_Tit,self.lang.bithdt_Tit,self.lang.email_Title,self.lang.loca_Tit,self.lang.schl_Tit,self.lang.wrk_Tit]
        arrPlaceHolderTitle = [self.lang.frst_Nam,self.lang.lst_Nam,self.lang.abt_Me,self.lang.sel_Gen,self.lang.sel_DOb,self.lang.ent_Email,self.lang.ent_Loc,self.lang.ent_Sch,self.lang.ent_wrk]
        if modelProfileData != nil
        {
            self.setDefaultUserInfo()
        }
        viewPickerHolder?.isHidden = true
        
        arrPickerData = [self.lang.notspeci_Title, self.lang.male_Title, self.lang.female_Title, self.lang.other_Title]

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    func setDefaultUserInfo()
    {
        strFirstName = modelProfileData.first_name as String
        strLastName = modelProfileData.last_name as String
        if modelProfileData.gender == "Male"{
            
            strGender = self.lang.male_Title
            
        }else if modelProfileData.gender == "Female"{
            
            strGender = self.lang.female_Title
        }else if modelProfileData.gender == "Other"{
            strGender = self.lang.other_Title
        }else{
            strGender = self.lang.notspeci_Title
        }
        strDob = modelProfileData.dob as String
        strEmail = modelProfileData.email_id as String
        strLocation = modelProfileData.user_location as String
        strSchool = modelProfileData.school as String
        strWork = modelProfileData.work as String
        strAboutMe = modelProfileData.about_me as String
        if strDob.count > 0
        {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let date1 = dateFormatter.date(from:strDob)
        //        print(date as Any)
        
        dateFormatter.locale = Language.getCurrentLanguage().locale
        strOriginalDate = dateFormatter.string(from: date1 ?? Date())
        }
        
        strDob = strDob.replacingOccurrences(of: " ", with: "-")
        arrValues = [strFirstName,strLastName,strAboutMe,strGender,strDob,strEmail,strLocation,strSchool,strWork]
        setUserImage()
        arrDummyValues = arrValues
        iPhoneScreenSizes()
        tblViewProfile.reloadData()
    }
    
    func setUserImage()
    {
//        strUserImgUrl = self.modelProfileData.user_normal_image_url as String
        imgUserThumb?.addRemoteImage(imageURL: modelProfileData.user_normal_image_url as String, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: modelProfileData.user_normal_image_url as String) as! URL, placeholderImage:UIImage(named:""))
        proImageModel = ProfileImageModel()
        proImageModel.large_image_url = modelProfileData.user_large_image_url
        proImageModel.normal_image_url = modelProfileData.user_normal_image_url
        proImageModel.small_image_url = modelProfileData.user_small_image_url
    }
    
    
    
    func iPhoneScreenSizes(){
        let bounds = UIScreen.main.bounds
        var rectEmailView = viewHeader.frame
        let width = bounds.size.width
        rectEmailView.size.height = width
        viewHeader.frame = rectEmailView
    }
    
    
    @IBAction func onAddPhotoTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        
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
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let settingsActionSheet: UIAlertController = UIAlertController(title:self.lang.error_Title, message:self.lang.nocam_Error, preferredStyle:UIAlertController.Style.alert)
                settingsActionSheet.addAction(UIAlertAction(title:self.lang.ok_Title, style:UIAlertAction.Style.cancel, handler:nil))
                present(settingsActionSheet, animated:true, completion:nil)
            }

    }
    
    func choosePhoto()
    {

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
            {
                imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                
            }

    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            let pickedImageEdited: UIImage? = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage)
            imgUserThumb.image = pickedImageEdited
            self.uploadProfileImage(displayPic:imgUserThumb.image!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImage(displayPic:UIImage)
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        let url = URL(string:String(format:"%@%@",k_APIServerUrl,APPURL.API_UPLOAD_PROFILE_IMAGE))
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        let image_data:NSData = displayPic.pngData()! as NSData
        let body = NSMutableData()
        
        let fname = String(format:"%@.png",modelProfileData.user_id)
        // Append Logged-In User ID
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"token\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN).data(using: String.Encoding.utf8.rawValue)!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        // Appnend Image Data
        body.append("Content-Disposition:form-data; name=\"image\";filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/png\r\n".data(using: String.Encoding.utf8)!)
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
                    MakentSupport().removeProgress(viewCtrl: self)
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
                        if params["normal_image_url"] != nil
                        {
                            self.proImageModel = ProfileImageModel().initiateProfileImageData(responseDict:params) as! ProfileImageModel
                            self.btnSave.isHidden = false
                            self.strUserImgUrl = params["normal_image_url"] as! String
                        }
                        else{
                            self.appDelegate.createToastMessage(self.lang.upload_Error, isSuccess: false)
                            
                        }
                        
                    }
                    else {
                        self.appDelegate.createToastMessage(self.lang.upload_Error, isSuccess: false)
                    }
                    MakentSupport().removeProgress(viewCtrl: self)
                }
            }
            catch _ {
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }
        
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    //MARK: ---------------------------------------------------------------
    //MARK: ***** Table view Datasource Methods *****
    /*
      Table view Datasource & Delegates
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 2
        {
            var height = 0
            if strAboutMe.count > 0
            {
                height = Int(MakentSupport().onGetStringHeight(self.view.frame.size.width-40, strContent: strAboutMe as NSString, font: UIFont (name: Fonts.CIRCULAR_LIGHT, size: 16)!))
                if height>60
                {
                    height = 60
                }
                else if height < 30
                {
                    height = 30
                }
            }
            return CGFloat(strAboutMe.count > 0 ? height+76 : 61)
        }
        else
        {
            return  97
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrValues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellEditProfile = tblViewProfile.dequeueReusableCell(withIdentifier: "CellEditProfile")! as! CellEditProfile
        
        if indexPath.row == 2 && strAboutMe.count > 0
        {
//            var height = MakentSupport().onGetStringHeight(self.view.frame.size.width-40, strContent: strAboutMe as NSString, font: UIFont (name: Fonts.CIRCULAR_LIGHT, size: 16)!)
//            if height>60
//            {
//                height = 60
//            }
//            else if height < 30
//            {
//                height = 30
//            }
            cell.lblAboutMe?.text = strAboutMe
//            var rectLblDetails = cell.lblAboutMe?.frame
//            rectLblDetails?.size.height = height+10
//            cell.lblAboutMe?.frame = rectLblDetails!
        }
        cell.txtTitle?.delegate = self
        cell.txtTitle?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblTitle?.text = arrTitle[indexPath.row]
        cell.lblTitle?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.txtTitle?.tag = indexPath.row
        cell.txtTitle?.placeholder = arrPlaceHolderTitle[indexPath.row]
        cell.txtTitle?.text = arrValues[indexPath.row]
        cell.imgAccessory?.isHidden = (indexPath.row == 2) ? true : false
        cell.contentView.backgroundColor = UIColor.white
        cell.lblAboutMe?.isHidden = (indexPath.row == 2) ? false :true
        cell.lblSubTitle?.isHidden = (indexPath.row == 2) ? false :true
        cell.txtTitle?.isHidden = (indexPath.row == 2) ? true :false
        cell.imgAccessory?.isHidden = true
        cell.lblSubTitle?.appGuestTextColor()
        cell.lblSubTitle?.text = (indexPath.row == 2) ? self.lang.edit_Tit : ""
        return cell
    }
    
    @IBAction func onTableRowTapped(_ sender:UIButton!)
    {
    }
    
    
    //MARK: ---- Table View Delegate Methods ----
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 2
        {
            if viewPickerHolder?.isHidden == false
            {
                viewPickerHolder?.isHidden = true
            }
            let propertyView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditTitleVC") as! EditTitleVC
            propertyView.strPlaceHolder = "dsds"
            propertyView.strTitle = "sdsd"
            propertyView.isFromEditProfile = true
            propertyView.strAboutMe = strAboutMe
            propertyView.delegate = self
            self.navigationController?.pushViewController(propertyView, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !(viewPickerHolder?.isHidden)!
        {
            viewPickerHolder?.isHidden = true
        }
    }
    
    internal func phoneNumberChanged(strDescription: NSString)
    {
        
    }
    
    // MARK: TextField Delegate Method
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        selectedCell = tblViewProfile.cellForRow(at: indexPath) as! CellEditProfile
        viewPickerHolder?.isHidden = true
        
        if textField.tag == 0   // FIRST NAME
        {
            selectedCell.txtTitle?.inputView = nil
            viewPickerHolder?.isHidden = true
            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(150.0)), animated: true)
        }
        else if textField.tag == 1   // LAST NAME
        {
            selectedCell.txtTitle?.inputView = nil
            viewPickerHolder?.isHidden = true
            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(300.0)), animated: true)
        }
        else if textField.tag == 3   // GENDER
        {
            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(420.0)), animated: true)
            pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 160))
            pickerView?.delegate = self
            pickerView?.delegate = self
            textField.inputView = pickerView!
        }
        else if textField.tag == 4   // BIRTH DATE
        {
            datePickerView?.datePickerMode = UIDatePicker.Mode.date
            if #available(iOS 13.4, *) {
                datePickerView?.preferredDatePickerStyle = .wheels
            
            } else {
                // Fallback on earlier versions
            }
            let calendar = Calendar(identifier: .gregorian)
            let currentDate = Date()
            var comps = DateComponents()
            comps.year = -18
            let maxDate = calendar.date(byAdding: comps, to: currentDate)
            datePickerView?.maximumDate = maxDate
            textField.inputView = datePickerView
//            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(500.0)), animated: true)
            datePickerView?.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
//            let screenWidth = UIScreen.main.bounds.width
//            let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
//            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
//            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(self.tapCancel)) // 6
//            let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(self.didPickDate)) //7
//            toolBar.tintColor = .appHostThemeColor
//            toolBar.setItems([cancel, flexible, barButton], animated: false) //8
//            textField.inputAccessoryView = toolBar //9
        }
        else if textField.tag == 5   // EMAIL ID
        {
            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(670.0)), animated: true)
        }
        else if textField.tag == 6   // LOCATION
        {
            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(750.0)), animated: true)
        }
        else if textField.tag == 7   // SCHOOL
        {
            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(840.0)), animated: true)
        }
        else if textField.tag == 8   // WORK
        {
            tblViewProfile.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(940.0)), animated: true)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        selectedCell = tblViewProfile.cellForRow(at: indexPath) as! CellEditProfile
        viewPickerHolder?.isHidden = true
        
        if textField.tag == 0   // FIRST NAME
        {
            strFirstName = textField.text!
        }
        else if textField.tag == 1   // LAST NAME
        {
            strLastName = textField.text!
        }
        else if textField.tag == 3   // GENDER
        {
        }
        else if textField.tag == 4   // BIRTH DATE
        {
            
        }
        else if textField.tag == 5   // EMAIL ID
        {
            strEmail = textField.text!
        }
        else if textField.tag == 6   // LOCATION
        {
            strLocation = textField.text!
        }
        else if textField.tag == 7   // SCHOOL
        {
            strSchool = textField.text!
        }
        else if textField.tag == 8   // WORK
        {
            strWork = textField.text!
        }
        
        arrValues = [strFirstName,strLastName,strAboutMe,strGender,strDob,strEmail,strLocation,strSchool,strWork]
        checkSaveButtonStatus()
    }
    
    func checkSaveButtonStatus()
    {
        if arrValues == arrDummyValues {
            btnSave.isHidden = true
        } else {
            btnSave.isHidden = false
        }
    }
    
    //MARK: ***** Date Picker Delegate Methods *****
    @objc func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Language.getCurrentLanguage().locale
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.calendar = .current
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        selectedCell.txtTitle?.text = dateFormatter.string(from: sender.date)
        strDob = dateFormatter.string(from: sender.date)
        
        arrValues = [strFirstName,strLastName,strAboutMe,strGender,strDob,strEmail,strLocation,strSchool,strWork]
        dateFormatter.dateFormat = "dd-MM-yyyy"
        checkSaveButtonStatus()
        
        strOriginalDate = dateFormatter.string(from: sender.date)
    }
//    @objc func didPickDate(){
//        if let datePicker = self.txtFldDOB.inputView as? UIDatePicker { // 2-1
//            let dateformatter = DateFormatter() // 2-2
//            dateformatter.dateFormat = "YYYY-MM-dd"
//            //            dateformatter.dateStyle = .medium // 2-3
//            self.txtFldDOB.text = dateformatter.string(from: datePicker.date) //2-4
//        }
//
//        self.txtFldDOB.resignFirstResponder() // 2-5
//    }
//    @objc func tapCancel() {
//        self.resignFirstResponder()
//    }
    
    
    // Following are the delegate and datasource implementation for picker view :
    
    //MARK: ***** Data Picker DataSource & Delegate Methods *****
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return arrPickerData[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedCell.txtTitle?.text = arrPickerData[row] as? String
        strGender = (arrPickerData[row] as? String)!
        arrValues = [strFirstName,strLastName,strAboutMe,strGender,strDob,strEmail,strLocation,strSchool,strWork]
        checkSaveButtonStatus()
    }
    
    //MARK: EDIT TITLE CHANGED DELEGATE METHOD
    func EditTitleTapped(strDescription: NSString)
    {
        strAboutMe = strDescription as String
        arrValues = [strFirstName,strLastName,strAboutMe,strGender,strDob,strEmail,strLocation,strSchool,strWork]
        tblViewProfile.reloadData()
        checkSaveButtonStatus()
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        self.navigationController!.popViewController(animated: true)
    }
    
    func getAllDetail(index : Int) -> String
    {
        let indexPath = IndexPath(row: index, section: 0)
        selectedCell = (tblViewProfile.cellForRow(at: indexPath) as! CellEditProfile)
        return ((selectedCell.txtTitle?.text)!.count > 0) ? (selectedCell.txtTitle?.text)! : ""
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        onSaveTapped(nil)
    }
    
    //MARK: SAVE ALL DETAILS
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
       
        var dicts = [AnyHashable: Any]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if arrValues[3] != ""{
            if arrValues[3] == lang.male_Title{
                arrValues[3] = "Male"
            }
            if arrValues[3] == lang.female_Title{
                arrValues[3] = "Female"
            }
//            if arrValues[3] == lang.notspeci_Title{
//                arrValues[3] = "Not Specified"
//            }
            if arrValues[3] == lang.other_Title{
                arrValues[3] = "Other"
            }
        }
        let date = dateFormatter.date(from:strOriginalDate)
        //        print(date as Any)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        strOriginalDate = dateFormatter.string(from: date ?? Date())
        dicts["token"]              = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["first_name"]         = arrValues[0].removingPercentEncoding!
        dicts["last_name"]          = arrValues[1].removingPercentEncoding!
        dicts["about_me"]           = strAboutMe.removingPercentEncoding!
        dicts["gender"]             = arrValues[3].removingPercentEncoding!
        dicts["dob"]                = strOriginalDate.removingPercentEncoding!
        dicts["email"]              = arrValues[5].removingPercentEncoding!
        dicts["phone"]              = strPhoneNo.removingPercentEncoding!
        dicts["user_location"]      = arrValues[6].removingPercentEncoding!
        dicts["school"]             = arrValues[7].removingPercentEncoding!
        dicts["work"]               = arrValues[8].removingPercentEncoding!
        if strUserImgUrl.count > 0
        {
            dicts["user_thumb_url"]     = strUserImgUrl
        }
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.METHOD_EDIT_PROFILE, paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            if responseDict.isSuccess {
                self.updateProfileModel()
            }else {
                self.appDelegate.createToastMessage(responseDict.statusMessage, isSuccess: false)
            }
        }
    }
    
    func updateProfileModel()
    {
        Constants().STOREVALUE(value: strUserImgUrl as NSString, keyname: APPURL.USER_IMAGE_THUMB)
        Constants().STOREVALUE(value: (strFirstName.removingPercentEncoding!) as NSString, keyname: APPURL.USER_FIRST_NAME)
        Constants().STOREVALUE(value: (modelProfileData.user_name.removingPercentEncoding!) as NSString, keyname: APPURL.USER_FULL_NAME)
        delegate?.profileInfoChanged()
        strUserImgUrl = ""
        self.onBackTapped(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellEditProfile : UITableViewCell
{
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var txtTitle: UITextField?
    @IBOutlet var lblSubTitle : UILabel?
    @IBOutlet var imgAccessory : UIImageView?
    @IBOutlet var lblAboutMe : UILabel?
}

class CellEditProfileOthers : UITableViewCell
{
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
