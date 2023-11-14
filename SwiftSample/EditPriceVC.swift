/**
* EditPriceVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

@objc protocol EditPriceDelegate
{
    func PriceEditted(strDescription: String)
    func currencyChangedInEditPrice(strCurrencyCode: String, strCurrencySymbol: String)
    @objc optional func updateAllRoomPrice(modelList : ListingModel)
}

class EditPriceVC : UIViewController, UITextFieldDelegate,CurrencyChangedDelegate

{
    @IBOutlet var viewBottomHolder : UIView!
    @IBOutlet var txtFldPrice : UITextField!
    @IBOutlet var viewPriceHolder : UIView!
    @IBOutlet var lblCurrency : UILabel!
    @IBOutlet var btnSave : UIButton!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var btnChangeCurrency : UIButton!

    @IBOutlet weak var btn_Back: UIButton!
    var delegate: EditPriceDelegate?
    var strPrice = ""
    var strRoomId = ""
    var room_currency_code = ""
    var room_currency_symbol = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var isFromCalendar : Bool = false
    
    @IBOutlet weak var fixedpric_Lbl: UILabel!
    @IBOutlet weak var editpric_Lbl: UILabel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.animatedLoader?.isHidden = true
        if isFromCalendar
        {
            btnChangeCurrency.isHidden = true
        }
        btnSave.isHidden = true
        btnSave.appHostTextColor()
        btn_Back.appHostTextColor()
        btnChangeCurrency.appHostTextColor()
        self.navigationController?.isNavigationBarHidden = true
        self.btnSave.setTitle(lang.save_Tit, for: .normal)
        self.editpric_Lbl.text = self.lang.edtpric_Tit
        self.fixedpric_Lbl.text = self.lang.fixpric_Msg
        self.btnChangeCurrency.setTitle(self.lang.chng_Curr, for: .normal)
        self.btn_Back.transform = self.getAffine
//        self.lrnmre_Lbl.text = self.lang.learn_Mre
        self.txtFldPrice.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        txtFldPrice.becomeFirstResponder()
        viewBottomHolder.isHidden = true
        lblCurrency.text = room_currency_symbol.stringByDecodingHTMLEntities
        viewPriceHolder.layer.borderColor = UIColor(red: 207.0 / 255.0, green: 207.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0).cgColor
        viewPriceHolder.layer.borderWidth = 1.0

//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        
        if strPrice != "" && strPrice != "0"
        {
            txtFldPrice.text = strPrice
        }
    }
    
//    func keyboardWillShow(notification: NSNotification)
//    {
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        
//        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewBottomHolder)
//    }
//    
//    func keyboardWillHide(notification: NSNotification)
//    {
//        MakentSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: viewBottomHolder)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        if strPrice == textField.text
        {
            btnSave.isHidden = true
            return
        }
        btnSave.isHidden = ((textField.text?.count)! > 0) ? false : true
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
    
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)

        if isFromCalendar
        {
            self.delegate?.PriceEditted(strDescription: self.txtFldPrice.text!)
            self.navigationController!.popViewController(animated: true)
            return
        }
        var dicts = [AnyHashable: Any]()

        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        self.btnSave?.isHidden = true

        self.animatedLoader?.isHidden = false

        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = strRoomId
        dicts["language"] = Language.getCurrentLanguage().rawValue
        let strPrice = YSSupport.escapedValue(((txtFldPrice.text)!  as NSString) as String!)

        dicts["room_price"]   = strPrice
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ADD_ROOM_PRICE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false

                if gModel.status_code == "1"
                {
                    self.delegate?.PriceEditted(strDescription: self.txtFldPrice.text!)
                    self.navigationController!.popViewController(animated: true)
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
//                    self.btnBack.isUserInteractionEnabled = true
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }

    @IBAction func onChangeCurrencyTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        let coutryView = k_MakentStoryboard.instantiateViewController(withIdentifier: "CountryVC") as! CountryVC
        coutryView.strApiMethodName = APPURL.METHOD_UPDATE_ROOM_CURRENCY
        coutryView.strCurrentCurrency = room_currency_code
        coutryView.strTitle = "Currency"
        coutryView.delegate = self
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(coutryView, animated: true)
    }
    
    internal func updateBookTypeOrPolicy(strDescription: String)
    {
        // no need to implement
    }

    internal func roomCurrencyChanged(strCurrencyCode: String, strCurrencySymbol: String)
    {
        delegate?.currencyChangedInEditPrice(strCurrencyCode: strCurrencyCode, strCurrencySymbol: strCurrencySymbol)
        room_currency_code = strCurrencyCode
        lblCurrency.text = strCurrencySymbol.stringByDecodingHTMLEntities
    }
    
    internal func updateRoomPrice(modelList : ListingModel)
    {
        txtFldPrice.text = ((modelList.room_price as String) == "0") ? "" : modelList.room_price as String
        delegate?.updateAllRoomPrice!(modelList : modelList)
        self.appDelegate.createToastMessage(self.lang.romadpri_Tit, isSuccess: true)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
