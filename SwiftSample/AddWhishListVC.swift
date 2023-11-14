/**
 * AddWhishListVC.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social
import MapKit

protocol addWhisListDelegate
{
    func onAddWhisListTapped(index:Int)
}

class AddWhishListVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, createdWhisListDelegate, ViewOfflineDelegate
{
    @IBOutlet var viewListHolder : UIView!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var btnCreateWhisList : UIButton!
    @IBOutlet var lblRoomCount : UILabel!
    @IBOutlet weak var collectionWhisList : UICollectionView!
    
    @IBOutlet weak var plusBtn: UIButton!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var arrWishListData : NSMutableArray = NSMutableArray()
    var delegate: addWhisListDelegate?
    var aboutOpened:Bool = false
    
    var strRoomName = ""
    var strRoomID = ""
    var listType = ""

    @IBOutlet weak var chooselist_Title: UILabel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Choose the list for create wishlist")
        self.plusBtn.appGuestTextColor()
        self.chooselist_Title.text = self.lang.chs_Tit
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrWishListData.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapRoomCell", for: indexPath as IndexPath) as! MapRoomCell
        let modelWishList = arrWishListData[indexPath.row] as? WishListModel
        cell.setWishListData(modelWishList: modelWishList!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let modelWishList = arrWishListData[indexPath.row] as? WishListModel
        self.makeWishList(listId : modelWishList?.list_id as! String, listName : "", privacy : modelWishList?.privacy as! String,listType: self.listType)
    }
    
    func makeWishList(listId : String, listName : String, privacy : String,listType : String)
    {
        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        //dicts["room_id"]   = strRoomID
        dicts["space_id"]   = strRoomID
        if listId.count > 0
        {
            dicts["list_id"]   = listId
        }
        if listName.count > 0
        {
            dicts["list_name"]   = listName.replacingOccurrences(of: "%20", with: " ")
        }
        dicts["list_type"]   = listType
        dicts["privacy_settings"]   = privacy
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_ADD_TO_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    SharedVariables.sharedInstance.lastWhistListRoomId = (self.strRoomID as NSString).integerValue
                    self.delegate?.onAddWhisListTapped(index: 1)
                    self.onBackTapped(nil)
                }
                else
                {
                    _ = MakentSupport().checkNetworkIssue(self, errorMsg: gModel.success_message as String)
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                MakentSupport().removeProgressInWindow(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                MakentSupport().removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnBack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    // MARK: When User Click Create Button
    @IBAction func onCreateListTapped(_ sender:UIButton!)
    {
        print("on Plus button Clicked")
        let viewCreateList = StoryBoard.account.instance.instantiateViewController(withIdentifier: "CreateWhishList") as! CreateWhishList
        viewCreateList.strRoomName = strRoomName
        viewCreateList.strRoomID = strRoomID
        viewCreateList.delegate = self
        viewCreateList.listType = listType
        present(viewCreateList, animated: true, completion: nil)
    }
    
    //MARK: CREATE NEW WISHLIST DELEGATE METHOD
    internal func onCreateNewWishList(listName : String, privacy : String,listType : String)
    {
       self.makeWishList(listId : "", listName : listName, privacy : privacy,listType : listType)
    }

    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        btnBack.backgroundColor = UIColor.clear
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

