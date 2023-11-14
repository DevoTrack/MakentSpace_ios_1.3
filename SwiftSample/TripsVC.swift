/**
* TripsVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class TripsVC : UIViewController, ViewOfflineDelegate
{
    
    @IBOutlet var animatedImageView: FLAnimatedImageView?
    @IBOutlet weak var  btnStartExplore : UIButton?
    @IBOutlet weak var  viewTipsHolder : UIView?
    @IBOutlet var collectionTrips: UICollectionView!
    @IBOutlet weak var loginView: UIView!
    var token = ""
    var strVerses:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrTrips = [tripList]()
    let arrTripsImgs = ["pending_trip.png","current_trip.png","upcoming_trip.png","past_trip.png"]
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    
    @IBOutlet weak var Login_Btn: UIButton!
    @IBOutlet weak var Trips_Itr: UILabel!
    @IBOutlet weak var Trips_Lbl2: UILabel!
    @IBOutlet weak var Trips_lbl1: UILabel!
    @IBOutlet weak var Trip_Msg: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("TripPage...")
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        self.btnStartExplore?.appGuestTextColor()
        self.btnStartExplore?.borderColor = UIColor.appGuestThemeColor
        self.btnStartExplore?.borderWidth = 1
        self.btnStartExplore?.setTitle(self.lang.stexp_Title, for: .normal)
        self.Trips_lbl1.text = lang.trip_Title
        self.Trips_Lbl2.text = lang.trip_Title
        self.Login_Btn.appGuestTextColor()
        self.Login_Btn.borderColor = UIColor.appGuestThemeColor
        self.Login_Btn.borderWidth = 2
        self.Trip_Msg.text = lang.Trips_Msg1
        self.Trips_Itr.text = lang.Trips_Msg2
        self.Login_Btn.setTitle(lang.login_Title, for: .normal)
        
         if token != ""{
//            loginView.isHidden = true
            self.view.removeAddedSubview(view: loginView)
         }
         else{
//            loginView.isHidden = false
            self.view.addCenterView(centerView: loginView)
         }
         
       
        self.navigationController?.navigationBar.isHidden = true
//        collectionTrips.delegate = self
//        collectionTrips.dataSource = self
        btnStartExplore?.layer.borderColor = UIColor.appGuestThemeColor.cgColor
        btnStartExplore?.layer.cornerRadius = 5
        
       
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        self.viewTipsHolder?.isHidden = true
        
//        self.collectionTrips.isHidden = true
        self.view.removeAddedSubview(view: collectionTrips)
        if let path =  Bundle.main.path(forResource: "itinerary-empty", ofType: "gif")
        {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                animatedImageView?.animatedImage = gif
                
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLatestTrips), name: NSNotification.Name(rawValue: "ResquestToBook"), object: nil)
    }
    
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        if token != ""{
            self.getTripsStatus()
        }
    }
    @IBAction func goToLoginAction(_ sender: Any) {
        let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainPage.hidesBottomBarWhenPushed = true
        
        appDelegate.lastPageMaintain = "trips"
//        self.navigationController?.pushViewController(mainPage, animated: false)
        let naviation = UINavigationController(rootViewController: mainPage)
        naviation.modalPresentationStyle = .fullScreen
        self.present(naviation, animated: false, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if token != ""{
            self.getTripsStatus()
        }
    }
    
    @objc func getLatestTrips(notification: Notification)
    {
        self.getTripsStatus()
    }
    
    func getTripsStatus()
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["language"] = Language.getCurrentLanguage().rawValue
        
//        WebServiceHandler.sharedInstance.getToWebService(wsMethod: METHOD_TRIPS_TYPE, paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
//           self.animatedLoader?.isHidden = true
//            print("success message",responseDict.string("success_message"))
//            if responseDict.isSuccess
//            {
//                self.viewTipsHolder?.isHidden = true
//                //                    self.collectionTrips.isHidden = false
//                self.view.addCenterView(centerView: self.collectionTrips)
//                self.collectionTrips.reloadData()
//            }
//            else
//            {
//                self.animatedLoader?.isHidden = true
//                self.viewTipsHolder?.isHidden = false
//                //                    self.collectionTrips.isHidden = true
//                self.view.removeAddedSubview(view: self.collectionTrips)
//            }
//        }
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_TRIPS_TYPE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {

                if gModel.status_code == "1"
                {
                    if gModel.trpModel.count > 0 {
                        self.arrTrips = gModel.trpModel
                    }
                    self.viewTipsHolder?.isHidden = true
//                    self.collectionTrips.isHidden = false
                    self.view.addCenterView(centerView: self.collectionTrips)
                    self.collectionTrips.reloadData()
                }

                else
                {
                    self.viewTipsHolder?.isHidden = false
//                    self.collectionTrips.isHidden = true
                    self.view.removeAddedSubview(view: self.collectionTrips)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.animatedLoader?.isHidden = true
             //   MakentSupport().removeProgressInWindow(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    // MARK: When User Press Start Exploring
    @IBAction func onStartExploreTapped(_ sender:UIButton!)
    {
        appDelegate.makentTabBarCtrler.selectedIndex = 0
    }
    
    
    
//    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TripsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if (!YSSupport.isNetworkRechable()) {
                return (arrTrips.count>0) ? arrTrips.count : 0
            }
            return (arrTrips.count>0) ?  arrTrips.count : 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
        {
            let rect = MakentSupport().getScreenSize()
            return CGSize(width: (rect.size.width/2)-10, height: (rect.size.width/2)-10)
        }
        
        internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionTrips.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CustomRentCell
            let val = self.arrTrips[indexPath.row]
            cell.lblRoomDetail?.text = val.value
            
    //        if val.value == "Pending Trips"{
    //            let pend = self.lang.pend_Trip
    //            cell.lblRoomDetail?.text =  pend
    //        }
    //        if val.value == "Upcoming Trips"{
    //            let upcom = self.lang.upcom_Trip
    //            cell.lblRoomDetail?.text =  upcom
    //        }
    //        if val.value == "Previous Trips"{
    //            let prev = self.lang.prev_Trip
    //            cell.lblRoomDetail?.text =  prev
    //        }
    //        if val.value == "Current Trips"{
    //            let curren = self.lang.curren_Trip
    //            cell.lblRoomDetail?.text =  curren
    //        }

            cell.imageView?.image = UIImage(named:arrTripsImgs[indexPath.row])
            return cell
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
           //1
                  switch kind {
                  //2
                  case UICollectionView.elementKindSectionHeader:
                      //3
                      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                       withReuseIdentifier: "ExploreHeaderView",
                                                                                       for: indexPath) as! ExploreHeaderView
                      headerView.trp_Titt.text = self.lang.booking_Title
                      return headerView
                  default:
                      fatalError(self.lang.unexp_KindErr)
                  }
            
    
        }
        
        
        
        
        // MARK: CollectionView Delegate
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {

            let roomDetailView = k_MakentStoryboard.instantiateViewController(withIdentifier: "TripsDetailVC") as! TripsDetailVC
            let val = self.arrTrips[indexPath.row]
            roomDetailView.strHeaderTitle =  val.value.replacingOccurrences(of: "\n", with: " ")
            roomDetailView.strTripsType =  val.key.lowercased().replacingOccurrences(of: " ", with: "_")
            roomDetailView.pageType = .trips
            
            
            self.navigationController?.pushViewController(roomDetailView, animated: true)
        }
        
        
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

            if let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? ExploreHeaderView {
                // Layout to get the right dimensions
                headerView.layoutIfNeeded()

                // Automagically get the right height


                // return the correct size
                return CGSize(width: 400, height: 70)
            }

            let size = CGSize(width: 400, height: 70)
            return size
        }
}
