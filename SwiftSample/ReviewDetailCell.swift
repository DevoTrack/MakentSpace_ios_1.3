/**
* ReviewDetailCell.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import UIKit

class ReviewDetailCell: UITableViewCell {
    @IBOutlet var lblName: UILabel?
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var lblDate: UILabel?
    @IBOutlet var lblDescription: UILabel?

    func setReviewData(modelReview : ReviewUserDetail)
    {
        let height = MakentSupport().onGetStringHeight((self.frame.size.width-40), strContent: (modelReview.review_message as String as NSString), font: UIFont (name: Fonts.CIRCULAR_LIGHT, size: 17)!)
        var rectEmailView = lblDescription?.frame
        rectEmailView?.size.height = height + 10
        lblDescription?.frame = rectEmailView!
        
        

        imgUserThumb?.addRemoteImage(imageURL: modelReview.review_user_image as String , placeHolderURL: "", isRound: true)
            //.sd_setImage(with: NSURL(string: modelReview.review_user_image as String) as! URL, placeholderImage:UIImage(named:""))

        lblName?.text = modelReview.review_user_name as String
        lblDate?.text =  modelReview.review_date as String
        lblDescription?.text = modelReview.review_message as String
//        lblName?.text = "Mani"
    }
}
