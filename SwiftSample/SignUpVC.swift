/**
* SignUpVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

class SignUpVC: UIViewController,UITextFieldDelegate
{
    var colorText = UIColor()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var fontStyleAndSize = UIFont()
    
    @IBOutlet var txtFldFirstName: UITextField!
    @IBOutlet var txtFldLastName: UITextField!

    @IBOutlet var imgFirstName: UIImageView!
    @IBOutlet var imgLastName: UIImageView!

    @IBOutlet var btnShowOrHide: UIButton!
    @IBOutlet var btnNext: UIButton!

    @IBOutlet var viewNameHolder: UIView!

    @IBOutlet weak var back_Btn: UIButton!
    
    @IBOutlet var viewObjectHolder: UIView!
    @IBOutlet var lblProgress: UIView!
    var datePickerView:UIDatePicker? = UIDatePicker()
   
    @IBOutlet var imgBg: UIImageView!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
   // @IBOutlet var viewGradient: UIView!
    var strOriginalDate = ""
    
    var getCurrentPage:CGFloat = 0.0
    let langAlignAff = Language.getCurrentLanguage()
    var getProgressVal:CGFloat = 0.0
    @IBOutlet weak var frstname_Lbl: UILabel!
    
    @IBOutlet weak var lstname_Lbl: UILabel!
    @IBOutlet weak var whtsname_Lbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       // MakentSupport().makeGradientColor(gradientView: viewGradient)
        imgFirstName.isHidden = true
        imgLastName.isHidden = true
        getCurrentPage = 0.0
//        txtFldLastName.isUserInteractionEnabled = true
        btnNext.isUserInteractionEnabled = false
        if txtFldLastName.text != "" && txtFldFirstName.text != ""{
            btnNext.isUserInteractionEnabled = true
        }
        btnNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.nextButtonImage()
        
        self.whtsname_Lbl.text = self.lang.wht_Name
        self.frstname_Lbl.text = self.lang.frstname_Tit
        self.lstname_Lbl.text = self.lang.lstname_Tit
        self.txtFldFirstName.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.txtFldLastName.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        btnNext.transform = langAlignAff.getAffine
        back_Btn.transform = langAlignAff.getAffine
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
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnNext)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnNext)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.checkNextButtonStatus()
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
        let letght =  textField.text?.count
        
        if textField==txtFldFirstName
        {
            if letght!>0
            {
                btnNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
                btnNext.isUserInteractionEnabled = true
                imgFirstName.isHidden = false
            }
            else
            {
                btnNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
                btnNext.isUserInteractionEnabled = false
                imgFirstName.isHidden = true
            }
        }
        
        if textField==txtFldLastName
        {
            if letght!>0
            {
                btnNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
                btnNext.isUserInteractionEnabled = true
                imgLastName.isHidden = false
            }
            else
            {
                btnNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
                btnNext.isUserInteractionEnabled = false
                imgLastName.isHidden = true
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldFirstName{
            txtFldLastName.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        return true
    }
    
    // MARK: Checking Next Button status
    /*
        First & Last name filled or not
        and making user interaction enable/disable
     */
    func checkNextButtonStatus()
    {
        if (txtFldFirstName.text?.count)!>0 && (txtFldLastName.text?.count)!>0
        {
            btnNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
            btnNext.isUserInteractionEnabled = true
            self.makeProgressAnimaiton(percentage: self.getProgressVal*1)
        }
        else
        {
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
            makeProgressAnimaiton(percentage: 20)
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
        btnNext.isUserInteractionEnabled = false
        let propertyView = StoryBoard.account.instance.instantiateViewController(withIdentifier: "SignUpEmail") as! SignUpEmail
        propertyView.strFirstName = txtFldFirstName.text!
        propertyView.strLastName =  txtFldLastName.text!
        self.navigationController?.pushViewController(propertyView, animated: false)
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
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        var rect = UIScreen.main.bounds as CGRect
        
        if(UIDevice.current.orientation.isLandscape)
        {
            rect = CGRect(x: 0, y:0,width: 1024 ,height: 768)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
