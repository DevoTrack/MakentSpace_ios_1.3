//
//  EditEarliyDiscountVc.swift
//  Makent
//
//  Created by Trioangle on 23/05/18.
//  Copyright © 2018 Mani kandan. All rights reserved.
//

import UIKit

class EditEarliyDiscountVc: UIViewController,UITextFieldDelegate {

    @IBOutlet var topView: UIView!
    @IBOutlet var addButtonOutlet: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var percentageTxtField: UITextField!
    @IBOutlet var daysTxtField: UITextField!
    
    @IBOutlet weak var percentageBottomView: UIView!
    @IBOutlet weak var daysBottomView: UIView!
    @IBOutlet weak var percen_lbl: UILabel!
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet weak var days_Titl: UILabel!
    var type = ""
    var SelectedID = ""
    var roomid = ""
    var day = ""
    var per = ""
    var listModel : ListingModel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == "1" {
            titleLabel.text = self.lang.earlybird_Disc
        }
        else{
            titleLabel.text = self.lang.lastmin_Disc
        }
        if day != "" && per != "" {
            percentageTxtField.text = per
            daysTxtField.text = day
        }
        percen_lbl.text = self.lang.percen_Sym
        days_Titl.text = self.lang.dayys_Title
        back_Btn.transform = self.getAffine
        back_Btn.appHostTextColor()
        addButtonOutlet.appHostSideBtnBG()
        daysBottomView.backgroundColor = UIColor.appHostThemeColor
        percentageBottomView.backgroundColor = UIColor.appHostThemeColor
        addButtonOutlet.setTitle(self.lang.save_Tit, for: .normal)
        daysTxtField.delegate = self
        addButtonOutlet.layer.cornerRadius = 5
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditEarliyDiscountVc.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
            let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountsPageVC") as! DiscountsPageVC
            discountView.listModel = self.listModel
            if self.type == "1"{
                discountView.type = "2"
            }
            else{
                discountView.type = "3"
            }
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountView, animated: false)
    }
    // Text field delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {       
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if percentageTxtField.text != "" && daysTxtField.text != "" {            
            
            var addType = ""
            if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
            {
                return
            }
            MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
            var dicts = [AnyHashable: Any]()
            dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
            if SelectedID != "" {
                dicts["id"]   = SelectedID
            }
            else{
                dicts["id"]   = ""
            }
            dicts["room_id"] = roomid
            dicts["discount"] = percentageTxtField.text!
            dicts["period"] = daysTxtField.text!
            if self.type == "1"{
                addType = "early_bird"
            }
            else{
                addType = "last_min"
            }
            dicts["type"] = addType
            MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_ADDITIONAL_PRICE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
                let proModel = response as! RoomDetailModel
                OperationQueue.main.addOperation {
                    
                    if proModel.status_code == "1"
                    {
                        let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountsPageVC") as! DiscountsPageVC
                        discountView.listModel = self.listModel
                        if self.type == "1"{
                            self.listModel.early_bird_rules.removeAllObjects()

                            discountView.type = "2"
                            self.listModel.early_bird_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                        }
                        else{
                            self.listModel.last_min_rules.removeAllObjects()
                            discountView.type = "3"
                            self.listModel.last_min_rules.addObjects(from:     (proModel.arrTemp2 as NSArray) as! [Any])
                        }
                        MakentSupport().removeProgressInWindow(viewCtrl: self)
                        self.navigationController?.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(discountView, animated: true)
                        
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
            
        else if percentageTxtField.text == "" {
            let msg = self.lang.discpercent_Err
            self.appDelegate.createToastMessage(msg, isSuccess: false)
            
        }
        else{
            let msg = self.lang.numofnight_Err
            self.appDelegate.createToastMessage(msg, isSuccess: false)
        }
        
    }
    

}
