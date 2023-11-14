//
//  AddRoomTVC.swift
//  Makent
//
//  Created by trioangle on 19/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit


//MARK:-
class AddBedTVC : UITableViewCell{
    static var identifier = "AddBedTVCID"
    @IBOutlet weak var roomTypeNameLbl : UILabel!
    @IBOutlet weak var valueLbl : UILabel!
    
    @IBOutlet weak var addBtn : UIButton!
    @IBOutlet weak var removeBtn : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) { [weak self] in
            self?.setValue(nil)
        }
        
        
    }
    func setValue(_ value : Int?){
        if let _value = value{
            self.valueLbl.text = _value.localize
        }
        self.addBtn.isRoundCorner = true
        self.removeBtn.isRoundCorner = true
        self.addBtn.border(1, UIColor.appHostThemeColor)
        self.removeBtn.border(1, UIColor.appHostThemeColor)
        self.addBtn.setTitleColor(UIColor.appHostThemeColor, for: .normal)
        self.removeBtn.setTitleColor(UIColor.appHostThemeColor, for: .normal)
        
        self.removeBtn.isUserInteractionEnabled = true
        self.addBtn.isUserInteractionEnabled = true
        if value == 0{
            self.removeBtn.layer.borderColor = UIColor.gray.cgColor
            self.removeBtn.setTitleColor(.gray, for: .normal)
            self.removeBtn.isUserInteractionEnabled = false
        }
        if value == 10{
            self.addBtn.layer.borderColor = UIColor.gray.cgColor
            self.addBtn.setTitleColor(.gray, for: .normal)
            self.addBtn.isUserInteractionEnabled = false
        }
    }
   
}

