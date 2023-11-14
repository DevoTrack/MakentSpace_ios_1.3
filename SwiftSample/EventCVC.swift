//
//  EventCVC.swift
//  Makent
//
//  Created by trioangle on 04/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class EventCVC: UICollectionViewCell {
    @IBOutlet weak var viewEvent: UIView!
    
    @IBOutlet weak var lblEventDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblEventDesc.TextFont()
    }
    
    override func prepareForReuse() {
        self.lblEventDesc.text = ""
        self.viewEvent.backgroundColor = .white
    }

}
