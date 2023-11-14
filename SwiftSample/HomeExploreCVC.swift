//
//  HomeExploreCVC.swift
//  Makent
//
//  Created by trioangle on 31/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
class HomeExploreListCVC: UICollectionViewCell {
    
    @IBOutlet weak var exploreImageView: UIImageView!
    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreSubTitleLabel: UILabel!
    @IBOutlet weak var explorePriceLabel: UILabel!
    @IBOutlet weak var exploreRatingLabel: UILabel!
    @IBOutlet weak var exploreRatingCountLabel: UILabel!
    @IBOutlet weak var whishListButtonOutlet: UIButton!
    
    @IBOutlet weak var wishListView: UIView!
    
    @IBOutlet weak var grayImage: UIImageView!
    @IBOutlet weak var ratingStackV : UIStackView!
    let lang = Language.getCurrentLanguage()
    //    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var subTitleHeightConstraint: NSLayoutConstraint!
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exploreTitleLabel.textAlignment = lang.getTextAlignment(align: .left)
        exploreSubTitleLabel.textAlignment = lang.getTextAlignment(align: .left)
        explorePriceLabel.textAlignment = lang.getTextAlignment(align: .left)
        exploreRatingCountLabel.textAlignment = lang.getTextAlignment(align: .left)
        self.exploreRatingLabel.AlignText()
        self.exploreImageView.contentMode = .scaleToFill
//        self.exploreImageView.roundCorners(corners: [.topRight], radius: 25)
//        self.exploreImageView.roundCorners(topLeft: 0, topRight: 20, bottomLeft: 0, bottomRight: 0)
//        let img = UIImage(named: "grayscale")
//        self.grayImage.image = img
//        self.grayImage.alpha = 0.5
//        self.wishListView.backgroundColor = .clear
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ratingStackV.isHidden = true
    }
    //
    ////    @IBOutlet weak var imageHeightConstant: NSLayoutConstraint!
    //
    //    @IBOutlet weak var priceHeightConstraint: NSLayoutConstraint!
    //
    //    @IBOutlet weak var ratingHeightConstraint: NSLayoutConstraint!
}
extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
             path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        path.closeSubpath()
        cgPath = path
    }
}
