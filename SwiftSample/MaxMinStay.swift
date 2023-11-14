/**
* MaxMinStay.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class MaxMinStay : UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var nights1: UILabel!
    
    @IBOutlet weak var nights2: UILabel!
    @IBOutlet var tblMaxMinStay : UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var minTxtFld: UITextField!
    @IBOutlet weak var maxTxtFld: UITextField!
    
    @IBOutlet weak var addreqMsg: UILabel!
    @IBOutlet weak var minmax_Titt: UILabel!
    
    @IBOutlet weak var maxStay: UIButton!
    @IBOutlet weak var minStay: UIButton!
    
    @IBOutlet weak var back_Btn: UIButton!
    
    @IBOutlet weak var frwd_Lbl: UILabel!
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var roomid = ""
    var listModel : ListingModel!
    var arrNightData : NSArray!
    var arrTemp = [String]()
    var arrStartTemp = [String]()
    var arrEndTemp = [String]()
    var count:Int = 1
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    @IBOutlet weak var don_btn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        back_Btn.appHostTextColor()
        don_btn.appHostTextColor()
        frwd_Lbl.appHostTextColor()
        
        minTxtFld.resignFirstResponder()//maxTxtFld
        minTxtFld.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        maxTxtFld.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        don_btn.isHidden = true
        self.back_Btn.transform = self.getAffine
        self.frwd_Lbl.transform = self.getAffine
        self.minStay.setTitle(self.lang.min_Stay, for: .normal)
        self.maxStay.setTitle(self.lang.max_Stay, for: .normal)
        self.minmax_Titt.text = self.lang.minmax_Title
        self.nights1.text = self.lang.nights_Title
        self.nights2.text = self.lang.nights_Title
        self.addreqMsg.text = self.lang.req_Msg

//
        self.navigationController?.isNavigationBarHidden = true
         don_btn.setTitle(self.lang.done_Title, for: .normal)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MaxMinStay.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func checkbuttonStatus() {
        if minTxtFld.text != "" || maxTxtFld.text != "" {
            don_btn.isHidden = false
        }
        else{
            don_btn.isHidden = true
        }
    }
    
    @IBAction func customAction(_ sender: Any) {
        let checkInView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "CustomMinMaxVC") as! CustomMinMaxVC
        checkInView.listModel = listModel
        if arrTemp.count != 0 {
            checkInView.arrTemp = self.arrTemp
            checkInView.arrStartTemp = self.arrStartTemp
            checkInView.arrEndTemp = self.arrEndTemp
        }
        checkInView.roomid = self.listModel.room_id as String
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(checkInView, animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if count == 1 {
            self.getRoomPropertyType()
        }
        super.viewWillAppear(animated)
        if listModel.minimum_stay != "0" || listModel.maximum_stay != "0" {
            minTxtFld.text = listModel.minimum_stay as String
            maxTxtFld.text = listModel.maximum_stay as String
        }
        else{
            minTxtFld.text = ""
            maxTxtFld.text = ""

        }
        self.navigationController?.isNavigationBarHidden = true

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
                    if self.count != 1{
                        propertyData.arrTemp5.removeAllObjects()
                    }
                    self.arrNightData = propertyData.arrTemp5
                    for i in 0..<self.arrNightData.count {
                        let modelTemp = self.arrNightData[i] as? RoomPropertyModel
                        self.arrTemp.append(modelTemp?.res_text as! String)
                        self.arrStartTemp.append(modelTemp?.start_date as! String)
                        self.arrEndTemp.append(modelTemp?.end_date as! String)
                    }
                    self.arrTemp.append(self.lang.cus_Tit)
                    self.arrStartTemp.append("")
                    self.arrEndTemp.append("")
                    self.count += 1

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
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.checkbuttonStatus()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let length: Int = currentString?.count ?? 0
        if length > 5 {
            return false
        }
        return true
    }
    
    
    //MARK:  Table view Detegate and data source handling
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let lengthModel = listModel.availability_rules[indexPath.row] as? RoomDetailModel
        if lengthModel?.maximumstay != ""  &&  lengthModel?.minimumstay != "" {
            return 110
        }
        else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listModel.availability_rules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell:CellAdditionalStay = tblMaxMinStay.dequeueReusableCell(withIdentifier: "CellAdditionalStay")! as! CellAdditionalStay
        cell.deletebutton.deleted(.appHostThemeColor)
            let lengthModel = listModel.availability_rules[indexPath.row] as? RoomDetailModel
            cell.duringlbl?.text = "\(self.lang.during_Title) \(lengthModel?.during as! String)"
        if lengthModel?.maximumstay != ""  &&  lengthModel?.minimumstay != ""{
            cell.mininumlbl?.text = "\(self.lang.guestmin_Title) \(lengthModel?.minimumstay as! String) \(self.lang.nights_Title)"
            cell.maxinumlbl?.text = "\(self.lang.guestmax_Title) \(lengthModel?.maximumstay as! String) \(self.lang.nights_Title)"
        }
        else if lengthModel?.minimumstay != "" && lengthModel?.maximumstay == ""{
            cell.mininumlbl?.text = "\(self.lang.guestmin_Title) \(lengthModel?.minimumstay as! String) \(self.lang.nights_Title)"
            cell.maxinumlbl?.isHidden = true
        }
        else if lengthModel?.maximumstay != ""  && lengthModel?.minimumstay == ""{
            cell.mininumlbl?.text = "\(self.lang.guestmax_Title)\(lengthModel?.maximumstay as! String) \(self.lang.nights_Title)"
            cell.maxinumlbl?.isHidden = true
        }
            let id:Int = Int((lengthModel?.id as? String)!)!
            cell.deletebutton.tag = id
            cell.deletebutton.addTarget(self, action: #selector(self.deleteButtonAction), for: UIControl.Event.touchUpInside)
        
            let min = lengthModel?.minimumstay as! String
            let max = lengthModel?.maximumstay as! String
            let start = lengthModel?.start_date_formatted as! String
            let end = lengthModel?.end_date_formatted as! String
            let type = lengthModel?.type as! String
            let during = lengthModel?.during as! String
        
            cell.editbutton.titleLabel?.text = "\(min),\(max),\(start),\(end),\(type),\(during)"
            cell.editbutton.tag = id
            cell.editbutton.addTarget(self, action: #selector(self.editButtonAction), for: UIControl.Event.touchUpInside)

        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
       // my custom colour

       
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
    }
    //
    //MARK: Back Action
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        let optionalView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "OptionalDetailVC") as! OptionalDetailVC
        optionalView.strRoomId = listModel.room_id as String
        optionalView.listModel = self.listModel
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(optionalView, animated: false)

    }

    @objc func editButtonAction(sender:UIButton)
    {
        let editid = String(sender.tag)
        let testString = "\(sender.titleLabel?.text!)"
        let textTit = testString.replacingOccurrences(of: "Optional(", with: "")
        let textTit1 = textTit.replacingOccurrences(of: ")", with: "")
        let text1 = textTit1.replacingOccurrences(of: "\"", with: "")
        let fullNameArr = text1.components(separatedBy: ",")
        let min    = fullNameArr[0]
        let max = fullNameArr[1]
        let start = fullNameArr[2]
        let end = fullNameArr[3]
        let type = fullNameArr[4]
        let during = fullNameArr[5]
        let checkInView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "CustomMinMaxVC") as! CustomMinMaxVC
        checkInView.listModel = listModel
        checkInView.ifedittype = "edit"
        checkInView.selectedID = editid
        checkInView.type = type
        checkInView.start_date = start
        checkInView.end_date = end
        checkInView.minVal = min
        checkInView.maxVal = max
        checkInView.buttonType = during
        checkInView.roomid = self.listModel.room_id as String
        if arrTemp.count != 0 {
            checkInView.arrTemp = self.arrTemp
            checkInView.arrStartTemp = self.arrStartTemp
            checkInView.arrEndTemp = self.arrEndTemp
        }
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(checkInView, animated: true)

    }
    @objc func deleteButtonAction(sender:UIButton) {
        
        let deleteid = String(sender.tag)
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["id"]   = deleteid
        dicts["room_id"] = listModel.room_id
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_DELETE_AVAILABILITY_RULE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let proModel = response as! RoomDetailModel
            OperationQueue.main.addOperation {
                if proModel.status_code == "1"
                {
                    self.listModel.availability_rules.removeAllObjects()
                    self.listModel.availability_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                    self.tblMaxMinStay.reloadData()
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
                
            }
            MakentSupport().removeProgressInWindow(viewCtrl: self)
            
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        //if minTxtFld.text != "" && maxTxtFld.text != "" {
            if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
            {
                return
            }
            MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
            var dicts = [AnyHashable: Any]()
            dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
            dicts["room_id"] = self.listModel.room_id as String
            dicts["minimum_stay"] = minTxtFld.text!
            dicts["maximum_stay"] = maxTxtFld.text!
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_MIN_MAX_STAY as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
                let proModel = response as! GeneralModel
                OperationQueue.main.addOperation {
                    if proModel.status_code == "1"
                    {
                        MakentSupport().removeProgressInWindow(viewCtrl: self)
                        self.listModel.minimum_stay = self.minTxtFld.text! as NSString
                        self.listModel.maximum_stay = self.maxTxtFld.text! as NSString
                        self.navigationController!.popViewController(animated: true)
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
//        }
//        else if minTxtFld.text == ""{
//            let msg = "Please enter the minimum stay field"
//            self.appDelegate.createToastMessage(msg, isSuccess: false)
//        }
//        else if maxTxtFld.text == ""{
//            let msg = "Please enter the maximum stay field"
//            self.appDelegate.createToastMessage(msg, isSuccess: false)
//        }
        
    }
    
    
}

class CellMaxMinStay: UITableViewCell
{
    @IBOutlet var btnWeeklyPrice: UIButton?
    @IBOutlet var btnMonthlyPrice: UIButton?

    @IBOutlet var txtFldWeekPrice : UITextField?
    @IBOutlet var txtFldMonthPrice : UITextField?

    
    @IBAction func onWeeklyPriceTapped(_ sender:UIButton!)
    {
        txtFldWeekPrice?.becomeFirstResponder()
    }

    @IBAction func onMonthlyPrice(_ sender:UIButton!)
    {
        txtFldMonthPrice?.becomeFirstResponder()
    }

}
class CellAdditionalStay: UITableViewCell
{
    @IBOutlet var duringlbl: UILabel?
    @IBOutlet var maxinumlbl: UILabel?
    @IBOutlet var mininumlbl: UILabel?
    @IBOutlet weak var deletebutton: UIButton!
    @IBOutlet weak var editbutton: UIButton!
    
}


