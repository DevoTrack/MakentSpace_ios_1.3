//
//  AddRoomBedVC.swift
//  Makent
//
//  Created by trioangle on 17/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol BedCountUpdateDelegate {
    func updatedBedCount(_ count : Int)
}

class AddRoomBedVC: UIViewController {

    
    //MARK:- Outlets
    
    @IBOutlet weak var crt_List: UILabel!
    
    @IBOutlet weak var thr_Lbl: UILabel!
    
    @IBOutlet weak var mrstps_Lbl: UILabel!
    
    @IBOutlet weak var finish_Btn: UIButton!
    
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var pageTitleLbl : UILabel!
    @IBOutlet weak var pageDescriptionLbl : UILabel!
    @IBOutlet weak var headerView : UIView!
    
    @IBOutlet weak var maxGuestHolderView : UIView!
    @IBOutlet weak var maxBathromHolderView  : UIView!
    @IBOutlet weak var maxBedRoomHolderView  : UIView!
    
    @IBOutlet weak var maxGuestValueLbl : UILabel!
    @IBOutlet weak var maxBathromValueLbl : UILabel!
    @IBOutlet weak var maxBedRoomValueLbl : UILabel!
    
    @IBOutlet weak var maxGuestTitle : UILabel!
    @IBOutlet weak var maxBathromTitle : UILabel!
    @IBOutlet weak var maxBedRoomTitle : UILabel!
    
    @IBOutlet weak var minGuestBtn : UIButton!
    @IBOutlet weak var minBathroomBtn : UIButton!
    @IBOutlet weak var minRoomBtn : UIButton!
    
    @IBOutlet weak var plusGuestBtn : UIButton!
    @IBOutlet weak var plusBathroomBtn : UIButton!
    @IBOutlet weak var plusRoomBtn : UIButton!
    
    @IBOutlet weak var bathroomView : UIView!
    @IBOutlet weak var guestView : UIView!
    @IBOutlet weak var roomAndBedTable : UITableView!
    
