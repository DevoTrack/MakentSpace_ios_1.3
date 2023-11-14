//
//  PhotoViewCell.swift
//  Makent
//
//  Created by trioangle on 28/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {

    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var spaceImage: UIImageView!
    var photoDataModel = [BasicStpData]()
    @IBOutlet weak var btnDeleteImage: UIButton!
    @IBOutlet weak var spaceDesc: UITextView!
    var delegate : CollectionDataPass?
    let lang = Language.localizedInstance()
    var parent = UIViewController()
    @IBOutlet weak var constrtDescText: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.spaceDesc.AlignText()
        self.spaceDesc.delegate = self
        self.photoView.isElevated = true
    }
    
    
}

