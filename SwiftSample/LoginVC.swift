/**
* LoginVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

public let ErrorDomain: String! = "SwiftyJSONErrorDomain"
///Error code
public let ErrorUnsupportedType: Int! = 999
public let ErrorIndexOutOfBounds: Int! = 900
public let ErrorWrongType: Int! = 901
public let ErrorNotExist: Int! = 500

public enum Type :Int{
    
    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

class LoginVC: UIViewController,UITextFieldDelegate
{
    var colorText = UIColor()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var fontStyleAndSize = UIFont()
    @IBOutlet var txtFldEmailID: UITextField!
    @IBOutlet var txtFldPassword: UITextField!
    @IBOutlet var btnShowOrHide: UIButton!
    @IBOutlet var imgEmailId: UIImageView!
    @IBOutlet var imgPassword: UIImageView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var viewToastHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!
    @IBOutlet var imgRememberMe: UIImageView!
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet weak var remmember_Btn: UIButton!
    
    @IBOutlet weak var Login_Lbl: UILabel!
    
    @IBOutlet weak var emailadd_Lbl: UILabel!
    
    @IBOutlet weak var pass_Lbl: UILabel!
    
    @IBOutlet weak var rem_Btn: UIButton!
    
    
    @IBOutlet weak var forg_Btn: UIButton!
    
    var isRememberSelected = false
    var  userDefaults = UserDefaults.standard
    
    @IBOutlet weak var rememView: UIView!
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let langAlignAff = Language.getCurrentLanguage()
    
    @objc func onTappedForgetBtn() {
        let forgetVC  = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        forg_Btn.addTarget(self, action: #selector(self.onTappedForgetBtn), for: .touchUpInside)
        txtFldPassword.isSecureTextEntry = true
        imgEmailId.isHidden = true
        imgPassword.isHidden = true
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height/2
        viewToastHolder.isHidden = true
        self.forg_Btn.setTitle(self.lang.forg_Tit, for: .normal)
        self.Login_Lbl.text = self.lang.login_Title
        self.emailadd_Lbl.text = self.lang.email_Title
        self.pass_Lbl.text = self.lang.pass_Title
        btnLogin.transform = langAlignAff.getAffine
        self.lblErrorMsg.appGuestTextColor()
        self.btnLogin.nextButtonImage()
        back_Btn.transform = langAlignAff.getAffine
        btnShowOrHide.transform = self.getAffine
        btnShowOrHide.setTitle(self.lang.show_Title, for: UIControl.State.normal)
        self.rememView.addTap {
            if(self.isRememberSelected)
            {
                self.imgRememberMe.image = UIImage(named: "check_deselected.png")
                self.isRememberSelected = false
                self.userDefaults.set(false, forKey: "rememberselected")
            }
            else
            {
                self.imgRememberMe.image = UIImage(named: "check_selected.png")
                self.isRememberSelected = true
                self.userDefaults.set(true, forKey: "rememberselected")
            }
        }
//        remmember_Btn.transform = langAlignAff.getAffine
        
        self.remmember_Btn.titleLabel?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.remmember_Btn.setTitle(self.lang.remem_Tit, for: .normal)
        
        txtFldEmailID.textAlignment = langAlignAff.getTextAlignment(align: .left)
        txtFldPassword.textAlignment = langAlignAff.getTextAlignment(align: .left)
        
        let rememberMe = userDefaults.bool(forKey: "rememberselected")
        if(rememberMe)
        {
            imgRememberMe.image = UIImage(named: "check_selected.png")
            isRememberSelected = true
        }
        
        let username = userDefaults.object(forKey: "loginusername") as? NSString
        let password = userDefaults.object(forKey: "loginpassword") as? NSString
        if ((username != nil && username != "") && (password != nil && password != ""))
        {
            txtFldEmailID.text = (userDefaults.object(forKey: "loginusername") as! NSString) as String
            txtFldPassword.text = (userDefaults.object(forKey: "loginpassword") as! NSString) as String
            btnLogin.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
            btnLogin.isUserInteractionEnabled = true
        }
        else
        {
            btnLogin.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
            btnLogin.isUserInteractionEnabled = false
        }

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewToastHolder)
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnLogin)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: viewToastHolder)
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnLogin)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }
        let letght =  textField.text?.count

        if textField==txtFldEmailID
        {
            if  MakentSupport().isValidEmail(testStr: txtFldEmailID.text!)
            {
                imgEmailId.isHidden = false
            }
            else
            {
                imgEmailId.isHidden = true
            }
        }
        
        if textField==txtFldPassword
        {
            if letght!>7 {
                imgPassword.isHidden = false
            }
            else
            {
                imgPassword.isHidden = true
            }
        }
        
        self.checkLoginButtonStatus()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    // MARK: Checking Login Button status
    /*
     
    */
    func checkLoginButtonStatus()
    {
        if (txtFldEmailID.text?.count)!>0 &&
            MakentSupport().isValidEmail(testStr: txtFldEmailID.text!) &&
            (txtFldPassword.text?.count)!>=8
        {
            btnLogin.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
            btnLogin.isUserInteractionEnabled = true
        }
        else
        {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
        }
    }
    
    @IBAction func onLoginTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        
        if(isRememberSelected)
        {
            userDefaults.set(txtFldEmailID.text, forKey: "loginusername")
            userDefaults.set(txtFldPassword.text, forKey: "loginpassword")
        }
        else
        {
            userDefaults.set("", forKey: "loginusername")
            userDefaults.set("", forKey: "loginpassword")
        }
        
        btnLogin.isUserInteractionEnabled = false
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        
        var dicts = [AnyHashable: Any]()
        dicts["email"] = txtFldEmailID.text!
        dicts["password"] = txtFldPassword.text!
        if let addr = MakentSupport().getWiFiAddress() {
            dicts["ip_address"] = addr
        } else {
            dicts["ip_address"] = ""
        }
        

        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_LOGIN as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let loginData = response as! LoginModel
            OperationQueue.main.addOperation {
                if loginData.status_code == "1"
                {
                    Constants().STOREVALUE(value: loginData.access_token as NSString, keyname: APPURL.USER_ACCESS_TOKEN)
                    WebServiceHandler
                        .sharedInstance
                        .getWebService(wsMethod: .language,
                                       params: ["language":Language.getCurrentLanguage().rawValue], response: nil)
                    self.appDelegate.userToken = loginData.access_token as String
                    SharedVariables.sharedInstance.userToken = loginData.access_token as String
                    SharedVariables.sharedInstance.userID = loginData.user_id
                    let token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
                    print("token\(token)")
                    let userDefaults = UserDefaults.standard
                    userDefaults.set("guest", forKey:"getmainpage")
                    self.appDelegate.resetFilersDates()
                    _ = PipeLine.fireEvent(withName: K_PipeNames.reloadView)
                    self.dismiss(animated: false, completion: {
                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                    })
                   
                   /* if self.appDelegate.lastPageMaintain == "explore"{
                        self.dismiss(animated: false, completion: nil)
                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                    }
                    else if self.appDelegate.lastPageMaintain == "saved"{
                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 1)
                    }
                    else if self.appDelegate.lastPageMaintain == "trips"{
                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
                    }
                    else if self.appDelegate.lastPageMaintain == "inbox"{
                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 3)
                    }
                    else if self.appDelegate.lastPageMaintain == "profile"{
                        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 4)
                    }

//
                    else if self.appDelegate.lastPageMaintain == "ExpCal"  || self.appDelegate.lastPageMaintain == "ExpContact" || self.appDelegate.lastPageMaintain == "booking" || self.appDelegate.lastPageMaintain == "contact" || self.appDelegate.lastPageMaintain == "roomDetail" || self.appDelegate.lastPageMaintain == "map"{

                        self.appDelegate.makentTabBarCtrler.tabBar.items?[4].title = tabBarTextCtrl.guestProfile.rawValue
                        if self.appDelegate.lastPageMaintain == "map" {
                            Constants().STOREVALUE(value: "ReloadExplore", keyname: RELOADEXPLORE)
                        }
                        self.dismiss(animated: false, completion: nil)
                    }
                    else{
                        self.appDelegate.authenticationDidFinish(viewCtrl: self)
                    }*/
                    self.view.backgroundColor = UIColor(red: 0/255.0, green:166.0/255.0, blue:153.0/255.0 , alpha: 1.0)                    
                }
                else
                {
                    self.viewToastHolder.isHidden = true
                    self.view.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
                    self.appDelegate.createToastMessage(loginData.success_message as String, isSuccess: false)
                    //self.makeAttributeErrorMsg(message : loginData.success_message)
                }
                self.btnLogin.isUserInteractionEnabled = true
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.btnLogin.isUserInteractionEnabled = true
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }
    
    
    func makeAttributeErrorMsg(message : NSString)
    {
        let originalText = "Error Those credentials don't look right. Please try again."
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: 14)!]))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0), range: NSMakeRange(0, 5))
        
        lblErrorMsg.attributedText = attributedString
//        return attributedString
    }
    
    // MARK: When User Remember Me Button Tapped
    @IBAction func onRememberMeTapped(_ sender:UIButton!)
    {
        if(isRememberSelected)
        {
            imgRememberMe.image = UIImage(named: "check_deselected.png")
            isRememberSelected = false
            userDefaults.set(false, forKey: "rememberselected")
        }
        else
        {
            imgRememberMe.image = UIImage(named: "check_selected.png")
            isRememberSelected = true
            userDefaults.set(true, forKey: "rememberselected")
        }
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
        self.view.endEditing(true)
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: When User Press Show/Hide Password Characters
    @IBAction func onShowPasswordTapped(_ sender:UIButton!)
    {
        if (txtFldPassword.isSecureTextEntry)
        {
            btnShowOrHide.setTitle(self.lang.hide_Title, for: UIControl.State.normal)
            txtFldPassword.isSecureTextEntry = false
        }
        else
        {
            btnShowOrHide.setTitle(self.lang.show_Title, for: UIControl.State.normal)
            txtFldPassword.isSecureTextEntry = true
        }
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
