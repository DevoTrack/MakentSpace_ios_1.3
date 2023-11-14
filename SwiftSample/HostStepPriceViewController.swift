//
//  HostStepPriceViewController.swift
//  Makent
//
//  Created by trioangle on 30/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HostStepPriceViewController: UIViewController {

    @IBOutlet weak var hostPriceTableView: UITableView!
    
    @IBOutlet weak var chngCrncyBtn: UIButton!
    @IBOutlet weak var setPricLbl: UILabel!
    
    @IBOutlet weak var currencyTitleLbl: UILabel!
    @IBOutlet weak var minRateLbl: UILabel!
    @IBOutlet weak var ContinueBtn: UIButton!
    let maxPriceRange:Int = 4
    var currentSelectedPrice = Int()
    var hostActivityPrice:HostStepPriceModel!
    var bsicStep = BasicStpData()
    let lang = Language.localizedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hostPriceTableView.register(UINib(nibName: "HostStepPriceTVC", bundle: nil), forCellReuseIdentifier: "hostStepPriceTVC")
        hostPriceTableView.reloadData()
        self.setPricLbl.text = "Set your price"
        self.setPricLbl.TitleFont()
      
      self.updateCurrencyToView()
        self.setPricLbl.TextTitleFont()
        self.backButton()
        self.bsicStep.crntScreenHostState = .spacePrice
        self.ContinueBtn.setfontDesign()
        self.ContinueBtn.setTitle(self.lang.continue_Title, for: .normal)
        self.ContinueBtn.addTap {
            if self.priceValidation(){
                self.wsToUpdatePriceDetails()
            }
        }
        self.chngCrncyBtn.addTap {
            print("currency")
            self.getCurrencyValues()
        }
    }
    
    func backButton() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "Back")
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTap {
            self.navigationController?.popViewController(animated: true)
        }
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    //Mark:- Price Validation
    func priceValidation()-> Bool{
        //&& ($0.full_day.description == "") && ($0.weekly.description == "") && ($0.monthly.description == "")
        
        if !self.hostActivityPrice.activityPrice.filter({ $0.hourly == 0}).isEmpty && !self.hostActivityPrice.activityPrice.filter({ $0.full_day == 0}).isEmpty && !self.hostActivityPrice.activityPrice.filter({ $0.weekly == 0}).isEmpty && !self.hostActivityPrice.activityPrice.filter({ $0.monthly == 0}).isEmpty{
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseFillAllFields)
            return false
        }
        if !self.hostActivityPrice.activityPrice.filter({ $0.hourly < self.hostActivityPrice.minimum_amount.toInt()}).isEmpty {
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseEnterHourlyAmountGreaterThanOrEqualMinimumAmount)
            return false
        }
        
        if !self.hostActivityPrice.activityPrice.filter({ $0.hourly > $0.full_day}).isEmpty {
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseEnterFullDayAmountGreaterThanHourlyAmount)
            return false
        }
        
        if !self.hostActivityPrice.activityPrice.filter({ $0.full_day > $0.weekly}).isEmpty {
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseEnterWeeklyAmountGreaterThanFullDayAmount)
            return false
        }
        
        if !self.hostActivityPrice.activityPrice.filter({ $0.weekly > $0.monthly}).isEmpty {
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseEnterMonthlyAmountGreaterThanWeeklyAmount)
            return false
        }
        
        return true
    }
    
    func updateCurrencyToView() {
        self.currencyTitleLbl.text = self.hostActivityPrice.currency_code
        let symbol = (hostActivityPrice.currency_symbol as  String).stringByDecodingHTMLEntities
        self.minRateLbl.text =  self.lang.minimumHourRange+"\(symbol) \(hostActivityPrice.minimum_amount)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bsicStep.crntScreenHostState = .spacePrice
    }
    
    class func InitWithStory()->HostStepPriceViewController{
        return StoryBoard.Spacehostlist.instance.instantiateViewController(withIdentifier: "HostStepPriceViewController") as! HostStepPriceViewController
    }
    
    func getCurrencyValues(){

        var params = JSONS()
        params["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.API_CURRENCY_LIST, paramDict: params, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responesDict) in
            if responesDict.isSuccess {
                 let currencyVC = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "exprienceMeetSelectionViewController") as! ExprienceMeetSelectionViewController
                var googleModel = [GoogleTitleModel]()
                responesDict.array("currency_list").forEach({ (tempJSONS) in
                    let model = GoogleTitleModel(currencyJSONS: tempJSONS)
                    googleModel.append(model)
                })
                currencyVC.googleDelegate = self
                currencyVC.totalModelArray = googleModel
              
                currencyVC.modalPresentationStyle = .popover
                let popover: UIPopoverPresentationController = currencyVC.popoverPresentationController!
                popover.delegate = self
                let barBtnItem =  UIBarButtonItem(customView: self.chngCrncyBtn)
                popover.barButtonItem = barBtnItem
                self.present(currencyVC, animated: true, completion: nil)
            }else {
                self.sharedAppDelegete.createToastMessage(responesDict.statusMessage, isSuccess: false)
            }
        }
        
    }
    
    func wsToUpdatePriceDetails() {
       
        var params = JSONS()
        params["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        params["step"] = "ready_to_host"
        params["space_id"] = BasicStpData.shared.spaceID
        var activityParam = [JSONS]()
        self.hostActivityPrice.activityPrice.forEach({activityParam.append($0.getDict())})
        params["activity_price"] = self.sharedUtility.getJsonFormattedString(activityParam)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: HostStepsAPIName.updateSpace.text, paramDict: params, viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responesDict) in
            if responesDict.isSuccess {
                self.NextAct()
            }else {
                self.sharedAppDelegete.createToastMessage(responesDict.statusMessage, isSuccess: false)
            }
        }
        
    }
    
    func wsToUpdateCurrencySettings(_ currency:String) {
        var params = JSONS()
        params["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        params["currency_code"] = currency
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: HostStepsAPIName.getMinAmount.text, paramDict: params, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                
                self.hostActivityPrice.currency_symbol = responseDict.string("currency_symbol")
                self.hostActivityPrice.currency_code = responseDict.string("currency_code")
                self.hostActivityPrice.minimum_amount = responseDict.int("minimum_amount").description
                self.hostActivityPrice.activityPrice = self.hostActivityPrice.activityPrice.map({ (tempPrice) -> ActivityPrice in
                    tempPrice.currency_code = responseDict.string("currency_code")
                    tempPrice.currency_symbol = responseDict.string("currency_symbol")
                    return tempPrice
                })
                self.updateCurrencyToView()
                self.hostPriceTableView.reloadData()//self.view.reloadWithoutAnimation()
                self.hostPriceTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: false)
            }else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
            }
        }
    }
    
    func NextAct(){
        let spaceAvail = SpaceAvailabilityViewController.InitWithStory()
        spaceAvail.baseStep = self.bsicStep
        self.navigationController?.pushViewController(spaceAvail, animated: true)
    }
   

}



