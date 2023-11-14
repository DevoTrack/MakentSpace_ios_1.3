//
//  CustomMinMaxVC.swift
//  Makent
//
//  Created by Trioangle on 09/07/18.
//  Copyright © 2018 Mani kandan. All rights reserved.
//

import UIKit

class CustomMinMaxVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var minmaxView: UIView!
    @IBOutlet weak var selectDateView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pickerHolder: UIPickerView!
    @IBOutlet weak var selectNightButton: UIButton!
    @IBOutlet weak var startDateTxtfld: UITextField!
    @IBOutlet weak var endDateTxtFld: UITextField!
    @IBOutlet weak var maxTxtFld: UITextField!
    @IBOutlet weak var minTxtFld: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet weak var reserveset_title: UILabel!
    @IBOutlet weak var nights2_lbl: UILabel!
    @IBOutlet weak var nights1_Lbl: UILabel!
    @IBOutlet weak var stdat_Lbl: UILabel!
//    @IBOutlet weak var select_Dat: UIButton!
    @IBOutlet weak var cls_btn: UIButton!
    @IBOutlet weak var enddat_Lbl: UILabel!
    @IBOutlet weak var maxsty_Btn: UIButton!
    @IBOutlet weak var minsty_Btn: UIButton!
    
    var listModel : ListingModel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var SelectedType = ""
    var roomid = ""
    var type = ""
    var buttonType = ""
    var ifedittype = ""
    var start_date = ""
    var end_date  = ""
    var selectedID = ""
    var minVal = ""
    var maxVal = ""
    var arrTemp = [String]()
    var arrStartTemp = [String]()
    var arrEndTemp = [String]()
    let datePicker = UIDatePicker()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ifedittype == "edit"{
            selectNightButton.setTitle(buttonType, for: .normal)
            SelectedType = buttonType
        }
        self.maxTxtFld.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.minTxtFld.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.nights1_Lbl.text = self.lang.nights_Title
        self.nights2_lbl.text = self.lang.nights_Title
        self.reserveset_title.text = self.lang.reser_Sett
        self.doneBtn.setTitle(self.lang.done_Title, for: .normal)
        self.back_Btn.transform = self.getAffine
        self.selectNightButton.setTitle(self.lang.sel_Dat, for: .normal)
        self.startDateTxtfld.placeholder = self.lang.ent_Sdt
        self.endDateTxtFld.placeholder = self.lang.ent_Edt
        self.stdat_Lbl.text = self.lang.strtdat_Title
        self.enddat_Lbl.text = self.lang.enddat_Title
        self.cls_btn.setTitle(self.lang.close_Tit, for: .normal)
        self.minsty_Btn.setTitle(self.lang.min_Stay, for: .normal)
        self.maxsty_Btn.setTitle(self.lang.max_Stay, for: .normal)
        startDateTxtfld.delegate = self
        endDateTxtFld.delegate = self
        minTxtFld.delegate = self
        maxTxtFld.delegate = self
        let screensize = UIScreen.main.bounds
        let screenwidth = screensize.width
        let screenhight = screensize.height
        if screenhight == 568 {
            mainScrollView.contentSize =  CGSize(width: screenwidth, height: screenhight+150)
        }
        else{
            mainScrollView.contentSize =  CGSize(width: screenwidth, height: screenhight+50)
        }
        pickerHolder.dataSource  = self
        pickerHolder.delegate = self
        pickerView.isHidden = true
        selectDateView.isHidden = false
        minmaxView.isHidden = false
        dateView.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomMinMaxVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        doneBtn.appHostTextColor()
        back_Btn.appHostTextColor()

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        mainScrollView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(0.0)), animated: true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if ifedittype == "edit"{
            maxTxtFld.text = maxVal
            minTxtFld.text = minVal
            if buttonType == "Custom" {
                startDateTxtfld.text = start_date
                endDateTxtFld.text = end_date
                dateView.isHidden = false
                minmaxView.frame = CGRect(x: minmaxView.frame.origin.x, y: (dateView.frame.origin.y+dateView.frame.height+20), width: minmaxView.frame.width, height: minmaxView.frame.height)
            }
            else{
                dateView.isHidden = true
                minmaxView.frame = CGRect(x: 25, y: 95, width: 325, height: 210)
            }
            
        }
        if SelectedType == self.lang.cus_Tit {
            dateView.isHidden = false
            minmaxView.frame = CGRect(x: minmaxView.frame.origin.x, y: (dateView.frame.origin.y+dateView.frame.height+5), width: minmaxView.frame.width, height: minmaxView.frame.height)
        }
        else{
            dateView.isHidden = true
            minmaxView.frame = CGRect(x: 25, y: 95, width: 325, height: 210)
        }
        
    }
    
    @IBAction func selectdateAction(_ sender: Any) {
        view.endEditing(true)
       if pickerView.isHidden == true {
             pickerView.isHidden = false
        }
       else{
              pickerView.isHidden = true
        }
    }
    
    @IBAction func pickerCloseAction(_ sender: Any) {
        pickerView.isHidden = true
    }
    
   
    // Text field delegate method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = true
        if textField == startDateTxtfld  {
                self.showDatePicker()
            }
        else if  textField == endDateTxtFld {
            self.showdatePicker1()
        }
        else if textField == minTxtFld {

            mainScrollView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(150.0)), animated: true)
          
        }
        else if textField == maxTxtFld {
                mainScrollView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(250.0)), animated: true)
        }
       return true
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let length: Int = currentString?.count ?? 0
        if length > 5 {
            return false
        }
        return true
    }
   
    func showDatePicker(){
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: self.lang.done_Title, style: UIBarButtonItem.Style.bordered, target: self, action: #selector(CustomMinMaxVC.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: self.lang.cancel_Title, style: UIBarButtonItem.Style.bordered, target: self, action: #selector(CustomMinMaxVC.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        startDateTxtfld.inputAccessoryView = toolbar
        startDateTxtfld.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        startDateTxtfld.text = formatter.string(from: datePicker.date)
        start_date = startDateTxtfld.text!
        start_date = dtLang(start_date)
        self.view.endEditing(true)
    }
    func showdatePicker1(){
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: self.lang.done_Title, style: UIBarButtonItem.Style.bordered, target: self, action: #selector(CustomMinMaxVC.donedatePicker1))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: self.lang.cancel_Title, style: UIBarButtonItem.Style.bordered, target: self, action: #selector(CustomMinMaxVC.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        endDateTxtFld.inputAccessoryView = toolbar
        endDateTxtFld.inputView = datePicker
        
    }
    
    @objc func donedatePicker1(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        endDateTxtFld.text = formatter.string(from: datePicker.date)
        formatter.locale = Locale.convertEnglish
        end_date = endDateTxtFld.text!
        end_date = dtLang(end_date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    
    //**MARK:-// Following are the delegate and datasource implementation for picker view :
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrTemp.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        var str = ""
        let modelTemp = arrTemp[row] as? String
        attributedString = NSAttributedString(string: modelTemp!, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor(red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)]))
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let modelTemp = arrTemp[row] as? String
        let start = arrStartTemp[row]as? String
        let end = arrEndTemp[row]as? String
        SelectedType = modelTemp! as String
        if start != "" && end != ""{
            start_date = start!
            end_date = end!
        }
        selectNightButton.setTitle(SelectedType, for: .normal)
        viewWillAppear(false)
    }
    
    @IBAction func backAction(_ sender: Any) {
//        let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "MaxMinStay") as! MaxMinStay
//        discountView.listModel = self.listModel
//        self.navigationController?.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(discountView, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func doneAction(_ sender: Any) {
        view.endEditing(true)
        if SelectedType != ""{
            if SelectedType == self.lang.cus_Tit{
                if startDateTxtfld.text != "" && endDateTxtFld.text != "" && (minTxtFld.text != "" || maxTxtFld.text != "") {
                    if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
                    {
                        return
                    }
                    MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
                    var dicts = [AnyHashable: Any]()
                    dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
                    dicts["room_id"] = roomid
                    if ifedittype == "edit"{
                        dicts["id"] = selectedID
                    }
                    else{
                        dicts["id"] = ""
                        
                    }
                    if SelectedType == self.lang.cus_Tit {
                        dicts["type"] = "custom"
                    }
                    else{
                        dicts["type"] = "month"
                    }
                    dicts["minimum_stay"] = minTxtFld.text!
                    dicts["maximum_stay"] = maxTxtFld.text!
                    dicts["start_date"] = start_date
                    dicts["end_date"] = end_date
                    MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_AVAILABILITY_RULE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
                        let proModel = response as! RoomDetailModel
                        OperationQueue.main.addOperation {
                            if proModel.status_code == "1"
                            {
                                self.listModel.availability_rules.removeAllObjects()
                                
                                self.listModel.availability_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                                let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "MaxMinStay") as! MaxMinStay
                                discountView.listModel = self.listModel
                                MakentSupport().removeProgressInWindow(viewCtrl: self)
                                self.navigationController?.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(discountView, animated: false)
                            }
                            else
                            {
                                if proModel.success_message == "token_invalid" || proModel.success_message == "user_not_found" || proModel.success_message == "Authentication Failed"
                                {
                                    self.appDelegate.logOutDidFinish()
                                    return
                                }
                                else{
                                    self.appDelegate.createToastMessage(proModel.success_message as String, isSuccess: false)
                                }
                                
                                
                            }
                        }
                        MakentSupport().removeProgressInWindow(viewCtrl: self)
                        
                    }, andFailureBlock: {(_ error: Error) -> Void in
                        OperationQueue.main.addOperation {
                            MakentSupport().removeProgressInWindow(viewCtrl: self)
                            _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
                        }
                    })
                }
                else if startDateTxtfld.text == ""{
                    appDelegate.createToastMessage(self.lang.choosestdate_Error, isSuccess: false)
                    
                }
                else if endDateTxtFld.text == ""{
                    appDelegate.createToastMessage(self.lang.chooseeddate_Error, isSuccess: false)
                    
                }
                else if minTxtFld.text == "" {
                    appDelegate.createToastMessage(self.lang.minsty_Error, isSuccess: false)
                }
                    
                else if maxTxtFld.text == "" {
                    appDelegate.createToastMessage(self.lang.maxsty_Error, isSuccess: false)
                }
            }
            else{
                if minTxtFld.text != "" || maxTxtFld.text != ""{
                    if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
                    {
                        return
                    }
                    MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
                    var dicts = [AnyHashable: Any]()
                    dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
                    dicts["room_id"] = roomid
                    if ifedittype == "edit"{
                        dicts["id"] = selectedID
                    }
                    else{
                        dicts["id"] = ""
                    }
                    dicts["type"] = "month"
                    dicts["minimum_stay"] = minTxtFld.text!
                    dicts["maximum_stay"] = maxTxtFld.text!
                    dicts["start_date"] = start_date
                    dicts["end_date"] = end_date
                    MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_AVAILABILITY_RULE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
                        let proModel = response as! RoomDetailModel
                        OperationQueue.main.addOperation {
                            if proModel.status_code == "1"
                            {
                                self.listModel.availability_rules.removeAllObjects()
                                
                                self.listModel.availability_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                                let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "MaxMinStay") as! MaxMinStay
                                discountView.listModel = self.listModel
                                MakentSupport().removeProgressInWindow(viewCtrl: self)
                                self.navigationController?.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(discountView, animated: false)
                                
                            }
                            else
                            {
                                if proModel.success_message == "token_invalid" || proModel.success_message == "user_not_found" || proModel.success_message == "Authentication Failed"
                                {
                                    self.appDelegate.logOutDidFinish()
                                    return
                                }
                                else{
                                    self.appDelegate.createToastMessage(proModel.success_message as String, isSuccess: false)
                                }
                                
                                
                            }
                        }
                        MakentSupport().removeProgressInWindow(viewCtrl: self)
                        
                    }, andFailureBlock: {(_ error: Error) -> Void in
                        OperationQueue.main.addOperation {
                            MakentSupport().removeProgressInWindow(viewCtrl: self)
                            _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
                        }
                    })
                }
//                else if minTxtFld.text == "" {
//                    appDelegate.createToastMessage("Please enter minimum stay field", isSuccess: false)
//                }
//                else if maxTxtFld.text == "" {
//                    appDelegate.createToastMessage("Please Enter maximum stay field", isSuccess: false)
//                }
            }
            
        }
        else if SelectedType == ""{
            let msg = self.lang.choose_DtError
            self.appDelegate.createToastMessage(msg, isSuccess: false)
        }
        
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

extension UIViewController{
    func dtLang(_ string:String)->String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.date(from: string)!
        formatter.locale = Locale.convertEnglish
        return formatter.string(from: date)
    }
}
