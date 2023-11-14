/**
* CurrencyVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol currencyListDelegate
{
    func onCurrencyChanged(currency:String)
}
class CurrencyVC : UIViewController,UITableViewDelegate, UITableViewDataSource, ViewOfflineDelegate {
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblCurrency: UITableView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var currency_Lbl: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    var delegate: currencyListDelegate?
    var strCurrentCurrency = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrCurrencyData  = [Any]()
    var isFromPopOver = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.callCurrencyAPI()
        if self.isFromPopOver {
            self.backBtn.isHidden = true
            
        }else {
            self.backBtn.isHidden = false
        }
        self.btnSave.appHostBGColor()
        self.btnSave.setTitle(self.lang.save_Tit, for: .normal)
        self.currency_Lbl.text = self.lang.curren_Title
//        let path = Bundle.main.path(forResource: "currencies", ofType: "plist")
//        let dict = NSDictionary(contentsOfFile: path!)
//        arrCurrency = dict!.object(forKey: "currencies")! as! NSArray
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        btnSave.layer.cornerRadius = 5.0
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        callCurrencyAPI()
    }
    
    // MARK: CURRENCY API CALL
    /*
     */
    func callCurrencyAPI()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        
       
        
        var dicts = [String: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_CURRENCY_LIST, paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                self.arrCurrencyData.removeAll()
                var tempModel = [CurrencyModel]()
                responseDict.array("currency_list").forEach({ (tempJSONS) in
                    let model = CurrencyModel(responseDict: tempJSONS)
                   self.arrCurrencyData.append(model)
//                        .append(model)
                })
                
                
//                    .addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                self.tblCurrency.reloadData()
                
                self.makeScroll()
            }else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
            }
        }
//        MakentAPICalls().GetRequest(dicts,methodName: METHOD_CURRENCY_LIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
//            let gModel = response as! GeneralModel
//            OperationQueue.main.addOperation {
//                MakentSupport().removeProgress(viewCtrl: self)
//
//                if gModel.status_code == "1"
//                {
//                    self.arrCurrencyData.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
//                    self.tblCurrency.reloadData()
//
//                    self.makeScroll()
//                }
//                else
//                {
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
    
    func makeScroll()
    {
        for i in 0...arrCurrencyData.count - 1
        {
            if let currencyModel = arrCurrencyData[i] as? CurrencyModel {
                let str = strCurrentCurrency.components(separatedBy: " | ")
                if currencyModel.currency_code as String == str[0]
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    tblCurrency.scrollToRow(at: indexPath, at: .middle, animated: true)
                    break
                }
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCurrencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellCurrency = tblCurrency.dequeueReusableCell(withIdentifier: "CellCurrency") as! CellCurrency
        
        let currencyModel = arrCurrencyData[indexPath.row] as? CurrencyModel
        let strSymbol = self.makeCurrencySymbols(encodedString: (currencyModel?.currency_symbol as String?)!)
        cell.lblCurrency?.text = String(format: "%@ | %@",(currencyModel?.currency_code as String?)!,strSymbol)

        cell.imgTickMark?.isHidden = (strCurrentCurrency == cell.lblCurrency?.text) ? false : true
        cell.imgTickMark?.image = UIImage(named: "check_red_active.png")?.withRenderingMode(.alwaysTemplate)
        cell.imgTickMark?.tintColor = UIColor.appHostThemeColor
        if Language.getCurrentLanguage().isRTL {
            cell.lblCurrency?.textAlignment = .right
        } else {
            cell.lblCurrency?.textAlignment = .left
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedCell = tblCurrency.cellForRow(at: indexPath) as! CellCurrency
        appDelegate.nSelectedIndex = indexPath.row
//        let currencyModel = arrCurrencyData[indexPath.row] as? CurrencyModel
        strCurrentCurrency = (selectedCell.lblCurrency?.text)!
        tblCurrency.reloadData()
    }
    
    
    func makeCurrencySymbols(encodedString : String) -> String
    {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
    
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        
        var dicts = [AnyHashable: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        let str = strCurrentCurrency.components(separatedBy: " | ")
        dicts["currency_code"] = str[0]
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_CHANGE_CURRENCY as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                if gModel.status_code == "1"
                {
                    
                    self.delegate?.onCurrencyChanged(currency: self.strCurrentCurrency)
                    Constants().STOREVALUE(value: "Reload", keyname: APPURL.RELOAD)
                    Constants().STOREVALUE(value: str[1] as NSString, keyname: APPURL.USER_CURRENCY_SYMBOL)
                    Constants().STOREVALUE(value: String(format:"%@ (%@)",str[0] as NSString,str[1]) as NSString, keyname: APPURL.USER_CURRENCY)
                    self.updateOrgCurrency()
                    self.navigationController!.popViewController(animated: true)
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currencyData"), object: self, userInfo: nil)
                }
                else
                {
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
            }
        })
    }
    
    func updateOrgCurrency()
    {
        let currencyModel = arrCurrencyData[appDelegate.nSelectedIndex] as? CurrencyModel
        Constants().STOREVALUE(value: (currencyModel?.currency_symbol)!, keyname: APPURL.USER_CURRENCY_SYMBOL_ORG)
        Constants().STOREVALUE(value: (currencyModel?.currency_code)!, keyname: APPURL.USER_CURRENCY_ORG)
        _ = PipeLine.fireEvent(withName: .reloadView)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}

class CellCurrency: UITableViewCell
{
    @IBOutlet var lblCurrency: UILabel?
    @IBOutlet var imgTickMark: UIImageView?
}

