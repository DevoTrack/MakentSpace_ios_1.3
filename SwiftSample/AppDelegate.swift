/**
 * Calendar Controller
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import iAd
import FBSDKCoreKit
import GoogleSignIn
//import Google
import GoogleMaps
import IQKeyboardManagerSwift
import Stripe
import Firebase
import AuthenticationServices

@UIApplicationMain

 class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate
{
    var navigationController: UINavigationController!
    var window: UIWindow?
    var arrBookNames = [String]()
    var dictOldTestament:NSMutableDictionary?
    var dictNewTestament:NSMutableDictionary?
    var dictAllTestament:NSMutableDictionary?
    var listOfBook:NSDictionary?
    var listOfBooks: NSMutableDictionary!
    let userDefaults = UserDefaults.standard
    var vcMenuVC : UIViewController!
    var isAdShowing : Bool = false
    var isFirstTime : Bool = false
    var isStepsCompleted:Bool = false
    var arrMapExperienceData = [ExploreExperienceData]()
    var expRoomID:Int = 0

    var nSelectedIndex : Int = 0
    var lastSelectedIndex : Int?
    var strRoomID = ""
    var searchguest = ""
    var samVal = ""
    var startdate = ""
    var enddate = ""
    var startTime = ""
    var endTime = ""
    var pricepertnight = ""
    var addaddress = ""
    var lat = ""
    var long = ""
    var s_types = ""
    var addrss = ""
    var test = ""
    var day = ""
    var day1 = ""
    var s_date = ""
    var e_date = ""
    var latt = CLLocationDegrees()
    var longg = CLLocationDegrees()
    var lat1 = ""
    var long1 = ""
    var gothis = ""
    var back1 = ""
    var page = ""
    var selecredExpDate  = ""
    var expStartTime = ""
    var expEndTime = ""
    var expPricepertnight = ""
    var userToken = ""

    /// For set the check in and check out values
     
    // for login flow
    var lastPageMaintain = ""
    var arrExploreData : NSMutableArray = NSMutableArray()
    var arrWishListData: NSMutableArray = NSMutableArray()
    var dictFilterParams = [AnyHashable: Any]()
    var min_Price : Int = 0
    var max_Price : Int = 0
    var btntype:String = ""
    var roomModel = RoomDetailModel()
    var experienceDetails: ExperienceRoomDetails!
    var isFromNewTime : Bool = false
    var arrNightData : NSArray!
    var placeDetails :NSDictionary = [:]
    var isDeleteListing: Bool = false
    var tabBarHeight: Int = 0
    //fileprivate
    var multipleDates: [Date] = []
    let makentTabBarCtrler = UITabBarController()
    
    static var sharedInstance = AppDelegate()
    
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let langVal = Language.getCurrentLanguage()
    //Experience page
    var strExperienceID = ""
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url as URL? ?? URL(fileURLWithPath: ""), sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        self.window = UIWindow(frame:UIScreen.main.bounds)
        UIApplication.shared.applicationIconBadgeNumber = 0;
        isFirstTime = true
        
        /// initialize the stripe
        Stripe.setDefaultPublishableKey(k_StripeKey)
        //"ASeeaUVlKXDd8DegCNSuO413fePRLrlzZKdGE_RwrWqJOVVbTNJb6-_r6xX9GdsRUVNc8butjTOIK_Xm"
        /// Initialize the paypal actions
//        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: k_PaypalClientID,PayPalEnvironmentSandbox: k_PaypalClientID])
//        PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentSandbox)
        
        //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
        let rememberMe = userDefaults.bool(forKey: "rememberselected")
        if(!rememberMe)
        {
            userDefaults.set(false, forKey: "rememberselected")
        }
        userDefaults.set("", forKey: "paymenttype")
        let fontsize = userDefaults.integer(forKey: "fontsize")

        if(fontsize==0)
        {
            userDefaults.set(15, forKey:"fontsize")
        }

        let fontStyle = userDefaults.object(forKey: "fontname")
        
        if(fontStyle == nil)
        {
            userDefaults.set("Coda", forKey:"fontname")
        }
       
//        self.setsemantic()
        arrWishListData = NSMutableArray()
        userDefaults.set("", forKey: "hostmessage")
        userDefaults.set("", forKey:APPURL.USER_LONGITUDE)
        userDefaults.set("", forKey:APPURL.USER_LATITUDE)
        userDefaults.set("", forKey:APPURL.USER_LOCATION)
        userDefaults.set("", forKey:APPURL.RELOAD)
        userDefaults.set("", forKey:APPURL.RELOADEXPLORE)
        userToken =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        SharedVariables.sharedInstance.userToken = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.shared.enable = true
    
        userDefaults.synchronize()
        self.makeSplashView(isFirstTime: true)
        self.initModules()
        self.updateLanguage()
        FirebaseApp.configure()
        self.getFetchDetails(userIdentifier: AppleLoginStorge.getStoreDetails().userIdentifer)
        return true
    }
    
    
    func getFetchDetails(userIdentifier:String) {
       
        if #available(iOS 13.0, *) {
            let appleProviderID = ASAuthorizationAppleIDProvider()
            appleProviderID.getCredentialState(forUserID: userIdentifier) { (creditial, error) in
            if let err = error {
               print(err)
                AppleLoginStorge.deleteUserDetails()
            }else {
                switch creditial {
                    
                case .revoked:
                    print("revoked")
                    AppleLoginStorge.deleteUserDetails()
                case .authorized:
                    print("authorized")
                    
                    
                case .notFound:
                     print("notFound")
                    AppleLoginStorge.deleteUserDetails()
                case .transferred:
                     print("transferred")
                    AppleLoginStorge.deleteUserDetails()
                @unknown default:
                    fatalError()
                }
            }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    func initModules(){
        
        GMSServices.provideAPIKey("ENTER YOUR MAP KEY HERE")
        GIDSignIn.sharedInstance().clientID = "413995402979-au9g0qiq43aemt8m1qehagfme9260fdn.apps.googleusercontent.com"
    }
    func updateLanguage(){
        if UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) != nil{//Call language api
            
            WebServiceHandler
                .sharedInstance
                .getWebService(wsMethod: .language,
                               params: ["language":Language.getCurrentLanguage().rawValue], response: nil)
        }else{
            print("ƒ : no token cant update language")
        }
        
        /*DispatchQueue.main.async {
            do{
                let paypal_app_id = ""
                let paypal_mode = ""
                PayPalMobile.initialize()
                try PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "\(paypal_app_id)",PayPalEnvironmentSandbox: "\(paypal_app_id)"])
            }catch {
                print("Paypal integration failed !")
            }
        }*/
    }
    // [START openurl]
    internal func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        let urlOpen = url.absoluteString
        var version = Bundle.main.infoDictionary?["FacebookAppID"] as? String
        version = String(format:"fb%@",version!)

        if (urlOpen as NSString).range(of:version!).location != NSNotFound {
            let handled = ApplicationDelegate.shared.application(application,open:url, sourceApplication: sourceApplication, annotation: annotation)
            
            return handled
        }
        else
        {
            return (GIDSignIn.sharedInstance()?.handle(url))!
                //GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let urlOpen = url.absoluteString
        var version = Bundle.main.infoDictionary?["FacebookAppID"] as? String
        version = String(format:"fb%@",version!)
        if (urlOpen as NSString).range(of:version!).location != NSNotFound {
            let handled = ApplicationDelegate.shared.application(app,open:url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication]as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] as? String)

            return handled
        }
        else
        {
            return GIDSignIn.sharedInstance().handle(url)
                //GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
    }

    
    func makeSplashView(isFirstTime:Bool)
    {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var getStoryBoardName : String = ""
        switch (deviceIdiom)
        {
        case .pad:
            getStoryBoardName = "Main"
        case .phone:
            getStoryBoardName = "Main"
        default:
            break
        }
        let storyBoardMenu : UIStoryboard = UIStoryboard(name: getStoryBoardName, bundle: nil)
        let splashView = storyBoardMenu.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        splashView.isFirstTimeLaunch = isFirstTime
        window!.rootViewController = splashView
        window!.makeKeyAndVisible()
    }
    
    
    // MARK: Set Root ViewController
    
    func getMainStoryboardName() -> String
    {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var getStoryBoardName : String = ""
        switch (deviceIdiom)
        {
        case .pad:
            getStoryBoardName = "Main"
        case .phone:
            getStoryBoardName = "Main"
        default:
            break
        }
        return getStoryBoardName
    }
    
    
    func makeSwitchSpalsh()
    {
        let controllersArray = self.makentTabBarCtrler.viewControllers
        for tempVC: UIViewController in controllersArray!
        {
            tempVC.removeFromParent()
        }
        self.makeSplashView(isFirstTime: false)
    }
    
    func setTabbarForSwithUsers(viewCtrl:UIViewController)
    {
        
        //∂reset_dates
        self.resetFilersDates()
//        DispatchQueue.main.async {
//            viewCtrl.view.removeFromSuperview()
//        }
        
//        let getMainPage =  userDefaults.object(forKey: "getmainpage") as? NSString
//        if getMainPage == "guest"
//        {
//            window?.rootViewController = self.self.generateMakentLoginFlowChange(tabIcon: 0)
//        }
//        else if getMainPage == "host"
//        {
//            window?.rootViewController = self.generateMakentHostTabbarController()
//        }
//        else
//        {
//            Constants().STOREVALUE(value: "", keyname: USER_ACCESS_TOKEN)
//            Constants().STOREVALUE(value: "", keyname: USER_ID)
//            Constants().STOREVALUE(value: "", keyname: USER_CURRENCY_SYMBOL)
//            userDefaults.synchronize()
            window?.rootViewController = self.generateMakentLoginFlowChange(tabIcon: 0)
//        }
    }
    
    func enableHockeyAppSdk()
    {
        /*BITHockeyManager.shared().configure(withIdentifier: "cef4ffb2bc6b4a49bbc44f60038b48a5")
        BITHockeyManager.shared().isStoreUpdateManagerEnabled = true
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()*/
    }
    
    func authenticationDidFinish(viewCtrl:UIViewController)
    {
        
        //viewCtrl.view.removeFromSuperview()
        //self.setsemantic()
//        let getMainPage =  userDefaults.object(forKey: "getmainpage") as? String
//        if (getMainPage==nil || getMainPage=="")
//        {
//            userDefaults.set("guest", forKey:"getmainpage")
//            userDefaults.synchronize()
//        }
//        let getMainPageName =  userDefaults.object(forKey: "getmainpage") as? String
//        if(getMainPageName == "guest")
//        {
            window?.rootViewController = self.generateMakentLoginFlowChange(tabIcon: 0)
//        }
//        else if(getMainPageName == "host")
//        {
//            window?.rootViewController = self.generateMakentHostTabbarController()
//        }
        window?.makeKeyAndVisible()
        self.enableHockeyAppSdk()
    }
    func generateMakentLoginFlowChange(tabIcon: Int) -> UITabBarController
    {
        self.lastSelectedIndex = tabIcon
        
        self.setsemantic()
        let lang1 = Language.getCurrentLanguage().getLocalizedInstance()
        //self.setSemantic()
        UITabBar.appearance().tintColor =  UIColor.appGuestThemeColor
        UITabBar.appearance().barTintColor = UIColor.white
        //SharedVariables.sharedInstance.homeType = HomeType.all
        SharedVariables.sharedInstance.homeType = HomeType.experiance
        let storyBoard1 : UIStoryboard = UIStoryboard(name: "MakentMainStoryboard", bundle: nil)
        let myVC0 = storyBoard1.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        
//        if langVal == .arabic{
//            let icon0 = UITabBarItem(title: lang1.expl_Title, image: UIImage(named: "explore_arab.png"), selectedImage: UIImage(named: "explore_arab.png"))
//           myVC0.tabBarItem = icon0
//        }else{
        let icon0 = UITabBarItem(title: lang1.expl_Title, image: UIImage(named: "explore"), selectedImage: UIImage(named: "explore"))
        myVC0.tabBarItem = icon0
//        }
        
        let nvc0 = UINavigationController(rootViewController: myVC0)

        let myVC1 = k_MakentStoryboard.instantiateViewController(withIdentifier: "TripsVC") as! TripsVC
        let icon1 = UITabBarItem(title: lang1.booking_Title, image: UIImage(named: "booking"), selectedImage: UIImage(named: "booking"))
        myVC1.tabBarItem = icon1
        let nvc1 = UINavigationController(rootViewController: myVC1)

        let myVC2 = SpaceListViewController.InitWithStory()
        let icon2 = UITabBarItem(title: lang1.list_Title.capitalized, image: UIImage(named: "hostlisting"), selectedImage: UIImage(named: "hostlisting"))
        myVC2.tabBarItem = icon2
        let nvc2 = UINavigationController(rootViewController: myVC2)
        
//        let myVC2 = k_MakentStoryboard.instantiateViewController(withIdentifier: "TripsVC") as! TripsVC
//        let icon2 = UITabBarItem(title: lang1.trip_Title, image: UIImage(named: k_AppTabBar), selectedImage: UIImage(named: k_AppTabBar))
//        myVC2.tabBarItem = icon2
//        let nvc2 = UINavigationController(rootViewController: myVC2)
        
        let myVC3 = k_MakentStoryboard.instantiateViewController(withIdentifier: "TripsDetailVC") as! TripsDetailVC
        myVC3.pageType = .inbox
        let icon3 = UITabBarItem(title: lang1.inbox_Title, image: UIImage(named: "inbox"), selectedImage: UIImage(named: "inbox"))
        myVC3.tabBarItem = icon3
        let nvc3 = UINavigationController(rootViewController: myVC3)
        
        let myVC4 = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        let token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        if token != "" {
            let icon4 = UITabBarItem(title: lang1.profi_Title, image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
            myVC4.tabBarItem = icon4
        }
        else{
            let icon4 = UITabBarItem(title: lang1.login_Title, image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
            myVC4.tabBarItem = icon4
        }
        let nvc4 = UINavigationController(rootViewController: myVC4)
        nvc0.isNavigationBarHidden = true
        nvc1.isNavigationBarHidden = false
        nvc2.isNavigationBarHidden = false
        nvc3.isNavigationBarHidden = true
        nvc4.isNavigationBarHidden = true
        let controllers = [nvc0,nvc1,nvc2,nvc3,nvc4]
        makentTabBarCtrler.delegate=self;
        makentTabBarCtrler.viewControllers = controllers
        window?.rootViewController = makentTabBarCtrler
        makentTabBarCtrler.selectedIndex=tabIcon;
        self.window?.makeKeyAndVisible()
        self.enableHockeyAppSdk()
        tabBarHeight = Int(self.makentTabBarCtrler.tabBar.frame.height)
        return makentTabBarCtrler
    }
    
    func setsemantic() {
        UIView.appearance().semanticContentAttribute = Language.getCurrentLanguage().getSemantic
        
    }
    
//    func generateMakentHostTabbarController() -> UITabBarController
//    {
//
//        self.setsemantic()
//        let lang1 = Language.getCurrentLanguage().getLocalizedInstance()
//
//        UITabBar.appearance().tintColor =  UIColor.appHostThemeColor
//        UITabBar.appearance().barTintColor = UIColor.white
//
//        let myVC1 = k_MakentStoryboard.instantiateViewController(withIdentifier: "TripsDetailVC") as! TripsDetailVC
//        myVC1.pageType = .reservation
//        let icon1 = UITabBarItem(title: lang1.reser_Title, image: UIImage(named: "inbox.png"), selectedImage: UIImage(named: "inbox.png"))
//        myVC1.tabBarItem = icon1
//        let nvc1 = UINavigationController(rootViewController: myVC1)
//        //Main Story
//        let myVC2 = StoryBoard.host.instance.instantiateViewController(withIdentifier: "SSCalendarTimeSelector") as! SSCalendarTimeSelector
//        myVC2.optionSelectionType = SSCalendarTimeSelectorSelection.multiple
//        myVC2.optionMultipleSelectionGrouping = .pill
//        let icon2 = UITabBarItem(title: lang1.cal_Title, image: UIImage(named: "hostcalendar.png"), selectedImage: UIImage(named: "hostcalendar.png"))
//        myVC2.tabBarItem = icon2
//        let nvc2 = UINavigationController(rootViewController: myVC2)
//        //let myVC3 = StoryBoard.host.instance.instantiateViewController(withIdentifier: "HostListing") as! HostListing
//        let myVC3 = SpaceListViewController.InitWithStory()
//        let icon3 = UITabBarItem(title: lang1.list_Title, image: UIImage(named: "hostlisting.png"), selectedImage: UIImage(named: "hostlisting.png"))
//        myVC3.tabBarItem = icon3
//        let nvc3 = UINavigationController(rootViewController: myVC3)
//        let myVC5 = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//        let icon5 = UITabBarItem(title: lang1.profi_Title, image: UIImage(named: "profile.png"), selectedImage: UIImage(named: "profile.png"))
//        myVC5.tabBarItem = icon5
//        let nvc5 = UINavigationController(rootViewController: myVC5)
//        nvc1.isNavigationBarHidden = true;
//        nvc2.isNavigationBarHidden = true;
//        nvc3.isNavigationBarHidden = false;
//        nvc5.isNavigationBarHidden = true;
//        let controllers = [nvc1,nvc2,nvc3,nvc5]
//        makentTabBarCtrler.delegate=self;
//        makentTabBarCtrler.viewControllers = controllers
//        window?.rootViewController = makentTabBarCtrler
//        makentTabBarCtrler.selectedIndex=0;
//        self.window?.makeKeyAndVisible()
//        return makentTabBarCtrler
//    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if MakentSupport().isPad(){
            return UIInterfaceOrientationMask.all
        }
        return UIInterfaceOrientationMask.portrait
    }
    
    func setSemantic(){
        UIView.appearance().semanticContentAttribute = Language.getCurrentLanguage().getSemantic
        self.makentTabBarCtrler.tabBar.semanticContentAttribute = Language.getCurrentLanguage().getSemantic
    }
    func logoutFinish(){
        arrWishListData = NSMutableArray()
        let controllersArray = self.makentTabBarCtrler.viewControllers
        for tempVC: UIViewController in controllersArray!
        {
            tempVC.removeFromParent()
        }
        UserDefaults.standard.set(false, forKey: "SecureSpaciko")
        Constants().STOREVALUE(value: "", keyname: APPURL.USER_ACCESS_TOKEN)
        Constants().STOREVALUE(value: "", keyname: APPURL.USER_ID)
        Constants().STOREVALUE(value: "", keyname: APPURL.USER_CURRENCY_SYMBOL)
        SharedVariables.sharedInstance.userToken = ""
        userDefaults.set("", forKey:"getmainpage")
        userDefaults.synchronize()
        self.resetFilersDates()
        self.lastPageMaintain = ""
        self.generateMakentLoginFlowChange(tabIcon: 4)
    }
    func logOutDidFinish()
    {
        arrWishListData = NSMutableArray()
        let controllersArray = self.makentTabBarCtrler.viewControllers
        for tempVC: UIViewController in controllersArray!
        {
            tempVC.removeFromParent()
        }
        UserDefaults.standard.set(false, forKey: "SecureSpaciko")
        Constants().STOREVALUE(value: "", keyname: APPURL.USER_ACCESS_TOKEN)
        Constants().STOREVALUE(value: "", keyname: APPURL.USER_ID)
        Constants().STOREVALUE(value: "", keyname: APPURL.USER_CURRENCY_SYMBOL)
        SharedVariables.sharedInstance.userToken = ""
        userDefaults.set("", forKey:"getmainpage")
        userDefaults.synchronize()
        self.resetFilersDates()
        self.lastPageMaintain = ""
        AppleLoginStorge.deleteUserDetails()
        self.generateMakentLoginFlowChange(tabIcon: 0)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        if UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) == "" {
            if tabBarController.selectedIndex != 4{
                self.lastSelectedIndex = tabBarController.selectedIndex
            }
        }else{
            self.lastSelectedIndex = nil
        }

    }
    func relayLayout()
    {
    }
    
    func createToastMessage(_ strMessage:String, isSuccess: Bool = false)
    {
        let lblMessage=UILabel(frame: CGRect(x: 0, y: (self.window?.frame.size.height)!+70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70))
        lblMessage.tag = 500
        lblMessage.text = strMessage
        lblMessage.textColor = (isSuccess) ? UIColor.appHostThemeColor : UIColor.red//appHostThemeColor
        lblMessage.backgroundColor = UIColor.white
        lblMessage.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: CGFloat(15))
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
        lblMessage.layer.shadowColor = UIColor.black.cgColor;
        lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
        lblMessage.layer.shadowOpacity = 0.5;
        lblMessage.layer.shadowRadius = 1.0;
        moveLabelToYposition(lblMessage)
        UIApplication.shared.keyWindow?.addSubview(lblMessage)
    }
    
    func moveLabelToYposition(_ lblView:UILabel)
    {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            lblView.frame = CGRect(x: 0, y: (self.window?.frame.size.height)!-70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
            }, completion: { (finished: Bool) -> Void in
                self.onCloseAnimation(lblView)
        })
    }
    
    func onCloseAnimation(_ lblView:UILabel)
    {
        UIView.animate(withDuration: 0.3, delay: 3.5, options: UIView.AnimationOptions(), animations: { () -> Void in
            lblView.frame = CGRect(x: 0, y: (self.window?.frame.size.height)!+70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
            }, completion: { (finished: Bool) -> Void in
                lblView.removeFromSuperview()
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        //FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

   

}

extension AppDelegate{
    //MARK:- Reset Calender Dates
    func resetFilersDates(){
        self.multipleDates.removeAll()
        self.dictFilterParams.removeAll()
        lastSelectedCategories.removeAll()
        
    }
    func selecteIndex(_ index : Int){
        guard self.makentTabBarCtrler.viewControllers?.indices.contains(index) ?? false else{return}
        self.makentTabBarCtrler.selectedIndex = index
    }
}

