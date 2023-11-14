//
//  FilterRoomTypes.swift
//  Makent
//
//  Created by Vignesh Palanivel on 09/08/17.
//  Copyright © 2017 Mani kandan. All rights reserved.
//

import UIKit
import MessageUI
import Social

protocol FilterRoomTypeDelegate
{
    func onFilterRoomTypeAdded(index:NSArray)
}


class FilterRoomTypes: UIViewController,UITableViewDelegate, UITableViewDataSource
 {
    @IBOutlet var tableAmenities: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
        var delegate: FilterRoomTypeDelegate?
    
    var arrayDict : Dictionary<String, Array<String>> = [:]
    var arrayDict1 : [String: [String]] = [:]
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
        var selectedCountry:String = ""
        var appDelegate  = UIApplication.shared.delegate as! AppDelegate
        var strCurrentCountry = ""
        var arrSelectedItems1 : NSMutableArray = NSMutableArray()
        var arrRoomTypeData : NSArray = NSArray()
        
    @IBOutlet weak var roomtyp_Lbl: UILabel!
    override func viewDidLoad()
        {
            super.viewDidLoad()
            self.navigationController?.isNavigationBarHidden = true
             self.view.appHostViewBGColor()
            tableAmenities.tableHeaderView = tblHeaderView
            self.roomtyp_Lbl.text = self.lang.rom_Typs
            self.roomtyp_Lbl.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            checkSaveBtnStatus()
            btnNext.transform = Language.getCurrentLanguage().getAffine
            self.getRoomTypeList()
            self.btnNext.nextButtonImage()
        }
    
    func getRoomTypeList()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: false)
        
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ROOM_PROPERTY_TYPE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    self.onLoadData()
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }
    
        func onLoadData()
        {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let path = String(format:"%@/roomtype.plist",paths)
            let fileManager = FileManager.default
            if ((fileManager.fileExists(atPath: path)))
            {
                arrRoomTypeData = NSArray.init(contentsOfFile: path)!
                self.tableAmenities.reloadData()
            }
           
        }
    
    
        func checkSaveBtnStatus()
        {
            btnNext.alpha = arrSelectedItems1.count > 0 ? 1.0 : 0.5
            btnNext.isUserInteractionEnabled = arrSelectedItems1.count > 0 ? true : false
        }
        @IBAction func onBackTapped(_ sender:UIButton!)
        {
            dismiss(animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            
            let dictTemp = arrRoomTypeData[indexPath.row] as! NSDictionary
            let is_shared = dictTemp.value(forKey: "is_shared")
            if is_shared as! String? == "Yes"
            {
                return 100
            }
            return 50
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrRoomTypeData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell:CellCountry = tableAmenities.dequeueReusableCell(withIdentifier: "CellCountry") as! CellCountry
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let dictTemp = arrRoomTypeData[indexPath.row] as! NSDictionary
            let roomName = dictTemp.value(forKey: "name")
            let is_shared = dictTemp.value(forKey: "is_shared")
            cell.lblName?.text = roomName as! String?
            cell.lblName?.numberOfLines = 2
            cell.lblName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            if is_shared as! String? == "Yes"
            {
                cell.lblName?.text = roomName as! String + lang.shareroom_Msg
            }
            cell.lblName?.textColor = (cell.lblName?.text == selectedCountry) ? k_AppThemeGreenColor : UIColor.darkGray
            let strIds = dictTemp.value(forKey: "id")
            
            if arrSelectedItems1.contains(String(format:"%d",strIds as! Int))
            {
                cell.lblName?.textColor = .white//k_AppThemeGreenColor
            }
            else {
                cell.lblName?.textColor = UIColor.darkGray
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            let dictTemp = arrRoomTypeData[indexPath.row] as! NSDictionary
            let strIds = dictTemp.value(forKey: "id")
            if arrSelectedItems1.contains(String(format:"%d",strIds as! Int))
            {
                arrSelectedItems1.remove(String(format:"%d",strIds as! Int))  
            }
            else
            {
                arrSelectedItems1.add(String(format:"%d",strIds as! Int))
              
            }
            checkSaveBtnStatus()
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            tableAmenities.reloadRows(at: [indexPath], with: .none)
        }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    @IBAction func gotoCardSelection(_ sender: UIButton) {
        
        delegate?.onFilterRoomTypeAdded(index: arrSelectedItems1)
        dismiss(animated: true, completion: nil)
        
    }
    
        
        func showProgress()
        {
            let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
            loginPageView.willMove(toParent: self)
            loginPageView.view.tag = 1234
            self.view.addSubview(loginPageView.view)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}
