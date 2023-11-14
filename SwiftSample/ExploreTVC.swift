//
//  ExploreTVC.swift
//  Makent
//
//  Created by trioangle on 14/05/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExploreTVC: UITableViewCell {

    @IBOutlet weak var homeImageListScrollView: UIScrollView!
//    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var homeSubTitleLabel: UILabel!
    @IBOutlet weak var homePriceLabel: UILabel!
    @IBOutlet weak var homeRatingLabel: UILabel!
    @IBOutlet weak var homeRatingCountLabel: UILabel!
    @IBOutlet weak var whishListButtonOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let alignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.homeTitleLabel.textAlignment = alignment
        self.homeSubTitleLabel.textAlignment = alignment
        self.homePriceLabel.textAlignment = alignment
        self.homeRatingLabel.AlignText()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
