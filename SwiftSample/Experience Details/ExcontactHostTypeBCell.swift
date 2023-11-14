//
//  ExcontactHostTypeBCell.swift
//  Makent
//
//  Created by Ranjith Kumar on 12/7/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExcontactHostTypeBCell: UITableViewCell {

    @IBOutlet weak var editTaskValue: KMPlaceholderTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        editTaskValue.becomeFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
