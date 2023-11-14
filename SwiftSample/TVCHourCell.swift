//
//  TVCHourCell.swift
//  Makent
//
//  Created by trioangle on 18/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TVCHourCell: UITableViewCell {

    @IBOutlet weak var viewStrt: UIView!
    
    @IBOutlet weak var viewEnd: UIView!
    
//    @IBOutlet weak var txtFldSrtTim: DropDown!
//
//    @IBOutlet weak var txtFldEndTim: DropDown!
    
     @IBOutlet weak var txtFldSrtTim: UITextField!

    @IBOutlet weak var txtFldEndTim: UITextField!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewStrt.isElevated = true
        self.viewEnd.isElevated = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
