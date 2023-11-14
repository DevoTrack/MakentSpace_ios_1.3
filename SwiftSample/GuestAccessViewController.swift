//
//  GuestAccessViewController.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class GuestAccessViewController: UIViewController {

   
    @IBOutlet weak var lblHelpTit: UILabel!
    
    @IBOutlet weak var lblPeopDesc: UILabel!
    @IBOutlet weak var listingLbl: UILabel!
   
    
    @IBOutlet weak var roomCountTable: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
    
   
    @IBOutlet var listView: UIView!
    var basicStp : BasicStpData?
    var listTitle = [String]()
    var roomData = [String]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var baseStep = BasicStpData()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.listTitle = [self.lang.noOfRooms,self.lang.noOfResRooms,self.lang.flrNum]
        self.ViewLayoutAction()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.baseStep.currentScreenState = .guestAccess
    }
     func ViewLayoutAction(){
        self.addBackButton()
        self.baseStep.currentScreenState = .guestAccess
        
        if baseStep.spaceID != ""{
            print(baseStep.spaceID)
        }
        self.lblHelpTit.text = self.lang.hlpEveOrg
        self.lblPeopDesc.text = self.lang.peopSearch + " " + k_AppName + " " + self.lang.mthNeeds
        self.listingLbl.text = self.lang.listings_Title
        //self.addtapEnd()
        self.roomCountTable.register(UINib(nibName: "RoomListTVC", bundle: nil), forCellReuseIdentifier: "RoomListTVC")
        self.roomCountTable.register(UINib(nibName: "RoomListSquareFtTVC", bundle: nil), forCellReuseIdentifier: "RoomListSquareFtTVC")
        self.continueBtn.setfontDesign()
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        self.roomCountTable.reloadData()
        self.continueBtn.addTarget(self, action: #selector(NextAct), for: .touchUpInside)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    class func InitWithStory()-> GuestAccessViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "GuestAccessViewController") as! GuestAccessViewController
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
    
     func ContinueAct(){
        
        let guestView = SpaceGuestViewController.InitWithStory()
        if self.baseStep.spaceTypeVal == ""{
            self.baseStep.spaceTypeVal = "sq_ft"
        }
         if self.baseStep.isEditSpace{
            
            guestView.basicStps.isEditSpace = self.baseStep.isEditSpace
        }
        guestView.basicStps = self.baseStep
        self.navigationController?.pushView(viewController: guestView)
     }
    //token, space_id, number_of_rooms, number_of_restrooms, floor_number, sq_ft, size_type
    func ContinueAction(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["number_of_rooms"] = (self.baseStep.getValue(.rooms)).description
        parameter["number_of_restrooms"] = (self.baseStep.getValue(.restRooms)).description
        parameter["floor_number"] = (self.baseStep.getValue(.floorNumber)).description
        
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
    
    //Mark:- Action Sheet
    func AreaFunc(_ lblTxt : UILabel){
        let areaActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        areaActionSheet.addAction(UIAlertAction(title:"sq ft", style:UIAlertAction.Style.default, handler:{ action in
            lblTxt.text = "sq ft"
            if self.baseStep.isEditSpace{
                self.baseStep.sizeType =  "sq_ft"
            }else{
                self.baseStep.spaceTypeVal =  "sq_ft"
            }

        }))
        areaActionSheet.addAction(UIAlertAction(title:"Acres", style:UIAlertAction.Style.default, handler:{ action in
            lblTxt.text = "Acres"
            
            if self.baseStep.isEditSpace{
                self.baseStep.sizeType =  "acre"
            }else{
                self.baseStep.spaceTypeVal =  "acre"
            }
            
        }))
        
        areaActionSheet.addAction(UIAlertAction(title:self.lang.cancel_Title, style:UIAlertAction.Style.cancel, handler:nil))
        
        self.present(areaActionSheet, animated:true, completion:nil)
    }
    
  
  
    //Mark:- Alert Space Field Empty || 0
    func footageSpaceAlert()->Bool{
       
        
//        if self.baseStep.getValue(.rooms) == 0 {
//            self.appDelegate.createToastMessage("Please Enter or Add Room Value", isSuccess: false)
//            return false
//        }
//        if self.baseStep.getValue(.floorNumber) == 0 {
//            self.appDelegate.createToastMessage("Please Enter or Add Floor Number Value", isSuccess: false)
//            return false
//        }
//        if self.baseStep.getValue(.restRooms) == 0 {
//            self.appDelegate.createToastMessage("Please Enter or Add Rest Rooms Value", isSuccess: false)
//            return false
//        }
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
   
    
}
extension GuestAccessViewController : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 1
        }else{
          return listTitle.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomListSquareFtTVC", for: indexPath) as! RoomListSquareFtTVC
            cell.txtLbl.attributedText = self.coloredAttributedText(normal: self.lang.estFootSpc, self.lang.asteriskSymbol)
            
            cell.baseStep = self.baseStep
            cell.txtLbl.tag = indexPath.row
            
            cell.plusBtn.PlusMinusLayout()
            cell.minusBtn.PlusMinusLayout()
            
            if baseStep.isEditSpace{
                cell.lblSizeType.text = self.baseStep.sizeType == "" ? "sq ft" : self.baseStep.sizeType
            }else{
                cell.lblSizeType.text = self.baseStep.spaceTypeVal == "" ? "sq ft" : self.baseStep.spaceTypeVal
            }
           
           if baseStep.isEditSpace{
            cell.countLbl.text = self.baseStep.squareFeet.description
            cell.minusBtn.alpha = self.baseStep.squareFeet  == 0 ? 0.5 : 1.0
            cell.plusBtn.alpha = self.baseStep.squareFeet == 999999 ? 0.5 : 1.0
           }else{
            cell.countLbl.text = self.baseStep.footageSpace.description == "" ? "0" : self.baseStep.footageSpace.description
            cell.minusBtn.alpha = self.baseStep.footageSpace  == 0 ? 0.5 : 1.0
            cell.plusBtn.alpha = self.baseStep.footageSpace == 999999 ? 0.5 : 1.0
            }
            
            
            
           
            
            //Mark:- Adding SquareFeet,FootageSpace plusButton Action
//            [weak self] in
//            guard let welf = self else {return}
            cell.plusBtn.addTap {
                
                if self.baseStep.isEditSpace{
                    if self.baseStep.squareFeet != 0 &&  (self.baseStep.squareFeet < 999998){
                        cell.plusBtn.alpha = 1.0
                        cell.minusBtn.alpha = 1.0
                        self.baseStep.squareFeet = self.baseStep.squareFeet + 1
                        cell.countLbl.text = self.baseStep.squareFeet.description
                        cell.minusBtn.alpha = self.baseStep.squareFeet  == 0 ? 0.5 : 1.0
                        cell.PlusMinusInter()
                    }else if self.baseStep.squareFeet == 999998{
                        cell.plusBtn.alpha = 0.5
                        cell.minusBtn.alpha = 1.0
                        self.baseStep.squareFeet = self.baseStep.squareFeet + 1
                        cell.countLbl.text = self.baseStep.squareFeet.description
                        cell.MinusInter()
                    }else{
                        cell.plusBtn.alpha = 1.0
                        cell.minusBtn.alpha = 1.0
                        self.baseStep.squareFeet = self.baseStep.squareFeet + 1
                        cell.countLbl.text = self.baseStep.squareFeet.description
                        cell.minusBtn.alpha = self.baseStep.squareFeet  == 0 ? 0.5 : 1.0
                        cell.PlusInter()
                    }
                }else{
                    if self.baseStep.footageSpace != 0 &&  (self.baseStep.footageSpace < 999998){
                        cell.plusBtn.alpha = 1.0
                        cell.minusBtn.alpha = 0.5
                        self.baseStep.footageSpace = self.baseStep.footageSpace + 1
                        cell.countLbl.text = self.baseStep.footageSpace.description
                        cell.minusBtn.alpha = self.baseStep.footageSpace  == 0 ? 0.5 : 1.0
                        cell.PlusMinusInter()
                        
                    }else if self.baseStep.footageSpace == 999998{
                        cell.plusBtn.alpha = 0.5
                        cell.minusBtn.alpha = 1.0
                        self.baseStep.squareFeet = self.baseStep.footageSpace + 1
                        cell.countLbl.text = self.baseStep.squareFeet.description
                        cell.MinusInter()
                    }else{
                        cell.plusBtn.alpha = 1.0
                        cell.minusBtn.alpha = 1.0
                        self.baseStep.footageSpace = self.baseStep.footageSpace + 1
                        cell.countLbl.text = self.baseStep.footageSpace.description
                        cell.minusBtn.alpha = self.baseStep.footageSpace  == 0 ? 0.5 : 1.0
                        cell.PlusInter()
                    }
                }
               
            }
            
            //Mark:- Subtracting SquareFeet,FootageSpace plusButton Action
            cell.minusBtn.addTap {
                if self.baseStep.isEditSpace{
                    if self.baseStep.squareFeet != 0 &&  (self.baseStep.squareFeet < 999999){
                        cell.plusBtn.alpha = 1.0
                        cell.minusBtn.alpha = 1.0
                        self.baseStep.squareFeet = self.baseStep.squareFeet - 1
                        let minusVal = self.baseStep.squareFeet
                        cell.countLbl.text = minusVal.description
                        cell.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                        cell.PlusMinusInter()
                        
                    }else if self.baseStep.squareFeet == 999999{
                        cell.plusBtn.alpha = 1.0
                        cell.minusBtn.alpha = 1.0
                        self.baseStep.squareFeet = self.baseStep.squareFeet - 1
                        cell.countLbl.text = self.baseStep.squareFeet.description
                        cell.PlusMinusInter()
                    }else{
                        cell.plusBtn.alpha = 1.0
                        cell.minusBtn.alpha = 0.5
                        let minusVal = self.baseStep.squareFeet
                        cell.countLbl.text = minusVal.description
                        cell.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                        cell.PlusInter()
                        
                    }
                }else{
                if self.baseStep.footageSpace != 0 &&  (self.baseStep.footageSpace < 999999){
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 1.0
                    self.baseStep.footageSpace = self.baseStep.footageSpace - 1
                    let minusVal = self.baseStep.footageSpace
                    cell.countLbl.text = minusVal.description
                    cell.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                    cell.PlusMinusInter()
                    
                }else if self.baseStep.footageSpace == 999999{
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 1.0
                    self.baseStep.footageSpace = self.baseStep.footageSpace - 1
                    cell.countLbl.text = self.baseStep.footageSpace.description
                    cell.PlusMinusInter()
                }else{
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 0.5
                    let minusVal = self.baseStep.footageSpace
                    cell.countLbl.text = minusVal.description
                    cell.minusBtn.alpha = minusVal  == 0 ? 0.5 : 1.0
                    cell.PlusInter()
                }
                }
            }
            
            cell.sqftLbl.addTap {
                self.AreaFunc(cell.lblSizeType)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomListTVC", for: indexPath) as! RoomListTVC
           // let valueType = BasicStpData.RoomDataIndex(rawValue: indexPath.row) ?? .rooms
            cell.baseStep = self.baseStep
            cell.nameLbl.text = listTitle[indexPath.row]
            cell.countLbl.tag = indexPath.row
            cell.plusBtn.PlusMinusLayout()
            cell.minusBtn.PlusMinusLayout()
            cell.plusBtn.tag = indexPath.row
            cell.minusBtn.tag = indexPath.row
            
            
           
            if let value = self.baseStep.roomData.value(atSafeIndex: indexPath.row){
                cell.countLbl.text = value.description
            if baseStep.isEditSpace{
                cell.minusBtn.alpha = value  == 0 ? 0.5 : 1.0
                cell.plusBtn.alpha = value == 999 ? 0.5 : 1.0
            }else{
                cell.plusBtn.alpha = 1.0
                cell.minusBtn.alpha = 0.5
                }
            }
                
            
            
            
            //Mark:- Adding Rooms,RestRooms,FloorNumber plusButton Action
            cell.plusBtn.addTap {
                
                if self.baseStep.roomData.value(atSafeIndex: indexPath.row) != 0 &&  (self.baseStep.roomData[indexPath.row] < 998){
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 0.5
                    self.baseStep.roomData[indexPath.row] = self.baseStep.roomData[indexPath.row] + 1
                    cell.countLbl.text = self.baseStep.roomData[indexPath.row].description
                    cell.minusBtn.alpha = self.baseStep.roomData[indexPath.row]  == 0 ? 0.5 : 1.0
                    cell.PlusMinusInter()
                }else if self.baseStep.roomData[indexPath.row] == 998{
                    cell.plusBtn.alpha = 0.5
                    cell.minusBtn.alpha = 1.0
                    self.baseStep.roomData[indexPath.row] = self.baseStep.roomData[indexPath.row] + 1
                    cell.countLbl.text = self.baseStep.roomData[indexPath.row].description
                    cell.MinusInter()
                }else{
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 1.0
                    self.baseStep.roomData[indexPath.row] = self.baseStep.roomData[indexPath.row] + 1
                    cell.countLbl.text = self.baseStep.roomData[indexPath.row].description
                    cell.minusBtn.alpha = self.baseStep.roomData[indexPath.row]  == 0 ? 0.5 : 1.0
                    cell.PlusInter()
                }
            }
            
            //Mark:- Subtracting Rooms,RestRooms,FloorNumber plusButton Action
            cell.minusBtn.addTap {
                if self.baseStep.roomData[indexPath.row] != 0 &&  (self.baseStep.roomData[indexPath.row] < 999){
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 1.0
                    self.baseStep.roomData[indexPath.row] = self.baseStep.roomData[indexPath.row] - 1
                    cell.countLbl.text = self.baseStep.roomData[indexPath.row].description
                    cell.minusBtn.alpha = self.baseStep.roomData[indexPath.row]  == 0 ? 0.5 : 1.0
                    cell.PlusMinusInter()
                    
                }else if self.baseStep.roomData[indexPath.row] == 999{
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 1.0
                    self.baseStep.roomData[indexPath.row] = self.baseStep.roomData[indexPath.row] - 1
                    cell.countLbl.text = self.baseStep.roomData[indexPath.row].description
                    cell.PlusMinusInter()
                }else{
                    cell.plusBtn.alpha = 1.0
                    cell.minusBtn.alpha = 0.5
                    let minusVal = self.baseStep.roomData[indexPath.row]
                    cell.countLbl.text = minusVal.description
                    cell.minusBtn.alpha = self.baseStep.roomData[indexPath.row]  == 0 ? 0.5 : 1.0
                    cell.PlusInter()
                }
            }
            
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



extension RoomListSquareFtTVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return count <= 6 && allowedCharacters.isSuperset(of: characterSet)
       
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.baseStep.isEditSpace{
            self.baseStep.squareFeet = (textField.text?.toInt())!
            if self.baseStep.squareFeet == 0{
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 0.5
                self.PlusInter()
            }else if self.baseStep.squareFeet == 999999{
                self.plusBtn.alpha = 0.5
                self.minusBtn.alpha = 1.0
                self.MinusInter()
            }else if (self.baseStep.squareFeet > 0) &&  (self.baseStep.squareFeet < 999999){
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 1.0
                self.PlusMinusInter()
            }
        }else{
            self.baseStep.footageSpace = (textField.text?.toInt())!
            if self.baseStep.footageSpace == 0{
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 0.5
                self.PlusInter()
            }else if self.baseStep.footageSpace == 999999{
                self.plusBtn.alpha = 0.5
                self.minusBtn.alpha = 1.0
                self.MinusInter()
            }else if (self.baseStep.footageSpace > 0) &&  (self.baseStep.footageSpace < 999999){
                self.plusBtn.alpha = 1.0
                self.minusBtn.alpha = 1.0
                self.PlusMinusInter()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.baseStep.isEditSpace{
            self.baseStep.squareFeet = (textField.text?.toInt())!
        }else{
            self.baseStep.footageSpace = (textField.text?.toInt())!
        }
    }
    
}
extension RoomListTVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return count <= 3 && allowedCharacters.isSuperset(of: characterSet)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.baseStep.roomData[textField.tag] = (textField.text?.toInt())!
        if self.baseStep.roomData[textField.tag] == 0{
            self.plusBtn.alpha = 1.0
            self.minusBtn.alpha = 0.5
            self.PlusInter()
        }else if self.baseStep.roomData[textField.tag] == 999{
            self.plusBtn.alpha = 0.5
            self.minusBtn.alpha = 1.0
            self.MinusInter()
        }else if (self.baseStep.roomData[textField.tag] > 0) &&  (self.baseStep.roomData[textField.tag] < 999){
            self.plusBtn.alpha = 1.0
            self.minusBtn.alpha = 1.0
            self.PlusMinusInter()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.baseStep.isEditSpace{
            self.baseStep.roomData[textField.tag] = (textField.text?.toInt())!
        }else{
            self.baseStep.roomData[textField.tag] = (textField.text?.toInt())!
        }
    }
   
    
}
extension UIButton{
    
    //Mark:- PlusMinus Button Round layer
    func PlusMinusLayout(){
        self.titleLabel?.font =  UIFont(name: Fonts.CIRCULAR_BOOK, size: 20)
        self.titleLabel?.textColor =  UIColor.appGuestThemeColor
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.borderWidth = 1.0
        self.borderColor = UIColor.appGuestThemeColor
    }
    
    //Mark:- Button AppHostColor with Circular font
    func setfontDesign(){

        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor.init(hex: "FF0F29")
        self.titleLabel?.font = UIFont(name: Fonts.CIRCULAR_BOLD, size: 15.0)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.isElevated = true
    }
    
}

