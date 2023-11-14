//
//  AddSpaceViewController.swift
//  Makent
//
//  Created by trioangle on 24/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class AddSpaceViewController: UIViewController {

  
    
    @IBOutlet var spaceHeaderView: UIView!
    
    @IBOutlet weak var addSpaceTable: UITableView!
    
    @IBOutlet var spaceFooterView: UIView!
    
    @IBOutlet weak var hostSpaceTitle: UILabel!
    
    @IBOutlet weak var hostSpaceDesc: UILabel!
    
    @IBOutlet weak var hostProgress: UIProgressView!
    
    @IBOutlet weak var hostDoneDesc: UILabel!
    
    @IBOutlet weak var previewBtn: UIButton!
    
    @IBOutlet weak var hostStatusBtn: UIButton!
    
    var spaceTitle = [String]()
    let lang = Language.localizedInstance()
    var spaceDetails = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fromChoose = Bool()
   
    var basicData = BasicStpData()
    var setupData = BasicStpData()
    var readyHostData: ReadyToHost!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ViewLayoutDesign()
        if fromChoose{
            self.dismiss(animated: false, completion: nil)
        }
        self.hostProgress.layer.cornerRadius = 3.0
        self.hostProgress.transform = self.hostProgress.transform.scaledBy(x: 1, y: 3)
        self.previewBtn.addTap {
            let homeDetailVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "homeDetailViewController") as! HomeDetailViewController
            homeDetailVC.roomIDString = BasicStpData.shared.spaceID
            homeDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeDetailVC, animated: true)
        }
        addSpaceTable.register(UINib(nibName: "SpaceHomeCell", bundle: nil), forCellReuseIdentifier: "SpaceHomeCell")
        spaceTitle = ["\(1.localize)."+self.lang.basic_Title,"\(2.localize)."+self.lang.set_Title,"\(3.localize)." + "Preparing to host"]
        //self.lang.readytohost_Title
        spaceDetails = [self.lang.spacegues_Title,self.lang.photospac_Title,self.lang.pricavail_Title]
        addSpaceTable.reloadData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.GetSpaceStepsService()
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    class func InitWithStory()-> AddSpaceViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "AddSpaceViewController") as! AddSpaceViewController
    }
    func ViewLayoutDesign(){
        print("user first name",Constants().GETVALUE(keyname: APPURL.USER_FIRST_NAME) as String)
        self.hostSpaceTitle.text = Constants().GETVALUE(keyname: APPURL.USER_FIRST_NAME) as String + self.lang.hostspc_Title
        self.hostSpaceTitle.text =  self.lang.hostspc_Title
        self.hostSpaceDesc.text = self.lang.hostspc_Desc
        
        self.previewBtn.setTitle(self.lang.prev_Tit, for: .normal)
        self.addBackButton()
        print("FrameHeight:",self.view.frame.height)
//        if self.basicData.isEditSpace{
//            self.addDismissButton()
//        }else{
            self.DismissButton()
//        }
        self.navigationController?.addProgress()
        hostStatusBtn.borderColor = UIColor.lightGray
        hostStatusBtn.borderWidth = 1.0
        self.previewBtn.layer.cornerRadius = 5
        self.previewBtn.clipsToBounds = true
        self.hostStatusBtn.layer.cornerRadius = 5
        self.hostStatusBtn.clipsToBounds = true
        
        
        //self.hostProgress.setProgress(Float(val/100.0), animated: true)
    }
    func DismissButton() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "Back")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (DismissClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func DismissClick(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
    }
    func setProgressText(){
        if self.rawVal == "en"{
            self.hostDoneDesc.text = self.lang.hostspc_Done + " \(self.basicData.completed.localize)" + self.lang.percen_Sym + " " + self.lang.done_Title.lowercased()
        }else{
            self.hostDoneDesc.text = self.lang.hostspc_Done + self.lang.percen_Sym + " \(self.basicData.completed.localize)" + " " + self.lang.done_Title.lowercased()
        }
    }
    
    func GetSpaceStepsService(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .spaceListDetails, params: parameter) { ( json, error) in
            if let _ = error{
                
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                MakentSupport().removeProgress(viewCtrl: self)
            }else{
                MakentSupport().removeProgress(viewCtrl: self)
                if let _json = json,
                    _json.isSuccess{
                    
                    //Mark:- Assigning SpaceType Values into model using compactMap
                    print(_json)
                    
                    let basicValues = _json.json("basics")
                    self.basicData = BasicStpData(basicValues)
                    
                    let setupValues = _json.json("setup")
                    self.setupData = BasicStpData(setupValues)
                    print(self.setupData.addressLine1)
                    
                    let readyHostValues = _json.json("ready_to_host")
                    self.readyHostData = ReadyToHost(readyHostValues)
                    
                    self.sharedVariable.readyToHostStep = self.readyHostData
                    
                    let val = _json.int("completed")
                    self.basicData.completed = val
                    print("completed:",val)
                    
                    let adminSts = _json.string("admin_status")
                    self.hostStatusBtn.setTitle(adminSts, for: .normal)
                    self.hostProgress.setProgress(Float(Float(val)/100.0), animated: true)
                    self.setProgressText()
                    self.addSpaceTable.reloadData()
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func addSpaceBackButton() {
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
    

}
extension AddSpaceViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.readyHostData != nil {
             return spaceTitle.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return spaceHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
            //self.view.frame.height * 0.17
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return spaceFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
        //self.view.frame.height * 0.10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        // self.view.frame.height * 0.16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceHomeCell", for: indexPath) as! SpaceHomeCell
        cell.spaceStepTitle.text = spaceTitle[indexPath.row]
        cell.spaceStepDetail.text = spaceDetails[indexPath.row]
        
        cell.checkImage.image = cell.checkImage.image?.withRenderingMode(.alwaysTemplate)
        cell.checkImage.tintColor = .lightGray
        
        let index = indexPath.row
        switch index {
        case 0:
            print("basicStatus",self.basicData.status)
            if self.basicData.status == "completed"{
                cell.lblStpsCmplt.text = ""//self.basicData.status
                cell.editBtn.isHidden = true
                cell.btnChange.setTitle("Need to make a change?", for: .normal)
                cell.checkImage.tintColor = .appGuestThemeColor
            }else{
                cell.editBtn.isHidden = true
                cell.btnChange.isHidden = true
                if self.basicData.remain_Stps > 0{
                if self.basicData.remain_Stps == 1{
                cell.lblStpsCmplt.text = self.basicData.remain_Stps.localize + " " + self.lang.mrStpTit
                cell.editBtn.setTitle(self.lang.continue_Title, for: .normal)
                }else{
                cell.lblStpsCmplt.text = self.basicData.remain_Stps.localize + " " + self.lang.mrStpsTit
                cell.editBtn.setTitle(self.lang.continue_Title, for: .normal)
                }
                }else{
                    cell.lblStpsCmplt.text = ""
                }
            }
            cell.btnChange.addTap{
//                DispatchQueue
                self.callBasicStepData()
            }
             break
        case 1:
            print("setupStatus",self.setupData.remain_Stps)
            if self.setupData.status == "completed"{
                cell.lblStpsCmplt.text = ""
                cell.editBtn.setTitle(self.lang.edit_Title, for: .normal)
                cell.checkImage.tintColor = .appGuestThemeColor
                cell.btnChange.isHidden = true
            }else{
                cell.btnChange.isHidden = true
                if self.setupData.remain_Stps > 0{
                if self.setupData.remain_Stps == 1{
                    cell.lblStpsCmplt.text = self.setupData.remain_Stps.localize + " " + self.lang.mrStpTit
                    cell.editBtn.setTitle(self.lang.continue_Title, for: .normal)
                }else{
                    cell.lblStpsCmplt.text = self.setupData.remain_Stps.localize + " " + self.lang.mrStpsTit
                    cell.editBtn.setTitle(self.lang.continue_Title, for: .normal)
                }
                }else{
                    cell.lblStpsCmplt.text = ""
                }
            }
            cell.editBtn.addTap {
                
               self.callPhotoStepData()
                
            }
             break
        case 2:
            
            if self.readyHostData.status == "completed"{
                cell.lblStpsCmplt.text = ""
                cell.editBtn.setTitle(self.lang.edit_Title, for: .normal)
                cell.checkImage.tintColor = .appGuestThemeColor
                cell.btnChange.isHidden = true
            }else{
                cell.btnChange.isHidden = true
                 if self.readyHostData.remaining_steps > 0{
                if self.readyHostData.remaining_steps == 1{
                    cell.lblStpsCmplt.text = self.readyHostData.remaining_steps.localize + " " + self.lang.mrStpTit
                    cell.editBtn.setTitle(self.lang.continue_Title, for: .normal)
                }else{
                    cell.lblStpsCmplt.text = self.readyHostData.remaining_steps.localize + " " + self.lang.mrStpsTit
                    cell.editBtn.setTitle(self.lang.continue_Title, for: .normal)
                }
                 }else{
                    cell.lblStpsCmplt.text = ""
                }
            }
             cell.editBtn.addTap {
//            let hostListStep = SpaceAvailabilityViewController.InitWithStory()
            let hostListStep = HostActivityStepsViewController.InitWithStory()
            hostListStep.selectedActivitiesModel = self.sharedHostSteps.activity_types
            
            self.navigationController?.navigationBar.isHidden = false
            
            self.navigationController?.pushViewController(hostListStep, animated: true)
             }
             break
                
        default:
            print("Default")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func callBasicStepData() {
        let typeSpace = TypeSpaceViewController.InitWithStory()
        typeSpace.bsicStep = self.basicData
        typeSpace.bsicStep.isEditSpace = true
        //self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(typeSpace, animated: true)
    }
    
    func callPhotoStepData() {
        let photoSpace = AddSpacePhotoViewController.InitWithStory(isToEdit: true)
        photoSpace.photoData = self.setupData
        photoSpace.photoData.isEditSpace = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(photoSpace, animated: true)
    }
    
}