    @IBOutlet weak var btnNext : UIButton!
    
    
    @IBOutlet var viewStepsAlert: UIView!
    //MARK:- Varaibles
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var _bedTypes : [BedType]!
    var bedTypes : [BedType]{
        get{return self._bedTypes.compactMap({$0.copy()})}
        set{
            self._bedTypes = newValue
        }
    }
    var rooms = [BedRoom]()
    var commonRoom : BedRoom!
    var safeCopyOfSelectedBeds : [BedType]?
    var selectedBeds : [BedType]?{
        didSet{
            if self.selectedBeds == nil{
                self.safeCopyOfSelectedBeds = nil
                self.roomAndBedTable.reloadData()
            }else{
                self.safeCopyOfSelectedBeds = self.selectedBeds?.compactMap({$0.copy()})
                self.roomAndBedTable.springReloadData()
            }
        }
    }
    var guestCount : Int?{
        didSet{
            self.maxGuestValueLbl.text = (self.guestCount ?? 1).localize
        }
    }
    var roomCount : Int?{
        didSet{
            self.maxBedRoomValueLbl.text = (self.roomCount ?? 0).localize
        }
    }
    var bathRoomCount : Float?{
        didSet{
            self.maxBathromValueLbl.text = (self.bathRoomCount ?? 1.0).localize
        }
    }
    //MARK:- Carried Variables from Previous screens
    var strRoomType = ""
    var strPropertyType = ""
    var strRoomLocation = ""
    var strPropertyName = ""
    var latitude = ""
    var longitude = ""
    var strRoomID : String?
    var isToEdit = false
    var bedCountUpdateDelegate : BedCountUpdateDelegate?
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initLanguage()
        // Do any additional setup after loading the view.
    }
    func initView(){
        self.roomAndBedTable.tableHeaderView = self.headerView
        self.backBtn.appHostTextColor()
        self.btnNext.appHostBGColor()
        minRoomBtn.appHostTextColor()
        minGuestBtn.appHostTextColor()
        minBathroomBtn.appHostTextColor()
        plusRoomBtn.appHostTextColor()
        plusGuestBtn.appHostTextColor()
        plusBathroomBtn.appHostTextColor()
        finish_Btn.appHostSideBtnBG()
        thr_Lbl.appGuestBGColor()
        self.maxGuestHolderView.elevate(2)
        self.maxBedRoomHolderView.elevate(2)
        self.maxBathromHolderView.elevate(2)
        
        self.guestCount = 1
        self.roomCount = self.rooms.count
        self.bathRoomCount = 1.0
        
        self.roomAndBedTable.delegate = self
        self.roomAndBedTable.dataSource = self
        
        if self.isToEdit{
            self.bathroomView.isHidden = true
            self.guestView.isHidden = true
            self.pageDescriptionLbl.isHidden = true
            self.headerView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.view.frame.width,
                                           height: 70)
            self.navView.border(0.5, .black)
        }else{
            self.navView.elevate(3)
        }
    }

    func initLanguage(){
        self.pageTitleLbl.text = lang.rombed_Title
        self.pageDescriptionLbl.text = lang.room_Desc
        self.maxGuestTitle.text = lang.maxgues_Tit
        self.maxBathromTitle.text = lang.bath_Tit.capitalized
        self.maxBedRoomTitle.text = lang.beddrms_Title
        self.btnNext.setTitle(self.isToEdit ? lang.save_Tit : lang.next_Tit, for: .normal)
        self.crt_List.text = lang.created_List
        self.finish_Btn.setTitle(lang.finish_List, for: .normal)
        self.mrstps_Lbl.text = lang.morestps_Msg
        self.thr_Lbl.text = 3.localize
        self.backBtn.transform = self.getAffine
       
    }
    //MARK:- initialzers
 
    class func initWithStory(_ bedTypes : [BedType],isToEdit : Bool = false) -> AddRoomBedVC{
        
        let view = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddRoomBedVCID") as! AddRoomBedVC
        view.bedTypes = bedTypes
        view.isToEdit = isToEdit
        if !isToEdit{
            view.commonRoom = BedRoom(beds: bedTypes.compactMap({$0.copy()}),
                                  headerview: AddRoomSHView.initViewFromXib())
        }
        return view
    }
    //MARK:- Actions
    @IBAction func backAction(_ sender : UIButton?){
        if let _selectedBeds = self.selectedBeds{//Inside bed count update
            for bed in _selectedBeds{//Resetting to oldValues
                if let safeValue = self.safeCopyOfSelectedBeds?.filter({$0 == bed}).first{
                    bed.override(usingBed: safeValue)
                }
            }
            self.selectedBeds = nil
        }else{//inside main page
            
            if self.isPresented(){
                self.dismiss(animated: true, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func plusMinusGuestAction(_ sender : UIButton?){
        guard var _guestCount = self.guestCount else {self.guestCount = 1;return}
        if sender == self.minGuestBtn{
            _guestCount -= 1
        }else{
            _guestCount += 1
        }
        guard 1...16 ~= _guestCount else {
            return
        }
        self.guestCount = _guestCount
    }
    @IBAction func plusMinusBathRoomsAction(_ sender : UIButton?){
        guard var _bathroomCount = self.bathRoomCount else {self.bathRoomCount = 0.0;return}
        if sender == self.minBathroomBtn{
            _bathroomCount -= 0.5
        }else{
            _bathroomCount += 0.5
        }
        guard 0...10 ~= _bathroomCount else {
            return
        }
        self.bathRoomCount = _bathroomCount
    }
    @IBAction func plusMinusBedRoomsAction(_ sender : UIButton?){
        guard var _roomCount = self.roomCount else {self.roomCount = 1;return}
        if sender == self.minRoomBtn{
            _roomCount = _roomCount - 1
        }else{
            _roomCount = _roomCount + 1
        }
        guard 0...16 ~= _roomCount else {
            return
        }
        if _roomCount < self.roomCount ?? 0{
            if !self.rooms.isEmpty{self.rooms.removeLast()}
        }else{
            self.rooms.append(BedRoom(beds: self.bedTypes.compactMap({$0.copy()}),
                                      headerview: AddRoomSHView.initViewFromXib()))
        }
        self.roomCount = _roomCount
        self.roomAndBedTable.reloadData()
    }
    @IBAction func nextAction(_ sender : UIButton?){
        
        //let bedCount = bedTypes.compactMap({$0.count}).reduce(0, {$0 + $1})
        if self.selectedBeds != nil{
            self.selectedBeds = nil
        }else{
         self.handleRoomValidation()
        }
    }
    
    @IBAction func onFinishListingAction(_ sender : UIButton?){
        self.route2AddRoomDetail()
    }
    //MARK:- UDF
    func showAlertForRemainingSteps()
    {
        //        viewStepsAlert?.isHidden = false
        self.view.addCenterView(centerView: viewStepsAlert!)
        btnNext.isHidden = true
    }
    //Mark:- Handling Room and Validation and api call
    func handleRoomValidation(){
        
        //Atleast One room should be there
        if self.rooms.isEmpty{
            self.appDelegate
                .createToastMessage("\(self.lang.addBedTypeError)",
                    isSuccess: false)
            return
        }
        
        //Atlease One Room should have bed
        guard self.rooms.anySatisfy({$0.isValid}) else{
            
            for (index,room) in self.rooms.enumerated(){
                if !room.isValid{
                    self.appDelegate
                        .createToastMessage("\(self.lang.bed_Tit) \(index + 1) \(self.lang.noBedsErr)",
                            isSuccess: false)
                    return
                }
            }
            return
        }
        if self.isToEdit{
            self.wstoUpdateRoom()
        }else{
            self.wstoAddNewRoom()
        }
        
        //            if !commonRoom.isValid{
        //                self.appDelegate
        //                    .createToastMessage("\(self.lang.commonSpace) \(self.lang.noBedsErr)",
        //                        isSuccess: false)
        //                return
        //            }
    }
    func route2AddRoomDetail(){
        guard let roomID = self.strRoomID else{return}
        let tempModel = ListingModel()
        tempModel.room_type = strRoomType as NSString
        tempModel.room_location = strRoomLocation as NSString
        tempModel.latitude = latitude as NSString
        tempModel.longitude = longitude as NSString
        tempModel.max_guest_count = (self.guestCount ?? 0).description as NSString
        tempModel.bedroom_count = (self.roomCount ?? 0).description as NSString
//        tempModel.beds_count = strBedsCount as NSString
        tempModel.bathrooms_count = (self.bathRoomCount ?? 0).description as NSString
        tempModel.room_id = roomID as NSString
        tempModel.room_location = strRoomLocation as NSString
        tempModel.room_thumb_images = []
        tempModel.remaining_steps = "3"
        tempModel.home_type = strPropertyName as NSString
        tempModel.policy_type = "Flexible"
        tempModel.isListEnabled = "No"
//        tempModel.bed_type = strBedTypeID as NSString
        tempModel.property_type = strPropertyType as NSString
        appDelegate.strRoomID = roomID
        let  userDefaults = UserDefaults.standard
        tempModel.length_of_stay_options = appDelegate.arrNightData as! NSMutableArray
        tempModel.currency_code = (userDefaults.object(forKey: APPURL.USER_CURRENCY_ORG) as? NSString)!
        tempModel.currency_symbol = (userDefaults.object(forKey: APPURL.USER_CURRENCY_SYMBOL_ORG) as? NSString)!
        let locView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "AddRoomDetails") as! AddRoomDetails
        locView.hidesBottomBarWhenPushed = false
        locView.listModel = tempModel
        locView.strRemaingSteps = "3"
        appDelegate.isFromNewTime = true
        self.navigationController?.hidesBottomBarWhenPushed = false
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.navigationController?.pushViewController(locView, animated: true)
    }
    
    //MARK:- WSHandling
    func getBedsDict() -> String{
        guard !self.rooms.isEmpty else {
            return ""
        }
        var str = "["
        for room in self.rooms{
            str += "\(room.getDict),"
        }
        str.removeLast()
        str.append("]")
        return str
    }
    func wstoUpdateRoom(){
        var dicts = [String: Any]()
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        dicts["token"]              = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]          = self.strRoomID ?? 0
        dicts["bedrooms"]          = self.roomCount ?? 0
        dicts["bedroom_bed_details"]  = self.getBedsDict()
        dicts["common_room_bed_details"] = self.commonRoom.getDict
        dicts["language"] = Language.getCurrentLanguage().rawValue
        WebServiceHandler
            .sharedInstance
            .postWebService(wsMethod: APIMethodsEnum.updateBedRooms,
                            params: dicts) { ( json, error) in
                                if let _ = error{
                                    
                                    self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                                    MakentSupport().removeProgress(viewCtrl: self)
                                }else{
                                    //UserDefaults.standard.set(false, forKey: "isStepsCompleted")
                                    self.appDelegate.isStepsCompleted = false
                                    if json?.string("success_message") == "Rooms Details Added Successfully."{
                                      self.appDelegate.createToastMessage(self.lang.rom_Sucess, isSuccess: false)
                                    }else{
                                    self.appDelegate
                                        .createToastMessage(json?
                                            .string("success_message") ?? "Success", isSuccess: true)
                                    }
                                    self.bedCountUpdateDelegate?
                                        .updatedBedCount(self.roomCount ?? 0)
                                    self.backAction(self.backBtn)
                                }
        }
        
    }
    func wstoAddNewRoom(){
        var dicts = [String: Any]()
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        dicts["token"]              = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_type"]          = strRoomType
        dicts["property_type"]      = strPropertyType
        dicts["latitude"]           = latitude
        dicts["longitude"]          = longitude
        dicts["max_guest"]          = self.guestCount ?? 1
        dicts["bedrooms_count"]     = self.rooms.count
        dicts["bathrooms"]          = self.bathRoomCount ?? 1
        
        
        dicts["bedroom_bed_details"]  = self.getBedsDict()
        
        dicts["common_room_bed_details"] = self.commonRoom.getDict
        dicts["language"] = Language.getCurrentLanguage().rawValue
        WebServiceHandler
        .sharedInstance
        .postWebService(wsMethod: APIMethodsEnum.addNewRoom,
                        params: dicts) { ( json, error) in
                            if let _ = error{
                               
                                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
                                MakentSupport().removeProgress(viewCtrl: self)
                            }else{
                            let gendralModel =
                                MakentSeparateParam()
                                    .separate(params: json! as NSDictionary,
                                              methodName: APPURL.METHOD_ADD_NEW_ROOM as NSString)
                                    as! GeneralModel
                            
                            self.handleAddRoomResponse(gendralModel)
                            }
        }
        
    }
    func handleAddRoomResponse(_ gModel : GeneralModel){
        if gModel.status_code == "1"
        {
            self.strRoomID = gModel.room_id as String
            self.strRoomLocation = gModel.room_location as String
            //                    self.lenthofstay.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
            self.showAlertForRemainingSteps()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAdded"), object: self, userInfo: nil)
        }
        else
        {
            self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
            if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
            {
                self.appDelegate.logOutDidFinish()
                return
            }
        }
        MakentSupport().removeProgress(viewCtrl: self)
    }
}
extension AddRoomBedVC : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.selectedBeds != nil{
            self.roomAndBedTable.tableHeaderView = nil
            self.btnNext.setTitle(lang.done_Title, for: .normal)
            return 1
        }else{
            self.roomAndBedTable.tableHeaderView = self.headerView
            self.btnNext.setTitle(self.isToEdit ? lang.save_Tit : lang.next_Tit, for: .normal)
            return self.rooms.count + 1//+1 for common Space
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedBeds = self.selectedBeds{
            return selectedBeds.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.selectedBeds != nil{
            return nil
        }
        let headerView : AddRoomSHView
        let beds : [BedType]
        if self.rooms.count == section{
            headerView = self.commonRoom.headerview
            headerView.roomNamelbl.text = lang.commonSpace
            beds = self.commonRoom.beds
        }else{
            headerView = self.rooms[section].headerview
            headerView.roomNamelbl.text = "\(lang.beddrm_Title) \((section + 1).localize)"
            beds = self.rooms[section].beds
        }
        let bedCount = beds.compactMap({$0.count}).reduce(0, {$0 + $1})
        let displayNames = beds.compactMap({$0.getDisplayName})
        
        headerView.bedCountLbl.text = "\(bedCount.localize) \(bedCount <= 1 ? lang.bedd_Title : lang.beds_Tit.capitalized)"
        headerView.bedDetailLbl.text = displayNames.joined(separator: ",")
        headerView.addBedsBtn.setTitle(lang.addBeds ,for: .normal)
        
        
        headerView.addBedsBtn.addAction(for: .tap) { [weak self] in
            self?.selectedBeds = beds
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddBedTVC.identifier,
                                                 for: indexPath) as! AddBedTVC
        let optionalBed : BedType? = self.selectedBeds?.value(atSafeIndex: indexPath.row)
        
        guard let bed = optionalBed else{return cell}
        cell.roomTypeNameLbl.text = bed.name
        cell.setValue(bed.count)
        cell.addBtn.addAction(for: .tap) {
            if 0...5 ~= bed.count + 1{
                bed.count += 1
                cell.setValue(bed.count)
            }
        }
        cell.removeBtn.addAction(for: .tap) {
            if 0...5 ~= bed.count - 1{
                bed.count -= 1
                cell.setValue(bed.count)
            }
        }
        
        return cell
    }
    
}
extension AddRoomBedVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.selectedBeds != nil{
            return 0
        }
        let beds : [BedType]
        if self.rooms.count == section{
            beds = self.commonRoom.beds
        }else{
            beds = self.rooms[section].beds
        }
        let displayNames  = beds.compactMap({$0.getDisplayName})
            .joined(separator: ",")
        if let height = displayNames.heightWithConstrainedWidth(self.view.frame.width, font: self.pageDescriptionLbl.font){
            return 80 + height
        }else{
            return (CGFloat(80 + Int(displayNames.count / 15) * 17))//UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
