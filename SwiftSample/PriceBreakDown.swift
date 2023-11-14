/**
 * PriceBreakDown.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import MessageUI
import Social

class PriceBreakDown : UIViewController,UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var tblPriceBreakDown: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var lblSeparator: UILabel!
    @IBOutlet var lblRoomDetails: UILabel!
    @IBOutlet var lblPageTitle: UILabel!
    
    @IBOutlet weak var animatedLoader: FLAnimatedImageView!
    
   // var strPriceDetail:String = ""
  //  var strServiceFee:String = ""
  //  var strLengthFee:String = ""
  //  var strBookFee:String = ""
  //  var strLengthDetail:String = ""
  //  var strBookDetail = ""
  //  var strTotalPrice : NSAttributedString!
    //var strLocationName:String = ""
   // var strTotalNights:String = ""
    var strNightPrice:String = ""
   // var strCurrency : String = ""
    var strPageTitle:String = ""
    var strHostFee:String = ""
    var hostoruser:String = ""
    var reservation_id = ""
    var type = ""
    var isNoHostFee :Bool = false
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrBreak = [tripList]()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var serviceKey : String = ""
    var priceBreakDatas : PriceBreakDownData!
//    var arrPrice = [String]()
//    var arrPirceDesc = [String]()
    var isFromReservation : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //print(arrPrice,arrPirceDesc,strBookDetail,strLengthDetail)
        self.lblPageTitle.text = self.lang.pay_Brk
       // MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        if strPageTitle.count > 0
        {
            lblPageTitle.text = strPageTitle
        }
        self.navigationController?.isNavigationBarHidden = true
        lblSeparator?.alpha = 0.0
//        print("kkk \(strLengthFee,strBookFee)")
        
//        if strLengthFee != "0" && strBookFee != "0"{
//            type = "2"
//            print("both are not null:")
//        }
//        else {
//            if strLengthFee != "0"{
//                type = "length"
//            }
//            else if strBookFee != "0"{
//                type = "book"
//            }
//            else{
//                type = "1"
//            }
//        }
    
//        if strPriceDetail != "" || strServiceFee != "" || strHostFee != "" || strBookFee != "0" || strLengthFee != "0"{
//
//            if strTotalNights.count > 0 {
//                strNightPrice = String(format: "%@ %d",strCurrency,Int(strPriceDetail)! * Int(strTotalNights)!)
//                strPriceDetail = String(format:"%@ %@ x %@ \(lang.nights_Title)",strCurrency, strPriceDetail, strTotalNights)
//                lblRoomDetails.text = String(format: "%@ \(lang.nightsin_Title) %@",strTotalNights,strLocationName)
//            }
//            strServiceFee = String(format:"%@ %@",strCurrency, strServiceFee)
//            strHostFee = String(format:"%@ %@",strCurrency, strHostFee)
//            strLengthFee = String(format:"-%@ %@",strCurrency, strLengthFee)
//            strBookFee = String(format:"-%@ %@",strCurrency, strBookFee)
//        }
        tblPriceBreakDown.tableHeaderView = tblHeaderView
        print(lblPageTitle)
        print(lblPageTitle.frame)
        print(lblRoomDetails)
        print(lblRoomDetails.frame)
        self.getTripsDetails()
        tblPriceBreakDown.tableFooterView = UIView()
    }
    
    func getTripsDetails()
    {
        var dicts = [AnyHashable: Any]()
        let getMainPage =  UserDefaults.standard.object(forKey: "getmainpage") as? NSString
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["s_key"] = self.serviceKey == "" ? "" : self.serviceKey
        
        if self.serviceKey.count == 0 {
            dicts["reservation_id"] = self.reservation_id
        }
        else {
            dicts["reservation_id"] = ""
            
        }
        if isFromReservation {
            dicts["user_type"] = "host"
        }
        else {
            dicts["user_type"] = "guest"
        }
        
        
        self.animatedLoader.isHidden = false
        

        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "price_breakdown", paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            print(responseDict)
            
            self.priceBreakDatas = PriceBreakDownData(priceJson: responseDict)
            self.tblPriceBreakDown.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 50
    }
    
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tblHeaderView
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.arrBreak.count
        if self.priceBreakDatas != nil
        {
            return self.priceBreakDatas.priceBrkData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       // print("type \(type),\(arrPrice.count)")
        let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
        let priceBreak = self.priceBreakDatas.priceBrkData[indexPath.row]
        if isFromReservation {
            cell.lblDetails?.text = priceBreak.key
            cell.lblPrice?.text = priceBreak.key == "Host Fee" ? "- \(priceBreak.value)" : priceBreak.value
        }
        else {
            cell.lblDetails?.text = priceBreak.key == "Host Fee" ? "Service Fee" : priceBreak.key
            cell.lblPrice?.text = priceBreak.value
        }
        print("key",priceBreak.key)
        print("values",priceBreak.value)
        
        return cell
       
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellPriceBreakDown: UITableViewCell
{
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblMessage: UILabel?
    @IBOutlet var lblPrice: UILabel?
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblLine1: UILabel!

}

class CellNightPrice: UITableViewCell
{
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblPrice: UILabel?
    @IBOutlet weak var lblLine: UILabel!

}

/*
 
 if isNoHostFee == true{
 return 61
 }
 
 if type == "2"{
 if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2
 {
 if indexPath.row == 1
 {
 print("strBookDetail is : \(strBookDetail)")
 if strBookDetail == "" ||  strBookDetail == "0" {
 return 0
 }
 }
 if indexPath.row == 2
 {
 print("strLengthDetail is : \(strLengthDetail)")
 if strLengthDetail == "" ||  strLengthDetail == "0" {
 return 0
 }
 }
 return 61
 }
 else if indexPath.row == 3
 {
 return 125
 }
 else if arrPrice.count > 0
 {
 return 61
 }
 else
 {
 return 61
 }
 }
 else if type == "length" || type == "book"{
 if indexPath.row == 0 || indexPath.row == 1
 {
 return 61
 }
 else if indexPath.row == 2
 {
 return 125
 }
 else if arrPrice.count > 0
 {
 return 61
 }
 else
 {
 return 61
 }
 }
 else{
 if indexPath.row == 0
 {
 return 61
 }
 else if indexPath.row == 1
 {
 return 125
 }
 else if arrPrice.count > 0
 {
 return 61
 }
 else
 {
 return 61
 }
 }
 
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 if isNoHostFee == true {
 
 return 2
 }
 
 
 if type == "2"{
 
 return 5 + arrPrice.count;
 
 }
 else if type == "length" || type == "book"{
 
 return 4 + arrPrice.count;
 }
 else {
 return 3 + arrPrice.count;
 }
 
 }
 
 if isNoHostFee == true {
 
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 
 if(indexPath.row == 0)
 {
 cell.lblDetails?.text = strPriceDetail
 cell.lblPrice?.text = strNightPrice
 if strTotalNights == "" || strPriceDetail == ""{
 
 cell.lblLine.isHidden = true
 }
 
 return cell
 }
 else{
 
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblPrice?.attributedText = strTotalPrice
 cell.lblDetails?.text = lang.totalpayout_Title
 return cell
 
 }
 
 
 }
 
 
 
 if type == "2"{
 if indexPath.row == 0
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 0)
 {
 cell.lblDetails?.text = strPriceDetail
 cell.lblPrice?.text = strNightPrice
 if strTotalNights == "" || strPriceDetail == ""{
 
 cell.lblLine.isHidden = true
 }
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 4) ? true : false
 return cell
 }
 if indexPath.row == 1
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 1)
 {
 cell.lblDetails?.text = strBookDetail
 cell.lblPrice?.text = strBookFee
 cell.lblDetails?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 cell.lblPrice?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 4) ? true : false
 return cell
 }
 if indexPath.row == 2
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 2)
 {
 cell.lblDetails?.text = strLengthDetail
 cell.lblPrice?.text = strLengthFee
 cell.lblDetails?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 cell.lblPrice?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 4) ? true : false
 return cell
 }
 if indexPath.row == 3  //  Total Price
 {
 
 let cell:CellPriceBreakDown = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellPriceBreakDown") as! CellPriceBreakDown
 var user_id = Constants().GETVALUE(keyname: APPURL.USER_ID) as String
 let host_id = hostoruser
 cell.lblMessage?.text = self.lang.price_Msg
 if user_id == host_id{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(self.lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 }
 else if appDelegate.samVal == "3"{
 
 if strHostFee == "$ 0" || strHostFee == "" {
 
 cell.lblDetails?.text = ""
 cell.lblPrice?.text = ""
 cell.lblLine1.isHidden = true
 
 }
 else{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(self.lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 }
 
 }
 
 else{
 cell.lblMessage?.isHidden = false
 cell.lblMessage?.text = self.lang.price_Msg
 if strServiceFee == "$ "{
 cell.lblDetails?.text = ""
 cell.lblLine1.isHidden = true
 
 }
 else{
 cell.lblDetails?.text = lang.servicefee_Title
 cell.lblPrice?.text = strServiceFee
 }
 
 }
 
 return cell
 }
 else if arrPrice.count > 0 && (indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2 && indexPath.row != 3) && arrPrice.count > indexPath.row - 4
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblDetails?.text = arrPirceDesc[indexPath.row - 4]
 cell.lblPrice?.text = arrPrice[indexPath.row - 4]
 return cell
 }
 else
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblPrice?.attributedText = strTotalPrice
 cell.lblDetails?.isHidden = true
 return cell
 }
 
 }
 else if type == "length"{
 if indexPath.row == 0
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 0)
 {
 cell.lblDetails?.text = strPriceDetail
 cell.lblPrice?.text = strNightPrice
 if strTotalNights == "" || strPriceDetail == ""{
 
 cell.lblLine.isHidden = true
 }
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 3) ? true : false
 return cell
 }
 if indexPath.row == 1
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 1)
 {
 cell.lblDetails?.text = strLengthDetail
 cell.lblPrice?.text = strLengthFee
 cell.lblDetails?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 cell.lblPrice?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 3) ? true : false
 return cell
 }
 else if indexPath.row == 2  //  Total Price
 {
 
 let cell:CellPriceBreakDown = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellPriceBreakDown") as! CellPriceBreakDown
 cell.lblMessage?.text = self.lang.price_Msg
 var user_id = Constants().GETVALUE(keyname: APPURL.USER_ID) as String
 let host_id = hostoruser
 if user_id == host_id{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 }
 else if appDelegate.samVal == "3"{
 
 if strHostFee == "$ 0" || strHostFee == "" {
 
 cell.lblDetails?.text = ""
 cell.lblPrice?.text = ""
 cell.lblLine1.isHidden = true
 
 }
 else{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 }
 
 }
 
 else{
 cell.lblMessage?.isHidden = false
 cell.lblMessage?.text = self.lang.price_Msg
 if strServiceFee == "$ "{
 cell.lblDetails?.text = ""
 cell.lblLine.isHidden = true
 
 }
 else{
 cell.lblDetails?.text = lang.servicefee_Title
 cell.lblPrice?.text = strServiceFee
 }
 
 }
 
 return cell
 }
 else if arrPrice.count > 0 && (indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2) && arrPrice.count > indexPath.row - 3
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblDetails?.text = arrPirceDesc[indexPath.row - 3]
 cell.lblPrice?.text = arrPrice[indexPath.row - 3]
 return cell
 }
 else
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblPrice?.attributedText = strTotalPrice
 cell.lblDetails?.isHidden = true
 return cell
 }
 
 }
 else if type == "book"{
 if indexPath.row == 0
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 0)
 {
 cell.lblDetails?.text = strPriceDetail
 cell.lblPrice?.text = strNightPrice
 if strTotalNights == "" || strPriceDetail == ""{
 
 cell.lblLine.isHidden = true
 }
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 3) ? true : false
 return cell
 }
 if indexPath.row == 1
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 1)
 {
 cell.lblDetails?.text = strBookDetail
 cell.lblPrice?.text = strBookFee
 cell.lblDetails?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 cell.lblPrice?.textColor = UIColor(red: 41.0 / 255.0, green: 152.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 3) ? true : false
 return cell
 }
 else if indexPath.row == 2  //  Total Price
 {
 
 let cell:CellPriceBreakDown = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellPriceBreakDown") as! CellPriceBreakDown
 
 var user_id = Constants().GETVALUE(keyname: APPURL.USER_ID) as String
 let host_id = hostoruser
 if user_id == host_id{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 }
 else if appDelegate.samVal == "3"{
 
 if strHostFee == "$ 0" || strHostFee == "" {
 
 cell.lblDetails?.text = ""
 cell.lblPrice?.text = ""
 cell.lblLine1.isHidden = true
 
 }
 else{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 }
 
 }
 
 else{
 cell.lblMessage?.isHidden = false
 if strServiceFee == "$ "{
 cell.lblDetails?.text = ""
 cell.lblLine1.isHidden = true
 
 }
 else{
 cell.lblDetails?.text = lang.servicefee_Title
 cell.lblPrice?.text = strServiceFee
 }
 
 }
 
 return cell
 }
 else if arrPrice.count > 0 && (indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2) && arrPrice.count > indexPath.row - 3
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblDetails?.text = arrPirceDesc[indexPath.row - 3]
 cell.lblPrice?.text = arrPrice[indexPath.row - 3]
 return cell
 }
 else
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblPrice?.attributedText = strTotalPrice
 cell.lblDetails?.isHidden = true
 return cell
 }
 
 }
 else
 {
 if indexPath.row == 0
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 if(indexPath.row == 0)
 {
 cell.lblDetails?.text = strPriceDetail
 cell.lblPrice?.text = strNightPrice
 if strTotalNights == "" || strPriceDetail == ""{
 
 cell.lblLine.isHidden = true
 }
 
 }
 
 cell.lblDetails?.isHidden = (indexPath.row == 2) ? true : false
 return cell
 }
 else if indexPath.row == 1  //  Total Price
 {
 let cell:CellPriceBreakDown = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellPriceBreakDown") as! CellPriceBreakDown
 cell.lblMessage?.text = self.lang.price_Msg
 
 var user_id = Constants().GETVALUE(keyname: APPURL.USER_ID) as String
 let host_id = hostoruser
 if user_id == host_id{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 //print(cell.lblPrice?.text!)
 }
 else if appDelegate.samVal == "3"{
 
 if strHostFee == "$ 0" || strHostFee == "" {
 
 cell.lblDetails?.text = ""
 cell.lblPrice?.text = ""
 cell.lblLine.isHidden = true
 
 }
 else{
 
 cell.lblDetails?.text = "\(k_AppName.capitalized) \(lang.hostfee_Title)"
 cell.lblPrice?.text = "-\(strHostFee)"
 //print(cell.lblPrice?.text!)
 }
 
 }
 
 
 else{
 if strServiceFee == "$ "{
 cell.lblDetails?.text = ""
 cell.lblLine.isHidden = true
 
 }
 else{
 cell.lblDetails?.text = lang.servicefee_Title
 cell.lblPrice?.text = strServiceFee
 }
 
 }
 
 return cell
 }
 else if arrPrice.count > 0 && (indexPath.row != 0 && indexPath.row != 1) && arrPrice.count > indexPath.row - 2
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblDetails?.text = arrPirceDesc[indexPath.row - 2]
 cell.lblPrice?.text = arrPrice[indexPath.row - 2]
 return cell
 }
 else
 
 {
 let cell:CellNightPrice = tblPriceBreakDown.dequeueReusableCell(withIdentifier: "CellNightPrice") as! CellNightPrice
 cell.lblPrice?.attributedText = strTotalPrice
 cell.lblDetails?.text = lang.totlaprice_Title
 
 return cell
 }
 
 
 }*/
