//
//  ExploreExperienceCell.swift
//  Makent
//
//  Created by Boominadha Prakash on 14/09/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExploreExperienceCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView?
    @IBOutlet var lblRoomDetail: UILabel?
    @IBOutlet var btnBookmark: UIButton?
    @IBOutlet var viewMoreImgs: UIView?
    @IBOutlet var imgRoomOne: UIImageView?
    @IBOutlet var imgRoomTwo: UIImageView?
    @IBOutlet var imgRating: UIImageView?
    @IBOutlet var lblRatingValue: UILabel?
    @IBOutlet var animatedImageView: FLAnimatedImageView?
    @IBOutlet var lblSeparator: UILabel?
    @IBOutlet var lblRating: UILabel?
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func resetValues() {
        self.lblRoomDetail?.text = ""
        self.btnBookmark?.setTitle("", for: .normal)
        self.lblRatingValue?.text = ""
        self.lblRating?.text = ""
    }
    func setExploreData(ratingCount: String) {
        let rect = MakentSupport().getScreenSize()
        var rectEmailView = self.frame
        if MakentSupport().isPad() {
            rectEmailView.size.width = rect.size.width
            var rectImgView = imageView?.frame
            rectImgView?.origin.x = 50
            rectImgView?.size.width = rect.size.width - 100
            
            if UIDevice.current.orientation.isLandscape {
                rectEmailView.size.height = 575
            } else {
                rectEmailView.size.height = 575
            }
            imageView?.frame = rectImgView!
            rectEmailView.origin.x = 0
        } else {
            rectEmailView.size.width = rect.size.width-20
            rectEmailView.origin.x = 10
        }
        
        self.frame = rectEmailView
    }
}
