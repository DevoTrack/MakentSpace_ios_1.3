/**
 * SignUpPassword.swift
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

class SignUpPassword: UIViewController,UITextFieldDelegate
{
    @IBOutlet var txtFldPassword: UITextField!
    @IBOutlet var imgPassword: UIImageView!
    @IBOutlet var btnShowOrHide: UIButton!
    @IBOutlet var btnPasswordNext: UIButton!
    @IBOutlet var viewPasswordHolder: UIView!
    @IBOutlet var viewObjectHolder: UIView!
    @IBOutlet var lblProgress: UIView!
    @IBOutlet var imgBg: UIImageView!

    var datePickerView:UIDatePicker? = UIDatePicker()
    var colorText = UIColor()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var fontStyleAndSize = UIFont()

    var strOriginalDate = ""
    
    var getCurrentPage:CGFloat = 0.0

    var getProgressVal:CGFloat = 0.0
    
    @IBOutlet weak var back_Btn: UIButton!
    var strFirstName = ""
    var strLastName = ""
    var strEmailId = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let langAlignAff = Language.getCurrentLanguage()
    @IBOutlet weak var pass_Tit: UILabel!
    @IBOutlet weak var cretpass_Tit: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       // MakentSupport().makeGradientColor(gradientView: viewGradient)
        btnPasswordNext.transform = langAlignAff.getAffine
        txtFldPassword.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        back_Btn.transform = langAlignAff.getAffine
        self.cretpass_Tit.text = self.lang.crt_Pass
        self.pass_Tit.text = self.lang.pas_Tit
        imgPassword.isHidden = true
        txtFldPassword.isSecureTextEntry = true
        getCurrentPage = 0.0
        
        if txtFldPassword.text != ""{
            btnPasswordNext.isUserInteractionEnabled = true
        }else{
            btnPasswordNext.isUserInteractionEnabled = false
        }
        btnPasswordNext.nextButtonImage()
        btnPasswordNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
        
        btnPasswordNext.layer.cornerRadius = btnPasswordNext.frame.size.height/2
        let rect = UIScreen.main.bounds as CGRect
        btnShowOrHide.setTitle(self.lang.show_Title, for: .normal)
        viewObjectHolder.frame = CGRect(x: rect.size.width, y:viewObjectHolder.frame.origin.y,width:viewObjectHolder.frame.size.width ,height: viewObjectHolder.frame.size.height)

        getProgressVal = rect.size.width/4
        MakentSupport().makeViewAnimaiton(viewObj: viewObjectHolder)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnPasswordNext)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnPasswordNext)
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
        checkNextButtonStatus()
    }
    
    func checkNextButtonStatus()
    {
        if (txtFldPassword.text?.count)!>7
        {
            btnPasswordNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
            btnPasswordNext.isUserInteractionEnabled = true
            imgPassword.isHidden = false
            self.makeProgressAnimaiton(percentage: self.getProgressVal*3)
        }
        else
        {
            btnPasswordNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
            btnPasswordNext.isUserInteractionEnabled = false
            imgPassword.isHidden = true
            self.makeProgressAnimaiton(percentage: self.getProgressVal*2)
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
    
    func Alert()-> Bool{
        
        let password_Text = txtFldPassword.text!.trimmingCharacters(in: .whitespaces)
        print("CountVal:",password_Text.count)
        if password_Text.count == 0{
            appDelegate.createToastMessage(self.lang.emp_Pass, isSuccess: false)
            
        }else if password_Text.count < 8{
            appDelegate.createToastMessage(self.lang.eight_Pass, isSuccess: false)
            
        }
        
        return true
    }
    
    // MARK: Navigating to Email field View
    /*
     First & Last name filled or not
     and making user interaction enable/disable
     */

    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
//        if !Alert(){
//            return
//        }
        btnPasswordNext.isUserInteractionEnabled = false
        let propertyView = StoryBoard.account.instance.instantiateViewController(withIdentifier: "SignUpDOB") as! SignUpDOB
        propertyView.strFirstName = strFirstName
        propertyView.strLastName =  strLastName
        propertyView.strEmailId =  strEmailId
        propertyView.strPassword =  txtFldPassword.text!
        self.navigationController?.pushViewController(propertyView, animated: false)
    }
    
    func makeTextfldAnimaiton() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.makeViewAnimaiton), userInfo: nil, repeats: false)
    }
    
    @objc func makeViewAnimaiton(viewObj:UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.txtFldPassword.becomeFirstResponder()
        }, completion: { (finished: Bool) -> Void in
        })
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
   
    @IBAction func displayHomePage()
    {
        self.view.endEditing(true)
    }
    
    // MARK: When User Press Show or Hide Password Characters
    /*
      Here we are changing the Show / Hide status
     */
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
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        var rect = UIScreen.main.bounds as CGRect
        
        if(UIDevice.current.orientation.isLandscape)
        {
            rect = CGRect(x: 0, y:0,width: 1024 ,height: 768)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
}
