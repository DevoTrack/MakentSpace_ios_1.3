//
//  AccessTVC.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class AccessTVC: UITableViewCell {

    @IBOutlet weak var selectDataBtn: UIButton!
    
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var txtLbl: UILabel!
    
    
    let checkedImage = UIImage(named: "check_red_active.png")
    let uncheckedImage = UIImage(named: "")
    
    // Bool property
    //Bool Property
    var isChecked:Bool = false{
        didSet{
            if isChecked == true{
                self.selectBtn.setImage(checkedImage, for: .normal)
            }else{
                self.selectBtn.setImage(uncheckedImage, for: .normal)
            }
           
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.styleSetup()
        
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension AccessTVC {
    
    func styleSetup() {
        self.selectBtn.borderWidth = 1.0
        self.selectBtn.borderColor = .lightGray
        self.selectBtn.cornerRadius = 2.0
        self.selectBtn.clipsToBounds = true
    }
    
}
