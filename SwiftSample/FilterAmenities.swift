/**
* FilterAmenities.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol FilterAmenitiesDelegate
{
    func onFilterAmenitiesAdded(index:NSArray,filterTitle : String)
}

class FilterAmenities : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableAmenities: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet weak var ament_Titl: UILabel!
    var delegate: FilterAmenitiesDelegate?
    
    var selectedCountry:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var strCurrentCountry = ""
    var arrSelectedItems : NSMutableArray = NSMutableArray()
    var arrAmenitiesData : NSArray = NSArray()
    var filterTitle : String?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //self.view.appHostViewBGColor()
        self.view.appGuestViewBGColor()
        //self.ament_Titl.text = self.lang.amenit_Tit
        self.ament_Titl.text = filterTitle
        self.ament_Titl.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
//        let path = Bundle.main.path(forResource: "amenities", ofType: "plist")
//        arrAmenitiesData = NSArray.init(contentsOfFile: path!)!
        self.btnNext.transform = Language.getCurrentLanguage().getAffine
        tableAmenities.tableHeaderView = tblHeaderView
        checkSaveBtnStatus()
        self.btnNext.nextButtonImage()
        btnNext.alpha = 1.0
    }
    
    func onLoadData()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = String(format:"%@/amenities.plist",paths)
        let fileManager = FileManager.default
        if ((fileManager.fileExists(atPath: path)))
        {
            arrAmenitiesData = NSArray.init(contentsOfFile: path)!
            self.tableAmenities.reloadData()
        }
    }

    
    func checkSaveBtnStatus()
    {
//        btnNext.alpha = arrSelectedItems.count > 0 ? 1.0 : 0.5
//        btnNext.isUserInteractionEnabled = arrSelectedItems.count > 0 ? true : false
    }
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAmenitiesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if filterTitle == "Event Type"
        {
             let cell:CellCountry = tableAmenities.dequeueReusableCell(withIdentifier: "CellCountry") as! CellCountry
                   
                   cell.selectionStyle = UITableViewCell.SelectionStyle.none
                   let dictTemp = arrAmenitiesData[indexPath.row] as! NSDictionary
                   let currencyModel = dictTemp.value(forKey: "name")//(forKeyPath: String(format:"%name",indexPath.row))
                   cell.lblName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
                   cell.lblName?.text = currencyModel as! String?
                 //  print("sds\(currencyModel!)")
                    cell.lblName?.text = currencyModel as! String?
                  
                   cell.lblName?.textColor = (cell.lblName?.text == selectedCountry) ? UIColor.white : UIColor.darkGray
                   let strIds = dictTemp.value(forKey: "id")//(arrAmenitiesData.value(forKeyPath: String(format:"%d.id",indexPath.row))!)
                   
                   if arrSelectedItems.contains(String(format:"%d",strIds as! Int))
                   {
                       cell.lblName?.textColor = .white//k_AppThemeGreenColor
                   }
                   else {
                       cell.lblName?.textColor = UIColor.darkGray
                   }
                   
                   return cell
        }
        
        let cell:CellCountry = tableAmenities.dequeueReusableCell(withIdentifier: "CellCountry") as! CellCountry
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let dictTemp = arrAmenitiesData[indexPath.row] as! NSDictionary
        let currencyModel = dictTemp.value(forKey: "name")//(forKeyPath: String(format:"%name",indexPath.row))
        cell.lblName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblName?.text = currencyModel as! String?
      //  print("sds\(currencyModel!)")
         cell.lblName?.text = currencyModel as! String?
       
        cell.lblName?.textColor = (cell.lblName?.text == selectedCountry) ? UIColor.white : UIColor.darkGray
        let strIds = dictTemp.value(forKey: "id")//(arrAmenitiesData.value(forKeyPath: String(format:"%d.id",indexPath.row))!)
        
        if arrSelectedItems.contains(String(format:"%d",strIds as! Int))
        {
            cell.lblName?.textColor = .white//k_AppThemeGreenColor
        }
        else {
            cell.lblName?.textColor = UIColor.darkGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if filterTitle == "Event Type"
        {
            let dictTemp = arrAmenitiesData[indexPath.row] as! NSDictionary
           let strIds = dictTemp.value(forKey: "id")//(forKeyPath: String(format:"%name",indexPath.row))

            //        let strIds = (arrAmenitiesData.value(forKeyPath: String(format:"%d.id",indexPath.row))!)
                  if arrSelectedItems.contains(String(format:"%d",strIds as! Int))
                  {
                      arrSelectedItems.remove(String(format:"%d",strIds as! Int))
                  }
                  else
                  {
                      arrSelectedItems.add(String(format:"%d",strIds as! Int))
                  }
            arrSelectedItems.removeAllObjects()
            arrSelectedItems.add(String(format:"%d",strIds as! Int))
                    print("arrSelectedItems",arrSelectedItems)
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    checkSaveBtnStatus()
//                    let indexPath = IndexPath(row: indexPath.row, section: 0)
//                    tableAmenities.reloadRows(at: [indexPath], with: .none)
            tableAmenities.reloadData()

        }
        else
        {
            let dictTemp = arrAmenitiesData[indexPath.row] as! NSDictionary
                    let strIds = dictTemp.value(forKey: "id")//(forKeyPath: String(format:"%name",indexPath.row))

            // let strIds = (arrAmenitiesData.value(forKeyPath: String(format:"%d.id",indexPath.row))!)
                    if arrSelectedItems.contains(String(format:"%d",strIds as! Int))
                    {
                        arrSelectedItems.remove(String(format:"%d",strIds as! Int))
                    }
                    else
                    {
                        arrSelectedItems.add(String(format:"%d",strIds as! Int))
                    }
                    checkSaveBtnStatus()
                    let indexPath = IndexPath(row: indexPath.row, section: 0)
                    tableAmenities.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }

    @IBAction func gotoCardSelection(sender : UIButton)
    {
        print("selected array values",arrSelectedItems)
        delegate?.onFilterAmenitiesAdded(index: arrSelectedItems, filterTitle : self.filterTitle!)
        dismiss(animated: true, completion: nil)
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
