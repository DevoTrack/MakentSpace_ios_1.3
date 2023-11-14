//
//  SpaceGuestViewController.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceGuestViewController: UIViewController {

    
    @IBOutlet weak var lblHelpTit: UILabel!
    
    @IBOutlet weak var lblHelpDesc: UILabel!
    
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var lblMaxNumTitle: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    
    @IBOutlet weak var countTF: UITextField!
    @IBOutlet weak var plusBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var basicStp : BasicStpData?
    var basicStps = BasicStpData()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       self.initViewLayoutAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.basicStps.currentScreenState = .spaceGuest
    }
    class func InitWithStory()-> SpaceGuestViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceGuestViewController") as! SpaceGuestViewController
    }
    
    func ContinueAction(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["space_id"] = BasicStpData.shared.spaceID
        if self.basicStps.isEditSpace{
         parameter["number_of_guests"] = self.basicStps.numberOfGuests.description
        }else{
         parameter["number_of_guests"] = self.basicStps.noofGuest.description
        }
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.ContinueAct()
                    
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                    
                }
            }
            
        }
        
    }
    
    func initViewLayoutAction(){
        self.continueBtn.setfontDesign()
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        self.addBackButton()
        
        self.basicStps.currentScreenState = .spaceGuest
        self.plusBtn.titleLabel?.text = "+"
        self.plusBtn.PlusMinusLayout()
        self.minusBtn.titleLabel?.text = "-"
        self.minusBtn.PlusMinusLayout()
       // self.lblHelpTit.text = self.lang.hlpEveOrg
        self.lblHelpTit.text = self.lang.getStartList
        self.lblHelpDesc.text = self.lang.peopSearch + " " + k_AppName + " " + self.lang.mthNeeds
        self.lblList.text = self.lang.listings_Title
        //self.lang.maxGuestDesc
        self.lblMaxNumTitle.attributedText = self.coloredAttributedText(normal: "How many guests will fit into your space, including how many visitors are allowed ?", self.lang.asteriskSymbol)
            
        if self.basicStps.isEditSpace{
            
        self.countTF.text = self.basicStps.numberOfGuests.description
            
            if self.basicStps.numberOfGuests == 0 {
                 self.PlusInter()
                 self.minusBtn.alpha = 0.5
            }
            
            if self.basicStps.numberOfGuests == 99999 {
                self.MinusInter()
                self.plusBtn.alpha = 0.5
            }
            
        }else{
        self.countTF.text = self.basicStps.noofGuest.description
        self.minusBtn.alpha = 0.5
        }
        self.countTF.delegate = self
        self.countTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                           for: UIControl.Event.editingChanged)
        //self.addtapEnd()
        self.continueBtn.addTap {
            if self.emptyAlert(){
            if self.basicStps.isEditSpace{
            self.ContinueAction()
            }else{
             self.ContinueAct()
            }
            }
        }
        
        self.plusBtn.addTap {
            if self.basicStps.isEditSpace{
                
                if (self.basicStps.numberOfGuests < 99999) {
                    self.plusBtn.alpha = 1.0
                    self.minusBtn.alpha = 0.5
                    self.basicStps.numberOfGuests = self.basicStps.numberOfGuests + 1
                    self.countTF.text = self.basicStps.numberOfGuests.description
                    self.minusBtn.alpha = self.basicStps.numberOfGuests  == 0 ? 0.5 : 1.0
                    self.PlusMinusInter()
                }else if self.basicStps.numberOfGuests == 99999{
                    self.plusBtn.alpha = 0.5
                    self.minusBtn.alpha = 1.0
                    self.basicStps.numberOfGuests = self.basicStps.numberOfGuests + 1
                    self.countTF.text = self.basicStps.numberOfGuests.description
                    self.MinusInter()
                }else{
                    self.plusBtn.alpha = 0.5
                    self.minusBtn.alpha = 1.0
                    self.basicStps.numberOfGuests = self.basicStps.numberOfGuests
                    self.countTF.text = self.basicStps.numberOfGuests.description
                    self.minusBtn.alpha = self.basicStps.numberOfGuests == 0 ? 0.5 : 1.0
                    self.MinusInter()
                }
                
            }else{
                
            if (self.basicStps.noofGuest < 99999){
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 0.5
                self.basicStps.noofGuest = self.basicStps.noofGuest + 1
                self.countTF.text = self.basicStps.noofGuest.description
                self.minusBtn.alpha = self.basicStps.noofGuest  == 0 ? 0.5 : 1.0
                self.PlusMinusInter()
                
            }else if self.basicStps.noofGuest == 99999{
                self.plusBtn.alpha = 0.5
                self.minusBtn.alpha = 1.0
                self.basicStps.noofGuest = self.basicStps.noofGuest + 1
                self.countTF.text = self.basicStps.noofGuest.description
                self.MinusInter()
            }else{
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 1.0
                self.basicStps.noofGuest = self.basicStps.noofGuest
                self.countTF.text = self.basicStps.noofGuest.description
                self.minusBtn.alpha = self.basicStps.noofGuest  == 0 ? 0.5 : 1.0
                self.MinusInter()
            }
                
            }
        }
        
        self.minusBtn.addTap {
            
             if self.basicStps.isEditSpace{
                
                if self.basicStps.numberOfGuests != 0 &&  (self.basicStps.numberOfGuests < 100000){
                    self.plusBtn.alpha = 1.0
                    self.minusBtn.alpha = 1.0
                    self.basicStps.numberOfGuests = self.basicStps.numberOfGuests - 1
                    let minusVal = self.basicStps.numberOfGuests
                    self.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                    self.countTF.text = minusVal.description
                    self.PlusMinusInter()
                    
                }else if self.basicStps.numberOfGuests == 100000{
                    self.plusBtn.alpha = 1.0
                    self.minusBtn.alpha = 1.0
                    self.basicStps.numberOfGuests = self.basicStps.numberOfGuests - 1
                    self.countTF.text = self.basicStps.numberOfGuests.description
                    self.PlusMinusInter()
                }else{
                    self.plusBtn.alpha = 1.0
                    self.minusBtn.alpha = 0.5
                    let minusVal = self.basicStps.numberOfGuests
                    self.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                    self.countTF.text = minusVal.description
                    self.PlusInter()
                }
                
             }else{
                
            if self.basicStps.noofGuest != 0 &&  (self.basicStps.noofGuest < 100000){
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 1.0
                self.basicStps.noofGuest = self.basicStps.noofGuest - 1
                let minusVal = self.basicStps.noofGuest
                self.countTF.text = self.basicStps.noofGuest.description
                self.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                self.PlusMinusInter()
            }else if self.basicStps.noofGuest == 100000{
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 1.0
                self.basicStps.noofGuest = self.basicStps.noofGuest - 1
                self.countTF.text = self.basicStps.noofGuest.description
                self.PlusMinusInter()
            }else{
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 0.5
                let minusVal = self.basicStps.noofGuest
                self.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                self.countTF.text = minusVal.description
                self.PlusInter()
                
            }
                
            }
        }
    }
    
    func guestIncrement(){
        
    }
    
    func guestDecrement(){
        
    }
    
    //Mark:- Alert Function
    func emptyAlert() -> Bool{
        if self.countTF.text == "0" || (self.countTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            self.appDelegate.createToastMessage(self.lang.guesCountAlert, isSuccess: false)
            return false
        }
        return true
    }
    
    func ContinueAct(){
        let spaceamenities = SpaceAmenitiesViewController.InitWithStory()
        spaceamenities.basicStp = self.basicStps
        if self.basicStps.isEditSpace{
        spaceamenities.basicStp.isEditSpace = self.basicStps.isEditSpace
        }
        self.navigationController?.pushView(viewController: spaceamenities)
    }
    func PlusMinusInter(){
        self.plusBtn.isUserInteractionEnabled = true
        self.minusBtn.isUserInteractionEnabled = true
    }
    func PlusInter(){
        self.plusBtn.isUserInteractionEnabled = true
        self.minusBtn.isUserInteractionEnabled = false
    }
    func MinusInter(){
        self.plusBtn.isUserInteractionEnabled = false
        self.minusBtn.isUserInteractionEnabled = true
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
extension SpaceGuestViewController : UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.basicStps.isEditSpace{
            self.basicStps.numberOfGuests = (textField.text?.toInt())!
            if self.basicStps.numberOfGuests == 0{
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 0.5
                self.PlusInter()
            }else if self.basicStps.numberOfGuests == 100000{
                self.plusBtn.alpha = 0.5
                self.minusBtn.alpha = 1.0
                self.MinusInter()
            }else if (self.basicStps.numberOfGuests > 0) &&  (self.basicStps.numberOfGuests < 100000){
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 1.0
                self.PlusMinusInter()
            }
        }else{
            self.basicStps.noofGuest = (textField.text?.toInt())!
            if self.basicStps.noofGuest == 0{
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 0.5
                self.PlusInter()
            }else if self.basicStps.noofGuest == 100000{
                self.plusBtn.alpha = 0.5
                self.minusBtn.alpha = 1.0
                self.MinusInter()
            }else if (self.basicStps.noofGuest > 0) &&  (self.basicStps.noofGuest < 100000){
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 1.0
                self.PlusMinusInter()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.basicStps.isEditSpace{
           self.basicStps.numberOfGuests = (textField.text?.toInt())!
        }else{
            self.basicStps.noofGuest = (textField.text?.toInt())!
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let val = textFieldText.toInt()
        
        print("Value:",val)
        guard (val < 99999) else {
            return count <= 5 && allowedCharacters.isSuperset(of: characterSet)
        }
            return count <= 6 && allowedCharacters.isSuperset(of: characterSet)
    }
    
}
