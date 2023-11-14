//
//  HostActivityStepsViewController.swift
//  Makent
//
//  Created by trioangle on 28/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HostActivityStepsViewController: UIViewController {
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var headerSubTitleLbl: UILabel!
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    let baseStep  = BasicStpData()
    let lang = Language.localizedInstance()
    
    var totalActivitiesModel = [ActivitiesType]()
    var selectedActivitiesModel = [ActivitiesType]() //get old and after update selection
    var selectedMainActivites = [MainActivitiesModel]()
    var selectedCollectionViewIndexPath:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
//        self.titleCollectionView.delegate =
       self.wsToGetHostStepsDetails()
        // Do any additional setup after loading the view.
    }
    
    
    
    func initView() {
        self.headerTitleLbl.customFont(.bold)
        self.headerSubTitleLbl.customFont(.bold)
//        self.titleCollectionView.backgroundColor = .appTitleColor
        self.headerTitleLbl.text = "Which activities are welcome in your space?"
        self.headerSubTitleLbl.text = "Select activities from the lists below"
        self.backButton()
        self.continueBtn.setfontDesign()
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        self.navigationController?.addProgress()
        self.baseStep.crntScreenHostState = .activities
        self.continueBtn.addTarget(self, action: #selector(self.updateHostStepDetail), for: .touchUpInside)
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
        self.baseStep.crntScreenHostState = .activities
    }
    
    func ActivityAlert() -> Bool {
        _ = self.totalActivitiesModel.map({$0.updateSelected()})

        let mainActivities = self.totalActivitiesModel.map({$0.isSelected})
        if !mainActivities.contains(true){
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseSelectAtleastOneActivityFromList, isSuccess: false)
            return false
        }
        
        return true
    }
    
    class func InitWithStory()->HostActivityStepsViewController{
        return StoryBoard.Spacehostlist.instance.instantiateViewController(withIdentifier: "HostActivityStepsViewController") as! HostActivityStepsViewController
    }
    
    //Mark:- Api Data Set in Collection and TableView
    func wsToGetHostStepsDetails() {
        var params = JSONS()
        params["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: HostStepsAPIName.readyToHost.text, paramDict: params, viewController: self
        , isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                self.totalActivitiesModel.removeAll()

                responseDict.array("activity_types").forEach({ (tempJSON) in
                    let model = ActivitiesType(tempJSON)
                    self.totalActivitiesModel.append(model)
                })
                
                self.selectedActivitiesModel.forEach({ (tempModel) in
                    if let index = self.totalActivitiesModel.index(where:{$0.id ==  tempModel.id}) {
                        self.totalActivitiesModel[index] = tempModel
                    }
                })
                if !self.totalActivitiesModel.isEmpty {
                    self.totalActivitiesModel.first?.isColapsed = true
                    self.selectedMainActivites = self.totalActivitiesModel.first!.mainActivities
                    self.selectedCollectionViewIndexPath = IndexPath(row: 0, section: 0)
                }
                
                
                self.titleCollectionView.reloadData()
                
                self.reloadTable()
            }else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage, isSuccess: false)
            }
        }
    }
    
    
    
    @objc func updateHostStepDetail() {
        if self.ActivityAlert(){
            self.ActivityService()
        }
    }
    
    //Mark:- Api Pass Data From Selected Data
    func ActivityService(){
        var params = JSONS()
        params["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        params["space_id"] = BasicStpData.shared.spaceID
        params["step"] = "ready_to_host"
        let tempModel = self.totalActivitiesModel
        var tempParam = [JSONS]()
        tempModel.forEach { (model) in
//            model.updateSelected()
            if model.isSelected {
                var finalMainParam = [JSONS]()
                model.mainActivities.forEach({ (mainModel) in
                    
                    if mainModel.isSelected {
                        var mainParam = JSONS()
                        var finalSubParam = [JSONS]()
                        mainModel.subActivities.forEach({ (subModel) in
                            if subModel.isSelected{
                                finalSubParam.append(subModel.getAPIDict())
                            }
                            
                        })
                        mainParam.merge(dict: mainModel.getAPIDict())
                        mainParam["sub_activities"] = finalSubParam
                        
                        finalMainParam.append(mainParam)
                    }
                    
                })
                var activityParam = JSONS()
                activityParam.merge(dict: model.getAPIDict())
                activityParam["activities"] = finalMainParam
                tempParam.append(activityParam)
            }
            
        }
        params["activity_data"] = self.sharedUtility.getJsonFormattedString(tempParam)
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: HostStepsAPIName.updateActivities.text, paramDict: params, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            
            if responseDict.isSuccess {
                let model = HostStepPriceModel(json: responseDict)
                
                self.selectedActivitiesModel = self.totalActivitiesModel.filter({$0.isSelected})
                self.sharedHostSteps.activity_types = self.selectedActivitiesModel
                self.sharedHostSteps.activityPriceModel = model
                let hostPriceVC = HostStepPriceViewController.InitWithStory()
                hostPriceVC.hostActivityPrice = model
                self.navigationController?.pushView(viewController: hostPriceVC)
            }else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage, isSuccess: false)
            }
        }
    }
}

