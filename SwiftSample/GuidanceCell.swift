//
//  GuidanceCell.swift
//  Makent
//
//  Created by trioangle on 10/12/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class GuidanceCell: UITableViewCell {

    @IBOutlet weak var Lbltitle: UILabel!
    
    @IBOutlet weak var Lblguidance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
