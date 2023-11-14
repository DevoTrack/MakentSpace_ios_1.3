/**
* CreateWhishList.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit

protocol createdWhisListDelegate
{
    func onCreateNewWishList(listName : String, privacy : String,listType : String)
}

class CreateWhishList : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet var tblCreateList : UITableView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var btnCreate : UIButton!

    var imgUser : UIImage!
    var strRoomID = ""
    var strRoomName = ""
    var strCurrentPrivacy = ""
    var listType = ""
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var delegate: createdWhisListDelegate?
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(strRoomName)
        strCurrentPrivacy = "Public"
        self.navigationController?.isNavigationBarHidden = true
        btnCreate.appGuestBGColor()
        btnCreate.alpha =
        
        (strRoomName.count > 0) ? 1.0 : 0.6
        self.lblName.text = self.lang.creat_List
        btnCreate.isUserInteractionEnabled = (strRoomName.count > 0) ? true : false
        self.btnCreate.setTitle(self.lang.creat_Tit, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        let letght =  textField.text?.count
        strRoomName = textField.text!
        btnCreate.isUserInteractionEnabled =  (letght! > 0) ? true :false
        btnCreate.alpha = (letght! > 0) ? 1.0 : 0.6
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    //MARK: ***** Room Detail Table view Datasource Methods *****
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (indexPath.row == 0) ? 149 : 111
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("createWishlist tableview")
        if indexPath.row == 0
        {
            print("CellCreateList")
            let cell:CellCreateList = tblCreateList.dequeueReusableCell(withIdentifier: "CellCreateList")! as! CellCreateList
            cell.txtRoomName?.placeholder = strRoomName
            cell.txtRoomName?.text = strRoomName
            cell.txtRoomName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            cell.Tit_Labl.text = self.lang.tit_Titl
            cell.Privacy_Labl.text = self.lang.privacy_Tit
            cell.txtRoomName?.becomeFirstResponder()
            return cell
        }
        else
        {
            print("CellCreatePrivacy")
            let cell:CellCreatePrivacy = tblCreateList.dequeueReusableCell(withIdentifier: "CellCreatePrivacy")! as! CellCreatePrivacy
            cell.lblTitle?.text = (indexPath.row == 1) ? lang.pub_Title : lang.pri_Title
            cell.lblDescription?.text = (indexPath.row == 1) ? "\(lang.visible_Msg) \(k_AppName.capitalized) \(lang.profi_Title)." : lang.visiblefrnd_Msg
            cell.imgPrivacy?.backgroundColor = (strCurrentPrivacy == (cell.lblTitle?.text)!) ? UIColor(red: 41.0 / 255.0, green: 151.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0) : UIColor.lightGray.withAlphaComponent(0.3)
            cell.imgPrivacy?.image = (strCurrentPrivacy == (cell.lblTitle?.text)!) ? UIImage(named:"small_tick.png") : UIImage(named:"")
            return cell
        }
    }
    
    //MARK: ---- Table View Delegate Methods ----
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row > 0
        {
            let selectedCell = tableView.cellForRow(at: indexPath) as! CellCreatePrivacy
            strCurrentPrivacy = (selectedCell.lblTitle?.text)!
            tblCreateList.reloadData()
        }
    }
    
    @IBAction func onSaveListTapped(_ sender:UIButton!)
    {
        print("onSaveListTapped")
        delegate?.onCreateNewWishList(listName : YSSupport.escapedValue(strRoomName), privacy : (strCurrentPrivacy == "Public") ? "0" : "1",listType:self.listType)
        self.onBackTapped(nil)
    }

    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CellCreateList : UITableViewCell
{
    @IBOutlet weak var Tit_Labl: UILabel!
    @IBOutlet var txtRoomName: UITextField?
    @IBOutlet weak var Privacy_Labl: UILabel!
}

class CellCreatePrivacy : UITableViewCell
{
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var imgPrivacy: UIImageView?
    
}


