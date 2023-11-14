//
//  WhosComingTypeCCell.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/9/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class WhosComingTypeCCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addGuestButton: UIButton!

    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGuestButton.appGuestTextColor()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
