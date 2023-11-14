//
//  StripeVC.swift
//  Makent
//
//  Created by Trioangle on 12/07/18.
//  Copyright © 2018 Mani kandan. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

protocol AddStripePayoutDelegate
{
    func payoutStripeAdded()
}
class StripeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var stripTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerHolder: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var imgUserThumb: UIImageView!
    @IBOutlet weak var pickerCloseButtonOutlet: UIButton!
    
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var imagePicker = UIImagePickerController()
    var stripeArrayDataDict = [String:String]()
    var stripeTitleArray = [String]()
    var AddressKana = [String]()
    var AddressKanji = [String]()
    var curencypicker = [String]()
    var countryNamepicker = [String]()
    var countryIdpicker = [String]()
    var countryCodepicker = [String]()
    var genderPicker = [String]()
    var countryDicts : NSMutableArray = NSMutableArray()
    var selectedCountry = ""
    var selectedCountryCode = ""
    var selectedCurrency = ""
    var selectedGender = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var type = ""
    var user_id = ""
    var legalImage = NSData()
    var additionalImage = NSData()
    var imagetopost = UIImage()
    var legalImgName = ""
    var additionalImgName = String()
    var selectedCell : StripeCell!
    var isLegalSelected = Bool()

    @IBOutlet weak var py_Tit: UILabel!
    
    var delegate: AddStripePayoutDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCountryName()
        pickerHolder.isHidden = true
        stripeArrayDataDict = [self.lang.country_Title:"",self.lang.phn_Num:"",self.lang.curren_Title:"",self.lang.iban_Num:"",self.lang.acc_HoldName:"",self.lang.add1_Val:"",self.lang.address2_Title:"",self.lang.city_Title:"",self.lang.stat_Prov:"",self.lang.postal_Title:""]
        self.backButton.transform = Language.getCurrentLanguage().getAffine
        self.genderPicker = [self.lang.male_Title,self.lang.female_Title]
        stripeTitleArray = [self.lang.country_Title,self.lang.phn_Num,self.lang.curren_Title,self.lang.iban_Num,self.lang.acc_HoldName,self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
        self.pickerCloseButtonOutlet.setTitle(self.lang.close_Tit, for: .normal)
        self.py_Tit.text = self.lang.payout_Tit
       self.backButton.transform = Language.getCurrentLanguage().getAffine
        submitButton.appGuestSideBtnBG()
        submitButton.setTitle(self.lang.submit_Tit, for: .normal)
        stripTableView.showsHorizontalScrollIndicator = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        let tagVal = sender.tag
        pickerHolder.isHidden = true
        if selectedCountry == "Australia" {
            var tempDict = [
                self.lang.country_Title:selectedCountryCode,
                self.lang.phn_Num:"",
                self.lang.curren_Title:selectedCurrency,
                self.lang.bankst_Tit:"",
                self.lang.acc_NumTit:"",
                self.lang.acc_HoldName:"",
                self.lang.add1_Val:"",
                self.lang.address2_Title:"",
                self.lang.city_Title:"",
                self.lang.stat_Prov:"",
                self.lang.postal_Title:""
            ]
            
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            stripeTitleArray = [
                self.lang.country_Title,
                self.lang.phn_Num,
                self.lang.curren_Title,
                self.lang.bankst_Tit,
                self.lang.acc_NumTit,
                self.lang.acc_HoldName,
                self.lang.city_Title,
                self.lang.add1_Val,
                self.lang.address2_Title,
                self.lang.stat_Prov,
                self.lang.postal_Title
            ]
            
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            
            curencypicker = (listModel?.currency_code) as! [String]
            
        }
        else if selectedCountry == "Canada" {
            
            var tempDict = [
                self.lang.country_Title:selectedCountryCode,
                self.lang.phn_Num:"",
                self.lang.curren_Title:selectedCurrency,
                self.lang.trnas_Num:"",
                self.lang.intnum_Tit:"",
                self.lang.acc_NumTit:"",
                self.lang.acc_HoldName:"",
                self.lang.add1_Val:"",
                self.lang.address2_Title:"",
                self.lang.city_Title:"",
                self.lang.stat_Prov:"",
                self.lang.postal_Title:""
            ]
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            
            stripeTitleArray = [
                self.lang.country_Title,
                self.lang.phn_Num,
                self.lang.curren_Title,
                self.lang.trnas_Num,
                self.lang.intnum_Tit,
                self.lang.acc_NumTit,
                self.lang.acc_HoldName,
                self.lang.add1_Val,
                self.lang.address2_Title,
                self.lang.city_Title,
                self.lang.stat_Prov,
                self.lang.postal_Title
            ]
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]
        }
        else if selectedCountry == "New Zealand" {
            
            var tempDict = [
                self.lang.country_Title:selectedCountryCode,
                self.lang.phn_Num:"",
                self.lang.curren_Title:selectedCurrency,
                self.lang.rount_Num:"",
                self.lang.acc_NumTit:"",
                self.lang.acc_HoldName:"",
                self.lang.add1_Val:"",
                self.lang.address2_Title:"",
                self.lang.city_Title:"",
                self.lang.stat_Prov:"",
                self.lang.postal_Title:""
            ]
            
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            stripeTitleArray = [
                self.lang.country_Title,
                self.lang.phn_Num,
                self.lang.curren_Title,
                self.lang.rount_Num,
                self.lang.acc_NumTit,
                self.lang.acc_HoldName,
                self.lang.add1_Val,
                self.lang.address2_Title,
                self.lang.city_Title,
                self.lang.stat_Prov,
                self.lang.postal_Title
            ]
            
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]

        }
        else if selectedCountry == "United States" {
            
            var tempDict = [
                self.lang.country_Title:selectedCountryCode,
                self.lang.phn_Num:"",
                self.lang.curren_Title:selectedCurrency,
                self.lang.rount_Num:"",
                self.lang.ssn4_Tit:"",
                self.lang.acc_NumTit:"",
                self.lang.acc_HoldName:"",
                self.lang.add1_Val:"",
                self.lang.address2_Title:"",
                self.lang.city_Title:"",
                self.lang.stat_Prov:"",
                self.lang.postal_Title:""
            ]
            
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            
            stripeTitleArray = [self.lang.country_Title,self.lang.phn_Num,self.lang.curren_Title,self.lang.rount_Num,self.lang.ssn4_Tit,self.lang.acc_NumTit,self.lang.acc_HoldName,self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]

        }
        else if selectedCountry == "Singapore" {
            
            var tempDict = [self.lang.country_Title:selectedCountryCode,self.lang.phn_Num:"",self.lang.curren_Title:selectedCurrency,self.lang.bank_Cd:"",self.lang.brnch_Tit:"",self.lang.acc_NumTit:"",self.lang.acc_HoldName:"",self.lang.add1_Val:"",self.lang.address2_Title:"",self.lang.city_Title:"",self.lang.stat_Prov:"",self.lang.postal_Title:""]
            
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            
            stripeTitleArray = [self.lang.country_Title,self.lang.phn_Num,self.lang.curren_Title,self.lang.bnk_Code,self.lang.brnch_Tit,self.lang.acc_NumTit,self.lang.acc_HoldName,self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]

            
        }
        else if selectedCountry == "United Kingdom" {
            
            var tempDict = [self.lang.country_Title:selectedCountryCode,self.lang.phn_Num:"",self.lang.curren_Title:selectedCurrency,self.lang.srtcd_Tit:"",self.lang.acc_NumTit:"",self.lang.acc_HoldName:"",self.lang.add1_Val:"",self.lang.address2_Title:"",self.lang.city_Title:"",self.lang.stat_Prov:"",self.lang.postal_Title:""]
            
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            stripeTitleArray = [self.lang.country_Title,self.lang.phn_Num,self.lang.curren_Title,self.lang.srtcd_Tit,self.lang.acc_NumTit,self.lang.acc_HoldName,self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]
        }
        else if selectedCountry == "Hong Kong" {
            
            var tempDict = [self.lang.country_Title:selectedCountryCode,self.lang.phn_Num:"",self.lang.curren_Title:selectedCurrency,self.lang.clrcod_Tit:"",self.lang.brnch_Tit:"",self.lang.acc_NumTit:"",self.lang.acc_HoldName:"",self.lang.add1_Val:"",self.lang.address2_Title:"",self.lang.city_Title:"",self.lang.stat_Prov:"",self.lang.postal_Title:""]
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            stripeTitleArray = [self.lang.country_Title,self.lang.phn_Num,self.lang.curren_Title,self.lang.clrcod_Tit,self.lang.brnch_Tit,self.lang.acc_NumTit,self.lang.acc_HoldName,self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]
        }
        else if selectedCountry == "Japan" {
            var tempDict = [self.lang.country_Title:selectedCountryCode,self.lang.phn_Num:"",self.lang.curren_Title:selectedCurrency,self.lang.bnk_namme:"",self.lang.brnch_Nam:"",self.lang.bank_Cd:"",self.lang.brnch_Tit:"",self.lang.acc_NumTit:"",self.lang.acc_OwnName:"",self.lang.phn_Num:"",self.lang.acc_HoldName:"",self.lang.gender_Tit:selectedGender,self.lang.add1_Val:"",self.lang.address2_Title:"",self.lang.city_Title:"",self.lang.stat_Prov:"",self.lang.postal_Title:"","KanaAddress1":"","KanaAddress2":"","KanaCity":"","KanaState / Province":"","KanaPostal Code":""]
            
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            stripeTitleArray = [self.lang.country_Title,self.lang.phn_Num,self.lang.curren_Title,self.lang.bnk_namme,self.lang.brnch_Tit,self.lang.bnk_Code,self.lang.brnch_Tit,self.lang.acc_NumTit,self.lang.acc_OwnNa,self.lang.phn_Num,self.lang.acc_HoldName,self.lang.gender_Tit]
            AddressKana = [self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
            AddressKanji = ["KanaAddress1","KanaAddress2","KanaCity","KanaState / Province","KanaPostal Code"]
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]
            
        }
        else{
            //remaing countrys
            
            var tempDict = [self.lang.country_Title:"",self.lang.phn_Num:"",self.lang.curren_Title:selectedCurrency,self.lang.iban_Num:"",self.lang.acc_HoldName:"",self.lang.add1_Val:"",self.lang.address2_Title:"",self.lang.city_Title:"",self.lang.stat_Prov:"",self.lang.postal_Title:""]
            for key in tempDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    tempDict[key] = stripeArrayDataDict[key]
                }
            }
            stripeArrayDataDict = tempDict
            
            stripeTitleArray = [self.lang.country_Title,self.lang.phn_Num,self.lang.curren_Title,self.lang.iban_Num,self.lang.acc_HoldName,self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
            let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
            curencypicker = (listModel?.currency_code) as! [String]
        }
        stripTableView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
   // MARK: TABLE VIEW DELEGATE AND DATA SOURCE ADDED
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedCountry == "Japan"{
            return 4
        }
        else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if countryNamepicker.count != 0 {
            if selectedCountry == "Japan"{
                return section == 0 ? stripeTitleArray.count : section == 1 ? AddressKana.count : section == 2 ? AddressKanji.count : 2
            }
            else{
                return section == 0 ? stripeArrayDataDict.count : 2
            }
        }
        else{
           return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (stripTableView.frame.size.width) ,height: 40)
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:20, width: viewHolder.frame.size.width ,height: 40)
        if selectedCountry == "Japan"{
            if section == 0
            {
                lblRoomName.text = "Stripe Details"
            }
            else if section == 1
            {
                lblRoomName.text = "Address Kana"
            }
            else if section == 2
            {
                lblRoomName.text = "Address Kanji"
            }
            else
            {
                lblRoomName.text = ""
            }
        }
        else{
            lblRoomName.text = self.lang.strip_Det

            if section == 0
            {
                lblRoomName.text = self.lang.strip_Det
            }
            else
            {
                lblRoomName.text = ""
            }
        }
        lblRoomName.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 15)
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedCountry == "Japan"{
            if indexPath.section==0{
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
                cell.txtPayouts?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.lblDetails?.text = stripeTitleArray[indexPath.row]
                cell.txtPayouts?.delegate = self
                cell.btnDetails?.tag = indexPath.row
                cell.additionalTitle.isHidden = true
                cell.lblDetails?.isHidden = false
                cell.btnDetails?.isHidden = (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 11) ? false : true
                cell.btnDetails?.addTarget(self, action: #selector(self.onTableRowTapped), for: UIControl.Event.touchUpInside)
                if indexPath.row == 0 {
                    cell.txtPayouts?.text = selectedCountry
                }
                else{
                    cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
                }
                return cell
            }
            else if indexPath.section==1{
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
                cell.txtPayouts?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.lblDetails?.text = AddressKana[indexPath.row] as String
                cell.additionalTitle.isHidden = true
                
                cell.lblDetails?.isHidden = false
                cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
                cell.btnDetails?.isHidden = true
                return cell
            }
            else if indexPath.section==2{
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
                let title = [self.lang.add1_Val,self.lang.address2_Title,self.lang.city_Title,self.lang.stat_Prov,self.lang.postal_Title]
                cell.additionalTitle.isHidden = false
                cell.txtPayouts?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.lblDetails?.isHidden = true
                cell.lblDetails?.text = AddressKanji[indexPath.row] as String
                cell.additionalTitle?.text = title[indexPath.row] as String
                cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
                cell.btnDetails?.isHidden = true
                return cell
            }
            else{
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "legalCellTVC") as! legalCellTVC
                cell.choosecamerabutton.addTarget(self, action: #selector(self.openPhotoAccess), for: UIControl.Event.touchUpInside)
                cell.updateimgNameLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                
                if indexPath.row ==  0 {
                    cell.legal_Doc.text = self.lang.legal_Doc
                    cell.updateimgNameLabel.text = legalImgName
                }
                else {
                    cell.legal_Doc.text = self.lang.additional_Doc
                    cell.updateimgNameLabel.text = additionalImgName
                }
                
                return cell
            }
        }
        else{
            if indexPath.section==0{
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
//                guard stripeTitleArray.count > indexPath.row else{
//                    return cell
//                }
                cell.lblDetails?.text = stripeTitleArray[indexPath.row]
                cell.btnDetails?.tag = indexPath.row
                cell.additionalTitle.isHidden = true
                cell.txtPayouts?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.lblDetails?.isHidden = false
                cell.btnDetails?.isHidden = (indexPath.row == 0 || indexPath.row == 2) ? false : true
                cell.btnDetails?.addTarget(self, action: #selector(self.onTableRowTapped), for: UIControl.Event.touchUpInside)
                cell.txtPayouts?.delegate = self
                if indexPath.row == 0 {
                    cell.txtPayouts?.text = selectedCountry
                }
                else{
                    cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
                }
                return cell
            }
            else{
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "legalCellTVC") as! legalCellTVC
                cell.choosecamerabutton.addTarget(self, action: #selector(self.openPhotoAccess), for: UIControl.Event.touchUpInside)
                cell.updateimgNameLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                cell.legal_Doc.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                if indexPath.row ==  0 {
                    cell.legal_Doc.text = self.lang.legal_Doc
                    cell.updateimgNameLabel.text = legalImgName
                }
                else {
                    cell.legal_Doc.text = self.lang.additional_Doc
                    cell.updateimgNameLabel.text = additionalImgName
                }
                
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK:- TEXT DELEGATE METHOD

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cell: StripeCell = textField.superview!.superview as! StripeCell
        if string.count > 0 {
            stripeArrayDataDict[(cell.lblDetails?.text)!] = textField.text! + string
        }
        else{
            stripeArrayDataDict[(cell.lblDetails?.text)!] = string
        }
        return true
    }
    
    func getCountryName()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ADD_STRIPE_PAYOUT as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let proModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if proModel.status_code == "1"
                {
                    self.countryDicts.addObjects(from: (proModel.arrTemp1 as NSArray) as! [Any])
                    for i in 0 ..< self.countryDicts.count{
                        let listModel = self.countryDicts[i] as? PayoutPerferenceModel
                        self.countryNamepicker.append((listModel?.country_name as? String)!)
                        self.countryCodepicker.append((listModel?.country_code as? String)!)
                    }
                }
                else
                {
                    if proModel.success_message == "token_invalid" || proModel.success_message == "user_not_found" || proModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }

                }
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                self.stripTableView.reloadData()
                self.pickerView.reloadAllComponents()
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    @IBAction func onTableRowTapped(_ sender:UIButton!)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        selectedCell = stripTableView.cellForRow(at: indexPath) as! StripeCell
        if sender.tag==0
        {
            self.view.endEditing(true)
            
            type = "country"
            pickerHolder.isHidden = false
            pickerView?.reloadAllComponents()
            
            if stripeArrayDataDict[self.lang.country_Title]?.count == 0 {
                stripeArrayDataDict[self.lang.country_Title] = countryCodepicker[0]
                pickerView?.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                pickerView?.selectRow(countryCodepicker.index(of: stripeArrayDataDict[self.lang.country_Title]!)!, inComponent: 0, animated: true)
            }
            stripeArrayDataDict[self.lang.curren_Title] = ""
        }
        
        else if sender.tag==2
        {
            guard (stripeArrayDataDict[self.lang.country_Title]?.count)! > 0 else {
                return
            }
            
            
            self.view.endEditing(true)
            if (curencypicker.count == 0){
                pickerHolder.isHidden = true
                return
            }
            type = "currency"
            pickerHolder.isHidden = false
            pickerView?.reloadAllComponents()
            if stripeArrayDataDict[self.lang.curren_Title]?.count == 0 {
                stripeArrayDataDict[self.lang.curren_Title] = curencypicker[0]
                pickerView?.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                pickerView?.selectRow(curencypicker.index(of: stripeArrayDataDict[self.lang.curren_Title]!)!, inComponent: 0, animated: true)
            }
        }
        else if sender.tag==11 // japan only
        {
            guard (stripeArrayDataDict[self.lang.country_Title]?.count)! > 0 else {
                return
            }
            
            self.view.endEditing(true)
            type = "gender"
            pickerHolder.isHidden = false
            pickerView?.reloadAllComponents()
            if stripeArrayDataDict[self.lang.gender_Tit]?.count == 0 {
                stripeArrayDataDict[self.lang.gender_Tit] = genderPicker[0]
                pickerView?.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                pickerView?.selectRow(genderPicker.index(of: stripeArrayDataDict[self.lang.gender_Tit]!)!, inComponent: 0, animated: true)
            }
        }
        else
        {
            selectedCell.txtPayouts?.inputView = nil
            selectedCell.txtPayouts?.keyboardType = (sender.tag==4) ? UIKeyboardType.asciiCapable : UIKeyboardType.asciiCapable
            pickerHolder.isHidden = true
            selectedCell.txtPayouts?.becomeFirstResponder()
        }
    }
    
    //MARK: PICKER VIEW DELEGATE AND DATA SOURCE
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if type == "currency"  {
            return curencypicker.count
        }
        else if type == "gender"{
            return genderPicker.count
        }
        else{
            return countryNamepicker.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        var modelTemp = ""
        if type == "currency" {
            modelTemp = curencypicker[row]
        }
        else if type == "country"{
            modelTemp = countryNamepicker[row]
        }
        else if type == "gender"{
            modelTemp = genderPicker[row]
        }
        attributedString = NSAttributedString(string: modelTemp, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor(red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)]))
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if type == "currency" {
            let modelTemp = curencypicker[row]
            selectedCurrency = modelTemp
            stripeArrayDataDict[self.lang.curren_Title] = modelTemp
        }
        else if type == "gender" {
            let modelTemp = genderPicker[row]
            selectedGender = modelTemp
            stripeArrayDataDict[self.lang.gender_Tit] = modelTemp
        }
        else{
            let modelTemp = countryNamepicker[row]
            let modele = countryCodepicker[row]
            selectedCountry = modelTemp 
            selectedCountryCode = modele 
            stripeArrayDataDict[self.lang.country_Title] = modele
            pickerCloseButtonOutlet.tag = row
        }
        
    }

    @objc func openPhotoAccess(sender: UIButton){
        self.view.endEditing(true)
        let buttonPosition:CGPoint = sender.convert(.zero, to:self.stripTableView)
        let indexPath = self.stripTableView.indexPathForRow(at: buttonPosition)
        isLegalSelected = indexPath?.row == 0
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: self.lang.cancel_Title, destructiveButtonTitle: nil, otherButtonTitles: self.lang.takephoto_Title, self.lang.choosephoto_Title)
        actionSheet.show(in: self.view)
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            self.takePhoto()
        }
        else if buttonIndex == 2
        {
            self.choosePhoto()
        }
    }
    
    func takePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let settingsActionSheet: UIAlertController = UIAlertController(title:self.lang.error_Title, message:self.lang.nocam_Error, preferredStyle:UIAlertController.Style.alert)
            settingsActionSheet.addAction(UIAlertAction(title:self.lang.ok_Title, style:UIAlertAction.Style.cancel, handler:nil))
            present(settingsActionSheet, animated:true, completion:nil)
        }
        
    }
    
    func choosePhoto()
    {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            
        }
        
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) != nil {
            let pickedImageEdited: UIImage? = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage)
            imagetopost = pickedImageEdited ?? UIImage()
            let imageData:NSData = pickedImageEdited!.pngData()! as NSData
            //.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            if isLegalSelected {
                legalImage = imageData
                legalImgName = "IMG_\(hour)\(minutes)\(seconds).png"
            }
            else {
                additionalImage = imageData
                additionalImgName = "IMG_\(hour)\(minutes)\(seconds).png"
            }
            
            stripTableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
            for key in stripeArrayDataDict {
                if "\(key.key)" != self.lang.address2_Title ||  "\(key.key)" != "Address 2"{
                    if (stripeArrayDataDict["\(key.key)"]?.count == 0) || stripeArrayDataDict["\(key.key)"] == nil  {
                        appDelegate.createToastMessage("\(self.lang.pls_Ent) \(key.key)", isSuccess: false)
                        return
                    }
                }
            }
         var genderVal = ""
         genderVal = checkNilValue(value:stripeArrayDataDict[self.lang.gender_Tit])
         genderVal = genderVal.lowercased()
        print(genderVal)
        let tokenDict = ["country" :  checkNilValue(value:stripeArrayDataDict[self.lang.country_Title]),
                         "phone_number" : checkNilValue(value:stripeArrayDataDict[self.lang.phn_Num]),
                         "currency" : checkNilValue(value:stripeArrayDataDict[self.lang.curren_Title]),
                         "iban" : checkNilValue(value:stripeArrayDataDict[self.lang.iban_Num]),
                         "bsb" : checkNilValue(value:stripeArrayDataDict[self.lang.bankst_Tit]),
                         "ssn_last_4" : checkNilValue(value:stripeArrayDataDict[self.lang.ssn4_Tit]),
                         "sort_code" : checkNilValue(value:stripeArrayDataDict[self.lang.srtcd_Tit]),
                         "clearing_code" : checkNilValue(value:stripeArrayDataDict[self.lang.clrcod_Tit]),
                         "transit_number" : checkNilValue(value:stripeArrayDataDict[self.lang.trnas_Num]),
                         "institution_number": checkNilValue(value:stripeArrayDataDict[self.lang.intnum_Tit]),
                         "account_number" : checkNilValue(value:stripeArrayDataDict[self.lang.acc_NumTit]),
                         "routing_number": checkNilValue(value:stripeArrayDataDict[self.lang.rount_Num]),
                         "bank_name" : checkNilValue(value:stripeArrayDataDict[self.lang.bnk_namme]),
                         "branch_name": checkNilValue(value:stripeArrayDataDict[self.lang.brnch_Nam]),
                         "bank_code" : checkNilValue(value:stripeArrayDataDict[self.lang.bank_Cd]),
                         "branch_code": checkNilValue(value:stripeArrayDataDict[self.lang.brnch_Tit]),
                         "account_holder_name" : checkNilValue(value:stripeArrayDataDict[self.lang.acc_HoldName]),
                         "account_owner_name" : checkNilValue(value:stripeArrayDataDict[self.lang.acc_OwnName]),
                         "address1" : checkNilValue(value:stripeArrayDataDict[self.lang.add1_Val]),
                         "address2" : checkNilValue(value:stripeArrayDataDict[self.lang.address2_Title]),
                         "city" : checkNilValue(value:stripeArrayDataDict[self.lang.city_Title]),
                         "state" : checkNilValue(value:stripeArrayDataDict[self.lang.stat_Prov]),
                         "postal_code" : checkNilValue(value:stripeArrayDataDict[self.lang.postal_Title]),
                         "kanji_address1" : checkNilValue(value:stripeArrayDataDict["KanaAddress1"]),
                         "kanji_address2" : checkNilValue(value:stripeArrayDataDict["KanaAddress2"]),
                         "kanji_city" : checkNilValue(value:stripeArrayDataDict["KanaCity"]),
                         "kanji_state" : checkNilValue(value:stripeArrayDataDict["KanaState / Province"]),
                         "kanji_postal_code" : checkNilValue(value:stripeArrayDataDict["KanaPostal Code"]),
                         "payout_method" : "stripe",
                         "gender" : genderVal,
                         "language":self.rawVal,
                         "token" : Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)] as [String : Any]
            if legalImgName != "" && additionalImgName != "" {
                self.callApiUpdate(requestParams:tokenDict)
            }
            else{
                if legalImgName == "" {
                    appDelegate.createToastMessage(self.lang.updatlegal_Error, isSuccess: false)
                }
                else if additionalImgName == "" {
                        appDelegate.createToastMessage(self.lang.updatAddition_Error, isSuccess: false)
                    }
                }
                
            }
    
        //"document" : updateimg,
    
    func checkNilValue(value:String?) -> String {
        if value == nil {
            return ""
        }
        else {
            return value!
        }
    }
    func callApiUpdate(requestParams: [String:Any]) {
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        //var imageData = NSData()
//        requestParams += ["language"]
        print("Params:",requestParams)
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                multipartFormData.append(self.legalImage as Data, withName: "document", fileName: "document.png", mimeType: "image/png")
                multipartFormData.append(self.additionalImage as Data, withName: "additional_document", fileName: "additional_document.png", mimeType: "image/png")
               
                //multipartFormData.append(self.updateimg as Data, withName: "document", mimeType: "document/png")
                    //.append(updateimg, withName: "document", fileName: "file.png", mimeType: "image/png")
                for (key, value) in requestParams
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        }, to:k_APIServerUrl+"add_payout_perference",headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                upload.responseJSON
                    { response in
                        
                        print(response.result)
                        print(response.value)
                        if response.result.value != nil
                        {
                            let dict :NSDictionary = response.result.value! as! NSDictionary
                            let status = dict.value(forKey: "status_code")as! String
                            let msg = dict.value(forKey: "success_message") as! String
                            if status=="1"
                            {
                                print("DATA UPLOAD SUCCESSFULLY")
                                MakentSupport().removeProgressInWindow(viewCtrl: self)
                                self.delegate?.payoutStripeAdded()
                                self.navigationController!.popViewController(animated: true)
                            }else if status=="0"{
                                 self.appDelegate.createToastMessage(msg, isSuccess: false)
                                 MakentSupport().removeProgressInWindow(viewCtrl: self)
                            }
                        }
                }
            case .failure(let encodingError):
                break
            }
        }
//        WebServiceHandler.sharedInstance.getWebServicePayout(wsMethod:"add_payout_perference", paramDict: requestParams, viewController:self, isToShowProgress:true, isToStopInteraction:true) { (response) in
//            let responseJson = response
//            DispatchQueue.main.async {
//                if responseJson["status_code"] as! String == "1" {
//                    MakentSupport().removeProgressInWindow(viewCtrl: self)
//                    self.delegate?.payoutStripeAdded()
//                    self.navigationController!.popViewController(animated: true)
//                }
//                else {
////                    MakentSupport().removeProgressInWindow(viewCtrl: self)
//                    self.appDelegate.createToastMessage(responseJson["success_message"] as! String, isSuccess: false)
//
//                }
//
//            }
//        }
        
    }
}
class legalCellTVC :UITableViewCell{
    
    @IBOutlet weak var updateimgNameLabel: UILabel!
    @IBOutlet weak var choosecamerabutton: UIButton!
   
    @IBOutlet weak var legal_Doc: UILabel!
}
class StripeCell : UITableViewCell {
    @IBOutlet var txtPayouts: UITextField?
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var btnDetails: UIButton?
    @IBOutlet weak var additionalTitle: UILabel!
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
