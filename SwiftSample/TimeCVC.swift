//
//  TimeCVC.swift
//  Makent
//
//  Created by trioangle on 04/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TimeCVC: UICollectionViewCell {

    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var lblTimeVal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTimeVal.textHourFont()
    }

}
