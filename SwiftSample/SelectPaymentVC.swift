/**
* SelectPaymentVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class SelectPaymentVC : UIViewController {
    
    @IBOutlet weak var selectpay_Lbl: UILabel!
    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
//    let arrSettingData: [String] = ["Invite friends", "Wish Lists", "Settings", "Help & Support", "Why host","List your space","Give us feedback","Logout"]
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnAddPayment: UIButton!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad()
    {
        super.viewDidLoad()
            self.navigationController?.isNavigationBarHidden = true
        self.view.appGuestViewBGColor()
        btnAddPayment.layer.borderColor = UIColor.white.cgColor
        btnAddPayment.layer.borderWidth = 1.5
        btnAddPayment.layer.cornerRadius = btnAddPayment.frame.size.height/2
        //btnAddPayment.nextButtonImage()
        self.selectpay_Lbl.text = self.lang.select_Pay
        self.btnAddPayment.setTitle(self.lang.add_Pay, for: .normal)
        btnSave.layer.cornerRadius = btnSave.frame.size.height/2
    }
    
    // MARK: Save Button status
    /*
     */
    
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        
    }

    @IBAction func onAddPaymentTapped(_ sender:UIButton!)
    {
        
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

