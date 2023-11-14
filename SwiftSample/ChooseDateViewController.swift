
//
//  ChooseDateViewController.swift
//  Makent
//
//  Created by trioangle on 25/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import WRCalendarView
import DateToolsSwift


class ChooseDateViewController: UIViewController {

    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    //    @IBOutlet weak var weekView: WRWeekView!
   @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet var chooseTimeView: UIView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnSaveChngs: UIButton!
    
    @IBOutlet weak var viewAddNote: UIView!
    
    @IBOutlet weak var viewTxtAdd: UIView!
    
    @IBOutlet weak var consrtNote: NSLayoutConstraint!
    
    @IBOutlet weak var txtViewNote: UITextView!
    
    
    @IBOutlet weak var lblStDate: UILabel!
    
    @IBOutlet weak var lblEdDate: UILabel!
    
    @IBOutlet weak var lblStTime: UILabel!
    
    @IBOutlet weak var lblEndTime: UILabel!
    
    @IBOutlet weak var lblYear: UILabel!
    
    var currentDate = Date()
    
    var baseStep = BasicStpData()
    var readyHost = ReadyToHost()
    var selectedIndex = IndexPath()
    
    var timeData = [TimeData]()
    
    var dataSourceHandler : HourlyCalandarHandler<TimeData>!
    
    var availStaus = "No"
    
    var notes = ""
    
    var index = 0
    
    var strtDate = ""
    
    var strtTime = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var btnAvail: UIButton!
    
    @IBOutlet weak var btnBlock: UIButton!
    
    var unAvailDates = UnAvail()
    
    @IBOutlet weak var dayHeaderCollection: UICollectionView!
    
    @IBOutlet weak var hourHeaderCollection: UICollectionView!
    
    @IBOutlet weak var calendarCollection: UICollectionView!
    
    let lang = Language.localizedInstance()
    
