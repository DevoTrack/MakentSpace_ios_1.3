//
//  SpaceFeaturesViewController.swift
//  Makent
//
//  Created by trioangle on 28/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

enum setupSpace : String {
    case style
    case feature
    case rules
    func SpaceVal() ->String { return self.rawValue }
}

class SpaceFeaturesViewController: UIViewController {

    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var cnstrtFeatureTble: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var spaceFeatureTable: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.localizedInstance()
    
    var styleList = [BasicStpData]()
    var featureList = [BasicStpData]()
    var rulesList = [BasicStpData]()
    var bsicStp = BasicStpData()
    var setupSpc : setupSpace!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViewLayoutAction()
        self.GetBasicStepsService()
        if bsicStp.isEditSpace{
            if self.setupSpc == .style{
                self.bsicStp.getVal(self.bsicStp.spaceStyle)
            } else if self.setupSpc == .feature{
                self.bsicStp.getVal(self.bsicStp.spaceFeatures)
            }else{
                self.bsicStp.getVal(self.bsicStp.spaceRules)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cnstrtFeatureTble.constant = self.spaceFeatureTable.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.setupSpc == .style{
            self.bsicStp.crntScreenSetupState = .spaceStyle
            self.bsicStp.getVal(self.bsicStp.spaceStyle)
        }else if self.setupSpc == .feature{
            self.bsicStp.crntScreenSetupState = .spaceFeatures
            self.bsicStp.getVal(self.bsicStp.spaceFeatures)
        }else if self.setupSpc == .rules{
            self.bsicStp.crntScreenSetupState = .spaceRules
            self.bsicStp.getVal(self.bsicStp.spaceRules)
        }
    }
    
    func initViewLayoutAction(){
        titleLabel.TitleFont()
        descLabel.DescFont()
        if self.setupSpc == .style{
            titleLabel.text = "The style of my space can be described as..."//self.lang.spcStyleDesc
            //descLabel.text = "Event organizers often search and filter by style Including the right style tags can help connect you with the right bookings."
            self.bsicStp.crntScreenSetupState = .spaceStyle
            //self.setupSpc = .feature
        }else if self.setupSpc == .feature{
            titleLabel.text = "Does your space have any of the below special features ?"//self.lang.spcFeatDesc
            //descLabel.text = "The features that you select will show up as tags in your listing allowing event organizers to easily search for and find spaces with the features they’re looking for."
            self.bsicStp.crntScreenSetupState = .spaceFeatures
           // self.setupSpc = .rules
        }else if self.setupSpc == .rules{
            titleLabel.text = "Got any rules you need guests to respect? Please tick all that apply."//self.lang.spcRulesDesc
           // descLabel.text = "In addition to the Splacer guidelines, event organizers must agree to your space rules before they book."
            self.bsicStp.crntScreenSetupState = .spaceRules
        }
        spaceFeatureTable.register(UINib(nibName: "AccessTVC", bundle: nil), forCellReuseIdentifier: "AccessTVC")
        self.backButton()
        spaceFeatureTable.reloadData()
        self.continueBtn.setfontDesign()
        self.continueBtn.addTap {
            self.NextAct()
        }
        
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
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
    class func InitWithStory()-> SpaceFeaturesViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceFeaturesViewController") as! SpaceFeaturesViewController
    }

    func ContinueAct(){
      if self.setupSpc == .style{
            let spaceFeaut = SpaceFeaturesViewController.InitWithStory()
            spaceFeaut.setupSpc = .feature
        if self.bsicStp.isEditSpace{
            spaceFeaut.bsicStp = self.bsicStp
            spaceFeaut.bsicStp.isEditSpace = self.bsicStp.isEditSpace
        }
            self.navigationController?.pushViewController(spaceFeaut, animated: true)
        }
        else if self.setupSpc == .feature{
            let spaceFeaut1 = SpaceFeaturesViewController.InitWithStory()
            spaceFeaut1.setupSpc = .rules
        if self.bsicStp.isEditSpace{
            spaceFeaut1.bsicStp = self.bsicStp
            spaceFeaut1.bsicStp.isEditSpace = self.bsicStp.isEditSpace
        }
            self.navigationController?.pushViewController(spaceFeaut1, animated: true)
      }else{
            let spaceDesc = SpaceDescriptionViewController.InitWithStory()
        if self.bsicStp.isEditSpace{
            spaceDesc.bsicStp = self.bsicStp
            spaceDesc.bsicStp.isEditSpace = self.bsicStp.isEditSpace
        }
            self.navigationController?.pushViewController(spaceDesc, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func NextAct(){
        
        print(self.styleList.filter({$0.isSelected}).compactMap({$0.id}))
        print(self.styleList.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ","))//Comma Separator
       
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["step"] = "setup"
        if self.setupSpc == .style{
        let styleList = self.styleList.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
        parameter ["space_style"] = styleList
        } else if self.setupSpc == .feature{
            let featureList = self.featureList.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
            parameter ["special_feature"] = featureList
        }else{
            let rulesList = self.rulesList.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
            parameter ["space_rules"] = rulesList
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
    func GetBasicStepsService(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .setupItems, params: parameter) { ( json, error) in
            if let _ = error{
                
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                MakentSupport().removeProgress(viewCtrl: self)
            }else{
                MakentSupport().removeProgress(viewCtrl: self)
                if let _json = json,
                    _json.isSuccess{
                    
                    //Mark:- Assigning SpaceType Values into model using compactMap
                    print(_json)
                    self.styleList = _json.array("space_styles").compactMap({BasicStpData($0)})
                    self.featureList = _json.array("special_features").compactMap({BasicStpData($0)})
                    self.rulesList = _json.array("space_rules").compactMap({BasicStpData($0)})
                    
                    self.spaceFeatureTable.reloadData()
                    
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

}
extension SpaceFeaturesViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setupSpc == .style{
            return self.styleList.count
        }else if setupSpc == .feature{
           return self.featureList.count
        }else{
            return self.rulesList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessTVC", for: indexPath) as! AccessTVC
        if setupSpc == .style{
            guard styleList.count > 0 else{return cell}
            let style = styleList[indexPath.row]
            cell.txtLbl.text = style.name
            if self.bsicStp.selectedVal.contains(obj: self.styleList[indexPath.row].id){
                self.styleList[indexPath.row].isSelected = true
            }
            cell.isChecked = self.styleList[indexPath.row].isSelected
            cell.selectDataBtn.addTap {
                cell.isChecked = !cell.isChecked
                self.styleList[indexPath.row].isSelected = !self.styleList[indexPath.row].isSelected
                self.bsicStp.styleList = self.styleList.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
            }
        }else if setupSpc == .feature{
            guard featureList.count > 0 else{return cell}
            let style = featureList[indexPath.row]
            cell.txtLbl.text = style.name
            
            if self.bsicStp.selectedVal.contains(obj: self.featureList[indexPath.row].id){
                self.featureList[indexPath.row].isSelected = true
            }
            cell.isChecked = self.featureList[indexPath.row].isSelected
            cell.selectDataBtn.addTap {
                cell.isChecked = !cell.isChecked
                self.featureList[indexPath.row].isSelected = !self.featureList[indexPath.row].isSelected
                self.bsicStp.featureList = self.featureList.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
            }
        }else{
            guard rulesList.count > 0 else{return cell}
            let style = rulesList[indexPath.row]
            cell.txtLbl.text = style.name
            
            if self.bsicStp.selectedVal.contains(obj: self.rulesList[indexPath.row].id){
                self.rulesList[indexPath.row].isSelected = true
            }
            cell.isChecked = self.rulesList[indexPath.row].isSelected
            cell.selectDataBtn.addTap {
                cell.isChecked = !cell.isChecked
                self.rulesList[indexPath.row].isSelected = !self.rulesList[indexPath.row].isSelected
                self.bsicStp.rulesList = self.rulesList.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
}

//    //Mark:- Getting Selected Values While Edit
//    func getVal(){
//        if self.setupSpc == .style{
//            let guestAccess = self.bsicStp.spaceStyle
//            let StringRecordedArr = guestAccess.components(separatedBy: ",")
//            print(StringRecordedArr.compactMap({($0 as NSString).integerValue}))
//            self.bsicStp.selectedVal = StringRecordedArr.compactMap({($0 as NSString).integerValue})
//            print("SelectedValues:",self.bsicStp.selectedVal)
//        }
//        else if self.setupSpc == .feature{
//            let guestAccess = self.bsicStp.spaceFeatures
//            let StringRecordedArr = guestAccess.components(separatedBy: ",")
//            print(StringRecordedArr.compactMap({($0 as NSString).integerValue}))
//            self.bsicStp.selectedVal = StringRecordedArr.compactMap({($0 as NSString).integerValue})
//            print("SelectedValues:",self.bsicStp.selectedVal)
//        }else{
//            let guestAccess = self.bsicStp.spaceRules
//            let StringRecordedArr = guestAccess.components(separatedBy: ",")
//            print(StringRecordedArr.compactMap({($0 as NSString).integerValue}))
//
//            self.bsicStp.selectedVal = StringRecordedArr.compactMap({($0 as NSString).integerValue})
//            print("SelectedValues:",self.bsicStp.selectedVal)
//        }
//        }
