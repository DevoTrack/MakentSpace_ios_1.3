/**
* SignUpDOB.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import Foundation

class SignUpDOB : UIViewController,UITextFieldDelegate
{
    @IBOutlet var txtFldDOB: UITextField!
    @IBOutlet var imgDOB: UIImageView!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var viewDOBHolder: UIView!

    @IBOutlet weak var msglab: UILabel!
    @IBOutlet var viewObjectHolder: UIView!
    @IBOutlet var scrollObjHolder: UIScrollView!
    @IBOutlet var lblProgress: UIView!

    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var viewToastHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!

    @IBOutlet weak var dateView: UIView!
    var strFirstName = ""
    var strLastName = ""
    var strEmailId = ""
    var strPassword = ""

    var datePickerView:UIDatePicker? = UIDatePicker()
    var colorText = UIColor()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var fontStyleAndSize = UIFont()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let langAlignAff = Language.getCurrentLanguage()
   // @IBOutlet var viewGradient: UIView!
    var strOriginalDate = ""
    @IBOutlet weak var birthfsy_Titl: UILabel!
    
    @IBOutlet weak var when_Birthday: UILabel!
    var getCurrentPage:CGFloat = 0.0

    var getProgressVal:CGFloat = 0.0
    
    @IBOutlet weak var back_Btn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       // MakentSupport().makeGradientColor(gradientView: viewGradient)
        self.when_Birthday.text = self.lang.whn_Bith
        self.birthfsy_Titl.text = self.lang.birth_Tit
        imgDOB.isHidden = true
        txtFldDOB.delegate = self
        btnSignUp.transform = langAlignAff.getAffine
        btnSignUp.nextButtonImage()
        back_Btn.transform = langAlignAff.getAffine
        if txtFldDOB.text != ""{
            btnSignUp.isUserInteractionEnabled = false
        }else{
           btnSignUp.isUserInteractionEnabled = false
        }
        msglab.text = "\(lang.birth_Desc)\(k_AppName.capitalized). \(lang.otherppl_Title)"
        lblErrorMsg.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblErrorMsg.appGuestTextColor()
        txtFldDOB.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        btnSignUp.isUserInteractionEnabled = false
        btnSignUp.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
        btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height/2
        self.dateView.appHostViewBGColor()
        self.dateView.isHidden = true
        self.view.addTap {
            self.view.endEditing(true)
        }
        viewToastHolder.isHidden = true
        let rect = UIScreen.main.bounds as CGRect
        
        viewObjectHolder.frame = CGRect(x: rect.size.width, y:viewObjectHolder.frame.origin.y,width:viewObjectHolder.frame.size.width ,height: viewObjectHolder.frame.size.height)
//        scrollObjHolder.contentSize = CGSize(width: rect.size.width*3, height:  scrollObjHolder.frame.size.height)
        getProgressVal = rect.size.width/4
        MakentSupport().makeViewAnimaiton(viewObj: viewObjectHolder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnSignUp)
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewToastHolder)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: viewToastHolder)
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnSignUp)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
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

    @IBAction func textFieldEditing(sender: UITextField) {
        // 6
        datePickerView?.datePickerMode = UIDatePicker.Mode.date

        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var comps = DateComponents()
        comps.year = -18
        let maxDate = calendar.date(byAdding: comps, to: currentDate)
//        comps.year = -30
//        let minDate = calendar.date(byAdding: comps, to: currentDate)
        datePickerView?.maximumDate = maxDate
//        datePickerView?.minimumDate = minDate
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                datePickerView?.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            } // Replace .inline with .compact
        }
        sender.inputView = datePickerView
//        self.dateView = datePickerView

        datePickerView?.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        let screenWidth = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(didPickDate)) //7
        toolBar.tintColor = .appHostThemeColor
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        sender.inputAccessoryView = toolBar //9
        
    }
    @objc func didPickDate(){
        if let datePicker = self.txtFldDOB.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "YYYY-MM-dd"
            //            dateformatter.dateStyle = .medium // 2-3
            self.txtFldDOB.text = dateformatter.string(from: datePicker.date) //2-4
        }
        
        self.txtFldDOB.resignFirstResponder() // 2-5
    }
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.calendar = .current
        txtFldDOB.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        strOriginalDate = dateFormatter.string(from: sender.date)
        btnSignUp.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
        btnSignUp.isUserInteractionEnabled = true
        imgDOB.isHidden = false

    }

    // MARK: Navigating to Email field View
    /*
     First & Last name filled or not
     and making user interaction enable/disable
     */

    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        btnSignUp.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
                self.makeProgressAnimaiton(percentage: self.getProgressVal*4)
                self.displayHomePage()
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    func makeTextfldAnimaiton() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.makeViewAnimaiton), userInfo: nil, repeats: false)
    }
    
    @objc func makeViewAnimaiton(viewObj:UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.txtFldDOB.becomeFirstResponder()
        }, completion: { (finished: Bool) -> Void in
        })
    }

    
    // MARK: AFTER SIGNUP COMPLETE
    /*
        Calling API
        Navigating to Home Page after signup completed
     */
   
    func displayHomePage()
    {
        self.view.endEditing(true)
        
        btnSignUp.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.showLoader), userInfo: nil, repeats: false)

        // Pass user data as NSData
        var dicts = [AnyHashable: Any]()
        dicts["email"] = strEmailId
        dicts["password"] = strPassword
        dicts["first_name"] = strFirstName
        dicts["last_name"] = strLastName
        dicts["dob"] = strOriginalDate
        if let addr = MakentSupport().getWiFiAddress() {
            dicts["ip_address"] = addr
        } else {
            dicts["ip_address"] = ""
        }
        dicts["auth_type"] = "email"
        dicts["auth_id"] = ""
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_SIGNUP as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            
            let loginData = response as! LoginModel
            OperationQueue.main.addOperation {
                
            if loginData.status_code == "0"{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(loginData.success_message, isSuccess: false)
                self.appDelegate.logoutFinish()
                return
                
            }
            if loginData.status_code == "1"
            {
                
                Constants().STOREVALUE(value: loginData.access_token as NSString, keyname: APPURL.USER_ACCESS_TOKEN)
                self.appDelegate.userToken = loginData.access_token as String
                SharedVariables.sharedInstance.userToken = loginData.access_token as String
                let token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
                print("token\(token)")
                let userDefaults = UserDefaults.standard
                userDefaults.set("guest", forKey:"getmainpage")
               
                self.appDelegate.resetFilersDates()
                _ = PipeLine.fireEvent(withName: K_PipeNames.reloadView)
                self.dismiss(animated: false, completion: {
                    self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                })
//                if self.appDelegate.lastPageMaintain == "explore"{
//                    self.dismiss(animated: true, completion: nil)
//                    self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
//                }
//                else if self.appDelegate.lastPageMaintain == "saved"{
//                    self.appDelegate.generateMakentLoginFlowChange(tabIcon: 1)
//                }
//                else if self.appDelegate.lastPageMaintain == "trips"{
//                    self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
//                }
//                else if self.appDelegate.lastPageMaintain == "inbox"{
//                    self.appDelegate.generateMakentLoginFlowChange(tabIcon: 3)
//                }
//                else if self.appDelegate.lastPageMaintain == "profile"{
//                    self.appDelegate.generateMakentLoginFlowChange(tabIcon:4)
//                }
////                else if {
////                    // redirect to map page
////                    let viewFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "MapRoomVC") as! MapRoomVC
////                    viewFilterVC.arrMapRoomData = self.appDelegate.arrExploreData
////                    viewFilterVC.min_Price = self.appDelegate.min_Price
////                    viewFilterVC.max_Price = self.appDelegate.max_Price
////                    viewFilterVC.dictParams = self.appDelegate.dictFilterParams
////                    viewFilterVC.hidesBottomBarWhenPushed = true
////                    self.navigationController?.pushViewController(viewFilterVC, animated: true)
////
////                }
//                else if self.appDelegate.lastPageMaintain == "ExpCal"  || self.appDelegate.lastPageMaintain == "ExpContact" || self.appDelegate.lastPageMaintain == "booking" || self.appDelegate.lastPageMaintain == "contact" || self.appDelegate.lastPageMaintain == "roomDetail" || self.appDelegate.lastPageMaintain == "map" {
//
//                    self.appDelegate.makentTabBarCtrler.tabBar.items?[4].title = tabBarTextCtrl.guestProfile.rawValue
//                    if self.appDelegate.lastPageMaintain == "map" {
//                        Constants().STOREVALUE(value: "ReloadExplore", keyname: RELOADEXPLORE)
//                    }
//                    self.dismiss(animated: false, completion: nil)
//                }
//
//                else{
//                    self.appDelegate.authenticationDidFinish(viewCtrl: self)
//                }
                self.view.appGuestViewBGColor()
            }
            else
            {
                self.viewToastHolder.isHidden = false
                self.view.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
                self.makeAttributeErrorMsg(message : loginData.success_message as NSString)

                self.btnSignUp.isUserInteractionEnabled = true
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
    
    @objc func showLoader()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
    }
    
    func makeAttributeErrorMsg(message : NSString)
    {
        let attributedString = NSMutableAttributedString(string: message as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: 14)!]))
        lblErrorMsg.attributedText = attributedString
    }
    
    // MARK: When User Press Close Button in Error Message
    @IBAction func onErrorTapped(_ sender:UIButton!)
    {
        viewToastHolder.isHidden = true
        self.view.appGuestViewBGColor()
            //.backgroundColor = UIColor(red: 0/255.0, green:166.0/255.0, blue:153.0/255.0 , alpha: 1.0)
    }
    
    func movePasswordScreen(isSuccess:Bool)
    {
        if isSuccess
        {
            UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
                let rect = MakentSupport().getScreenSize()
                self.getCurrentPage = 2.0
                self.makeProgressAnimaiton(percentage: self.getProgressVal*2)
                self.scrollObjHolder.setContentOffset(CGPoint(x: rect.size.width*2, y: 0), animated: true)
                MakentSupport().makeViewAnimaiton(viewObj: self.viewObjectHolder)
            }, completion: { (finished: Bool) -> Void in
                self.makeTextfldAnimaiton()
            })
        }
        else
        {
            self.viewToastHolder.isHidden = false
            self.view.appGuestViewBGColor()
                //.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
        }
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }

        self.view.endEditing(true)
//        var rect = UIScreen.main.bounds as CGRect
//        
//        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
//        {
//            rect = CGRect(x: 0, y:0,width: 1024 ,height: 768)
//        }
        
        self.navigationController?.popViewController(animated: false)
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
