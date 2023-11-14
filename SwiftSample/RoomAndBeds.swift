/**
* RoomAndBeds.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social
import MapKit

class RoomAndBeds : UIViewController,UITableViewDelegate, UITableViewDataSource,HostGuestDelegate, HostBedRoomsDelegate,HostBedsDelegate,HostBathroomsDelegate,HostBedDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    @IBOutlet var tblRoomsBeds: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewStepsAlert: UIView?
    @IBOutlet var lblAlert: UILabel?
    @IBOutlet var btnNext: UIButton!
    var lenthofstay : NSMutableArray = NSMutableArray()

    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var strRoomType = ""
    var strPropertyType = ""
    var strRoomLocation = ""
    var strPropertyName = ""
    var latitude = ""
    var longitude = ""
    var strMaxGuest = "1"
    var strBedroomsCount = "1"
    var strBedsCount = "1"
    var strBathroomsCount = "1"
    var strBedType = ""
    var strBedTypeID = ""
    var strRoomID:String!
    var arrBedData : NSArray!
    
    @IBOutlet var pickerView:UIPickerView?
    @IBOutlet var viewPickerHolder:UIView?
    var arrPickerData : NSArray!
    
    @IBOutlet weak var cls_Btn: UIButton!
    //    @IBOutlet weak var finish_Btn: UIButton!
//    @IBOutlet weak var mrstps_Lbl: UILabel!
//    @IBOutlet weak var roombed_Msg: UILabel!
//    @IBOutlet weak var roombed_Tit: UILabel!
    
    @IBOutlet weak var roombed_Tit: UILabel!
    
    @IBOutlet weak var roombed_Msg: UILabel!
    
    @IBOutlet weak var finish_Btn: UIButton!
    
    @IBOutlet weak var mrstps_Lbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        viewStepsAlert?.isHidden = true
        self.roombed_Tit.text = self.lang.roomandbeds
        self.roombed_Msg.text = self.lang.room_Desc
        self.lblAlert?.text = self.lang.created_List //need localize
        self.mrstps_Lbl.text = self.lang.morestps_Msg
        self.finish_Btn.setTitle(self.lang.finish_List, for: .normal)
        self.btnNext.setTitle(self.lang.next_Tit, for: .normal)
        if arrBedData != nil
        {
            let model = arrBedData[0] as? RoomPropertyModel
            strBedType = (model?.property_name)! as String
            arrPickerData = arrBedData
            let modelTemp = arrPickerData[0] as? RoomPropertyModel
            strBedTypeID = (modelTemp?.property_id)! as String
        }
        else{
            
            let model = arrBedData[0] as? RoomPropertyModel
            strBedType = (model?.property_name)! as String
            arrPickerData = arrBedData
            let modelTemp = arrPickerData[0] as? RoomPropertyModel
            strBedTypeID = (modelTemp?.property_id)! as String

        }
        cls_Btn.setTitle(self.lang.close_Tit, for: .normal)
        let rect = MakentSupport().getScreenSize()
        var rectHeaderView = viewHeader.frame
        rectHeaderView.size.height = rect.size.height - 500
//        viewPickerHolder?.isHidden = true
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        switch height {
        case 568.0:
            rectHeaderView.size.height = rect.size.height - 408
        case 8120:
            rectHeaderView.size.height = rect.size.height - 708
        default:
            break
        }
        
        viewHeader.frame = rectHeaderView
        
        tblRoomsBeds.tableHeaderView = viewHeader
    }
    
    @IBAction func changeDateFromLabel()
    {
        btnNext.isHidden = false
//        viewPickerHolder?.isHidden = true
        self.view.removeAddedSubview(view: viewPickerHolder!)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    
    // Following are the delegate and datasource implementation for picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if arrPickerData == nil
        {
            return 0
        }
        
        return arrPickerData.count;
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        let modelTemp = arrPickerData[row] as? RoomPropertyModel
        let str  = (modelTemp?.property_name)! as String
        
        attributedString = NSAttributedString(string: str, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor(red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)]))
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var str = ""
        let modelTemp = arrPickerData[row] as? RoomPropertyModel
        str = (modelTemp?.property_name)! as String
        strBedTypeID = (modelTemp?.property_id)! as String
        strBedType = str
        tblRoomsBeds.reloadData()
    }

    
    //
    //MARK: Room Detail Table view Handling
    /*
        Room Detail List View Table Datasource
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 102
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row==0)
        {
            let cell:CellGuest = tblRoomsBeds.dequeueReusableCell(withIdentifier: "CellGuest") as! CellGuest
            cell.mmaxguest_Lbl.text = self.lang.maxgues_Tit
            cell.delegate = self
            return cell
        }
        if(indexPath.row==1)
        {
            let cell:CellBedrooms = tblRoomsBeds.dequeueReusableCell(withIdentifier: "CellBedrooms") as! CellBedrooms
            cell.bedrms_Lbl.text = self.lang.bdrms_Tit
            cell.delegate = self
            return cell
        }
        if(indexPath.row==2)
        {
            let cell:CellBeds = tblRoomsBeds.dequeueReusableCell(withIdentifier: "CellBeds") as! CellBeds
            cell.beds_Lbl.text = self.lang.capbed_Title
            cell.delegate = self
            return cell
        }
        if(indexPath.row==3)
        {
            let cell:CellBedTypes = tblRoomsBeds.dequeueReusableCell(withIdentifier: "CellBedTypes") as! CellBedTypes
            cell.lblBedTypes.text = strBedType
            cell.bedtyp_Lbl.text = "\(self.lang.bedtyp_Title)s"
            cell.delegate = self
            return cell
        }
        else
        {
            let cell:CellBathrooms = tblRoomsBeds.dequeueReusableCell(withIdentifier: "CellBathrooms") as! CellBathrooms
            cell.bath_Lbl.text = "\(self.lang.capbath_Title)s"
            cell.delegate = self
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE METHOD
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexPath = IndexPath(row: indexPath.row , section: 0)
        let cell = tblRoomsBeds.cellForRow(at: indexPath)
        if (cell is CellGuest)
        {
        }
    }
    
    //MARK: CREATE MODEL FOR LISTING ROOMS
    /*
      MOVE TO ADD ROOM DETAIL AFTER GETTING NEW ROOM ID
     */
    @IBAction func onFinishListing(_ sender:UIButton!)
    {
        let tempModel = ListingModel()
        tempModel.room_type = strRoomType as NSString
        tempModel.room_location = strRoomLocation as NSString
        tempModel.latitude = latitude as NSString
        tempModel.longitude = longitude as NSString
        tempModel.max_guest_count = strMaxGuest as NSString
        tempModel.bedroom_count = strBedroomsCount as NSString
        tempModel.beds_count = strBedsCount as NSString
        tempModel.bathrooms_count = strBathroomsCount as NSString
        tempModel.room_id = strRoomID as NSString
        tempModel.room_location = strRoomLocation as NSString
        tempModel.room_thumb_images = []
        tempModel.remaining_steps = "3"
        tempModel.home_type = strPropertyName as NSString
        tempModel.policy_type = "Flexible"
        tempModel.isListEnabled = "No"
        tempModel.bed_type = strBedTypeID as NSString
        tempModel.property_type = strPropertyType as NSString
        appDelegate.strRoomID = strRoomID
        let  userDefaults = UserDefaults.standard
        tempModel.length_of_stay_options = appDelegate.arrNightData as! NSMutableArray
        tempModel.currency_code = (userDefaults.object(forKey: APPURL.USER_CURRENCY_ORG) as? NSString)!
        tempModel.currency_symbol = (userDefaults.object(forKey: APPURL.USER_CURRENCY_SYMBOL_ORG) as? NSString)!
        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddRoomDetails") as! AddRoomDetails
        locView.hidesBottomBarWhenPushed = false
        locView.listModel = tempModel
        locView.strRemaingSteps = "3"
        appDelegate.isFromNewTime = true
        self.navigationController?.hidesBottomBarWhenPushed = false
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.navigationController?.pushViewController(locView, animated: true)
        

    }
    
    //MARK: NEXT BTN ACTION
    //MARK: API CALL - CREATE NEW ROOM
    /*
     HERE WE ARE PASSING PREVIOUS DETAILS (i.e - > room_type,property_type,latitude,longitude,max_guest_coun etc.,)
     */
    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        var dicts = [AnyHashable: Any]()
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        dicts["token"]              = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_type"]          = strRoomType
        dicts["property_type"]      = strPropertyType
        dicts["latitude"]           = latitude
        dicts["longitude"]          = longitude
        dicts["max_guest"]          = strMaxGuest
        dicts["bedrooms_count"]     = strBedroomsCount
        dicts["beds_count"]         = strBedsCount
        dicts["bathrooms"]          = strBathroomsCount
        dicts["bed_type"]           = strBedTypeID
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ADD_NEW_ROOM as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    self.strRoomID = gModel.room_id as String
                    self.strRoomLocation = gModel.room_location as String
