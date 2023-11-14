/**
 * MLImagePickerController.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */


import UIKit
import Photos

protocol MLImagePickerControllerDelegate {
    func imagePickerDidSelectedAssets(assets:Array<UIImage>, assetIdentifiers:Array<String>, phImageFileUrls:Array<NSURL>)
}

let PHImageFileURLKey = "PHImageFileURLKey"
let MLImagePickerUIScreenScale = UIScreen.main.scale
private let MLImagePickerCellMargin:CGFloat = 2
private let MLImagePickerCellRowCount:CGFloat = 4
private let MLImagePickerMaxCount:Int = 9
private let MLImagePickerCellWidth = (UIScreen.main.bounds.size.width - MLImagePickerCellMargin * (MLImagePickerCellRowCount + 1)) / MLImagePickerCellRowCount

class MLImagePickerController:  UIViewController,
                                UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                MLImagePickerAssetsCellDelegate,
                                UITableViewDataSource,
                                UITableViewDelegate
{
    
    private var fetchResult:PHFetchResult<PHAsset>!
    private var selectImages:Array<UIImage>! = []
    private var photoIdentifiers:Array<String>! = []
    private var phImageFileUrls:Array<NSURL>! = []
    private var groupSectionFetchResults:Array<PHFetchResult<PHAsset>>! = []
    private var AssetGridThumbnailSize:CGSize!
    private var imageManager:MLImagePickerAssetsManger!
    private var tableViewSelectedIndexPath:IndexPath! = IndexPath(row: 0, section: 0)
    
    private var collectionView:UICollectionView?
    private var navigationItemRightBtn:UIButton!
    private var groupTableContainerView:UIView?
    private var groupTableView:UITableView?
    private var messageLbl:UILabel!
    private var redTagLbl:UILabel!
    private var titleBtn:UIButton!
    
    // <MLImagePickerControllerDelegate>, SelectAssets CallBack
    var delegate:MLImagePickerControllerDelegate?
    // Selected Indentifiers Assets
    var selectIndentifiers:Array<String> = []
    // Setting Max Multiselect Count
    var selectPickerMaxCount:Int! = 9
    // Scroll Selecte Pickers, Default is YES
    var cancleLongGestureScrollSelectedPicker:Bool! = false
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func show(vc:UIViewController!){
        let imagePickerVc = MLImagePickerController()
        imagePickerVc.delegate = self.delegate
        imagePickerVc.selectIndentifiers = selectIndentifiers
        imagePickerVc.selectPickerMaxCount = self.selectPickerMaxCount == nil ? MLImagePickerMaxCount : self.selectPickerMaxCount
        
        let navigationVc = UINavigationController(rootViewController: imagePickerVc)
        vc.present(navigationVc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.setupNavigationBar()
        self.setupCollectionView()
        self.initialization();
    }
    
    private func initialization(){
        
        self.imageManager = MLImagePickerAssetsManger()
        self.fetchResult = self.imageManager.result()

        AssetGridThumbnailSize = CGSize(width:MLImagePickerCellWidth * MLImagePickerUIScreenScale, height:MLImagePickerCellWidth * MLImagePickerUIScreenScale)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        for i in 0 ..< self.fetchResult.count {
            let asset:PHAsset = self.fetchResult[i]
            self.photoIdentifiers.append(asset.localIdentifier)

            if self.selectIndentifiers.contains(asset.localIdentifier) == true {
                self.imageManager.requestImage(for: asset, targetSize: AssetGridThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in Void()
                    if info![PHImageFileURLKey] != nil {
                        self.phImageFileUrls.append(info![PHImageFileURLKey] as! NSURL)
                    }
                    self.selectImages.append(image!)
                })
            }
        }
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        if self.cancleLongGestureScrollSelectedPicker == false {
            self.collectionView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: Selector(("longPressGestureScrollPhoto:"))))
        }
    }
    
    private func setupNavigationBar(){
        let titleBtn = UIButton(type: .custom)
        titleBtn.frame = CGRect(x:0, y:0, width:200, height:44)
        titleBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        titleBtn.setTitleColor(UIColor.gray, for: .normal)
        titleBtn.setTitle(lang.allphoto_Title, for: .normal)
        titleBtn.addTarget(self, action: #selector(MLImagePickerController.tappenTitleView), for: .touchUpInside)

        titleBtn.setImage(UIImage.ml_imageFromBundleNamed(named: "zl_xialajiantou"), for: .normal)
        self.navigationItem.titleView = titleBtn
        self.titleBtn = titleBtn
        
        
        let navigationItemLeftBtn = UIButton(type: .custom)
        navigationItemLeftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        navigationItemLeftBtn.frame = CGRect(x:0, y:0, width:60, height:44)
        navigationItemLeftBtn.setTitle(lang.back_Title, for: .normal)
        
        navigationItemLeftBtn.setTitleColor(UIColor(red: 49/256.0, green: 105/256.0, blue: 245/256.0, alpha: 1.0), for: .normal)
        
        navigationItemLeftBtn.addTarget(self, action: #selector(MLImagePickerController.back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationItemLeftBtn)
        self.navigationItemRightBtn = navigationItemLeftBtn

        
        let navigationItemRightBtn = UIButton(type: .custom)
        navigationItemRightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        navigationItemRightBtn.frame = CGRect(x:0, y:0, width:30, height:44)
        navigationItemRightBtn.setTitle(lang.add_Title, for: .normal)
        
        navigationItemRightBtn.setTitleColor(UIColor(red: 49/256.0, green: 105/256.0, blue: 245/256.0, alpha: 1.0), for: .normal)
        
        navigationItemRightBtn.addTarget(self, action: #selector(MLImagePickerController.done), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationItemRightBtn)
        self.navigationItemRightBtn = navigationItemRightBtn
        
        let redTagLbl = UILabel()
        redTagLbl.isHidden = (self.selectIndentifiers.count == 0)
        redTagLbl.text = "\(self.selectIndentifiers.count)"
        redTagLbl.layer.cornerRadius = 8.0
        redTagLbl.layer.masksToBounds = true
        redTagLbl.backgroundColor = UIColor.red
        redTagLbl.textColor = UIColor.white
        redTagLbl.font = UIFont.systemFont(ofSize: 12)
        redTagLbl.textAlignment = .center
        redTagLbl.frame = CGRect(x:navigationItemRightBtn.frame.width-8,y:0, width:16, height:16)
        navigationItemRightBtn.addSubview(redTagLbl)
        self.redTagLbl = redTagLbl
    }
    
    @objc func done(){
        if self.delegate != nil{
            self.delegate?.imagePickerDidSelectedAssets(assets: self.selectImages, assetIdentifiers: self.selectIndentifiers, phImageFileUrls: self.phImageFileUrls)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupCollectionView(){
        let width = (self.view.frame.size.width - MLImagePickerCellMargin * MLImagePickerCellRowCount + 1) / MLImagePickerCellRowCount;
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 2
        collectionViewFlowLayout.itemSize = CGSize(width:width, height:width)
        
        let assetsCollectionView = UICollectionView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height), collectionViewLayout: collectionViewFlowLayout)
        assetsCollectionView.register(UINib(nibName: "MLImagePickerAssetsCell", bundle: nil), forCellWithReuseIdentifier: "MLImagePickerAssetsCell")
        assetsCollectionView.backgroundColor = UIColor.clear
        assetsCollectionView.dataSource = self
        assetsCollectionView.delegate = self
        self.view.addSubview(assetsCollectionView)
        self.collectionView = assetsCollectionView
    }
    
    @objc func setupGroupTableView(){
        if (self.groupTableContainerView != nil){
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.groupTableContainerView?.alpha = (self.groupTableContainerView?.alpha == 1.0) ? 0.0 : 1.0
            })
            
        }else{
            let groupTableContainerView = UIView(frame: self.view.bounds)
            groupTableContainerView.alpha = 0.0
            groupTableContainerView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            self.view.addSubview(groupTableContainerView)
            self.groupTableContainerView = groupTableContainerView
            
            let groupTableView = UITableView(frame: CGRect(x:0, y:64, width:self.view.frame.width, height:300), style: .plain)
            groupTableView.register(UINib(nibName: "MLImagePickerGroupCell", bundle: nil), forCellReuseIdentifier: "MLImagePickerGroupCell")
            groupTableView.separatorStyle = .none
            groupTableView.dataSource = self
            groupTableView.delegate = self
            self.groupTableContainerView!.addSubview(groupTableView)
            self.groupTableView = groupTableView
            
            let groupBackgroundView = UIView(frame: CGRect(x:0, y:groupTableView.frame.maxY, width:groupTableContainerView.frame.width, height:groupTableContainerView.frame.height - groupTableView.frame.maxY))
            groupBackgroundView.backgroundColor = UIColor.clear
            groupBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MLImagePickerController.setupGroupTableView)))
            self.groupTableContainerView!.addSubview(groupBackgroundView)
            
            let options:PHFetchOptions = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
