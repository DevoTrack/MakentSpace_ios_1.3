/**
* FBSignUpVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

class FBSignUpVC: UIViewController,UITextFieldDelegate
{
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var lookGoodLbl: UILabel!
    @IBOutlet weak var makeSureLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet var txtFldFirstName: UITextField!
    @IBOutlet var txtFldLastName: UITextField!
    @IBOutlet var txtFldEmailID: UITextField!
    @IBOutlet var txtFldDOB: UITextField!
    @IBOutlet var imgFirstName: UIImageView!
    @IBOutlet var imgLastName: UIImageView!
    @IBOutlet var imgEmailId: UIImageView!
    @IBOutlet var imgDOB: UIImageView!
    @IBOutlet var btnSignUp: UIButton!
//    @IBOutlet var tableView: UIScrollView!
    @IBOutlet var lblProgress: UIView!

    @IBOutlet var viewToastHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!

   // @IBOutlet var viewGradient: UIView!
    var strOriginalDate = ""
    var datePickerView:UIDatePicker? = UIDatePicker()

    var getCurrentPage:CGFloat = 0.0

    var getProgressVal:CGFloat = 0.0
    var  userDefaults = UserDefaults.standard
    var previousResponse = JSONS()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.appGuestViewBGColor()
        self.tableView.tableFooterView = UIView()
        self.lookGoodLbl.text = "Looks good?"
        self.makeSureLbl.text = "Make sure your information is correct before continuing."
        self.firstNameLbl.text = self.lang.frstname_Tit
        self.lastNameLbl.text = self.lang.lstname_Tit
        self.dobLbl.text = self.lang.birth_Tit
        self.emailLbl.text = self.lang.email_Title.uppercased()
       // MakentSupport().makeGradientColor(gradientView: viewGradient)
        imgFirstName.isHidden = true
        imgLastName.isHidden = true
        imgEmailId.isHidden = true
        imgDOB.isHidden = true
        getCurrentPage = 0.0
        self.adjustSubViewFrames()
        
        btnSignUp.isUserInteractionEnabled = false
        btnSignUp.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height/2
        
        viewToastHolder.isHidden = true
        let rect = UIScreen.main.bounds as CGRect

//        tableView.contentSize = CGSize(width: rect.size.width*3, height:  tableView.frame.size.height)
        getProgressVal = rect.size.width/4
        makeProgressAnimaiton(percentage: 20)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustSubViewFrames), name: UIDevice.orientationDidChangeNotification, object: nil)
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let firstName = self.previousResponse.string("first_name")
        let lastName = self.previousResponse.string("last_name")
        let email = self.previousResponse.string("email")
        if !firstName.isEmpty {
            txtFldFirstName.text = firstName
            imgFirstName.isHidden = false
        }
        
        if !lastName.isEmpty {
            txtFldLastName.text = lastName
            imgLastName.isHidden = false
        }
        
        if !email.isEmpty {
            txtFldEmailID.text = email
            txtFldEmailID.isHidden = false
            txtFldEmailID.isUserInteractionEnabled = false
        }else {
            txtFldEmailID.isUserInteractionEnabled = true
        }
       
        
        self.view.addTap {
            self.txtFldDOB.resignFirstResponder()
        }
//        let dob = userDefaults.object(forKey: USER_DOB) as? NSString
//        if (dob != nil && dob != "")
//        {
//            txtFldDOB.text = (userDefaults.object(forKey: USER_DOB) as! NSString) as String
//            imgDOB.isHidden = false
//            strOriginalDate = (userDefaults.object(forKey: USER_DOB) as! NSString) as String
//        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnSignUp)
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewToastHolder)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(0.0)), animated: true)

        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: viewToastHolder)
            MakentSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnSignUp)
    }
    
    @objc func adjustSubViewFrames()
    {
        let rect = MakentSupport().getScreenSize()
        tableView.contentSize = CGSize(width: rect.size.width, height:  tableView.frame.size.height+140)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         self.view.appGuestViewBGColor()
    }
    
    // MARK: Setting Progress value and Animation
    func makeProgressAnimaiton(percentage:CGFloat)
    {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.lblProgress.frame = CGRect(x: 0, y: 0,width: percentage ,height: self.lblProgress.frame.size.height)
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }

        let letght =  textField.text?.count
        
        if textField==txtFldFirstName
        {
            if letght!>0
            {
                imgFirstName.isHidden = false
            }
            else
            {
                imgFirstName.isHidden = true
            }
        }
        
        if textField==txtFldLastName
        {
            if letght!>0
            {
                imgLastName.isHidden = false
            }
            else
            {
                imgLastName.isHidden = true
            }
        }
        
        if textField==txtFldEmailID
        {
            if letght!>0 && MakentSupport().isValidEmail(testStr: txtFldEmailID.text!)
            {
                imgEmailId.isHidden = false
            }
            else
            {
                imgEmailId.isHidden = true
            }
        }
        
        if textField==txtFldDOB
        {
            if letght!>=1  // Password should be 6 characters minimum
            {
                imgDOB.isHidden = false
            }
            else
            {
                imgDOB.isHidden = true
            }
        }
        
        self.checkNextButtonStatus()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == " ") {
            return false
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        if textField == self.txtFldFirstName   // FIRSTNAME
        {
            tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(50.0)), animated: true)
        }
        else if textField == self.txtFldLastName   // LASTNAME
        {
            tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(100.0)), animated: true)
        }
        else if textField == self.txtFldDOB   // DOB
        {
            tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(150.0)), animated: true)
        }
        else if textField == self.txtFldEmailID   // EMAIL ID
        {
            tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(200.0)), animated: true)
        }
        return true
    }


    @IBAction func textFieldEditing(sender: UITextField) {
        // 6
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
//        comps.year = -30
//        let minDate = calendar.date(byAdding: comps, to: currentDate)
        datePickerView?.maximumDate = maxDate
//        datePickerView?.minimumDate = minDate
        
        
        
        sender.inputView = datePickerView

        datePickerView?.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MMM-yyyy"

        txtFldDOB.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        strOriginalDate = dateFormatter.string(from: sender.date)
        imgDOB.isHidden = false

        self.checkNextButtonStatus()
    }

    // MARK: Checking Next Button status
    /*
        First & Last name filled or not
        and making user interaction enable/disable
     */
    func checkNextButtonStatus()
    {
        if (txtFldFirstName.text?.count)!>0 && (txtFldLastName.text?.count)!>0 && (txtFldDOB.text?.count)!>0 && (txtFldDOB.text?.count)!>0 && MakentSupport().isValidEmail(testStr: txtFldEmailID.text!)
        {
            btnSignUp.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            btnSignUp.isUserInteractionEnabled = true
        }
        else
        {
            btnSignUp.isUserInteractionEnabled = false
            btnSignUp.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    // MARK: Navigating to Email field View
    /*
     First & Last name filled or not
     and making user interaction enable/disable
     */

    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        self.checkEmailExist()
    }
    
    
    // MARK: AFTER SIGNUP COMPLETE
    /*
        Calling API
        Navigating to Home Page after signup completed
     */
    
    func showLoader()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
    }
    
    //MARK - EMAIL VALIDATION API CALLS
    /*
     Checking Email already Exist before sign up api call
     */
    func checkEmailExist()
    {
        self.view.endEditing(true)
        
//        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.showLoader), userInfo: nil, repeats: false)
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["email"] = txtFldEmailID.text!
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_EMAIL_VALIDATION as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            
            let loginData = response as! NSDictionary
            OperationQueue.main.addOperation {
                if loginData["status_code"] as! NSString == "1"
                {
                    self.wsToSignUpUserDetails()
                }
                else
                {
                    self.btnSignUp.isUserInteractionEnabled = true
                    self.makeAttributeErrorMsg(message : loginData["success_message"] as! NSString)
                   
                    self.viewToastHolder.isHidden = false
                    self.view.backgroundColor = Constants.monsterFavouriteColor
                    
                }
                
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.btnSignUp.isUserInteractionEnabled = true
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }

    //MARK - SIGN UP API CALLS
    func wsToSignUpUserDetails()
    {
        self.view.endEditing(true)
        
        btnSignUp.isUserInteractionEnabled = false
        
//        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.showLoader), userInfo: nil, repeats: false)
        
        // Pass user data as NSData
        var dicts = self.previousResponse
        dicts["email"] = txtFldEmailID.text!
        dicts["first_name"] = txtFldFirstName.text!
        dicts["last_name"] = txtFldLastName.text!
//        dicts["password"] = ""
        dicts["dob"] = strOriginalDate
        
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "signup", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                let model = LoginModel(jsons: responseDict)
                self.setDefaultProperties(token: model.access_token)
            }else {
                self.sharedAppDelegate.createToastMessage(responseDict.statusMessage)
                self.btnSignUp.isUserInteractionEnabled = true
            }
        }
