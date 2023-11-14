//
//  SpaceAmenitiesViewController.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceAmenitiesViewController: UIViewController {
    @IBOutlet weak var spaceTableView: UITableView!
    
 
    @IBOutlet weak var cnstrtSpcTblViw: NSLayoutConstraint!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var lblHelp: UILabel!
    
    
    @IBOutlet weak var lblPeopleDesc: UILabel!
    
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var lblAmentDesc: UILabel!
    var basicStp = BasicStpData()
    var amenities = [BasicStpData]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViewLayoutAction()
        self.GetBasicStepsService()
        if basicStp.isEditSpace{
            self.basicStp.getVal(self.basicStp.amenities)
        }
    }
    
    class func InitWithStory()-> SpaceAmenitiesViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceAmenitiesViewController") as! SpaceAmenitiesViewController
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cnstrtSpcTblViw.constant = self.spaceTableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        basicStp.currentScreenState = .spaceAmenities
    }
    func initViewLayoutAction(){
        
        spaceTableView.register(UINib(nibName: "AccessTVC", bundle: nil), forCellReuseIdentifier: "AccessTVC")
       
        self.addBackButton()
        spaceTableView.reloadData()
        basicStp.currentScreenState = .spaceAmenities
        //self.lblHelp.text = self.lang.hlpEveOrg
        self.lblHelp.text = self.lang.getStartList
       
        self.lblPeopleDesc.text = self.lang.peopSearch + " " + k_AppName + " " + self.lang.mthNeeds
        self.lblList.text = self.lang.listings_Title
        self.lblAmentDesc.text = "Please select all of the amenities that can be found in your space. Tick as few or as many as are relevant"
            //self.lang.amentiesDesc
        
        self.continueBtn.setfontDesign()
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        continueBtn.addTap {
            if self.basicStp.isEditSpace{
                self.NextAct()
            }else{
                self.ContinueAct()
            }
        }
       
    }
    
//    //Mark:- Getting Selected Values While Edit
//    func getVal(){
//        
//        let guestAccess = self.basicStp.amenities
//        let StringRecordedArr = guestAccess.components(separatedBy: ",")
//        print(StringRecordedArr.compactMap({($0 as NSString).integerValue}))
//        self.basicStp.selectedVal = StringRecordedArr.compactMap({($0 as NSString).integerValue})
//        print("SelectedValues:",self.basicStp.selectedVal)
//        
//    }
    
    func ContinueAct(){
        let extraAmenities = ExtraServicesViewController.InitWithStory()
        extraAmenities.basicStp = self.basicStp
        if self.basicStp.isEditSpace{
            
            extraAmenities.basicStp.isEditSpace = self.basicStp.isEditSpace
        }
        self.navigationController?.pushView(viewController: extraAmenities)
    }
    
    func NextAct(){
        print(self.amenities.filter({$0.isSelected}).compactMap({$0.id}))
        print(self.amenities.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ","))//Comma Separator
        let guestAmenities = self.amenities.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["step"] = "basics"
        parameter ["amenities"] = guestAmenities
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
        WebServiceHandler().getWebService(wsMethod: .basicStepItems, params: parameter) { ( json, error) in
            if let _ = error{
                
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                MakentSupport().removeProgress(viewCtrl: self)
            }else{
                MakentSupport().removeProgress(viewCtrl: self)
                if let _json = json,
                    _json.isSuccess{
                    
                    //Mark:- Assigning SpaceType Values into model using compactMap
                    
                    
                    self.amenities = _json.array("amenities").compactMap({BasicStpData($0)})
                    self.spaceTableView.reloadData()
                    
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
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SpaceAmenitiesViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard amenities.count > 0 else {return 0}
        return amenities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessTVC", for: indexPath) as! AccessTVC
        guard amenities.count > 0 else {return cell}
        let amenties = amenities[indexPath.row]
        cell.txtLbl.text = amenties.name
        if self.basicStp.selectedVal.contains(obj: self.amenities[indexPath.row].id){
            self.amenities[indexPath.row].isSelected = true
        }
        cell.isChecked = self.amenities[indexPath.row].isSelected
        cell.selectDataBtn.addTap {
            cell.isChecked = !cell.isChecked
            self.amenities[indexPath.row].isSelected = !self.amenities[indexPath.row].isSelected
            self.basicStp.amenitiesList = self.amenities.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

