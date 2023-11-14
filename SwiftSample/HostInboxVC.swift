/**
* HostInboxVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class HostInboxVC : UIViewController,UITableViewDelegate, UITableViewDataSource, ViewOfflineDelegate
{
    @IBOutlet var tblHostInbox: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var lblSeparator: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var lblUnreaderStatus: UILabel!
    @IBOutlet var viewNoMessage: UIView!

    var strHeaderTitle:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrReservationMsgs : NSMutableArray = NSMutableArray()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    @IBOutlet weak var nores_Msg: UILabel!
    @IBOutlet weak var nores_Title: UILabel!
    @IBOutlet weak var reser_Tit: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        lblSeparator?.alpha = 0.0
        lblTitle?.alpha = 0.0
//        viewNoMessage.isHidden = true
        tblHostInbox.tableHeaderView = tblHeaderView
        self.reser_Tit.text = self.lang.resers_Title
        self.lblTitle.text = self.lang.resers_Tit
        self.lblTitle.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.nores_Title.text = self.lang.nores_Req
        self.nores_Msg.text = self.lang.noreser_Msg
        let rect = UIScreen.main.bounds as CGRect
        var rectTblView = tblHostInbox.frame
        rectTblView.size.height = rect.size.height-100
        tblHostInbox.frame = rectTblView
        
        self.animatedLoader?.isHidden = false
        
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)

        self.getInboxMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
        
        
        tblHostInbox.addPullRefresh { [weak self] in
            self?.getInboxMessages()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
    }
    
    func getInboxMessages()
    {

        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_GET_RESERVATION as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1" && gModel.arrTemp1.count > 0
                {
                    if self.arrReservationMsgs.count > 0
                    {
                        self.arrReservationMsgs.removeAllObjects()
                    }

                    self.arrReservationMsgs.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                    if self.arrReservationMsgs.count > 0
                    {
                        self.setHeaderInfo(unread_count:self.arrReservationMsgs.count)
                        self.tblHostInbox.reloadData()
//                        self.viewNoMessage.isHidden = true
                        self.tblHostInbox.isHidden = false
                        self.view.removeAddedSubview(view: self.viewNoMessage)
                    }
                    else
                    {
                        self.lblSeparator?.alpha = 1.0
                        self.lblTitle?.alpha = 1.0
//                        self.viewNoMessage.isHidden = false
//                        self.tblHostInbox.isHidden = true
                        self.view.addCenterViewHideTableView(centerView: self.viewNoMessage)
                    }
                }
                else
                {
                    self.lblUnreaderStatus.text = self.lang.noreser_Msg//"You have no reservation"
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.animatedLoader?.isHidden = true
                self.tblHostInbox.stopPullRefreshEver()
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.tblHostInbox.stopPullRefreshEver()
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    func setHeaderInfo(unread_count: Int)
    {
        if (unread_count != 0)
        {
            lblUnreaderStatus.text = String(format: (unread_count == 1) ? "\(self.lang.youhave_Title) %d \(self.lang.reser_Tit)" : "\(self.lang.youhave_Title) %d \(self.lang.resers_Tit)",unread_count)
        }
        else{
            lblUnreaderStatus.text = self.lang.noreser_Msg//"You have no reservation"
        }
    }
    
    // MARK: Table View Data Source
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 125
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReservationMsgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellReservationHost = tblHostInbox.dequeueReusableCell(withIdentifier: "CellReservationHost") as! CellReservationHost
        cell.imgUserThumb?.layer.cornerRadius = (cell.imgUserThumb?.frame.size.height)! / 2
        let msgModel = arrReservationMsgs[indexPath.row] as? ReservationModel
        cell.setReservationDetails(modelTrips: msgModel!)
        cell.btnPreAccept?.setTitle(self.lang.preacc_Title, for: .normal)
        cell.btnPreAccept?.tag = indexPath.row
        cell.btnPreAccept?.addTarget(self, action: #selector(self.onPreAcceptTapped), for: UIControl.Event.touchUpInside)
        cell.imgUserThumb?.clipsToBounds = true
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewEditProfile = StoryBoard.host.instance.instantiateViewController(withIdentifier: "ReservationDetailVC") as! ReservationDetailVC
        viewEditProfile.hidesBottomBarWhenPushed = true
        let msgModel = arrReservationMsgs[indexPath.row] as? ReservationModel
        viewEditProfile.modelReservationData = msgModel
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    
    @IBAction func onPreAcceptTapped(sender: UIButton)
    {
        let msgModel = arrReservationMsgs[sender.tag] as? ReservationModel
        let preView = k_MakentStoryboard.instantiateViewController(withIdentifier: "PreAcceptVC") as! PreAcceptVC
        preView.strReservationId = msgModel?.reservation_id as! String
        preView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(preView, animated: true)
    }
    
    @objc func PreAcceptChanged()
    {
        getInboxMessages()
        if arrReservationMsgs.count > 0
        {
            self.arrReservationMsgs.removeAllObjects()
            tblHostInbox.reloadData()
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        lblSeparator?.alpha = (scrollView.contentOffset.y as CGFloat > 55) ? 1.0 : 0.0
        lblTitle?.alpha = (scrollView.contentOffset.y as CGFloat > 55) ? 1.0 : 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellReservationHost: UITableViewCell
{
    @IBOutlet var lblTripStatus: UILabel?
    @IBOutlet var lblUserName: UILabel?
    @IBOutlet var lblTripDate: UILabel?
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblLocation: UILabel?
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var btnPreAccept: UIButton?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    func setReservationDetails(modelTrips: ReservationModel)
    {
        btnPreAccept?.appHostSideBtnBG()
        btnPreAccept?.isHidden = (modelTrips.trip_status == "Pending") ? false : true
        var rectLblView = lblLocation?.frame
        rectLblView?.size.width = self.frame.size.width - ((modelTrips.trip_status == "Pending") ? 120 : 40) - (lblLocation?.frame.origin.y)!
        lblLocation?.frame = rectLblView!

        btnPreAccept?.cornerRadius = 3.0
        lblUserName?.AlignText()
        lblDetails?.AlignText()
        lblTripDate?.AlignText()
        lblLocation?.AlignText()
        
        lblUserName?.text = modelTrips.guest_user_name as String
        lblDetails?.text = modelTrips.room_name.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!
//        modelWishList?.list_name.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        lblTripDate?.text = modelTrips.trip_date as String
            //.replacingOccurrences(of: "to", with: "-")
        lblLocation?.text = modelTrips.room_location as String
        imgUserThumb?.addRemoteImage(imageURL: modelTrips.guest_thumb_image as String, placeHolderURL: "")
            //.sd_setImage(with: NSURL(string: modelTrips.guest_thumb_image as String) as? URL, placeholderImage:UIImage(named:""))
        //        lblTripStatus?.text = modelTrips.trip_status as String
        if modelTrips.trip_status == "Cancelled"{
            lblTripStatus?.text = self.lang.canld_Tit
        }
        if modelTrips.trip_status == "Inquiry"{
            lblTripStatus?.text = self.lang.inq_Title
        }
        if modelTrips.trip_status == "Declined"{
            lblTripStatus?.text = self.lang.decld_Tit
        }
        if modelTrips.trip_status == "Expired"{
            lblTripStatus?.text = self.lang.exp_Tit
        }
        if modelTrips.trip_status == "Accepted"{
            lblTripStatus?.text = self.lang.accep_Tit
        }
        if modelTrips.trip_status == "Pre-Accepted"{
            lblTripStatus?.text = self.lang.preaccep_Tit
        }
        if modelTrips.trip_status == "Pending"{
            lblTripStatus?.text = self.lang.pend_Tit
        }
        if modelTrips.trip_status == "Cancelled" || modelTrips.trip_status == "Declined" || modelTrips.trip_status == "Expired"
        {
            lblTripStatus?.textColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
        }
        else if modelTrips.trip_status == "Accepted"
        {
            lblTripStatus?.textColor = UIColor(red: 63.0 / 255.0, green: 179.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        }
        else if modelTrips.trip_status == "Pre-Accepted" || modelTrips.trip_status == "Inquiry"
        {
            lblTripStatus?.textColor = UIColor.darkGray
        }
        else if modelTrips.trip_status == "Pending"
        {
            lblTripStatus?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
    }
    
}

extension UITextField{
    func AlignText(){
        self.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
    }
}
extension UITextView{
    func AlignText(){
        self.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
    }
}
