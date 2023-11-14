/**
* ReservationVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class ReservationVC : UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tblReservation: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var viewNavHeader: UIView?
    var strHeaderTitle:String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var res_Lbl: UILabel!
    
    @IBOutlet weak var res1_Lbl: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tblReservation.tableHeaderView = tblHeaderView
        imgUserThumb?.layer.cornerRadius = (imgUserThumb?.frame.size.height)! / 2
        imgUserThumb?.clipsToBounds = true
        viewNavHeader?.alpha = 0.0

        res_Lbl.text = self.lang.reser_Tit
        res1_Lbl.text = self.lang.reser_Tit
        
//        lblHeaderTitle.text = strHeaderTitle
//        lblHeaderDesc.text = String(format: "You have 2 %@",strHeaderTitle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 141
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellReservationDetails = tblReservation.dequeueReusableCell(withIdentifier: "CellReservationDetails") as! CellReservationDetails
//        cell.lblDetails?.text = "Ultimate Location, Views & Privacy!\nExpired . 6 - 8 Sep 2016"
        cell.view_Detlbl.text = self.lang.view_Det
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let viewEditProfile = StoryBoard.host.instance.instantiateViewController(withIdentifier: "ReservationDetailVC") as! ReservationDetailVC
        viewEditProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
      let y = -scrollView.contentOffset.y as CGFloat;
        if (y > 0){
        }else
        {
            let offsetY = scrollView.contentOffset.y as CGFloat;
            
//            let val1 = (((tblHeaderView.frame.size.height-250) + 110 - offsetY) / 84)
//            let alpha = min(1, 1 - val1)
            if (offsetY > 160)
            {
                viewNavHeader?.alpha = 1.0
            } else  {
                viewNavHeader?.alpha = 0.0
            }
        }
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellReservationDetails: UITableViewCell
{
    @IBOutlet var lblStatus: UILabel?
    @IBOutlet var lblDate: UILabel?
    @IBOutlet var lblMessage: UILabel?
    @IBOutlet var lblGuest: UILabel?
    @IBOutlet weak var view_Detlbl: UILabel!
}