extension HostStepPriceViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hostActivityPrice.activityPrice.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hostStepPriceTVC") as! HostStepPriceTVC
        let model = self.hostActivityPrice.activityPrice[indexPath.row]
        cell.plusBtnOutlet.addTarget(self, action: #selector(self.tappedPlusBtnAction(_:)), for: .touchUpInside)
        cell.minusBtnOutlet.addTarget(self, action: #selector(self.tappedMiniusBtnAction(_:)), for: .touchUpInside)
        cell.setModelDetails(model)
        cell.hourlyRateTitleLbl.text = "Hourly Rate"
        cell.minHoursTitleLbl.text = "Min. Hours"
        cell.fullDayTitleLbl.text = "Full day rate"
        cell.minHoursLbl.text = model.min_hours.description
        cell.lblWeeklyRate.text = "Weekly Rate"
        cell.lblMonthlyRate.text = "Monthly Rate"
        
        cell.plusBtnOutlet.tag = indexPath.row
        cell.minusBtnOutlet.tag = indexPath.row
        cell.fullDayTF.tag = indexPath.row
        cell.hourlyRateTF.tag = indexPath.row
        cell.tfWeekly.tag = indexPath.row
        cell.tfMonthly.tag = indexPath.row
        
        cell.hourlyRateTF.AlignText()
        cell.fullDayTF.AlignText()
        cell.tfWeekly.AlignText()
        cell.tfMonthly.AlignText()
        
        cell.fullDayTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        cell.hourlyRateTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        cell.tfWeekly.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        cell.tfMonthly.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        cell.fullDayTF.delegate = self
        cell.hourlyRateTF.delegate = self
        cell.tfWeekly.delegate = self
        cell.tfMonthly.delegate = self
        cell.elevate(0.6)
        return cell
    }


}

