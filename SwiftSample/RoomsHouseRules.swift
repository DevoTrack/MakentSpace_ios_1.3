/**
* RoomsHouseRules.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

protocol HouseRulesAgreeDelegate
{
    func onAgreeTapped()
}

class RoomsHouseRules: UIViewController,UITextFieldDelegate {

    @IBOutlet var lblHostUserName: UILabel?
    @IBOutlet var txtRules: UITextView?
    @IBOutlet var viewAgreeHolder: UIView?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var strRoomId = ""
    var strHostUserName = ""
    var strHouseRules = ""
    var delegate: HouseRulesAgreeDelegate?
    var isFromRoomDetails : Bool = false
    var isFromRoomAboutHome : Bool = false
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var agree_btn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
         self.agree_btn.setTitle(self.lang.agree_Titlle, for: .normal)
        self.agree_btn.appGuestSideBtnBG()
        viewAgreeHolder?.isHidden = (isFromRoomDetails) ? true : false
        if isFromRoomAboutHome
        {
         lblHostUserName?.text = lang.abthome_Title
        }
        else
        {
        lblHostUserName?.text = String(format:"%@'s \(lang.housrul_Title)",strHostUserName)
        }
        lblHostUserName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        let height = MakentSupport().onGetStringHeight((lblHostUserName?.frame.size.width)!, strContent: String(format:"%@'s \(lang.housrul_Title)",strHostUserName) as NSString, font: (lblHostUserName?.font)!)
        var rectViewRule = lblHostUserName?.frame
        rectViewRule?.size.height = height+5
        lblHostUserName?.frame = rectViewRule!
        self.txtRules?.text = strHouseRules
        self.txtRules?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        let rect = MakentSupport().getScreenSize()
        var rectTxtView = txtRules!.frame
        rectTxtView.origin.y = (rectViewRule?.size.height)! + (rectViewRule?.origin.y)!
        rectTxtView.size.height = rect.size.height - (rectTxtView.origin.y)
        txtRules?.frame = rectTxtView
    }
    
    func getHouseRules()
    {
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"] = strRoomId
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_HOUSE_RULES as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let loginData = response as! NSDictionary
            OperationQueue.main.addOperation {
//                MakentSupport().removeProgress(viewCtrl: self)
                
                if loginData["status_code"] as! NSString == "1"
                {
                    if loginData["success_message"] as! NSString == "No House Rules..."
                    {
                        self.txtRules?.text = (loginData["success_message"] as! NSString) as String
                    }
                    else if loginData["house_rules"] != nil
                    {
                        self.txtRules?.text = (loginData["house_rules"] as! NSString) as String
                    }
                }
                else
                {
                   
                }
                
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
//         MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }
    
    // MARK: When User Press Back/Agree Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if sender.tag==11
        {
            delegate?.onAgreeTapped()
        }
        dismiss(animated: true, completion: nil)
    }
}
