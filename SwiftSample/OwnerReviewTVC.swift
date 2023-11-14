//
//  OwnerReviewTVC.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
class OwnerReviewTVC: UITableViewCell {
    
    @IBOutlet weak var reviewUserImageView: UIImageView!
    @IBOutlet weak var reviewUserNameLabel: UILabel!
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func displayReviewDetails(roomDetailDict:SpaceDetailData) {
        //ratingLabel.text = roomDetailDict.reviewCount
        let rateVal = roomDetailDict.rating
        ratingLabel.text = MakentSupport().createRatingStar(ratingValue: rateVal as NSString) as String
//            //MakentSupport().createRatingStar(ratingValue: "5") as String
//        ratingLabel.appGuestTextColor()
        if roomDetailDict.reviewCount > 1{
             reviewCountLabel.text = "\(self.lang.read_Title) \(roomDetailDict.reviewCount) \(self.lang.revs_Title)"
        }else if roomDetailDict.reviewCount == 1{
             reviewCountLabel.text = "\(self.lang.read_Title) \(roomDetailDict.reviewCount) \(self.lang.rev_Title)"
        }else{
             reviewCountLabel.text = ""
        }
        reviewCountLabel.appGuestTextColor()
        reviewDescriptionLabel.text = roomDetailDict.reviewMessage
        reviewUserImageView.addRemoteImage(imageURL: roomDetailDict.reviewUserImage as! String, placeHolderURL: "", isRound: true)
        reviewUserNameLabel.text = roomDetailDict.reviewUserName
        reviewDateLabel.text = roomDetailDict.reviewDate
        reviewCountLabel.textColor = k_AppThemeColor
        ratingLabel.textColor = k_AppThemeColor
    }
}
