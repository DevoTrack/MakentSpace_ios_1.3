//
//  ExWhatIProvideCell.swift
//  Makent
//
//  Created by Ranjith Kumar on 12/7/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExWhatIProvideCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var titleContsHight: NSLayoutConstraint!
    
    @IBOutlet weak var contentLabelBottomLC: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let textAlignement = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.titleLabel.textAlignment = textAlignement
        self.subTitleLabel.textAlignment = textAlignement
        self.contentLabel.textAlignment = textAlignement
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