    var gameTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.automaticallyAdjustsScrollViewInsets = false
       
    }
    
    func initView(){
        
        self.readyHost = self.sharedHostSteps
        
        self.dataSourceHandler = HourlyCalandarHandler(calendarCollection)
        self.initCalendarDataSource()
        self.isLoading.isHidden = true
        
        self.dataSourceHandler.goToMonth(Date())
        self.backButton()
        
        
        self.lblYear.TextTitleFont()
        
        
        self.baseStep.crntScreenHostState = .spaceCalendar
        self.continueBtn.setfontDesign()
        self.continueBtn.setTitle(self.lang.continue_Title, for: .normal)
        self.chooseTimeView.isHidden = true
        
        self.CollectionRegister()
        self.consrtNote.constant = 0
        self.viewTxtAdd.layer.cornerRadius = 5
        self.viewTxtAdd.borderColor = .lightGray
        self.viewTxtAdd.borderWidth = 1.0
        self.viewTxtAdd.clipsToBounds = true
        print("dataAvail",self.readyHost.available_times.filter({$0.type == .available}).compactMap({$0.notes}))
        print("dataBlock",self.readyHost.available_times.filter({$0.type == .block}).compactMap({$0.notes}))
        print("notAvail",self.readyHost.not_available_times)
        
        self.btnAvail.backgroundColor = .white
        self.btnBlock.backgroundColor = .lightGray
        
        self.viewAddNote.addTap {
            self.consrtNote.constant = 66
        }
        
        self.continueBtn.addTap {
            self.ContinueAct()
        }
        
        self.btnSaveChngs.addTap {
            //Mark:- Add Event To Display
            
//            if self.txtViewNote.text.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                self.notes = self.txtViewNote.text
                print(self.selectedIndex)
                self.NextAct()
                
//            }
            
            
            self.removeBottomView()
        }
        
        
        
        self.btnBlock.addTap {
            self.availStaus = "No"
            self.btnAvail.backgroundColor = .white
            self.btnBlock.backgroundColor = .lightGray
        }
        self.btnAvail.addTap {
            self.availStaus = "Yes"
            self.btnAvail.backgroundColor = .lightGray
            self.btnBlock.backgroundColor = .white
        }
        self.btnCancel.addTap {
            self.removeBottomView()
            self.consrtNote.constant = 0
        }
        
        
    }
    
    func backButton() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "Back")
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTap {
            self.navigationController?.popViewController(animated: true)
        }
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func initCalendarDataSource(){
        self.unAvailDates.removeAll()
        let sunday : [String] = self.readyHost.not_available_times.array("0")
        if !sunday.isEmpty{
            self.unAvailDates[.sun] = sunday.compactMap({Time(forRailway: $0.description)})
        }
        let monday  : [String] = self.readyHost.not_available_times.array("1")
        if !monday.isEmpty{
            self.unAvailDates[.mon] = monday.compactMap({Time(forRailway: $0.description)})
        }
        let tuesday : [String] = self.readyHost.not_available_times.array("2")
        if !tuesday.isEmpty{
            self.unAvailDates[.tue] = tuesday.compactMap({Time(forRailway: $0.description)})
        }
        let wednesday : [String] = self.readyHost.not_available_times.array("3")
        if !wednesday.isEmpty{
            self.unAvailDates[.wed] = wednesday.compactMap({Time(forRailway: $0.description)})
        }
        let thursday : [String] = self.readyHost.not_available_times.array("4")
        if !thursday.isEmpty{
            self.unAvailDates[.thu] = thursday.compactMap({Time(forRailway: $0.description)})
        }
        let friday : [String] = self.readyHost.not_available_times.array("5")
        if !friday.isEmpty{
            self.unAvailDates[.fri] = friday.compactMap({Time(forRailway: $0.description)})
        }
        let saturday : [String] = self.readyHost.not_available_times.array("6")
        if !saturday.isEmpty{
            self.unAvailDates[.sat] = saturday.compactMap({Time(forRailway: $0.description)})
        }
        
        for blockedDate in self.readyHost.available_times{
            let date = Date().getDateVal(blockedDate.startDate)//blockedDate.startDate
            
            let stTime = Time(forRailway: blockedDate.startTime)//blockedDate.startTime
            self.dataSourceHandler.setData(blockedDate, for: date, time: stTime)
        }
        
    }
    
    func CollectionRegister(){
        self.dayHeaderCollection.register(UINib.init(nibName: "DayCVC", bundle: nil), forCellWithReuseIdentifier: "DayCVC")
        self.hourHeaderCollection.register(UINib.init(nibName: "TimeCVC", bundle: nil), forCellWithReuseIdentifier: "TimeCVC")
        self.calendarCollection.register(UINib.init(nibName: "EventCVC", bundle: nil), forCellWithReuseIdentifier: "EventCVC")
        self.calendarCollection.delegate = self
        self.calendarCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.baseStep.crntScreenHostState = .spaceCalendar
    }
    
    func addBottomView(_ indexPath : IndexPath) {
        var frame = self.chooseTimeView.bounds
        frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: frame.height)
        self.chooseTimeView.frame = frame
        self.view.addBottomView(bottomView: self.chooseTimeView)
        self.continueBtn.isHidden = true
        self.chooseTimeView.isHidden = false
        self.lblStDate.text = Date().dateToDisplay(string: self.dataSourceHandler.date(for: indexPath.item)?.description ?? "2018-09-12 14:11:54+0000")
        self.lblEdDate.text = Date().dateToDisplay(string: self.dataSourceHandler.date(for: indexPath.item)?.description ?? "2018-09-12 14:11:54+0000")
        self.lblStTime.text = Time(forIndex: indexPath.section).rawValue//.getRailwayTimes
        self.lblEndTime.text = Time(forIndex: indexPath.section + 1).rawValue//.getRailwayTimes
        self.strtDate = Time(forIndex: indexPath.section).getRailwayTimes
        self.strtTime = Time(forIndex: indexPath.section).getRailwayTimes
        
    }
    
    func removeBottomView(){
        var frame = self.chooseTimeView.bounds
        frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: frame.height)
        self.chooseTimeView.frame = frame
        self.view.removeBottomView(bottomView: self.chooseTimeView)
        self.chooseTimeView.isHidden = true
        self.continueBtn.isHidden = false
    }
    
    
    func NextAct(){
        
        var parameter = [String : Any]()
        parameter["token"] = UserDefaults.standard.string(forKey: APPURL.USER_ACCESS_TOKEN) ?? ""
       
        parameter["space_id"] = BasicStpData.shared.spaceID
        parameter["start_date"] = self.lblStDate.text
        parameter["start_time"] = self.strtTime
        parameter["notes"]  = self.notes
        parameter["available_status"] = self.availStaus
        MakentSupport().showProgress(viewCtrl: self, showAnimation: true)
        WebServiceHandler().getWebService(wsMethod: .updateCalendar, params: parameter) { (json, error) in
            if let _ = error{
                MakentSupport().removeProgress(viewCtrl: self)
                self.appDelegate.createToastMessage(self.lang.network_ErrorIssue, isSuccess: false)
            }else{
                if let _json = json,
                    _json.isSuccess{
                    
                    MakentSupport().removeProgress(viewCtrl: self)
                    print(_json)
                    
                    self.readyHost.calendarData = _json.json("calendar_data")
                    self.readyHost.not_available_times = self.readyHost.calendarData.json("not_available_times")
                    
                    self.readyHost.available_times.removeAll()
                    self.readyHost.calendarData.array("available_times").forEach { (tempJSON) in
                        let model = TimeData(tempJSON, type: .available)
                        self.readyHost.available_times.append(model)
                    }
                    self.readyHost.calendarData.array("blocked_times").forEach { (tempJSON) in
                        let model = TimeData(tempJSON, type: .block)
                        self.readyHost.available_times.append(model)
                    }
                    self.initCalendarDataSource()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.calendarCollection.reloadData()
                    }
                    
                   
                    
                    
                    self.txtViewNote.text = ""
                }else{
                    MakentSupport().removeProgress(viewCtrl: self)
                    self.appDelegate
                        .createToastMessage(json?
                            .string("success_message") ?? "Success", isSuccess: true)
                }
            }
            
        }
        
    }
    
    class func InitWithStory() -> ChooseDateViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "ChooseDateViewController") as! ChooseDateViewController
    }
    
    func ContinueAct(){
        self.navigationController?.removeProgress()
//        let dashboardVC = self.navigationController!.viewControllers.filter { $0 is SpaceListViewController }.first!
        //self.navigationController?.popToRootViewController(animated: true)
        let addSpace = AddSpaceViewController.InitWithStory()
        addSpace.fromChoose = true
        self.navigationController?.pushViewController(addSpace, animated: false)
    }
  
    
    //Mark:- Checking Is Blocked Or Not
    func isBlocked(for indexPath: IndexPath)->Bool{
        if let data = self.dataSourceHandler.getData(for: indexPath){
            
            if data.type == .block{
                return true
            }
        }
        return false
    }
    
    //Mark:- Checking Is Available Times Or Not
    func isAvailable(for indexPath: IndexPath)->Bool{
        
        if let data = self.dataSourceHandler.getData(for: indexPath){
            
            if data.type == .available{
                return true
            }
        }
        return false
    }
    
    //Mark:- Checking Time And Date Is Expired Or Not
    func isYesterday(for indexPath: IndexPath)->Bool{
       
        if self.dataSourceHandler.date(for: indexPath.item)!.startOfDay - (60*60*24)  < Date().startOfDay {
            return true
        }
        return false
    }
    
    //Mark:- Checking Date Is Today Or Not
    func isToday(for indexPath: IndexPath)->Bool{
        
        
        if self.dataSourceHandler.date(for: indexPath.item)?.startOfDay ?? Date().startOfDay == Date().startOfDay && (self.dataSourceHandler.date(for: indexPath.item)?.yesterDay != Date().startOfDay){
            return true
        }
        return false
    }
    
    
    //Mark:- Checking Time And Date Is Expired Or Not
     func isExpired(for indexPath: IndexPath)->Bool{
     let time = Time(forIndex: indexPath.section)
     
     if self.dataSourceHandler.date(for: indexPath.item)?.startOfDay ?? Date().startOfDay < Date().startOfDay || ((self.dataSourceHandler.date(for: indexPath.item)?.startOfDay == Date().startOfDay) && (time.getIndex <= Date().currentTime.getIndex)){
     return true
     }
     return false
     }
}



