//
//  SimilarListingCVC.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class SimilarListCVC: UICollectionViewCell {
    
    @IBOutlet weak var listImageView:UIImageView!
    @IBOutlet weak var carPriceLabel:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carRatingLabel:UILabel!
    @IBOutlet weak var carReviewLabel:UILabel!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    @IBOutlet weak var ratingLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewLabelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var grayView: UIView!
    
    override func awakeFromNib() {
        //        carPriceLabel.font = UIFont(name: Fonts.CIRCULAR_LIGHT, size: 15)
        nameLabel.font = UIFont(name: Fonts.CIRCULAR_LIGHT, size: 15)
        carReviewLabel.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 14)
        carReviewLabel.textColor = .black//k_AppThemeColor
        carRatingLabel.textColor = k_AppThemeColor
        //        favouriteButtonOutlet.titleLabel?.font = UIFont(name: Fonts.MAKENT_LOGO_FONT1, size: 25)
        carRatingLabel.font  = UIFont(name: Fonts.MAKENT_LOGO_FONT1, size: 10)
    }
}
