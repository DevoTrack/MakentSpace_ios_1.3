/**
* CancelRequestVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
protocol CancelRequestDelegate
{
    func CancelRequestChanged(strDescription: NSString)
}

class CancelRequestVC : UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate, ViewOfflineDelegate
{
    
    @IBOutlet var tblCountry : UITableView!
    @IBOutlet var txtMessage : UITextView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var btnReason : UIButton!
    @IBOutlet var btnSave : UIButton!
    
    var strSeletedReason : String = ""
    var strReservationId : String = ""
    var strMethodName : String = ""
    var strButtonTitle = ""
    
    var arrTitle = [String]()
    var newArr = [String]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrCurrency = NSArray()
    var delegate: CancelRequestDelegate?
    var pageType:BookingDetailsTypeEnum!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtMessage.text = ""
        txtMessage.delegate = self
        txtMessage.textColor = UIColor.darkGray
        
        newArr = [lang.why_Dec,lang.nolong_Accom,lang.mytrav_Dat,lang.res_Acc,lang.exten_Circum,lang.hos_Cancel,lang.uncomfor_Host,lang.plc_Expect
            ,lang.other_Title]
        strSeletedReason = newArr[0] as String
        btnReason.setTitle(lang.why_Dec, for: .normal)
        btnSave.setTitle(self.lang.can_Reser, for: .normal)
        btnSave.appGuestSideBtnBG()
        if strButtonTitle.count > 0
        {
            btnSave.setTitle(self.lang.can_Reser, for: .normal)
        }
        tblCountry.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        lblTitle.text = self.lang.canres_Tit
        tblCountry.reloadData()
        lblTitle?.layer.shadowColor = UIColor.gray.cgColor;
        lblTitle?.layer.shadowOffset = CGSize(width:1.0, height:1.0);
        lblTitle?.layer.shadowOpacity = 0.5;
        lblTitle?.layer.shadowRadius = 1.0;
        txtMessage.returnKeyType = UIReturnKeyType.done
        self.handleCancel()
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        handleCancel()
        cancelTrips()
    }
    func handleCancel(){
        if self.pageType == .trips {
            let arrTitle = ["Why are you declining?","I no longer need accommodations","My travel dates changed","I made the reservation by accident","I have an extenuating circumstance","My host needs to cancel","I’m uncomfortable with the host","The place isn't what I was expecting","The place isn't what I was expecting","Other"]
            self.newArr = arrTitle
            self.strMethodName = APPURL.METHOD_GUEST_CANCEL_TRIP_AFTER_PAY
        } else if self.pageType == .inbox {
            let hostArrTitle = ["No longer Available",
                                "Offer a different listing",
                                "Need Maintaince",
                                "I have an extenuating circumstance",
                                "My guest needs to cancel",
                                "Other"]
            self.newArr = hostArrTitle
            self.strMethodName = APPURL.METHOD_CANCEL_RESERVATION
        } else if self.pageType == .reservation {
            let hostArrTitle = ["No longer Available",
                                "Offer a different listing",
                                "Need Maintaince",
                                "I have an extenuating circumstance",
                                "My guest needs to cancel",
                                "Other"]
            self.newArr = hostArrTitle
            self.strMethodName = APPURL.METHOD_CANCEL_RESERVATION
        }
    }
    //MARK: Cancel Booked Trips
    func cancelTrips()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        //        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"]      = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["reservation_id"]    = strReservationId
        let strMsg = YSSupport.escapedValue((txtMessage.text  as NSString) as String?)
        if self.strMethodName == APPURL.METHOD_DECLINE_RESERVATION
        {
            dicts["decline_message"]    = strMsg?.removingPercentEncoding
            dicts["decline_reason"]    = strSeletedReason.replacingOccurrences(of: " ", with: "%20")
        }
        else if self.strMethodName == APPURL.METHOD_PRE_APPROVAL_OR_DECLINE
        {
            dicts["message"]    = strMsg?.removingPercentEncoding
            dicts["template"]    = "9"
        }
        else
        {
            strSeletedReason = YSSupport.escapedValue((strSeletedReason  as NSString) as String?)
            dicts["cancel_message"]    = strMsg?.removingPercentEncoding
            dicts["cancel_reason"]    =  strSeletedReason.replacingOccurrences(of: " ", with: "%20")
        }
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: strMethodName, paramDict: dicts as! JSONS, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                
                if (self.strMethodName == APPURL.METHOD_CANCEL_RESERVATION || self.strMethodName == APPURL.METHOD_DECLINE_RESERVATION || self.strMethodName == APPURL.METHOD_PRE_APPROVAL_OR_DECLINE)
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CancelReservation"), object: self, userInfo: nil)
                }
                else
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CancelResquestToBook"), object: self, userInfo: nil)
                }
                self.onBackTapped(nil)
                
            }else {
                self.appDelegate.createToastMessage(responseDict.statusMessage, isSuccess: false)
            }
        }
        
        //        MakentAPICalls().GetRequest(dicts,methodName: strMethodName as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
        //            let gModel = response as! GeneralModel
        //            OperationQueue.main.addOperation {
        //                if gModel.status_code == "1"
        //                {
        //                    self.onBackTapped(nil)
        //                    if (self.strMethodName == METHOD_CANCEL_RESERVATION || self.strMethodName == METHOD_DECLINE_RESERVATION || self.strMethodName == METHOD_PRE_APPROVAL_OR_DECLINE)
        //                    {
        //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CancelReservation"), object: self, userInfo: nil)
        //                    }
        //                    else
        //                    {
        //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CancelResquestToBook"), object: self, userInfo: nil)
        //                    }
        //                }
        //                else
        //                {
        //                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
        //                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
        //                    {
        //                        self.appDelegate.logOutDidFinish()
        //                        return
        //                    }
        //                }
        //                MakentSupport().removeProgressInWindow(viewCtrl: self)
        //            }
        //        }, andFailureBlock: {(_ error: Error) -> Void in
        //            OperationQueue.main.addOperation {
        //                MakentSupport().removeProgressInWindow(viewCtrl: self)
        //                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
        //            }
        //        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        }
        
        if (text == "\n") {
            txtMessage.resignFirstResponder()
            return true
        }
        
        return true
    }
    
    //MARK: ---------------------------------------------------------------
    //MARK: ***** Room Detail Table view Datasource Methods *****
    /*
     Room Detail List View Table Datasource & Delegates
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 51
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return newArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellCountryCode = tblCountry.dequeueReusableCell(withIdentifier: "CellCountryCode")! as! CellCountryCode
        cell.lblCountryTitle?.text = newArr[indexPath.row]
        cell.imgCoutry?.isHidden = (strSeletedReason == cell.lblCountryTitle?.text && (newArr[0] as String == strSeletedReason)) ? false : true
        cell.imgCoutry?.isHidden = true
        return cell
    }
    
    //MARK: ---- Table View Delegate Methods ----
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        strSeletedReason = newArr[indexPath.row] as String
        btnReason.setTitle(newArr[indexPath.row] as String, for: .normal)
        tblCountry.reloadData()
        tblCountry.isHidden = true
    }
    
    @IBAction func onCountryTapped(_ sender:UIButton!)
    {
        tblCountry.isHidden = !tblCountry.isHidden
    }
    
    @IBAction func onVerifySMSTapped(_ sender:UIButton!)
    {
        if strSeletedReason == "" {
        //&& txtMessage.text?.count == 0{
            self.appDelegate.createToastMessage(lang.errorinCancel, isSuccess: true)
        }else{
            self.view.endEditing(true)
            self.cancelTrips()
        }
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if self.navigationController != nil {
            self.navigationController!.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


