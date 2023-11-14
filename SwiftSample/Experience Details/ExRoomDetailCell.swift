//
//  ExRoomDetailCell.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/22/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExRoomDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var provideItemsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!

    @IBOutlet weak var illprovideImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityLabelHeightConstraint: NSLayoutConstraint!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func populate(data: ExperienceRoomDetails) {
        
        titleLabelHeightConstraint.constant = 0.0
        cityLabelHeightConstraint.constant = 0.0
        
        titleLabel.text = data.experienceName
        cityLabel.text = data.cityName
        hoursLabel.text = "\(data.hours?.clean ?? "")\(lang.hours_Total)"
        if data.provideItems != ""{
            provideItemsLabel.text = data.provideItems
            illprovideImage.isHidden = false
            provideItemsLabel.isHidden = false
        }
        else{
            illprovideImage.isHidden = true
            provideItemsLabel.isHidden = true
        }
        languageLabel.text = lang.offer_In + data.language!
        categoryLabel.text  = "\(data.categoryType ?? "") \(lang.exp_Title)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
