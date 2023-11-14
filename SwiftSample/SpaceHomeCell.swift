//
//  SpaceHomeCell.swift
//  Makent
//
//  Created by trioangle on 24/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceHomeCell: UITableViewCell {

    @IBOutlet weak var spaceStepTitle: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var lblStpsCmplt: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var spaceStepDetail: UILabel!
    
    @IBOutlet weak var btnChange: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
