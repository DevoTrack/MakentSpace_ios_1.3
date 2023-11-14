/**
* PreAcceptVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit

class PreAcceptVC : UIViewController,UITextViewDelegate, ViewOfflineDelegate  {
    
    @IBOutlet var txtMessage : UITextView!
    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var btnAccept : UIButton?

    @IBOutlet weak var accp_Mdg: UILabel!
    var strSeletedReason : String = ""
    var strReservationId : String = ""
    var strRoomId : String = ""
    var strPageTitle : String = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrCurrency = NSArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtMessage.text = ""
        txtMessage.textColor = UIColor.darkGray
        txtMessage.returnKeyType = UIReturnKeyType.done
        txtMessage.delegate = self
        txtMessage.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.navigationController?.isNavigationBarHidden = true
        lblTitle?.text = self.lang.preacc_Req
        self.accp_Mdg.text = self.lang.opt_Msg
        self.accp_Mdg.appGuestTextColor()
        self.accp_Mdg.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        btnAccept?.setTitle(self.lang.preAccepted, for: .normal)
        btnAccept?.appGuestBGColor()
        if strPageTitle.count > 0
        {
            btnAccept?.setTitle(strPageTitle, for: .normal)
            lblTitle?.text = String(format:"%@ \(self.lang.thisreq_Title)",strPageTitle)
        }
        
        lblTitle?.layer.shadowColor = UIColor.gray.cgColor;
        lblTitle?.layer.shadowOffset = CGSize(width:1.0, height:1.0);
        lblTitle?.layer.shadowOpacity = 0.5;
        lblTitle?.layer.shadowRadius = 1.0;
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        onPreAcceptTapped(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onPreAcceptTapped(_ sender:UIButton!)
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        
//        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"]      = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["reservation_id"]    = strReservationId
        
        let strMsg = txtMessage.text
//            YSSupport.escapedValue((txtMessage.text  as NSString) as String!)
        
        if (strPageTitle.count > 0)
        {
            dicts["message"]    = strMsg?.removingPercentEncoding
            dicts["template"]    = "1"
        }
        else
        {
            dicts["message_to_guest"]    = strMsg?.removingPercentEncoding
        }
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: (strPageTitle.count > 0) ? APPURL.API_PRE_APPROVAL_OR_DECLINE: APPURL.API_PRE_ACCEPT, paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "preacceptchanged"), object: self, userInfo: nil)
                self.onBackTapped(nil)

            }else {
                self.appDelegate.createToastMessage(responseDict.statusMessage, isSuccess: false)
            }
        }
        
//        MakentAPICalls().GetRequest(dicts,methodName: (strPageTitle.count > 0) ? METHOD_PRE_APPROVAL_OR_DECLINE as NSString : METHOD_PRE_ACCEPT as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
//            let gModel = response as! GeneralModel
//            OperationQueue.main.addOperation {
//                if gModel.status_code == "1"
//                {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "preacceptchanged"), object: self, userInfo: nil)
//                    self.onBackTapped(nil)
//                }
//                else
//                {
//                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
//                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
//                    {
//                        self.appDelegate.logOutDidFinish()
//                        return
//                    }
//                }
//                MakentSupport().removeProgress(viewCtrl: self)
//            }
//        }, andFailureBlock: {(_ error: Error) -> Void in
//            OperationQueue.main.addOperation {
//                MakentSupport().removeProgress(viewCtrl: self)
//                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
//            }
//        })
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        }
        
        if (text == "\n") {
            txtMessage.resignFirstResponder()
            return true
        }

        return true
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
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