extension ChooseDateViewController : UICollectionViewDataSource,UICollectionViewDataSourcePrefetching{
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case self.dayHeaderCollection:
            return 1
        case self.hourHeaderCollection:
            return 1
        case self.calendarCollection:
            return Time.count
        default:
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.dayHeaderCollection:
            return self.dataSourceHandler.dateCount
        case self.hourHeaderCollection:
            return Time.count
        case self.calendarCollection:
            return self.dataSourceHandler.dateCount
        default:
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let date = self.dataSourceHandler
            .date(for: indexPath.item) ?? Date()
        var day = (date.weekDays).description
        day.append((date.days).description)
        switch collectionView {
        case self.dayHeaderCollection:
             let cell : DayCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCVC", for: indexPath) as! DayCVC
             
             day.append((date.months).description)
             day.append("\n"+(date.years).description)
             cell.lblDayVal.text = date.weekDays.description.capitalized
             cell.lblDateVal.text = date.days.description
            return cell
            
        case self.hourHeaderCollection:
             let cell : TimeCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCVC", for: indexPath) as! TimeCVC
            
             let time = Time(forIndex: indexPath.item)
             cell.lblTimeVal.text = time.rawValue
            return cell
            
        case self.calendarCollection:
             let cell : EventCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCVC", for: indexPath) as! EventCVC
             
             let time = Time(forIndex: indexPath.section)
             
             //(self.unAvailDates[date.weekDays] != nil)
            if self.unAvailDates[date.weekDays]?.contains(time) ?? false{
                
                //Mark:- Checking Not Available Times
                    cell.viewEvent.backgroundColor = UIColor().getNotAvailableColor()
                    return cell
                
             }else if let data = self.dataSourceHandler.getData(for: indexPath){
                
                //Mark:- Checking Blocked And Available Times
                
                 if   self.isAvailable(for: indexPath)   {
                    
                    cell.lblEventDesc.text = data.notes
                     //+ "\n" + data.startTime + " - " + data.endTime
                    cell.viewEvent.backgroundColor = UIColor().getAvailableColor()
                }else if self.isBlocked(for: indexPath)  {
                    cell.lblEventDesc.text = data.notes + "\n" + data.startTime + " - " + data.endTime
                    cell.viewEvent.backgroundColor = UIColor().getBlockedColor()
                }
                
            }else{
                if self.isToday(for: indexPath){
                    cell.viewEvent.backgroundColor = UIColor().getTodayColor()
                }else{
                    let expired = self.isYesterday(for: indexPath)
                    cell.viewEvent.backgroundColor = expired ? .lightGray : .white
                }
             }
             
            
            return cell
            
        default:
            
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.last?.item == self.dataSourceHandler.dateCount - 1{
             //print("lastItemFound",indexPaths.last?.item)
            
             self.isLoading.startAnimating()
             self.isLoading.isHidden = false
             DispatchQueue.main.async {
                self.dataSourceHandler.addNextYear()
                self.calendarCollection.layoutIfNeeded()
                self.calendarCollection.collectionViewLayout.invalidateLayout()
                self.calendarCollection.reloadData()
                self.dayHeaderCollection.reloadData()
                self.isLoading.stopAnimating()
                self.isLoading.isHidden = true
             }
        }else if indexPaths.first?.item == 0{
            self.isLoading.startAnimating()
            self.isLoading.isHidden = false
            DispatchQueue.main.async {
                self.dataSourceHandler.addPreviousYear()
                self.calendarCollection.layoutIfNeeded()
                self.calendarCollection.collectionViewLayout.invalidateLayout()
                self.calendarCollection.reloadData()
                self.dayHeaderCollection.reloadData()
                self.isLoading.stopAnimating()
                self.isLoading.isHidden = true
            }
            
        }
        
    }

}


