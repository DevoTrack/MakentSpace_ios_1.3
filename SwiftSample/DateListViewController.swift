//
//  DateListViewController.swift
//  Makent
//
//  Created by trioangle on 24/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol DateListVCDelegate {
    func selectedDatapassing(_ selectedTime:SubAvailableTimes)
}

class DateListViewController: UIViewController {

    @IBOutlet weak var tblvTimeList: UITableView!
    
    var totalTimeList = [SubAvailableTimes]()
    
    var selectedTime :SubAvailableTimes!
    var delegate:DateListVCDelegate?
    var isFromStartTime = Bool()
    var isDateSec = Bool()

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addBackButton()
        self.view.backgroundColor = .white
    }
    

    
    class func InitWithStory()-> DateListViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "DateListViewController") as! DateListViewController
    }
    
    func TimeValid(){
        
    }
    
}
extension DateListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalTimeList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
        
        cell.textLabel?.customFont(.light, textColor: .lightGray)
        
        let model = totalTimeList[indexPath.row]
        if model.isSelected {
            cell.textLabel?.textColor = .lightGray
        }else {
            cell.textLabel?.textColor = .black
        }
        if self.isFromStartTime {
            cell.textLabel?.text = model.start_time
            if self.selectedTime.start_time == model.start_time {
                cell.textLabel?.textColor = .appGuestThemeColor
            }
            
        }else {
            if self.selectedTime.end_time == model.end_time {
                cell.textLabel?.textColor = .appGuestThemeColor
            }
            cell.textLabel?.text = model.end_time
            
        }
       
        
       
        return cell
    }
}
extension DateListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model =  self.totalTimeList[indexPath.row]
        if model.isSelected {
            return
        }else {
            if !self.isFromStartTime {
                //MARK: CHECK DISABLE INDEX FROM CLICKABLE INDEX
                var checkIndex = self.selectedTime?.end_time
                
                if let end_time = checkIndex, end_time == ""{
                    checkIndex = (self.selectedTime?.start_time)!
                }
                
                if let startIndex = self.totalTimeList.index(where:{$0.end_time == checkIndex}) {
                    let disbledIndex = self.datesHourRange(from: (self.totalTimeList[startIndex].end_time), to: self.totalTimeList[indexPath.row].end_time, isFromAMPM: true, isDateSec: isDateSec)
                    if let index = self.totalTimeList.index(where:{disbledIndex.contains($0.end_time) && $0.isSelected})  {
                        if index <= indexPath.row {
                            self.sharedAppDelegete.createToastMessage(self.sharedAppDelegate.lang.pleaseChooseValidTimes)
                            return
                        }
                    }
                }
                
                
                //MARK: CHECK 30 MINUTES INTERVAL
                if let index = self.totalTimeList.index(where: {$0.start_time == self.selectedTime?.start_time}) {
                    if ((index) >= indexPath.row) {
                        self.sharedAppDelegete.createToastMessage(self.sharedAppDelegate.lang.youCannotSelectThisTimeBecauseTimeIntervalIsAHourRequired)
                        return
                    }
                }
                
                //MARK: CHECK TIME SHOULD BE GREATER THEN
                if let index = self.totalTimeList.index(where:{$0.end_time == self.selectedTime?.start_time})  {
                    if index >= indexPath.row {
                        self.sharedAppDelegete.createToastMessage(self.sharedAppDelegete.lang.endTimeShouldBeGreaterThanTheStartTime)
                        return
                    }
                }
                
                self.selectedTime?.end_time = self.totalTimeList[indexPath.row].end_time
            }else {
                
                if self.selectedTime.start_time == "" {
                    self.selectedTime?.start_time = self.totalTimeList[indexPath.row].start_time
                }else {
                    let checkIndex = self.selectedTime?.end_time
        
                    if let startIndex = self.totalTimeList.index(where:{$0.end_time == checkIndex}) {
                         var disbledIndex = [String]()
                        if startIndex > indexPath.row {
                            disbledIndex = self.datesHourRange(from:self.totalTimeList[indexPath.row].start_time , to: (self.totalTimeList[startIndex].end_time), isFromAMPM: true, isDateSec: isDateSec)
                        }else {
                            self.sharedAppDelegete.createToastMessage(self.sharedAppDelegete.lang.endTimeShouldBeGreaterThanTheStartTime)
                            return
                        }
                       
//                        if disbledIndex.isEmpty {
//                            self.sharedAppDelegete.createToastMessage("Please choose valid times")
//                            return
//                        }else
                            if let index = self.totalTimeList.index(where:{disbledIndex.contains($0.start_time) && $0.isSelected})  {
                            if index >= indexPath.row {
                                self.sharedAppDelegete.createToastMessage(self.sharedAppDelegate.lang.pleaseChooseValidTimes)
                                return
                            }
                        }
                        else {
                            self.selectedTime?.start_time = self.totalTimeList[indexPath.row].start_time
                        }
                    } else {
                            self.selectedTime?.start_time = self.totalTimeList[indexPath.row].start_time
                    }
                    
                }
                

            }
        }
        self.delegate?.selectedDatapassing(self.selectedTime)
        self.navigationController?.popViewController(animated: true)
        
    }
}
class TimeCell : UITableViewCell{
    
}

