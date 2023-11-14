/**
* ViewProfileVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit

protocol ViewProfileDelegate
{
    func profileInfoChanged()
}

class ViewProfileVC : UIViewController, UITableViewDelegate, UITableViewDataSource,EditProfileDelegate
{
    
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet var imgUserThumb : UIImageView!
    @IBOutlet var viewHeader : UIView!
    @IBOutlet var tblViewProfile : UITableView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblLocation : UILabel!
    @IBOutlet var btnEdit : UIButton?
    
    var isReadMoreTapped : Bool = false

    let arrShareTitle = ["Email","Facebook","Google +","Twitter"]
    var delegate: ViewProfileDelegate?
    var strOtherUserId : String = ""
    var strSinceFrom = "Member Since November 2016"
    var strSchoolName = "MNMSPS, MIET Engineering College"
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var modelProfileData : ProfileModel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let langAffin = Language.getCurrentLanguage()
    var token = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        back_Btn.transform = self.langAffin.getAffine
        btnEdit?.layer.shadowColor = UIColor.gray.cgColor;
        btnEdit?.layer.shadowOffset = CGSize(width:1.0, height:1.0);
        btnEdit?.layer.shadowOpacity = 0.5;
        btnEdit?.layer.shadowRadius = 1.0;
        btnEdit?.layer.cornerRadius = (btnEdit?.frame.size.height)!/2;        
        self.navigationController?.isNavigationBarHidden = true
        print("UserId:",strOtherUserId)
        lblName.text = ""
        lblLocation.text = ""
        if modelProfileData != nil
        {
            self.setUserInfo()
        }else if strOtherUserId.count > 0
        {
            if Constants().GETVALUE(keyname: APPURL.USER_ID) as String == strOtherUserId
            {
                self.getUserProfile()
            }
            else
            {
                lblName.text = ""
                lblLocation.text = ""
                btnEdit?.isHidden = true
                self.getOtherUserProfile()
            }
        }else{
            self.getUserProfile()
        }
    }
    
    
    func getUserProfile()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        
        var dicts = [String: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.METHOD_VIEW_PROFILE, paramDict: dicts, viewController: self, isToShowProgress: false, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                let model = ProfileModel(json: responseDict.json("user_details"))
                self.modelProfileData = model
                self.setUserInfo()
            }else {
                self.appDelegate.createToastMessage(responseDict.statusMessage)
            }
        }
    }
    
    func getOtherUserProfile()
    {
        var dicts = [String: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["user_id"]   = strOtherUserId
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "user_profile_details", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            if responseDict.isSuccess {
                let model = ProfileModel(otherProfileJson: responseDict.json("user_details"))
                //                    ProfileModel(json: responseDict.json("user_details"))
                self.modelProfileData = model
                self.setUserInfo()
            }else {
                self.appDelegate.createToastMessage(responseDict.statusMessage)
            }
        }
    }
    
    func setUserInfo(){
        imgUserThumb.addRemoteImage(imageURL: modelProfileData.user_normal_image_url as String, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: modelProfileData.user_normal_image_url as String)! as URL, placeholderImage:UIImage(named:""))
        lblName.text = modelProfileData.user_name.removingPercentEncoding ?? ""
        lblLocation.text = modelProfileData.user_location as String
         iPhoneScreenSizes()
        self.tblViewProfile.reloadData()
        var rectEmailView = btnEdit?.frame
        rectEmailView?.origin.y = imgUserThumb.frame.size.height - 25
        btnEdit?.frame = rectEmailView!
    }
    
    func iPhoneScreenSizes()
    {
        let bounds = UIScreen.main.bounds
//        let height = bounds.size.height
        let width = bounds.size.width
        var rectEmailView = viewHeader.frame
        
//        switch height {
//        case 480.0:
            rectEmailView.size.height = width + 90
//        case 568.0:
//            rectEmailView.size.height = width + 90
//        case 667.0:
//            rectEmailView.size.height = width + 90
//        case 736.0:
//            rectEmailView.size.height = width + 90
//        case 1104.0:
//            rectEmailView.size.height = width + 90
//        default:
//            print("")
//        }
        
        viewHeader.frame = rectEmailView
//        viewHeader.layer.borderColor = UIColor.red.cgColor
//        viewHeader.layer.borderWidth = 1.0
        
        var rectImgView = imgUserThumb.frame
        rectImgView.size.height = width - 10
        imgUserThumb.frame = rectImgView

        
        print(imgUserThumb.frame)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: ---------------------------------------------------------------
    //MARK: ***** Room Detail Table view Datasource Methods *****
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == 0)
        {
            var height = 0
            if (modelProfileData.about_me as String).count > 0
            {
                height = Int(MakentSupport().onGetStringHeight(self.view.frame.size.width-40, strContent: modelProfileData.about_me, font: UIFont (name: Fonts.CIRCULAR_LIGHT, size: 16)!))
                if !isReadMoreTapped
                {
                    if height>100
                    {
                        height = 100
                    }
                    else if height < 45
                    {
                        height = 45
                    }
                    else{
                        height = height + 10
                    }
                }
            }
            return CGFloat((modelProfileData.about_me as String).count > 0 ? height+25 : 0)
        }
        else if(indexPath.row == 1)
        {
            return (modelProfileData.school as String).count > 0 ? 153 : 56 //(indexPath.section == 0) ? 61 : 153
        }
        else{
            return (modelProfileData.is_email_connect as String).count > 0 ? 153 : 56 //(indexPath.section == 0) ? 61 : 153

        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (modelProfileData == nil)
        {
            return 0
        }
        return 3
//        return (section == 0) ? arrShareTitle.count : 1
        // return (section == 0) ? arrShareTitle.count : 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath.row == 0)
        {
            let cell:CellAboutMe = tableView.dequeueReusableCell(withIdentifier: "CellAboutMe")! as! CellAboutMe
            if (modelProfileData.about_me as String).count > 0
            {
                var height = MakentSupport().onGetStringHeight(self.view.frame.size.width-40, strContent: modelProfileData.about_me, font: UIFont (name: Fonts.CIRCULAR_LIGHT, size: 16)!)
                cell.btnReadMore?.addTarget(self, action: #selector(self.onReadMoreTapped), for: UIControl.Event.touchUpInside)
//                cell.contentView.backgroundColor = UIColor.lightGray
                if !isReadMoreTapped
                {
                    let str = modelProfileData.about_me as String
                    if str.count > 150
                    {
                        let first2Chars = String(str.characters.prefix(150)) // first2Chars = "My"
                        height = 100
                        let newStr = String(format: "%@\(self.lang.redmore_Title)", first2Chars)
//                        print(newStr.count)
                        cell.lblAboutMe?.attributedText = MakentSupport().makeAttributeTextColor(originalText: newStr as NSString, normalText: first2Chars as NSString, attributeText: self.lang.redmore_Title as NSString, font: (cell.lblAboutMe?.font)!)
                        cell.btnReadMore?.isUserInteractionEnabled = true
                    }
                    else
                    {
                        height = 45
                        cell.btnReadMore?.isUserInteractionEnabled = false
                        cell.lblAboutMe?.text = modelProfileData.about_me as String
                    }
                }
                else
                {
                    cell.btnReadMore?.isUserInteractionEnabled = false
                    cell.lblAboutMe?.text = modelProfileData.about_me as String
                }
                var rectLblDetails = cell.lblAboutMe?.frame
                rectLblDetails?.size.height = height+10
                cell.lblAboutMe?.frame = rectLblDetails!
            }
            return cell
        }
        else if(indexPath.row == 1)
        {
            let cell:CellViewProfileOthers = tableView.dequeueReusableCell(withIdentifier: "CellViewProfileOthers")! as! CellViewProfileOthers
            cell.school_Lbl.text = self.lang.schl_Tit
            cell.lblSinceFrom?.text = String(format:"\(self.lang.memsin_Tit) %@",modelProfileData.member_from)
            cell.lblSchoolName?.text = (modelProfileData.school as String).count > 0 ? modelProfileData.school as String :""
            return cell
        }
        else{
                let cell:CellViewVerifyinto = tableView.dequeueReusableCell(withIdentifier: "CellViewVerifyinto")! as! CellViewVerifyinto
            cell.verifyinfo.text = self.lang.verif_Info
            if(modelProfileData.is_email_connect == "yes"){
                    
                     cell.email.text = self.lang.email_Title
                
                 }
                return cell
                    }
    }
    
    //MARK: ---- Table View Delegate Methods ----
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func onReadMoreTapped()
    {
        if !isReadMoreTapped
        {
            isReadMoreTapped = true
            tblViewProfile.reloadData()
        }
    }

    @IBAction func onEditProfileTapped(_ sender:UIButton!)
    {
        let viewEditProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
//        viewEditProfile.imgUser = imgUserThumb?.image
        viewEditProfile.modelProfileData = modelProfileData
        viewEditProfile.delegate = self
        viewEditProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }

    internal func profileInfoChanged()
    {
        delegate?.profileInfoChanged()
        self.getUserProfile()
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if self.navigationController != nil
        {
            self.navigationController!.popViewController(animated: true)
        }
        else
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellViewProfile : UITableViewCell
{
    @IBOutlet var lblSocialTitle: UILabel?
    @IBOutlet var btnSocialConnect: UIButton?
}

class CellViewProfileOthers : UITableViewCell
{
    @IBOutlet weak var school_Lbl: UILabel!
    @IBOutlet var lblSinceFrom: UILabel?
    @IBOutlet var lblSchoolName: UILabel?
}

class CellAboutMe : UITableViewCell
{
    @IBOutlet var btnReadMore: UIButton?
    @IBOutlet var lblAboutMe: UILabel?
}

class CellViewVerifyinto : UITableViewCell
{
   
    @IBOutlet weak var verifyinfo: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var linkedin: UILabel!
    @IBOutlet weak var google: UILabel!
    @IBOutlet weak var fb: UILabel!
    @IBOutlet weak var phno: UILabel!
    
}

