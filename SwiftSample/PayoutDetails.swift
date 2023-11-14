/**
* PayoutDetails.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social
import Alamofire

protocol AddPayoutDelegate
{
    func payoutAdded()
}


class PayoutDetails : UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource, ViewOfflineDelegate,UITextFieldDelegate{
    @IBOutlet weak var pay_Titlee: UILabel!
    @IBOutlet weak var cls_Btn: UIButton!
    
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet weak var submit_Btn: UIButton!
    @IBOutlet var tblPayoutDetails : UITableView!
    @IBOutlet var viewFooder: UIView?
    @IBOutlet var pickerView:UIPickerView?
    @IBOutlet var btnSubmit:UIButton?
    @IBOutlet var viewPickerHolder:UIView?
    @IBOutlet var viewEmailHolder:UIView?
    @IBOutlet var txtPayPalEmailID:UITextField?
    var arrCountryData : NSMutableArray = NSMutableArray()
    var arrCountryDataPlist : NSMutableArray = NSMutableArray()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    @IBOutlet weak var payout_Tit: UILabel!
    
    @IBOutlet weak var close_Btn: UIButton!
    var delegate: AddPayoutDelegate?
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrPickerData : NSArray!
    var selectedCell : CellPayoutDetails!
    var filteredCountries : [String] = []
    var currencyList : [String] = []
    
    @IBOutlet weak var emailTxtView: UIView!
    var arrSettingData: [String] = []
    var selectedCurrency = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        tblPayoutDetails.tableFooterView =  viewFooder
     
        self.emailTxtView.layer.cornerRadius = 3.0
        self.emailTxtView.layer.borderColor = UIColor.lightGray.cgColor
        self.emailTxtView.layer.borderWidth = 1.0
        self.txtPayPalEmailID?.placeholder = self.lang.paypal_EmailId
        self.txtPayPalEmailID?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        
        //txtPayPalEmailID?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        viewEmailHolder?.isHidden = true
        viewPickerHolder?.isHidden = true
//        callCountryAPI()
        let path = Bundle.main.path(forResource: "country", ofType: "plist")
        arrCountryDataPlist = NSMutableArray(contentsOfFile: path!)!
        btnSubmit?.layer.cornerRadius = 5.0
        btnSubmit?.appGuestSideBtnBG()
       self.close_Btn.setTitle(self.lang.close_Tit, for: .normal)
        self.txtPayPalEmailID?.placeholder = self.lang.paypal_EmailId
        self.submit_Btn.setTitle(self.lang.submit_Tit, for: .normal)
        
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine
        
        self.cls_Btn.transform = Language.getCurrentLanguage().getAffine
        
        self.payout_Tit.text = self.lang.payout_Tit
        
        self.pay_Titlee.text = self.lang.payout_Tit
        self.btnSubmit?.setTitle(self.lang.submit_Tit, for: .normal)
        self.navigationController?.isNavigationBarHidden = true
//        let path = Bundle.main.path(forResource: "country", ofType: "plist")
//        arrPickerData = NSMutableArray(contentsOfFile: path!)!
        arrSettingData = [self.lang.address_Title, self.lang.address2_Title, self.lang.city_Title, self.lang.state_Title, self.lang.postal_Title,self.lang.country_Title]

    }
    
    func callCountryAPI()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        
        var dicts = [AnyHashable: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_COUNTRY_LIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                
                if gModel.status_code == "1"
                {
                    self.arrCountryData.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                    self.tblPayoutDetails.reloadData()
                }
                else
                {
                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
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
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    func getPayOutDetail(index : Int) -> String
    {
        let indexPath = IndexPath(row: index, section: 0)
        selectedCell = tblPayoutDetails.cellForRow(at: indexPath) as! CellPayoutDetails
        let strValue = YSSupport.escapedValue((selectedCell.txtPayouts?.text)!)
        return (strValue!.count > 0) ? strValue! : ""
    }

    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        savePayOutDetails()
    }
    func savePayOutDetails()
    {
        //MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        let email = txtPayPalEmailID?.text as! String
        let requestParams = ["address1" : self.getPayOutDetail(index: 0),
                             "address2" : self.getPayOutDetail(index: 1),
                             "city" : self.getPayOutDetail(index: 2),
                             "state" : self.getPayOutDetail(index: 3),
                             "postal_code" : self.getPayOutDetail(index: 4),
                             "country" : selectedCurrency,
                             "paypal_email" : email,
                             "payout_method" : "paypal",
                             "token" : Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)] as! [String : Any]
        print("ReqParams:",requestParams)
        WebServiceHandler.sharedInstance.getWebService(wsMethod: .payout, params: requestParams) { (response, error) in
            let responseJson = response
            if let status = responseJson?.string("status_code") {
                if status == "1"{
                    self.delegate?.payoutAdded()
                    self.navigationController!.popViewController(animated: true)
                }else{
                    self.appDelegate.createToastMessage(responseJson?.string("success_message") ?? "", isSuccess: false)
                }
               
            }
        }
//        WebServiceHandler.sharedInstance.getWebService(wsMethod:"add_payout_perference", paramDict: requestParams, viewController:self, isToShowProgress:true, isToStopInteraction:true) { (response) in
//            let responseJson = response
//            //DispatchQueue.main.async {
//                if responseJson["status_code"] as! String == "1" {
//                    self.delegate?.payoutAdded()
//                    self.navigationController!.popViewController(animated: true)
//                    //MakentSupport().removeProgressInWindow(viewCtrl: self)
//
//                }
//                else {
//                    self.appDelegate.createToastMessage(responseJson["success_message"] as! String, isSuccess: false)
//                    //MakentSupport().removeProgressInWindow(viewCtrl: self)
//                }
//
//           // }
//        }
    }

    func changeCountryFromLabel()
    {
        viewPickerHolder?.isHidden = true
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
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.callCountryAPI()
        for i in 0..<self.arrCountryDataPlist.count {
            let countryName = ((self.arrCountryDataPlist[i] as AnyObject).value(forKey: "country_name") as! String)
            let countryCode = ((self.arrCountryDataPlist[i] as AnyObject).value(forKey: "country_code") as! String)
            self.filteredCountries.append(countryName)
            self.currencyList.append(countryCode)
    }
    }
    
    //
    //MARK: Room Detail Table view Handling
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblPayoutDetails.frame.size.width) ,height: 40)
        
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:20, width: viewHolder.frame.size.width ,height: 40)
        lblRoomName.text = self.lang.addresspay_Title
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSettingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellPayoutDetails = tblPayoutDetails.dequeueReusableCell(withIdentifier: "CellPayoutDetails")! as! CellPayoutDetails
        cell.txtPayouts?.delegate = self
        cell.lblDetails?.text = arrSettingData[indexPath.row]
        cell.btnDetails?.tag = indexPath.row
        cell.btnDetails?.addTarget(self, action: #selector(self.onTableRowTapped), for: UIControl.Event.touchUpInside)
        cell.btnDetails?.isHidden = indexPath.row == 5 ? false : true
        cell.txtPayouts?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.txtPayouts?.placeholder = (indexPath.row==5) ? self.lang.country_Title : ""
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //
    //MARK: Back Action
    //
    
    @IBAction func onTableRowTapped(_ sender:UIButton!)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        selectedCell = tblPayoutDetails.cellForRow(at: indexPath) as! CellPayoutDetails
        if sender.tag==5
        {
            self.view.endEditing(true)
            selectedCell.txtPayouts?.inputView = pickerView
            viewPickerHolder?.isHidden = false
            pickerView?.reloadAllComponents()
        }
        else
        {
            selectedCell.txtPayouts?.inputView = nil
            selectedCell.txtPayouts?.keyboardType = (sender.tag==4) ? UIKeyboardType.asciiCapable : UIKeyboardType.asciiCapable
            viewPickerHolder?.isHidden = true
            selectedCell.txtPayouts?.becomeFirstResponder()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !(viewPickerHolder?.isHidden)!
        {
            viewPickerHolder?.isHidden = true
        }
    }
    
    // Following are the delegate and datasource implementation for picker view :
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if arrCountryDataPlist.count == 0 || arrCountryDataPlist == nil {
            return 0
        }
        else{
            return arrCountryDataPlist.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return  self.filteredCountries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        let currencyModel = ((arrCountryData[row] as AnyObject).value(forKey: "country_name") as! String)

        selectedCell.txtPayouts?.text = self.filteredCountries[row]
        selectedCurrency =  self.currencyList[row]
    }
    
    @IBAction func closePickerView()
    {
        viewPickerHolder?.isHidden = true
    }

    
    //
    //MARK:  Calling API for Save Payout Details
    //MARK:  Submit buttton - Verifying PayPal Email ID
    //
    
    @IBAction func onVerifyPayPalEmailID()
    {
        self.view.endEditing(true)
        if (txtPayPalEmailID?.text?.count)! > 0 && MakentSupport().isValidEmail(testStr: (txtPayPalEmailID?.text)!)
        {
            viewEmailHolder?.isHidden = true
            self.savePayOutDetails()
        }
        else{
            appDelegate.createToastMessage(self.lang.paypal_EmailErr, isSuccess: false)
        }
        

    }

    //
    //MARK: Submit Action
    //
    @IBAction func onSubmitTapped(_ sender:UIButton!)
    {
        if self.getPayOutDetail(index: 0).count == 0 || self.getPayOutDetail(index: 1).count == 0
        {
            appDelegate.createToastMessage(self.lang.addr_FieldErr, isSuccess: false)
            return
        }
        else if self.getPayOutDetail(index: 2).count == 0
        {
            appDelegate.createToastMessage(self.lang.city_FieldErr, isSuccess: false)
            return
        }
        else if self.getPayOutDetail(index: 3).count == 0
        {
            appDelegate.createToastMessage(self.lang.state_FieldErr, isSuccess: false)
            return
        }
        else if self.getPayOutDetail(index: 4).count == 0
        {
            appDelegate.createToastMessage(self.lang.postalcode_FieldErr, isSuccess: false)
            return
        }
        else if self.getPayOutDetail(index: 5).count == 0
        {
            appDelegate.createToastMessage(self.lang.country_FieldErr, isSuccess: false)
            return
        }        
        viewEmailHolder?.isHidden = false
    }
    
    //
    //MARK: Back Action
    //
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if sender.tag == 11
        {
            viewEmailHolder?.isHidden = true
        }
        else
        {
            self.navigationController!.popViewController(animated: true)
        }
    }
   
    func onAddListTapped(){
        
    }
}

class CellPayoutDetails: UITableViewCell
{
    @IBOutlet var txtPayouts: UITextField?
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var btnDetails: UIButton?
}

