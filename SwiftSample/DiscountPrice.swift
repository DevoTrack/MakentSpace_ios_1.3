/**
 * DiscountPrice.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import MessageUI
import Social

protocol LongTermDelegate
{
    func onLongTermPriceChanged(modelList:ListingModel)
}


class DiscountPrice : UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    //    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblDiscountPrice : UITableView!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    var delegate: LongTermDelegate?
    
    var arrTitle = ["Cleaning fee","Additional guests","For each guest after","Security deposit","Weekend pricing"]
    
    var arrValues = [String]()
    var arrDummyValues = [String]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var selectedCell : CellDiscountPrice!
    
    var strWeekPrice = ""
    var strMonthPrice = ""
    var strCleaningFee = ""
    var strAdditionGuestFee = ""
    var strAdditionGuestCount = ""
    var strSecurityDeposit = ""
    var strWeekendPrice = ""
    var strCurrency = "&#36;"
    
    @IBOutlet var btnSave : UIButton!
    @IBOutlet var btnBack : UIButton!
    var listModel : ListingModel!
    
    var pickerView:UIPickerView? = UIPickerView()
    @IBOutlet var viewPickerHolder:UIView?
    
    @IBOutlet weak var addpric_Title: UILabel!
    
    @IBOutlet weak var set_Pric: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnBack.isUserInteractionEnabled = true
        btnBack.appHostTextColor()
        btnSave.appHostTextColor()
        self.navigationController?.isNavigationBarHidden = true
        btnSave.isHidden = true
        self.addpric_Title.text = self.lang.additionalprice_Title
//        self.disc_Msg.text = self.lang.givdis_Msg
        self.btnBack.transform = Language.getCurrentLanguage().getAffine
        self.set_Pric.text = self.lang.setpric_Msg
        self.btnSave.setTitle(self.lang.save_Tit, for: .normal)
        strCurrency = strCurrency.stringByDecodingHTMLEntities
        arrTitle = [self.lang.clenfee_Title,self.lang.addgues_Title,self.lang.echgues_Title,self.lang.secdep_Title,self.lang.weekendpric_Title]
        
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
//        viewPickerHolder?.isHidden = true
        
        strWeekPrice = ((listModel.weekly_price as String) == "0" || (listModel.weekly_price as String) == "") ? "" : listModel.weekly_price as String
        
        
        strMonthPrice = ((listModel.monthly_price as String) == "0" || (listModel.monthly_price as String) == "") ? "" : listModel.monthly_price as String
        
        strCleaningFee = ((listModel.cleaningFee as String) == "0" || (listModel.cleaningFee as String) == "") ? "" : listModel.cleaningFee as String
        
        strAdditionGuestFee = ((listModel.additionGuestFee as String) == "0" || (listModel.additionGuestFee as String) == "") ? "" : listModel.additionGuestFee as String
        
        strAdditionGuestCount = ((listModel.additionGuestCount as String) == "0" || (listModel.additionGuestCount as String) == "") ? "" : listModel.additionGuestCount as String
        
        
        print("strAdditionGuestCount is: \(listModel.additionGuestCount)")
        
        strSecurityDeposit = ((listModel.securityDeposit as String) == "0" || (listModel.securityDeposit as String) == "") ? "" : listModel.securityDeposit as String
        
        strWeekendPrice = ((listModel.weekendPrice as String) == "0" || (listModel.weekendPrice as String) == "") ? "" : listModel.weekendPrice as String
        
        strCurrency = (listModel.currency_symbol as String).count > 0 ? (listModel.currency_symbol as String).stringByDecodingHTMLEntities : strCurrency
        
        arrValues = [strWeekPrice,strMonthPrice,strCleaningFee,strAdditionGuestFee,strAdditionGuestCount,strSecurityDeposit,strWeekendPrice]
        arrDummyValues = arrValues
        
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
        btnBack.isUserInteractionEnabled = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: TextField Delegate Method
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        
        var indexPath = IndexPath()
        if textField.tag < 2
        {
            indexPath = IndexPath(row: textField.tag, section: 0)
        }
        else
        {
            indexPath = IndexPath(row: textField.tag-2, section: 1)
        }
        selectedCell = tblDiscountPrice.cellForRow(at: indexPath) as! CellDiscountPrice
//        viewPickerHolder?.isHidden = true
        self.view.removeAddedSubview(view: viewPickerHolder!)
        selectedCell.txtFldPrice?.inputView = nil
        
        
        print("this tag is: \(textField.tag)")
        
        if textField.tag == 2   // Additional Guest count
        {
//            viewPickerHolder?.isHidden = false
            self.view.addFooterView(footerView: viewPickerHolder!)
            pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 160))
            pickerView?.delegate = self
            pickerView?.dataSource = self
            textField.inputView = pickerView!
            
            if self.strAdditionGuestCount != "" && self.strAdditionGuestCount != "0" {
                
                pickerView?.selectRow(((strAdditionGuestCount as NSString).integerValue) - 1, inComponent: 0, animated: false)
                
            }
        }
        
        return true
    }
    
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        var indexPath = IndexPath()
        if textField.tag < 2
        {
            indexPath = IndexPath(row: textField.tag, section: 0)
        }
        else
        {
            indexPath = IndexPath(row: textField.tag-2, section: 1)
        }
        print("this tag is: \(textField.tag)")
        selectedCell = tblDiscountPrice.cellForRow(at: indexPath) as! CellDiscountPrice
//        viewPickerHolder?.isHidden = true
        self.view.removeAddedSubview(view: viewPickerHolder!)
        
        if textField.tag == 0   // WEEKLY PRICE
        {
            strCleaningFee = textField.text!
        }
        else if textField.tag == 1   // MONTHLY PRICE
        {
            strAdditionGuestFee = textField.text!
        }
        else if textField.tag == 2   // Cleaning Fee
        {
            strAdditionGuestCount = textField.text!
        }
        else if textField.tag == 3  // Additional Guest Fee
        {
            strSecurityDeposit = textField.text!
        }
        else if textField.tag == 4   // Additional Guest count
        {
            strWeekendPrice = textField.text!
        }
        
        arrValues = [strWeekPrice,strMonthPrice,strCleaningFee,strAdditionGuestFee,strAdditionGuestCount,strSecurityDeposit,strWeekendPrice]
        checkSaveButtonStatus()
    }
    
    // Following are the delegate and datasource implementation for picker view :
    
    //MARK: ***** Data Picker DataSource & Delegate Methods *****
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 16
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return String(format:(row==15) ? "%d+" : "%d",row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedCell.txtFldPrice?.text = String(format:"%d",row+1)
        strAdditionGuestCount = String(format:"%d",row+1)
        arrValues = [strWeekPrice,strMonthPrice,strCleaningFee,strAdditionGuestFee,strAdditionGuestCount,strSecurityDeposit,strWeekendPrice]
        checkSaveButtonStatus()
    }
    
    //MARK: ***** Data Picker Methods End *****
    
    
    /*
     HIDE/UNHIDE SAVE BUTTON
     */
    func checkSaveButtonStatus()
    {
        if arrValues == arrDummyValues {
            btnSave.isHidden = true
        } else {
            btnSave.isHidden = false
        }
    }
    
    
    
    //MARK: Long Term price Table view Handling
    /*
     Long Term price Table Datasource & Delegates
     */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblDiscountPrice.frame.size.width) ,height: 30)
        
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:0, width: viewHolder.frame.size.width ,height: 30)
        if section == 0
        {
            lblRoomName.text=self.lang.addpri
        }
        else if section == 1
        {
            lblRoomName.text=""
        }
        lblRoomName.font = UIFont (name: Fonts.CIRCULAR_LIGHT, size: 15)!
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return (indexPath.row == 0) ? 50 :60
        }
        else
        {
            return (indexPath.row == 1) ? 50 :60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section == 0 ? 2 : arrTitle.count - 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellDiscountPrice = tblDiscountPrice.dequeueReusableCell(withIdentifier: "CellDiscountPrice")! as! CellDiscountPrice
        
        if indexPath.section == 0
        {
            cell.txtFldPrice?.tag = indexPath.row
//            cell.btnPrice?.tag = indexPath.row
//            cell.btnPrice?.setTitle(arrTitle[indexPath.row], for: .normal)
            
//            cell.priceLabel.tag = indexPath.row
            cell.priceLabel.text = arrTitle[indexPath.row]
            
            
            
        }
        else
        {
            cell.txtFldPrice?.tag = indexPath.row+2
//            cell.btnPrice?.tag = indexPath.row+2
//            cell.btnPrice?.setTitle(arrTitle[indexPath.row+2], for: .normal)
            
            cell.priceLabel.text = arrTitle[indexPath.row + 2]
        }
        
        
        if cell.txtFldPrice?.tag == 0
        {
            cell.txtFldPrice?.text  = strCleaningFee
        }
        else if cell.txtFldPrice?.tag == 1
        {
            cell.txtFldPrice?.text  = strAdditionGuestFee
        }
        else if cell.txtFldPrice?.tag == 2
        {
            
            print("strAdditionGuestCount is: \(strAdditionGuestCount)")
            cell.txtFldPrice?.text  = (strAdditionGuestCount == "0" || strAdditionGuestCount == "") ? "1" : strAdditionGuestCount
        }
        else if cell.txtFldPrice?.tag == 3
        {
            cell.txtFldPrice?.text  = strSecurityDeposit
        }
        else if cell.txtFldPrice?.tag == 4
        {
            cell.txtFldPrice?.text  = strWeekendPrice
        }
        
        if cell.txtFldPrice?.tag == 2  {
            
            cell.lblCurrency.text = ""
            
        }else {
            
            cell.lblCurrency.text = strCurrency
        }
//        cell.btnPrice?.addTarget(self, action: #selector(self.onPriceTapped), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    
    //MARK: UITABLE VIEW DELEGATE METHOD
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let button = UIButton()
        if indexPath.section == 0 {
            button.tag = indexPath.row
        }
        else {
            button.tag = indexPath.row + 2
        }
        onPriceTapped(sender: button)
    }
    
    //MARK: WHILE USER CLICKING THE ROW - EDIT PRICE
    func onPriceTapped(sender:UIButton)
    {
        var indexPath = IndexPath()
        if sender.tag < 2
        {
            indexPath = IndexPath(row: sender.tag, section: 0)
        }
        else
        {
            indexPath = IndexPath(row: sender.tag-2, section: 1)
        }
        selectedCell = tblDiscountPrice.cellForRow(at: indexPath) as? CellDiscountPrice
        selectedCell.txtFldPrice?.becomeFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if !(viewPickerHolder?.isHidden)!
//        {
//            viewPickerHolder?.isHidden = true
//        }
        self.view.removeAddedSubview(view: viewPickerHolder!)
    }
    
    //MARK: API CALL - SAVE LONG TERM PRICE
    /*
     UPDATING LISTMODEL & CALLING DELEGATE METHOD TO ADD ROOM DETAIL
     */
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        btnBack.isUserInteractionEnabled = false
        self.view.endEditing(true)
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        var dicts = [AnyHashable: Any]()
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = listModel.room_id as String
        dicts["weekly_price"]   = strWeekPrice
        dicts["monthly_price"]   = strMonthPrice        
        dicts["cleaning_fee"]   = strCleaningFee
        dicts["additional_guests"]   = strAdditionGuestFee
        if strAdditionGuestCount == "" || strAdditionGuestCount == "0" || strAdditionGuestCount == " " {
            dicts["for_each_guest"]   = "1"
        }
        else{
            dicts["for_each_guest"]   = strAdditionGuestCount
        }
        dicts["security_deposit"]   = strSecurityDeposit
        dicts["weekend_pricing"]   = strWeekendPrice
        self.btnSave.isHidden = true
        self.animatedLoader?.isHidden = false
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_LONG_TERM_PRICE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            OperationQueue.main.addOperation {
                let gModel = response as! GeneralModel
                if gModel.status_code == "1"
                {
                    self.updateModel()
                    self.btnBack.isUserInteractionEnabled = true
                    
                }
                else
                {
                    self.btnSave.isHidden = false
                    self.animatedLoader?.isHidden = true
                    self.btnBack.isUserInteractionEnabled = true
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.animatedLoader?.isHidden = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                //                self.isDataFinishedFromServer = true
                self.btnBack.isUserInteractionEnabled = true
                self.btnSave.isHidden = false
                self.animatedLoader?.isHidden = true
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    
    //
    //MARK: UPDATING ROOM LONG TERM PRICE
    /*
     AFTER API CALLED - UPDATING LISTMODEL & CALLING DELEGATE METHOD TO ADD ROOM DETAIL
     */
    func updateModel()
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.weekly_price = strWeekPrice as NSString
        tempModel.monthly_price = strMonthPrice as NSString
        tempModel.cleaningFee = strCleaningFee as NSString
        tempModel.additionGuestFee = strAdditionGuestFee as NSString
        tempModel.additionGuestCount = strAdditionGuestCount as NSString
        tempModel.securityDeposit = strSecurityDeposit as NSString
        tempModel.weekendPrice = strWeekendPrice as NSString
        self.listModel = tempModel        
        self.delegate?.onLongTermPriceChanged(modelList:listModel)
        self.navigationController!.popViewController(animated: true)
    }
    
    //
    //MARK: Back Action
    //
    
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

class CellDiscountPrice: UITableViewCell
{
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var btnPrice: UIButton?
    @IBOutlet var lblCurrency: UILabel!
    
    @IBOutlet var txtFldPrice : UITextField?
    override func awakeFromNib() {
        txtFldPrice?.textColor = UIColor.appHostThemeColor
    }
}