extension HostActivityStepsViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.selectedMainActivites.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return self.selectedMainActivites[section].subActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hostActivityTVC") as! HostActivityTVC
        let model = self.selectedMainActivites[indexPath.section].subActivities[indexPath.row]
        cell.activityLbl.text = model.name
        
        if model.isSelected {
             cell.activityImgView.image = CheckImage.checkBox.instance.first
        }else {
            cell.activityImgView.image = CheckImage.checkBox.instance.last
        }
        cell.activityImgView.tintColor = UIColor.appHostThemeColor
        
       
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: self.activityTableView.frame.width, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
        if self.selectedMainActivites[section].isSelected {
            imageView.image = self.checkBox.instance.first
        }else {
             imageView.image = self.checkBox.instance.last
        }
        imageView.tintColor = UIColor.appHostThemeColor
        
        let label = UILabel(frame: CGRect(x:45, y: 0, width: self.activityTableView.frame.width, height:30))
        
        label.text = self.selectedMainActivites[section].name
        label.textColor = .black
        headerview.backgroundColor = .white
        headerview.addSubview(imageView)
        headerview.addSubview(label)
        headerview.transForm()
        label.transForm()
        imageView.transForm()
        label.center.y = headerview.center.y
        headerview.addTap {
           self.onTapppedSection(section: section)
        }

        
        return headerview
    }
    
    func onTapppedSection(section:Int){
        let tempModel = self.selectedMainActivites[section]
        if !tempModel.isSelected {
            tempModel.isSelected = true
            let subActivities = tempModel.subActivities.map({$0.isSelected = true})
        }else {
            tempModel.isSelected = false
            let subActivities = tempModel.subActivities.map({$0.isSelected = false})
        }
        self.selectedMainActivites[section] = tempModel
        
        self.activityTableView.reloadSections(IndexSet(integer: section), with: .none)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedMainActivites[indexPath.section].subActivities[indexPath.row].isSelected = !self.selectedMainActivites[indexPath.section].subActivities[indexPath.row].isSelected
       
        if self.selectedMainActivites[indexPath.section].subActivities.filter({$0.isSelected}).count > 0 {
            self.selectedMainActivites[indexPath.section].isSelected = true
        }else {
            self.selectedMainActivites[indexPath.section].isSelected = false
        }
        self.titleCollectionView.scrollToItem(at: (IndexPath(item: indexPath.section, section: 0)), at: .centeredVertically, animated: false)
        tableView.reloadData()
    }
    
    
}




extension HostActivityStepsViewController:SubActivityPrototcol {
    func reloadTable() {
        self.activityTableView.reloadData()
    }
    
    
}


class HostActivityTVC: UITableViewCell {
    
  
    
    
    
    
   
    @IBOutlet weak var activityImgView: UIImageView!
    @IBOutlet weak var activityLbl: UILabel!
//    var delegate : SubActivityPrototcol?
//    var subActivityModel =  [HostStepBasicmodel]()
//
//    var isMainActivitySelect = Bool()
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return subActivityModel.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "hostSubActivityTVC") as! HostSubActivityTVC
//        let model = subActivityModel[indexPath.row]
//        cell.activityLbl.text = model.name
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = self.subActivityModel[indexPath.row]
//
//        if model.isSelected {
//            model.isSelected = false
//        }else {
//          model.isSelected = true
//        }
//
//        if  !self.subActivityModel.filter({$0.isSelected}).isEmpty {
//            self.isMainActivitySelect = true
//            self.delegate?.reloadTable()
//
//        }
//        tableView.reloadData()
//    }
    
}


extension HostActivityStepsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.totalActivitiesModel.isEmpty {
            return 0
        }
        return self.totalActivitiesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hostStepsCVC", for: indexPath) as! HostStepsCVC
        cell.titleLbl.text = self.totalActivitiesModel[indexPath.row].name
        if (self.selectedCollectionViewIndexPath != nil && self.selectedCollectionViewIndexPath == indexPath) || (self.selectedCollectionViewIndexPath == nil && self.totalActivitiesModel[indexPath.row].isColapsed ) {
            cell.parentView.appHostViewBGColor()
        } else {
            cell.parentView.backgroundColor = .lightText
        }
        
        cell.parentView.elevate(3.0)
        
        cell.titleLbl.textColor = k_BetaThemeColor
        cell.parentView.isRoundCorner = true
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.totalActivitiesModel[indexPath.row].name.count * 15 + 30

        return CGSize(width: width, height: 50)
    }
//    func colle
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let tempmodel = self.totalActivitiesModel
//        tempmodel.forEach { (temp) in
//            temp.isSelected = false
//        }
//        self.totalActivitiesModel = tempmodel
//       self.totalActivitiesModel =  self.totalActivitiesModel.map({$0.isSelected = true })
        self.selectedCollectionViewIndexPath = indexPath
        let model = self.totalActivitiesModel[indexPath.row]
        let select = model.isSelected
       
        self.totalActivitiesModel.map({$0.isColapsed = false})
       
        model.isColapsed = !select
        self.selectedMainActivites = model.mainActivities
        
        
        collectionView.reloadData()
        
        self.reloadTable()
    }
    
    
}

protocol SubActivityPrototcol {
    func reloadTable()
}

class HostSubActivityTVC: UITableViewCell {
    
    @IBOutlet weak var activityImgView: UIImageView!
    @IBOutlet weak var activityLbl: UILabel!
    
    
}

class HostStepsCVC: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        parentView.elevate(3.0)
//        self.backgroundColor = .lightGray
       
        titleLbl.customFont(.bold)
    }
}

enum HostStepsAPIName:String {
    case readyToHost = "ready_host_step_items"
    case updateActivities = "update_activities"
    case updateSpace = "update_space"
    case getMinAmount = "get_min_amount"
    var text:String {
        return self.rawValue
    }
}

extension Array:ArrayModel {
    
    mutating func updateApiModel<T:ArrayModel>(model:T,resposenDict:[JSONS]) ->[T]{
        var returnModel = [T]()
        returnModel.removeAll()
        resposenDict.forEach { (tempJSON) in
//            let model = model(tempJSON)
//            returnModel.append(model)
        }
        return returnModel
        
    }
}

protocol ArrayModel {
    associatedtype T
}

extension ArrayModel {
    typealias T = Self
}
