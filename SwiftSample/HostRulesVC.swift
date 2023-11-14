/**
* HostRulesVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol HostHouseRulesDelegate
{
    func onHostHouserulesChanged(message : String)
}
class HostRulesVC : UIViewController,UITableViewDelegate, UITableViewDataSource,EditTitleDelegate
{
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblHostRules: UITableView!

    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let arrRules = ["Suitable for children\n(Age 2-12)","Suitable for infants\n(Under 2)","Pets allowed","Smoking allowed","Parties allowed"]
    let arrSecondRules = ["Addtional Rules"]
    var delegate: HostHouseRulesDelegate?
    var strRoomID = ""
    var strHouseRules = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //
    //MARK: Room Detail Table view Handling
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
//        if(section == 0) {
            let viewHolder:UIView = UIView()
            viewHolder.frame =  CGRect(x: 0, y:0, width: (self.view.frame.size.width) ,height: 40)
            
            let lblRoomName:UILabel = UILabel()
            lblRoomName.frame =  CGRect(x: 0, y:10, width: viewHolder.frame.size.width-100 ,height: 40)
            lblRoomName.text="Is my listing suitable for children?"
            lblRoomName.textColor = UIColor(red: 236.0 / 255.0, green: 102.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
            lblRoomName.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 13)
            viewHolder.addSubview(lblRoomName)
            return viewHolder
            
//        }
//        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0) {
            return 70
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        if indexPath.section == 0
//        {
//            return 60
//        }
//        else
//        {
            return 50
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0
//        {
//            return 5
//        }
//        else
//        {
            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        if indexPath.section==0
//        {
//            let cell:CellHostRules = tblHostRules.dequeueReusableCell(withIdentifier: "CellHostRules")! as! CellHostRules
//            cell.btnAccept?.tag = indexPath.row
//            cell.btnReject?.tag = indexPath.row
//            
////            if (cell.btnAccept?.isSelected==true)
////            {
////                cell.btnReject?.backgroundColor =  UIColor.white
////                cell.btnAccept?.backgroundColor =  UIColor(red: 0.0 / 255.0, green: 209.0 / 255.0, blue: 193.0 / 255.0, alpha: 1.0)
////            }
////            
////            if !(cell.btnAccept?.isSelected)!
////            {
////                cell.btnAccept?.backgroundColor =  UIColor.white
////            }
////            
////            if (cell.btnReject?.isSelected)!
////            {
////                cell.btnReject?.backgroundColor =  UIColor(red: 130.0 / 255.0, green: 136.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
////
////                cell.btnAccept?.backgroundColor =  UIColor.white
////            }
////            
////            if !(cell.btnReject?.isSelected)!
////            {
////                cell.btnReject?.backgroundColor =  UIColor.white
////            }
//
//            cell.btnAccept?.addTarget(self, action: #selector(self.onAcceptTapped), for: UIControlEvents.touchUpInside)
//            cell.btnReject?.addTarget(self, action: #selector(self.onRejectTapped), for: UIControlEvents.touchUpInside)
//            cell.setBorder()
//            cell.lblRules?.text = arrRules[indexPath.row]
//            return cell
//        }
//        else
//        {
            let cell:CellHostChildRules = tblHostRules.dequeueReusableCell(withIdentifier: "CellHostChildRules") as! CellHostChildRules
            cell.lblRules?.text = arrSecondRules[indexPath.row]
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        if indexPath.section==0 && indexPath.row==0
//        {
            let propertyView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditTitleVC") as! EditTitleVC
            propertyView.strPlaceHolder = "How do you expect guests to behave?"
            propertyView.strTitle = "House Rules"
            propertyView.delegate = self
            propertyView.strAboutMe = strHouseRules
            propertyView.strRoomId = strRoomID
            self.navigationController?.pushViewController(propertyView, animated: true)
//        }
    }
    
    @IBAction func onAcceptTapped(_ sender:UIButton!)
    {
//        if sender.isSelected
//        {
//            sender.isSelected = false
//        }
//        else{
//            sender.isSelected = true
//        }
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        tblHostRules.reloadRows(at: [indexPath], with: .none)
    }

    @IBAction func onRejectTapped(_ sender:UIButton!)
    {
//        sender.isSelected = !sender.isSelected
//        sender.backgroundColor =  UIColor(red: 130.0 / 255.0, green: 136.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
//
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        tblHostRules.reloadRows(at: [indexPath], with: .none)
    }
    
    //MARK: EDIT TITLE CHANGED DELEGATE METHOD
    internal func EditTitleTapped(strDescription: NSString)
    {
        delegate?.onHostHouserulesChanged(message : strDescription as String)
        self.onBackTapped(nil)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}

class CellHostRules: UITableViewCell
{
    @IBOutlet var lblRules: UILabel?
    @IBOutlet var btnAccept: UIButton?
    @IBOutlet var btnReject: UIButton?
    
    func setBorder()
    {
        MakentSupport().makeSquareBorder(btnLayer: btnAccept!, color: UIColor.lightGray.withAlphaComponent(0.4), radius: btnAccept!.frame.size.width/2)
        MakentSupport().makeSquareBorder(btnLayer: btnReject!, color: UIColor.lightGray.withAlphaComponent(0.4), radius: btnReject!.frame.size.width/2)
    }
}

class CellHostChildRules: UITableViewCell
{
    @IBOutlet var lblRules: UILabel?
}

