//
//  ContactHostTypeACell.swift
//  Makent
//
//  Created by Ranjith Kumar on 12/7/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ContactHostTypeACell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: TTTAttributedLabel!
    @IBOutlet weak var profilePicture: UIImageView! {
        didSet {
            profilePicture.layer.cornerRadius = 70/2
            profilePicture.clipsToBounds = true
        }
    }
let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func awakeFromNib() {
        super.awakeFromNib()
        secondLabel.delegate = self
        setupFAQ()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupFAQ() {
        let str = self.lang.faq_Msg as NSString
        secondLabel.text = str as String
        secondLabel.linkAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.rgb(from: 0xFF0F29).withAlphaComponent(0.85)]
        let range = str.range(of: lang.faq_Title)
        secondLabel.addLink(to: NSURL(string: "\(k_WebServerUrl)\(webPageUrl.URL_HELPS_SUPPORT)")! as URL?, with: range)
    }
    
}
extension ContactHostTypeACell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
