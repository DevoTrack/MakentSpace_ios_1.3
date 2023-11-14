/**
* AllAmenitiesVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol AmenityChangedDelegate
{
    func AmenitiesChanged(strDescription: String)
}


class AllAmenitiesVC : UIViewController,UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblAmenities: UITableView!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var btnSave : UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    var delegate: AmenityChangedDelegate?

    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var arrValues = [String]()
    
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let arrMostCommon = ["Essentials~~~1","TV~~~2","Cable TV~~~3", "Air Conditioning~~~4","Heating~~~5", "Kitchen~~~6","Internet~~~7", "Wireless Internet~~~8"]
    
    let arrExtras = ["Hot tub~~~9","Washer~~~10","Pool~~~11","Dryer~~~12","Breakfast~~~13","Free Parking on Premises~~~14","Gym~~~15","Elevator in Building~~~16","Indoor Fireplace~~~17","Buzzer/Wireless Intercom~~~18","Doorman~~~19","Shampoo~~~20"]
    
    let arrSpecial = ["Family/Kid Friendly~~~21","Smoking allowed~~~22","Suitable for events~~~23","Pets Allowed~~~24","Pets live on this property~~~25","Wheelchair Accessible~~~26"]
    
    let arrHomeSafety = ["Smoke Detector~~~27","Carbon Monoxide Detector~~~28","First Aid Kit~~~29","Safety Card~~~30","Fire Extinguisher~~~31"]
    
    @IBOutlet weak var amen_Lbl: UILabel!
    var arrSelectedItems : NSMutableArray = NSMutableArray()
    var dictAmenitiesData : NSDictionary = NSDictionary()
    var arrAmenitiesData : NSArray = NSArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.btnBack.isUserInteractionEnabled = true
        self.amen_Lbl.text = self.lang.amenit_Tit
        self.btnSave.setTitle(self.lang.save_Tit, for: .normal)
        self.btnBack.transform = Language.getCurrentLanguage().getAffine
        self.btnBack.appHostTextColor()
        self.btnSave.appHostTextColor()
        self.navigationController?.isNavigationBarHidden = true
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        btnSave.isHidden = true
        if arrSelectedItems.count > 0
        {
            arrValues.append(arrSelectedItems.componentsJoined(by: ","))
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = String(format:"%@/amenities.plist",paths)
//        let fileManager = FileManager.default
//        if (!(fileManager.fileExists(atPath: path)))
//        {
            self.getAmenitiesList()
        
//        }
//        else
//        {
//            let paths = Bundle.main.path(forResource: "amenities", ofType: "plist")
//            arrAmenitiesData = NSArray.init(contentsOfFile: paths!)!
//            self.tblAmenities.reloadData()
//        }
    }
    
    func getAmenitiesList()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: false)
        
        var dicts = [AnyHashable: Any]()
        
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["language"] = Language.getCurrentLanguage().rawValue
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_AMENITIES_LIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
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
        let path = String(format:"%@/amenities.plist",paths)
        let fileManager = FileManager.default
        if ((fileManager.fileExists(atPath: path)))
        {
            arrAmenitiesData = NSArray.init(contentsOfFile: path)!
//            self.dictAmenitiesData = NSDictionary(contentsOfFile: path)!
            self.tblAmenities.reloadData()
        }
    }
    func onLoadData1()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = String(format:"%@/roomtype.plist",paths)
        let fileManager = FileManager.default
        if ((fileManager.fileExists(atPath: path)))
        {
            arrAmenitiesData = NSArray.init(contentsOfFile: path)!
            //            self.dictAmenitiesData = NSDictionary(contentsOfFile: path)!
            self.tblAmenities.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
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
        self.btnBack.isUserInteractionEnabled = true

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrAmenitiesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellAmenitiesAll = tblAmenities.dequeueReusableCell(withIdentifier: "CellAmenitiesAll")! as! CellAmenitiesAll
        let dictTemp = arrAmenitiesData[indexPath.row] as! NSDictionary
        let currencyModel = dictTemp.value(forKey: "name")//(forKeyPath: String(format:"%name",indexPath.row))
        cell.lblAmenities?.text = currencyModel as! String?
        cell.lblAmenities?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        let strIds = dictTemp.value(forKey: "id")

//        let strIds = (dictAmenitiesData.value(forKeyPath: String(format:"%d.id",indexPath.row))!)
        cell.lblTickMark.text = (arrSelectedItems.contains(String(format:"%d",strIds as! Int))) ? "9" : ""
        cell.lblTickMark.appHostTextColor()
        cell.lblTickMark.borderColor = UIColor.appHostThemeColor

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dictTemp = arrAmenitiesData[indexPath.row] as! NSDictionary
        let strIds = dictTemp.value(forKey: "id")

//        let strIds = (dictAmenitiesData.value(forKeyPath: String(format:"%d.id",indexPath.row))!)

        if arrSelectedItems.contains(String(format:"%d",strIds as! Int))
        {
            arrSelectedItems.remove(String(format:"%d", strIds as! Int))
        }
        else
        {
            arrSelectedItems.add(String(format:"%d", strIds as! Int))
        }
        let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
        tblAmenities.reloadRows(at: [indexPath], with: .none)
        checkSaveButtonStatus()
    }
    
    func checkSaveButtonStatus()
    {
        var arrDummyValues = [String]()
        arrDummyValues.append(arrSelectedItems.componentsJoined(by: ","))
        if arrValues == arrDummyValues {
            btnSave.isHidden = true
        } else {
            btnSave.isHidden = false
        }
    }
    
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        self.btnBack.isUserInteractionEnabled = false

        var dicts = [AnyHashable: Any]()
        
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        self.btnSave?.isHidden = true
        
        self.animatedLoader?.isHidden = false
        
        dicts["room_id"]   = appDelegate.strRoomID
        dicts["selected_amenities"]   = arrSelectedItems.componentsJoined(by: ",")
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_UPDATE_SELECTED_AMENITIES as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            
            print("general model: \(response)")
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
                
                if gModel.status_code == "1"
                {
                    self.btnBack.isUserInteractionEnabled = true
                    let str = self.arrSelectedItems.componentsJoined(by: ",")
                    self.delegate?.AmenitiesChanged(strDescription: str)
                    self.navigationController!.popViewController(animated: true)
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    //                    self.btnBack.isUserInteractionEnabled = true
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped()
    {
        
    }
}

class CellAmenitiesAll: UITableViewCell
{
    @IBOutlet var lblAmenities: UILabel?
    @IBOutlet var lblTickMark: UILabel!

}

