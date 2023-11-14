//
//  HomeTCell.swift
//  Makent
//
//  Created by trioangle on 31/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
//#Mark Home Content TableView Cell

class HomeTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet fileprivate weak var _titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var homeProductCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showAllButtonOutlet: UIButton!
    @IBOutlet weak var showAllButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelBottomMarginHeight: NSLayoutConstraint!
    
    //PinterestLayoutDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var titleLabelText : String{
        get{
            return self._titleLabel.text ?? ""
        }
        set{
            self._titleLabel.text = newValue
            if newValue.isEmpty{
                self.titleLabelHeight.constant = 0
                self.titleLabelBottomMarginHeight.constant = 0
            }else{
                self.titleLabelHeight.constant = 23.5
                self.titleLabelBottomMarginHeight.constant = 10
            }
        }
    }
    
    var appDelegate = AppDelegate()
    var indexValue = Int()
    
    var exploreListDictArray = [Detail](){
        didSet{
            self.homeProductCollectionView.reloadData()
        }
    }
    
    
    var detail = [List]()
    
    var delegate:ShowDetailDelegate?
    
    var isPreparing : Bool = true
    
    var collectionViewObserver: NSKeyValueObservation?
    
    var height : CGFloat = 0.0
    
    var width : CGFloat = 0.0
    
    var roomImage = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeProductCollectionView.delegate = self
        homeProductCollectionView.dataSource = self
        self.showAllButtonOutlet.appGuestTextColor()
        //contentSize.height
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionViewHeightConstraint.constant = self.homeProductCollectionView.collectionViewLayout.collectionViewContentSize.height
        print("$$$$ reuse height: ", self.collectionViewHeightConstraint.constant)
    }
    
    func addObserver() {
        collectionViewObserver = homeProductCollectionView.observe(\.contentSize, changeHandler: { [weak self] (collectionView, change) in
            self?.homeProductCollectionView.invalidateIntrinsicContentSize()
            self?.collectionViewHeightConstraint.constant = collectionView.contentSize.height + 10
            //            let tempArray = self?.exploreListDictArray.count ?? 0
            //            if tempArray > 0 {
            //                if tempArray > 3 {
            //
            //                }else {
            //                     self?.collectionViewHeightConstraint.constant = 226
            //                }
            //            }
            
            //            self?.homeProductCollectionView.setNeedsLayout()
            self?.layoutIfNeeded()
        })
    }
    
    deinit {
        collectionViewObserver = nil
    }
    
    
    
    
    
    
    //MARK: - HOME ALL, SHOW ALL && EXPERIENCE COLLECTION VIEW
    // MARK: - CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return exploreListDictArray.count
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.reloadInputViews()
        }
        if exploreListDictArray.count > 0 {
            
            return exploreListDictArray.count
            
        }else{return 0}
        
    }
    
    
    //Mark :- Data Showing For Home and Experience CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeExploreListCVC", for: indexPath) as! HomeExploreListCVC
        
        let exploreDict = exploreListDictArray[indexPath.row]
       

        cell.exploreSubTitleLabel.text = exploreDict.name //exploreDict.getDisplayRoomName
        cell.exploreImageView.addRemoteImage(imageURL: exploreDict.photoName, placeHolderURL: "")
        //sd_setImage(with: NSURL(string: exploreDict.photoName)! as URL, placeholderImage:UIImage(named:""))
