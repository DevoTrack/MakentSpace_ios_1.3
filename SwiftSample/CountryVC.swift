/**
* CountryVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

@objc protocol CurrencyChangedDelegate
{
    func roomCurrencyChanged(strCurrencyCode: String, strCurrencySymbol: String)
    func updateBookTypeOrPolicy(strDescription: String)
    @objc optional func updateRoomPrice(modelList : ListingModel)
}


class CountryVC : UIViewController,UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblCountry: UITableView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var backbtn: UIButton!

    var strCurrentCurrency = ""
    var strCurrencySymbol = ""
    var strCurrency = ""
    var strTitle = ""
    var bookval = ""
    var dispArray = [String]()
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
//    var arrCurrency = NSArray()
    var delegate: CurrencyChangedDelegate?
    var arrCurrencyData : NSMutableArray = NSMutableArray()
    var isFromAddRoom : Bool = false
    var strApiMethodName = ""
    var listModel : ListingModel!
    
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var btnSave : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backbtn.isUserInteractionEnabled = true
        self.backbtn.transform = self.getAffine
        self.backbtn.appHostTextColor()
        self.btnSave.appHostTextColor()
        self.navigationController?.isNavigationBarHidden = true
        self.animatedLoader?.isHidden = true
        self.dispArray = [self.lang.insbook_Title,self.lang.reqbook_Title]
        btnSave.isHidden = true
        self.btnSave.setTitle(self.lang.save_Tit, for: .normal)
        strCurrency = strCurrentCurrency
        print("val",strTitle)
        
        if strTitle == "Currency"{
            lblTitle.text = self.lang.curren_Title
        }else if strTitle == "Country"{
            lblTitle.text = self.lang.country_Title
        }else{
            lblTitle.text = strTitle
        }
        if !isFromAddRoom
        {
            self.callCurrencyAPI()
        }
    }
    
    // MARK: CURRENCY API CALL
    /*
     */
    func callCurrencyAPI()
    {
        self.backbtn.isUserInteractionEnabled = false
        var dicts = [String: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_CURRENCY_LIST, paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                self.arrCurrencyData.removeAllObjects()
                responseDict.array("currency_list").forEach({ (tempJSONS) in
                    let model = CurrencyModel(responseDict: tempJSONS)
                    self.arrCurrencyData.add(model)
//                        .append(model)
                })
               
                self.tblCountry.reloadData()
                self.makeScroll()
            }else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
            }
        }
       
    }
    
    func makeScroll()
    {
        for i in 0...arrCurrencyData.count-1
        {
            let currencyModel = arrCurrencyData[i] as? CurrencyModel
            if currencyModel?.currency_code as! String == strCurrentCurrency
            {
                let indexPath = IndexPath(row: i, section: 0)
                tblCountry.scrollToRow(at: indexPath, at: .top, animated: true)
                break
            }
        }
        
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCurrencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellCountryList = tblCountry.dequeueReusableCell(withIdentifier: "CellCountryList") as! CellCountryList
        cell.lblCoutry?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        if !isFromAddRoom
        {
            
            let currencyModel = arrCurrencyData[indexPath.row] as? CurrencyModel
            cell.lblCoutry?.text = String(format: "%@",(currencyModel?.currency_code as String?)!)
        }
        else
        {
            if  (arrCurrencyData.count > indexPath.row){
                cell.lblCoutry?.text = arrCurrencyData[indexPath.row] as! String
            }
        }
        
        cell.imgTickMark?.image = UIImage(named: "check_red_active.png")?.withRenderingMode(.alwaysTemplate)
        cell.imgTickMark?.tintColor = UIColor.appHostThemeColor
        if !isFromAddRoom
        {
            cell.imgTickMark?.isHidden = (strCurrentCurrency == cell.lblCoutry?.text) ? false : true
        }else{
            cell.imgTickMark?.isHidden = (strCurrentCurrency == cell.lblCoutry?.text) ? false : true
        }


        return cell
    }
    
    func makeCurrencySymbols(encodedString : String) -> String
    {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
//        tblCountry.reloadRows(at: [indexPath], with: .none)
        if !isFromAddRoom
        {
            let currencyModel = arrCurrencyData[indexPath.row] as? CurrencyModel
            strCurrentCurrency = String(format: "%@",(currencyModel?.currency_code as String?)!)
            strCurrencySymbol =  String(format: "%@",(currencyModel?.currency_symbol as String?)!)
        }
        else
        {
            strCurrentCurrency = arrCurrencyData[indexPath.row] as! String
        }
        btnSave.isHidden = (strCurrency == strCurrentCurrency) ? true : false
        tblCountry.reloadData()
    }
        
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        if strApiMethodName == APPURL.METHOD_UPDATE_ROOM_CURRENCY
        {
            self.backbtn.isUserInteractionEnabled = false
            self.updateRoomCurrencyAPICall()
        }
        else
        {
            self.backbtn.isUserInteractionEnabled = false
            var dicts = [AnyHashable: Any]()
            MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
            self.btnSave?.isHidden = true
            
            self.animatedLoader?.isHidden = false
            
            if strApiMethodName == APPURL.METHOD_UPDATE_POLICY
            {
                if strCurrentCurrency == self.lang.strt_Title{
                   dicts["policy_type"] = "Strict"
                }else if strCurrentCurrency == self.lang.flexi_Title{
                  dicts["policy_type"] = "Flexible"
                }else {
                   dicts["policy_type"] = "Moderate"
                }
//                dicts["policy_type"]   = strCurrentCurrency
            }
            else if strApiMethodName == APPURL.METHOD_UPDATE_BOOKING_TYPE
            {
//                dicts["booking_type"]   = strCurrentCurrency.lowercased().replacingOccurrences(of: " ", with: "_")
                if strCurrentCurrency ==  self.lang.insbook_Title {
                    dicts["booking_type"]  = "instant_book"
                }
                else {
                    dicts["booking_type"]   = "request_to_book"
                }
            }
            dicts["room_id"]   = appDelegate.strRoomID
            dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
            MakentAPICalls().GetRequest(dicts,methodName:strApiMethodName as NSString as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
                let gModel = response as! GeneralModel
                OperationQueue.main.addOperation {
                    self.animatedLoader?.isHidden = true
                    self.btnSave?.isHidden = false
                    
                    self.backbtn.isUserInteractionEnabled = true
                    if gModel.status_code == "1"
                    {
                        self.backbtn.isUserInteractionEnabled = true
                        if self.strApiMethodName == APPURL.METHOD_UPDATE_ROOM_CURRENCY
                        {
                            self.delegate?.roomCurrencyChanged(strCurrencyCode: self.strCurrentCurrency, strCurrencySymbol: self.strCurrencySymbol)
                        }
                        else{
                            self.delegate?.updateBookTypeOrPolicy(strDescription: self.strCurrentCurrency)
                        }
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
                    }
                }
            }, andFailureBlock: {(_ error: Error) -> Void in
                OperationQueue.main.addOperation {
                    self.animatedLoader?.isHidden = true
                    self.btnSave?.isHidden = false
                    self.backbtn.isUserInteractionEnabled = true
                    self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                }
            })
        }
    }
    
    func updateRoomCurrencyAPICall()
    {
        self.backbtn.isUserInteractionEnabled = false
        var dicts = [AnyHashable: Any]()
        self.animatedLoader?.isHidden = false
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        self.btnSave?.isHidden = true
        dicts["currency_code"]   = strCurrentCurrency.replacingOccurrences(of: " ", with: "%20")
        dicts["room_id"]   = appDelegate.strRoomID
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
      
        MakentAPICalls().GetRequest(dicts,methodName:strApiMethodName as NSString as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! ListingModel
            OperationQueue.main.addOperation {
                self.backbtn.isUserInteractionEnabled = true
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
                
                if gModel.status_code == "1"
                {
                    self.updateCurrencyChanges(gModel)
                    self.backbtn.isUserInteractionEnabled = true
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.backbtn.isUserInteractionEnabled = true
                self.btnSave?.isHidden = false
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })

    }
    
    func updateCurrencyChanges(_ modelList : ListingModel)
    {
        var tempModel = ListingModel()
        if listModel != nil
        {
            tempModel = listModel
        }
        tempModel.additionGuestFee = modelList.additionGuestFee
        tempModel.cleaningFee = modelList.cleaningFee
        tempModel.monthly_price = modelList.monthly_price
        tempModel.room_price = modelList.room_price
        tempModel.securityDeposit = modelList.securityDeposit
        tempModel.weekendPrice = modelList.weekendPrice
        tempModel.weekly_price = modelList.weekly_price
        delegate?.updateRoomPrice!(modelList : tempModel)
        delegate?.roomCurrencyChanged(strCurrencyCode: self.strCurrentCurrency, strCurrencySymbol: self.strCurrencySymbol)
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}

class CellCountryList: UITableViewCell
{
    @IBOutlet var lblCoutry: UILabel?
    @IBOutlet var imgTickMark: UIImageView?
}



