//
//  SpaceDescribeViewController.swift
//  Makent
//
//  Created by trioangle on 19/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceDescribeViewController: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    
    var basicStp : BasicStpData?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var baseStep = BasicStpData()
    
    @IBOutlet weak var lblSpaceFurnish: UILabel!
    
    @IBOutlet weak var lblWrkStn: UILabel!
    
    @IBOutlet weak var lblShrdPriv: UILabel!
    
    @IBOutlet weak var lblNewExo: UILabel!
    
    @IBOutlet weak var lblSpaceType: UILabel!
    
    @IBOutlet weak var lblSpaceSF: UILabel!
    
    @IBOutlet weak var tfWorkStation: UITextField!
    
    @IBOutlet weak var btnStationAdd: UIButton!
    
    @IBOutlet weak var btnStationMinus: UIButton!
    
    @IBOutlet weak var btnSpaceAdd: UIButton!
    
    @IBOutlet weak var tfSpace: UITextField!
    
    @IBOutlet weak var btnSpaceMinus: UIButton!
    
    @IBOutlet weak var btnFurnishYes: UIButton!
    
    @IBOutlet weak var btnFurnishNo: UIButton!
    
    @IBOutlet weak var btnShared: UIButton!
    
    @IBOutlet weak var btnPrivate: UIButton!
    
    @IBOutlet weak var btnExpYes: UIButton!
    
    @IBOutlet weak var btnNewNo: UIButton!
    
    @IBOutlet weak var viewSpaceType: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.InitViewLayoutAction()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.baseStep.currentScreenState = .guestAccess
    }
    
    func InitViewLayoutAction(){
        self.btnContinue.setfontDesign()
        self.addBackButton()
        self.labelLayout()
        if self.baseStep.isEditSpace{
            self.radioBtnLayout()
            self.DataDisplay()
        }else{
            self.radioBtnLayout()
            self.btnInitLayout()
        }
        self.radioBtnAction()
        self.addminusLayout()
        self.squareFeetBtnAct()
        self.wrkStnsBtnAct()
        self.textFieldDelegates()
        self.btnContinue.setTitle(self.lang.continue_Title, for: .normal)
        self.baseStep.currentScreenState = .guestAccess
        self.viewSpaceType.addTap {
            self.AreaFunc(self.lblSpaceType)
        }
        self.btnContinue.addTarget(self, action: #selector(NextAct), for: .touchUpInside)
    }
    
    func DataDisplay(){
        self.baseStep.fullyFurnished == "" ? self.btnFurnishYesAction() : self.btnFurnishNoAction()
        self.baseStep.sharedPrivate == "" ? self.btnSharedAction() : self.btnPrivateAction()
        self.baseStep.rentingSpaceFirstTime == "" ? self.btnExpYesAction() : self.btnNewNoAction()
        
       
        if self.baseStep.sizeType != ""{
            self.lblSpaceType.text = self.baseStep.sizeType == "sq_ft" ? "SF ▼" : "Acres ▼"
        }
//        if self.baseStep.spaceTypeVal != ""{
//            self.lblSpaceType.text = self.baseStep.spaceTypeVal == "acre" ? "M2" : "SF"
//        }
        
//        self.lblSpaceType.text = self.baseStep.sizeType == "" ? self.baseStep.spaceTypeVal : self.baseStep.sizeType
        
        
        
            self.tfSpace.text = self.baseStep.squareFeet.description
            self.btnSpaceMinus.alpha = self.baseStep.squareFeet  == 0 ? 0.5 : 1.0
            self.btnSpaceAdd.alpha = self.baseStep.squareFeet == 999999 ? 0.5 : 1.0
        
        
        
            self.tfWorkStation.text = self.baseStep.noOfWorkstations.description
            self.btnStationMinus.alpha = self.baseStep.noOfWorkstations  == 0 ? 0.5 : 1.0
            self.btnStationAdd.alpha = self.baseStep.noOfWorkstations == 999 ? 0.5 : 1.0
       
        
    }
    
    func textFieldDelegates(){
        self.tfSpace.delegate = self
        self.tfWorkStation.delegate = self
        self.tfSpace.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                           for: UIControl.Event.editingChanged)
        
        self.tfWorkStation.addTarget(self, action: #selector(self.textFieldDidChangeWrkStns(_:)),
                               for: UIControl.Event.editingChanged)
    }
    
    func labelLayout(){
        self.lblSpaceFurnish.attributedText = self.coloredAttributedText(normal: "Is Your space fully furnished", "*")
        self.lblWrkStn.attributedText = self.coloredAttributedText(normal: "How many working stations are available in your space ?", "*")
        self.lblShrdPriv.attributedText = self.coloredAttributedText(normal: "Are you working stations/desks shared or private ?", "*")
        self.lblNewExo.attributedText = self.coloredAttributedText(normal: "Have you ever hosted your venue with a website like" + " " + k_AppName + " " + "before ?", "*")
        self.lblSpaceSF.attributedText = self.coloredAttributedText(normal: "How big is your space ?", "*")
        self.viewSpaceType.layer.borderWidth = 0.5
    }
    
    func addminusLayout(){
        self.btnStationAdd.PlusMinusLayout()
        self.btnStationMinus.PlusMinusLayout()
        self.btnStationAdd.titleLabel?.text = "+"
        self.btnSpaceAdd.titleLabel?.text = "+"
        
        self.btnSpaceAdd.PlusMinusLayout()
        self.btnSpaceMinus.PlusMinusLayout()
        self.btnStationMinus.titleLabel?.text = "-"
        self.btnSpaceMinus.titleLabel?.text = "-"
        
    }
    
    //Mark:- Action Sheet
    func AreaFunc(_ lblTxt : UILabel){
        let areaActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        areaActionSheet.addAction(UIAlertAction(title:"SF", style:UIAlertAction.Style.default, handler:{ action in
            lblTxt.text = "SF ▼"
            if self.baseStep.isEditSpace{
                self.baseStep.sizeType =  "sq_ft"
            }else{
                self.baseStep.spaceTypeVal =  "sq_ft"
            }
            
        }))
        areaActionSheet.addAction(UIAlertAction(title:"Acres", style:UIAlertAction.Style.default, handler:{ action in
            lblTxt.text = "Acres ▼"
            
            if self.baseStep.isEditSpace{
                self.baseStep.sizeType =  "acre"
            }else{
                self.baseStep.spaceTypeVal =  "acre"
            }
            
        }))
        
        areaActionSheet.addAction(UIAlertAction(title:self.lang.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
        
        self.present(areaActionSheet, animated:true, completion:nil)
    }
    
    func btnInitLayout(){
        self.btnStationMinus.alpha = 0.5
        self.btnSpaceMinus.alpha = 0.5
        self.PlusStationInter()
        self.PlusSqFeetInter()
    }
    
    func radioBtnLayout(){
        
        
        
        //Mark:- RadioButton Layout Default
        self.btnExpYes.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
        self.btnExpYes.tintColor = .lightGray
        self.btnNewNo.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
        self.btnNewNo.tintColor = .lightGray
        
        self.btnFurnishYes.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
        self.btnFurnishYes.tintColor = .lightGray
        self.btnFurnishNo.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
        self.btnFurnishNo.tintColor = .lightGray
        
        self.btnShared.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
        self.btnShared.tintColor = .lightGray
        self.btnPrivate.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
        self.btnPrivate.tintColor = .lightGray
        
    }
    
    func radioBtnAction(){
        //Mark:- RadioButton Action
        self.btnExpYes.addTap {
            self.btnExpYesAction()
        }
        
        self.btnNewNo.addTap {
            self.btnNewNoAction()
        }
        
        self.btnFurnishYes.addTap {
            self.btnFurnishYesAction()
        }
        
        self.btnFurnishNo.addTap {
            self.btnFurnishNoAction()
        }
        
        self.btnShared.addTap {
            self.btnSharedAction()
        }
        
        self.btnPrivate.addTap {
            self.btnPrivateAction()
        }
    }
    
    func btnExpYesAction(){
        
        let image = UIImage(named: "radioOff")?.withRenderingMode(.alwaysTemplate)
        
        if (self.btnExpYes.currentImage == image) {
            self.btnExpYes.setImage(UIImage().btnSetImage("radioOn"), for: .normal)
            self.btnExpYes.tintColor = UIColor.appHostThemeColor
            self.btnNewNo.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnNewNo.tintColor = .lightGray
            //Mark:- Renting First Time No Set
            self.baseStep.rentingSpaceFirstTime = "No"
        }else{
            self.btnExpYes.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnExpYes.tintColor = .lightGray
            self.baseStep.rentingSpaceFirstTime = ""
        }
    }
    
    
    
    func btnNewNoAction(){
        
        let image = UIImage(named: "radioOff")?.withRenderingMode(.alwaysTemplate)
        
        if (self.btnNewNo.currentImage == image) {
            self.btnNewNo.setImage(UIImage().btnSetImage("radioOn"), for: .normal)
            self.btnNewNo.tintColor = UIColor.appHostThemeColor
            self.btnExpYes.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnExpYes.tintColor = .lightGray
            //Mark:- Renting First Time Yes Set
            self.baseStep.rentingSpaceFirstTime = "Yes"
        }else{
            self.btnNewNo.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnNewNo.tintColor = .lightGray
            self.baseStep.rentingSpaceFirstTime = ""
        }
    }
    
    func btnFurnishYesAction(){
        
        let image = UIImage(named: "radioOff")?.withRenderingMode(.alwaysTemplate)
        
        if (self.btnFurnishYes.currentImage == image) {
            self.btnFurnishYes.setImage(UIImage().btnSetImage("radioOn"), for: .normal)
            self.btnFurnishYes.tintColor = UIColor.appHostThemeColor
            self.btnFurnishNo.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnFurnishNo.tintColor = .lightGray
            self.baseStep.fullyFurnished = "Yes"
        }else{
            self.btnFurnishYes.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnFurnishYes.tintColor = .lightGray
            self.baseStep.fullyFurnished = ""

            
        }
    }
    
    func btnFurnishNoAction(){
        
        let image = UIImage(named: "radioOff")?.withRenderingMode(.alwaysTemplate)
        
        if (self.btnFurnishNo.currentImage == image) {
            self.btnFurnishNo.setImage(UIImage().btnSetImage("radioOn"), for: .normal)
            self.btnFurnishNo.tintColor = UIColor.appHostThemeColor
            self.btnFurnishYes.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnFurnishYes.tintColor = .lightGray
            self.baseStep.fullyFurnished = "No"
        }else{
            self.btnFurnishNo.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnFurnishNo.tintColor = .lightGray
            self.baseStep.fullyFurnished = ""
        }
    }
    
    func btnSharedAction(){
        
        let image = UIImage(named: "radioOff")?.withRenderingMode(.alwaysTemplate)
        
        if (self.btnShared.currentImage == image) {
            self.btnShared.setImage(UIImage().btnSetImage("radioOn"), for: .normal)
            self.btnShared.tintColor = UIColor.appHostThemeColor
            self.btnPrivate.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnPrivate.tintColor = .lightGray
            self.baseStep.sharedPrivate = "Yes"
        }else{
            self.btnShared.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnShared.tintColor = .lightGray
            self.baseStep.sharedPrivate = ""
        }
    }
    
    func btnPrivateAction(){
        
        let image = UIImage(named: "radioOff")?.withRenderingMode(.alwaysTemplate)
        
        if (self.btnPrivate.currentImage == image) {
            self.btnPrivate.setImage(UIImage().btnSetImage("radioOn"), for: .normal)
            self.btnPrivate.tintColor = UIColor.appHostThemeColor
            self.btnShared.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnShared.tintColor = .lightGray
            self.baseStep.sharedPrivate = "No"
        }else{
            self.btnPrivate.setImage(UIImage().btnSetImage("radioOff"), for: .normal)
            self.btnPrivate.tintColor = .lightGray
            self.baseStep.sharedPrivate = ""
        }
    }
    
    func wrkStnsBtnAct(){
        //Mark:- Adding WorkStation plusButton Action
        self.btnStationAdd.addTap {
            
            if  (self.baseStep.noOfWorkstations < 998){
                self.btnStationAdd.alpha = 1.0
                self.btnStationMinus.alpha = 1.08
                self.baseStep.noOfWorkstations = self.baseStep.noOfWorkstations + 1
                self.tfWorkStation.text = self.baseStep.noOfWorkstations.description
                self.btnStationMinus.alpha = self.baseStep.noOfWorkstations  == 0 ? 0.5 : 1.0
                self.PlusMinusStationInter()
            }else if self.baseStep.noOfWorkstations == 998{
                self.btnStationAdd.alpha = 0.5
                self.btnStationMinus.alpha = 1.0
                self.baseStep.noOfWorkstations = self.baseStep.noOfWorkstations + 1
                self.tfWorkStation.text = self.baseStep.noOfWorkstations.description
                self.MinusStationInter()
            }else{
                self.btnStationAdd.alpha = 0.5
                self.btnStationMinus.alpha = 1.0
                self.baseStep.noOfWorkstations = self.baseStep.noOfWorkstations
                self.tfWorkStation.text = self.baseStep.noOfWorkstations.description
                self.btnStationMinus.alpha = self.baseStep.noOfWorkstations  == 0 ? 0.5 : 1.0
                self.MinusStationInter()
            }
        }
        
        //Mark:- Subtracting WorkStation plusButton Action
        self.btnStationMinus.addTap {
        
            if self.baseStep.noOfWorkstations <= 0 {
                self.btnStationMinus.alpha = 0.5
                self.btnStationMinus.isUserInteractionEnabled = false
            }
            
            else if (self.baseStep.noOfWorkstations < 999){
                self.btnStationAdd.alpha = 1.0
                self.btnStationMinus.alpha = 1.0
                self.baseStep.noOfWorkstations = self.baseStep.noOfWorkstations - 1
                self.tfWorkStation.text = self.baseStep.noOfWorkstations.description
                self.btnStationMinus.alpha = self.baseStep.noOfWorkstations  == 0 ? 0.5 : 1.0
                self.PlusMinusStationInter()
                
            }else if self.baseStep.noOfWorkstations == 999{
                self.btnStationAdd.alpha = 1.0
                self.btnStationMinus.alpha = 1.0
                self.baseStep.noOfWorkstations = self.baseStep.noOfWorkstations - 1
                self.tfWorkStation.text = self.baseStep.noOfWorkstations.description
                self.PlusMinusStationInter()
            }else{
                self.btnStationAdd.alpha = 1.0
                self.btnStationMinus.alpha = 0.5
                let minusVal = self.baseStep.noOfWorkstations
                self.tfWorkStation.text = minusVal.description
                self.btnStationMinus.alpha = self.baseStep.noOfWorkstations  == 0 ? 0.5 : 1.0
                self.PlusStationInter()
            }
        }
    }
    
    func squareFeetBtnAct(){
        
        self.btnSpaceAdd.addTap {
            
            if self.baseStep.isEditSpace{
                if (self.baseStep.squareFeet < 999998){
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.squareFeet = self.baseStep.squareFeet + 1
                    self.tfSpace.text = self.baseStep.squareFeet.description
                    self.btnSpaceMinus.alpha = self.baseStep.squareFeet  == 0 ? 0.5 : 1.0
                    self.PlusMinusSqFeetInter()
                }else if self.baseStep.squareFeet == 999998{
                    self.btnSpaceAdd.alpha = 0.5
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.squareFeet = self.baseStep.squareFeet + 1
                    self.tfSpace.text = self.baseStep.squareFeet.description
                    self.MinusSqFeetInter()
                }else{
                    self.btnSpaceAdd.alpha = 0.5
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.squareFeet = self.baseStep.squareFeet
                    self.tfSpace.text = self.baseStep.squareFeet.description
                    self.btnSpaceMinus.alpha = self.baseStep.squareFeet  == 0 ? 0.5 : 1.0
                    self.MinusSqFeetInter()
                }
            }else{
                if (self.baseStep.footageSpace < 999998){
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 0.5
                    self.baseStep.footageSpace = self.baseStep.footageSpace + 1
                    self.tfSpace.text = self.baseStep.footageSpace.description
                    self.btnSpaceMinus.alpha = self.baseStep.footageSpace  == 0 ? 0.5 : 1.0
                    self.PlusMinusSqFeetInter()
                    
                }else if self.baseStep.footageSpace == 999998{
                    self.btnSpaceAdd.alpha = 0.5
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.squareFeet = self.baseStep.footageSpace + 1
                    self.tfSpace.text = self.baseStep.squareFeet.description
                    self.MinusSqFeetInter()
                }else{
                    self.btnSpaceAdd.alpha = 0.5
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.footageSpace = self.baseStep.footageSpace
                    self.tfSpace.text = self.baseStep.footageSpace.description
                    self.btnSpaceMinus.alpha = self.baseStep.footageSpace  == 0 ? 0.5 : 1.0
                    self.MinusSqFeetInter()
                }
            }
            
        }
        
        //Mark:- Subtracting SquareFeet,FootageSpace plusButton Action
        self.btnSpaceMinus.addTap {
            if self.baseStep.isEditSpace{
                if self.baseStep.squareFeet != 0 &&  (self.baseStep.squareFeet < 999999){
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.squareFeet = self.baseStep.squareFeet - 1
                    let minusVal = self.baseStep.squareFeet
                    self.tfSpace.text = minusVal.description
                    self.btnSpaceMinus.alpha = minusVal  == 0 ? 0.5 : 1.0
                    self.PlusMinusSqFeetInter()
                    
                }else if self.baseStep.squareFeet == 999999{
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.squareFeet = self.baseStep.squareFeet - 1
                    self.tfSpace.text = self.baseStep.squareFeet.description
                    self.PlusMinusSqFeetInter()
                }else{
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 0.5
                    let minusVal = self.baseStep.squareFeet
                    self.tfSpace.text = minusVal.description
                    self.btnSpaceMinus.alpha = minusVal  == 0 ? 0.5 : 1.0
                    self.PlusSqFeetInter()
                    
                }
            }else{
                if self.baseStep.footageSpace != 0 &&  (self.baseStep.footageSpace < 999999){
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.footageSpace = self.baseStep.footageSpace - 1
                    let minusVal = self.baseStep.footageSpace
                    self.tfSpace.text = minusVal.description
                    self.btnSpaceMinus.alpha = minusVal  == 0 ? 0.5 : 1.0
                    self.PlusMinusSqFeetInter()
                    
                }else if self.baseStep.footageSpace == 999999{
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 1.0
                    self.baseStep.footageSpace = self.baseStep.footageSpace - 1
                    self.tfSpace.text = self.baseStep.footageSpace.description
                    self.PlusMinusSqFeetInter()
                }else{
                    self.btnSpaceAdd.alpha = 1.0
                    self.btnSpaceMinus.alpha = 0.5
                    let minusVal = self.baseStep.footageSpace
                    self.tfSpace.text = minusVal.description
                    self.btnSpaceMinus.alpha = minusVal  == 0 ? 0.5 : 1.0
                    self.PlusSqFeetInter()
                }
            }
        }
    }
    
    @objc func NextAct(){
        
        if footageSpaceAlert(){
            
            if baseStep.isEditSpace{
                
                ContinueAction()
            }else{
                
                ContinueAct()
            }
            
        }
    }
    
    func footageSpaceAlert() -> Bool{
        
        
        
        if self.baseStep.fullyFurnished == "" && self.baseStep.sharedPrivate == "" && self.baseStep.rentingSpaceFirstTime == "" {
            self.appDelegate.createToastMessage(self.lang.pleaseFillAllMandatory, isSuccess: false)
            return false
        }
        
        if self.baseStep.fullyFurnished == "" {
            self.appDelegate.createToastMessage(self.lang.pleaseProvideYourSpaceIsFurnishedOrNot, isSuccess: false)
            return false
        }
        if self.baseStep.noOfWorkstations == 0 {
            self.appDelegate.createToastMessage(self.lang.pleaseEnterOrAddWorkStationValue, isSuccess: false)
            return false
        }
        if self.baseStep.sharedPrivate == "" {
            self.appDelegate.createToastMessage(self.lang.pleaseSelectSharedOrPrivate, isSuccess: false)
            return false
        }
        if self.baseStep.rentingSpaceFirstTime == "" {
            self.appDelegate.createToastMessage(self.lang.pleaseProvideAreYouRentingNewOrExperience, isSuccess: false)
            return false
        }
        
        //Mark:- Checking Step Flow is Edit or New
        if baseStep.isEditSpace{
            
            if self.baseStep.squareFeet == 0 {
                self.appDelegate.createToastMessage(self.lang.footSpcAlert, isSuccess: false)
                return false
            }
        }else{
            if self.baseStep.footageSpace == 0 {
                self.appDelegate.createToastMessage(self.lang.footSpcAlert, isSuccess: false)
                return false
            }
        }
        return true
    }
    func ContinueAction(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["no_of_workstations"] = self.baseStep.noOfWorkstations.description
        parameter["shared_or_private"] = self.baseStep.sharedPrivate
        parameter["renting_space_firsttime"] = self.baseStep.rentingSpaceFirstTime
        parameter["fully_furnished"] = self.baseStep.fullyFurnished
        if baseStep.isEditSpace{
            parameter["sq_ft"] = self.baseStep.squareFeet.description
            parameter["size_type"] = self.baseStep.sizeType
        }else{
            parameter["sq_ft"] = self.baseStep.footageSpace.description
            parameter["size_type"] = self.baseStep.spaceTypeVal
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
    func ContinueAct(){
        
        let guestView = SpaceGuestViewController.InitWithStory()
        
        if self.baseStep.isEditSpace{
            
            guestView.basicStps.isEditSpace = self.baseStep.isEditSpace
        }else{
            if self.baseStep.spaceTypeVal == ""{
                self.baseStep.spaceTypeVal = "sq_ft"
            }
        }
        guestView.basicStps = self.baseStep
        self.navigationController?.pushView(viewController: guestView)
    }
    
    class func InitWithStory()->SpaceDescribeViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceDescribeViewController") as! SpaceDescribeViewController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func PlusMinusStationInter(){
        self.btnStationAdd.isUserInteractionEnabled = true
        self.btnStationMinus.isUserInteractionEnabled = true
    }
    func PlusStationInter(){
        self.btnStationAdd.isUserInteractionEnabled = true
        self.btnStationMinus.isUserInteractionEnabled = false
    }
    func MinusStationInter(){
        self.btnStationAdd.isUserInteractionEnabled = false
        self.btnStationMinus.isUserInteractionEnabled = true
    }
    
    func PlusMinusSqFeetInter(){
        self.btnSpaceAdd.isUserInteractionEnabled = true
        self.btnSpaceMinus.isUserInteractionEnabled = true
    }
    func PlusSqFeetInter(){
        self.btnSpaceAdd.isUserInteractionEnabled = true
        self.btnSpaceMinus.isUserInteractionEnabled = false
    }
    func MinusSqFeetInter(){
        self.btnSpaceAdd.isUserInteractionEnabled = false
        self.btnSpaceMinus.isUserInteractionEnabled = true
    }
}

extension SpaceDescribeViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if textField == self.tfSpace{
        return count <= 6 && allowedCharacters.isSuperset(of: characterSet)
        }else{
        return count <= 3 && allowedCharacters.isSuperset(of: characterSet)
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.baseStep.isEditSpace{
            self.baseStep.squareFeet = (textField.text?.toInt())!
            if self.baseStep.squareFeet == 0{
                self.btnSpaceAdd.alpha = 1.0
                self.btnSpaceMinus.alpha = 0.5
                self.PlusSqFeetInter()
            }else if self.baseStep.squareFeet == 999999{
                self.btnSpaceAdd.alpha = 0.5
                self.btnSpaceMinus.alpha = 1.0
                self.MinusSqFeetInter()
            }else if (self.baseStep.squareFeet > 0) &&  (self.baseStep.squareFeet < 999999){
                self.btnSpaceAdd.alpha = 1.0
                self.btnSpaceMinus.alpha = 1.0
                self.PlusMinusSqFeetInter()
            }
        }else{
            self.baseStep.footageSpace = (textField.text?.toInt())!
            if self.baseStep.footageSpace == 0{
                self.btnSpaceAdd.alpha = 1.0
                self.btnSpaceMinus.alpha = 0.5
                self.PlusSqFeetInter()
            }else if self.baseStep.footageSpace == 999999{
                self.btnSpaceAdd.alpha = 0.5
                self.btnSpaceMinus.alpha = 1.0
                self.MinusSqFeetInter()
            }else if (self.baseStep.footageSpace > 0) &&  (self.baseStep.footageSpace < 999999){
                self.btnSpaceAdd.alpha = 1.0
                self.btnSpaceMinus.alpha = 1.0
                self.PlusMinusSqFeetInter()
            }
        }
    }
    
    @objc func textFieldDidChangeWrkStns(_ textField: UITextField) {
        
        self.baseStep.noOfWorkstations = (textField.text?.toInt())!
        if self.baseStep.isEditSpace{
        if self.baseStep.noOfWorkstations == 0{
            self.btnStationAdd.alpha = 1.0
            self.btnStationMinus.alpha = 0.5
            self.PlusStationInter()
        }else if self.baseStep.noOfWorkstations == 999{
            self.btnStationAdd.alpha = 0.5
            self.btnStationMinus.alpha = 1.0
            self.MinusStationInter()
        }else if (self.baseStep.noOfWorkstations > 0) &&  (self.baseStep.noOfWorkstations < 999){
            self.btnStationAdd.alpha = 1.0
            self.btnStationMinus.alpha = 1.0
            self.PlusMinusStationInter()
        }
        }else{
            
            if self.baseStep.noOfWorkstations == 0{
                self.btnStationAdd.alpha = 1.0
                self.btnStationMinus.alpha = 0.5
                self.PlusStationInter()
            }else if self.baseStep.noOfWorkstations == 999{
                self.btnStationAdd.alpha = 0.5
                self.btnStationMinus.alpha = 1.0
                self.MinusStationInter()
            }else if (self.baseStep.noOfWorkstations > 0) &&  (self.baseStep.noOfWorkstations < 999){
                self.btnStationAdd.alpha = 1.0
                self.btnStationMinus.alpha = 1.0
                self.PlusMinusStationInter()
            }
        }
    }
}
