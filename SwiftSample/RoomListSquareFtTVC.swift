//
//  RoomListSquareFtTVC.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class RoomListSquareFtTVC: UITableViewCell {

    @IBOutlet weak var txtLbl: UILabel!
    @IBOutlet weak var sqftLbl: UIView!
    @IBOutlet weak var lblSizeType: UILabel!
    
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var countLbl: UITextField!
    @IBOutlet weak var minusBtn: UIButton!
    var baseStep = BasicStpData()
    let lang = Language.getCurrentLanguage()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.countLbl.delegate = self
        countLbl.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        
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

        // Configure the view for the selected state
    }
    
}
