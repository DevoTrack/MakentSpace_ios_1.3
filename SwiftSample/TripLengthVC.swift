//
//  TripLengthVC.swift
//  Makent
//
//  Created by Trioangle on 13/01/18.
//  Copyright © 2018 Mani kandan. All rights reserved.
//

import UIKit
import MessageUI
import Social

class TripLengthVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblAdditionalPrice: UITableView!
    @IBOutlet var tblHeader: UIView!
//    @IBOutlet weak var trip_Title: UILabel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrSpecialPrices = [String]()
    var arrPrices = [String]()
    var arrSpecialOffers = [String]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var availability : NSMutableArray = NSMutableArray()
   
    @IBOutlet weak var trip_Title: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.trip_Title.text = self.lang.triplength_Title
        print(availability.count,arrSpecialPrices.count,arrSpecialPrices,arrPrices,arrPrices.count)
        self.navigationController?.isNavigationBarHidden = true
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
    }
    
    //
    //MARK: Room Detail Table view Handling
    /*
     Additional Price List View Table Datasource & Delegates
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section==0
        {
        
            if arrSpecialPrices[indexPath.row] == "Availability"{
        
                return 44
             }
            else{
                return 90
            }
        }
        else{
            return 110
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return arrSpecialPrices.count
        }
        else{
             return availability.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section==0
        {
            let cell:CellAdditionalPrice = tblAdditionalPrice.dequeueReusableCell(withIdentifier: "CellAdditionalPrice")! as! CellAdditionalPrice
            cell.lblTitle?.text = arrSpecialPrices[indexPath.row]
            cell.lblSubTitle?.text = arrPrices[indexPath.row]
            if cell.lblTitle?.text == "Availability"{
                cell.lblLine?.isHidden = true
                cell.lblSubTitle?.isHidden = true
            }
            return cell
        }
        else {
            let cell:CellAvailability = tblAdditionalPrice.dequeueReusableCell(withIdentifier: "CellAvailability")! as! CellAvailability
            let Model = availability[indexPath.row] as! RoomDetailModel
            let during = Model.during as String
            let max = Model.maximumstay as String
            let min = Model.minimumstay as String
            if during == "" {
                
                cell.lblSubTitle?.text = "\(self.lang.guestmin_Title)\(min) \(self.lang.night_Title) \n\(self.lang.guestmax_Title) \(max) \(self.lang.night_Title)"
            }
            else if max == ""{
                
                cell.lblSubTitle?.text = "\(self.lang.during_Title) \(during)\n\(self.lang.guestmin_Title) \(min) \(self.lang.night_Title)"
            }
            else if min == ""{
                
                cell.lblSubTitle?.text = "\(self.lang.during_Title) \(during)\n\(self.lang.guestmax_Title) \(max) \(self.lang.night_Title)"
            }
            else{
                
                cell.lblSubTitle?.text = "\(self.lang.during_Title) \(during)\n\(self.lang.guestmin_Title) \(min) \(self.lang.night_Title) \n\(self.lang.guestmax_Title) \(max) \(self.lang.night_Title)"
            }
            return cell
        }
        
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // did select method
      
    }
    
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
}

class CellAvailability : UITableViewCell{
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblSubTitle: UILabel?

}

