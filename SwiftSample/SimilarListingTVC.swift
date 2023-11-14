//
//  SimilarListingTVC.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
//MARK: Similar Listing
class SimilarListTVC: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var similarListTitleLabel: UILabel!
    @IBOutlet weak var similarListCollectionView: UICollectionView!
    var delegate: SimilarListDelegate?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
   // var similarListDictArray = [[String:Any]]()
    var similarListDictArray : SpaceDetailData!
    var currencyCode = NSString()
    
    override func awakeFromNib() {
        currencyCode = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard similarListDictArray != nil else
        {
            return 0
        }
       return similarListDictArray.similarList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SimilarListCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "similarListCVC", for: indexPath) as! SimilarListCVC
        cell.listImageView.addRemoteImage(imageURL: similarListDictArray.similarList[indexPath.row].photoName
            , placeHolderURL: "", isRound: false)
        cell.listImageView.cornerRadius = 75
        cell.grayView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        if Language.getCurrentLanguage().isRTL{
            cell.listImageView.layer.maskedCorners = .layerMinXMinYCorner
        } else {
            cell.listImageView.layer.maskedCorners = .layerMaxXMinYCorner
        }
        
        var typeName = String()
        typeName.append(similarListDictArray.similarList[indexPath.row].spaceTypeName)
//        let numberOfBeds = similarListDictArray.squareFeet
        cell.typeLabel.text = "\(typeName) • \(similarListDictArray.similarList[indexPath.row].size)\(similarListDictArray.similarList[indexPath.row].sizeType)"
        cell.typeLabel.textColor = k_AppThemePinkColor
        cell.typeLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.nameLabel.text = similarListDictArray.similarList[indexPath.row].name
        cell.nameLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.priceLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        if ("\(String(describing: similarListDictArray.similarList[indexPath.row].instantBook))" == "No") {
            cell.priceLabel.text = "\(Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL)) \(similarListDictArray.similarList[indexPath.row].hourly) \(self.lang.per_Hours)"
        }else{
            cell.priceLabel.attributedText = Utilities.attributeForInstantBook(normalText: "\("\(Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL)) \(similarListDictArray.similarList[indexPath.row].hourly) \(self.lang.per_Hours)" as String)", boldText: "", fontSize: 11.0)
        }
        
        if similarListDictArray.similarList[indexPath.row].isWishList == "Yes" {
            
            cell.favouriteButtonOutlet.setImage(UIImage(named: "heart_selected"), for: .normal)
            
        }else {
            
            cell.favouriteButtonOutlet.setImage(UIImage(named: "heart_normal"), for: .normal)
        }
        cell.favouriteButtonOutlet.clipsToBounds = true
        cell.favouriteButtonOutlet.addTarget(self, action: #selector(self.favouriteLabelTapped(sender:)), for: .touchUpInside)
        cell.carRatingLabel.font = UIFont(name: Fonts.MAKENT_LOGO_FONT1, size: 12)
        if similarListDictArray.similarList[indexPath.row].rating  != "0" {
            cell.carReviewLabel.isHidden = false
            cell.carRatingLabel.isHidden = false
            if similarListDictArray.similarList[indexPath.row].rating != "0" {
//                cell.ratingLabelWidthConstraint.constant = 62
//                cell.reviewLabelLeadingConstraint.constant = 1
                cell.carReviewLabel.text = "\(similarListDictArray.similarList[indexPath.row].reviewCount)"
            }else {
                
//                cell.ratingLabelWidthConstraint.constant = 0
//                cell.reviewLabelLeadingConstraint.constant = 0
                cell.carRatingLabel.text = ""
            }
            let rateVal = similarListDictArray.similarList[indexPath.row].rating
            cell.carRatingLabel.text = MakentSupport().createRatingStar(ratingValue: rateVal as NSString) as String
            
            cell.carRatingLabel.appGuestTextColor()
           
        }
        else {
            cell.carReviewLabel.isHidden = true
            cell.carRatingLabel.isHidden = true
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onSimilarListTapped(strRoomID: "\(String(describing: self.similarListDictArray.similarList[indexPath.row].spaceId))")
    }
    
    @objc func favouriteLabelTapped(sender:UIButton) {
        if let cell: SimilarListCVC = sender.superview?.superview as? SimilarListCVC {
            let indexPath = self.similarListCollectionView.indexPath(for: cell)
            delegate?.onWishList(index: (indexPath?.row)!, sender:sender)
        }
    }
}
