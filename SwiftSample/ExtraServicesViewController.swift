//
//  ExtraServicesViewController.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExtraServicesViewController: UIViewController {

   
    
    @IBOutlet weak var serviceTable: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
   
    @IBOutlet weak var tblCnstrntSrvc: NSLayoutConstraint!
    
    @IBOutlet weak var descView: UIView!
    
    @IBOutlet weak var additiInformTextView: UITextView!
    
    @IBOutlet weak var lblHelpTit: UILabel!
    
    @IBOutlet weak var lblPeopDesc: UILabel!
    
    @IBOutlet weak var lblListTit: UILabel!
    
    @IBOutlet weak var lblServiceDesc: UILabel!
    
    
    @IBOutlet weak var lblAddDesc: UILabel!
    
    var basicStp = BasicStpData()
    var services = [BasicStpData]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViewLayoutAction()
        if basicStp.isEditSpace{
            self.basicStp.getVal(self.basicStp.services)
            self.additiInformTextView.textColor = .black
            self.additiInformTextView.text! = self.basicStp.servicesExtra
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       self.basicStp.currentScreenState = .extraServices
    }
    
    class func InitWithStory()-> ExtraServicesViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "ExtraServicesViewController") as! ExtraServicesViewController
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.tblCnstrntSrvc.constant = CGFloat.init(self.serviceTable.contentSize.height)
        }
    }
    func initViewLayoutAction(){
        
        serviceTable.register(UINib(nibName: "AccessTVC", bundle: nil), forCellReuseIdentifier: "AccessTVC")
        serviceTable.reloadData()
        self.descView.layer.borderWidth = 1.0
        self.descView.borderColor = .lightGray
        self.descView.layer.cornerRadius = 5.0
        self.descView.clipsToBounds = true
        //self.lblHelpTit.text = self.lang.hlpEveOrg
        self.lblHelpTit.text = self.lang.getStartList
        self.lblPeopDesc.text = self.lang.peopSearch + " " + k_AppName + " " + self.lang.mthNeeds
        self.lblListTit.text = self.lang.listings_Title
        self.lblServiceDesc.text = "What services and extras can be found in your space"
        //self.lang.servDesc
        self.lblAddDesc.text = "If there is any additional information about the services you listed above, like available packages and/or rate options, please share more details below."
            //self.lang.addInfDesc
        self.additiInformTextView.placeTextHolder(holdVal: self.lang.additionalInf)
        self.basicStp.currentScreenState = .extraServices
        self.additiInformTextView.AlignText()
        self.additiInformTextView.delegate = self
        self.addBackButton()
        self.GetBasicStepsService()
        
        
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
  
    //Mark:- Getting Selected Values While Edit
//    func getVal(){
//        
//        let guestAccess = self.basicStp.services
//        let StringRecordedArr = guestAccess.components(separatedBy: ",")
//        print(StringRecordedArr.compactMap({($0 as NSString).integerValue}))
//        self.basicStp.selectedVal = StringRecordedArr.compactMap({($0 as NSString).integerValue})
//        print("SelectedValues:",self.basicStp.selectedVal)
//        self.additiInformTextView.text! = self.basicStp.servicesExtra
//        self.additiInformTextView.textColor = .black
//    }
    
    func ContinueAct(){
        
        self.basicStp.extServices = self.additiInformTextView.text!
        let spaceAddress = SpaceAddressViewController.InitWithStory()
        spaceAddress.basicStp = self.basicStp
        if self.basicStp.isEditSpace{
            
            spaceAddress.basicStp.isEditSpace = self.basicStp.isEditSpace
        }
        self.navigationController?.pushView(viewController: spaceAddress)
        
    }
    
    func NextAct(){
        print(self.services.filter({$0.isSelected}).compactMap({$0.id}))
        print(self.services.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ","))//Comma Separator
        var parameter = [String : Any]()
        let servicesAccess = self.services.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["step"] = "basics"
        if self.additiInformTextView.text! != self.lang.additionalInf{
            parameter["services_extra"] = self.additiInformTextView.text!
        }
        else {
            parameter["services_extra"] = ""
        }
        parameter["services"] =  servicesAccess
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
                    
                    
                    self.services = _json.array("services").compactMap({BasicStpData($0)})
                    self.serviceTable.reloadData()
                    
                    
                    
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
    @objc func backAct(){
        self.navigationController?.popViewController(animated: true)
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
extension ExtraServicesViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard services.count > 0 else {return 0}
        return services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessTVC", for: indexPath) as! AccessTVC
        guard services.count > 0 else {return cell}
        let service = services[indexPath.row]
        
        cell.txtLbl.text = service.name
        
        if self.basicStp.selectedVal.contains(obj: self.services[indexPath.row].id){
            self.services[indexPath.row].isSelected = true
        }
        
        cell.isChecked = self.services[indexPath.row].isSelected
        
        cell.selectDataBtn.addTap {
            cell.isChecked = !cell.isChecked
            self.services[indexPath.row].isSelected = !self.services[indexPath.row].isSelected
            self.basicStp.servicesList = self.services.filter({$0.isSelected}).compactMap({$0.id}).map{"\($0)"}.joined(separator: ",")
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

extension ExtraServicesViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == self.lang.additionalInf{
            additiInformTextView.text = ""
            additiInformTextView.textColor = .black
        }else{
            additiInformTextView.textColor = .black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            additiInformTextView.text = self.lang.additionalInf
            additiInformTextView.textColor = .lightGray
        }
        
        textView.resignFirstResponder()
    }
}
