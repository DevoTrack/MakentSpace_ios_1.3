//
//  ChooseViewController.swift
//  Makent
//
//  Created by trioangle on 18/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol statusUpdate{
    var isUpdated : Bool {get}
}

class ChooseViewController: UIViewController {

    @IBOutlet weak var lblChsTim: UILabel!
    @IBOutlet weak var tblTiming: UITableView!
    @IBOutlet weak var cnsrtTblTiming: NSLayoutConstraint!
    @IBOutlet weak var cnsrtBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var stsUpdateDel : statusUpdate?
    
    let lang = Language.localizedInstance()
    var mainAvailableTime:MainAvailableTimes!
    
    var mainAvailableTimes = [MainAvailableTimes]()
    var dayIndex = Int()
    
    var selectedIndex = Int()
    var isSelectStart = Bool()
    var isAdd : Bool = false
    var isDelete : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViewLayout()
    }
    
    func initViewLayout(){
        
        self.addPopButton()
        self.title = "Choose Time"
        self.tblTiming.register(UINib.init(nibName: "TVCOpenClsCell", bundle: nil), forCellReuseIdentifier: "TVCOpenClsCell")
        self.tblTiming.register(UINib.init(nibName: "TVCHourCell", bundle: nil), forCellReuseIdentifier: "TVCHourCell")
        self.tblTiming.reloadData()
        
        if self.mainAvailableTime.currentAvaliableStatus == .Open {
            self.cnsrtBtnHeight.constant = 30
            self.btnAdd.setTitle("Add", for: .normal)
        }else{
            self.cnsrtBtnHeight.constant = 0
            self.btnAdd.setTitle("", for: .normal)
        }
        
        self.btnAdd.setfontDesign()
        self.btnSave.setfontDesign()
        self.btnSave.setTitle(lang.save_Tit, for: .normal)
        self.btnSave.addTap {
            if self.timeAlert(){
            self.NextAct()
            }
        }
        self.btnAdd.addTap {
            self.mainAvailableTime.sub_availability_times.append(SubAvailableTimes.init())
            self.isAdd = true
            self.tblTiming.reloadData()
        }
        
    }
    func addPopButton() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "Back")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (Pop), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    

    
    @objc
    func Pop(){
        self.removeEmptyTimeSlot()
        self.navigationController?.popViewController(animated: true)
    }
    
    //Mark:- Remove Empty Time Slot While Pop From CurrentView
    func removeEmptyTimeSlot(){
        let stTime = self.mainAvailableTime.sub_availability_times.compactMap({$0.start_time})
        let edTime = self.mainAvailableTime.sub_availability_times.compactMap({$0.end_time})
        
        if stTime.contains("") || edTime.contains(""){
            
            if let i = stTime.index(of: ""){
                self.mainAvailableTime.sub_availability_times.remove(at: i)
            }else if let j = edTime.index(of: ""){
                self.mainAvailableTime.sub_availability_times.remove(at: j)
            }
            
        }
    }
    
    func timeAlert() -> Bool{
       
        let stTime = self.mainAvailableTime.sub_availability_times.compactMap({$0.start_time})
        let edTime = self.mainAvailableTime.sub_availability_times.compactMap({$0.end_time})
        guard self.mainAvailableTime.currentAvaliableStatus != .All && self.mainAvailableTime.currentAvaliableStatus != .Closed  else {return true}
        //guard (stTime.count > 1 && edTime.count > 1) else {return true}
    
        if stTime.contains("") && edTime.contains(""){
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseSelectStartAndEndTime, isSuccess: false)
            return false
        }else if stTime.contains(""){
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseSelectStartTime, isSuccess: false)
            return false
        }else if edTime.contains(""){
            self.sharedAppDelegete.createToastMessage(self.lang.pleaseSelectEndTime, isSuccess: false)
            return false
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.cnsrtTblTiming.constant = self.tblTiming.contentSize.height
        self.tblTiming.reloadData()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.cnsrtTblTiming.constant = self.tblTiming.contentSize.height
        }

    }
    
    
    
    //Mark:- Toggle Switch Action
    @objc func opnClsAct(_ swt : UISwitch){
        
        switch swt.tag {
        case 0:
            if self.mainAvailableTime.currentAvaliableStatus == .Closed{
                self.mainAvailableTime.status = Availability.Open.text
               
                if !self.mainAvailableTime.sub_availability_times.isEmpty {
                    self.ShowBtn()
                    return
                }else{
                    self.mainAvailableTime.status = Availability.All.text
                    self.CloseBtn()
                }
            }else {
                self.removeEmptyTimeSlot()
                self.mainAvailableTime.status = Availability.Closed.text
            }
            self.CloseBtn()

            break
        case 1:
            if self.mainAvailableTime.currentAvaliableStatus == .All {

                if self.mainAvailableTime.sub_availability_times.count == 0{
                    self.mainAvailableTime.sub_availability_times.append(SubAvailableTimes.init())
                }
                self.mainAvailableTime.status = Availability.Open.text
                self.ShowBtn()
               
                
            }else if self.mainAvailableTime.currentAvaliableStatus == .Open{
                self.mainAvailableTime.status = Availability.All.text
                self.CloseBtn()
                
            }
            break
        default:
            print("valueChanges")
        }
    }
    
    
    func NextAct(){
        
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["step"] = "ready_to_host"
        parameter["availability_data"] = self.sharedUtility.getJsonFormattedString(self.mainAvailableTime.getDict())
        print("Parameters:",parameter)
    
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().postWebService(wsMethod: .updateSpace, params: parameter) { (json, error) in
            
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.sharedAppDelegete.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    MakentSupport().removeProgress(viewCtrl: self)
                    print(_json)
                    self.sharedVariable.readyToHostStep.calendarData = _json.json("calendar_data")
                    self.sharedVariable.readyToHostStep.not_available_times = self.sharedVariable.readyToHostStep.calendarData.json("not_available_times")
                    if self.mainAvailableTime.currentAvaliableStatus == .All {
                        self.mainAvailableTime.sub_availability_times.removeAll()
                    }
                    self.sharedVariable.readyToHostStep.available_times.removeAll()
                    self.sharedVariable.readyToHostStep.calendarData.array("available_times").forEach { (tempJSON) in
                        let model = TimeData(tempJSON, type: .available)
                        self.sharedVariable.readyToHostStep.available_times.append(model)
                    }
                    self.sharedVariable.readyToHostStep.calendarData.array("blocked_times").forEach { (tempJSON) in
                        let model = TimeData(tempJSON, type: .block)
                        self.sharedVariable.readyToHostStep.available_times.append(model)
                    }

                    self.mainAvailableTimes[self.dayIndex].status = self.mainAvailableTime.status
                    self.mainAvailableTimes[self.dayIndex].sub_availability_times = self.mainAvailableTime.sub_availability_times
                    print("CalendarData:",self.sharedVariable.readyToHostStep.calendarData)
                    
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.sharedAppDelegete.createToastMessage(json?.string("success_message") ?? "Success", isSuccess: true)
                }
            }
            
        }
        
    }
    
    func CloseBtn(){
        self.cnsrtBtnHeight.constant = 0
        self.btnAdd.setTitle("", for: .normal)
        self.tblTiming.reloadData()
    }
    func ShowBtn(){
        self.cnsrtBtnHeight.constant = 30
        self.btnAdd.setTitle("Add", for: .normal)
        self.tblTiming.reloadData()
        self.cnsrtTblTiming.constant = self.tblTiming.contentSize.height
    }
    
    
    class func InitWithStory()-> ChooseViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "ChooseViewController") as! ChooseViewController
    }

    

}
extension ChooseViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else if section == 1{
            if self.mainAvailableTime.currentAvaliableStatus == .Closed {
                return 0
            }else{
                return 1
            }
        }else {
            if self.mainAvailableTime.currentAvaliableStatus == .Open {
                 return self.mainAvailableTime.sub_availability_times.count
            }else{
            return 0
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVCOpenClsCell", for: indexPath) as! TVCOpenClsCell
            
            
            cell.swtOpnCls.tintColor = UIColor.appGuestThemeColor
            cell.swtOpnCls.onTintColor = UIColor.appGuestThemeColor
            cell.swtOpnCls.tag = indexPath.section
            
           
            if self.mainAvailableTime.currentAvaliableStatus == .Closed {
                cell.lblOpnCls.text = Availability.Closed.text
                cell.swtOpnCls.setOn(false, animated: true)
                
            }else{
                cell.lblOpnCls.text =  Availability.Open.text
                cell.swtOpnCls.setOn(true, animated: true)
            }
            
            cell.swtOpnCls.addTarget(self, action: #selector(self.opnClsAct(_:)), for: .valueChanged)
            
            return cell
            
            
        }else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVCOpenClsCell", for: indexPath) as! TVCOpenClsCell
            
            cell.swtOpnCls.tintColor = UIColor.appGuestThemeColor
            cell.swtOpnCls.onTintColor = UIColor.appGuestThemeColor
            cell.swtOpnCls.tag = indexPath.section
            
            if self.mainAvailableTime.currentAvaliableStatus == .All {
                cell.lblOpnCls.text = "All Hours"
            }
            
            if self.mainAvailableTime.currentAvaliableStatus == .Open {
                cell.lblOpnCls.text = "Set Hours"
            }
            
            if self.mainAvailableTime.currentAvaliableStatus == .All{
                cell.swtOpnCls.setOn(true, animated: true)
            }else{
                cell.swtOpnCls.setOn(false, animated: true)
            }
            
            cell.swtOpnCls.addTarget(self, action: #selector(self.opnClsAct(_:)), for: .valueChanged)
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVCHourCell", for: indexPath) as! TVCHourCell
            let time = self.mainAvailableTime.sub_availability_times
            print("StartTime:",time[indexPath.row].start_time)
            print("EndTime:",time[indexPath.row].end_time)

            cell.txtFldSrtTim.placeholder = "start time"
            cell.txtFldEndTim.placeholder = "end time"
            
            if time.count > 1{
                cell.btnDelete.isHidden = false
            }else{
                cell.btnDelete.isHidden = true
            }
            
            cell.viewStrt.addTap {

                self.callTimeSelectionPage(time[indexPath.row].start_time, isFromStart: true, index: indexPath.row)
            }
            
            cell.viewEnd.addTap {

                self.callTimeSelectionPage(time[indexPath.row].end_time, isFromStart: false, index: indexPath.row)
            }
            
            cell.btnDelete.addTap {
                self.isDelete = true
                self.mainAvailableTime.sub_availability_times.remove(at: indexPath.row)
//                self.viewWillLayoutSubviews()
                self.tblTiming.reloadData()
                self.cnsrtTblTiming.constant = self.tblTiming.contentSize.height
//                self.isDelete = false
            }
            
            cell.txtFldSrtTim.text = time[indexPath.row].start_time.getUserFormattedDate()
            cell.txtFldEndTim.text = time[indexPath.row].end_time.getUserFormattedDate()
            
            return cell
        }
    }
    
    
    func callTimeSelectionPage(_ selected:String?,isFromStart:Bool,index:Int) {
        
        self.selectedIndex = index
        self.isSelectStart = isFromStart
        let dateList = DateListViewController.InitWithStory()
        var tempModelArray = [SubAvailableTimes]()
        
        
        dateList.selectedTime = self.mainAvailableTime.sub_availability_times[index]
        
        
        //Mark:- Setting 24 Hours Data Array(isSelected false to All)
        let totalList = self.datesHourRange(from: "00:00", to: "23:59")
        totalList.forEach { (tempmode) in
            var jsons = JSONS()
            jsons["start_time"] = tempmode
            jsons["end_time"] = tempmode
            let model = SubAvailableTimes(jsons)
            model.isSelected = false
            tempModelArray.append(model)
        }
        
        for model in self.mainAvailableTime.sub_availability_times {
            if (model.start_time != "" && model.start_time != self.mainAvailableTime.sub_availability_times[index].start_time)
            || (model.end_time != "" && model.end_time != self.mainAvailableTime.sub_availability_times[index].end_time) {
                
                //Mark:- For Changing DateFormatter For Data Already Present
               
                print("Status:",self.mainAvailableTime.currentAvaliableStatus.rawValue)
                let disbleIndex = self.datesHourRange(from: (model.start_time), to: (model.end_time), isFromAMPM: true,isDateSec : true)
                print("StTime,EdTime",model.start_time,model.end_time)
                print("disableIndex:",disbleIndex)
                for timeStr in disbleIndex {
                    if let index = tempModelArray.index(where:{$0.start_time == timeStr}){
                        print(tempModelArray[index].start_time)
                        tempModelArray[index].isSelected = true
                    }
                }
            }
        }
        
        
        dateList.totalTimeList = tempModelArray
        dateList.delegate = self
        dateList.isDateSec = true
        
        dateList.isFromStartTime = isFromStart
        
        
        self.navigationController?.pushViewController(dateList, animated: true)
    }
}
extension ChooseViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
}

