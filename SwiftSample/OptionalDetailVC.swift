/**
* OptionalDetailVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social


protocol OptionalDetailDelegate
{
    func RoomBedUpdatedFromOptional(listModel: ListingModel)
    func UpdatedLongTermPrice(listModel:ListingModel)
    func AmenitiesChangedFrmOptional(strDescription: String)
    func RoomCurrencyChanged(listModel: ListingModel)
    func listYourSpace(roomStatus:String)
    func roomDisabled()
}

class OptionalDetailVC : UIViewController,UITableViewDelegate, UITableViewDataSource,LongTermDelegate,RoomBedUpdateDelegate,AmenityChangedDelegate,CurrencyChangedDelegate
{
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet var tblOptionalDetail: UITableView!
    @IBOutlet var tblFooderView: UIView!
    @IBOutlet var btnDisableList: UIButton!
    @IBOutlet var animatedLoader: FLAnimatedImageView?

    @IBOutlet weak var opt_Title: UILabel!
    var delegate: OptionalDetailDelegate?
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var arrPrice = ["Additional Prices","Length of stay discounts","Early bird discounts","Last min discounts","Reservation Settings","Currency"]
    var arrDetails = ["Description","Amenities","Rooms & Beds","Policy"]
    var strRoomId = ""
    var strWeekPrice = ""
    var strMonthPrice = ""
    var listModel : ListingModel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    @IBOutlet weak var back_btn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        arrPrice = [self.lang.additionalprice_Title,self.lang.lengthdis_Title,self.lang.earlybird_Disc,self.lang.lastmin_Disc,self.lang.reserset_Title,self.lang.curren_Title]
        arrDetails = [self.lang.descript_Title,self.lang.ament_Title,self.lang.rombed_Title,self.lang.policy_Title]
        self.opt_Title.text = self.lang.optidet_Title
        back_btn.transform = Language.getCurrentLanguage().getAffine
        
        
        if listModel.room_status == "Listed"
        {
            btnDisableList.setTitle((listModel.isListEnabled == "Yes") ? self.lang.unlis_Title : self.lang.lis_Title, for: .normal)
            tblOptionalDetail.tableFooterView = tblFooderView
        }
        btnDisableList.layer.borderColor = UIColor.lightGray.cgColor
        btnDisableList.layer.borderWidth = 1.0
        
        if listModel != nil
        {
            strWeekPrice = listModel.weekly_price as String
            strMonthPrice = listModel.monthly_price as String
        }
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        btnDisableList.appHostTextColor()
        back_btn.appHostTextColor()
        //changeButtonStatus()

    }
    
    override func viewDidAppear(_ animated: Bool) {
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
     Room Detail List View Table Datasource & Delegates
     */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblOptionalDetail.frame.size.width) ,height: 40)
        
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:20, width: viewHolder.frame.size.width ,height: 40)
        if section == 0
        {
            lblRoomName.text=self.lang.pric_Title//"Price"
        }
        else
        {
            lblRoomName.text=self.lang.det_Title//"Details"
        }
        lblRoomName.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 15)
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return arrPrice.count
        }
        else
        {
            return arrDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section==0
        {
            let cell:CellOptionalPrice = tblOptionalDetail.dequeueReusableCell(withIdentifier: "CellOptionalPrice") as! CellOptionalPrice
            cell.lblCurrency?.isHidden = (indexPath.row==5) ? false : true
            cell.lblPrice?.text = arrPrice[indexPath.row]
            cell.lblCurrency?.text = listModel.currency_code as String
            return cell

        }
        
        else
        {
            let cell:CellOptionalDetail = tblOptionalDetail.dequeueReusableCell(withIdentifier: "CellOptionalDetail")! as! CellOptionalDetail
            cell.lblDetails?.text = arrDetails[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section==0
        {
            if indexPath.row==0
            {
                let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountPrice") as! DiscountPrice
                discountView.delegate = self
                discountView.listModel = listModel
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(discountView, animated: true)
            }
            else if indexPath.row == 1{
                // length of stay discounts
                let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountsPageVC") as! DiscountsPageVC
                discountView.type = "1"
                discountView.listModel = listModel
                discountView.roomid = self.strRoomId
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(discountView, animated: true)
            }
            else if indexPath.row == 2{
                //early bird discounts
                let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountsPageVC") as! DiscountsPageVC
                discountView.type = "2"
                discountView.listModel = listModel
                discountView.roomid = self.strRoomId
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(discountView, animated: true)
            }
            else if indexPath.row == 3 {
                //last min discounts
                let discountView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "DiscountsPageVC") as! DiscountsPageVC
                discountView.type = "3"
                discountView.listModel = listModel
                discountView.roomid = self.strRoomId
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(discountView, animated: true)
            }
            else if indexPath.row == 4{
                //reservation settings.
                let checkInView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "MaxMinStay") as! MaxMinStay
                checkInView.listModel = listModel
                checkInView.roomid = self.strRoomId
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(checkInView, animated: true)
            }
            else
            {
                let coutryView = k_MakentStoryboard.instantiateViewController(withIdentifier: "CountryVC") as! CountryVC
                coutryView.delegate = self
                coutryView.strTitle = "Currency"
                coutryView.strApiMethodName = APPURL.METHOD_UPDATE_ROOM_CURRENCY
                coutryView.strCurrentCurrency = listModel.currency_code as String
                coutryView.listModel = listModel
                self.navigationController?.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(coutryView, animated: true)
            }
        }
        else if indexPath.section==1
        {
            if indexPath.row==0
            {
                let abtListView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AboutListing") as! AboutListing
                abtListView.strRoomId = strRoomId
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(abtListView, animated: true)
            }
            else if indexPath.row==1
            {
                let amenityView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AllAmenitiesVC") as! AllAmenitiesVC
                amenityView.delegate = self
                if (listModel.selected_amenities_id as String).count > 0
                {
                    let arr = (listModel.selected_amenities_id as String).components(separatedBy: ",")
                    amenityView.arrSelectedItems =  NSMutableArray(array: arr)
                }
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(amenityView, animated: true)
            }
            else if indexPath.row==2
            {
                let roomBedView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "RoomBedSelection") as! RoomBedSelection
                roomBedView.delegate = self
                roomBedView.listModel = listModel
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(roomBedView, animated: true)
            }
            else if indexPath.row==3
            {
                let coutryView = k_MakentStoryboard.instantiateViewController(withIdentifier: "CountryVC") as! CountryVC
                coutryView.isFromAddRoom = true
                coutryView.strTitle = self.lang.policy_Title//"Policy"
                coutryView.strApiMethodName = APPURL.METHOD_UPDATE_POLICY
                coutryView.arrCurrencyData = ([self.lang.flexi_Title,self.lang.mod_Title,self.lang.strt_Title] as NSArray).mutableCopy() as! NSMutableArray
                coutryView.strCurrentCurrency = listModel.policy_type as String
                coutryView.delegate = self
                self.navigationController?.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(coutryView, animated: true)
            }
        }
    }
    
    internal func updateBookTypeOrPolicy(strDescription: String)
    {
        var tempModel = ListingModel()
        tempModel = self.listModel
        tempModel.policy_type = strDescription as NSString
        self.listModel = tempModel
        delegate?.RoomCurrencyChanged(listModel: listModel)
    }

    internal func roomCurrencyChanged(strCurrencyCode: String, strCurrencySymbol: String)
    {
        var tempModel = ListingModel()
        tempModel = self.listModel
        tempModel.currency_code = strCurrencyCode as NSString
        tempModel.currency_symbol = strCurrencySymbol as NSString
        self.listModel = tempModel
        delegate?.RoomCurrencyChanged(listModel: listModel)
        tblOptionalDetail.reloadData()
    }
    
    internal func updateRoomPrice(modelList : ListingModel)
    {
        self.listModel = modelList
        self.appDelegate.createToastMessage(self.lang.romadpri_Tit, isSuccess: true)

    }
    
    internal func AmenitiesChanged(strDescription: String)
    {
        delegate?.AmenitiesChangedFrmOptional(strDescription: strDescription)
    }
    
    internal func RoomBedUpdated(listModel: ListingModel)
    {
        self.listModel = listModel
        delegate?.RoomBedUpdatedFromOptional(listModel: listModel)
    }
    
    internal func onLongTermPriceChanged(modelList:ListingModel)
    {
        self.listModel = modelList
        delegate?.UpdatedLongTermPrice(listModel:self.listModel)
    }
    
    @IBAction func onDisableListingTapped(_ sender:UIButton!)
    {
        var dicts = [AnyHashable: Any]()

        self.btnDisableList.isUserInteractionEnabled = false
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = appDelegate.strRoomID
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_DISABLE_LISTING as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                
                if gModel.status_code == "1"
                {
                    self.changeButtonStatus()//
                    //UserDefaults.standard.set(true, forKey: "isStepsCompleted")
                    
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    self.btnDisableList.isUserInteractionEnabled = true
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
                self.btnDisableList.isUserInteractionEnabled = true
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }

    func changeButtonStatus()
    {
        self.btnDisableList.isUserInteractionEnabled = true
        var tempModel = ListingModel()
        tempModel = listModel        
        tempModel.isListEnabled = listModel.isListEnabled as String == self.lang.yes_Tit ? self.lang.no_Tit as NSString : self.lang.yes_Tit as NSString
        self.listModel = tempModel
        btnDisableList.setTitle((listModel.isListEnabled as String == self.lang.yes_Tit) ? self.lang.unlis_Title : self.lang.lis_Title, for: .normal)
        //        delegate?.RoomCurrencyChanged(listModel: listModel)
        delegate?.listYourSpace(roomStatus:(listModel.isListEnabled as String == self.lang.yes_Tit) ? self.lang.lis_Title : self.lang.unlis_Title)
    }

    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddRoomDetails") as! AddRoomDetails
        locView.hidesBottomBarWhenPushed = false
        locView.listModel = self.listModel
        self.navigationController?.hidesBottomBarWhenPushed = false
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.navigationController?.pushViewController(locView, animated: false)
//        self.navigationController!.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}

class CellOptionalPrice: UITableViewCell
{
    @IBOutlet var lblCurrency: UILabel?
    @IBOutlet var lblPrice: UILabel?

}

class CellOptionalDetail: UITableViewCell
{
    @IBOutlet var lblDetails: UILabel?
}



