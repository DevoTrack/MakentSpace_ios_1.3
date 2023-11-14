/**
* DescripePlace.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social


protocol DescribePlaceDelegate
{
    func roomDescriptionChanged(strDescription: NSString, isTitle: Bool)
}

class RoomDescriptionTVC: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}


class DescripePlace : UIViewController,UITableViewDelegate, UITableViewDataSource,EditTitleDelegate {
//    @IBOutlet var scrollMenus: UIScrollView!
    @IBOutlet weak var tit_Lbl: UILabel!
    
    @IBOutlet weak var back_Btn: UIButton!
    
    @IBOutlet var tblDescPlace: UITableView!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var delegate: DescribePlaceDelegate?
    var strRoomId = ""
    var strTitle = ""
    var strRoomDesc = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
         self.tit_Lbl.text = self.lang.descpl_Title
        self.back_Btn.transform = self.getAffine
        back_Btn.appHostTextColor()
//        let rect = MakentSupport().getScreenSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.makentTabBarCtrler.tabBar.isHidden = true

    }
    
    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //
    //MARK: Room Detail Table view Handling
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomDescriptionTVC") as! RoomDescriptionTVC
        if indexPath.row == 0 {
            cell.titleLabel.text = self.lang.add_Tit
            cell.subTitleLabel.text = strTitle.count > 0 ? strTitle : self.lang.clr_Desc
        }
        else {
            cell.titleLabel.text = self.lang.writ_Summ
            cell.subTitleLabel.text = strRoomDesc.count > 0 ? strRoomDesc : self.lang.travabt_Space
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let button = UIButton()
        if indexPath.row == 0 {
            button.tag = 11
        }
        else {
            button.tag = 12
        }
        
        onAddTitleAndSummaryTapped(button)
    }
    
    @IBAction func onAddTitleAndSummaryTapped(_ sender:UIButton!)
    {
        let propertyView = StoryBoard.host.instance.instantiateViewController(withIdentifier: "EditTitleVC") as! EditTitleVC
        propertyView.strPlaceHolder = (sender.tag==11) ? self.lang.clr_Desc : self.lang.travabt_Space
        propertyView.delegate = self
        propertyView.strRoomId = strRoomId
        propertyView.strAboutMe = (sender.tag==11) ? strTitle : strRoomDesc
        appDelegate.nSelectedIndex = (sender.tag==11) ? 0 : 1
        propertyView.nMaxCharCount = (sender.tag==11) ? 35 : 500
        propertyView.strTitle = (sender.tag==11) ? lang.edit_Tit: lang.edit_Summ
        self.navigationController?.pushViewController(propertyView, animated: true)
    }

    //MARK: EDIT TITLE CHANGED DELEGATE METHOD
    internal func EditTitleTapped(strDescription: NSString)
    {
        delegate?.roomDescriptionChanged(strDescription: strDescription, isTitle: (appDelegate.nSelectedIndex == 0) ? true : false)
        if (appDelegate.nSelectedIndex == 0)
        {
            strTitle = strDescription as String
        }
        else
        {
            strRoomDesc = strDescription as String
        }
        self.appDelegate.isStepsCompleted = false
        tblDescPlace.reloadData()
    }

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}

class CellDescripePlace: UITableViewCell
{
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblTitleDesc: UILabel?
    @IBOutlet var lblSummary: UILabel?
    @IBOutlet var lblSummaryDesc: UILabel?
    
    @IBOutlet var btnAddTitle: UIButton?
    @IBOutlet var btnAddSummary: UIButton?
}
extension UIViewController{
    var getAffine : CGAffineTransform{
        return Language.getCurrentLanguage().getAffine
    }
    
}
extension UITableViewCell{
    var getAffine : CGAffineTransform{
        return Language.getCurrentLanguage().getAffine
    }
}
