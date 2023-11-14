/**
* CreatedList.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social


protocol createdListDelegate
{
    func onCreateListTapped(index:Int)
}


class CreatedList : UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblCreatedList: UITableView!
    var delegate: createdListDelegate?
    var arrRoomList : NSMutableArray = NSMutableArray()
    var selectedRoom_id = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.adjustTableViewFrame(CGFloat(arrRoomList.count))
        self.tblCreatedList.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.makeTableViewAnimation), userInfo: nil, repeats: false)
    }
    
    func adjustTableViewFrame(_ count:CGFloat )
    {
        let valCount = (count > 6) ? 6 : count
        var rectStartBtn = self.tblCreatedList.frame
        rectStartBtn.size.height = valCount * 70
        self.tblCreatedList.frame = rectStartBtn
    }
    
    //MARK: ZOOM ANIMATION FOR TABLEVIEW
    /*
     ANIMATING TABLE VIEW
     */
    
    @objc func makeTableViewAnimation(isRemoved : Bool)
    {
        UIView.animate(withDuration:0.5 , animations: {
            self.tblCreatedList.transform = (isRemoved) ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        appDelegate.makentTabBarCtrler.tabBar.isHidden = true
    }
    
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.makeTableViewAnimation(isRemoved: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.removeView), userInfo: nil, repeats: false)
    }
    
    @objc func removeView()
    {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Room Detail Table view Handling
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellCreatedList = tblCreatedList.dequeueReusableCell(withIdentifier: "CellCreatedList")! as! CellCreatedList
        let listModel = arrRoomList[indexPath.row] as? ListingModel
        cell.setRoomDatas(modelListing: listModel!)
        cell.lblTickMark.isHidden = (selectedRoom_id == listModel?.room_id as! String) ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        delegate?.onCreateListTapped(index: indexPath.row)
        self.onBackTapped(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onAddListTapped(){
        
    }
}

class CellCreatedList: UITableViewCell
{
    @IBOutlet var lblName: UILabel?
    @IBOutlet var lblSteps: UILabel?
    @IBOutlet var imgRoomView: UIImageView?
    @IBOutlet var lblTickMark: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func setRoomDatas(modelListing: ListingModel)
    {
        if (modelListing.room_name as String).count > 0
        {
            lblName?.text = modelListing.room_name as String
        }
        else
        {
            lblName?.text = String(format:"%@ \(self.lang.in_Title) %@",modelListing.room_type,modelListing.room_location)
        }
        
        if modelListing.remaining_steps == "0"
        {
            lblSteps?.text = self.lang.lis_Title
            lblSteps?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
        else
        {
            lblSteps?.attributedText = MakentSupport().makeHostAttributeTextColor(originalText: String(format:"%@ \(self.lang.steps_Title) - %@",modelListing.remaining_steps,modelListing.room_type) as NSString, normalText: String(format:"- %@",modelListing.room_type) as NSString, attributeText: String(format:"%@ \(self.lang.steps_Title)",modelListing.remaining_steps) as NSString, font: (lblSteps?.font)!)
        }
        
        if (modelListing.room_thumb_images?.count)! > 0
        {
            imgRoomView?.addRemoteImage(imageURL: modelListing.room_thumb_images?[0] as! String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: modelListing.room_thumb_images?[0] as! String) as! URL, placeholderImage:UIImage(named:""))
        }
        else
        {
            imageView?.image = UIImage(named:"room_default_no_photos.png")
        }
        
    }


}


