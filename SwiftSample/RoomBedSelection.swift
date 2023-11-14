/**
* RoomBedSelection.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

protocol RoomBedUpdateDelegate
{
    func RoomBedUpdated(listModel: ListingModel)
}


class RoomBedSelection : UIViewController
{
    //MARK:- Outlets
    @IBOutlet weak var pageTitleLbl : UILabel!
    @IBOutlet weak var saveBtn : UIButton!
    @IBOutlet weak var backBtn : UIButton!
    
    @IBOutlet weak var maxBathromTitle : UILabel!
    @IBOutlet weak var plusBathRoomBtn : UIButton!
    @IBOutlet weak var minusBathRoomBtn : UIButton!
    @IBOutlet weak var bathRoomValueLbl : UILabel!
    
    @IBOutlet weak var maxGuestTitle : UILabel!
    @IBOutlet weak var plusGuestBtn : UIButton!
    @IBOutlet weak var minusGuestBtn : UIButton!
    @IBOutlet weak var guestValueLbl : UILabel!
    
    
    @IBOutlet weak var bedsHolderView : UIView!
    @IBOutlet weak var bedTypeTitleLbl : UILabel!
    @IBOutlet weak var bedTypeValueLbl : UILabel!
    
    @IBOutlet weak var propertyHolderView : UIView!
    @IBOutlet weak var propertyTypeTitleLbl : UILabel!
    @IBOutlet weak var propertyTypeValueTF : UITextField!
    
    @IBOutlet weak var roomHolderView : UIView!
    @IBOutlet weak var roomTypeTitleLbl : UILabel!
    @IBOutlet weak var roomTypeValueTF : UITextField!
    
    @IBOutlet weak var bedCountLbl : UILabel!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
  
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var delegate : RoomBedUpdateDelegate?
    var listModel : ListingModel!
    var isApiCalled = false
    var arrRoomTypes = [RoomPropertyModel]()
    var arrHomeTypes = [RoomPropertyModel]()
    var bedTypes : [BedType]!
    var isPickingPropertyType = false
    lazy var pickerView : UIPickerView = {
        var _pickerView = UIPickerView()
        _pickerView.backgroundColor = .white
        _pickerView.showsSelectionIndicator = true
        
       _pickerView.delegate = self
        
        _pickerView.dataSource = self
        return _pickerView
    }()
    lazy var toolBar : UIToolbar = {
        var _toolBar = UIToolbar()
        _toolBar.barStyle = UIBarStyle.default
        //        toolBar.translucent = true
        _toolBar.tintColor = UIColor.appHostTitleColor
        _toolBar.sizeToFit()
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: lang.cancel_Title, style: .plain, target: self, action: #selector(self.onPickerCancel))
            //UIBarButtonItem(barButtonSystemItem: .cancel, target: self                                           action: #selector(self.onPickerCancel))
        
         //cancelButton.title = lang.cal_Title
        _toolBar.setItems([ spaceButton, cancelButton], animated: false)
        _toolBar.isUserInteractionEnabled = true
        
        return _toolBar
    }()
    var guestCount : Int?{
        didSet{
            self.guestValueLbl.text = (self.guestCount ?? 0).localize
            self.checkSaveBtnStatus()
        }
    }
    var bathRoomCount : Float?{
        didSet{
            self.bathRoomValueLbl.text = (self.bathRoomCount ?? 0.0).localize
            self.checkSaveBtnStatus()
        }
    }
    var getOldProperyTypeName : String?{
        if let selectedPropType = self.arrHomeTypes.filter({$0.property_id == self.listModel.property_type}).first{
            return selectedPropType.property_name.description
        }
        return nil
    }
    var getOldRoomTypeName : String?{
        if let selectedroomType = self.arrRoomTypes.filter({$0.property_id == self.listModel.room_type}).first{
            return selectedroomType.property_name.description
        }
        return nil
    }
    var selectedRoomID : String?
    var selectedPropertyID : String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //MARK:- view life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initView()
        self.initGestures()
        self.getRoomPropertyType()
        self.initLanguage()
        self.populateView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bedCountLbl.text = ((Int(listModel.bedroom_count as String) ?? 0) + 1).localize
        self.checkSaveBtnStatus()
    }
    //MARK:- initialize
    func initView(){
        self.propertyTypeValueTF.delegate = self
        
        self.roomTypeValueTF.delegate = self
        self.propertyTypeValueTF.inputView = self.pickerView
        self.propertyTypeValueTF.inputAccessoryView = self.toolBar
        self.roomTypeValueTF.inputView = self.pickerView
        self.roomTypeValueTF.inputAccessoryView = self.toolBar
        backBtn.appHostTextColor()
        saveBtn.appHostTextColor()
        minusGuestBtn.appHostTextColor()
        minusBathRoomBtn.appHostTextColor()
        plusGuestBtn.appHostTextColor()
        plusBathRoomBtn.appHostTextColor()
        bedCountLbl.appHostTextColor()
        bedTypeValueLbl.appHostTextColor()
        propertyTypeValueTF.textColor = UIColor.appHostTitleColor
        roomTypeValueTF.textColor = UIColor.appHostTitleColor
       
        
    }
    func initGestures(){
        self.bedsHolderView.addAction(for: .tap) { [weak self] in
            self?.fetchandMove2AddRoomVC()
        }
        self.roomHolderView.addAction(for: .tap) { [weak self] in
            self?.showPicker(forProperty: false)
        }
        self.propertyHolderView.addAction(for: .tap) { [weak self] in
            self?.showPicker(forProperty: true)
        }
    }
    func initLanguage(){
        self.pageTitleLbl.text = lang.rombed_Title
        self.maxGuestTitle.text = lang.maxgues_Tit
        self.maxBathromTitle.text = lang.bath_Tit.capitalized
        self.bedTypeTitleLbl.text = lang.bedtyp_Title.capitalized
        self.propertyTypeTitleLbl.text = lang.proptyp_Tit
        self.roomTypeTitleLbl.text = lang.rom_Typ
        self.propertyTypeValueTF.placeholder = lang.some_Titt
        self.roomTypeValueTF.placeholder = lang.some_Titt
        if Language.getCurrentLanguage().isRTL{
            self.bedCountLbl.textAlignment = .left
        }
        self.saveBtn.setTitle(lang.save_Tit, for: .normal)
        self.bedTypeValueLbl.transform = self.getAffine
        self.backBtn.transform = self.getAffine
        
    }
    func populateView(){
        self.guestCount = Int(self.listModel.max_guest_count.description) ?? 0
        self.bathRoomCount = Float(self.listModel.bathrooms_count.description)
        self.checkSaveBtnStatus()
    }
    //MARK: - API CALL -> GETTING ROOM PROPERTY
    /*
     Get Exist Room Property type
     */
    
    func getRoomPropertyType()
    {
        MakentSupport().showProgress(viewCtrl: self, showAnimation: false)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ROOM_PROPERTY_TYPE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let propertyData = response as! GeneralModel
            OperationQueue.main.addOperation {
                if propertyData.status_code == "1"
                {
                    self.isApiCalled = true

                    self.arrRoomTypes = propertyData.arrTemp1
                        .compactMap({$0 as? RoomPropertyModel})
                    self.arrHomeTypes = propertyData.arrTemp2
                        .compactMap({$0 as? RoomPropertyModel})
                    self.bedTypes = propertyData.bedTypes
                    self.propertyTypeValueTF.text = self.getOldProperyTypeName ?? ""
                    self.roomTypeValueTF.text = self.getOldRoomTypeName ?? ""
               
                    self.checkSaveBtnStatus()
                }
                else
                {
                    if propertyData.success_message == "token_invalid" || propertyData.success_message == "user_not_found" || propertyData.success_message == "Authentication Failed"
                    {
                        AppDelegate.sharedInstance.logOutDidFinish()
                        return
                    }
                }
                MakentSupport().removeProgress(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgress(viewCtrl: self)
            }
        })
    }

    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        self.backBtn.isUserInteractionEnabled = false
        self.view.endEditing(true)
        var dicts = [AnyHashable: Any]()
        
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        self.saveBtn.isHidden = true
        
        self.animatedLoader?.isHidden = false
        
        dicts["token"]  = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["room_id"]   = listModel.room_id
        dicts["bathrooms"]   = (self.bathRoomCount ?? 0.0).description as NSString
     

      
        dicts["person_capacity"]   = self.guestCount?.description as NSString? ?? listModel.max_guest_count

        dicts["room_type"]   = self.selectedRoomID as NSString? ?? listModel.room_type
       
        
        dicts["property_type"]   = self.selectedPropertyID as NSString? ?? listModel.property_type
        
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ROOMS_BEDS_LIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    self.backBtn.isUserInteractionEnabled = true
                    var tempModel = ListingModel()
                    tempModel = self.listModel
                    tempModel.room_type = self.selectedRoomID as NSString? ?? self.listModel.room_type
                   
                    tempModel.property_type = self.selectedPropertyID as NSString? ?? self.listModel.property_type
                    tempModel.max_guest_count = self.guestCount?.description as NSString? ?? self.listModel.max_guest_count
                    tempModel.bathrooms_count = (self.bathRoomCount ?? 0.0).description as NSString
                    self.listModel = tempModel
                    self.delegate?.RoomBedUpdated(listModel: self.listModel)
                    self.onBackTapped(self.backBtn)
                }
                else
                {
                    self.appDelegate.createToastMessage(gModel.success_message as String, isSuccess: false)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                    //                    self.btnBack.isUserInteractionEnabled = true
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.backBtn?.isHidden = false
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }
        })
    }
    @objc func onPickerCancel(){
        self.view.endEditing(true)
    }
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if self.saveBtn.isHidden{
            self.navigationController?.popViewController(animated: true)
            return
        }
        let alert =  UIAlertController(title: lang.alert,
                                       message: lang.discardMessage,
                                       preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: lang.discard, style: UIAlertAction.Style.destructive, handler: { (action) in
            
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: lang.cancel_Title, style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func addRemoveBathroomAction(_ sender : UIButton?){
        guard var _bathroomCount = self.bathRoomCount else {self.bathRoomCount = 0.0;return}
        if sender == self.minusBathRoomBtn{
            _bathroomCount -= 0.5
        }else{
            _bathroomCount += 0.5
        }
        guard 0...10 ~= _bathroomCount else {
            return
        }
        self.bathRoomCount = _bathroomCount
    }
    @IBAction func addRemoveGuestAction(_ sender : UIButton?){
        guard var _guestCount = self.guestCount else {self.guestCount = 1;return}
        if sender == self.minusGuestBtn{
            _guestCount -= 1
        }else{
            _guestCount += 1
        }
        
    
        guard 0...16 ~= _guestCount else {
            return
        }
        self.guestCount = _guestCount
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UDF
    func checkSaveBtnStatus(){
        let changed =
            self.guestCount != Int(self.listModel.max_guest_count.description) ||
            self.bathRoomCount != Float(self.listModel.bathrooms_count.description) ||
            self.propertyTypeValueTF.text != self.getOldProperyTypeName ||
            self.roomTypeValueTF.text != self.getOldRoomTypeName
        self.saveBtn.isHidden = !changed
    }
    func showPicker(forProperty : Bool){
        self.isPickingPropertyType = forProperty
        if self.isPickingPropertyType{
            self.propertyTypeValueTF.becomeFirstResponder()
        }else{
            self.roomTypeValueTF.becomeFirstResponder()
        }
        self.pickerView.becomeFirstResponder()
    }
    func fetchandMove2AddRoomVC(){
        let params : [String : Any] = [
            "token" : Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN),
            "room_id" : listModel.room_id
         ]
        MakentSupport().showProgress(viewCtrl: self, showAnimation: false)
        WebServiceHandler.sharedInstance
        .getWebService(wsMethod: APIMethodsEnum.roomBedDetails,
                        params: params) { (json, error) in
                    
                            MakentSupport().removeProgress(viewCtrl: self)
                            if let jsonValue = json?.json("data"){
                                let selectedCommonBed = jsonValue
                                    .array("common_beds")
                                    .compactMap({BedType($0)})
                                var selectedBedRooms = [[BedType]]()
                                if let array = jsonValue["bed_room_beds"] as? [[JSONS]]{
                                    array.forEach({ (item) in
                                        selectedBedRooms
                                            .append(item
                                                .compactMap({BedType($0)}))
                                    })
                                }
                                self.routeToAddRoom(withCommonBeds:selectedCommonBed,
                                                    rooms: selectedBedRooms)
                            }else{
                                print(error?.localizedDescription ?? "error")
                            }
        }
    }
    func routeToAddRoom(withCommonBeds common : [BedType],rooms : [[BedType]]){
        let addRoomVC = AddRoomBedVC.initWithStory(self.bedTypes,isToEdit: true)
        for room in rooms{
            var newBedsInRoom = self.bedTypes
                .compactMap({$0.copy()})
            for oldBed in room{
                newBedsInRoom = newBedsInRoom.filter({$0 != oldBed})
                newBedsInRoom.append(oldBed)
            }
            addRoomVC.rooms.append(BedRoom(beds: newBedsInRoom,
                                           headerview: AddRoomSHView.initViewFromXib()))
        }
        var newCommonBeds = self.bedTypes.compactMap({$0.copy()})
        for oldCommonbed in common{
            newCommonBeds = newCommonBeds.filter({$0 != oldCommonbed})
            newCommonBeds.append(oldCommonbed)
        }
        addRoomVC.commonRoom = BedRoom(beds: newCommonBeds,
                                       headerview: AddRoomSHView.initViewFromXib())
        addRoomVC.strRoomID = listModel.room_id.description
        addRoomVC.bedCountUpdateDelegate = self
        self.navigationController?.pushViewController(addRoomVC,
                                                      animated: true)
    }
}
//MARK:- UIPickerViewDataSource
extension RoomBedSelection : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.isPickingPropertyType{
            return self.arrHomeTypes.count
        }else{
            return self.arrRoomTypes.count
        }
    }
   
}
//MARK:- UIPickerViewDelegate
extension RoomBedSelection : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.isPickingPropertyType{
            return self.arrHomeTypes
                .value(atSafeIndex: row)?.property_name
                .description ?? "nil"
        }else{
            return self.arrRoomTypes
                .value(atSafeIndex: row)?.property_name
                .description ?? "nil"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.isPickingPropertyType{
            let prop = self.arrHomeTypes
                .value(atSafeIndex: row)
            self.propertyTypeValueTF.text = prop?.property_name
                .description ?? "nil"
            
            self.selectedPropertyID = prop?.property_id.description
        }else{
            let room = self.arrRoomTypes
                .value(atSafeIndex: row)
            self.roomTypeValueTF.text = room?.property_name
                .description ?? "nil"
            self.selectedRoomID = room?.property_id.description
        }
        self.checkSaveBtnStatus()
    }
}
//MARK:- UITextFieldDelegate
extension RoomBedSelection : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isPickingPropertyType = textField == self.propertyTypeValueTF
        self.pickerView.reloadAllComponents()
        let row : Int
        if self.isPickingPropertyType{
            guard !arrHomeTypes.isEmpty else{return}
            row = arrHomeTypes.find(includedElement: {$0.property_name.description == textField.text}) ?? 0
        }else{
            guard !arrRoomTypes.isEmpty else{return}
            row = arrRoomTypes.find(includedElement: {$0.property_name.description == textField.text}) ?? 0
        }
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
    }
}
extension RoomBedSelection : BedCountUpdateDelegate{
    func updatedBedCount(_ count: Int) {
        self.listModel.bedroom_count = count.description as NSString
    }
}
//MARK:- #########################################
class CellRoomBedSelection: UITableViewCell
{
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblSubValues: UILabel?
    @IBOutlet var lblIsShared: UILabel?

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