//        roomImage.contentMode = .scaleToFill
//        roomImage = cell.exploreImageView
////        roomImage.frame = CGRect(x: 0, y: 0, width: roomImage.frame.width, height: roomImage.frame.height)
//        cell.exploreImageView.roundCorners(corners: [.topRight], radius:10)
        cell.exploreImageView.cornerRadius = 75
        if Language.getCurrentLanguage().isRTL {
            cell.exploreImageView.layer.maskedCorners = [.layerMinXMinYCorner]
        } else {
            cell.exploreImageView.layer.maskedCorners = [.layerMaxXMinYCorner]
        }
        
        cell.backgroundColor = .lightGray.withAlphaComponent(0.5)
        let types = exploreDict.type
        
        cell.explorePriceLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        print("\(Utilities.sharedInstance.getCurrencySymbolFromCountryCode(code: exploreDict.currencyCode))")
        if types == "Rooms" {
            print("This is from room")
            if (exploreDict.bedCount > 0){
                if (exploreDict.bedCount == 1){
                   cell.exploreTitleLabel.text = "\(exploreDict.categoryName) • " + exploreDict.bedCount.description + " \(self.lang.bedd_Title)"
                }else{
                cell.exploreTitleLabel.text = "\(exploreDict.categoryName) • " + exploreDict.bedCount.description + " \(self.lang.capbed_Title)"
                }
            }else{
                cell.exploreTitleLabel.text = "\(exploreDict.categoryName) • \(exploreDict.countryName)"
            }
            cell.exploreTitleLabel.textColor = Utilities.sharedInstance.randomColor(seed: cell.exploreTitleLabel.text ?? "")
             if (exploreDict.instantBook) == "No" {
            cell.explorePriceLabel.text = "\(exploreDict.currencySymbol) \(exploreDict.price ) \(self.lang.pernight_Title)"
                
             } else {
                 cell.explorePriceLabel.attributedText = Utilities.attributeForInstantBook(normalText: "\(exploreDict.currencySymbol) \(exploreDict.price ) \(self.lang.pernight_Title)" , boldText: "", fontSize: 15.0)
                
            }
            
        }else{
          
            cell.exploreTitleLabel.text = "\(exploreDict.spaceType) • \(exploreDict.size) \(exploreDict.sizeType)"
            
            cell.exploreTitleLabel.textColor = Utilities.sharedInstance.staticColours()
           
            if (exploreDict.instantBook) == "No" {
                cell.explorePriceLabel.text = "\(exploreDict.currencySymbol) \(exploreDict.hourly ) \(self.lang.per_Hours)"
                
            } else {
                cell.explorePriceLabel.attributedText = Utilities.attributeForInstantBook(normalText: "\(exploreDict.currencySymbol) \(exploreDict.hourly) \(self.lang.per_Hours)" , boldText: "", fontSize: 11.0)
                
            }

        }
        
        if (exploreDict.rating as NSString).intValue > 0 {
            cell.ratingStackV.isHidden = false
            //"\(exploreDict.rating)"
           
            cell.exploreRatingLabel.text =  MakentSupport().createRatingStar(ratingValue: exploreDict.rating as NSString) as String
//                Utilities.sharedInstance.setRatingImage(rating: (exploreDict.rating as NSString).floatValue).withRenderingMode(.alwaysTemplate)
            cell.exploreRatingLabel.textColor = UIColor.appGuestThemeColor
            cell.exploreRatingCountLabel.text = "\(exploreDict.reviewsCount)"
            
        }
        else {
             cell.exploreRatingLabel.text = ""
            cell.exploreRatingCountLabel.text = ""
            cell.ratingStackV.isHidden = true
            
        }
        
        
