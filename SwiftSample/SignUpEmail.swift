/**
 * SignUpEmail.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */


import UIKit
import Foundation

class SignUpEmail: UIViewController,UITextFieldDelegate
{
    @IBOutlet var txtFldEmailID: UITextField!
    @IBOutlet var imgEmailId: UIImageView!
    @IBOutlet var btnEmailNext: UIButton!
    @IBOutlet var viewEmailHolder: UIView!
    
    @IBOutlet var viewObjectHolder: UIView!
    @IBOutlet var lblProgress: UIView!
    

    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var viewToastHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!

    @IBOutlet weak var email_Address: UILabel!
    // @IBOutlet var viewGradient: UIView!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var datePickerView:UIDatePicker? = UIDatePicker()
    var colorText = UIColor()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var fontStyleAndSize = UIFont()
    let langAlignAff = Language.getCurrentLanguage()
    var strFirstName = ""
    var strLastName = ""
    @IBOutlet weak var yremail_Tit: UILabel!
    
    @IBOutlet weak var back_Btn: UIButton!
    var strOriginalDate = ""
    
    var getCurrentPage:CGFloat = 0.0

    var getProgressVal:CGFloat = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       // MakentSupport().makeGradientColor(gradientView: viewGradient)
        imgEmailId.isHidden = true
        getCurrentPage = 0.0
        btnEmailNext.nextButtonImage()
        self.lblErrorMsg.appGuestTextColor()
        btnEmailNext.isUserInteractionEnabled = false
        
        btnEmailNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
        
        btnEmailNext.layer.cornerRadius = btnEmailNext.frame.size.height/2
        viewToastHolder.isHidden = true
        let rect = UIScreen.main.bounds as CGRect
        self.txtFldEmailID.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        if self.txtFldEmailID.text != ""{
            btnEmailNext.isUserInteractionEnabled = true
        }
        self.yremail_Tit.text = self.lang.yremail_Tit
        self.email_Address.text = self.lang.emailadd_Tit
        btnEmailNext.transform = langAlignAff.getAffine
        back_Btn.transform = langAlignAff.getAffine
        viewObjectHolder.frame = CGRect(x: rect.size.width, y:viewObjectHolder.frame.origin.y,width:viewObjectHolder.frame.size.width ,height: viewObjectHolder.frame.size.height)
        lblErrorMsg.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        getProgressVal = rect.size.width/4
        MakentSupport().makeViewAnimaiton(viewObj: viewObjectHolder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnEmailNext)
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewToastHolder)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: viewToastHolder)
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnEmailNext)
    }
        
    override func viewWillAppear(_ animated: Bool)
    {
        checkNextButtonStatus()
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

        checkNextButtonStatus()
    }
    
    func checkNextButtonStatus()
    {
        if (txtFldEmailID.text?.count)!>0 && MakentSupport().isValidEmail(testStr: txtFldEmailID.text!)
        {
            btnEmailNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
            btnEmailNext.isUserInteractionEnabled = true
            imgEmailId.isHidden = false
            self.makeProgressAnimaiton(percentage: self.getProgressVal*2)
        }
        else
        {
            btnEmailNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
            btnEmailNext.isUserInteractionEnabled = false
            imgEmailId.isHidden = true
            self.makeProgressAnimaiton(percentage: self.getProgressVal*1)
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

    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        btnEmailNext.isUserInteractionEnabled = false
        self.checkEmailExist()
    }
    
    func makeTextfldAnimaiton() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.makeViewAnimaiton), userInfo: nil, repeats: false)
    }
    
    @objc func makeViewAnimaiton(viewObj:UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
            if self.getCurrentPage == 1.0 {
                self.txtFldEmailID.becomeFirstResponder()
            }
        }, completion: { (finished: Bool) -> Void in
        })
    }

    
    // MARK: AFTER SIGNUP COMPLETE
    /*
        Calling API
        Navigating to Home Page after signup completed
     */
    
    @objc func showLoader()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
    }
   
    func movePasswordScreen(isSuccess:Bool)
    {
        self.viewToastHolder.isHidden = false
        self.view.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
    }

    
    @IBAction func goToPasswordPage()
    {
        self.view.endEditing(true)
        let propertyView = StoryBoard.account.instance.instantiateViewController(withIdentifier: "SignUpPassword") as! SignUpPassword
        propertyView.strFirstName = strFirstName
        propertyView.strLastName =  strLastName
        propertyView.strEmailId =  txtFldEmailID.text!
        self.navigationController?.pushViewController(propertyView, animated: false)
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
    }
    
    /*
        Checking Email already Exist before sign up api call
     */
    func checkEmailExist()
    {
        self.view.endEditing(true)
        self.showLoader()
        var dicts = [AnyHashable: Any]()
        dicts["email"] = txtFldEmailID.text!

        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_EMAIL_VALIDATION as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            
            let loginData = response as! NSDictionary
            OperationQueue.main.addOperation {
                if loginData["status_code"] as! NSString == "1"
                {
                    self.goToPasswordPage()
                }
                else
                {
                    self.movePasswordScreen(isSuccess:false)
                    self.makeAttributeErrorMsg(message : loginData["success_message"] as! NSString)
                }
                
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                self.makeAttributeErrorMsg(message : self.lang.network_ErrorIssue as NSString)
                self.movePasswordScreen(isSuccess:false)
            }
        })
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }

        self.view.endEditing(true)
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
