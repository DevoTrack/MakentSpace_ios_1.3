/**
 * LoadWebView.swift
 *
 * @package Makent
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import MessageUI
import Social
import WebKit
class LoadWebView : UIViewController{ 
    //    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet weak var back_Btn: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var webCommon: WKWebView!
    var strPageTitle = ""
    var strWebUrl = ""
    var strCancellationFlexible = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var isFromBooking = Bool()
    var isViewFromCancel = Bool()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.back_Btn.transform = Language.getCurrentLanguage().getAffine
        self.webCommon.backgroundColor = .white
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        
        self.webCommon?.backgroundColor = .white
        self.webCommon?.navigationDelegate = self
        self.webCommon?.uiDelegate = self
        self.LoadWebView()
        lblTitle.text = strPageTitle
    }
    func LoadWebView(){
        
        if strCancellationFlexible.count>0{
            webCommon.loadHTMLString(strCancellationFlexible, baseURL: nil)
        }else{
            if let url = URL(string: strWebUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                print(url)
                let request = URLRequest(url: url)
                webCommon.load(request)
            }else{
                //SharedVariables.sharedInstance.appDelegate.createToastMessage("Your request has some problem", isSuccess: true)
                webCommon.load(URLRequest(url: URL(string: strWebUrl)!))
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func goBack()
    {
        OperationQueue.main.addOperation {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isViewFromCancel{
        self.navigationController?.isNavigationBarHidden = false
        }
    }
    @IBAction func onAddTitleTapped(_ sender:UIButton!)
    {
        
    }
    
    @IBAction func onAddSummaryTapped(_ sender:UIButton!)
    {
        
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}

extension LoadWebView: WKNavigationDelegate, WKUIDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if (webView.isLoading){
            print("Loading...")
            
        }else {
            print("Loaded")
            MakentSupport().removeProgress(viewCtrl: self)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        MakentSupport().removeProgress(viewCtrl: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //let res: String? = webCommon.stringByEvaluatingJavaScript(from: "document.getElementById('json').innerHTML")
        webCommon.evaluateJavaScript("document.getElementById('json').innerHTML") { (result, error) in
            if let res = result as? String {
                if (res.count) > 0
            {
                    let data: NSData = res.data(using: String.Encoding.utf8)! as NSData
                var items = NSDictionary()
                
                do
                {
                    let jsonResult : Dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! NSDictionary as Dictionary
                    
                    items = jsonResult as NSDictionary
    //                if (items.count>0)
    //                {
    //                    if items["status_code"] != nil
    //                    {
    //                        if items["status_code"] as! NSString == "1" && items["success_message"] as! NSString == "Request Booking Send to Host"
    //                        {
    //                            let dict: [AnyHashable: Any] = [
    //                                "description" : items["success_message"] as! NSString
    //                            ]
    //
    //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ResquestToBook"), object: self, userInfo: dict)
    //                            appDelegate.multipleDates = []
    //                            appDelegate.e_date = ""
    //                            appDelegate.s_date = ""
    //                            appDelegate.day = ""
    //                            appDelegate.startdate = ""
    //                            appDelegate.enddate = ""
    //                            appDelegate.searchguest = ""
    //                            if self.appDelegate.lastPageMaintain == "booking"{
    //
    //                                self.dismiss(animated: true, completion: nil)
    //                                self.hidesBottomBarWhenPushed = false
    //                                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
    //                            }
    //                            else{
    //                                self.appDelegate.makentTabBarCtrler.selectedIndex = 2
    //                                 self.hidesBottomBarWhenPushed = false
    //
    //                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
    //                                print(viewControllers.count)
    //                                self.presentingViewController?.dismiss(animated: true, completion: nil)
    //
    //                            }
    //                         //   self.appDelegate.createToastMessage((items["success_message"] as! NSString) as String, isSuccess: true)
    //                        }
    //                        else if items["status_code"] as! NSString == "1" && items["success_message"] as! NSString == "Payment Successfully Paid"
    //                        {
    //                            let dict: [AnyHashable: Any] = [
    //                                "description" : items["success_message"] as! NSString
    //                            ]
    //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ResquestToBook"), object: self, userInfo: dict)
    //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "roombooked"), object: self, userInfo: dict)
    //                            if self.appDelegate.lastPageMaintain == "booking" || self.appDelegate.lastPageMaintain == "Trips" {
    //
    //                                self.dismiss(animated: true, completion: nil)
    //                                self.hidesBottomBarWhenPushed = false
    //                                self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
    //                            }
    //                            else if items["status_code"] as! NSString == "1"
    //                            {
    //                                self.appDelegate.makentTabBarCtrler.selectedIndex = 2
    //                                self.hidesBottomBarWhenPushed = false
    //
    //                                self.presentingViewController?.dismiss(animated: false, completion: nil)
    //
    //
    //                                self.appDelegate.createToastMessage((self.lang.paymnt_Succes), isSuccess: false)
    //                            }
    //
    //                            else{
    //                                self.appDelegate.makentTabBarCtrler.selectedIndex = 2
    //                                self.hidesBottomBarWhenPushed = false
    ////                                self.dismiss(animated: true, completion: nil)
    ////                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
    //                                self.presentingViewController?.dismiss(animated: false, completion: nil)
    //
    ////                                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    //                            }
    //                        //    self.appDelegate.createToastMessage((items["success_message"] as! NSString) as String, isSuccess: true)
    //
    //                        }
    //                        else // if items["status_code"] as! NSString == "1" && items["success_message"] as! NSString == "Payment Failed"
    //                        {
    //                            self.goBack()
    //                            self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
    //                            self.appDelegate.createToastMessage((items["success_message"] as! NSString) as String, isSuccess: false)
    //                        }
    //
    //                    }
    //                }
    //                else {
    //                }
                    
                    if let jsons = items as? JSONS {
                        self.appDelegate.multipleDates = []
                        self.appDelegate.e_date = ""
                        self.appDelegate.s_date = ""
                        self.appDelegate.day = ""
                        self.appDelegate.startdate = ""
                        self.appDelegate.enddate = ""
                        self.appDelegate.searchguest = ""
                        
                        if jsons.statusCode == 1 && jsons.statusMessage == "Request Booking Send to Host" || jsons.statusMessage == "Payment Successfully Paid" || jsons.statusMessage.contains("Successfully")
                        {
                            let dict: [AnyHashable: Any] = [
                                "description" : items["success_message"] as! NSString
                            ]
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ResquestToBook"), object: self, userInfo: dict)
                            if items["success_message"] as! NSString == "Payment Successfully Paid"{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "roombooked"), object: self, userInfo: dict)
                            }
                            self.appDelegate.createToastMessage(jsons.statusMessage, isSuccess: true)
                            if self.isFromBooking {
                               
                                self.dismiss(animated: true, completion: nil)
                                
                                
                            }else {
                               self.navigationController?.popToRootViewController(animated: false)
                            }
                            
                             _ = self.appDelegate.generateMakentLoginFlowChange(tabIcon: 2)
                            
                            return
                        }else {
                            self.appDelegate.createToastMessage(jsons.statusMessage, isSuccess: false)
                            self.goBack()
                            return
                        }
                    }else {
                        self.appDelegate.createToastMessage(self.lang.serverErrorPleaseTryAgain, isSuccess: false)
                        self.goBack()
                        return
                        
                    }
                }
                catch _ {
                }
                
            }
        }
        }
        MakentSupport().removeProgress(viewCtrl: self)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        print("navigationAction load:\(String(describing: navigationAction.request.url))")
        decisionHandler(.allow)
    }
    
}
