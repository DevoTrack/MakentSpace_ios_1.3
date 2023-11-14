//
//  TimeFilterViewController.swift
//  Makent
//
//  Created by Trioangle on 29/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
import UserNotifications

class TimeFilterViewController: UIViewController
{
    
    @IBOutlet weak var timeFilterTableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var endTimeView: UIView!
    var timeBoolean = Bool()
    
    /// Add the time selctor values
    var TimeArray = ["12:00 AM","01:00  AM","02:00 AM","03:00 AM","04:00 AM","05:00 AM","06:00 AM","07:00 AM","08:00 AM","09:00 AM","10:00 AM","11:00 AM","12:00 PM","01:00 PM","02:00 PM","03:00 PM","04:00 PM","05:00 PM","06:00 PM","07:00 PM","08:00 PM","09:00 PM","10:00 PM","11:00 PM","11:59 PM"]
    
    @IBOutlet weak var endTimeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        timeFilterTableView.dataSource = self
        timeFilterTableView.delegate   = self
        
        endTimeTableView.dataSource  = self
        endTimeTableView.delegate    = self
        
        timeFilterTableView.showsVerticalScrollIndicator = false
        endTimeTableView.showsVerticalScrollIndicator    = false
        
        if !timeBoolean
        {
            self.timeFilterTableView.isHidden = true
        }
        else
        {
            self.endTimeView.isHidden = true
        }
        
//        backgroundView.addTap {
//            self.dismiss(animated: true, completion: nil)
//
////            self.dismiss(animated: true) {
////                if !self.timeBoolean
////                       {
////                           self.timeFilterTableView.isHidden = true
////                       }
////                       else
////                       {
////                           self.endTimeView.isHidden = true
////                       }
////            }
//        }
        //self.endTimeView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     print("outside clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
//     func touchesBegan(_ touches: Set<AnyHashable>, withEvent event: UIEvent) {
//        var touch: UITouch? = touches.first as! UITouch
//        //location is relative to the current view
//        // do something with the touched point
//        if touch?.view !=  {
//            yourView.isHidden = true
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool)
    {
      
    }
    
   
    
     /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TimeFilterViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == self.timeFilterTableView
        {
            let timecell:TimeFilterCell = self.timeFilterTableView.dequeueReusableCell(withIdentifier: "TimeFilterCellID") as! TimeFilterCell
            timecell.timeLabel.text = self.TimeArray[indexPath.row]
            cell = timecell
        }
        else if tableView == self.endTimeTableView
        {
             let endcell:EndTimeFilterCell = self.endTimeTableView.dequeueReusableCell(withIdentifier: "EndTimeCellID") as! EndTimeFilterCell
            endcell.endTimeLabel.text = self.TimeArray[indexPath.row]
            cell = endcell
        }
//        self.timeFilterTableView.layoutIfNeeded()
//        self.view.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return self.TimeArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let vw = UIView()
        vw.frame = self.view.frame
        vw.frame.size.height = 60
        //vw.frame.origin.y = 20
        let lblNew = UILabel()
        lblNew.frame = vw.frame
        lblNew.text = "  Select"
//        lblNew.center = vw.center
//        lblNew.center.x = vw.center.x
//        lblNew.center.y = vw.center.y
        lblNew.center.x = vw.center.x
        lblNew.frame.origin.y = vw.frame.origin.y
        lblNew.textColor = UIColor.black
        vw.backgroundColor = UIColor.white
        // lblNew.translatesAutoresizingMaskIntoConstraints = false
        vw.addSubview(lblNew)
        
//        if tableView == timeFilterTableView
//        {
//            vw.frame = self.view.frame
//            vw.frame.size.height = 60
//            vw.frame.origin.y = 0
//            let lblNew = UILabel()
//            lblNew.frame = vw.frame
//            // lblNew.text = "Test"
//            lblNew.text = "Select"
//            lblNew.textColor = UIColor.black
//            //        lblNew.translatesAutoresizingMaskIntoConstraints = false
//            vw.addSubview(lblNew)
//        }
//        else if tableView ==  endTimeTableView
//        {
//            vw.frame = self.view.frame
//            vw.frame.size.height = 60
//            vw.frame.origin.y = 0
//            let lblNew = UILabel()
//            lblNew.frame = vw.frame
//            // lblNew.text = "Test"
//            lblNew.text = "Select"
//            lblNew.textColor = UIColor.black
//            //        lblNew.translatesAutoresizingMaskIntoConstraints = false
//            vw.addSubview(lblNew)
//        }
        return vw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == timeFilterTableView
        {
            
            print("selectedTime",self.TimeArray[indexPath.row])
            self.dismiss(animated: true) {
                let paramDict = ["selectStartTime" : self.TimeArray[indexPath.row]]
                NotificationCenter.default.post(name: Notification.Name("startTime"), object: nil, userInfo: paramDict)
            }
        }

        else if tableView ==  endTimeTableView
        {
            self.dismiss(animated: true) {
                let paramDict = ["selectEndTime" : self.TimeArray[indexPath.row]]
                NotificationCenter.default.post(name: Notification.Name("endTime"), object: nil, userInfo: paramDict)
            }

        }
    }
}

class TimeFilterCell : UITableViewCell
{
    
    @IBOutlet weak var timeLabel: UILabel!
}

class EndTimeFilterCell : UITableViewCell
{
   
    @IBOutlet weak var endTimeLabel: UILabel!
}
