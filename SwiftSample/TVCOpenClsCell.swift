//
//  TVCOpenClsCell.swift
//  Makent
//
//  Created by trioangle on 18/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TVCOpenClsCell: UITableViewCell {

    @IBOutlet weak var lblOpnCls: UILabel!
    
    @IBOutlet weak var swtOpnCls: UISwitch!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
