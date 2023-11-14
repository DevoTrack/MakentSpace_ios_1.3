//
//  WhosComingTypeBCell.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/9/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

//protocol WhosComingTypeBEditing: class {
//    func didEditGuest(guest: Guest)
//}

class WhosComingTypeBCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
//    public weak var delegate: WhosComingTypeBEditing?
    public var guest: Guest!

    override func awakeFromNib() {
        super.awakeFromNib()
        editButton.appGuestTextColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//
    
    
}