extension HostStepPriceViewController {
   
    @objc func tappedMiniusBtnAction(_ sender:UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let model = self.hostActivityPrice.activityPrice[indexPath.row]
        if let cell = self.hostPriceTableView.cellForRow(at: indexPath) as? HostStepPriceTVC {
            self.currentSelectedPrice = (cell.minHoursLbl.text! as NSString).integerValue
            if currentSelectedPrice == 1 {
                currentSelectedPrice = 1
                self.callRangeErrorMsg()
            }else {
                currentSelectedPrice -= 1
            }
            model.min_hours = currentSelectedPrice
            UIView.performWithoutAnimation {
                self.hostPriceTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
       
    }
    
    func callRangeErrorMsg(){
        self.sharedAppDelegete.createToastMessage(self.lang.minimumHourRange+"1-\(maxPriceRange)")
        return
    }
    
    @objc func tappedPlusBtnAction(_ sender:UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let model = self.hostActivityPrice.activityPrice[indexPath.row]
        if let cell = self.hostPriceTableView.cellForRow(at: indexPath) as? HostStepPriceTVC {
            self.currentSelectedPrice = (cell.minHoursLbl.text! as NSString).integerValue
            if currentSelectedPrice >= maxPriceRange {
                currentSelectedPrice = maxPriceRange
                self.callRangeErrorMsg()
                
            }else {
                currentSelectedPrice += 1
                
            }
             model.min_hours = currentSelectedPrice
            UIView.performWithoutAnimation {
                self.hostPriceTableView.reloadRows(at: [indexPath], with: .none)
            }
            
        }
        
        
    }
    
    
    
}



extension HostStepPriceViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    @objc func textFieldDidChange(_ textField:UITextField)  {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let model = self.hostActivityPrice.activityPrice[indexPath.row]
        if let cell = self.hostPriceTableView.cellForRow(at: indexPath) as? HostStepPriceTVC, let number = (textField.text)?.toInt() {
            if textField == cell.hourlyRateTF {
                model.hourly = number
            }else if textField == cell.fullDayTF {
                model.full_day = number
            }else if textField == cell.tfWeekly {
                model.weekly = number
            }else if textField == cell.tfMonthly {
                model.monthly = number
            }
            UIView.performWithoutAnimation {
                self.hostPriceTableView.beginUpdates()
                self.hostPriceTableView.endUpdates()
            }
            let unconvertedRect = textField.caretRect(for: (textField.selectedTextRange?.start)!)
            var careRect = textField.convert(unconvertedRect, to: self.hostPriceTableView)
            careRect.size.height += careRect.size.height / 2;

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.hostPriceTableView.scrollRectToVisible(careRect, animated: false)
            }
        }
    }
}

extension HostStepPriceViewController:GoogleLocationUpdateExperience,UIPopoverPresentationControllerDelegate {
    var isSelected: Bool {
        return false
    }
    
    func getGoogledata(_ model: GoogleTitleModel) {
        print(model.title)
        self.wsToUpdateCurrencySettings(model.title)
        
    }
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension UIView
{
    func reloadWithoutAnimation() {
        _ = self.subviews.compactMap { (tempView)  in
            if let tableView = tempView as? UITableView {
                UIView.performWithoutAnimation {
                    tableView.reloadData()
                }
                
            }
        }
        
    }

}
