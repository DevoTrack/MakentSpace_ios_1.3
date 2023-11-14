//
//  ExperinceType2Cell.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/22/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol ReadMoreClickable: class {
    func didTapReadMoreButton(title: String, subTitle: String)
}

class ExperinceType2Cell: UITableViewCell {

    @IBOutlet weak var aboutRoomLbl: UILabel!

    @IBOutlet weak var btnAboutReadMore: UIButton!
    @IBOutlet weak var descRoomLbl: UILabel!
    var title: String!
    var subTitle: String!
    public weak var delegate: ReadMoreClickable?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func awakeFromNib() {
        super.awakeFromNib()
        let alignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        self.descRoomLbl.textAlignment = .natural
        btnAboutReadMore.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateData(title:String,subTitle:String) {
        self.title = title
        self.subTitle = subTitle
        aboutRoomLbl.text = title
        if subTitle.count > 150{
            let first2Chars = String(subTitle.characters.prefix(150))
            let newStr = String(format: "%@\(lang.redmore_Title)", first2Chars)
            descRoomLbl?.attributedText = MakentSupport().makeAttributeTextColor(originalText: newStr as NSString, normalText: first2Chars as NSString, attributeText: lang.redmore_Title as NSString, font: (descRoomLbl?.font)!)
//            btnAboutReadMore?.isUserInteractionEnabled = true
        }else{
//            btnAboutReadMore?.isUserInteractionEnabled = false
            descRoomLbl?.text = subTitle as String
        }
    }

    @objc func readMoreButtonTapped() {
        self.delegate?.didTapReadMoreButton(title: title, subTitle: subTitle)
    }
    
}