extension ChooseViewController:DateListVCDelegate {
    
    func selectedDatapassing(_ selectedTime: SubAvailableTimes) {
        //let selectedTimeListArray = self.mainAvailableTime.sub_availability_times[self.selectedIndex]
        if  self.isSelectStart {
            self.mainAvailableTime.sub_availability_times[self.selectedIndex].start_time = selectedTime.start_time
            self.mainAvailableTime.sub_availability_times[self.selectedIndex].end_time = selectedTime.end_time
        } else {
             self.mainAvailableTime.sub_availability_times[self.selectedIndex].end_time = selectedTime.end_time
        }
        
        
        
        self.tblTiming.beginUpdates()
        let indexPath = IndexPath(row: self.selectedIndex, section: 2)
        self.tblTiming.reloadRows(at: [indexPath], with: .bottom)
        self.tblTiming.endUpdates()
//        if !self.isShowAddMore {
//            self.isShowAddMore = true
//            self.tblTiming.reloadData()
//        }
        
        if  self.isSelectStart &&  ( self.mainAvailableTime.sub_availability_times[self.selectedIndex].start_time != selectedTime.end_time && selectedTime.end_time != "end time" ) {
             self.mainAvailableTime.sub_availability_times[self.selectedIndex].start_time = selectedTime.start_time
             self.mainAvailableTime.sub_availability_times[self.selectedIndex].end_time = selectedTime.end_time
//            self.wsToAddTime()
            return
            
        }
        else if !( self.mainAvailableTime.sub_availability_times[self.selectedIndex].start_time == "start time") && !self.isSelectStart {
             self.mainAvailableTime.sub_availability_times[self.selectedIndex].end_time = selectedTime.end_time
//            self.wsToAddTime()
            return
        }
        
        self.tblTiming.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
}

/*//            if self.subAvalibleTimes.count > 0{
 //                if self.mainAvailableTime.availVal == Availability.Open.rawValue || self.mainAvailableTime.availVal == Availability.All.rawValue{
 //                    self.mainAvailableTime.availVal = Availability.Close.rawValue
 //                    self.tempArray = self.subAvalibleTimes
 //                    self.if self.mainAvailableTime.currentAvaliableStatus == .All {
 //                    self.CloseBtn()
 //                    self.subAvalibleTimes = self.tempArray
 //                }else{
 //                    self.mainAvailableTime.availVal = Availability.Open.rawValue
 //                    self.subAvalibleTimes = self.tempArray
 //                    self.tempArray.removeAll()
 //                    self.ShowBtn()
 //                    self.tempArray = self.subAvalibleTimes
 //                }
 //            }else{
 //
 //                if self.mainAvailableTime.availVal == Availability.All.rawValue{
 //                    self.mainAvailableTime.availVal = Availability.Close.rawValue
 //                    self.CloseBtn()
 //                }else{
 //                    self.mainAvailableTime.availVal = Availability.All.rawValue
 //                    self.ShowBtn()
 //                }
 //            }*/
