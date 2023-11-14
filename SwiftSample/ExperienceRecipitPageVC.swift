//
//  ExperienceRecipitPageVC.swift
//  Makent
//
//  Created by Trioangle on 31/01/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//
import UIKit

class ExperienceRecipitPageVC: UIViewController {
    
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var expTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var strLocationName:String = ""
    var currencyCode:String = ""
    var guestCount:String = ""
    var serviceFee:String = ""
    var totalAmt:String = ""
    var subtotal:String = ""
    var perhead:String = ""
    var currencySym:String = ""
    var couponAmount : Int?
    var isFromGuestSide:Bool = false
    var isExperiences:Bool = false
    var arrTitle = [String]()
    var arrPirce = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        expTableView.delegate = self
        expTableView.dataSource = self
        self.titleLabel.text = self.lang.customer_Title
//        if isFromGuestSide ==  true{
//            titleLabel.text = ""
//        }
        
        if strLocationName.first == " "{
            strLocationName.removeFirst()
        }
        locationlabel.text = strLocationName
        expTableView.tableHeaderView = tblHeaderView
        
        if isExperiences {
            let a = Int(subtotal) ?? 0
            let b = Int(guestCount) ?? 0
            let total = a * b
            arrTitle.append("\(currencySym)\(subtotal) x \(guestCount)\(self.lang.guest_Title)")
            arrPirce.append("\(currencySym)\(total)")
        }else{
            arrTitle.append("\(currencySym)\(perhead) x \(guestCount)\(self.lang.guest_Title)")
            arrPirce.append("\(currencySym)\(subtotal)")
        }
        if isFromGuestSide == true {
            arrTitle.append(self.lang.servicefee_Title)
            arrPirce.append("\(currencySym)\(serviceFee)")
            locationlabel.font = UIFont(name: "Helvetica Neue", size: 18)
            
        }
        if let _couponAmount = self.couponAmount,_couponAmount != 0{
            arrTitle.append("Coupon Amount")
            arrPirce.append("-\(currencySym)\(_couponAmount)")
        }
        arrTitle.append("\(self.lang.tott_Tit) (\(currencyCode))")
        arrPirce.append("\(currencySym)\(totalAmt)")
        self.expTableView.reloadData()
    }
    
    @IBAction func experienceAction(_ sender: UIButton) {
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension ExperienceRecipitPageVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count != 0 ? arrTitle.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellExpPrice = expTableView.dequeueReusableCell(withIdentifier: "CellExpPrice") as! CellExpPrice
        cell.titleLabel?.text = arrTitle[indexPath.row]
        cell.priceLabel?.text = arrPirce[indexPath.row]
        let check = "\(self.lang.tott_Tit)(\(currencyCode))"
        if cell.titleLabel?.text == check {
           cell.titleLabel?.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 18)!
           cell.priceLabel?.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 18)!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
class CellExpPrice:UITableViewCell{
    @IBOutlet var priceLabel: UILabel?
    @IBOutlet var titleLabel: UILabel?
}
