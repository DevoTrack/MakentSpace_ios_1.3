/**
* MainVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
//import Google
import TTTAttributedLabel
import AuthenticationServices


extension UIApplication {
    func _handleNonLaunchSpecificActions(arg1: AnyObject, forScene arg2: AnyObject, withTransitionContext arg3: AnyObject, completion completionHandler: () -> Void) {
        //whatever you want to do in this catch
        print("handleNonLaunchSpecificActions catched")
    }
}

class MainVC : UIViewController,MFMailComposeViewControllerDelegate,GIDSignInDelegate{
   

    @IBOutlet var viewFacebook: UIView!
    @IBOutlet var viewGoogle: UIView!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var viewToastHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var lblTerms: TTTAttributedLabel!
    
    @IBOutlet weak var change_Lngbtn: UIButton!
//
    @IBOutlet weak var change_Lnglbl: UILabel!
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet weak var continueFBLbl : UILabel!
    @IBOutlet weak var continueGglLbl : UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    @IBOutlet weak var fbLbl: UILabel!
    
    @IBOutlet weak var googLbl: UILabel!
    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var appleLoginHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appleLoginLbl: UILabel!
    lazy var appleButton : ImageButton = {
        return ImageButton.initWithNib()
    }()
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    var strEmail = ""
    var strFBID = ""
    var strUserName = ""
    var strFirstName = ""
    var strVerses:String = ""
    @IBOutlet weak var lblGoogleXconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imgAppleXconstraint: NSLayoutConstraint!
    @IBOutlet weak var lblFacebookXconstraint: NSLayoutConstraint!
    @IBOutlet weak var clsBtn: UIButton!
    var strLastName = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var isFromProfile : Bool = false
    var auth_Type = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupLoginProviderView()
        self.loginBtn.isUserInteractionEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        self.continueFBLbl.textColor = .white
        self.continueGglLbl.textColor = .white
        self.googLbl.textColor = .white
        self.fbLbl.textColor = .white
//        self.viewFacebook.guestElevateBGColor()
//        self.viewGoogle.guestElevateBGColor()
        self.view.appGuestViewBGColor()
        
        self.lblErrorMsg.appGuestTextColor()
       
        self.loginBtn.setTitle(self.lang.login_Title, for: .normal)
        self.continueFBLbl.text = self.lang.conti_Fb
        self.appleLoginLbl.text = "\(self.lang.signInWith + " Apple")"
        self.change_Lnglbl.text = self.lang.chsLan
        self.change_Lnglbl.textColor = .white
        self.change_Lngbtn.setTitleColor(.white, for: .normal)
        if Language.getCurrentLanguage().rawValue == "en"{
            self.change_Lngbtn.setTitle("English", for: .normal)
        }else{
            self.change_Lngbtn.setTitle("عربى", for: .normal)
        }
        self.change_Lngbtn.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        self.continueGglLbl.text = self.lang.conti_Google
        self.btnSignUp.setTitle(self.lang.crt_Acc, for: .normal)
        
       // logo.image=UIImage(named: k_AppLogo)?.withRenderingMode(.alwaysTemplate)
        logo.tintColor = .white
        viewFacebook.layer.cornerRadius = viewFacebook.frame.size.height/2
        viewGoogle.layer.cornerRadius = viewGoogle.frame.size.height/2
        appleLoginView.layer.cornerRadius = viewGoogle.frame.size.height/2
        viewToastHolder.isHidden = true
        btnSignUp.appHostSideBtnBG()
        btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height/2
//        btnSignUp.layer.borderColor = UIColor.white.cgColor
//        btnSignUp.layer.borderWidth = 1.0
        appName.text = "\(self.lang.welcm_To) \(k_AppName.capitalized)"
        self.setupMultipleTapLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          
        }
        

        
        
    }
        
    override func viewDidLayoutSubviews() {
        if Language.getCurrentLanguage().isRTL {
            lblGoogleXconstraint.constant = 1.8
            lblFacebookXconstraint.constant = 1.8
            imgAppleXconstraint.constant = 1.8
        } else {
            lblGoogleXconstraint.constant = 0.4
            lblFacebookXconstraint.constant = 0.4
            imgAppleXconstraint.constant = 0.4
        }
    }


    private func setupLoginProviderView() {
        // Set button style based on device theme
//        if #available(iOS 13.0, *) {
//            // self.appleLoginHeightConstraint.constant = 34
//            let isDarkTheme = view.traitCollection.userInterfaceStyle == .dark
//
//            // Create and Setup Apple ID Authorization Button
//            let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
//            //authorizationButton.titl
//            authorizationButton.frame.size = CGSize(width: appleLoginView.frame.width, height: appleLoginView.frame.height)
//            authorizationButton.center = CGPoint(x: appleLoginView.frame.size.width  / 2, y: appleLoginView.frame.size.height / 2)
//            authorizationButton.clipsToBounds = true
//            authorizationButton.layer.cornerRadius = authorizationButton.frame.height / 2
//            authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
//
//            // Add Height Constraint
//            let heightConstraint = authorizationButton.heightAnchor.constraint(equalToConstant: 44)
//            authorizationButton.addConstraint(heightConstraint)
//
//            //Add Apple ID authorization button into the stack view
//            appleLoginView.addSubview(authorizationButton)
//        } else {
//            //            self.appleLoginHeightConstraint.constant = 0
//            // Fallback on earlier versions
//            self.appleLoginHeightConstraint.constant = 0
//        }
        appleLoginView.addTap {
            self.handleLogInWithAppleIDButtonPress()
        }
        
    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
           if #available(iOS 13.0, *) {
               let appleIDProvider = ASAuthorizationAppleIDProvider()
               let request = appleIDProvider.createRequest()
               request.requestedScopes = [.fullName, .email]

               let authorizationController = ASAuthorizationController(authorizationRequests: [request])
               authorizationController.delegate = self
               authorizationController.presentationContextProvider = self
               authorizationController.performRequests()
            self.auth_Type = "apple"
               
           } else {
               // Fallback on earlier versions
           }
           

       }
    
    @objc func changeLanguage(){
        let optionMenu = UIAlertController(title: nil, message: self.lang.chsLan, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "English", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            Language.saveLanguage(Language.english)
            self.appDelegate.updateLanguage()
            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
            self.change_Lngbtn.setTitle("English", for: .normal)
            self.dismiss(animated: false, completion: nil)
 
        })
    
        let deleteAction = UIAlertAction(title: "عربى", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.change_Lngbtn.setTitle("عربى", for: .normal)
            Language.saveLanguage(Language.arabic)
            self.appDelegate.updateLanguage()
            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
            self.dismiss(animated: false, completion: nil)
  
        })
        
        let cancelAction = UIAlertAction(title: self.lang.cancel_Title, style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func setupMultipleTapLabel() {
        
        let str = "\(self.lang.bysign_Agree) \((k_AppName.capitalized))'s \(self.lang.termser_Title),\(self.lang.priv_Policy),\(self.lang.guesrefun_Policy),\(self.lang.hosguar_Terms)" as NSString
        lblTerms.text = str as String
        lblTerms.delegate = self
        let range : NSRange = str.range(of: self.lang.termser_Title)
        lblTerms.addLink(to: NSURL(string: "\(k_WebServerUrl)terms_of_service")! as URL?, with: range)
        
        let range1 : NSRange = str.range(of: self.lang.priv_Policy)
        lblTerms.addLink(to: NSURL(string: "\(k_WebServerUrl)privacy_policy")! as URL?, with: range1)
        let range2 : NSRange = str.range(of: self.lang.guesrefun_Policy)
        lblTerms.addLink(to: NSURL(string: "\(k_WebServerUrl)guest_refund")! as URL?, with: range2)
        let range3 : NSRange = str.range(of: self.lang.hosguar_Terms)
        lblTerms.addLink(to: NSURL(string: "\(k_WebServerUrl)host_guarantee")! as URL?, with: range3)
//        let str = "\(lang.bysign_Agree) \(lang.lugg_Terms)" as NSString
//        lblTerms.text = str as String
//        lblTerms.delegate = self
//        let range : NSRange = str.range(of: self.lang.lugg_Terms)
//        lblTerms.addLink(to: NSURL(string: "\(WebServerUrl)terms_of_service")! as URL?, with: range)
//        let range1 : NSRange = str.range(of: "Privacy Policy")
//        lblTerms.addLink(to: NSURL(string: "\(WebServerUrl)privacy_policy")! as URL?, with: range1)
//        let range2 : NSRange = str.range(of: "Guest Refund Policy")
//        lblTerms.addLink(to: NSURL(string: "\(WebServerUrl)guest_refund")! as URL?, with: range2)
//        let range3 : NSRange = str.range(of: "Host Guarantee Terms")
//        lblTerms.addLink(to: NSURL(string: "\(WebServerUrl)host_guarantee")! as URL?, with: range3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }
    }
    
    // MARK: User Can Login Via FB Or Google
    /*
       BUTTON TAG - 11 -> FB
       BUTTON TAG - 22 -> Google
     */
    @IBAction func backButtonAction(_ sender: Any) {
        if let lastSelectedIndex = self.appDelegate.lastSelectedIndex{

            self.appDelegate.selecteIndex(lastSelectedIndex)
            self.dismiss(animated: false, completion: nil)
            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
            return
        }
        if self.appDelegate.lastPageMaintain == "explore"{
//            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
            self.tabBarController?.selectedIndex = 0
//            self.dismiss(animated: true, completion: nil)
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
            self.dismiss(animated: false, completion: nil)
            self.appDelegate.authenticationDidFinish(viewCtrl: self)
        }
//        else if {
//            // redirect to map page
//            let viewFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "MapRoomVC") as! MapRoomVC
//            viewFilterVC.arrMapRoomData = appDelegate.arrExploreData
//            viewFilterVC.min_Price = appDelegate.min_Price
//            viewFilterVC.max_Price = appDelegate.max_Price
//            viewFilterVC.dictParams = appDelegate.dictFilterParams
//            viewFilterVC.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(viewFilterVC, animated: true)
//        }
        else if self.appDelegate.lastPageMaintain == "roomDetail" || self.appDelegate.lastPageMaintain == "contact" || self.appDelegate.lastPageMaintain == "booking" || self.appDelegate.lastPageMaintain == "ExpCal" || self.appDelegate.lastPageMaintain == "ExpContact" || self.appDelegate.lastPageMaintain == "map" {
            self.dismiss(animated: true, completion: nil)
            
        }

        else{
            if self.isPresented(){
                self.dismiss(animated: false, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
//        LoginVC
        let login = StoryBoard.account.instance.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(login, animated: false)
    }
    
    
    @IBAction func createonAccAction(_ sender: Any) {
        //SignUpVC
        let login = StoryBoard.account.instance.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(login, animated: false)
    }
    
    @IBAction func onSocialLoginTapped(_ sender : UIButton)
    {
        if !viewToastHolder.isHidden
        {
            self.onErrorTapped(nil)
        }

        if sender.tag==11   // FB LOGIN
        {
            let fbLoginManager : LoginManager = LoginManager()
           // fbLoginManager.loginBehavior = FBSDKLoginBehavior.browser
            fbLoginManager.logIn(permissions: ["public_profile","email"],from: self) { result, error in
                if (error == nil)
                {
                    let fbloginresult : LoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil
                    {
                    //    MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
                        if(fbloginresult.grantedPermissions.contains("public_profile"))
                        {
                            self.getFBUserData()
                            fbLoginManager.logOut()
                        }
                    }
                }
            }
        }
        else   // GOOGLE LOGIN
        {
//            var configureError: NSError?
//            GGLContext.sharedInstance().configureWithError(&configureError)
//            assert(configureError == nil, "Error configuring Google services: \(configureError)")
            GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    
    // MARK: FETCH LOGGED IN FB USER DETAILS
    func getFBUserData()
    {
        if((AccessToken.current) != nil)
        {
            if (AccessToken.current?.tokenString.count ?? 0 ) > 0
            {
                Constants().STOREVALUE(value: AccessToken.current?.tokenString as! NSString, keyname: APPURL.CEO_FacebookAccessToken)
            }
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, birthday, picture.type(large), email"]).start { connection, result, error in
                
                if (error == nil){
                    let newresult = result as? NSDictionary
                    var dicts = JSONS()
                    dicts["email"] = (newresult?["email"] != nil) ? newresult?["email"] as! String : ""
                    dicts["password"] = ""
                    dicts["first_name"] = newresult?["first_name"] as! String
                    dicts["last_name"] = newresult?["last_name"] as! String
                    let fbId = newresult?["id"] as! String
                    dicts["auth_id"] = fbId
                    dicts["auth_type"] = "facebook"
                  
                    var fist = dicts["first_name"] as! NSString
                    var  last = dicts["last_name"] as! NSString
                    fist = fist.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    last = last.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    Constants().STOREVALUE(value: fist , keyname: APPURL.USER_FIRST_NAME)
                    Constants().STOREVALUE(value: last , keyname: APPURL.USER_LAST_NAME)
                    Constants().STOREVALUE(value: dicts["auth_id"] as! NSString, keyname: APPURL.USER_FB_ID)
                    dicts["dob"] = ""
                    if (newresult?["birthday"] != nil)
                    {
                        var strDob = newresult?["birthday"] as! NSString
                        let arrDob = strDob.components(separatedBy: "/")
                        if arrDob.count>2
                        {
                            strDob = String(format: "%@-%@-%@", arrDob[1],arrDob[0],arrDob[2]) as NSString
                            Constants().STOREVALUE(value:strDob , keyname: APPURL.USER_DOB)
                            dicts["dob"] = strDob
                        }
                        else
                        {
                            dicts["dob"] = ""
                        }
                    }
                    else
                    {
                        Constants().STOREVALUE(value: "", keyname: APPURL.USER_DOB)
                    }
//                    if newresult?.value(forKeyPath:"picture.data.url") != nil
//                    {
//                        dicts["profile_pic"] = newresult?.value(forKeyPath:"picture.data.url") as! String
//                        Constants().STOREVALUE(value: dicts["profile_pic"] as! NSString, keyname: USER_IMAGE_THUMB)
//                    }
                    
                        dicts["profile_pic"] = "http://graph.facebook.com/\(fbId)/picture?type=large"
//                    let viewEditProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "FBSignUpVC") as! FBSignUpVC
//                    viewEditProfile.previousResponse = jsonParm
                    self.makeAPICalls(parms: dicts)
//                    self.navigationController?.pushView(viewController: viewEditProfile)
                }
            }

        }
    }
    
    // MARK: GOOGLE SIGN
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)  // SIGN IN SUCCESSFUL
        {
            MakentSupport().showProgress(viewCtrl: self, showAnimation: true)

            // Perform any operations on signed in user here.
            let userId = user.userID                      // For client-side use only!
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email

            var dicts = JSONS()
            
            if GIDSignIn.sharedInstance().currentUser.profile.hasImage {
                let dimension = round(120 * UIScreen.main.scale)
                let imageURL = user.profile.imageURL(withDimension: UInt(dimension))
                print("imgurl\(imageURL)")
                dicts["profile_pic"] = imageURL?.absoluteString //String(format:"%@",imageURL)
            }
            dicts["email"] = email
            dicts["password"] = ""
            dicts["first_name"] = givenName
            dicts["last_name"] = familyName
            dicts["dob"] = ""
            dicts["auth_id"] = userId
            dicts["auth_type"] = "google"
            self.makeAPICalls(parms: dicts)
//            let viewEditProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "FBSignUpVC") as! FBSignUpVC

//            viewEditProfile.previousResponse = jsonParm
//            MakentSupport().removeProgress(viewCtrl: self)
//            self.navigationController?.pushView(viewController: viewEditProfile)
        }
        else
        {
        }
    }
    
    fileprivate func callSignupForAppleLoginandwithEmail(paramDict:JSONS) {
        let viewEditProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "FBSignUpVC") as! FBSignUpVC
        viewEditProfile.previousResponse =  paramDict
        self.navigationController?.pushViewController(viewEditProfile, animated: false)
       
    }
    
    func wsToSignupUserDetails(params:JSONS){
        var paramDict = JSONS()
        if let addr = MakentSupport().getWiFiAddress() {
            paramDict["ip_address"] = addr
        } else {
            paramDict["ip_address"] = ""
        }
        paramDict.merge(dict: params)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "signup", paramDict: paramDict, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                if responseDict.statusCode == 2   {
                    self.callSignupForAppleLoginandwithEmail(paramDict: paramDict)
                    return
               }
                let model = LoginModel(jsons: responseDict)
                self.setDefaultProperties(token: model.access_token)
            }
            else {
                self.appDelegate.createToastMessage(responseDict.statusMessage, isSuccess: false)
                self.appDelegate.logoutFinish()
                return
            }
            self.view.appGuestViewBGColor()
        }
       
    }
    

    // MARK: CALLING API FOR CREATE FB OR GOOGLE ACC
    func makeAPICalls(parms: JSONS)
    {
        MakentAPICalls().GetRequest(parms,methodName: APPURL.METHOD_SIGNUP as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let loginData = response as! LoginModel
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                if loginData.status_code == "0"{
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate.createToastMessage(self.lang.cont_Admin, isSuccess: false)
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
                        if self.appDelegate.lastPageMaintain == "explore"{
                            self.dismiss(animated: true, completion: {
                                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                            })
                            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                        }
                        else if self.appDelegate.lastPageMaintain == "saved"{
                            self.dismiss(animated: true, completion: nil)
                            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 1)
                        }
                        else if self.appDelegate.lastPageMaintain == "trips"{
                            self.dismiss(animated: true, completion: nil)
                            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
                        }
                        else if self.appDelegate.lastPageMaintain == "inbox"{
                            self.dismiss(animated: true, completion: nil)
                            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 3)
                        }
                        else if self.appDelegate.lastPageMaintain == "profile"{
                            self.dismiss(animated: true, completion: {
                                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                            })
                            // self.appDelegate.generateMakentLoginFlowChange(tabIcon:4)
                        }
                        //                    else if {
                        //                        // redirect to map page
                        //                        let viewFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "MapRoomVC") as! MapRoomVC
                        //                        viewFilterVC.arrMapRoomData = self.appDelegate.arrExploreData
                        //                        viewFilterVC.min_Price = self.appDelegate.min_Price
                        //                        viewFilterVC.max_Price = self.appDelegate.max_Price
                        //                        viewFilterVC.dictParams = self.appDelegate.dictFilterParams
                        //                        viewFilterVC.hidesBottomBarWhenPushed = true
                        //                        self.navigationController?.pushViewController(viewFilterVC, animated: true)
                        //                    }
                        
                        else if self.appDelegate.lastPageMaintain == "ExpContact" || self.appDelegate.lastPageMaintain == "ExpCal" || self.appDelegate.lastPageMaintain == "booking" || self.appDelegate.lastPageMaintain == "contact" || self.appDelegate.lastPageMaintain == "roomDetail" || self.appDelegate.lastPageMaintain == "map" {
                            
                            self.appDelegate.makentTabBarCtrler.tabBar.items?[4].title = tabBarTextCtrl.guestProfile.rawValue
                            if self.appDelegate.lastPageMaintain == "map" {
                                Constants().STOREVALUE(value: "ReloadExplore", keyname: APPURL.RELOADEXPLORE)
                            }
                            self.dismiss(animated: true, completion: {
                                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                            })
                        }
                        else{
                            self.dismiss(animated: true, completion: {
                                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
                            })
                            //self.appDelegate.authenticationDidFinish(viewCtrl: self)
                        }
                        
                        self.view.appGuestViewBGColor()
                    }
                else if loginData.status_code == "2" {
                    let viewEditProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "FBSignUpVC") as! FBSignUpVC
                    viewEditProfile.previousResponse = parms
                    self.navigationController?.pushViewController(viewEditProfile, animated: false)
                
                }else
                    {
                        self.dismiss(animated: true, completion: nil)
                        self.viewToastHolder.isHidden = false
                        self.makeAttributeErrorMsg(message : loginData.success_message as NSString)
                        self.view.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
                    }
                }
            }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }
    
    
    func makeAttributeErrorMsg(message : NSString)
    {
        let attributedString = NSMutableAttributedString(string: message as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: 14)!]))
        
        lblErrorMsg.attributedText = attributedString
        //        return attributedString
    }

    // MARK: When User Press Close Button in Error Message
    @IBAction func onErrorTapped(_ sender:UIButton!)
    {
        viewToastHolder.isHidden = true
        self.view.appGuestViewBGColor()
    }

}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
extension MainVC: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}

