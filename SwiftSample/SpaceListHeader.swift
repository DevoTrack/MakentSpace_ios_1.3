//
//  SpaceListHeader.swift
//  Makent
//
//  Created by trioangle on 01/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//
//Note:- Not Used in Makent Spaces
import UIKit

class SpaceListHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    let image = UIImageView()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(image)
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            image.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 0),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: image.layoutMarginsGuide.trailingAnchor,
                                           constant: 8),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor,
                                            constant: 8),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        
    }
}
