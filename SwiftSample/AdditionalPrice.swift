/**
 * AdditionalPrice.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import MessageUI
import Social

class AdditionalPrice : UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tblAdditionalPrice: UITableView!
    @IBOutlet var tblHeader: UIView!
    @IBOutlet weak var extrafee: UILabel!
    @IBOutlet weak var cleanFee: UILabel!
    @IBOutlet weak var securityfee: UILabel!
    
    var strHostThumbUrl = ""
    var strRoomType = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var type = ""
    var type1 = ""
    var type2 = ""
    var change = ""
    var change1 = ""
    var change2 = ""
    var tablecount = ""
    
    var arrSpecialPrices = [String]()
    var arrPrices = [String]()
    var extrapeople = ""
    var security = ""
    var cleaningfee = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var arrLengthPrice = [String]()
    var arrEarlyPrice = [String]()
    var arrLastPrice = [String]()
    var arrLengthDiscount = [String]()
    var arrEarlyDiscount = [String]()
    var arrLastDiscount = [String]()
    var  arrTitle = ["Length of stay discounts","Early bird discounts","Last min discounts"]
    var arrlengthStayData : NSMutableArray = NSMutableArray()
    var arrEarlybirdData : NSMutableArray = NSMutableArray()
    var arrLastMinData : NSMutableArray = NSMutableArray()
    var arrRoomTypeData : NSArray = NSArray()
    var arForTable = [AnyHashable]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.ext_Peop.text = self.lang.ext_Peop
//        self.sec_Dep.text = self.lang.sec_Dep
//        self.cln_Fee.text = self.lang.clean_Fee
//        self.addpric_Title.text = self.lang.additionalprice_Title
        self.tblAdditionalPrice.showsVerticalScrollIndicator = false
            extrafee.text = extrapeople
            cleanFee.text = cleaningfee
            securityfee.text = security
        if arrlengthStayData.count != 0 && arrEarlybirdData.count != 0 && arrLastMinData.count != 0{
            type = "1"
        }
        arrTitle = [lang.staydiscount_Title,lang.earlydiscount_Title,lang.lastdisc_Title]
        if arrlengthStayData.count != 0 {
            for i in 0 ..< self.arrlengthStayData.count {
                let AddDiscountModel = arrlengthStayData[i] as? RoomDetailModel
                let discount = AddDiscountModel?.discount as! String
                let days = AddDiscountModel?.period as! String
                var day = ""
                if days == "7"{
                    day = lang.wekly_Title
                }
                else if days == "28"{
                    day = lang.mnthly_Title
                }
                else if days == "1"{
                    day = lang.nigt_Title
                }
                else{
                    day = lang.nights_Title
                }
                arrLengthPrice.append("\(discount)%")
                arrLengthDiscount.append("\(days) \(day)")
            }
        }
        
        if arrEarlybirdData.count != 0 {
            for i in 0 ..< self.arrEarlybirdData.count {
                let AddDiscountModel = arrEarlybirdData[i] as? RoomDetailModel
                let discount = AddDiscountModel?.discount as! String
                let days = AddDiscountModel?.period as! String
                var day = ""
                if days == "1"{
                    day = "day"
                }
                else{
                    day = "days"                }
              
                arrEarlyPrice.append("\(discount)%")
                arrEarlyDiscount.append("\(days) \(day)")
                
            }
        }
        if arrLastMinData.count != 0 {
            
            for i in 0 ..< self.arrLastMinData.count {
                
                let AddDiscountModel = arrLastMinData[i] as? RoomDetailModel
                let discount = AddDiscountModel?.discount as! String
                let days = AddDiscountModel?.period as! String
                var day = ""
                if days == "1"{
                    day =  lang.dayy_Title
                }
                else{
                    day = lang.dayys_Title
                }
                arrLastPrice.append("\(discount)%")
                arrLastDiscount.append("\(days) \(day)")
            }
        }
        
        self.navigationController?.isNavigationBarHidden = true
        tblAdditionalPrice.tableHeaderView = tblHeader
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
   
    //MARK: Room Detail Table view Handling
    /*
     Additional Price List View Table Datasource & Delegates
     */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblAdditionalPrice.frame.size.width) ,height: 40)
        let lblRoomName:UILabel = UILabel()
        lblRoomName.textAlignment = .center
        lblRoomName.frame =  CGRect(x: 0 , y:10, width: viewHolder.frame.size.width ,height: 40)
     if arrlengthStayData.count != 0 && arrEarlybirdData.count != 0 && arrLastMinData.count != 0{
        if section == 0
        {
            lblRoomName.text = lang.staydiscount_Title
        }
        else if section == 1
        {
            lblRoomName.text = lang.earlybird_Disc
        }
        else{
            lblRoomName.text = lang.lastmin_Disc
        }
      }
     else{
        if arrlengthStayData.count != 0 && arrEarlybirdData.count != 0{
            if section == 0
            {
                lblRoomName.text = lang.staydiscount_Title
            }
            else if section == 1
            {
                lblRoomName.text = lang.earlybird_Disc
            }
            else{
                lblRoomName.text=""
            }
        }
        else if arrlengthStayData.count != 0 && arrLastMinData.count != 0{
            if section == 0
            {
                lblRoomName.text = lang.staydiscount_Title
            }
            else if section == 1
            {
                lblRoomName.text=""
            }
            else{
                lblRoomName.text = lang.lastmin_Disc
            }
        }
        else if arrlengthStayData.count != 0{
            if section == 0
            {
                lblRoomName.text = lang.staydiscount_Title
            }
            else if section == 1
            {
                lblRoomName.text = ""
            }
            else{
                lblRoomName.text=""
            }
            
        }
        else if arrEarlyDiscount.count != 0{
            if section == 0
            {
                lblRoomName.text=""
            }
            else if section == 1
            {
                lblRoomName.text=lang.earlybird_Disc
            }
            else{
                lblRoomName.text=""
            }
            
        }
        else if arrLastDiscount.count != 0{
            if section == 0
            {
                lblRoomName.text=""
            }
            else if section == 1
            {
                lblRoomName.text=""
            }
            else{
                lblRoomName.text=lang.lastmin_Disc
            }
            
        }
        else{
            if section == 0
            {
                lblRoomName.text=""
            }
            else if section == 1
            {
                lblRoomName.text=""
            }
            else{
                lblRoomName.text=""
            }
        }
        
        }
        lblRoomName.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 15)
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return arrLengthDiscount.count
        }
        else if section == 1
        {
            return arrEarlyDiscount.count
        }
        else{
            
            return arrLastDiscount.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            if indexPath.section==0
            {
                let cell:CellOptionalPrice = tblAdditionalPrice.dequeueReusableCell(withIdentifier: "CellOptionalPrice") as! CellOptionalPrice
                cell.lblPrice?.text = arrLengthDiscount[indexPath.row]
                cell.lblCurrency?.text = arrLengthPrice[indexPath.row]
                return cell
            }
            else if indexPath.section==1{
                
                let cell:CellOptionalDiscount = tblAdditionalPrice.dequeueReusableCell(withIdentifier: "CellOptionalDiscount") as! CellOptionalDiscount
                cell.lbldiscont?.text = arrEarlyPrice[indexPath.row]
                cell.lblnyt?.text = arrEarlyDiscount[indexPath.row]
                return cell
            }
            else{
               let cell:CellDiscount = tblAdditionalPrice.dequeueReusableCell(withIdentifier: "CellDiscount") as! CellDiscount
               cell.lbldiscont?.text = arrLastDiscount[indexPath.row]
               cell.lblnyt?.text = arrLastPrice[indexPath.row]
               return cell
           }
        
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //did select method
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
   
}

class CellAdditionalPrice: UITableViewCell
{
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblSubTitle: UILabel?
    @IBOutlet var lblLine: UILabel?
    
}
class CellOptionalDiscount : UITableViewCell{
    
    @IBOutlet var lbldiscont: UILabel?
    @IBOutlet var lblnyt: UILabel?
    
}
class CellDiscount : UITableViewCell{
    
    @IBOutlet var lbldiscont: UILabel?
    @IBOutlet var lblnyt: UILabel?
    
}