extension ChooseDateViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("∂ Section : \(indexPath.section), Item : \(indexPath.item)")
        self.selectedIndex = indexPath
        
        guard collectionView == self.calendarCollection else{return}
        
        let time = Time(forIndex: indexPath.section)
        let date = self.dataSourceHandler.date(for: indexPath.item)
        
       //Mark:- Checking Day is Less Than Today or Day is Expired
        if let _date = date,
            self.unAvailDates[_date.weekDays]?.contains(time) ?? false || isExpired(for: indexPath){
            if self.chooseTimeView.isHidden == false{
                self.removeBottomView()
                
            }
        }else{
            if self.chooseTimeView.isHidden == false{
                self.removeBottomView()
                self.addBottomView(indexPath)
            }else{
                self.addBottomView(indexPath)
            }
            
        }
        
        self.calendarCollection.reloadItems(at: [indexPath])
    }
}
extension ChooseDateViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.dayHeaderCollection:
            return CGSize.init(width: CalendarCollectionViewLayout.CELL_WIDTH, height: 55)
        case self.hourHeaderCollection:
            return CGSize.init(width: 50, height: CalendarCollectionViewLayout.CELL_HEIGHT)
        default:
            return CGSize.zero
        }
    }
}
extension ChooseDateViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        switch scrollView {
        case self.calendarCollection:

            let center = self.view.convert(scrollView.center, to: self.calendarCollection)
            self.dayHeaderCollection.contentOffset.x = scrollView.contentOffset.x
            self.hourHeaderCollection.contentOffset.y = scrollView.contentOffset.y
            
            if let index = self.calendarCollection.indexPathForItem(at: center),
                let date = self.dataSourceHandler.date(for: index.item){
                self.lblMonth.text = date.months.description.capitalized
                self.lblYear.text = date.years.description
            }else {
                self.calendarCollection.reloadData()
            }

        case self.hourHeaderCollection:
            self.calendarCollection.contentOffset.y = scrollView.contentOffset.y
        case self.dayHeaderCollection:
            self.calendarCollection.contentOffset.x = scrollView.contentOffset.x
        default:
            break
        }
    }

}

