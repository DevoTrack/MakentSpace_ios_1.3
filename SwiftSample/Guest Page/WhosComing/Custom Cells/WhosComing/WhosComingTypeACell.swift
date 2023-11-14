//
//  WhosComingCell.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/9/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class WhosComingTypeACell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.backgroundColor = UIColor.black
        profileImageView.layer.cornerRadius = 50/2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
