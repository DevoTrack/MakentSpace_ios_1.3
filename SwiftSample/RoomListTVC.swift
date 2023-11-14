//
//  RoomListTVC.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class RoomListTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var countLbl: UITextField!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    var baseStep = BasicStpData()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countLbl.delegate = self
        
    }
    func PlusMinusInter(){
        self.plusBtn.isUserInteractionEnabled = true
        self.minusBtn.isUserInteractionEnabled = true
    }
    func PlusInter(){
        self.plusBtn.isUserInteractionEnabled = true
        self.minusBtn.isUserInteractionEnabled = false
    }
    func MinusInter(){
        self.plusBtn.isUserInteractionEnabled = false
        self.minusBtn.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        countLbl.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                           for: UIControl.Event.editingChanged)
        
        // Configure the view for the selected state
    }
    
}
