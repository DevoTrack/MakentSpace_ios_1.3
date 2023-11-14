/**
 * MLImagePickerQuickView.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */



import UIKit
import PhotosUI

let MLImagePickerMenuHeight:CGFloat = 40

class MLImagePickerQuickView: UIView,
                              UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout,
                              MLImagePickerAssetsCellDelegate
{

    
    private var fetchResult:PHFetchResult<PHAsset>!
    private var imageManager:MLImagePickerAssetsManger!
    private var photoIdentifiers:Array<String> = []
    private var phImageFileUrls:Array<NSURL>! = []
    private var selectImages:Array<UIImage> = []
    private var listsImages:Array<UIImage> = []
    
    private var collectionView:UICollectionView!
    private var redTagLbl:UILabel!
    private var messageLbl:UILabel!
    private var albumContainerView:UIView!
    
    // MARK: Public
    // <MLImagePickerControllerDelegate>, SelectAssets CallBack
    var delegate:MLImagePickerControllerDelegate?
    // Selected Indentifiers Assets
    var selectIndentifiers:Array<String>! = []
    // Setting Max Multiselect Count
    var selectPickerMaxCount:Int! = 9
    // Scroll Selecte Pickers, Default is YES
    var cancleLongGestureScrollSelectedPicker:Bool! = false
    // picker list count, Default is 50
    var showListsPickerCount:Int! = 50
    // if viewControllerReponse is nil, but not open album.
    var viewControllerReponse:UIViewController?
    
    // Must realize.
    func prepareForInterfaceBuilderAndData() {
        self.setupCollectionView()
    }
    
    func setupCollectionView(){
        
        let albumContainerView:UIView = UIView(frame: CGRect(x:0, y:self.frame.height, width:self.frame.width, height:self.frame.height))
        albumContainerView.backgroundColor = UIColor.white
        self.addSubview(albumContainerView)
        self.albumContainerView = albumContainerView
        
        let menuView:UIView = UIView()
        menuView.borderColor = UIColor(red: 231/256.0, green: 231/256.0, blue: 231/256.0, alpha: 1.0)
        menuView.borderWidth = 0.5
        menuView.frame = CGRect(x:0, y:0, width:self.frame.width, height:MLImagePickerMenuHeight)
        albumContainerView.addSubview(menuView)
        
        if self.viewControllerReponse != nil {            
            let openAlbumBtn = UIButton(frame: CGRect(x:15, y:0, width:60, height:MLImagePickerMenuHeight))
            openAlbumBtn.setTitleColor(UIColor(red: 49/256.0, green: 105/256.0, blue: 245/256.0, alpha: 1.0), for: .normal)
            openAlbumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            openAlbumBtn.setTitle("打开相册", for: .normal)
            openAlbumBtn.addTarget(self, action: #selector(MLImagePickerQuickView.openAlbum), for: .touchUpInside)
            menuView.addSubview(openAlbumBtn)
        }
        
        let doneBtn = UIButton(frame: CGRect(x:self.frame.width - MLImagePickerMenuHeight - 15, y:0, width:MLImagePickerMenuHeight, height:MLImagePickerMenuHeight))
        doneBtn.setTitleColor(UIColor(red: 49/256.0, green: 105/256.0, blue: 245/256.0, alpha: 1.0), for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.addTarget(self, action: #selector(MLImagePickerQuickView.done), for: .touchUpInside)
        menuView.addSubview(doneBtn)
        
        let redTagLbl = UILabel()
        redTagLbl.isHidden = (self.selectIndentifiers.count == 0)
        redTagLbl.text = "\(self.selectIndentifiers.count)"
        redTagLbl.layer.cornerRadius = 8.0
        redTagLbl.layer.masksToBounds = true
        redTagLbl.backgroundColor = UIColor.red
        redTagLbl.textColor = UIColor.white
        
        redTagLbl.font = UIFont.systemFont(ofSize: 12)
        redTagLbl.textAlignment = .center
        redTagLbl.frame = CGRect(x:doneBtn.frame.maxX-10,y:4, width:16, height:16)
        menuView.addSubview(redTagLbl)
        self.redTagLbl = redTagLbl
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        
        let collectionView:UICollectionView = UICollectionView(frame: CGRect(x:0, y:menuView.frame.maxY, width:self.frame.width, height:self.frame.height - MLImagePickerMenuHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "MLImagePickerAssetsCell", bundle: nil), forCellWithReuseIdentifier: "MLImagePickerAssetsCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        albumContainerView.addSubview(collectionView)
        self.collectionView = collectionView
        
        self.imageManager = MLImagePickerAssetsManger()
        self.imageManager.stopCachingImagesForAllAssets()
        self.fetchResult = self.imageManager.result()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        
        let count = self.fetchResult.count > 50 ? 50 : self.fetchResult.count
        
        for i in 0 ..< count {
            let asset:PHAsset = self.fetchResult[i]
            self.photoIdentifiers.append(asset.localIdentifier)
            
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width:self.frame.height,height:self.frame.height), contentMode: .aspectFill, options: requestOptions) { (image, info) -> Void in
                self.listsImages.append(image!)
                
                if self.selectIndentifiers.contains(asset.localIdentifier) == true {
                    self.selectImages.append(image!)
                    if info![PHImageFileURLKey] != nil {
                        self.phImageFileUrls.append(info![PHImageFileURLKey] as! NSURL)
                    }
                    self.selectImages.append(image!)
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.albumContainerView.frame = self.bounds
                })
                
                self.collectionView?.reloadData()
                self.collectionView?.layoutIfNeeded()
            }
            
        }
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listsImages.count
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
        cell.imageV.image = self.listsImages[indexPath.item]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let image:UIImage = self.listsImages[indexPath.item]
        let radio:CGFloat = image.size.height / collectionView.frame.height
        
        return CGSize(width: image.size.width / radio, height: collectionView.frame.height)
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
                self.phImageFileUrls.remove(at: index!)
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
        
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width:100,height:100), contentMode: .aspectFill, options: requestOptions) { (image, info) -> Void in
            if image != nil {
                self.selectImages.append(image!)
                if info![PHImageFileURLKey] != nil {
                    self.phImageFileUrls.append(info!["PHImageFileURLKey"] as! NSURL)
                }
                self.redTagLbl.isHidden = (self.selectIndentifiers.count == 0)
                self.redTagLbl.text = "\(self.selectIndentifiers.count)"
            }
        }
        
        return true
    }
    
    private func checkBeyondMaxSelectPickerCount()->Bool{
        if (self.selectIndentifiers.count >= self.selectPickerMaxCount) {
            self.showWatting(str: "选择照片不能超过\(self.selectPickerMaxCount!)张")
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.hideWatting()
            })
            return false
        }
        return true
    }
    
    @objc func done(){
        if self.delegate != nil{
            self.delegate?.imagePickerDidSelectedAssets(assets: self.selectImages, assetIdentifiers: self.selectIndentifiers, phImageFileUrls: self.phImageFileUrls)
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.albumContainerView.frame = CGRect(x:0, y:self.frame.height, width:self.albumContainerView.frame.width, height:self.albumContainerView.frame.height)
            }) { ( flag:Bool) -> Void in
            self.removeFromSuperview()
        }
    }
    
    @objc func openAlbum(){
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.albumContainerView.frame = CGRect(x:0, y:self.frame.height, width:self.albumContainerView.frame.width, height:self.albumContainerView.frame.height)
            }) { ( flag:Bool) -> Void in
                self.removeFromSuperview()
        }
        
        let pickerVc = MLImagePickerController()
        // 回调
        pickerVc.delegate = self.delegate
        // 最大图片个数
        pickerVc.selectPickerMaxCount = 20
        // 默认记录选择的图片
        pickerVc.selectIndentifiers = self.selectIndentifiers
        pickerVc.show(vc: self.viewControllerReponse!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.albumContainerView == nil{
            self.setupCollectionView()
        }
    }
}
