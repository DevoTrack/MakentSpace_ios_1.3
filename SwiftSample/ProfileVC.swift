/**
* ProfileVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social
import FirebaseCore
import SDWebImage
import SafariServices

class ProfileVC : UIViewController,UITableViewDelegate, UITableViewDataSource,ViewProfileDelegate {
    
    
    
    @IBOutlet var tableProfile: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var lblUserName: UILabel?
    @IBOutlet var btnViewProfile: UIButton?
    @IBOutlet var animatedImageView: FLAnimatedImageView?

    @IBOutlet weak var viewedt_Lbl: UILabel!
    var strVerses:String = ""
    var modelProfileData : ProfileModel!
    var isFirstTime:Bool = true
    var token = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrSettingData: [String] = []
    var arrimgDetails: [String] = []
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var stretchableTableHeaderView : HFStretchableTableHeaderView! = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        self.viewedt_Lbl.text = self.lang.viewedt_Tit
        if token == "" {
            self.tabBarItem.title = self.lang.login_Title
            let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            mainPage.hidesBottomBarWhenPushed = true
            
            appDelegate.lastPageMaintain = "profile"
            let naivgation = UINavigationController(rootViewController: mainPage)
            naivgation.modalPresentationStyle = .fullScreen
            self.present(naivgation, animated: false, completion: nil)
        }else{
            self.tabBarItem.title = self.lang.profl_Title
            self.navigationController?.isNavigationBarHidden = true
            MakentSupport().setDotLoader(animatedLoader: animatedImageView!)
            btnViewProfile?.isHidden = true
            stretchableTableHeaderView = HFStretchableTableHeaderView()
            stretchableTableHeaderView.stretchHeader(for: tableProfile, with: tblHeaderView)
            lblUserName?.text = Constants().GETVALUE(keyname: APPURL.USER_FIRST_NAME) as String
            let userDefaults = UserDefaults.standard
            var getMainPage =  userDefaults.object(forKey: "getmainpage") as? String
            getMainPage = ((getMainPage == "guest")) ? self.lang.switchhost_Title : self.lang.switchtravel_Title
            //getMainPage!, "switch_mode.png",
            arrSettingData = [self.lang.setting_Title, self.lang.helpandsup_Title, self.lang.whyhost_Title,self.lang.yourReserv_Title,self.lang.wishList_Title]
            arrimgDetails = ["setting_icon.png", "lifesaver.png", "add_listings.png","inbox","saved.png"]
           
            isFirstTime = false
            self.getUserProfile()
            
        }
    }
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.getUserProfile()
    }
    
    func getUserProfile()
    {
        
          if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
            {
                return
            }
            
            var dicts = [String: Any]()
            dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.METHOD_VIEW_PROFILE, paramDict: dicts, viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
                if responseDict.isSuccess {
                    let model = ProfileModel(json: responseDict.json("user_details"))
                    self.modelProfileData = model
                    self.setUserInfo()
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(model.dob, forKey:"DOB")
                    
                }else {
                    self.appDelegate.createToastMessage(responseDict.statusMessage)
                }
                self.animatedImageView?.isHidden = true
                self.tableProfile.reloadData()
            }
            
            
       
    }

    func setUserInfo()
    {
        btnViewProfile?.isHidden = false
        let normal_image = modelProfileData.user_normal_image_url.description
        let avatarURL : URL? = URL(string: normal_image)

//        imgUserThumb?.addRemoteImage(imageURL: normal_image, placeHolderURL: "avatar_placeholder.png")
        if let url = avatarURL {
            imgUserThumb?.sd_setImage(with: url, placeholderImage:UIImage(named:""))//avatar_placeholder.png
        }else{
            self.imgUserThumb?.image = UIImage(named: "avatar_placeholder.png")
        }
        lblUserName?.text = modelProfileData.first_name as String
        imgUserThumb?.layer.cornerRadius = (imgUserThumb?.frame.size.width)!/2
        imgUserThumb?.clipsToBounds = true
        var fist = modelProfileData.first_name
        var  last = modelProfileData.user_name
        fist = (fist.removingPercentEncoding ?? "") as NSString
        last = (last.removingPercentEncoding ?? "") as NSString
        Constants().STOREVALUE(value: fist, keyname: APPURL.USER_FIRST_NAME)
        Constants().STOREVALUE(value: last, keyname: APPURL.USER_FULL_NAME)
        self.tableProfile.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 76
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettingData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ProfileCell = tableProfile.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell

        cell.lblName?.text = arrSettingData[indexPath.row]
        cell.imgSetting?.image =  UIImage(named: arrimgDetails[indexPath.row])// 
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let titleTxt = arrSettingData[indexPath.row]

//        if(indexPath.row==0)
//        {
//
//            let userDefaults = UserDefaults.standard
//
//            let getMainPage = userDefaults.object(forKey: "getmainpage") as! String
//
//            if(getMainPage == "guest")
//            {
//                SharedVariables.sharedInstance.multipleDates = [Date]()
//                userDefaults.set("host", forKey:"getmainpage")
//            }
//            else
//            {
//                userDefaults.set("guest", forKey:"getmainpage")
//            }
//            appDelegate.makeSwitchSpalsh()
//        }
        
//            [ getMainPage!, self.lang.setting_Title, self.lang.helpandsup_Title, self.lang.whyhost_Title,self.lang.yourReserv_Title,self.lang.wishList_Title]
        if titleTxt == self.lang.setting_Title
        {
            let locView = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ProfileSettings") as! ProfileSettings
            locView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(locView, animated: true)
        }
        else if titleTxt == self.lang.helpandsup_Title {
//
//                let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
//                viewWeb.hidesBottomBarWhenPushed = true
//                viewWeb.strPageTitle = self.lang.helpandsup_Title
//            viewWeb.strWebUrl = String(format:"%@%@?token=%@",k_WebServerUrl,webPageUrl.URL_HELPS_SUPPORT,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))
            if let url = URL(string: self.lang.helpandsup_Title)  {
                let vc = SFSafariViewController(url:url )
                    self.navigationController?.present(vc, animated: true, completion: nil)
            } else {
                guard let newurl = URL(string: String(format: "%@%@?token=%@", k_WebServerUrl,webPageUrl.URL_HELPS_SUPPORT,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))) else {
                    return
                }
                    let vc = SFSafariViewController(url:newurl)
                        self.navigationController?.present(vc, animated: true, completion: nil)
            }
            
            
        }
        else if titleTxt == self.lang.whyhost_Title {
            
            let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
            viewWeb.hidesBottomBarWhenPushed = true
            viewWeb.strPageTitle = self.lang.whyhost_Title
            viewWeb.strWebUrl = String(format:"%@%@?token=%@",k_WebServerUrl,webPageUrl.URL_WHY_HOST,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))
            self.navigationController?.pushViewController(viewWeb, animated: true)
            

        }else if titleTxt == self.lang.yourReserv_Title {
            let myVC3 = k_MakentStoryboard.instantiateViewController(withIdentifier: "TripsDetailVC") as! TripsDetailVC
            myVC3.pageType = .reservation
            myVC3.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myVC3, animated: true)
        }else if titleTxt  == self.lang.wishList_Title {
            
            self.navigationController?.navigationBar.isHidden = false
            let wishlistVC = StoryBoard.account.instance.instantiateViewController(withIdentifier: "WhishListVC") as! WhishListVC
            wishlistVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wishlistVC, animated: true)
        }
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if self.stretchableTableHeaderView != nil {
            self.stretchableTableHeaderView.scrollViewDidScroll(scrollView)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        if self.stretchableTableHeaderView != nil{
            self.stretchableTableHeaderView.resize()
        }
    }

    @IBAction func onEditProfileTapped(_ sender:UIButton!)
    {
        let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        
        viewProfile.modelProfileData = modelProfileData
        viewProfile.hidesBottomBarWhenPushed = true
        viewProfile.delegate = self
        self.navigationController?.pushViewController(viewProfile, animated: true)
    }

    //MARK: VIEW PROFILE DELEGATE METHOD
    internal func profileInfoChanged()
    {
        
        self.getUserProfile()
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
   
}

