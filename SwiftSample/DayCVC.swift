//
//  DayCVC.swift
//  Makent
//
//  Created by trioangle on 04/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class DayCVC: UICollectionViewCell {
    @IBOutlet weak var viewDay: UIView!
    
    @IBOutlet weak var lblDateVal: UILabel!
    @IBOutlet weak var lblDayVal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblDayVal.textHourFont()
        self.lblDateVal.textHourTitleFont()
    }

}