//        dicts["fbid"] = Constants().GETVALUE(keyname: USER_FB_ID)

//        let dob = userDefaults.object(forKey: USER_IMAGE_THUMB) as? NSString
//        if (dob != nil && dob != "")
//        {
//            dicts["profile_pic"] = Constants().GETVALUE(keyname: USER_IMAGE_THUMB)
//        }
//
//
//        if let addr = MakentSupport().getWiFiAddress()
//        {
//            dicts["ip_address"] = addr
//        }
//        else
//        {
//            dicts["ip_address"] = ""
//        }
        
//        MakentAPICalls().GetRequest(dicts,methodName: METHOD_SIGNUP as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
//
//            let loginData = response as! LoginModel
//            OperationQueue.main.addOperation {
//            if loginData.status_code == "1"
//            {
//                Constants().STOREVALUE(value: loginData.access_token, keyname: USER_ACCESS_TOKEN)
//                WebServiceHandler
//                    .sharedInstance
//                    .getWebService(wsMethod: .language,
//                                   params: ["language":Language.getCurrentLanguage().rawValue], response: nil)
//                self.appDelegate.userToken = loginData.access_token as String
//                SharedVariables.sharedInstance.userToken = loginData.access_token as String
//                SharedVariables.sharedInstance.userToken = loginData.access_token as String
//                let token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//                print("token\(token)")
//                let userDefaults = UserDefaults.standard
//                userDefaults.set("travel", forKey:"getmainpage")
//                self.appDelegate.resetFilersDates()
//                _ = PipeLine.fireEvent(withName: K_PipeNames.reloadView)
//                self.dismiss(animated: false, completion: {
//                    self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
//                })
//            }
//            else
//            {
//                self.viewToastHolder.isHidden = false
//               self.view.backgroundColor = Constants.monsterFavouriteColor
//                self.makeAttributeErrorMsg(message : loginData.success_message)
//
//                self.btnSignUp.isUserInteractionEnabled = true
//            }
//
//                MakentSupport().removeProgress(viewCtrl: self)
//            }
//        }, andFailureBlock: {(_ error: Error) -> Void in
//            OperationQueue.main.addOperation {
//                self.btnSignUp.isUserInteractionEnabled = true
//                MakentSupport().removeProgress(viewCtrl: self)
//            }
//        })
    }
    
    func makeAttributeErrorMsg(message : NSString)
    {
        let attributedString = NSMutableAttributedString(string: message as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: 14)!]))
//        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0), range: NSMakeRange(0, 5))
        
        lblErrorMsg.attributedText = attributedString
        //        return attributedString
    }
    
    // MARK: When User Press Close Button in Error Message
    @IBAction func onErrorTapped(_ sender:UIButton!)
    {
        viewToastHolder.isHidden = true
        self.view.appGuestViewBGColor()
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }
        self.navigationController!.popViewController(animated: true)

        self.view.endEditing(true)
    }
    
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