//            allPhotosOptions.predicate = (_isMediaTypeImage)?[NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage]:[NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];

            let allPhotos:PHFetchResult = PHAsset.fetchAssets(with: options)
            let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            let userCollections:PHFetchResult = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.groupSectionFetchResults = [allPhotos, smartAlbums as! PHFetchResult<PHAsset>, userCollections as! PHFetchResult<PHAsset>]
            
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.groupTableContainerView?.alpha = (self.groupTableContainerView?.alpha == 1.0) ? 0.0 : 1.0
            })
        }
    }
    
    @objc func tappenTitleView(){
        self.setupGroupTableView()
    }
    
    // MARK: UICollectionViewDataSource && UICollectionViewDelegate
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.fetchResult.count > 0) ? self.fetchResult.count : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MLImagePickerAssetsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MLImagePickerAssetsCell", for: indexPath as IndexPath) as! MLImagePickerAssetsCell
        
        let asset:PHAsset = self.fetchResult[indexPath.item]
        
        cell.delegate = self
        cell.asset = asset
        cell.indexPath = indexPath
        cell.localIdentifier = self.photoIdentifiers[indexPath.item]
        cell.selectButtonSelected = self.selectIndentifiers.contains(cell.localIdentifier)
        cell.isShowVideo = (asset.mediaType == .video)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .fastFormat
        requestOptions.isNetworkAccessAllowed = true
        
        self.imageManager.requestImage(for: asset, targetSize: AssetGridThumbnailSize, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
            // Set the cell's thumbnail image if it's still showing the same asset.
            if (cell.localIdentifier == asset.localIdentifier) {
                cell.imageV.image = image;
            }
        }
        
        return cell
    }
    
    // MARK: UITableViewDataSource && UITableViewDelegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.groupSectionFetchResults.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let result:PHFetchResult = self.groupSectionFetchResults[section]
            return result.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fetchResult:PHFetchResult = self.groupSectionFetchResults[indexPath.section]
        
        let cell:MLImagePickerGroupCell = tableView.dequeueReusableCell(withIdentifier: "MLImagePickerGroupCell") as! MLImagePickerGroupCell
        if indexPath.section == 0 {
            cell.titleLbl.text = self.lang.allphoto_Title
            cell.assetCountLbl.text = "\(fetchResult.count)"
        }else{
            let collection:PHAssetCollection = fetchResult[indexPath.row] as! PHAssetCollection
            let result:PHFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
            cell.titleLbl.text = collection.localizedTitle
            cell.assetCountLbl.text = "\(result.count)"
        }
        
        cell.selectedStatus = (self.tableViewSelectedIndexPath.section == indexPath.section && self.tableViewSelectedIndexPath.row == indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableViewSelectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.setupGroupTableView()
        self.photoIdentifiers.removeAll()
        
        let cell:MLImagePickerGroupCell = tableView.cellForRow(at: indexPath as IndexPath) as! MLImagePickerGroupCell
        self.titleBtn.setTitle(cell.titleLbl.text, for: .normal)
        
        var fetchResult:PHFetchResult = self.groupSectionFetchResults[indexPath.section] 
        
        if indexPath.section != 0 {
            let collection:PHAssetCollection = fetchResult[indexPath.row] as! PHAssetCollection
            fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
        }
        self.fetchResult = fetchResult
        
        for index in 0..<fetchResult.count {
            let asset:PHAsset = fetchResult[index]
            self.photoIdentifiers.append(asset.localIdentifier)
        }
        
        for index in 0..<fetchResult.count {
            let asset:PHAsset = fetchResult[index]
            self.photoIdentifiers.append(asset.localIdentifier)
        }
        self.groupTableView?.reloadData()
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: MLImagePickerAssetsCellDelegate
    func imagePickerSelectAssetsCellWithSelected(indexPath: IndexPath, selected: Bool) -> Bool {
        let identifier = self.photoIdentifiers[indexPath.item]
        let asset:PHAsset = self.fetchResult[indexPath.item]
        
        if selected == true {
            if (self.checkBeyondMaxSelectPickerCount() == false){
                return false
            }
            if self.selectIndentifiers.contains(identifier) == false {
                // Insert
                self.selectIndentifiers.append(identifier)
            }else{
                return false;
            }
        }else{
            // Delete
            if selectIndentifiers.contains(identifier) {
                let index = self.selectIndentifiers.index(of: identifier)
//                self.phImageFileUrls.remove(at: index!)
                self.selectImages.remove(at: index!)
            }
            
            let identifierIndex = self.selectIndentifiers.index(of: identifier)
            self.selectIndentifiers.remove(at: identifierIndex!)
            
            self.redTagLbl.isHidden = (self.selectIndentifiers.count == 0)
            self.redTagLbl.text = "\(self.selectIndentifiers.count)"
            
            return true
        }
    
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        self.imageManager.requestImage(for: asset, targetSize: AssetGridThumbnailSize, contentMode: .aspectFill, options: requestOptions) { ( image, info) -> Void in
            if image != nil {
                self.selectImages.append(image!)
                if info![PHImageFileURLKey] != nil {
                    self.phImageFileUrls.append(info![PHImageFileURLKey] as! NSURL)
                }
                self.redTagLbl.isHidden = (self.selectIndentifiers.count == 0)
                self.redTagLbl.text = "\(self.selectIndentifiers.count)"
            }
        }
        
        return true
    }
    
    private func checkBeyondMaxSelectPickerCount()->Bool{
        if (self.selectIndentifiers.count >= self.selectPickerMaxCount) {
            self.view.showWatting(str: "\(self.lang.photoexeed_Title)\(self.selectPickerMaxCount!)")
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.view.hideWatting()
            })
            return false
        }
        return true
    }
    
    // MARK: GestureRecognizer
    func longPressGestureScrollPhoto(gesture:UILongPressGestureRecognizer){
        let point = gesture.location(in: self.collectionView)
        let cells = self.collectionView!.visibleCells as! Array<MLImagePickerAssetsCell>
        
        for i in 0 ..< cells.count {
            let cell:MLImagePickerAssetsCell = cells[i]
            if ((cell.frame.maxY > point.y && cell.frame.maxY - point.y <= cell.frame.height) == true &&
                (cell.frame.maxX > point.x && cell.frame.maxX - point.x <= cell.frame.width)
                ) == true {
                    let indexPath = self.collectionView?.indexPath(for: cell)
                    
                    if (self.checkBeyondMaxSelectPickerCount() == false){
                        return
                    }
                    cell.selectButtonSelected = true
                    self.imagePickerSelectAssetsCellWithSelected(indexPath: indexPath!, selected: true)
            }
        }
    }
}
