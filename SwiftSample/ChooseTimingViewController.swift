//
//  ChooseTimingViewController.swift
//  Makent
//
//  Created by trioangle on 16/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import UserNotifications

protocol TimeselectionProtocal {
    func setSelectedDate(times :GetAvailabilityTimeData, isFromStartTime: Bool)
}

class ChooseTimingViewController: UIViewController, TimeselectionProtocal {
    
    @IBOutlet weak var chooseDateView: UIView!
    @IBOutlet weak var chooseTimingLabel: UILabel!
    @IBOutlet weak var chooseTimingBackBtn: UIButton!
    @IBOutlet weak var selectedDates: UILabel!
    @IBOutlet weak var selectedTiming: UILabel!
    @IBOutlet weak var save: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    var availableTimes : GetAvailabilityTimeData!
    @IBOutlet weak var checkInTime: UILabel!
    @IBOutlet weak var checkOutTime: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var eventVC: DateselectionProtocal?
   
    var timesTitle = [String]()
    
    func setSelectedDate(times: GetAvailabilityTimeData, isFromStartTime: Bool) {
        if isFromStartTime {
            self.availableTimes.selectedStarTime = times.selectedStarTime
        }else {
            self.availableTimes.selectedEndTime = times.selectedEndTime
        }
        updateLabelDetails(isFromStartTime: isFromStartTime)
    }
    
    func updateLabelDetails(isFromStartTime: Bool) {
        if isFromStartTime
        {
            startTime.text = self.lang.startTime+"\n\(self.availableTimes.selectedStarTime)"
        }
        else
        {
            endTime.text = self.lang.endTime+"\n\(self.availableTimes.selectedEndTime)"
        }
        
    }
    
//    func setSelectedDate(times: String, isFromStartTime : Bool)
//    {
////        timeBooleanValues   = isFromStartTime
////        timeValues          = times
//        if isFromStartTime == true
//        {
//            startTime.text = "\(self.lang.startTime)\n\(times.)"
//        }
//        else
//        {
//            endTime.text = "\(self.lang.endTime)\n\(times)"
//        }
//
//        print("time choosing time selection", times, "timeBoolean Values", isFromStartTime)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChooseTimingViewController",availableTimes.startDate,availableTimes.endDate)
        self.navigationController?.isNavigationBarHidden = true
        chooseTimingLabel.text = self.lang.chooseTiming
        selectedDates.text     = self.lang.selected_Dates
        selectedTiming.text    = self.lang.selected_Timings
        save.text              = self.lang.save_Tit
        
        checkInTime.text = self.lang.checkin_Title+"\n\(availableTimes.startDate)"
        checkInTime.textColor = UIColor.appGuestThemeColor
        checkOutTime.text = self.lang.checkout_Title+"\n\(availableTimes.endDate)"
        checkOutTime.textColor = UIColor.appGuestThemeColor
        startTime.text = self.lang.startTime
        endTime.text = self.lang.endTime
        startTime.textColor = UIColor.appGuestThemeColor
        endTime.textColor = UIColor.appGuestThemeColor
        save.layer.backgroundColor  = k_AppThemePinkColor.cgColor
        self.chooseDateView.addTap {
            self.navigationController?.popViewController(animated: true)
        }
        startTime.addTap {
            self.addTimes(isFromStart: true)
        }
        endTime.addTap
        {
            if self.startTime.text == self.lang.startTime
            {
                self.appDelegate.createToastMessage(self.lang.endTimeErrorMsg, isSuccess: false)
            }
            else
            {
                self.addTimes(isFromStart: false)
            }
        }
        chooseTimingBackBtn.addTarget(self, action: #selector(self.onBackTapped), for: .touchUpInside)
        
        save.addTap {
            self.saveAction()
        }
        // Do any additional setup after loading the view.
    }
    
    func saveAction()
    {
        print("starttime text", self.startTime.text!)
        print("End time",self.endTime.text!)
        
                if self.startTime.text! == self.lang.startTime
        {
                    self.appDelegate.createToastMessage(self.lang.pleaseSelectStartTime, isSuccess: false)
        }
                else if self.endTime.text! == self.lang.endTime
        {
                    self.appDelegate.createToastMessage(self.lang.pleaseSelectEndTime)
        }
        else
        {
            if checkInTime.text != "" , checkOutTime.text != "" , availableTimes.startDate != availableTimes.endDate {
                print("Success")
                let paramDict = ["startDate" : self.availableTimes.startDate,
                                             "endDate" : self.availableTimes.endDate,
                                              "startTime": self.availableTimes.selectedStarTime,
                                               "endTime" :self.availableTimes.selectedEndTime]
                                              NotificationCenter.default.post(name: Notification.Name("DateTimeDetails"), object: nil, userInfo: paramDict)
                self.dismiss(animated: true, completion: nil)
            } else if checkInTime.text != "" , checkOutTime.text != "" , availableTimes.startDate == availableTimes.endDate {
                if !self.timeComparision(self.availableTimes.selectedStarTime, self.availableTimes.selectedEndTime)
                 {
                     self.appDelegate.createToastMessage(self.lang.endTimeShouldBeGreaterThanTheStartTime)
                } else {
                    let paramDict = ["startDate" : self.availableTimes.startDate,
                                                 "endDate" : self.availableTimes.endDate,
                                                  "startTime": self.availableTimes.selectedStarTime,
                                                   "endTime" :self.availableTimes.selectedEndTime]
                                                  NotificationCenter.default.post(name: Notification.Name("DateTimeDetails"), object: nil, userInfo: paramDict)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
           else if !self.timeComparision(self.availableTimes.selectedStarTime, self.availableTimes.selectedEndTime)
            {
                self.appDelegate.createToastMessage(self.lang.endTimeShouldBeGreaterThanTheStartTime)
            }
            else
            {
                let paramDict = ["startDate" : self.availableTimes.startDate,
                                             "endDate" : self.availableTimes.endDate,
                                              "startTime": self.availableTimes.selectedStarTime,
                                               "endTime" :self.availableTimes.selectedEndTime]
                                              NotificationCenter.default.post(name: Notification.Name("DateTimeDetails"), object: nil, userInfo: paramDict)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func timeComparision (_ stTime : String,_ edTime : String) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let sDate = dateFormatter.date(from: stTime) ?? Date()
        let eDate = dateFormatter.date(from: edTime) ?? Date()
        if sDate < eDate{
            print("true")
            return true
        }else{
            print("false")
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        print("onBack Button Tapped")
        self.navigationController?.popViewController(animated: true)
    }
    
    func addTimes(isFromStart : Bool)
    {
        let eventView     = k_MakentStoryboard.instantiateViewController(withIdentifier: "TimeAvailabilityVCID") as! TimeAvailabilityViewController
        eventView.chooseTimeVC = self
        eventView.modalPresentationStyle = .custom
        if isFromStart
        {
            eventView.isFromStartTime = true
        }
        else
        {
            eventView.isFromStartTime = false
        }
        eventView.availabilityTime = self.availableTimes
       // self.navigationController?.pushViewController(eventView, animated: true)
        self.present(eventView, animated: true, completion: nil)
    }
   
}
