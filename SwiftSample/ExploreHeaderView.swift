/**
* ExploreHeaderView.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit

class ExploreHeaderView: UICollectionReusableView {
    @IBOutlet weak var lblHeaderTitle: UILabel?
    @IBOutlet weak var lblRoomInfo: UILabel?

    @IBOutlet weak var saved_Title: UILabel!
    @IBOutlet var btnUpArrow: UIButton?
    @IBOutlet var btnWhereTo: UIButton?
    @IBOutlet var btnWhen: UIButton?
    @IBOutlet var btnGuest: UIButton?
    
    @IBOutlet weak var trp_Titt: UILabel!
    
    @IBOutlet weak var tappedView: UIView!
    //    @IBOutlet var viewGradient: UIView!
    @IBOutlet var btnEdit: UIButton?
    @IBOutlet var btnClearAll: UIButton?
    @IBOutlet var imgHeader: UIImageView?
    @IBOutlet var viewImgHolder: UIView?

    
    // Following control using for Wishlist viewcontroller
    @IBOutlet var btnInvite: UIButton!
    @IBOutlet weak var homesBtn: UIButton!
    @IBOutlet weak var experiencesBtn: UIButton!

    override class func awakeFromNib() {
        super.awakeFromNib()
//        trp_Titt.text = ""
    }
    func makeText(){
       trp_Titt.text = "Bookings"
    }
    func makeGradient()
    {
//        trp_Titt.text = "Bookings"
//        MakentSupport().makeGradientColor(gradientView: viewGradient)
    }
}