//                    self.lenthofstay.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                    self.showAlertForRemainingSteps()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAdded"), object: self, userInfo: nil)
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
    
    /*
     HERE WE ARE DISPLAYING SUCCESS ALERT AFTER CREATING ROOM
     */
    func showAlertForRemainingSteps()
    {
//        viewStepsAlert?.isHidden = false
        self.view.addCenterView(centerView: viewStepsAlert!)
        btnNext.isHidden = true
    }
    
    
    //MARK: DELEGATE METHODS OF ROOM BEDS CELL
    /*
     HERE WE ARE GETTING ROOMS & BEDS COUNT
     */
    internal func onHostGuestChanged(value : Int)
    {
        strMaxGuest = String(format:"%d",value)
    }
    
    internal func onHostBedRoomsChanged(value : Int)
    {
        strBedroomsCount = String(format:"%d",value)
    }
    
    internal func onHostBedsChanged(value : Int)
    {
        strBedsCount = String(format:"%d",value)
    }
    
    internal func onBedTypesChanged(value : Int)
    {
        btnNext.isHidden = true
//        viewPickerHolder?.isHidden = false
        self.view.addFooterView(footerView: viewPickerHolder!)
    }
    
    internal func onHostBathroomsChanged(value : Double)
    {
        strBathroomsCount = String(format:"%.1f",value).replacingOccurrences(of: ".0", with: "")
    }
    
    //MARK: ------------ DELEGATE METHODS END ------------
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

