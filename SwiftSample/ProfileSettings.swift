/**
* ProfileSettings.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social
import LocalAuthentication

class ProfileSettings : UIViewController,UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,currencyListDelegate, ViewOfflineDelegate {
    
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet var tableProfileSettings: UITableView!
    var strCurrency : String = ""
    
    @IBOutlet weak var set_Lbl: UILabel!
    
    var  userDefaults = UserDefaults.standard
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrSettingData: [String] = []
    let secure = UserDefaults.standard.bool(forKey: "SecureSpaciko")
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.set_Lbl.text = self.lang.setting_Title
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine
        let userCurrency = userDefaults.object(forKey: APPURL.USER_CURRENCY) as? NSString
        if (userCurrency != nil && userCurrency != "")
        {
            strCurrency = userCurrency as! String
        }
        else
        {
            strCurrency = "USD ($)"
        }
        if devicePasscodeSet(){
            arrSettingData = [self.lang.curren_Title, self.lang.profset_Payout,self.lang.chsLan,self.lang.secTit + " " + k_AppName, self.lang.termser_Title, "\(self.lang.vers_Tit) " + k_AppVersion,self.lang.logot_Tit,self.lang.accDelete]
        }else{
          arrSettingData = [self.lang.curren_Title, self.lang.profset_Payout,self.lang.chsLan,self.lang.secTit + " " + k_AppName + "\n" + "Note: Turn on device Passcode", self.lang.termser_Title, "\(self.lang.vers_Tit) " + k_AppVersion,self.lang.logot_Tit,self.lang.accDelete]
        }
        self.tableProfileSettings.register(UINib(nibName: "DeleteAccountTVC", bundle: nil), forCellReuseIdentifier: "DeleteAccountTVC")
    }
    
    func devicePasscodeSet() -> Bool {
      //checks to see if devices (not apps) passcode has been set
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    @objc func opnClsAct(_ swt : UISwitch){
        if devicePasscodeSet(){
        if swt.isOn{
            UserDefaults.standard.set(true, forKey: "SecureSpaciko")
        }else{
           UserDefaults.standard.set(false, forKey: "SecureSpaciko")
        }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    //MARK: Delete Account:
    
    func callCheckAccDeleteApi()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        var paramDict = JSONS()
        paramDict["token"]   =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        WebServiceHandler.sharedInstance.getWebService(wsMethod: APIMethodsEnum.deleteAccount, params: paramDict) { (_json, err) in
            MakentSupport().removeProgressInWindow(viewCtrl: self)
            if let error = err{
                print("Error:",error.localizedDescription)
            }else{
                guard let json = _json else{return}
                if json.string("status_code")  == "1"{
                    if json.bool("is_payout")  == true{
                        self.ConfirmAlert(comments: self.lang.delete_acc_content, isPayout: true)
                    }else{
                        self.ConfirmAlert(comments: self.lang.delete_acc_content, isPayout: false)
                    }
                }else if json.string("status_code")  == "0" && json.string("status_message") == "This user in Inactive status please contact admin "{
                    self.appDelegate.logOutDidFinish()
                }else{
                    self.showAlert(comments: json.string("status_message"))
                }
            }
            
        }
        
    }
    
    func ConfirmAlert(comments:String,isPayout:Bool){
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "Makent Space", alertDescription: comments, okAction:self.lang.confirm.lowercased().capitalized,cancelAction: self.lang.close_Tit.lowercased().capitalized)
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            isPayout ? self.PayoutAlert(comments: self.lang.payoutContent) : self.callAccDeleteApi()
        }
        commonAlert.addAdditionalCancelAction {
            print("yes action")
        }
    }
    
    func showAlert(comments:String){
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "Makent Space", alertDescription: comments, okAction:self.lang.close_Tit.lowercased().capitalized,okColor: .appGuestButtonBG)
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            print("no action")
        }
    }
    
    func PayoutAlert(comments:String){
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "Makent Space", alertDescription: comments, okAction:self.lang.confirm.lowercased().capitalized,cancelAction: self.lang.cancel_Title.lowercased().capitalized)
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            self.callAccDeleteApi()
        }
        commonAlert.addAdditionalCancelAction {
            print("yes action")
        }
    }
    
    func callAccDeleteApi()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        var paramDict = JSONS()
        paramDict["token"]   =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        paramDict["confirm"] = "yes"
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        WebServiceHandler.sharedInstance.getWebService(wsMethod: APIMethodsEnum.deleteAccount, params: paramDict)  { (_json, err) in
            MakentSupport().removeProgressInWindow(viewCtrl: self)
            if let error = err{
                print("Error:",error.localizedDescription)
            }else{
                guard let json = _json else{return}
                if json.string("status_code")  == "1"{
                    self.moveToSplash(comments: self.lang.DeleteConfirmation)

                }else if json.string("status_code")  == "0" && json.string("status_message") == "This user in Inactive status please contact admin "{
                    self.appDelegate.logOutDidFinish()
                }else{
                    if !json.statusMessage.isEmpty{
                    self.appDelegate.createToastMessage(json.statusMessage)
                    }
                }
            }

        }
        
    }
    

    func moveToSplash(comments:String){
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "Makent space", alertDescription: comments, okAction:self.lang.ok_Title.lowercased().capitalized,okColor: .appGuestButtonBG)
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            self.appDelegate.lastPageMaintain = ""
            self.appDelegate.userToken = ""
            SharedVariables.sharedInstance.userToken = ""
           // self.appDelegate.arrWishListData.removeAll()
            self.appDelegate.strRoomID = ""
            self.appDelegate.arrExploreData = NSMutableArray()
            self.appDelegate.min_Price = 0
            self.appDelegate.max_Price = 0
            self.appDelegate.logOutDidFinish()
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE METHOD
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 76
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettingData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if arrSettingData[indexPath.row] ==  self.lang.accDelete  {
            let cell: DeleteAccountTVC = self.tableProfileSettings.dequeueReusableCell(withIdentifier: "DeleteAccountTVC", for: indexPath) as! DeleteAccountTVC
            cell.viewDeleteAcc.layer.cornerRadius = cell.viewDeleteAcc.frame.size.height / 2
            cell.viewDeleteAcc.elevate(4)
            cell.viewDeleteAcc.backgroundColor = .appTitleColor
            cell.lblDeleteAcc.text = lang.accDelete
            cell.selectionStyle = .none
            cell.addTap {
                self.callCheckAccDeleteApi()
            }
            return cell
        }
        let cell:ProfileSettingsCell = tableProfileSettings.dequeueReusableCell(withIdentifier: "ProfileSettingsCell") as! ProfileSettingsCell
        cell.switchMessage?.isHidden = (indexPath.row == 3) ? false : true
        cell.switchMessage?.addTarget(self, action: #selector(self.opnClsAct(_:)), for: .valueChanged)
        if self.secure{
            cell.switchMessage?.setOn(true, animated: false)
        }
        cell.imgAccessory?.transform = Language.getCurrentLanguage().getAffine
        cell.lblPrice?.isHidden = (indexPath.row == 0) ? false : true
        cell.lblPrice?.text = strCurrency
        cell.lblPrice?.appGuestTextColor()
        cell.imgAccessory?.isHidden = (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 3) ? true : false
        cell.lblName?.text = arrSettingData[indexPath.row]
        return cell
    }
    
    //MARK: UITABLEVIEW DATASOURCE METHOD
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row==0)
        {
            let locView = k_MakentStoryboard.instantiateViewController(withIdentifier: "CurrencyVC") as! CurrencyVC
            let strCurr = strCurrency.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").components(separatedBy: " ")
            locView.strCurrentCurrency = String(format: "%@ | %@",strCurr[0],strCurr[1])
            locView.delegate = self
            locView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(locView, animated: true)
        }
        else if (indexPath.row==1)
        {
            let locView = k_MakentStoryboard.instantiateViewController(withIdentifier: "AboutPayout") as! AboutPayout
            self.navigationController?.pushViewController(locView, animated: true)
        }else if (indexPath.row == 2)
        {
            let optionMenu = UIAlertController(title: nil, message: self.lang.chsLan, preferredStyle: .actionSheet)
            
            let saveAction = UIAlertAction(title: "English", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("LangVal:",Language.english)
                SharedVariables.sharedInstance.multipleDates = [Date]()
                Language.saveLanguage(Language.english)
                self.appDelegate.updateLanguage()
                self.appDelegate.makentTabBarCtrler.tabBar.transForm()
                
                    self.appDelegate.authenticationDidFinish(viewCtrl: self)
                
                
 
              
            })
            
            let deleteAction = UIAlertAction(title: "عربى", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("LangVal:",Language.arabic)
                SharedVariables.sharedInstance.multipleDates = [Date]()
                Language.saveLanguage(Language.arabic)
                self.appDelegate.updateLanguage()
                self.appDelegate.makentTabBarCtrler.tabBar.transForm()
                
                    self.appDelegate.authenticationDidFinish(viewCtrl: self)
                
     
            })
            
            let cancelAction = UIAlertAction(title: self.lang.cancel_Title, style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
               
            })
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(saveAction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        }
        else if (indexPath.row==4)
        {
            let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
            viewWeb.hidesBottomBarWhenPushed = true
            viewWeb.strWebUrl = String(format:"%@%@?token=%@",k_WebServerUrl,webPageUrl.URL_TERMS_OF_SERVICE,Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))
            viewWeb.strPageTitle = self.lang.termser_Title
            self.navigationController?.pushViewController(viewWeb, animated: true)
        }
        if(indexPath.row==6)
        {
            let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
            settingsActionSheet.addAction(UIAlertAction(title:self.lang.logot_Tit, style:UIAlertAction.Style.destructive, handler:{ action in
                self.callLogoutAPI()
            }))
            settingsActionSheet.addAction(UIAlertAction(title:self.lang.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
            present(settingsActionSheet, animated:true, completion:nil)
        }
    }

    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        callLogoutAPI()
    }

    // MARK: LOGOUT API CALL
    /*
     */
    func callLogoutAPI()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)

        var dicts = [AnyHashable: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_LOGOUT as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let loginData = response as! GeneralModel
            OperationQueue.main.addOperation {
//                MakentSupport().removeProgress(viewCtrl: self)
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                
                if loginData.status_code == "1" && loginData.success_message == "Logout Successfully"
                {
                    self.appDelegate.lastPageMaintain = ""
                    self.appDelegate.userToken = ""
                    SharedVariables.sharedInstance.userToken = ""
                    self.appDelegate.arrWishListData = NSMutableArray()
                    self.appDelegate.strRoomID = ""
                    self.appDelegate.btntype = ""
                    self.appDelegate.arrExploreData = NSMutableArray()
                    self.appDelegate.min_Price = 0
                    self.appDelegate.max_Price = 0
                    self.appDelegate.dictFilterParams = [AnyHashable: Any]()
                    self.appDelegate.roomModel = RoomDetailModel()
                  
                    self.appDelegate.logOutDidFinish()
                    
                }
                else  if loginData.status_code == "0" && loginData.success_message == "This user in Inactive status please contact admin "
                {
                    self.appDelegate.logOutDidFinish()
                }
                else
                {
                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: loginData.success_message as String)
               
                }
                
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    internal func onCurrencyChanged(currency: String)
    {
        let str = currency.components(separatedBy: " | ")
        strCurrency = String(format:"%@ (%@)", str[0],str[1])
        Constants().STOREVALUE(value: strCurrency as NSString, keyname: APPURL.USER_CURRENCY)
        let indexPath = IndexPath(row: 1, section: 0)
        tableProfileSettings.reloadRows(at: [indexPath], with: .none)
        tableProfileSettings.reloadData()
    }


    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
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

class ProfileSettingsCell: UITableViewCell {
    @IBOutlet var lblName: UILabel?
    @IBOutlet var imgAccessory: UIImageView?
    @IBOutlet var switchMessage: UISwitch?
    @IBOutlet var lblPrice: UILabel?

}

