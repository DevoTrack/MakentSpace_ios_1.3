/**
* CouponVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

protocol CouponDelegate
{
    func onCouponAdded(index:Int)
}

class CouponVC: UIViewController,UITextFieldDelegate
{
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var txtFldCouponCode: UITextField!
    @IBOutlet var viewPetsHolder: UIView!
    
    @IBOutlet weak var coup_Lbl: UILabel!
    
    @IBOutlet weak var coup_Tit: UILabel!
    var nCurrentGuest: Int = 0
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var petsSelected:Bool = false
    
    var delegate: CouponDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnApply.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        btnApply.layer.borderWidth = 1.5
        btnApply.layer.cornerRadius = btnApply.frame.size.height/2
        btnApply.setTitle(self.lang.app_Tit, for: .normal)
        self.coup_Tit.text = self.lang.coup_Tit
        self.coup_Lbl.text = self.lang.ent_Coup
//        btnApply.backgroundColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 0.5)
        
        btnApply.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        btnApply.setTitleColor(UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0), for: UIControl.State.normal)
    }
    
    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        let letght =  textField.text?.count
        
        if letght!>0
        {
            btnApply.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
            btnApply.backgroundColor = UIColor.white.withAlphaComponent(1.0)

            btnApply.setTitleColor(UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0), for: UIControl.State.normal)
        }
        else
        {
            btnApply.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            btnApply.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            btnApply.setTitleColor(UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0), for: UIControl.State.normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    

    // MARK: Save Button status
    /*
     
     */

    @IBAction func onApplyTapped(_ sender:UIButton!)
    {
        delegate?.onCouponAdded(index: Int((txtFldCouponCode.text)!)!)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
}
