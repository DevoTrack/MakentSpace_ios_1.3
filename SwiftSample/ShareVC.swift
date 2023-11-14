/**
* ShareVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class ShareVC : UIViewController,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var viewBlur: UIView!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var imgOrgBg: UIImageView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var tblShare: UITableView!
    @IBOutlet var lblRoomTitle: UILabel!
    @IBOutlet var viewImgHolder: UIView!

    let arrShareTitle = ["Email","SMS","Copy Link","Facebook","Messenger","Twitter","WhatsApp","More"]
    let arrShareImgs = ["email_icon.png","chat_icon.png","copy_icon.png","facebook_icon.png","fb_messenger.png","twitter_icon.png","whatsapp_icon.png", "more-indicator.png"]
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var strShareContent = ""
    var strRoomTitle = ""
    var strRoomUrl = ""
    var strShareUrl = ""
    var strLocationName = ""

    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        lblRoomTitle.text = "B"
//        lblRoomTitle.font = UIFont (name: MAKENT_LOGO_FONT, size: 17)!
        
        self.navigationController?.isNavigationBarHidden = true
        lblRoomTitle.text = strRoomTitle
        imgOrgBg.addRemoteImage(imageURL: strRoomUrl, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: strRoomUrl) as! URL, placeholderImage:UIImage(named:""))
        imgBg.addRemoteImage(imageURL: strRoomUrl, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: strRoomUrl) as! URL, placeholderImage:UIImage(named:""))
        self.iPhoneScreenSizes()
        

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = viewBlur.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewBlur.addSubview(blurEffectView)
        
        tblShare.reloadData()

    }
    
    func iPhoneScreenSizes(){
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        var rectEmailView = viewHeader.frame
        var rectViewImgHolder = viewImgHolder.frame
        
        switch height {
        case 568.0:
            rectEmailView.size.height = 400
        case 667.0:
            rectEmailView.size.height = 400
        case 736.0:
            rectEmailView.size.height = 400
        case 1104.0:
            rectEmailView.size.height = 660
        default:
            break
        }
        viewHeader.frame = rectEmailView

        rectViewImgHolder.origin.x = 45
        rectViewImgHolder.origin.y = 45
        rectViewImgHolder.size.width = rectEmailView.size.width-90
        rectViewImgHolder.size.height = rectViewImgHolder.size.width
        viewImgHolder.frame = rectViewImgHolder
        viewBlur.frame = viewHeader.frame
        viewImgHolder.center = viewHeader.center
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: ---------------------------------------------------------------
    //MARK: ***** Room Detail Table view Datasource Methods *****
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 61
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShareTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellShare = tblShare.dequeueReusableCell(withIdentifier: "CellShare")! as! CellShare
        cell.lblShareTitle?.text = arrShareTitle[indexPath.row]
        cell.imgShare?.image=UIImage(named: arrShareImgs[indexPath.row])
        return cell
    }
    
    //MARK: ---- Table View Delegate Methods ----
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row==7)
        {
            let activityViewController = UIActivityViewController(activityItems: [self.getDefaultShareContent()], applicationActivities: nil)
            present(activityViewController, animated: true, completion: {})
        }
    }

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    func getDefaultShareContent() -> NSString
    {
        let shareContent = String(format:"\(self.lang.checkout_Awesom) \(k_AppName.capitalized): %@\n%@",strRoomTitle,strShareUrl)
        return shareContent as NSString
    }

    func getShareContent() -> NSString
    {
        let shareContent = String(format:"\(lang.hey_Title) \n\n\(lang.grt_Place) %@ \(lang.on_Tit) \(k_AppName.capitalized). \(lang.whtthnk_Title)\n\n%@\n%@",strLocationName,strRoomTitle,strShareUrl)
        return shareContent as NSString
    }
    

   // MARK: FACEBOOK SHARE
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
            let alert = UIAlertController(title: self.lang.acc_Title, message: self.lang.pls_Log, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: self.lang.ok_Title, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: ------------------------------

    // MARK: WHATSAPP SHARE

    @IBAction func onTwitterTapped()
    {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText(self.getShareContent() as String!)
//            vc.addURL(NSURL(string: APPSTOREURL))
            present(vc!, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: self.lang.acc_Title, message: self.lang.twitlog_Err, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: self.lang.ok_Title, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: ------------------------------

    // MARK: WHATSAPP SHARE
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
    // MARK: ------------------------------

    // MARK: EMAIL SHARE
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
              let sendMailErrorAlert = UIAlertView(title: lang.email_NotSend, message: lang.email_NotSendMsg, delegate: self, cancelButtonTitle: lang.ok_Title)
            sendMailErrorAlert.show()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let strBody = self.getShareContent()
        mailComposerVC.setSubject(String(format: "\(self.lang.checkout_Msg) %@", strLocationName))
        mailComposerVC.setMessageBody(strBody as String, isHTML: false)
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    // MARK: ------------------------------
    
    // MARK: EMAIL SHARE
    @IBAction func onSMSTapped()
    {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        composeVC.body = self.getShareContent() as String
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    // MARK: - Message compose Delegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        if result==MessageComposeResult.sent
        {
        }
        else if result==MessageComposeResult.cancelled
        {
        }
        else if result==MessageComposeResult.failed
        {
        }
    }

    // MARK: ------------------------------
    // MARK: - COPY TO CLIPBOARD
    @IBAction func onCopyClipBoardTapped()
    {
        UIPasteboard.general.string = strShareUrl
        self.onBackTapped(nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onclickbutton(){
    
    
    }
}

class CellShare: UITableViewCell
{
    @IBOutlet var lblShareTitle: UILabel?
    @IBOutlet var imgShare: UIImageView?
}


