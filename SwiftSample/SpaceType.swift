/**
* SpaceType.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class SpaceType : UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblSpaceType: UITableView!
    @IBOutlet var viewHeader: UIView!
    
    
//    @IBOutlet weak var spacetype_Msg: UILabel!
//    
//    @IBOutlet weak var list_Space: UILabel!
//
    @IBOutlet weak var bck_Btn: UIButton!
    
    @IBOutlet weak var list_Space: UILabel!
    
    @IBOutlet weak var spacetype_Msg: UILabel!
    
    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let arrIconName = ["entirehome.png","privateroom.png","sharedroom.png"]
    var arrSpaceData : NSArray!
    var arrPropertyData : NSArray!
    var arrBedData : NSArray!
    var bedTypes : [BedType]?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.bck_Btn.transform = self.getAffine
       
        self.bck_Btn.appHostTextColor()
       
        self.spacetype_Msg.text = self.lang.listsp_Mes
        self.list_Space.text = self.lang.list_Space
        var rectHeaderView = viewHeader.frame

        rectHeaderView.size.height = self.view.frame.height/2
        viewHeader.frame = rectHeaderView
        tblSpaceType.tableHeaderView = viewHeader
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.getRoomPropertyType()
    }
    
    //MARK: - API CALL -> GETTING ROOM PROPERTY
    /*
     Get Exist Room Property type
     */
    func getRoomPropertyType()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: false)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ROOM_PROPERTY_TYPE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let propertyData = response as! GeneralModel
            OperationQueue.main.addOperation {
                if propertyData.status_code == "1"
                {
                    self.arrSpaceData = propertyData.arrTemp1
                    self.arrPropertyData = propertyData.arrTemp2
                    self.arrBedData = propertyData.arrTemp3
                    self.bedTypes = propertyData.bedTypes
                    self.appDelegate.arrNightData = propertyData.arrTemp2
                    self.tblSpaceType.reloadData()
                }
                else
                {
                    if propertyData.success_message == "token_invalid" || propertyData.success_message == "user_not_found" || propertyData.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
////        return 70
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSpaceData != nil ? arrSpaceData.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellSpaceType = tblSpaceType.dequeueReusableCell(withIdentifier: "CellSpaceType")! as! CellSpaceType
        cell.lblIsShared?.appGuestTextColor()
        let proModel = arrSpaceData[indexPath.row] as? RoomPropertyModel
        cell.lblHomeType?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblSubType?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblIsShared?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblHomeType?.text = proModel?.property_name as String?
        cell.lblSubType?.text = proModel?.property_description! as String?
        cell.lblIsShared?.text = self.lang.shareroom_Msg
        if proModel?.property_isShared as String? == "Yes"
        {
           cell.lblIsShared?.isHidden = false
            if proModel?.property_description! as String? == ""
            {
                let x = cell.lblSubType?.frame.origin.x
                let y = cell.lblSubType?.frame.origin.y
                cell.lblIsShared?.frame.origin = CGPoint(x:x! ,y:y!);
            }
        }
        else
        {
           cell.lblIsShared?.isHidden = true
        }
        
        let strImgName = (indexPath.row == 0) ? "entirehome.png" : ((indexPath.row == 1) ? "privateroom.png" : "sharedroom.png")
        cell.imgIcon?.image =  UIImage(named: strImgName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let proModel = arrSpaceData[indexPath.row] as? RoomPropertyModel

//        let propertyView = self.storyboard?.instantiateViewController(withIdentifier: "PropertyType") as! PropertyType
        let propertyView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "PropertyType") as! PropertyType
        propertyView.strRoomType = (proModel?.property_id as String?)!
        if arrPropertyData != nil
        {
            propertyView.arrPropertyData = arrPropertyData
        }
        if arrBedData != nil
        {
            propertyView.arrBedData = arrBedData
        }
        propertyView.bedTypes = self.bedTypes
        self.navigationController?.pushViewController(propertyView, animated: true)
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

class CellSpaceType: UITableViewCell
{
    @IBOutlet var lblHomeType: UILabel?
    @IBOutlet var lblSubType: UILabel?
    @IBOutlet var lblIsShared: UILabel?
    @IBOutlet var imgIcon: UIImageView?
}
