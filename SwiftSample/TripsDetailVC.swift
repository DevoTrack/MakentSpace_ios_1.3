/**
* TripsDetailVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class TripsDetailVC : UIViewController
{
    @IBOutlet var tableTrips: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet weak var lblHeaderTitle : UILabel!
    @IBOutlet weak var lblHeaderDesc : UILabel!
    
    @IBOutlet var noReservationParentView: UIView!
    @IBOutlet weak var noReservationRequestLbl: UILabel!
    @IBOutlet weak var noReservationSubTitleLbl: UILabel!
    
    
    @IBOutlet weak var loginSubTitleLbl: UILabel!
    @IBOutlet weak var loginImg: UIImageView!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var loginTitleLbl: UILabel!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet weak var tblFooterView: UIView!
    
    @IBOutlet weak var startExploring: UIButton!
    var pageType:BookingDetailsTypeEnum = BookingDetailsTypeEnum.trips
    
    var strHeaderTitle:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var strTripsType : String = ""
    
    
    var bookingDetailsModelArray = [BaseBookingModel]()
    var frame = CGRect()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Trip Detail View controller")
        self.frame = self.view.frame
       
          self.initForNotificationObservers()
        tableTrips.estimatedRowHeight = 125
        tableTrips.tableHeaderView = tblHeaderView
//        tableTrips.table
        lblHeaderTitle.text = strHeaderTitle
        self.startExploring.setTitle(self.lang.stexp_Title, for: .normal)
        self.setHeaderSubTitle(unReadCount: 0)
        DispatchQueue.main.async {
            self.checkUserIsLogin()
        }
        

        tableTrips.addPullRefresh { [weak self] in
            self?.getTripsDetails()
        }
        if self.pageType == .inbox {
            if self.bookingDetailsModelArray.isEmpty {
               
                var frame = self.tblFooterView.bounds
                frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: frame.height)
                self.view.addBottomView(bottomView: self.tblFooterView)
            } else {
            self.view.removeBottomView(bottomView: self.tblFooterView)
        }
        }
        if self.pageType != .trips {
            self.title = self.lblHeaderTitle.text
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func addNoReservationView() {
        if self.bookingDetailsModelArray.isEmpty {
            self.noReservationRequestLbl.text = self.lang.nores_Req
            self.noReservationSubTitleLbl.text = self.lang.noreser_Msg
            self.noReservationParentView.frame = self.frame
            self.view.addCenterViewHideTableView(centerView: self.noReservationParentView)
            return
        }else {
            self.view.removeAddedSubview(view: self.noReservationParentView)
            self.tableTrips.isHidden = false
        }
       
    }
    
    
    func addLoginView() {
        self.loginTitleLbl.text = self.lang.inbox_Title
        self.loginSubTitleLbl.text = lang.msghost_Msg
        self.loginBtnOutlet.setTitle(lang.login_Title, for: .normal)
        self.loginBtnOutlet.appGuestTextColor()
        self.loginBtnOutlet.borderColor = UIColor.appGuestThemeColor
        self.loginBtnOutlet.borderWidth = 2
        self.loginImg.image = UIImage(named: "inboxEmpty")
        self.loginBtnOutlet.addTap {
            let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            mainPage.hidesBottomBarWhenPushed = true
            
            self.appDelegate.lastPageMaintain = "trips"
            let naviation = UINavigationController(rootViewController: mainPage)
            naviation.modalPresentationStyle = .fullScreen
            self.present(naviation, animated: false, completion: nil)
        }
        self.loginView.frame = self.view.frame
        
        self.view.addCenterView(centerView: loginView)
        
    }
    
    func removewloginView() {
        self.view.removeAddedSubview(view: self.loginView)
    }
    
    func checkUserIsLogin() {
        if (Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String).isEmpty {
            if self.tableTrips.refreshControl?.isRefreshing ?? false {
                self.tableTrips.refreshControl?.endRefreshing()
            }
            self.addLoginView()
            
        }else {
            self.removewloginView()
            self.getTripsDetails()
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setHeaderInfo(_ subTitle:String) {
         self.lblHeaderDesc.text = subTitle
    }
    
    func setHeaderSubTitle(unReadCount:Int) {
        if self.pageType == .trips {
            if (unReadCount>0)
            {
                self.setHeaderInfo(String(format: "\(self.lang.youhave_Title) %d %@",self.bookingDetailsModelArray.count,self.strHeaderTitle))
                
            }
            else{
                self.setHeaderInfo(String(format: "\(self.lang.youhav_No)  %@",self.strHeaderTitle))
                
            }
        }else if pageType == .reservation {
            var result = String()
            let unread_count = unReadCount
            if (unread_count != 0)
            {
                
                result = "\(self.lang.youhave_Title) \(unread_count) "
                if unread_count == 1 {
                    result += "\(self.lang.reser_Tit)"
                }else {
                    result += "\(self.lang.resers_Tit)"
                }
                
//                    String(format: (unread_count == 1) ? "\(self.lang.youhave_Title) %d \(self.lang.reser_Tit)" : "\(self.lang.youhave_Title) %d \(self.lang.resers_Tit)",unread_count.description)
            }
            else
            {
                result = self.lang.noreser_Msg//"You have no reservation"
            }
            self.lblHeaderTitle.text = self.lang.resers_Tit.capitalized
            self.setHeaderInfo(result)
        }
        else {
            var result = String()
            let unread_count = unReadCount

            if (unread_count != 0)
            {
                result = String(format: "\(self.lang.youhave_Title) %@ \(self.lang.unreadmsg_Title)",unread_count.description)
            }
            else
            {
                result = self.lang.nounread_Msg
            }
            self.lblHeaderTitle.text = self.lang.inbox_Title
            self.setHeaderInfo(result)
        }
    }
    
    // MARK: BACK BUTTON ACTION
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func startExploringBtnAction(_ sender: Any) {
        self.appDelegate.generateMakentLoginFlowChange(tabIcon: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: BUTTON ACTIONS
extension TripsDetailVC {
    
    func getTripsDetails()
    {
        
        var dicts = [String: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        if self.pageType == BookingDetailsTypeEnum.trips {
            dicts["booking_type"] = strTripsType
        }else if self.pageType == .inbox {
            dicts["type"]   = "inbox"
        }
        //self.checkUserIsLogin()
        self.animatedLoader?.isHidden = false
//        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: self.pageType.apiMethod, paramDict: dicts, viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
            self.tableTrips.stopPullRefreshEver()
            self.animatedLoader?.isHidden = true
            if responseDict.isSuccess {
                self.bookingDetailsModelArray.removeAll()
                if self.pageType == BookingDetailsTypeEnum.trips {
                    //                    self.bookingDetailsModelArray
                    responseDict.array("bookings").forEach({self.bookingDetailsModelArray.append(TripBookingModel(tripDict: $0))})
                    self.setHeaderSubTitle(unReadCount: self.bookingDetailsModelArray.count)
                }else {
                    responseDict.array("data").forEach({self.bookingDetailsModelArray.append(InboxBookingModel(jsons: $0))})
                    print(self.bookingDetailsModelArray.count,"Message Count")
                    if self.pageType == .inbox {
                        self.setHeaderSubTitle(unReadCount: responseDict.int("unread_count"))
                    }else {
                        self.setHeaderSubTitle(unReadCount: self.bookingDetailsModelArray.count)
                        self.addNoReservationView()
                    }
                    
                }
                self.tableTrips.reloadData()
                if self.pageType == .inbox {
                    if self.bookingDetailsModelArray.isEmpty {
                       
                        var frame = self.tblFooterView.bounds
                        frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: frame.height)
                        self.view.addBottomView(bottomView: self.tblFooterView)
                    } else {
                    self.view.removeBottomView(bottomView: self.tblFooterView)
                }
                }
            }else {
                if !responseDict.statusMessage.contains("No") {
                    self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
                }
                if self.pageType == .inbox {
                    if self.bookingDetailsModelArray.isEmpty {
                       
                        var frame = self.tblFooterView.bounds
                        frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: frame.height)
                        self.view.addBottomView(bottomView: self.tblFooterView)
                    } else {
                    self.view.removeBottomView(bottomView: self.tblFooterView)
                }
                }
            }
        }
            
    }
    
    
    @objc func onBookNowTapped(sender: UIButton)
    {
        let model = bookingDetailsModelArray[sender.tag]
        if let cell = self.tableTrips.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CellTrips {
            if cell.btnBookNow?.currentTitle == self.lang.Book_Now {
                self.callBookNowAction(model: model)
                
            }else if cell.btnBookNow?.currentTitle == self.lang.preAccepted {
                
                self.callPreAcceptedAction(model: model)
            }
        }
    }
    
    func callBookNowAction(model:BaseBookingModel) {
//        let viewWeb = k_MakentStoryboard.instantiateViewController(withIdentifier: "LoadWebView") as! LoadWebView
//        viewWeb.hidesBottomBarWhenPushed = true
//        //            viewWeb.appDelegate.lastPageMaintain = "Trips"
//        viewWeb.strPageTitle = self.lang.payment_Title
//        viewWeb.strWebUrl = String(format:"%@%@?reservation_id=%@&token=%@",k_APIServerUrl,API_PAY_NOW,(model.reservationID),Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN))
//        self.navigationController?.pushViewController(viewWeb, animated: true)
        
        let contactView = k_MakentStoryboard.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        contactView.sKey = ""
        contactView.strInstantBook = "Yes"
        contactView.Reser_ID    = model.reservationID.description
        let navController = UINavigationController(rootViewController: contactView)
        self.present(navController, animated:true, completion: nil)
        
    }
    
    func callPreAcceptedAction(model:BaseBookingModel) {
        let preView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PreAcceptVC") as! PreAcceptVC
        preView.strReservationId = model.reservationID.description
        preView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(preView, animated: true)
    }
}

//MARK: NOTIFICATION OBSERVERS
extension TripsDetailVC {
    
    func initForNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.tripCancelled), name: NSNotification.Name(rawValue: "CancelResquestToBook"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLatestTrips), name: NSNotification.Name(rawValue: "ResquestToBook"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLatestTrips), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLatestTrips), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLatestTrips), name: NSNotification.Name(rawValue: "roombooked"), object: nil)
        
    }
    
    @objc func getLatestTrips(notification: Notification)
    {
        self.getTripsDetails()
    }
    @objc func tripCancelled()
    {
        getTripsDetails()
    }
}

// MARK: Table View Data Source
// MARK: Table View Delegate
extension TripsDetailVC :UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookingDetailsModelArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellTrips = tableTrips.dequeueReusableCell(withIdentifier: "CellTrips") as! CellTrips
        
        let model = self.bookingDetailsModelArray[indexPath.row]
        if self.pageType == .trips {
            cell.setTripsDetails(tripsModel: model as! TripBookingModel)
        }else if self.pageType == .reservation {
            cell.setReservationDetails(reservationModel: model as! ReservationBookingModel)
        }else  {
            cell.setInboxDetails(inboxModel: model as! InboxBookingModel)
        }
        
        cell.btnBookNow?.tag = indexPath.row
        cell.btnBookNow?.addTarget(self, action: #selector(self.onBookNowTapped), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = self.bookingDetailsModelArray[indexPath.row]
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        if pageType == .inbox ,let inboxModel = model as? InboxBookingModel  {
            if(inboxModel.reservationStatus == "Pending" && (Constants().GETVALUE(keyname: APPURL.USER_ID) as String == inboxModel.requestUserID.description))
            {
                self.gotoReservation(model: model)
                return
            }
       
            let viewEditProfile = k_MakentStoryboard.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
            viewEditProfile.baseBookingModel = model
            if model.host_user_deleted {
                viewEditProfile.isDeletedUser = true
            }
            viewEditProfile.pageType = self.pageType
            viewEditProfile.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewEditProfile, animated: true)
        }else {
            
                self.gotoReservation(model: model)
            
            
            
        }
        
    }
    
    func gotoReservation(model:BaseBookingModel) {
        let viewEditProfile = k_MakentStoryboard.instantiateViewController(withIdentifier: "InboxDetailVC") as! InboxDetailVC
        viewEditProfile.modelTripsData = model
        if model.host_user_deleted {
            viewEditProfile.isDeletedUser = true
        }
        viewEditProfile.strTripsType = strTripsType
        viewEditProfile.pageType = self.pageType
        viewEditProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
}




extension TripsDetailVC {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.pageType != .trips {
            let offsetY = scrollView.contentOffset.y
            print(offsetY)
            if offsetY <= self.tblHeaderView.frame.height {
               self.hideNavigationBar()
            }else {
                self.showNavigationBar()
            }
        }
    }
    
    
    func showNavigationBar() {
        
        self.navigationController?.navigationBar.tintColor = .black
        
        
        if self.pageType != .inbox {
            self.navigationController?.isNavigationBarHidden = false
            self.title = ""
            self.addBackButton()
            
        }
    }
    
    func hideNavigationBar() {
        if self.pageType == .inbox {
            self.navigationController?.isNavigationBarHidden = true
            self.appDelegate.makentTabBarCtrler.tabBar.isHidden = false
        }else{
            self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
            self.showNavigationBar()
        }
        
    }
}