//        cell.layer.cornerRadius = 3.0
        if "\(String(describing: exploreDict.isWishlist))" == "Yes" {
            cell.whishListButtonOutlet.setImage(UIImage(named: "heart_selected"), for: .normal)
        }
        else {
            cell.whishListButtonOutlet.setImage(UIImage(named: "heart_normal"), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exploreDict = exploreListDictArray[indexPath.row]
        if SharedVariables.sharedInstance.homeType == HomeType.home {
            exploreDict.type = "Rooms"
        }
        else if SharedVariables.sharedInstance.homeType == HomeType.experiance || SharedVariables.sharedInstance.homeType == HomeType.experianceCategory(ExploreCat(JSONS())) {
            exploreDict.type = "Experiences"
        }
        delegate?.didSelectDetailPage(detailDict: exploreDict)
    }
    
    //MARK: - HomeExploreListCVC CollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var currentText = ""
        var siblingText = ""
        var isCurrentItemRatingApplied = false
        var isSiblingItemRatingApplied = false

        if let item = exploreListDictArray.value(atSafeIndex: indexPath.item){
            currentText = item.name
            isCurrentItemRatingApplied = item.reviewsCount != 0
        }
        if indexPath.item % 2 == 0{//item is left
            if let rightSiblingItem = exploreListDictArray.value(atSafeIndex: indexPath.item + 1){
                siblingText = rightSiblingItem.name
                isSiblingItemRatingApplied = rightSiblingItem.reviewsCount != 0
            }
        }else{//item is right
            if let leftSiblingItem = exploreListDictArray.value(atSafeIndex: indexPath.item - 1){
                siblingText = leftSiblingItem.name
                isSiblingItemRatingApplied = leftSiblingItem.reviewsCount != 0
            }
        }
        //let customWidth = (collectionView.frame.width / 2.0) - 5
        let customWidth = (collectionView.frame.width / 1.0) - 10
        //height calculation
        let customHeight = currentText.heightWithConstrainedWidth(width: customWidth, font: UIFont(name: Fonts.CIRCULAR_BOLD, size: 13.0)!) + customWidth + 10
        let currentTextHeight = currentText.heightWithConstrainedWidth(width: customWidth,
                                                                       font: UIFont(name: Fonts.CIRCULAR_BOLD,
                                                                                    size: 13.0)!) - 16
        let siblingTextHeight = siblingText.heightWithConstrainedWidth(width: customWidth,
                                                                       font: UIFont(name: Fonts.CIRCULAR_BOLD,
                                                                                    size: 13.0)!) - 16
        let currentItemAdditionalHeight = currentTextHeight + (isCurrentItemRatingApplied ?  15 : 0)
        let siblingItemAdditionalHeight = siblingTextHeight + (isSiblingItemRatingApplied ?  15 : 0)
        var additionalHeight : CGFloat = 0
        if currentItemAdditionalHeight < siblingItemAdditionalHeight{
            additionalHeight += siblingItemAdditionalHeight
        }else{
            additionalHeight += currentItemAdditionalHeight
        }

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{

            return CGSize(width: customWidth, height: layout.itemSize.height + 5)
        }
        return CGSize(width: customWidth, height: customHeight)
    }
    
    func viewController(responder: UIResponder) -> UIViewController? {
        if let vc = responder as? UIViewController {
            return vc
        }
        
        if let next = responder.next {
            return viewController(responder: next)
        }
        
        return nil
    }
    
}

extension UIButton {
    func appGuestTextColor() {
        self.setTitleColor(.appTitleColor, for: .normal)
    }
    
    func appGuestBGColor() {
        self.backgroundColor = UIColor.appGuestThemeColor

    }
    func appHostTextColor() {
        self.setTitleColor(.appHostTitleColor, for: .normal)
    }
    
    func appHostBGColor() {
        self.backgroundColor = UIColor.appHostThemeColor
    }
    
    func appGuestSideBtnBG() {
        self.backgroundColor = UIColor.appGuestButtonBG
    }
    
    func appHostSideBtnBG() {
        self.backgroundColor = UIColor.appHostButtonBG
    }
    func nextButtonImage() {
        self.setImage(UIImage(named: "nextarrow.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = UIColor.white
        self.backgroundColor = UIColor.appGuestLightColor
        self.elevate(3.0)
    }
    func deleted(_ color:UIColor) {
        self.setImage(UIImage(named: "delete.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = color
    }
}

extension UILabel {
    func appGuestTextColor() {
        self.textColor = .appTitleColor
    }
    
    func appTextPinkColor() {
         self.textColor = k_AppThemePinkColor
    }
    
    func appHostTextColor() {
        self.textColor = .appHostTitleColor
        
    }
    
    
    func appGuestBGColor() {
        self.backgroundColor = UIColor.appGuestThemeColor
    }
    
    func appHostBGColor() {
        self.backgroundColor = UIColor.appHostThemeColor
    }
//    func appGuestSideBtnBG() {
//        self.backgroundColor = UIColor.appHostButtonBG
//    }
//    
//    func appHostSideBtnBG() {
//        self.backgroundColor = UIColor.appGuestButtonBG
//    }
//    func nextButtonImage() {
//        self.setImage(UIImage(named: "nextarrow.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        self.tintColor = UIColor.appGuestThemeColor
//    }
}

extension UIImageView {
    func dropDownImage(_ color:UIColor) {
        self.image = UIImage(named: "downarrow.png")?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func clockImage(_ color:UIColor) {
        self.image = UIImage(named: "clock.png")?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }

    func deleted(_ color:UIColor) {
        self.image = UIImage(named: "delete.png")?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }

}
