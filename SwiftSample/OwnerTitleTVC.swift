//
//  OwnerTitleTVC.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
class OwnerTitleTVC: UITableViewCell {
    
    @IBOutlet weak var ownerTitleLabel: UILabel!
    
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var hostedByImageView: UIImageView!
    //    @IBOutlet weak var OwnerCategoryLabel: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    //    @IBOutlet weak var OwnerSubCategoryLabel: UILabel!
    
//    func displayOwnerDetails(roomDetailDict:[String:Any]) {
//        ownerTitleLabel.text = roomDetailDict["room_name"] as? String ?? String()
//        hostedByLabel.text = "\(String(describing: roomDetailDict["room_type"] as? String ?? String())) \n\(self.lang.ownby_Title) \(String(describing: roomDetailDict["host_user_name"] as? String ?? String()))"
//        hostedByLabel.attributedText = MakentSupport.instance.addAttributeFont(originalText: hostedByLabel.text!, attributedText: (roomDetailDict["carType"] as? String ?? String()), attributedFontName: CIRCULAR_BOLD, attributedColor: .darkGray,attributedFontSize: hostedByLabel.font.pointSize)
//        hostedByImageView.addRemoteImage(imageURL: roomDetailDict["host_user_image"] as? String ?? "", placeHolderURL: "room_default_no_photos", isRound: true)
//    }
    
    func displayOwnerDetails(roomDetailDict:SpaceDetailData) {
        print("profile pic",roomDetailDict.hostProfilePic)
        ownerTitleLabel.text = roomDetailDict.name
            hostedByLabel.text = "\n\(self.lang.hostedby_Title) \(roomDetailDict.hostName)"
//        hostedByLabel.appGuestTextColor()
        hostedByLabel?.attributedText = MakentSupport().makeAttributeTextColor(originalText: String(format:"\n\(self.lang.hostedby_Title) \(roomDetailDict.hostName) ") as NSString, normalText: "\n\(self.lang.hostby_Title) " as NSString, attributeText: "\(roomDetailDict.hostName) " as NSString, font: (hostedByLabel?.font)!)
//        hostedByLabel.attributedText = MakentSupport.instance.addAttributeFont(originalText: hostedByLabel.text!, attributedText: (roomDetailDict["carType"] as? String ?? String()), attributedFontName: CIRCULAR_BOLD, attributedColor: .darkGray,attributedFontSize: hostedByLabel.font.pointSize)
        hostedByImageView.addRemoteImage(imageURL: roomDetailDict.hostProfilePic, placeHolderURL: "room_default_no_photos", isRound: true)
    }
}
