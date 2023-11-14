/**
* AmenitiesVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class AmenitiesVC : UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableAmenities: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var modelAmenities: UIButton!
    
    
    var arrAllAmenities = NSArray()
    var nCurrentCount : Int = 0
    var arrAmenities = [String]()
    var arrCurrentAmenities : [Amenities]!
    //var arrCurrentAmenities : NSMutableArray = NSMutableArray()
    var arraminities : NSMutableArray = NSMutableArray()

    @IBOutlet weak var ament_Tit: UILabel!
    var isFromHostAddRoom : Bool = false
    var arrimg = ["A","B","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    var dictAmenitiesData  = [NSDictionary]()
    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let arrSettingData: [String] = ["Wifi", "Air Conditioning", "Pool", "Kitchen", "Parking","Breakfast","Indoor fireplace","Heating","Family Friendly","Washer","Dryer","Essentials","Shampoo","Hair dryer","Iron"]
    let arrimgDetails: [String] = ["gifts.png", "gifts.png", "gifts.png", "gifts.png", "gifts.png","gifts.png","gifts.png","gifts.png","gifts.png","gifts.png","gifts.png","gifts.png","gifts.png","gifts.png","gifts.png"]
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("AmenitiesVC")
        print("AmenitiesVC count",arrCurrentAmenities.count)
        self.navigationController?.isNavigationBarHidden = true
        let path = Bundle.main.path(forResource: "amenities", ofType: "plist")
        self.ament_Tit.text = self.lang.amenit_Tit
        dictAmenitiesData = NSArray.init(contentsOfFile: path!)! as! [NSDictionary]
        //self.loadAmentities()
        tableAmenities.tableHeaderView = tblHeaderView
    }
    var amentitiesData : [NSDictionary] = []
    
    func onLoadData()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = String(format:"%@/amenities.plist",paths)
        let fileManager = FileManager.default
        if ((fileManager.fileExists(atPath: path)))
        {
            amentitiesData = NSArray.init(contentsOfFile: path)! as! [NSDictionary]
            //self.dictAmenitiesData = NSDictionary(contentsOfFile: path)!
            self.tableAmenities.reloadData()
        }
    }
    
    fileprivate func loadAmentities () {
        
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
                    
                    self.tableAmenities.reloadData()
                }
                MakentSupport().removeProgress(viewCtrl: self)
                
                
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                MakentSupport().removeProgress(viewCtrl: self)
                
                self.tableAmenities.reloadData()
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 76
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCurrentAmenities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:AmenitiesCell = tableAmenities.dequeueReusableCell(withIdentifier: "AmenitiesCell") as! AmenitiesCell
//        let icon = (arrCurrentAmenities[indexPath.row] as! [String:Any])["icon"] as? String
//        cell.lblName?.text = (arrCurrentAmenities[indexPath.row] as! [String:Any])["name"] as? String
//         if ((arrCurrentAmenities[indexPath.row] as! [String:Any])["icon"] as? String)?.count == 1 {
//            cell.lblIcons?.text = (arrCurrentAmenities[indexPath.row] as! [String:Any])["icon"] as? String
//        }
//         else{
//            cell.lblIcons?.text = "t"
//        }
//        cell.lblName?.text = (arrCurrentAmenities[indexPath.row] as! [String:Any])["name"] as? String
//        if ((arrCurrentAmenities[indexPath.row] as! [String:Any])["icon"] as? String)?.count == 1 {

//        }
//        else{
//            cell.lblIcons?.text = "t"
//        }
        cell.amenitiesImg.addRemoteImage(imageURL: arrCurrentAmenities[indexPath.row].imageName, placeHolderURL: "")
        
        cell.lblName?.text = arrCurrentAmenities[indexPath.row].name
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row>=appDelegate.arrBookNames.count)
        {
            return;
        }
    }

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
}

