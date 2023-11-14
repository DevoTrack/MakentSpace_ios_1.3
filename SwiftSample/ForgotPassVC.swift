/**
* ForgotPassVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class ForgotPassVC : UIViewController,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate {
//    @IBOutlet var scrollMenus: UIScrollView!

    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var btnSentMail: UIButton!
    @IBOutlet var imgEmailId: UIImageView!
    @IBOutlet var txtFldEmailID: UITextField!
//    @IBOutlet var viewGradient: UIView!
    
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var viewToastHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!
    @IBOutlet weak var emailadd_Tit: UILabel!
    
    @IBOutlet weak var frgtpass_Msg: UILabel!
    @IBOutlet weak var frgtpass_Lbl: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let langAlignAff = Language.getCurrentLanguage()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
  //      MakentSupport().makeGradientColor(gradientView: viewGradient)
        self.frgtpass_Lbl.text = self.lang.forpass_Tit
        self.frgtpass_Msg.text = self.lang.enter_Email
        self.emailadd_Tit.text = self.lang.emailadd_Tit
        txtFldEmailID.textAlignment = langAlignAff.getTextAlignment(align: .left)
        btnSentMail.transform = langAlignAff.getAffine
        back_Btn.transform = langAlignAff.getAffine
        self.navigationController?.isNavigationBarHidden = true
        imgEmailId.isHidden = true
        btnSentMail.isUserInteractionEnabled = false
        btnSentMail.nextButtonImage()
        self.lblErrorMsg.appGuestTextColor()
        btnSentMail.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
        btnSentMail.layer.cornerRadius = btnSentMail.frame.size.height/2
        viewToastHolder.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewToastHolder)
        
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnSentMail)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: viewToastHolder)
        MakentSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnSentMail)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            if letght!>0 && MakentSupport().isValidEmail(testStr: txtFldEmailID.text!)
            {
                imgEmailId.isHidden = false
                btnSentMail.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(1.0)
                btnSentMail.isUserInteractionEnabled = true
            }
            else
            {
                imgEmailId.isHidden = true
                btnSentMail.isUserInteractionEnabled = false
                btnSentMail.backgroundColor = UIColor.appGuestLightColor.withAlphaComponent(0.5)
            }
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
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }

    /*
        When user click send button
     */
    @IBAction func onSentMailTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        btnSentMail.isUserInteractionEnabled = false
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        
        var dicts = [AnyHashable: Any]()
        dicts["email"] = txtFldEmailID.text!
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_FORGOT_PASSWORD as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let loginData = response as! NSDictionary
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)

                if loginData["status_code"] as! NSString == "1"
                {
                    let sendMailErrorAlert = UIAlertView(title: self.lang.checkem_Title, message: String(format: "\(self.lang.wesen_Email) %@. \(self.lang.tap_Link)", self.txtFldEmailID.text!), delegate: self, cancelButtonTitle: self.lang.ok_Title)
                    sendMailErrorAlert.show()
                }
                else
                {
                    self.viewToastHolder.isHidden = false
                    self.view.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
                    self.makeAttributeErrorMsg(message : loginData["success_message"] as! NSString)
                    self.btnSentMail.isUserInteractionEnabled = true
                }
                
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.btnSentMail.isUserInteractionEnabled = true
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }
    
    // MARK - ALERT VIEW DELEGATE METHOD
    
    /*
      // WHEN USER CLICK OK BUTTON
     */
    func alertView(_ View: UIAlertView, clickedButtonAt buttonIndex: Int){
            self.onBackTapped(nil)
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

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }

        self.navigationController!.popViewController(animated: true)
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
   
    @IBAction func onFacebookTapped()
    {

        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            let strBody  = String(format: "Spread the words of lord by sharing this %@\n%@",APPNAME_AND_VERSION,APPSTOREURL)
//            vc.setInitialText(strBody)
//            vc.addURL(URL(string: APPSTOREURL))
            present(vc!, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title:  self.lang.acc_Title, message: self.lang.pls_Log, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: self.lang.ok_Title, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onWhatsAppTapped(_ sender:UIButton!)
    {
//        viewShareAppHolder.isHidden = true
//        var strBody  = String(format: "Spread the words of lord by sharing this %@\n%@",APPNAME_AND_VERSION,APPSTOREURL)
//
//        strBody = strBody.stringByReplacingOccurrencesOfString("=", withString: "%3D", options: NSString.CompareOptions.LiteralSearch, range: nil)
//        strBody = strBody.stringByReplacingOccurrencesOfString("&", withString: "%26", options: NSString.CompareOptions.LiteralSearch, range: nil)
//        
//        let urlStringEncoded = strBody.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
//        let whatsappURL  = URL(string: "whatsapp://send?text=\(urlStringEncoded!)")
//        
//        if UIApplication.sharedApplication().canOpenURL(whatsappURL!) {
//            UIApplication.sharedApplication().openURL(whatsappURL!)
//        }
//        else {
//            let alert = UIAlertController(title: MSGTXT, message: "Please install WhatsApp in your phone.", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
    }
    
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertView(title: self.lang.email_NotSend, message: self.lang.email_NotSendMsg, delegate: self, cancelButtonTitle: self.lang.ok_Title)
            sendMailErrorAlert.show()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let strBody = String(format: "\(self.lang.sprd_Msg)\n%@\n%@", "\(k_AppName) \(k_AppVersion)",COMMON.APPSTOREURL)

//        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("\(self.lang.holy_Title) \(k_AppName.capitalized) \(self.lang.offline_Title)")
        mailComposerVC.setMessageBody(strBody, isHTML: false)
        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func makeMenuAnimation()
    {
//        let initialDelay = 0.5;
//        var i = 0.0;
//        for view in self.scrollMenus.subviews {
//            setupUIAnimationWithView(view,deleyTime: initialDelay + i)
//            i=i + 0.1;
//        }
    }
    
    func setupShareAppViewAnimationWithView(_ view:UIView,deleyTime:Double)
    {
//        view.transform = CGAffineTransform(translationX: 0, y: -self.viewShareAppHolder.frame.size.height)
//        UIView.animate(withDuration: 1.0, delay: deleyTime, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations:
//            {
//                view.transform = CGAffineTransform.identity
//                view.alpha = 1.0;
//                
//            }, completion: nil)
    }
    
    func setupUIAnimationWithView(_ view:UIView,deleyTime:Double)
    {
//        view.transform = CGAffineTransform(translationX: 0, y: self.scrollMenus.frame.size.height)
//        UIView.animate(withDuration: 2.5, delay: deleyTime, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations:
//            {
//                view.transform = CGAffineTransform.identity
//                view.alpha = 1.0;
//
//            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onclickbutton(){
    
    
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
