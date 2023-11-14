//
//  DiscountsPageVC.swift
//  Makent
//
//  Created by Trioangle on 23/05/18.
//  Copyright © 2018 Mani kandan. All rights reserved.
//

import UIKit

class DiscountsPageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var dicountTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    var type = ""
    var listModel : ListingModel!
    var tabCount : Int = 0
    var roomid = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrListedRooms : NSMutableArray = NSMutableArray()
    var isDelete:Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        self.backButton.transform = Language.getCurrentLanguage().getAffine
        self.dayLabel.text = self.lang.dayys_Title.capitalized
        self.percentageLabel.text = self.lang.percen_Tit
        self.addButton.setTitle(self.lang.add_Tit, for: .normal)
        backButton.appHostTextColor()
        addButton.appHostSideBtnBG()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == "1"{
            titleLabel.text = lang.lengthdis_Title
            if listModel.length_of_stay_rules.count == 0 {
                noDataLabel.text = lang.nostay_Disc
                dicountTableView.isHidden = true
                noDataLabel.isHidden = false
                dayLabel.isHidden = true
                percentageLabel.isHidden = true
            }
            else{
                tabCount = listModel.length_of_stay_rules.count
                dicountTableView.isHidden = false
                noDataLabel.isHidden = true
                dayLabel.text = lang.night_Tit
                percentageLabel.text = lang.percen_Tit
                dayLabel.isHidden = false
                percentageLabel.isHidden = false
                if (listModel.length_of_stay_rules.count == listModel.length_of_stay_options.count) || (listModel.length_of_stay_rules.count == 8){
                    self.addButton.isHidden = true
                }
                else{
                    self.addButton.isHidden = false
                }
            }
            if (listModel.length_of_stay_rules.count == listModel.length_of_stay_options.count) || (listModel.length_of_stay_rules.count == 8){
                self.addButton.isHidden = true
            }
            else{
                self.addButton.isHidden = false
            }
        }
        else if type == "2"{
            titleLabel.text = lang.earlybird_Disc
            if listModel.early_bird_rules.count == 0 {
                noDataLabel.text = lang.nobir_Disc
                dicountTableView.isHidden = true
                noDataLabel.isHidden = false
                dayLabel.isHidden = true
                percentageLabel.isHidden = true
            }
            else{
                tabCount = listModel.early_bird_rules.count
                dicountTableView.isHidden = false
                noDataLabel.isHidden = true
                dayLabel.text = lang.dayys_Title
                percentageLabel.text = lang.percen_Tit
                dayLabel.isHidden = false
                percentageLabel.isHidden = false
            }
        }
        else{
            titleLabel.text = lang.lastmin_Disc
            if listModel.last_min_rules.count == 0 {
                noDataLabel.text = lang.nolst_Disc
                dicountTableView.isHidden = true
                noDataLabel.isHidden = false
                dayLabel.isHidden = true
                percentageLabel.isHidden = true
            }
            else{
                tabCount = listModel.last_min_rules.count
                dicountTableView.isHidden = false
                noDataLabel.isHidden = true
                dayLabel.text = lang.dayys_Title
                percentageLabel.text = lang.percen_Tit
                dayLabel.isHidden = false
                percentageLabel.isHidden = false
            }
        }
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        
        let optionalView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "OptionalDetailVC") as! OptionalDetailVC
        optionalView.strRoomId = listModel.room_id as String
        optionalView.listModel = self.listModel
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(optionalView, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "1"{
            return listModel.length_of_stay_rules.count
        }
        else if type == "2" {
            return listModel.early_bird_rules.count
        }
        else{
            return listModel.last_min_rules.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CellDiscountsTVC = dicountTableView.dequeueReusableCell(withIdentifier: "CellDiscountsTVC") as! CellDiscountsTVC
        cell.deleteButton.deleted(.appHostThemeColor)
        if type == "1"{
            let lengthModel = listModel.length_of_stay_rules[indexPath.row] as? RoomDetailModel
            cell.nightLabel.text = lengthModel?.period as? String
            cell.percentageLabel.text = lengthModel?.discount as? String
            let id:Int = Int((lengthModel?.id as? String)!)!
            cell.deleteButton.tag = id
            cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction), for: UIControl.Event.touchUpInside)
            cell.editButton.tag = id
            let day = (lengthModel?.period as! String)
            let per = (lengthModel?.discount as! String)
            let per1 = (lengthModel?.period_text as! String)
            cell.editButton.titleLabel?.text = "\(day),\(per),\(per1)"
            cell.editButton.addTarget(self, action: #selector(self.editButtonAction), for: UIControl.Event.touchUpInside)
        }
        else if type == "2"{
            let lengthModel = listModel.early_bird_rules[indexPath.row] as? RoomDetailModel
            cell.nightLabel.text = "    \(lengthModel?.period as! String)"
            cell.percentageLabel.text = lengthModel?.discount as! String
            let id:Int = Int((lengthModel?.id as? String)!)!
            cell.deleteButton.tag = id
            cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction), for: UIControl.Event.touchUpInside)
            cell.editButton.tag = id
            let day = (lengthModel?.period as! String)
            let per = (lengthModel?.discount as! String)
            cell.editButton.titleLabel?.text = "\(day),\(per)"
            cell.editButton.addTarget(self, action: #selector(self.editButtonAction), for: UIControl.Event.touchUpInside)
            
        }
        else if type == "3"{
            let lengthModel = listModel.last_min_rules[indexPath.row] as? RoomDetailModel
            cell.nightLabel.text = "    \(lengthModel?.period as! String)"
            cell.percentageLabel.text = lengthModel?.discount as! String
            let id:Int = Int((lengthModel?.id as? String)!)!
            cell.deleteButton.tag = id
            cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction), for: UIControl.Event.touchUpInside)
            cell.editButton.tag = id
            let day = (lengthModel?.period as! String)
            let per = (lengthModel?.discount as! String)
            cell.editButton.titleLabel?.text = "\(day),\(per)"
            cell.editButton.addTarget(self, action: #selector(self.editButtonAction), for: UIControl.Event.touchUpInside)
            
        }
        return cell
    }
    
    @IBAction func AddbuttonAction(_ sender: Any) {
        if type == "1"{
            //length of stay
            let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditLengthOfDiscountsVC") as! EditLengthOfDiscountsVC
            discountView.listModel = self.listModel
            discountView.roomid = listModel.room_id as String
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountView, animated: true)
        }
        else if type == "2" {
            //early bird discount
            let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditEarliyDiscountVc") as! EditEarliyDiscountVc
            discountView.type = "1"
            discountView.listModel = self.listModel
            discountView.roomid = listModel.room_id as String
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountView, animated: true)
        }
        else{
            //last min discounts
            let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditEarliyDiscountVc") as! EditEarliyDiscountVc
            discountView.type = "2"
            discountView.listModel = self.listModel
            discountView.roomid = listModel.room_id as String
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountView, animated: true)
        }
    }
    
    @objc func deleteButtonAction(sender:UIButton) {
        
        let deleteid = String(sender.tag)
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["id"]   = deleteid
        dicts["room_id"] = listModel.room_id
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_DELETE_ADDITIONAL_PRICE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let proModel = response as! RoomDetailModel
            OperationQueue.main.addOperation {
                if self.type == "1"{
                    self.listModel.length_of_stay_rules.removeAllObjects()
                }
                else  if self.type == "2"{
                    self.listModel.early_bird_rules.removeAllObjects()
                }
                else{
                    self.listModel.last_min_rules.removeAllObjects()
                }
                if proModel.status_code == "1"
                {
                    if self.type == "1" {
                        self.listModel.length_of_stay_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                        self.viewWillAppear(true)
                        if self.listModel.length_of_stay_rules.count == 0 {
                            self.dicountTableView.isHidden = true
                            self.viewWillAppear(true)
                        }
                    }
                    else if self.type == "2" {
                        self.listModel.early_bird_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                        if self.listModel.length_of_stay_rules.count == 0 {
                            self.dicountTableView.isHidden = true
                            self.viewWillAppear(true)
                        }
                        
                    }
                    else {
                        self.listModel.last_min_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                        if self.listModel.last_min_rules.count == 0 {
                            self.dicountTableView.isHidden = true
                            self.viewWillAppear(true)
                        }
                        
                    }
                    self.dicountTableView.reloadData()
                }
                else
                {
                    if proModel.success_message == "token_invalid" || proModel.success_message == "user_not_found" || proModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                    
                }
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                
            }
            MakentSupport().removeProgressInWindow(viewCtrl: self)
            
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    @objc func editButtonAction(sender:UIButton){
        let editid = String(sender.tag)
        let testString = "\(sender.titleLabel?.text!)"
        let textTit = testString.replacingOccurrences(of: "Optional(", with: "")
        let textTit1 = textTit.replacingOccurrences(of: ")", with: "")
        let text1 = textTit1.replacingOccurrences(of: "\"", with: "")
        let fullNameArr = text1.components(separatedBy: ",")
        let day    = fullNameArr[0]
        let per = fullNameArr[1]
        var per1 = ""
        if type == "1"{
            per1 = fullNameArr[2]
        }
        if type == "1"{
            //length of stay
            let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditLengthOfDiscountsVC") as! EditLengthOfDiscountsVC
            discountView.listModel = self.listModel
            discountView.roomid = listModel.room_id as String
            discountView.type = "edit"
            discountView.day = day
            discountView.per = per
            discountView.peried = per1
            discountView.SelectedID = editid
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountView, animated: true)
        }
        else if type == "2" {
            //early bird discount
            let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditEarliyDiscountVc") as! EditEarliyDiscountVc
            discountView.type = "1"
            discountView.listModel = self.listModel
            discountView.SelectedID = editid
            discountView.day = day
            discountView.per = per
            discountView.roomid = listModel.room_id as String
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountView, animated: true)
            
        }
        else{
            //last min discounts
            let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditEarliyDiscountVc") as! EditEarliyDiscountVc
            discountView.type = "2"
            discountView.listModel = self.listModel
            discountView.SelectedID = editid
            discountView.day = day
            discountView.per = per
            discountView.roomid = listModel.room_id as String
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountView, animated: true)
        }
    }
    
    
}
class CellDiscountsTVC: UITableViewCell {
    
    @IBOutlet var nightLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
}