extension  MainVC : ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            print(authorization)
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Create an account in your system.
                let userIdentifier = appleIDCredential.user
                
                if let newuser = appleIDCredential.fullName, !newuser.description.isEmpty {
                    let model = AppleLoginStorge(first: newuser.givenName ?? "", last: newuser.familyName ?? "", user: userIdentifier, email: appleIDCredential.email ?? "")
                    model.storeDetails()
                    if let identityTokenData = appleIDCredential.identityToken,
                        let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                        print("Identity Token \(identityTokenString)")
                    }
                    self.appleLoginDetails(model: model,isForNewUser: true)
                }else {
                    self.getFetchDetails(appleIDCredential: appleIDCredential)
                }
                
                
                //Navigate to other view controller
            } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
                // Sign in using an existing iCloud Keychain credential.
                
                let username = passwordCredential.user
                let password = passwordCredential.password
                
    //            passwordCredentia
                
                //Navigate to other view controller
            }
    //            let firstName = appleIDCredential.user
                
            
        }
    
    func appleLoginDetails(model:AppleLoginStorge,isForNewUser:Bool = false){
            var paramDict = JSONS()
            paramDict["email"] = model.email
            paramDict["password"] = ""
            paramDict["dob"] = ""
            paramDict["first_name"] = model.firstName
            paramDict["last_name"] = model.lastName
            
            if model.userIdentifer.isEmpty {
                  paramDict["auth_type"] = "email"
            }else {
                paramDict["auth_type"] = "apple"
                 paramDict["auth_id"] = model.userIdentifer
            }
           
            paramDict["profile_pic"] = ""
    
        self.wsToSignupUserDetails(params: paramDict)
        }
        
        
    @available(iOS 13.0, *)
    func getFetchDetails(appleIDCredential: ASAuthorizationAppleIDCredential){
            let lang = Language.getCurrentLanguage().getLocalizedInstance()
            if #available(iOS 13.0, *) {
                let appleProviderID = ASAuthorizationAppleIDProvider()
            
                appleProviderID.getCredentialState(forUserID: appleIDCredential.user) { (creditial, error) in
                if let err = error {
                    self.sharedAppDelegate.createToastMessage(err.localizedDescription)
                }else {
                    switch creditial {
                        
                    case .revoked:
                        print("revoked")
                        AppleLoginStorge.deleteUserDetails()
                        self.sharedAppDelegate.createToastMessage("No Data Found")
                    case .authorized:
                        print("authorized")
                        DispatchQueue.main.async {
//                            let model = AppleLoginStorge.getStoreDetails()
                            let model = AppleLoginStorge(first: appleIDCredential.fullName?.givenName ?? "", last: appleIDCredential.fullName?.familyName ?? "", user: appleIDCredential.user, email: appleIDCredential.email ?? "")
                            self.appleLoginDetails(model: model)
                        }
                        
                        
                    case .notFound:
                         print("notFound")
                        AppleLoginStorge.deleteUserDetails()
                        self.sharedAppDelegate.createToastMessage("No Data Found")
                    case .transferred:
                         print("transferred")
                        AppleLoginStorge.deleteUserDetails()
                         self.sharedAppDelegate.createToastMessage(lang.nodat_Found)
                    }
                }
                
                    
        
            }
                } else {
                    // Fallback on earlier versions
                }
        }
}

extension MainVC : ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    var sharedAppDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func setDefaultProperties(token:String){
        
        self.sharedAppDelegate.userToken = token
        SharedVariables.sharedInstance.userToken = token
        self.wsToUpdateLanguage()
        let userDefaults = UserDefaults.standard
        userDefaults.set("travel", forKey:"getmainpage")
        self.sharedAppDelegate.resetFilersDates()
        _ = PipeLine.fireEvent(withName: K_PipeNames.reloadView)
        self.dismiss(animated: false, completion: {
            self.sharedAppDelegate.generateMakentLoginFlowChange(tabIcon: 0)
        })
        self.view.appGuestViewBGColor()
    }
    
    
    func wsToUpdateLanguage(){
           WebServiceHandler
           .sharedInstance
           .getWebService(wsMethod: .language,
                          params: ["language":Language.getCurrentLanguage().rawValue], response: nil)
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
