//
//  SpaceListViewController.swift
//  Makent
//
//  Created by trioangle on 30/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceListViewController: UIViewController {

    @IBOutlet weak var spaceListView: UITableView!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet var loginView: UIView!
    
    @IBOutlet weak var lblListTitle: UILabel!
    
    @IBOutlet weak var lblListTit : UILabel!
    
    @IBOutlet weak var lblLisTitle: UILabel!
    @IBOutlet weak var lblListDesc: UILabel!
    
    @IBOutlet weak var imgAddSpace: UIImageView!
    
    @IBOutlet var noDataAlertView: UIView!
    
    @IBOutlet weak var lblNoListTitle: UILabel!
    
    @IBOutlet weak var lblNoListDesc: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let lang = Language.localizedInstance()
    
    var headerTitle = [String]()
    
    var bsicStep = BasicStpData()
    
     var spaceList = [BasicStpData]()
    
     var spaceUnlist = [BasicStpData]()
    
    @IBOutlet weak var btnLeftMenu: UIButton!
    //var btnLeftMenu = UIButton()
    
     var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view. listing
        
        self.initViewLayoutAction()
        
        //self.GetBasicStepsService()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navWhite()
        self.lblLisTitle.text = self.lang.listings_Title
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = false
        if token != "" {
            
        self.GetBasicStepsService()
        
        }
        self.navigationController?.navigationBar.backgroundColor = .white
        
    }
    func initViewLayoutAction(){

        self.spaceListView.register(UINib(nibName: "SpaceListTVC", bundle: nil), forCellReuseIdentifier: "SpaceListTVC")
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        self.spaceListView.register(UINib(nibName: "AddSpaceListTVC", bundle: nil), forCellReuseIdentifier: "AddSpaceListTVC")
        self.spaceListView.reloadData()
        self.spaceListView.register(SpaceListHeader.self,
                           forHeaderFooterViewReuseIdentifier: "SpaceListHeader")
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = false
        self.imgAddSpace.image = UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate)
        //self.imgAddSpace.isElevated = true
        self.imgAddSpace.tintColor = UIColor.appHostThemeColor
        self.imgAddSpace.addTap {
            let spaceList = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "TypeSpaceViewController") as! TypeSpaceViewController
            self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
            self.navigationController?.pushViewController(spaceList, animated: true)
        }
        
        self.lblListTitle.text = self.lang.listings_Title
        self.lblListDesc.text = self.lang.spcListDesc
        self.lblListTit.text = self.lang.listings_Title
        
        self.lblNoListTitle.text = self.lang.noliss_Tit
        self.lblNoListDesc.text = self.lang.noliss_Msg
        
        self.bsicStep.currentScreenState = .typeSpace
        self.spaceListView.addPullRefresh { [weak self] in
           // self?.noDataAlertView.removeFromSuperview()
           
            self?.spaceList.removeAll()
            self?.spaceUnlist.removeAll()
            self?.spaceListView.reloadData()
            self?.GetBasicStepsService()
            self?.spaceListView.stopPullRefreshEver()
            
        }
        if token != ""
        {
            
            self.view.removeAddedSubview(view: loginView)
            //self.GetBasicStepsService()
        }
        else
        {
            self.btnLogin.setTitle(lang.login_Title, for: .normal)
            self.btnLogin.appGuestTextColor()
            self.btnLogin.borderColor = UIColor.appGuestThemeColor
            self.btnLogin.borderWidth = 1
            self.btnLogin.addTap {
                let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                mainPage.modalPresentationStyle = .fullScreen
                mainPage.hidesBottomBarWhenPushed = true
                self.appDelegate.lastPageMaintain = "trips"
                let naviation = UINavigationController(rootViewController: mainPage)
                naviation.modalPresentationStyle = .fullScreen
                self.present(naviation, animated: false, completion: nil)
            }
            loginView.isHidden = false
            self.view.addCenterView(centerView: loginView)
        }
       
    }
    
    
    func ListStepsService(_ spaceId : String,_ status : String){
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = spaceId
        parameter["step"] = "basics"
        parameter["status"] = status
        self.btnLeftMenu.isUserInteractionEnabled = false
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().postWebService(wsMethod: .updateSpace, params: parameter) { ( json, error) in
            if let _ = error{
                self.btnLeftMenu.isUserInteractionEnabled = true
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                MakentSupport().removeProgress(viewCtrl: self)
            }else{
                MakentSupport().removeProgress(viewCtrl: self)
                if let _json = json,
                    _json.isSuccess{
                    self.btnLeftMenu.isUserInteractionEnabled = true
                    self.noDataAlertView.removeFromSuperview()
                    //Mark:- Assigning SpaceType Values into model using compactMap
                    
                    self.spaceList = _json.array("listed").compactMap({BasicStpData($0)})
                    self.spaceUnlist = _json.array("unlisted").compactMap({BasicStpData($0)})
                    self.headerTitleArray()
                    self.spaceListView.reloadData()
                    self.GetBasicStepsService()
                    
                }else{
                    
//                    self.noDataAlertView.removeFromSuperview()
//                    self.view.addSubview(self.noDataAlertView)
//                    self.view.bringSubviewToFront(self.noDataAlertView)
//                    self.noDataAlertView.frame = self.view.frame
                    
                    print("Error Message",json?
                        .string("error_message"))
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.GetBasicStepsService()
                    self.appDelegate
                        .createToastMessage(json?
                            .string("error_message") ?? "Error", isSuccess: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func headerTitleArray(){
        if self.spaceList.count > 0 && self.spaceUnlist.count > 0{
           self.lblLisTitle.text = self.lang.listings_Title
           self.headerTitle = [self.lang.lis_Title,self.lang.unlis_Title,""]
        }else if spaceList.count == 0 && self.spaceUnlist.count > 0{
           self.lblLisTitle.text = self.lang.listings_Title
           self.headerTitle = ["",self.lang.unlis_Title,""]
        }else if spaceList.count > 0 && self.spaceUnlist.count == 0{
           self.lblLisTitle.text = self.lang.listings_Title
           self.headerTitle = [self.lang.lis_Title,"",""]
        }else if spaceList.count == 0 && self.spaceUnlist.count == 0{
          self.lblLisTitle.text = ""
          self.headerTitle = [""]
        }
        
    }
    /*if self.spaceList.count > 0 && self.spaceUnlist.count > 0{
     self.lblLisTitle.text = self.lang.listings_Title
     self.headerTitle = [" " + self.lang.lis_Title," " + self.lang.unlis_Title,""]
     }else if spaceList.count == 0 && self.spaceUnlist.count > 0{
     self.lblLisTitle.text = self.lang.listings_Title
     self.headerTitle = [""," " + self.lang.unlis_Title,""]
     }else if spaceList.count > 0 && self.spaceUnlist.count == 0{
     self.lblLisTitle.text = self.lang.listings_Title
     self.headerTitle = [" " + self.lang.lis_Title,"",""]
     }else if spaceList.count == 0 && self.spaceUnlist.count == 0{
     self.headerTitle = [""]
     }*/
    
    func navWhite(){
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func addPlusButton() {
        
        //self.navigationController?.isNavigationBarHidden = false
        self.navWhite()
        
       
        btnLeftMenu.titleLabel?.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 30)
        btnLeftMenu.setTitle("+", for: .normal)
        btnLeftMenu.setTitleColor(UIColor.appGuestButtonBG, for: .normal)
        //btnLeftMenu.sizeToFit()
        btnLeftMenu.addTap {
           
            let spaceList = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "TypeSpaceViewController") as! TypeSpaceViewController
            self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
            self.navigationController?.pushViewController(spaceList, animated: true)
        }
//        let barButton = UIBarButtonItem(customView: btnLeftMenu)
//        self.navigationItem.rightBarButtonItem = barButton
    }
    
    class func InitWithStory()->SpaceListViewController
    {
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceListViewController") as! SpaceListViewController
    }
    
    func GetBasicStepsService(){
     
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        self.btnLeftMenu.isUserInteractionEnabled = false
        self.spaceListView.isHidden = true
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .listingSpace, params: parameter) { [self] ( json, error) in
            if let _ = error
            {
                self.btnLeftMenu.isUserInteractionEnabled = true
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                self.spaceListView.isHidden = false
                MakentSupport().removeProgress(viewCtrl: self)
            }
            else
            {
                MakentSupport().removeProgress(viewCtrl: self)
                if let _json = json,
                    _json.isSuccess
                {
                    self.btnLeftMenu.isUserInteractionEnabled = true
                    self.noDataAlertView.removeFromSuperview()
                    //Mark:- Assigning SpaceType Values into model using compactMap
                    self.spaceList.removeAll()
                    self.spaceUnlist.removeAll()
                    self.spaceList = _json.array("listed").compactMap({BasicStpData($0)})
                    self.spaceUnlist = _json.array("unlisted").compactMap({BasicStpData($0)})
                    if self.spaceList.count > 0 || self.spaceUnlist.count > 0{
                        self.addPlusButton()
                    }
                    self.headerTitleArray()
                    self.spaceListView.reloadData()
                    self.spaceListView.isHidden = false
                }
                else
                {
                    self.spaceListView.isHidden = false
                    self.noDataAlertView.removeFromSuperview()
                    self.noDataAlertView.frame = self.view.frame
                    self.view.addSubview(self.noDataAlertView)
                    self.view.bringSubviewToFront(self.noDataAlertView)
                    
//                    self.headerTitleArray()
//                    self.spaceListView.reloadData()
//                    self.btnLeftMenu.isUserInteractionEnabled = true
                    print("Error Message",json?
                        .string("success_message"))
                    MakentSupport().removeProgress(viewCtrl: self)
                    //self.appDelegate.createToastMessage(json?.string("success_message") ?? "Success", isSuccess: true)
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
extension SpaceListViewController : UITableViewDataSource,UITableViewDelegate{
    
    func AddSpaceNav(){
        let typeSpace = AddSpaceViewController.InitWithStory()
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        let navController = UINavigationController(rootViewController: typeSpace)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        let index = section
        view.frame = CGRect(x: 40, y: 5, width: tableView.frame.width - 80, height: 40)
        view.backgroundColor = .white
        view.transForm()
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width - 20, height: 40)
        label.transForm()
        label.TitleFont()
        guard self.headerTitle.count > 0 else {
            return UIView()
        }
        label.text = self.headerTitle[section]
        view.addSubview(label)
        switch index {
              case 0:
                  guard spaceList.count > 0 else{
                    view.frame.size.height = 0
                    return view
                  }
                  return view
              case 1:
                  guard spaceUnlist.count > 0 else{
                    view.frame.size.height = 0
                    return view
                  }
                  return view
              default:
                  view.frame.size.height = 0
                  return view
              }
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
        
         return spaceList.count
        }else if section == 1{
         
        return spaceUnlist.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceListTVC", for: indexPath) as! SpaceListTVC
      
        cell.listView.isElevated = true
        
        cell.prgsList.transform = self.getAffine
        
        
        
        //Mark:- Space Listed Data
        if indexPath.section == 0{
            
            guard spaceList.count > indexPath.row else{return cell}
            let listedData = spaceList[indexPath.row]
            cell.listedDataDisplay(listedData)
            let val = listedData.completed
            if val == 100 && (listedData.status == "Listed" || listedData.status == "Unlisted" ){
                cell.tfListtype.optionArray = [lang.lis_Title,lang.unlis_Title]
                //spaceListValue.adminStatus
                cell.lblListSts.text  = ""
                cell.tfListtype.text = ""
                cell.lblListSts.text = listedData.status == "Listed" ? lang.lis_Title : lang.unlis_Title
                cell.lblListSts.textAlignment = Language.getCurrentLanguage().rawValue == "en" ? .center : .left
                cell.viewListType.isHidden = false
                cell.tfListtype.didSelect{(selectedText , index ,id) in
                    cell.lblListSts.text  = ""
                    cell.tfListtype.textAlignment = .center
                    self.ListStepsService(listedData.spaceId.description, selectedText)
                }
                
                cell.viewListType.isUserInteractionEnabled = true
                cell.viewListType.addTap {
                    cell.tfListtype.showList()
                }
            }
            
        }else if indexPath.section == 1 {
            
            //Mark:- Space UnListed Data
            guard spaceUnlist.count > indexPath.row else{return cell}
            let spaceUnListValue = spaceUnlist[indexPath.row]
            cell.unListedDataDisplay(spaceUnListValue)
            let val = spaceUnListValue.completed
            if val == 100 && (spaceUnListValue.status == "Listed" || spaceUnListValue.status == "Unlisted"  ){
                cell.tfListtype.optionArray = [lang.lis_Title,lang.unlis_Title]
                //spaceListValue.adminStatus
                
                cell.tfListtype.text = ""
                cell.lblListSts.text = spaceUnListValue.status == "Pending" ? lang.pend_Tit : lang.unlis_Title
                cell.lblListSts.textAlignment = .center
                cell.viewListType.isHidden = false
                cell.tfListtype.didSelect{(selectedText , index ,id) in
                    cell.lblListSts.text  = ""
                    cell.tfListtype.textAlignment = .center
                    self.ListStepsService(spaceUnListValue.spaceId.description, selectedText)
                }
                
                cell.viewListType.addTap {
                    cell.tfListtype.showList()
                }
            }else  if val == 100 && (spaceUnListValue.status == "Pending"){
               cell.lblListSts.text = spaceUnListValue.status == "Pending" ? lang.pend_Tit : ""
            }
            
            }
        else{
              let cell = tableView.dequeueReusableCell(withIdentifier: "AddSpaceListTVC", for: indexPath) as! AddSpaceListTVC
            
                cell.lblAddSpace.text = self.lang.addAnthrSpc
            
              return cell
     }
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0
        {
            guard spaceList.count > indexPath.row else{return}
            let spaceListValue = spaceList[indexPath.row]
            BasicStpData.shared.spaceID = spaceListValue.spaceId.description
            self.AddSpaceNav()
        }
        else if indexPath.section == 1
        {
            guard spaceUnlist.count > indexPath.row else{return}
            let spaceUnListValue = spaceUnlist[indexPath.row]
            BasicStpData.shared.spaceID = spaceUnListValue.spaceId.description
            self.AddSpaceNav()
        }
        else
        {
            
            let spaceList = StoryBoard.Space.instance.instantiateViewController(withIdentifier: "TypeSpaceViewController") as! TypeSpaceViewController
            self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
            self.navigationController?.pushViewController(spaceList, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.section
        switch index {
        case 0:
            guard spaceList.count > indexPath.row else{return 0}
            return UITableView.automaticDimension
        case 1:
            guard spaceUnlist.count > indexPath.row else{return 0}
            return UITableView.automaticDimension
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }

        
    }
}
