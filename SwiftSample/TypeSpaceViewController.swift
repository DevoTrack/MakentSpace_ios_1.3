//
//  TypeSpaceViewController.swift
//  Makent
//
//  Created by trioangle on 24/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit



class TypeSpaceViewController: UIViewController,UIPopoverPresentationControllerDelegate,PopoverViewControllerDelegate {

    @IBOutlet weak var lblHlpTit: UILabel!
    
    @IBOutlet weak var lblPeopSrch: UILabel!
    @IBOutlet weak var selectSpaceTypeView: UIView!
    
    @IBOutlet weak var lblTypSpc: UILabel!
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var continue_Btn: UIButton!
   
    @IBOutlet weak var lblListTit: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var basicStpMdl : BasicStpData?
    var bsicStep = BasicStpData()
    var id = ""
    var name = ""
    var spaceType = [BasicStpData]()
    
    @IBOutlet weak var ActivityLoader: UIActivityIndicatorView!
    
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = false
        self.ActivityLoader.isHidden = false
        self.ActivityLoader.startAnimating()
        self.ViewLayoutAction()
        
    }
    
    func messageData(selectedData: BasicStpData) {
        if selectedData.name != ""{
            self.selectLabel.text = selectedData.name
            self.selectLabel.textColor = .black
            bsicStep.spaceName = selectedData.name
            bsicStep.spaceId = selectedData.id
            if self.bsicStep.isEditSpace{
            BasicStpData.shared.spaceId = selectedData.id
            }
            self.name = selectedData.name
            bsicStep.spaceID = selectedData.id.description
            self.id = selectedData.id.description
        }else{
            let select = self.lang.select_Title
            self.selectLabel.text = select
            self.selectLabel.textColor = .lightGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bsicStep.currentScreenState = .typeSpace
    }
    class func InitWithStory()-> TypeSpaceViewController{
        let view = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "TypeSpaceViewController") as! TypeSpaceViewController
       
        return view
        
    }
    func ViewLayoutAction(){
        
        self.addBackButton()
        
        self.GetBasicStepsService()
        self.navigationController?.addProgress()
        self.bsicStep.currentScreenState = .typeSpace
        self.lblTypSpc.attributedText = self.coloredAttributedText(normal: self.lang.typeSpaceTitle, self.lang.asteriskSymbol)
        self.lblHlpTit.text = self.lang.hlpEveOrg
//        self.lblPeopSrch.text = self.lang.peopSearch + " " + k_AppName + " " + self.lang.mthNeeds
        self.lblPeopSrch.text = self.lang.peopSearchNew
        self.lblListTit.text = self.lang.listings_Title
        self.continue_Btn.setfontDesign()
        self.continue_Btn.setTitle(self.lang.continue_Title, for: .normal)
        self.continue_Btn.addTarget(self, action: #selector(NextView), for: .touchUpInside)
        self.selectSpaceTypeView.cornerRadius = 5
        self.selectSpaceTypeView.isElevated = true
        self.selectLabel.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 15.0)
        if self.bsicStep.isEditSpace{
            BasicStpData.shared.spaceId = self.bsicStep.spaceType.int("id")
        }
        //Mark:- PopView Action
        self.selectSpaceTypeView.addTap {
            let selectionVC = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "PopoverViewController") as! PopoverViewController
            selectionVC.preferredContentSize = CGSize(width: self.selectSpaceTypeView.frame.width, height: 300)
            selectionVC.modalPresentationStyle = .popover
            selectionVC.spaceType = self.spaceType
            selectionVC.popDel = self
            selectionVC.isType = true
            let popover: UIPopoverPresentationController = selectionVC.popoverPresentationController!
            popover.delegate = self
            let barBtnItem =  UIBarButtonItem(customView: self.selectSpaceTypeView)
            popover.barButtonItem = barBtnItem
            self.present(selectionVC, animated: true, completion: nil)
        }
        
    }
    
    func typeNameShow(){
        
        let name = self.bsicStep.spaceType.string("name")
        
        let val = self.spaceType.contains(where: {$0.name == name})
        self.name = name
        if val{
            self.selectLabel.text = name
            self.selectLabel.textColor = .black
        }else{
            let select = self.lang.select_Title
            self.selectLabel.text = select
            self.selectLabel.textColor = .lightGray
            if self.bsicStep.isEditSpace{
                self.appDelegate.createToastMessage(self.lang.selectedSpaceTypeIsDeActivatedByAdmin, isSuccess: false)
            }
        }
        
    }
    
    func GetBasicStepsService(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        
        WebServiceHandler().getWebService(wsMethod: .basicStepItems, params: parameter) { ( json, error) in
            if let _ = error{
                self.ActivityLoader.stopAnimating()
                self.ActivityLoader.isHidden = true
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                
            }else{
                self.ActivityLoader.stopAnimating()
                self.ActivityLoader.isHidden = true
                if let _json = json,
                    _json.isSuccess{
                    
                    //Mark:- Assigning SpaceType Values into model using compactMap
                    
                    self.spaceType = _json.array("space_types").compactMap({BasicStpData($0)})
                    self.typeNameShow()
                   
                }else{
                    
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    //Mark:- Update Api
     func ContinueAction(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["space_type"] = BasicStpData.shared.spaceId.description
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.MoveToNext()
                    
                }else{
                   print(json)
                   MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                }
            }
        }
    }
    
    //Mark:- Alert Function
    func emptyAlert() -> Bool{
        if self.selectLabel.text == self.lang.select_Title || (self.selectLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            self.appDelegate.createToastMessage(self.lang.spcAlert, isSuccess: false)
            return false
        }
        return true
    }
    
    
    //Mark:- Next Button Action
    @objc func NextView(){
        
        if self.emptyAlert(){
            
            if bsicStep.isEditSpace{
                self.ContinueAction()
            }else{
                self.MoveToNext()
            }
            
        }
    }
    
    //Mark:- Push To GuessAccess ViewController
    func MoveToNext(){
        let guestAccess = SpaceDescribeViewController.InitWithStory()//GuestAccessViewController.InitWithStory()
        
        if self.bsicStep.isEditSpace{
            
            guestAccess.baseStep.isEditSpace = self.bsicStep.isEditSpace
        }
        guestAccess.baseStep = self.bsicStep
        self.navigationController?.pushViewController(guestAccess, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
   

}
