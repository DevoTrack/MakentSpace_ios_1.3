/**
* AddGuestVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

protocol AddGuestDelegate
{
    func onGuestAdded(index:Int)
}

class AddGuestVC: UIViewController,UITextFieldDelegate
{
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var guestLbl : UILabel!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnAddGuest: UIButton!
    @IBOutlet var btnRemoveGuest: UIButton!
    
    @IBOutlet weak var guestCountLabel: UILabel!
    var nCurrentGuest: Int = 0
    var nMaxGuestCount: Int = 0
    var isfromExplore = false
    var petsSelected:Bool = false
    
    var delegate: AddGuestDelegate?
    let lanugage = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if isfromExplore ==  true {
            nMaxGuestCount = 16
        }

      //  btnAddGuest.layer.cornerRadius = btnAddGuest.frame.size.height/2
       // btnSave.layer.cornerRadius = btnSave.frame.size.height/2
        print(nCurrentGuest)
        if nCurrentGuest == 0{
            nCurrentGuest = 1
        }
       // btnRemoveGuest.isHidden = nCurrentGuest == 1 ? true : false
        guestCountLabel.text = "\(nCurrentGuest.localize)"
            //  btnAddGuest.setTitle(nCurrentGuest.localize, for: .normal)
       // btnRemoveGuest.layer.borderColor = UIColor.white.cgColor
      //  btnRemoveGuest.layer.borderWidth = 1.5
      //  btnRemoveGuest.layer.cornerRadius = btnRemoveGuest.frame.size.height/2
      //  btnAddGuest.appGuestBGColor()
      //  btnRemoveGuest.appGuestBGColor()
     //   btnRemoveGuest.setTitleColor(.white, for: .normal)
        btnSave.appGuestTextColor()
        self.localize()
    }
    func localize(){
        self.guestLbl.text = self.lanugage.guests
        self.btnSave.setTitle(self.lanugage.save_Tit+" >", for: .normal)
    }
    // MARK: Add Or Remove Guest Tapped
    /*
        Tag - 11 - Add Guest
        Tag - 22 - Remove Guest
     */
    @IBAction func onAddOrRemoveTapped(_ sender:UIButton!)
    {
        if sender.tag==11
        {
            if  nCurrentGuest >= nMaxGuestCount {
                return
            }

            nCurrentGuest += 1
            guestCountLabel.text = "\(nCurrentGuest)"
        }
        else
        {
            if  nCurrentGuest == 1 || nCurrentGuest == 0{
                return
            }
            nCurrentGuest -= 1
            guestCountLabel.text = "\(nCurrentGuest)"
        }
      //  btnRemoveGuest.isHidden = nCurrentGuest == 1 ? true : false
       // btnAddGuest.setTitle(nCurrentGuest.localize, for:UIControl.State.normal)
    }
    
    // MARK: Save Button status
    /*
     
     */

    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        delegate?.onGuestAdded(index: nCurrentGuest)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
}
