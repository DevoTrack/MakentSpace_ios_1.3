//
//  SpaceDescriptionViewController.swift
//  Makent
//
//  Created by trioangle on 03/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceDescriptionViewController: UIViewController {

    @IBOutlet weak var labelDescTitle: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var labelListName: UILabel!
    
    @IBOutlet weak var lblListCharCont: UILabel!
    
    @IBOutlet weak var viewListName: UIView!
    @IBOutlet weak var txtfldListName: UITextField! //35Char
    
    @IBOutlet weak var labelListDesc: UILabel!
    
    @IBOutlet weak var labelListDescCount: UILabel!
    
    @IBOutlet weak var viewListDesc: UIView!
    
    @IBOutlet weak var txtvwListDesc: UITextView! //500 Char
    
    @IBOutlet weak var continueBtn: UIButton!
    
    let lang = Language.localizedInstance()
    
    var bsicStp = BasicStpData()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Keep it short, sweet, and friendly, including this in your title can help your space stand out.
        self.initViewLayoutAction()
        if bsicStp.isEditSpace{
            self.setVal()
        }
    }
    
    func updateCharacterCount() {
        let listName = self.txtfldListName.text!.count
        let listDesc = self.txtvwListDesc.text!.count
        if listName > 1{
            self.lblListCharCont.text = "\((35) - self.txtfldListName.text!.count)" + " " + self.lang.charsLeft
        }else{
            self.lblListCharCont.text = "\((35) - self.txtfldListName.text!.count)" + " " + self.lang.charLeft
        }
        if listDesc > 1{
            self.labelListDescCount.text = "\((500) - self.txtvwListDesc.text.count)" + " " + self.lang.charsLeft
        }else{
            self.labelListDescCount.text = "\((500) - self.txtvwListDesc.text.count)" + " " + self.lang.charLeft
        }
        
    }
    

    
    func initViewLayoutAction(){
        self.addBackButton()
        self.labelDescTitle.TitleFont()
        self.labelDescription.DescFont()
        self.lblListCharCont.TextTitleFont()
        self.labelListDescCount.TextTitleFont()
        self.txtfldListName.TextTitleFont()
        self.txtvwListDesc.TextTitleFont()
        self.viewListName.BorderView()
        self.viewListDesc.BorderView()
        self.continueBtn.setfontDesign()
        self.txtfldListName.delegate = self
        self.txtvwListDesc.delegate = self
        self.labelDescTitle.text = self.lang.travelTitle
        self.labelDescription.text = self.lang.travelDesc1 + " " + k_AppName + " " + "is unique, and by highlighting your venue's most special features, you can stand out in your area and encourage more bookings!"
            //self.lang.travelDesc2
        self.labelListName.attributedText = self.coloredAttributedText(normal:self.lang.lisNameTit, "*")
        
        self.labelListDesc.attributedText = self.coloredAttributedText(normal:self.lang.sumTit, "*")
        
        
        self.lblListCharCont.text = "35" + " " + self.lang.charsLeft
        self.labelListDescCount.text = "500" + " " + self.lang.charsLeft
        
        self.continueBtn.addTap {
            if self.alertAct(){
            self.NextAct()
            }
        }
        self.bsicStp.crntScreenSetupState = .spaceDescription
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        
    }
    
    
    
    func setVal(){
        self.txtfldListName.text = self.bsicStp.name
        self.txtvwListDesc.text = self.bsicStp.summary
        self.updateCharacterCount()
        self.contEnable()
    }
    
    //Mark:- Contine Button Enable
    func contEnable(){
        if (self.txtfldListName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! && ((self.txtvwListDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || self.txtvwListDesc.text == self.lang.sumTit){
            self.continueBtn.alpha = 1.0
            self.continueBtn.isUserInteractionEnabled = true
        }else{
            self.contDisable()
        }
    }
    
    func contDisable(){
        if (self.txtfldListName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || ((self.txtvwListDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || self.txtvwListDesc.text == self.lang.sumTit){
            self.continueBtn.alpha = 0.1
            self.continueBtn.isUserInteractionEnabled = false
        }
    }
    
    //Mark:- Empty Fields Alert
    func alertAct()->Bool{
        if (self.txtfldListName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! && ((self.txtvwListDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || self.txtvwListDesc.text == self.lang.sumTit){
            self.appDelegate.createToastMessage(self.lang.pleaseFillAllMandatory, isSuccess: false)
            return false
        }else if (self.txtfldListName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            self.appDelegate.createToastMessage(self.lang.pleaseEnterListName, isSuccess: false)
            return false
        }else if ((self.txtvwListDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || self.txtvwListDesc.text == self.lang.sumTit){
            self.appDelegate.createToastMessage(self.lang.pleaseEnterSummary, isSuccess: false)
            return false
        }
        return true
    }
    
    func NextAct(){
        if self.txtvwListDesc.text != self.lang.checkinDesc{
            self.bsicStp.summary = self.txtvwListDesc.text!
        }
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["step"] = "setup"
        parameter ["name"] = txtfldListName.text!
        parameter ["summary"] = self.bsicStp.summary
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
    
    func ContinueAct(){
        self.navigationController?.removeProgress()
        let dashboardVC = self.navigationController!.viewControllers.filter { $0 is AddSpaceViewController }.first!
        self.navigationController!.popToViewController(dashboardVC, animated: true)
    }
    class func InitWithStory()-> SpaceDescriptionViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceDescriptionViewController") as! SpaceDescriptionViewController
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


extension SpaceDescriptionViewController : UITextFieldDelegate,UITextViewDelegate{
    
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let newLength = 35 - count
        if newLength == 1 {
            self.lblListCharCont.text = (35 - count).description + " " + self.lang.charLeft
        }else if newLength == 0{
            self.lblListCharCont.text = "0" + " " + self.lang.charLeft
        }else if count < 35{
            self.lblListCharCont.text = (35 - count).description + " " + self.lang.charsLeft
         }
        
        return count <= 35
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let textViewText = textView.text,
            let rangeOfTextToReplace = Range(range, in: textViewText) else {
                return false
        }
        let substringToReplace = textViewText[rangeOfTextToReplace]
        let count = textViewText.count - substringToReplace.count + text.count
        let newLength = 500 - count
        if newLength == 1 {
            self.labelListDescCount.text = (500 - count).description + " " + self.lang.charsLeft
        }else if newLength == 0{
            self.labelListDescCount.text = "0" + " " + self.lang.charLeft
        }else if count < 500{
            self.labelListDescCount.text = (500 - count).description + " " + self.lang.charsLeft
        }
        
        return count <= 500
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == self.lang.sumTit{
            txtvwListDesc.text = ""
            txtvwListDesc.textColor = .black
        }else{
            txtvwListDesc.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            txtvwListDesc.text = self.lang.sumTit
            txtvwListDesc.textColor = .lightGray
        }else{
            self.bsicStp.summary = textView.text
        }
        
        textView.resignFirstResponder()
    }
}

// BackSpace
//if textField ==  userNameFTF{
//    let char = string.cString(using: String.Encoding.utf8)
//    let isBackSpace = strcmp(char, "\\b")
//    if isBackSpace == -92 {
//        return true
//    }
//    return textField.text!.count <= 9
//}
