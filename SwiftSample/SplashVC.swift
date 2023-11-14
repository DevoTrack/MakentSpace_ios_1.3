/**
 * SplashVC.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import LocalAuthentication

class SplashVC: UIViewController {
    var window = UIWindow()
    @IBOutlet var lblMenuTitle: UILabel!
    @IBOutlet var imgAppIcon: UIImageView!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var isFirstTimeLaunch : Bool = false
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let secure = UserDefaults.standard.bool(forKey: "SecureSpaciko")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //imgAppIcon.image=UIImage(named: k_AppLogo)?.withRenderingMode(.alwaysTemplate)
        
        
        
        if isFirstTimeLaunch
        {
            if SharedVariables.sharedInstance.userToken != "" && secure{
                if !simulator.isSimulator{
                    self.authenticateUserTouchID()
                }else{
                    self.onSetRootViewController()
                }
            }else{
            UserDefaults.standard.set(false, forKey: "SecureSpaciko")
            self.onSetRootViewController()
            imgAppIcon.center = self.view.center
            imgAppIcon.tintColor = UIColor.appGuestThemeColor
            lblMenuTitle.isHidden = true
            }
        }
        else
        {
            if SharedVariables.sharedInstance.userToken != "" && secure{
                if !simulator.isSimulator{
                    self.authenticateUserTouchID()
                }else{
                    self.onSetRootViewController()
                }
            }else{
            Timer.scheduledTimer(timeInterval:2.0, target: self, selector: #selector(self.onSetRootViewController), userInfo: nil, repeats: false)
             UserDefaults.standard.set(false, forKey: "SecureSpaciko")
            //            moveHelpAnimation(imgScroll:imgAppIcon)
            lblMenuTitle.isHidden = false
            let userDefaults = UserDefaults.standard
            
            let getMainPage = userDefaults.object(forKey: "getmainpage") as? NSString
            imgAppIcon.image=UIImage(named: k_AppLogo)?.withRenderingMode(.alwaysTemplate)
            if(getMainPage == "guest")
            {
                self.view.backgroundColor = UIColor.white
                imgAppIcon.tintColor = UIColor.appHostThemeColor
                lblMenuTitle.text = self.lang.switch_Travel
                lblMenuTitle.appHostTextColor()
                
            }
            else if(getMainPage == "host")
            {
                self.view.backgroundColor = UIColor.white
                imgAppIcon.tintColor = UIColor.appGuestThemeColor
               
                lblMenuTitle.text = self.lang.switch_Host
                lblMenuTitle.appGuestTextColor()
            }
        }
        }
        // MakentSupport().runSpinAnimation(view: imgAppIcon, duration: 1, rotations: 1, repeatcounts: 1)
    }
    
    func moveHelpAnimation(imgScroll:UIImageView)
    {
        //        let rectImg = imgMakentIcon.frame;
        UIView.animate(withDuration:  1.0, delay: 0.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            
            imgScroll.frame = CGRect(x: (self.view.frame.size.width-self.imgAppIcon.frame.size.width), y:self.imgAppIcon.frame.origin.y, width: self.imgAppIcon.frame.size.width ,height: self.imgAppIcon.frame.size.height)
        }, completion: { (finished: Bool) -> Void in
            self.moveHelpAnimationAgain(imgScroll:imgScroll)
        })
    }
    
    func moveHelpAnimationAgain(imgScroll:UIImageView) {
        //        let rectImg = imgMakentIcon.frame;
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            imgScroll.frame = CGRect(x: 0, y: self.imgAppIcon.frame.origin.y, width: self.imgAppIcon.frame.size.width,height: self.imgAppIcon.frame.size.height);
        }, completion: { (finished: Bool) -> Void in
            self.moveHelpAnimation(imgScroll:imgScroll)
        })
    }
    func authenticateUserTouchID() {
        let context : LAContext = LAContext()
        // Declare a NSError variable.
        let myLocalizedReasonString = self.lang.authenticationIsNeeded
        var authError: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError){
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
                if success{
                    DispatchQueue.main.async {
                        self.onSetRootViewController()
                    }
                    
                }else{
                    if let error : LAError = evaluateError as? LAError {
                        
                        let message = self.showErrorMessageForLAErrorCode(error.errorCode)
                        print(message)
                    }
                }
            }
        }
    }
    
    func showErrorMessageForLAErrorCode(_ errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            //self.authenticateUserTouchID()
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            self.authenticateUserTouchID()
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    @objc func onSetRootViewController()
    {
        //let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setTabbarForSwithUsers(viewCtrl: self)
    }
}

enum tabBarTextCtrl: String {
    case reservations
    
    //= "RESERVATIONS"
    case calendar //= "CALENDAR"
    case listing //= "LISTING"
    case hostProfile //= "PROFILE"
    case explore //= "Explore"
    case saved //= "Saved"
    case trips //= "Trips"
    case inbox //= "Inbox"
    case guestProfile //= "Profile"
    case login //= "Log In"
    var rawValue : String {
        let lang = Language.getCurrentLanguage().getLocalizedInstance()
        switch self {
        case .reservations:
            return lang.reser_Title
        case .listing:
            return lang.list_Title
        case .hostProfile:
            return lang.prof_Title
        case .explore:
            return lang.expl_Title
        case .saved:
            return lang.save_Title
        case .trips:
            return lang.trip_Title
        case .inbox:
            return lang.inbox_Title
        case .guestProfile:
            return lang.profl_Title
        case .login:
            return lang.login_Title
        default:
            return ""
        }
    }
}
