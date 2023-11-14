/**
* MakePaymentVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class MakePaymentVC : UIViewController
{
    @IBOutlet var tableProfile: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btnCreaditCard: UIButton!
    @IBOutlet var btnPayPal: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet weak var selectpay_Lbl: UILabel!
    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.appGuestViewBGColor()
        btnNext.alpha = 0.5
        btnNext.isUserInteractionEnabled = false
        btnNext.transform = Language.getCurrentLanguage().getAffine
        btnNext.nextButtonImage()
        self.selectpay_Lbl.text = self.lang.select_Pay
        self.selectpay_Lbl.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.btnPayPal.setTitle("PayPal", for: .normal)
        self.btnCreaditCard.setTitle(self.lang.crdit_Titlt, for: .normal)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func onPaymentTypeTapped(_ sender:UIButton!)
    {
        btnNext.alpha = 1.0
        btnNext.isUserInteractionEnabled = true

        let  userDefaults = UserDefaults.standard
        userDefaults.synchronize()

        if sender.tag == 11
        {
            userDefaults.set(self.lang.crdit_Titlt, forKey: "paymenttype")
            btnCreaditCard.setTitleColor(UIColor.white, for: .normal)
            btnPayPal.setTitleColor(UIColor.black, for: .normal)
        }
        else if sender.tag == 22
        {
            userDefaults.set("PayPal", forKey: "paymenttype")
            btnPayPal.setTitleColor(UIColor.white, for: .normal)
            btnCreaditCard.setTitleColor(UIColor.black, for: .normal)
        }
        else
        {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        }
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

