/**
* EditTitleVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol EditTitleDelegate
{
    func EditTitleTapped(strDescription: NSString)
}

class EditTitleVC : UIViewController, UITextViewDelegate
{
    @IBOutlet var viewBottomHolder : UIView!
    @IBOutlet var txtViewTitle : UITextView!
    @IBOutlet var lblPlacHolder : UILabel!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var btnSave : UIButton!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var btnClose : UIButton!

    @IBOutlet var lblCharLeft : UILabel!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var strRoomId = ""
    var isFromEditProfile : Bool = false
    var isFromRoomDesc : Bool = false
    var nMaxCharCount : Int = 0
    var strTitle:String = ""
    var strPlaceHolder:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var delegate: EditTitleDelegate?
    var strAboutMe:String = ""

    @IBOutlet weak var lbl_Title: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        self.lblTitle.text = self.lang.edittit_Tit
        self.btnBack.transform = Language.getCurrentLanguage().getAffine
        btnSave.appHostTextColor()
        btnBack.appHostTextColor()
        btnClose.appHostTextColor()
        self.txtViewTitle.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        btnSave.setTitle(self.lang.save_Tit, for: .normal)
        self.navigationController?.isNavigationBarHidden = true
        txtViewTitle.becomeFirstResponder()
        btnSave.isHidden = true
        if nMaxCharCount == 0
        {
            viewBottomHolder.isHidden = true
        }
        lblPlacHolder.isHidden = (strAboutMe.count > 0) ? true : false
        txtViewTitle.text = (strAboutMe.count > 0) ? strAboutMe : ""
        btnSave.isHidden = (strAboutMe.count > 0) ? false : true
        btnClose.isHidden = true
        
        if(isFromEditProfile)
        {
            btnSave.isHidden = false
            btnClose.isHidden = false
            txtViewTitle.text = (strAboutMe.count > 0) ? strAboutMe : ""
            btnSave.setTitleColor(UIColor.darkGray, for: .normal)
            btnClose.setTitle("=", for: .normal)
            
            btnBack.setTitle("", for: .normal)

            lblTitle.isHidden = true
            lblPlacHolder.isHidden = true
            viewBottomHolder.isHidden = true
            self.view.backgroundColor = UIColor.white
        }
        
        let length =  txtViewTitle.text?.count
        lblCharLeft.text = String(format:"%d \(self.lang.chlef_Tit)",nMaxCharCount - length!)

        self.animatedLoader?.isHidden = true
        
        if strTitle == "Edit Title"{
            lblTitle.text = lang.edit_Tit
        }else{
            lblTitle.text = lang.edit_Summ
        }
        lblPlacHolder.text = strPlaceHolder
        
        
        let height = MakentSupport().onGetStringHeight(lblPlacHolder.frame.size.width, strContent: strPlaceHolder as NSString, font: lblPlacHolder.font)
        var rectEmailView = lblPlacHolder.frame
        rectEmailView.size.height = height+5
        lblPlacHolder.frame = rectEmailView

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewBottomHolder)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: viewBottomHolder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {

        let length =  txtViewTitle.text?.count
        
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        }

        if nMaxCharCount == 0
        {
            return true
        }

        let newLength = length! + text.count
        if(newLength <= nMaxCharCount)
        {
            return true
        }
        else{
            let emptySpace: Int = nMaxCharCount - length!
            if !(emptySpace > text.count) {
                return false
            }
            if emptySpace > nMaxCharCount {
                return false
            }
        }
        
        if length! >= nMaxCharCount
        {
            return false
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView)
    {
        let length =  txtViewTitle.text?.count
        if(!isFromEditProfile)
        {
            if length!>0
            {
                btnSave.isHidden = false
                lblPlacHolder.isHidden = true
            }
            else
            {
                btnSave.isHidden = true
                lblPlacHolder.isHidden = false
            }
        }
        
        if isFromRoomDesc
        {
            btnSave.isHidden = false
        }
        if nMaxCharCount != 0
        {
            lblCharLeft.text = String(format:"%d \(self.lang.chlef_Tit)",nMaxCharCount - length!)
        }
    }

    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        if(isFromEditProfile)
        {
            let st = (txtViewTitle.text.count)>0 ? txtViewTitle.text as NSString : ""
            delegate?.EditTitleTapped(strDescription: st  as NSString)
            self.navigationController!.popViewController(animated: true)
            return
        }
        
        if strAboutMe == txtViewTitle.text
        {
            self.onBackTapped(nil)
            return
        }
        
        btnBack.isUserInteractionEnabled = false
        var dicts = [AnyHashable: Any]()
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = strRoomId
        
        let strTextValue =  txtViewTitle.text?.trimmingCharacters(in: .whitespaces) ?? ""//YSSupport.escapedValue((txtViewTitle.text  as NSString) as String!)

        if isFromRoomDesc
        {
            if strTitle == self.lang.thespac_Tit
            {
                dicts["space"]   = strTextValue
            }
            else if strTitle == self.lang.guesacc_Tit
            {
                dicts["guest_access"]   = strTextValue
            }
            else if strTitle == self.lang.interact_Guest
            {
                dicts["interaction_guests"]   = strTextValue
            }
            else if strTitle == self.lang.overview_Tit
            {
                dicts["neighborhood_overview"]   = strTextValue
            }
            else if strTitle == self.lang.getarnd_Tit
            {
                dicts["getting_arround"]   = strTextValue
            }
            else if strTitle == self.lang.otherthng_Tit
            {
                dicts["notes"]   = strTextValue
            }
            else if strTitle == self.lang.houserul_Titl
            {
                dicts["house_rules"]   = strTextValue
                self.updateDescriptionToServer(dicts, methodName:APPURL.METHOD_UPDATE_HOUSE_RULES as NSString)
                return
            }
            self.updateDescriptionToServer(dicts, methodName:APPURL.METHOD_UPDATE_ROOM_DESC as NSString)
        }
        else if txtViewTitle.text.count > 0
        {
            if strTitle == self.lang.edit_Tit || strTitle == self.lang.edit_Summ
            {
                if strTitle == self.lang.edit_Tit
                {
                    dicts["room_title"]   = strTextValue
                }
                else
                {
                    dicts["room_description"]   = strTextValue
                }
                
                self.updateDescriptionToServer(dicts, methodName:APPURL.METHOD_UPDATE_TITLE as NSString)
            }
        }
    }
    
    func updateDescriptionToServer(_ dicts:[AnyHashable: Any],methodName: NSString)
    {
        self.btnSave.isHidden = true
        self.animatedLoader?.isHidden = false

        MakentAPICalls().GetRequest(dicts,methodName: methodName as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            OperationQueue.main.addOperation {
                if methodName as String == APPURL.METHOD_UPDATE_ROOM_DESC
                {
                    let abtModel = response as! AboutListingModel
                    if abtModel.status_code == "1"
                    {
                        self.delegate?.EditTitleTapped(strDescription: self.txtViewTitle.text as NSString)
                        self.navigationController!.popViewController(animated: true)
                    }
                    else
                    {
                        self.btnBack.isUserInteractionEnabled = true
                        self.appDelegate.createToastMessage(abtModel.success_message as String, isSuccess: false)
                    }
                }
                else
                {
                    let gModel = response as! GeneralModel
                    if gModel.status_code == "1"
                    {
                        self.delegate?.EditTitleTapped(strDescription: self.txtViewTitle.text as NSString)
                        self.navigationController!.popViewController(animated: true)
                    }
                    else
                    {
                        self.btnSave.isHidden = false
                        self.animatedLoader?.isHidden = true
                        self.btnBack.isUserInteractionEnabled = true
                        self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                        if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                        {
                            self.appDelegate.logOutDidFinish()
                            return
                        }
                    }
                }
                self.animatedLoader?.isHidden = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                //                self.isDataFinishedFromServer = true
                self.btnBack.isUserInteractionEnabled = true
                self.btnSave.isHidden = false
                self.animatedLoader?.isHidden = true
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
