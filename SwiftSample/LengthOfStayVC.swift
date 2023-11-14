//
//  LengthOfStayVC.swift
//  Makent
//
//  Created by Trioangle on 16/08/18.
//  Copyright © 2018 Mani kandan. All rights reserved.
//

import UIKit

class LengthOfStayVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrListedRooms : NSMutableArray = NSMutableArray()
    var isDelete:Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "Length of Stay Discounts"
        if listModel.length_of_stay_rules.count == 0 {
            noDataLabel.text = "No Length of Stay Discounts Found"
            dicountTableView.isHidden = true
            noDataLabel.isHidden = false
            dayLabel.isHidden = true
            percentageLabel.isHidden = true
        }
        else{
            tabCount = listModel.length_of_stay_rules.count
            dicountTableView.isHidden = false
            noDataLabel.isHidden = true
            dayLabel.text = "Days"
            percentageLabel.text = "Percentage"
            dayLabel.isHidden = false
            percentageLabel.isHidden = false
            if listModel.length_of_stay_rules.count == listModel.length_of_stay_options.count{
                self.addButton.isHidden = true
            }
            else{
                self.addButton.isHidden = false
            }
        }
        if listModel.length_of_stay_rules.count == listModel.length_of_stay_options.count {
            if listModel.length_of_stay_rules.count == 0 && listModel.length_of_stay_options.count == 0{
                self.addButton.isHidden = false
            }
            else{
                self.addButton.isHidden = true
            }
        }
        else{
            self.addButton.isHidden = false
        }
        dicountTableView.reloadData()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        
        let optionalView = self.storyboard?.instantiateViewController(withIdentifier: "OptionalDetailVC") as! OptionalDetailVC
        optionalView.strRoomId = listModel.room_id as String
        optionalView.listModel = self.listModel
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(optionalView, animated: false)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listModel.length_of_stay_rules.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CellDiscountsTVC = dicountTableView.dequeueReusableCell(withIdentifier: "CellDiscountsTVC") as! CellDiscountsTVC
        let lengthModel = listModel.length_of_stay_rules[indexPath.row] as? RoomDetailModel
        cell.nightLabel.text = lengthModel?.period as? String
        cell.percentageLabel.text = lengthModel?.discount as? String
        let id:Int = Int((lengthModel?.id as? String)!)!
        cell.deleteButton.tag = id
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction), for: UIControlEvents.touchUpInside)
        cell.editButton.tag = id
        let day = (lengthModel?.period_text as! String)
        let per = (lengthModel?.discount as! String)
        let per1 = (lengthModel?.period as! String)
        cell.editButton.titleLabel?.text = "\(day),\(per),\(per1)"
        cell.editButton.addTarget(self, action: #selector(self.editButtonAction), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    @IBAction func AddbuttonAction(_ sender: Any) {
        //length of stay
        let discountView = self.storyboard?.instantiateViewController(withIdentifier: "EditLengthOfDiscountsVC") as! EditLengthOfDiscountsVC
        discountView.listModel = self.listModel
        discountView.roomid = listModel.room_id as String
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(discountView, animated: true)
        
    }
    
    func deleteButtonAction(sender:UIButton) {
        
        let deleteid = String(sender.tag)
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"]  = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["id"]   = deleteid
        dicts["room_id"] = listModel.room_id
        MakentAPICalls().GetRequest(dicts,methodName: METHOD_DELETE_ADDITIONAL_PRICE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let proModel = response as! RoomDetailModel
            OperationQueue.main.addOperation {
                self.listModel.length_of_stay_rules.removeAllObjects()
                if proModel.status_code == "1"
                {
                    self.listModel.length_of_stay_rules.addObjects(from: (proModel.arrTemp2 as NSArray) as! [Any])
                    self.viewWillAppear(true)
                    if self.listModel.length_of_stay_rules.count == 0 {
                        self.dicountTableView.isHidden = true
                        self.viewWillAppear(true)
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
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: "Server issue, Please try again.")
            }
        })
    }
    func editButtonAction(sender:UIButton){
        let editid = String(sender.tag)
        let testString = "\(sender.titleLabel?.text!)"
        let textTit = testString.replacingOccurrences(of: "Optional(", with: "")
        let textTit1 = textTit.replacingOccurrences(of: ")", with: "")
        let text1 = textTit1.replacingOccurrences(of: "\"", with: "")
        let fullNameArr = text1.components(separatedBy: ",")
        let day    = fullNameArr[0]
        let per = fullNameArr[1]
        let per1 = fullNameArr[2]
        //length of stay
        
        let discountView = self.storyboard?.instantiateViewController(withIdentifier: "EditLengthOfDiscountsVC") as! EditLengthOfDiscountsVC
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
    
    
}
