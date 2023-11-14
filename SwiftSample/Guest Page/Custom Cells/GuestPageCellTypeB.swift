//
//  GuestPageCellTypeB1.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/8/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class GuestPageCellTypeB: UITableViewCell {

    @IBOutlet weak var lblTerms: TTTAttributedLabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTermsNConsWith()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupTermsNConsWith() {
        let str = lang.agree_GuestPage as NSString as NSString
        lblTerms.text = str as String
        lblTerms.linkAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.rgb(from: 0xFF0F29).withAlphaComponent(0.85)]
        let range = str.range(of: lang.mak_AddTerms)
        lblTerms.addLink(to: NSURL(string: "\(k_WebServerUrl)terms_of_service")! as URL?, with: range)
        
        let range2 : NSRange = str.range(of: lang.cancelpolicy_Title)
        lblTerms.addLink(to: NSURL(string: "\(k_WebServerUrl)guest_refund")! as URL?, with: range2)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
