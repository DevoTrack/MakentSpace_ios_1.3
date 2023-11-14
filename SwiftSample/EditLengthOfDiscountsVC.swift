//
//  EditLengthOfDiscountsVC.swift
//  Makent
//
//  Created by Trioangle on 23/05/18.
//  Copyright © 2018 Mani kandan. All rights reserved.
//

import UIKit

class EditLengthOfDiscountsVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet var topView: UIView!
    @IBOutlet var pickerView: UIView!
    @IBOutlet var selectNightView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var percentageView: UIView!
    @IBOutlet var percentageTxtField: UITextField!
    @IBOutlet var pickerHolder: UIPickerView!
    @IBOutlet var selectedNightLabel: UILabel!
    @IBOutlet var selectNightButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var length_Tit: UILabel!
    @IBOutlet weak var close_Btn: UIButton!
    
    @IBOutlet weak var percentageBottomView: UIView!
    @IBOutlet weak var back_Btn: UIButton!
    
    
    @IBOutlet weak var percen_lbl: UILabel!
    var listModel : ListingModel!
    var roomid = ""
    var SelectedID = ""
    var type = ""
    var SelectedDiscount = ""
    var SelectedPeriod = ""
    var SelectedType = ""
    var day = ""
    var per = ""
    var peried = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrPickerData : NSArray!
    var arrNightData : NSArray!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRoomPropertyType()
        addButton.layer.cornerRadius = 5
        pickerHolder.delegate = self
        pickerHolder.dataSource = self
        percentageTxtField.delegate = self
        self.percen_lbl.text = self.lang.percen_Sym
        self.length_Tit.text = self.lang.staydiscount_Title
        self.selectNightButton.setTitle(self.lang.selnigh_Tit, for: .normal)
        self.selectNightButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine
        back_Btn.appHostTextColor()
        percentageBottomView.appHostViewBGColor()
        addButton.appHostSideBtnBG()
        self.selectedNightLabel.font = UIFont(name: Fonts.MAKENT_LOGO_FONT2, size: 15)
        self.close_Btn.setTitle(self.lang.close_Tit, for: .normal)
        self.addButton.setTitle(self.lang.save_Tit, for: .normal)
//        pickerView.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditLengthOfDiscountsVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if day != "" && per != ""{
            selectNightButton.setTitle(day, for: .normal)
            percentageTxtField.text = per
            SelectedPeriod = peried
        }
    }
    func getRoomPropertyType()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: false)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ROOM_PROPERTY_TYPE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let propertyData = response as! GeneralModel
            OperationQueue.main.addOperation {
                if propertyData.status_code == "1"
                {
                    self.arrNightData = propertyData.arrTemp4
                    self.pickerHolder.reloadAllComponents()
                }
                else
                {
                    if propertyData.success_message == "token_invalid" || propertyData.success_message == "user_not_found" || propertyData.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }
    // Text field delegate method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.pickerView.isHidden = true
        self.view.removeAddedSubview(view: pickerView)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountsPageVC") as! DiscountsPageVC
        discountView.listModel = self.listModel
        discountView.type = "1"
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(discountView, animated: false)
    }
    
    
    @IBAction func selectNightButtonAction(_ sender: Any) {
//        self.pickerView.isHidden = false
        self.view.addFooterView(footerView: pickerView)
        view.endEditing(true)
    }
    
    @IBAction func pickerCloseAction(_ sender: Any) {
//        self.pickerView.isHidden = true
        self.view.removeAddedSubview(view: pickerView)
    }
    
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        if SelectedPeriod != "" && percentageTxtField.text != "" {
            if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
            {
                return
            }
            MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
            var dicts = [AnyHashable: Any]()
            dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
            if type == "edit" {
                dicts["id"]   = SelectedID
            }
            else{
                dicts["id"]   = ""
            }
            dicts["room_id"] = roomid
            dicts["discount"] = percentageTxtField.text!
            dicts["period"] = SelectedPeriod
            dicts["type"] = "length_of_stay"
            MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_ADDITIONAL_PRICE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
                let proModel = response as! RoomDetailModel
                OperationQueue.main.addOperation {
                    if proModel.status_code == "1"
                    {
                        self.listModel.length_of_stay_rules.removeAllObjects()
                        self.listModel.length_of_stay_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                        let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountsPageVC") as! DiscountsPageVC
                        discountView.listModel = self.listModel
                        discountView.type = "1"
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
        else if SelectedPeriod == "" {
            let msg = lang.choosenight_Error
            self.appDelegate.createToastMessage(msg, isSuccess: false)
            
        }
        else{
            let msg = lang.discpercent_Err
            self.appDelegate.createToastMessage(msg, isSuccess: false)
        }
        
        
        
    }
    //**MARK:-// Following are the delegate and datasource implementation for picker view :
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if arrNightData == nil {
            return 0
        }else{
            return arrNightData.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        let modelTemp = arrNightData[row] as? RoomPropertyModel
        let str  = (modelTemp?.len_text)! as String
        attributedString = NSAttributedString(string: str, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor(red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)]))
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let modelTemp = arrNightData[row] as? RoomPropertyModel
        SelectedType = (modelTemp?.len_text)! as String
        SelectedPeriod = (modelTemp?.len_nights)! as String
        selectNightButton.setTitle(SelectedType, for: .normal)
        
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
