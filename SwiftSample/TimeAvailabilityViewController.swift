//
//  TimeAvailabilityViewController.swift
//  Makent
//
//  Created by trioangle on 17/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TimeAvailabilityViewController: UIViewController {
    
    @IBOutlet weak var tableviewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var availableTimeTableView: UITableView!
    
    @IBOutlet weak var availabilityScrollView: UIScrollView!
    
    @IBOutlet weak var scrollInnerBaseView: UIView!
    
    @IBOutlet weak var timeAvailabilityBlankView: UIView!
    
    var availabilityTime : GetAvailabilityTimeData!
    var isFromStartTime : Bool!
    var chooseTimeVC: TimeselectionProtocal?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableTimeTableView.delegate = self
        availableTimeTableView.dataSource = self
        availabilityScrollView.delegate = self
        availableTimeTableView.tableFooterView = UIView()
        
        availabilityScrollView.alwaysBounceVertical = true
        availabilityScrollView.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        availabilityScrollView.addSubview(refreshControl)
        
        self.timeAvailabilityBlankView.addTap {
             self.dismiss(animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         print("outside clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//     print("outside clicked")
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @objc func didPullToRefresh() {
        print("Refersh")
        // For End refrshing
        self.dismiss(animated: true, completion: nil)
        refreshControl?.endRefreshing()
    }
    
}

extension TimeAvailabilityViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AvailabilityTimeCell = self.availableTimeTableView.dequeueReusableCell(withIdentifier: "AvailabilityTimeCellID") as! AvailabilityTimeCell
        cell.availableTimeValues.border(1.0, .lightGray)
        cell.availableTimeValues.cornerRadius = cell.availableTimeValues.frame.height/2
        if isFromStartTime
        {
//            if indexPath.row < self.availabilityTime.starttimes.count
//            {
            let data = self.availabilityTime.starttimes[indexPath.row]
            print("Blocked: \(data.blocked)")
            if data.blocked == true
            {
                cell.availableTimeValues.textColor = UIColor.lightGray
                cell.availableTimeValues.appGuestViewBGColor()
            }
            else
            {
                cell.availableTimeValues.textColor = UIColor.black
                cell.availableTimeValues.backgroundColor = .white
            }
            cell.availableTimeValues.text =  data.time
            //self.localToUTC(date: data.time)
            self.tableviewHeightCons.constant = self.availableTimeTableView.contentSize.height + 100
//            }
        }
        else
        {
            let data = self.availabilityTime.endTimes[indexPath.row]
//            cell.availableTimeValues.text =  data.time
           
            if data.blocked == true
            {
                cell.availableTimeValues.textColor = UIColor.lightGray
            }
            else
            {
                cell.availableTimeValues.textColor = UIColor.black
            }
             cell.availableTimeValues.text = data.time
//                self.localToUTC(date: data.time)//data.time
            self.tableviewHeightCons.constant = self.availableTimeTableView.contentSize.height + 100
           // self.tableviewHeightCons.constant = CGFloat((data.time.count) * 80)
        }
        self.availableTimeTableView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        if self.isFromStartTime {
            return self.availabilityTime.starttimes.count
        }
        else {
            return self.availabilityTime.endTimes.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let vw = UIView()
        vw.frame = self.view.frame
        vw.frame.size.height = 60
        vw.frame.origin.y = 0
        let lblNew = UILabel()
        lblNew.frame = CGRect(x: vw.frame.width/2 - 35, y: vw.frame.minY, width: vw.frame.width, height: vw.frame.height)
        // lblNew.text = "Test"
        if isFromStartTime == true
        {
             lblNew.text = "Start Time"
        }
        else
        {
            lblNew.text = "End Time"
        }
        lblNew.textColor = UIColor.black
//        lblNew.translatesAutoresizingMaskIntoConstraints = false
        vw.addSubview(lblNew)
        return vw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if isFromStartTime == true
        {
            let data = self.availabilityTime.starttimes[indexPath.row]
            
            if data.blocked
            {
                
            }
            else
            {
                self.availabilityTime.selectedStarTime = self.availabilityTime.starttimes[indexPath.row].time
                self.chooseTimeVC?.setSelectedDate(times: self.availabilityTime,isFromStartTime: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else
        {
            let data = self.availabilityTime.endTimes[indexPath.row]
            
            if data.blocked
            {
                
            }
            else
            {
            print("selected end Time",self.availabilityTime.endTimes[indexPath.row].time)
            //self.timeValidate(check: stTime, check: edTime)
                self.availabilityTime.selectedEndTime = self.availabilityTime.endTimes[indexPath.row].time
             self.chooseTimeVC?.setSelectedDate(times: self.availabilityTime, isFromStartTime: false)
             self.dismiss(animated: true, completion: nil)
            }
        }
        //self.timeValidate(check: stTime, check: edTime)
        
        
//        self.present(eventView, animated: false, completion: nil)
    }
}

extension TimeAvailabilityViewController : UIScrollViewDelegate
{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        print("scrollingContent functions",scrollView.contentOffset.y)
        print("scrollingFrame functions",scrollView.frame.origin.y)
        print("scrollingBase functions",scrollInnerBaseView.frame.origin.y)
//      if scrollView.contentOffset.y == 0
//        {
//            self.dismiss(animated: true, completion: nil)
//        }
        // self.dismiss(animated: true, completion: nil)
    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if decelerate
//        {
//            self.dismiss(animated: true, completion: nil)
//        }
//
//
//    }
}

class AvailabilityTimeCell : UITableViewCell
{
    
    @IBOutlet weak var availableTimeValues: UILabel!
    
}
