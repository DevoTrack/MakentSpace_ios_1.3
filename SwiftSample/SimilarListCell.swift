/**
* SimilarListCell.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import UIKit

class SimilarListCell: UICollectionViewCell {
    @IBOutlet var imgRoom: UIImageView?
    @IBOutlet var lblRoomName: UILabel?
    @IBOutlet var btnBookmark: UIButton?
    @IBOutlet var lblRatingValue: UILabel?
    @IBOutlet var imgRating: UIImageView?

    func setData()
    {
        let rect = UIScreen.main.bounds as CGRect
        
        var rectEmailView = self.frame
        rectEmailView.size.width = rect.size.width-20
        rectEmailView.origin.x = 10
        self.frame = rectEmailView

//        lblName?.text = "Mani"
    }
}
