//
//  AccessibilityViewController.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class AccessibilityViewController: UIViewController {
    @IBOutlet weak var accessTableView: UITableView!
    
    @IBOutlet weak var lblGuestAccess: UILabel!
    
    @IBOutlet weak var cnsrtGustTble: NSLayoutConstraint!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var accessibilityProgress: UIProgressView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var lblHelpTit: UILabel!
    
    @IBOutlet weak var lblPeopleDesc: UILabel!
    
    @IBOutlet weak var lblList: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    //var basicStp : BasicStpData?
    var bsicStp = BasicStpData()
    var basicStp = BasicStpData()
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var guestAccess = [BasicStpData]()
    var selectedVal = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViewLayoutAction()
        self.GetBasicStepsService()
        if basicStp.isEditSpace{
            if self.bsicStp.guestAccess != ""{
               self.bsicStp.getVal(self.bsicStp.guestAccess)
            }else{
               self.bsicStp.getVal(self.basicStp.guestAccess)
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cnsrtGustTble.constant = self.accessTableView.contentSize.height
    }
    class func InitWithStory()-> AccessibilityViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "AccessibilityViewController") as! AccessibilityViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bsicStp.currentScreenState = .accessibility
    }
    
    func alphaContinueAct(){
        
        let guestAccess = self.guestAccess.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
        var provideDict = [String:Any]()
        provideDict["address_line_1"] = self.basicStp.addressLine1
        
        provideDict["address_line_2"] = self.basicStp.addressLine2
        provideDict["city"] = self.basicStp.city
        provideDict["country"] = self.basicStp.country
        provideDict["country_name"] = self.basicStp.countryName
        provideDict["guidance"] = self.basicStp.guidance
        provideDict["state"] = self.basicStp.state
        
        provideDict["latitude"] = self.basicStp.latitude
        provideDict["longitude"] = self.basicStp.longitude
        provideDict["postal_code"] = self.basicStp.postalCode
        
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["location_data"] = self.sharedUtility.getJsonFormattedString(provideDict)

        parameter["space_type"] = self.bsicStp.spaceId.description
        parameter["guest_access"] = guestAccess
        parameter["number_of_guests"] = self.bsicStp.noofGuest
        parameter["no_of_workstations"] = self.bsicStp.noOfWorkstations.description
        parameter["shared_or_private"] = self.bsicStp.sharedPrivate
        parameter["renting_space_firsttime"] = self.bsicStp.rentingSpaceFirstTime
        parameter["fully_furnished"] = self.bsicStp.fullyFurnished
        parameter ["amenities"] = self.bsicStp.amenitiesList
        parameter["services_extra"] = self.bsicStp.extServices
        parameter["services"] = self.bsicStp.servicesList
        
        parameter["size_type"] = self.bsicStp.sizeType  == "" ? self.bsicStp.spaceTypeVal : self.bsicStp.sizeType
        parameter["sq_ft"] = self.bsicStp.footageSpace.description
        print("Parameter",parameter)
        
        //APIMethodsEnum.createSpace
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    
                    MakentSupport().removeProgress(viewCtrl: self)
                    BasicStpData.shared.spaceID = _json.int("space_id").description
                    self.MoveToNext()
                    
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
                    
                }
            }
            
        }
        
        
    }
    
    func GetBasicStepsService(){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["step"] = "basics"
        parameter["space_id"] = BasicStpData.shared.spaceID
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
                    
                    self.guestAccess.removeAll()
                    self.guestAccess = _json.array("guest_accesses").compactMap({BasicStpData($0)})
                    
                    self.accessTableView.reloadData()
                    
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
    
     func ContinueAction(){
         print(self.guestAccess.filter({$0.isSelected}).compactMap({$0.id}))
         print(self.guestAccess.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ","))//Comma Separator
        
        var parameter = [String : Any]()
        let guestAccess = self.guestAccess.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
         parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["step"] = "basics"
        parameter["guest_access"] =  guestAccess
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
                    self.MoveToNext()
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
        
        self.accessTableView.register(UINib(nibName: "AccessTVC", bundle: nil), forCellReuseIdentifier: "AccessTVC")
        self.accessTableView.reloadData()
        self.lblGuestAccess.attributedText  = self.coloredAttributedText(normal: self.lang.spaceAccessTitle, self.lang.asteriskSymbol)
        self.accessibilityProgress.transform = self.accessibilityProgress.transform.scaledBy(x: 1, y: 3)
        self.accessibilityProgress.setProgress(0.32, animated: true)
        //self.lblHelpTit.text = self.lang.hlpEveOrg
        self.lblHelpTit.text = self.lang.getStartList
        self.lblPeopleDesc.text = self.lang.peopSearch + " " + k_AppName + " " + self.lang.mthNeeds
        self.lblList.text = self.lang.listings_Title
        self.addBackButton()
        self.bsicStp.currentScreenState = .accessibility
        self.continueBtn.setfontDesign()
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        //self.continueBtn.addTarget(self, action: #selector(NextView), for: .touchUpInside)
        self.continueBtn.addTap {
            if self.notSelectedAlert(){
                
                self.NextView()
            }
        }
        //print("seletedVal:",self.guestAccess.filter({$0.isSelected}).compactMap({$0.id}).isEmpty)
    }
    
    //Mark:- Alert For No More Values Selected
    
    func notSelectedAlert()->Bool{
        if self.guestAccess.filter({$0.isSelected}).compactMap({$0.id}).isEmpty{
            self.appDelegate.createToastMessage(self.lang.spaceAccessAlert, isSuccess: false)
            return false
        }
        return true
    }
    
    func MoveToNext(){
        
        
        if self.basicStp.isEditSpace{
            self.navigationController?.removeProgress()
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.navigationController?.removeProgress()
            let dashboardVC = AddSpaceViewController.InitWithStory()
            self.navigationController?.pushViewController(dashboardVC, animated: true)
        }
       
//        let spaceGuest = SpaceGuestViewController.InitWithStory()
//
//        if self.bsicStp.isEditSpace{
//
//          spaceGuest.basicStps.isEditSpace = self.bsicStp.isEditSpace
//        }
//        spaceGuest.basicStps = self.bsicStp
//        self.navigationController?.pushViewController(spaceGuest, animated: true)
        
    }
    
    
    
    //Mark:- Next Button Action
    @objc func NextView(){
        if basicStp.isEditSpace{
            self.ContinueAction()
            
        }else{
            self.alphaContinueAct()
 
        }
    }
    @objc func CloseAct(){
        self.navigationController?.popViewController(animated: true)
    }

    

}
extension AccessibilityViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard guestAccess.count > 0 else {return 0}
        return guestAccess.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessTVC", for: indexPath) as! AccessTVC
        guard guestAccess.count > indexPath.row else {return cell}
        let guestData = self.guestAccess[indexPath.row]
        
            cell.txtLbl.text = guestData.name
        
        
            if self.bsicStp.selectedVal.contains(obj: self.guestAccess[indexPath.row].id){
            self.guestAccess[indexPath.row].isSelected = true
            }
      
            cell.isChecked = self.guestAccess[indexPath.row].isSelected
        
        cell.selectDataBtn.addTap {
            cell.isChecked = !cell.isChecked

            self.guestAccess[indexPath.row].isSelected = !self.guestAccess[indexPath.row].isSelected
            self.bsicStp.guesAccessList = self.guestAccess.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
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
/*func findIndex<T: Equatable>(of valueToFind: T, in array:[T])  {
 for (index, value) in array.enumerated() {
 if value == valueToFind {
 
 }
 }
 
//Mark:- Getting Selected Values While Edit
//    func getVal(){
//
//        let guestAccess = self.bsicStp.guestAccess
//        let StringRecordedArr = guestAccess.components(separatedBy: ",")
//        print(StringRecordedArr.compactMap({($0 as NSString).integerValue}))
//        self.bsicStp.selectedVal = StringRecordedArr.compactMap({($0 as NSString).integerValue})
//        print("SelectedValues:",self.bsicStp.selectedVal)
//
//    }
 
 
 }*/
