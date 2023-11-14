/**
* AddMessageVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

protocol AddMessageDelegate
{
    func onMessageAdded(messsage:String)
}

class AddMessageVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet var viewTopHolder: UIView!
    @IBOutlet var txtViewMessage: UITextView!
    @IBOutlet var viewMessageHolder: UIView!
    @IBOutlet var imgReceiver: UIImageView!
    var urlHostImg : String = ""
    var strHostUserId : String = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var delegate: AddMessageDelegate?
    var strMessage : String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let nameval = UserDefaults.standard.value(forKey: "full_name") as! String
    @IBOutlet weak var save_Btn: UIButton!
    @IBOutlet weak var intro_Message: UILabel!
    @IBOutlet weak var intro_Title: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewTopHolder.layer.shadowColor = UIColor.gray.cgColor;
        viewTopHolder.layer.shadowOffset = CGSize(width:0, height:0.8);
        viewTopHolder.layer.shadowOpacity = 0.4;
        viewTopHolder.layer.shadowRadius = 0.0;
        self.intro_Title.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.intro_Message.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.txtViewMessage.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.intro_Title.text = self.lang.int_Yrslf
        self.intro_Message.text = "\(self.lang.tel_Tit) \(nameval) \(self.lang.tel_Desc)"
        imgReceiver.layer.cornerRadius = imgReceiver.frame.size.height/2
        imgReceiver.clipsToBounds = true
        save_Btn.setTitle(self.lang.save_Tit, for: .normal)
        txtViewMessage.text = (strMessage.count>0) ? strMessage : ""
        UITextView.appearance().tintColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
        imgReceiver.addRemoteImage(imageURL: urlHostImg, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: urlHostImg) as URL?, placeholderImage:UIImage(named:""))

        txtViewMessage.becomeFirstResponder()
    }
    
    // MARK: Host Profile Button Action

    @IBAction func onHostProfileTapped()
    {
        let viewProfile = StoryBoard.account.instance.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        viewProfile.strOtherUserId = strHostUserId
        viewProfile.hidesBottomBarWhenPushed = true
        present(viewProfile, animated: true, completion: nil)

    }
    
    // MARK: Save Message Button Action
    /*
     
     */
    @IBAction func onSaveMsgTapped(_ sender:UIButton!)
    {
        if txtViewMessage.text.count>0
        {
            let  userDefaults = UserDefaults.standard
            userDefaults.set(txtViewMessage.text, forKey: "hostmessage")
            userDefaults.synchronize()
            delegate?.onMessageAdded(messsage: txtViewMessage.text)
            self.onBackTapped(nil)
        }
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
