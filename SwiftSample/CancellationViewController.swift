//
//  CancellationViewController.swift
//  Makent
//
//  Created by trioangle on 18/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class CancellationViewController: UIViewController {

    @IBOutlet weak var contBtn: UIButton!
    
    @IBOutlet weak var lblCancelTitle: UILabel!
    
    @IBOutlet weak var viewCancel: UIView!
    
    @IBOutlet weak var tfCancel: DropDown!
    
    @IBOutlet weak var lblBookingTitle: UILabel!
    
    @IBOutlet weak var viewBookTyp: UIView!
    
    @IBOutlet weak var lblSecurityTitle: UILabel!
    
    @IBOutlet weak var lblCancelPolicy: UILabel!
    @IBOutlet weak var lblSecTitle: UILabel!
    
    @IBOutlet weak var tfBookType: DropDown!
    
    @IBOutlet weak var viewSecDepsoit: UIView!
    
    @IBOutlet weak var tfSecDep: UITextField!
    
    @IBOutlet weak var tfCurrencyCode: UITextField!
    @IBOutlet weak var viewCrcy: UIView!
    var baseStep = BasicStpData()
    var readyHost = ReadyToHost()
    let lang = Language.localizedInstance()
    var key = ""
    var cancelTitle = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViewLayout()
        
    }
    
    class func InitWithStory()-> CancellationViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "CancellationViewController") as! CancellationViewController
    }
    func initViewLayout(){
        
        self.contBtn.setfontDesign()
        self.baseStep.crntScreenHostState = .spaceCancellation
        self.backButton()
        self.readyHost = self.sharedVariable.readyToHostStep
        self.tfCurrencyCode.text = self.readyHost.activityPriceModel.currency_code
        self.viewCancel.BorderView()
        self.viewBookTyp.BorderView()
        self.viewSecDepsoit.BorderView()
        self.tfCancel.AlignText()
        self.tfBookType.AlignText()
        self.tfSecDep.AlignText()
        self.contBtn.addTap {
            
            self.NextAct()
        }
        
        self.contBtn.setTitle(self.lang.continue_Title, for: .normal)
        
        if self.readyHost.cancellation_policy.filter({$0.is_selected}).count > 0{
        self.key = self.readyHost.cancellation_policy.filter({$0.is_selected}).compactMap({$0.key})[0]
            self.tfCancel.selectedIndex = self.key.toInt()
        self.cancelTitle = self.readyHost.cancellation_policy.filter({$0.is_selected}).compactMap({$0.title})[0]
        }
        if self.cancelTitle != ""{
            self.tfCancel.text = self.cancelTitle
        }
        if self.readyHost.booking_type != ""{
            self.tfBookType.text = self.readyHost.booking_type == "instant_book" ? "Instant Book" : "Request to book"
            self.tfBookType.selectedIndex = self.readyHost.booking_type == "instant_book" ? 0 : 1
        }
        
        if self.readyHost.security != ""{
            self.tfSecDep.text = self.readyHost.security
        }
        
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText, NSAttributedString.Key.font: UIFont.init(name: Fonts.CIRCULAR_BOLD, size: 15.0)]
        // create the attributed string
        let attributedString = NSAttributedString(string: "View policy", attributes: boldFontAttributes as [NSAttributedString.Key : Any])
        self.lblCancelPolicy.attributedText = attributedString
        
        self.lblCancelPolicy.addTap {
            let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
            viewWeb.isViewFromCancel = true
            viewWeb.strPageTitle = self.lang.cancelpolicy_Title
            viewWeb.strCancellationFlexible = (self.key == "Flexible") ? CancelPolicy.flexible.instance : (self.key == "Moderate") ? CancelPolicy.moderate.instance : CancelPolicy.strict.instance
            self.navigationController?.pushViewController(viewWeb, animated: true)
        }
        
        self.tfCancel.placeholder = "Please Select Cancelation Policy"
        self.tfBookType.placeholder = "Please Select Booking Type"
        self.tfSecDep.placeholder = "Please Enter Security Fee"
        self.tfSecDep.delegate = self
        self.viewCancel.addTap {
            self.tfCancel.showList(true)
        }
        
        self.viewBookTyp.addTap {
            self.tfBookType.showList()
        }
        
        self.tfCancel.didSelect{(selectedText , index ,id) in
           self.key = self.readyHost.cancellation_policy[index].key
        }
        
        self.tfBookType.didSelect { (selectedText, index, id) in
            self.readyHost.booking_type = selectedText == "Instant Book" ? "instant_book" : "request_to_book"
                //"instant_book" ? "Instant Book" : "Request to book"
        }
        
        self.tfCancel.optionArray = readyHost.cancellation_policy.compactMap({$0.title})
        self.tfBookType.optionArray = [lang.insbook_Title,lang.reqbook_Title]
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
    override func viewWillAppear(_ animated: Bool) {
        self.baseStep.crntScreenHostState = .spaceCancellation
    }
    
    func NextAct(){
        
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["step"] = "ready_to_host"
        parameter["activity_currency"] = self.readyHost.activityPriceModel.currency_code
        parameter["security_deposit"]  = self.readyHost.security == "" ? self.tfSecDep.text : self.readyHost.security
        parameter["cancellation_policy"] = self.key
        parameter["booking_type"] = self.readyHost.booking_type
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    MakentSupport().removeProgress(viewCtrl: self)
                    print(_json)
                    self.NextDate()
                    
                    
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                }
            }
            
        }
        
    }
    func NextDate(){
        let myVC2 = ChooseDateViewController.InitWithStory()
        myVC2.baseStep = self.baseStep
        self.navigationController?.pushViewController(myVC2, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CancellationViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        guard let textFieldText = textField.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
            return allowedCharacters.isSuperset(of: characterSet)
       
    }
}
