/**
* CountryListVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class CountryListVC : UIViewController,UITableViewDelegate, UITableViewDataSource, ViewOfflineDelegate, UISearchBarDelegate
{
    @IBOutlet var tableCountry: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!

    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCountry:String = ""
    var selectedCountryCode:String = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrCountryData : NSMutableArray = NSMutableArray()
    var strCurrentCountry = ""
    var filteredCountries : [String] = []
    var allCountriesList : [String] = []
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    var filteredData : [String] = []

    override func viewWillAppear(_ animated: Bool) {
        for i in 0..<arrCountryData.count {
            let countryName = ((arrCountryData[i] as AnyObject).value(forKey: "country_name") as! String)
            self.filteredCountries.append(countryName)
            self.searchBar.delegate = self
        }
        self.allCountriesList = filteredCountries
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.navigationController?.isNavigationBarHidden = true
        let path = Bundle.main.path(forResource: "country", ofType: "plist")
        arrCountryData = NSMutableArray(contentsOfFile: path!)!
        print("countryData",arrCountryData)
        self.view.appGuestViewBGColor()
        btnNext.nextButtonImage()
        btnNext.transform = Language.getCurrentLanguage().getAffine
        let  userDefaults = UserDefaults.standard
        let countrys = userDefaults.object(forKey: "countryname") as? NSString
        self.searchBar.placeholder = "Search Countries"
        
        

//        if (countrys != nil && countrys != "")
//        {
//            selectedCountry = countrys as! String
//        }
//        else
//        {
//            selectedCountry = "United States"
//        }
        self.makeScroll()
//        self.callCountryAPI()
        tableCountry.tableHeaderView = tblHeaderView
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? filteredCountries : filteredCountries.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.allCountriesList = filteredData
        tableCountry.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }

    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.callCountryAPI()
    }
    
    // MARK: CURRENCY API CALL
    /*
     */
    func callCountryAPI()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        
        var dicts = [AnyHashable: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_COUNTRY_LIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            print("response code",response)
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                
                if gModel.status_code == "1"
                {
                   
                    self.arrCountryData.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                    self.tableCountry.reloadData()
                    self.makeScroll()
                }
                else
                {
                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    func makeScroll()
    {
        for i in 0...arrCountryData.count-1
        {
            let currencyModel = ((arrCountryData[i] as AnyObject).value(forKey: "country_name") as! String)//arrCountryData[i] as? CountryModel
            if currencyModel == selectedCountry
            {
                let indexPath = IndexPath(row: i, section: 0)
                tableCountry.scrollToRow(at: indexPath, at: .top, animated: true)
                break
            }
        }
    }

    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCountriesList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellCountry = tableCountry.dequeueReusableCell(withIdentifier: "CellCountry") as! CellCountry
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currencyModel = allCountriesList[indexPath.row]//arrCountryData[indexPath.row] as? CountryModel
        cell.lblName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.lblName?.text = currencyModel
        cell.lblName?.textColor = (cell.lblName?.text == selectedCountry) ? UIColor.darkGray : UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! CellCountry
        if selectedCountry.count>0 && (cell.lblName?.text == selectedCountry)
        {
            selectedCountry = ""
            btnNext.alpha = 0.5
            btnNext.isUserInteractionEnabled = false
        }
        else
        {
            selectedCountry = (cell.lblName?.text)!
            btnNext.alpha = 1.0
            btnNext.isUserInteractionEnabled = true
        }
        
        let  userDefaults = UserDefaults.standard
        userDefaults.set(selectedCountry, forKey: "countryname")
        let countryCode = (arrCountryData[indexPath.row] as AnyObject).value(forKey: "country_code")
        if countryCode != nil {
        userDefaults.set(countryCode!, forKey: "countrycode")
        }
        userDefaults.synchronize()
        tableCountry.reloadData()
    }

    @IBAction func gotoCardSelection(sender : UIButton)
    {
        print("Card selection Button actions")
        self.navigationController!.popViewController(animated: true)
//        let paymentView = k_MakentStoryboard.instantiateViewController(withIdentifier: "MakePaymentVC") as! MakePaymentVC
//        self.navigationController?.pushViewController(paymentView, animated: true)
    }

    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CountryListVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}


class CellCountry: UITableViewCell {
    @IBOutlet var lblName: UILabel?
}
