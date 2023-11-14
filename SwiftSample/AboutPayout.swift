/**
* AboutPayout.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class AboutPayout : UIViewController, UITableViewDelegate, UITableViewDataSource, AddPayoutDelegate, ViewOfflineDelegate,AddStripePayoutDelegate {
    
    @IBOutlet weak var back_Btn: UIButton!
    
    @IBOutlet var btnStartPayout: UIButton?
    @IBOutlet var tblPayoutDetails : UITableView!
    @IBOutlet weak var payoutmethod: UILabel!
    
    @IBOutlet weak var btn_StripePay: UIButton!
    @IBOutlet weak var payout_mg: UILabel!
    @IBOutlet weak var payout_TitleLbl: UILabel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var selectedCell : CellAboutPayout!
    var isCellOpened : Bool = false
    var arrPayoutList : NSMutableArray = NSMutableArray()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        payoutmethod.text = "\(self.lang.setup_Title) \(k_AppName.capitalized) \(self.lang.payoutmeth_Title)"
        self.navigationController?.isNavigationBarHidden = true
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        btnStartPayout?.appGuestSideBtnBG()
        btn_StripePay.appGuestSideBtnBG()
        self.payout_TitleLbl.text = self.lang.payout_Tit
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine
        self.payout_mg.text = self.lang.payot_Msg
        btnStartPayout?.setTitle(self.lang.paypal_Meth, for: .normal)
        btn_StripePay.setTitle(self.lang.stripe_Meth, for: .normal)
        let rect = UIScreen.main.bounds as CGRect
        var rectStartBtn = btnStartPayout?.frame
        rectStartBtn?.origin.y = rect.size.height-(btnStartPayout?.frame.size.height)!-80
        btnStartPayout?.frame = rectStartBtn!
        getPayoutList()
        btnStartPayout?.layer.cornerRadius = 5.0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true

    }
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        getPayoutList()
    }
    
    func getPayoutList()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        var dicts = [AnyHashable: Any]()
        
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_GET_PAYOUT_LIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if self.arrPayoutList.count > 0
                {
                    self.arrPayoutList.removeAllObjects()
                }
                self.tblPayoutDetails.isHidden = true

                if gModel.status_code == "1" && gModel.arrTemp1.count>0
                {
                    self.arrPayoutList.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                    self.tblPayoutDetails.isHidden = false
                    self.tblPayoutDetails.reloadData()
                    MakentSupport().removeProgressInWindow(viewCtrl: self)
                }else if gModel.success_message == "No Data Found"{
                    MakentSupport().removeProgressInWindow(viewCtrl: self)
                }
                else if gModel.success_message != "No Data Found"
                {
                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                    MakentSupport().removeProgressInWindow(viewCtrl: self)

                }
                self.tblPayoutDetails.reloadData()
                
                

            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
                MakentSupport().removeProgressInWindow(viewCtrl: self)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrPayoutList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellAboutPayout = tblPayoutDetails.dequeueReusableCell(withIdentifier: "CellAboutPayout")! as! CellAboutPayout
        
        let modelPay = arrPayoutList[indexPath.row] as! PayoutModel
        cell.lblDetails?.text = modelPay.payout_mail_id as String
        cell.lblStatus?.text = (modelPay.payout_type == "Yes") ? self.lang.def_Tit : ""
       
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            var rectStartBtn = cell.viewCellHolder?.frame
            rectStartBtn?.origin.x = 0
            cell.viewCellHolder?.frame = rectStartBtn!
        }, completion: { (finished: Bool) -> Void in
        })
  
        
        cell.btnMakeDefault?.tag = indexPath.row
        cell.btnMakeDefault?.addTarget(self, action: #selector(self.onMakeDefaultTapped), for: UIControl.Event.touchUpInside)
        cell.btnDelete?.setTitle(self.lang.dele_Tit, for: .normal)
        cell.btnMakeDefault?.setTitle(self.lang.mk_Deftit, for: .normal)
        cell.btnDelete?.tag = indexPath.row
        cell.btnDelete?.addTarget(self, action: #selector(self.onDeletePayoutTapped), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let modelPay = arrPayoutList[indexPath.row] as! PayoutModel

        if modelPay.payout_type == "Yes"
        {
            if(isCellOpened)
            {
                tblPayoutDetails.reloadData()
                isCellOpened = false
            }
            return
        }
        if isCellOpened
        {
            tblPayoutDetails.reloadData()
            isCellOpened = false
            return
        }
        let indexPath = IndexPath(row: indexPath.row, section: 0)
        selectedCell = (tblPayoutDetails.cellForRow(at: indexPath) as! CellAboutPayout)
        isCellOpened = true
        if Language.getCurrentLanguage().rawValue == "en"{
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            var rectStartBtn = self.selectedCell.viewCellHolder?.frame
            rectStartBtn?.origin.x = -167
            self.selectedCell.viewCellHolder?.frame = rectStartBtn!
        }, completion: { (finished: Bool) -> Void in
        })
        }else{
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
                var rectStartBtn = self.selectedCell.viewCellHolder?.frame
                rectStartBtn?.origin.x = -167 + self.selectedCell.contentView.frame.width
                self.selectedCell.viewCellHolder?.frame = rectStartBtn!
            }, completion: { (finished: Bool) -> Void in
            })
        }
    }

    @objc func onMakeDefaultTapped(_ sender:UIButton!)
    {
        let modelPay = arrPayoutList[sender.tag] as! PayoutModel
        isCellOpened = false
        self.callAPIForMakeDefaultOrDeletePayout(methodName: APPURL.METHOD_MAKE_DEFAULT_PAYOUT, indexToDelete: sender.tag, payoutId:  modelPay.payout_id as String)
    }
    
    @objc func onDeletePayoutTapped(_ sender:UIButton!)
    {
        let modelPay = arrPayoutList[sender.tag] as! PayoutModel
        isCellOpened = false
        self.callAPIForMakeDefaultOrDeletePayout(methodName: APPURL.METHOD_DELETE_PAYOUT, indexToDelete: sender.tag, payoutId: modelPay.payout_id as String)
    }
    
    func callAPIForMakeDefaultOrDeletePayout(methodName: String, indexToDelete: Int, payoutId: String)
    {
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["type"]   = (methodName == APPURL.METHOD_DELETE_PAYOUT) ? "delete" : "default"
        dicts["payout_id"]   = payoutId

        MakentAPICalls().GetRequest(dicts,methodName: methodName as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    if methodName == APPURL.METHOD_DELETE_PAYOUT && self.arrPayoutList.count > 0
                    {
                        self.arrPayoutList.removeObject(at: indexToDelete)
                    }
                    else
                    {
                        self.changeValue(index:indexToDelete)
                        if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                        {
                            self.appDelegate.logOutDidFinish()
                            return
                        }
                    }
                    if self.arrPayoutList.count == 0
                    {
                        self.tblPayoutDetails.isHidden = true
                    }
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                }
                self.tblPayoutDetails.reloadData()
                MakentSupport().removeProgressInWindow(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    
    func changeValue(index:Int)
    {
        getPayoutList()

    }
    //MARK: GO TO ADD NEW PAYOUT PAGE
    @IBAction func onAddPayoutTapped(_ sender:UIButton!)
    {
        let viewEditProfile = k_MakentStoryboard.instantiateViewController(withIdentifier: "PayoutDetails") as! PayoutDetails
        viewEditProfile.delegate = self
        viewEditProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    @IBAction func onAddStripeTapped(_ sender:UIButton!)
    {
         let userDefaults = UserDefaults.standard
         let DOB =  userDefaults.object(forKey: "DOB") as? String
        if DOB != " " || DOB != "" {
            let StripePage = k_MakentStoryboard.instantiateViewController(withIdentifier: "StripeVC") as! StripeVC
            StripePage.delegate = self
            StripePage.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(StripePage, animated: true)
        }
        else{
            appDelegate.createToastMessage(self.lang.updatedob_Error, isSuccess: false)
        }

        
    }
    //MARK: NEW PAYOUT ADDED DELEGATE
    internal func payoutAdded()
    {
        if arrPayoutList.count > 0
        {
            arrPayoutList.removeAllObjects()
        }
        
        self.getPayoutList()
    }
    internal func payoutStripeAdded()
    {
        if arrPayoutList.count > 0
        {
            arrPayoutList.removeAllObjects()
        }
        
        self.getPayoutList()
    }
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellAboutPayout: UITableViewCell
{
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblStatus: UILabel?
    @IBOutlet var btnMakeDefault: UIButton?
    @IBOutlet var btnDelete: UIButton?
    @IBOutlet var viewCellHolder: UIView?
}