protocol HostGuestDelegate
{
    func onHostGuestChanged(value : Int)
}


class CellGuest: UITableViewCell
{
    @IBOutlet var lblGuest: UILabel!
    var nCurrentGuestCount : Int = 1
    var delegate: HostGuestDelegate?

    @IBOutlet weak var mmaxguest_Lbl: UILabel!
    // MARK: Add Or Remove Guest Tapped
    /*
     Tag - 11 - Add Guest
     Tag - 22 - Remove Guest
     */
    
    @IBAction func onGuestTapped(_ sender:UIButton!)
    {
        if sender.tag==11
        {
            if  nCurrentGuestCount >= 16 {
                return
            }
            
            nCurrentGuestCount += 1
        }
        else
        {
            if  nCurrentGuestCount == 1 {
                return
            }
            nCurrentGuestCount -= 1
        }
        delegate?.onHostGuestChanged(value : nCurrentGuestCount)
        lblGuest.text = String(format: (nCurrentGuestCount == 16) ? "%d+" : "%d", nCurrentGuestCount)
    }
}

protocol HostBedDelegate
{
    func onBedTypesChanged(value : Int)
}

class CellBedTypes : UITableViewCell
{
    @IBOutlet var lblBedTypes: UILabel!
    var nBedRoomsCount : Int = 1
    var delegate: HostBedDelegate?
    
    @IBOutlet weak var bedtyp_Lbl: UILabel!
    // MARK: Add Or Remove Bedrooms Tapped
    /*
     Tag - 11 - Add Bedrooms
     Tag - 22 - Remove Bedrooms
     */
    
    
    @IBAction func onBedroomsTapped(_ sender:UIButton!)
    {
        delegate?.onBedTypesChanged(value : nBedRoomsCount)
    }
}

protocol HostBedRoomsDelegate
{
    func onHostBedRoomsChanged(value : Int)
}
class CellBedrooms : UITableViewCell
{
    @IBOutlet var lblBedrooms: UILabel!
    var nBedRoomsCount : Int = 1
    var delegate: HostBedRoomsDelegate?

    @IBOutlet weak var bedrms_Lbl: UILabel!
    // MARK: Add Or Remove Bedrooms Tapped
    /*
     Tag - 11 - Add Bedrooms
     Tag - 22 - Remove Bedrooms
     */
    
    
    @IBAction func onBedroomsTapped(_ sender:UIButton!)
    {
        if sender.tag==11
        {
            if  nBedRoomsCount >= 10 {
                return
            }
            
            nBedRoomsCount += 1
        }
        else
        {
            if  nBedRoomsCount == 1 {
                return
            }
            nBedRoomsCount -= 1
        }
        delegate?.onHostBedRoomsChanged(value : nBedRoomsCount)

        lblBedrooms.text = String(format:"%d", nBedRoomsCount)
    }
}

protocol HostBedsDelegate
{
    func onHostBedsChanged(value : Int)
}

class CellBeds: UITableViewCell
{
    @IBOutlet var lblBeds: UILabel!
    var nBedsCount : Int = 1
    var delegate: HostBedsDelegate?

    @IBOutlet weak var beds_Lbl: UILabel!
    // MARK: Add Or Remove Beds Tapped
    /*
     Tag - 11 - Add Beds
     Tag - 22 - Remove Beds
     */
    
    @IBAction func onBedsTapped(_ sender:UIButton!)
    {
        if sender.tag==11
        {
            if  nBedsCount >= 16 {
                return
            }
            
            nBedsCount += 1
        }
        else
        {
            if  nBedsCount == 1 {
                return
            }
            nBedsCount -= 1
        }
        delegate?.onHostBedsChanged(value : nBedsCount)

        lblBeds.text = String(format: (nBedsCount == 16) ? "%d+" : "%d", nBedsCount)
    }
}

protocol HostBathroomsDelegate
{
    func onHostBathroomsChanged(value : Double)
}

class CellBathrooms : UITableViewCell
{
    @IBOutlet var lblBathrooms: UILabel!
    var nBathrooomsCount : Double = 1
    var delegate: HostBathroomsDelegate?

    @IBOutlet weak var bath_Lbl: UILabel!
    // MARK: Add Or Remove Bathrooms
    /*
     Tag - 11 - Add Bathrooms
     Tag - 22 - Remove Bathrooms
     */
    
    @IBAction func onBathroomsTapped(_ sender:UIButton!)
    {
        if sender.tag==11
        {
            if  nBathrooomsCount >= 8 {
                return
            }
            
            nBathrooomsCount += 0.5
        }
        else
        {
            if  nBathrooomsCount == 1 {
                return
            }
            nBathrooomsCount -= 0.5
        }
        delegate?.onHostBathroomsChanged(value : nBathrooomsCount)
        lblBathrooms.text = String(format: "%.1f", nBathrooomsCount).replacingOccurrences(of: ".0", with: "")
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
