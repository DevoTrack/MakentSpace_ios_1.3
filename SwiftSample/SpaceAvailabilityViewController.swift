//
//  SpaceAvailabilityViewController.swift
//  Makent
//
//  Created by trioangle on 17/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceAvailabilityViewController: UIViewController {
    
//    lazy var isUpdated : Bool = Bool()
    

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tblVwSpaceAvail: UITableView!
    
    @IBOutlet weak var contBtn: UIButton!
    
    var dayArray = [String]()
    
    var baseStep = BasicStpData()
    
    var mainAvailableTime = [MainAvailableTimes]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let lang = Language.localizedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViewLayout()
    }
    
    //Mark:- ViewInitialLayout function
    func initViewLayout(){
        
        self.contBtn.setfontDesign()
        self.mainAvailableTime = self.sharedHostSteps.availability_times
        self.lblTitle.text = "Set your space availability"
        self.contBtn.setTitle(self.lang.continue_Title, for: .normal)
    
        self.baseStep.crntScreenHostState = .spaceAvailability
        self.backButton()
        
        dayArray = [self.lang.sun_Title,self.lang.mon_Title,self.lang.tue_Title,self.lang.wed_Title,self.lang.thurs_Title,self.lang.fri_Title,self.lang.sat_Title]
        self.tblVwSpaceAvail.register(UINib.init(nibName: "TVCSpaceAvail", bundle: nil), forCellReuseIdentifier: "TVCSpaceAvail")
        self.tblVwSpaceAvail.reloadData()
        self.contBtn.setfontDesign()
        self.contBtn.addTap {
            self.NextAct()
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
    override func viewWillAppear(_ animated: Bool) {
        self.baseStep.crntScreenHostState = .spaceAvailability
        self.tblVwSpaceAvail.reloadData()
    }
    
    func NextAct(){
        let Cancel = CancellationViewController.InitWithStory()
        self.navigationController?.pushViewController(Cancel, animated: true)
    }
    
    class func InitWithStory() -> SpaceAvailabilityViewController{
        return StoryBoard.Space.instance.instantiateViewController(withIdentifier: "SpaceAvailabilityViewController") as! SpaceAvailabilityViewController
    }
    

}
extension SpaceAvailabilityViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCSpaceAvail", for: indexPath) as! TVCSpaceAvail
        cell.imgArr.transForm()
        print("availSts:",mainAvailableTime[indexPath.row].status)
        cell.lblDay.text = dayArray[indexPath.row]
        cell.lblSts.text = mainAvailableTime[indexPath.row].status
        return cell
    }
}
extension SpaceAvailabilityViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chooseTime = ChooseViewController.InitWithStory()
        chooseTime.mainAvailableTime = self.mainAvailableTime[indexPath.row].copy()
        chooseTime.mainAvailableTimes = self.mainAvailableTime
        chooseTime.dayIndex = indexPath.row
        self.navigationController?.pushViewController(chooseTime, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
