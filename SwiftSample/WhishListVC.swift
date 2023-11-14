/**
* WhishListVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class WhishListVC : UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,WhishListDetailDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var loginView: UIView!
    @IBOutlet var collectionRent: UICollectionView!
    @IBOutlet var viewBtnHolder: UIView!
    @IBOutlet var tblTemp: UITableView!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var viewNoWishlist: UIView!

    @IBOutlet weak var nowish_Msg: UILabel!
    @IBOutlet weak var nowish_Lbl: UILabel!
    @IBOutlet weak var login_Btn: UIButton!
    @IBOutlet weak var collectmsg_Lbl: UILabel!
    @IBOutlet weak var find_Home: UIButton!
    // For API Calls
    var nPageNumber : Int = 1
    var isDataFinishedFromServer : Bool = false
    var isApiCalling : Bool = false
    var arrWishListData : NSMutableArray = NSMutableArray()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var token = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var saved_Title: UILabel!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Wishlist page view controller")
       
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        tblTemp.isHidden = true
        viewBtnHolder.isHidden = true
        viewNoWishlist.isHidden = true
        self.saved_Title.text = self.lang.save_Title
        self.saved_Title.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.login_Btn.setTitle(lang.login_Title, for: .normal)
        self.login_Btn.appGuestTextColor()
        self.login_Btn.borderColor = UIColor.appGuestThemeColor
        self.login_Btn.borderWidth = 1
        self.find_Home.appHostSideBtnBG()
        self.collectmsg_Lbl.text = lang.notlog_WishMsg
        self.collectmsg_Lbl.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.find_Home.setTitle(lang.find_HomeTit, for: .normal)
        self.nowish_Lbl.text = lang.nowish_Tit
        self.nowish_Lbl.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.nowish_Msg.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.nowish_Msg.text = lang.nowish_Msg
        let rect = UIScreen.main.bounds as CGRect
        var rectStartBtn = viewBtnHolder.frame
        rectStartBtn.origin.y = rect.size.height-viewBtnHolder.frame.size.height-70
        viewBtnHolder.frame = rectStartBtn
        var rectcollectionRent = collectionRent.frame
        rectcollectionRent.size.height = rect.size.height-50
        collectionRent.frame = rectcollectionRent
        if token != ""
        {
            loginView.isHidden = true
            self.view.removeAddedSubview(view: loginView)
            setWishListData()
            NotificationCenter.default.addObserver(self, selector: #selector(self.setWishListData), name: NSNotification.Name(rawValue: "RoomAddedInWhishlist"), object: nil)
        }
        else
        {
            loginView.isHidden = false
            self.view.addCenterView(centerView: loginView)
        }
    }
    @IBAction func goToLoginAction(_ sender: Any) {
        let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainPage.hidesBottomBarWhenPushed = true
        
        appDelegate.lastPageMaintain = "saved"
//        self.navigationController?.pushViewController(mainPage, animated: false)
        let naviation = UINavigationController(rootViewController: mainPage)
        self.present(naviation, animated: true, completion: nil)
    }
    @objc func setWishListData()
    {
        print("Set Wishlist")
        arrWishListData = self.appDelegate.arrWishListData
        if arrWishListData.count == 0
        {
            print("arrWishListData greater than zero")
            callAPIForGettingWishList()
        }
        else
        {
            print("arrWishListData zero")
            self.viewNoWishlist.isHidden = true
            self.viewBtnHolder.isHidden = true
            collectionRent.isHidden = false
            collectionRent.reloadData()
        }
    }
    // MARK: EXPLORE API CALL
    /*
       Here Getting Room List Details like -> Room Name, Room Thumb Image, Room id, Price
     */
    func callAPIForGettingWishList()
    {
        self.animatedLoader?.isHidden = false
        MakentSupport().setDotLoader(animatedLoader: animatedLoader!)
        var dicts = [AnyHashable: Any]()
        dicts["token"]   = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_GET_WISHLIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1"
                {
                    self.arrWishListData.removeAllObjects()
                    if gModel.arrTemp1.count > 0
                    {
                        self.arrWishListData.addObjects(from: (gModel.arrTemp1 as NSArray) as! [Any])
                        
                        self.appDelegate.arrWishListData = NSMutableArray()
                        self.appDelegate.arrWishListData = self.arrWishListData
                    }
                    else
                    {
                        self.appDelegate.arrWishListData = NSMutableArray()
                        self.appDelegate.arrWishListData = self.arrWishListData
                    }
                    if self.arrWishListData.count == 0
                    {
                        let userDefaults = UserDefaults.standard
                        
                        let getMainPage = userDefaults.object(forKey: "getmainpage") as! String
                        
                        if(getMainPage == "guest")
                        {
                            self.viewBtnHolder.isHidden = false
                        }
                        else
                        {
                            self.viewBtnHolder.isHidden = true
                        }
                        self.viewNoWishlist.isHidden = false
                        self.collectionRent.isHidden = true
                        //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeallwhishlist"), object: self, userInfo: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removesingleroomfromwhishlist"), object: self, userInfo: nil)
                    }
                    else
                    {
                        self.viewNoWishlist.isHidden = true
                        self.viewBtnHolder.isHidden = true
                        self.collectionRent.isHidden = false
                        self.view.removeAddedSubview(view: self.viewNoWishlist)
                    }
                }
                else
                {
                    if gModel.success_message == "token_invalid" || gModel.success_message == "user_not_found" || gModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removesingleroomfromwhishlist"), object: self, userInfo: nil)
                    self.arrWishListData.removeAllObjects()
                    
                    if self.token != "" {
                        //            loginView.isHidden = true
                        self.viewNoWishlist.isHidden = false
                        self.view.addCenterView(centerView: self.viewNoWishlist)
                    }
                    else{
                        self.loginView.isHidden = false
                        self.view.addCenterView(centerView: self.loginView)
                    }
                    
                    
                }
                self.collectionRent.reloadData()
                self.animatedLoader?.isHidden = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        callAPIForGettingWishList()
        self.navigationController?.navigationBar.isHidden = false
        self.addBackButton()
        self.appDelegate.makentTabBarCtrler.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onFindHomesTapped(sender:UIButton)
    {
        let userDefaults = UserDefaults.standard
        
        let getMainPage = userDefaults.object(forKey: "getmainpage") as! String
        
        if(getMainPage == "guest")
        {
            self.appDelegate.makentTabBarCtrler.selectedIndex = 0
        }
        else
        {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
        
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "ExploreHeaderView",for: indexPath) as! ExploreHeaderView
           headerView.saved_Title.text = self.lang.save_Title
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return arrWishListData.count
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionRent.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CustomRentCell
        let modelWishList = arrWishListData[indexPath.row] as? WishListModel
        cell.displayWishListName(modelWishList!)

        if (modelWishList?.arrListRooms?.count)! > 0
        {
            cell.viewMoreImgs?.isHidden = true
//            cell.imageView?.sd_setImage(with: NSURL(string: modelWishList?.arrListRooms?[0] as! String) as URL?, placeholderImage:UIImage(named:""))
            cell.imageView?.addRemoteImage(imageURL: modelWishList?.arrListRooms?[0] as? String ?? "", placeHolderURL: "", isRound: false)
            if (modelWishList?.arrListRooms?.count)! > 2
            {
                cell.viewMoreImgs?.isHidden = false
                
                cell.imgRoomOne?.addRemoteImage(imageURL: modelWishList?.arrListRooms?[1] as? String ?? "", placeHolderURL: "", isRound: false)
//                cell.imgRoomOne?.sd_setImage(with: NSURL(string: modelWishList?.arrListRooms?[1] as! String) as URL?, placeholderImage:UIImage(named:""))
                cell.imgRoomTwo?.addRemoteImage(imageURL: modelWishList?.arrListRooms?[2] as? String ?? "", placeHolderURL: "", isRound: false)
//                cell.imgRoomTwo?.sd_setImage(with: NSURL(string: modelWishList?.arrListRooms?[2] as! String) as URL?, placeholderImage:UIImage(named:""))
            }
        }
        else
        {
            cell.viewMoreImgs?.isHidden = true
            cell.imageView?.image = UIImage(named: "")
        }
        
        cell.setExploreData(ratingCount : "0") // Managing Frame height
        return cell
    }

    // MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let modelWishList = arrWishListData[indexPath.row] as? WishListModel
//        let roomDetailView = self.storyboard?.instantiateViewController(withIdentifier: "WhishListDetailsVC") as! WhishListDetailsVC
        let roomDetailView = StoryBoard.account.instance.instantiateViewController(withIdentifier: "WhishListDetailsVC") as! WhishListDetailsVC
        roomDetailView.strListName =  modelWishList?.list_name.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)! ?? ""
        roomDetailView.strListId = (modelWishList?.list_id as String?)!
        roomDetailView.strListPrivacy = (modelWishList?.privacy as String?)!
        roomDetailView.delegate = self
        
        self.navigationController?.pushViewController(roomDetailView, animated: true)
    }
    
    internal func wishListChanged()
    {
        callAPIForGettingWishList()
        if self.arrWishListData.count > 0
        {
            self.arrWishListData.removeAllObjects()
        }
        collectionRent.reloadData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
    }
    
    func shallMoveToNextPage() -> Bool {
        let yOffset: CGFloat = collectionRent.contentOffset.y
        let height: CGFloat = collectionRent.contentSize.height - collectionRent.frame.height
        return yOffset / height > 0.89
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
    }
    
    internal func onAddWhisListTapped(index:Int)
    {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
