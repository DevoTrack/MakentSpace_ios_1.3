/**
* CustomRentCell.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import UIKit

class CustomRentCell: UICollectionViewCell {
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
    
    
    @IBOutlet weak var lblSpcname: UILabel!
    
    @IBOutlet weak var lblGuestCount: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func setExploreData(ratingCount : String)
    {
        let rect = MakentSupport().getScreenSize()
        var rectEmailView = self.frame
        if MakentSupport().isPad()
        {
            rectEmailView.size.width = rect.size.width
            var rectImgView = imageView?.frame
            rectImgView?.origin.x = 50
            rectImgView?.size.width = rect.size.width - 100

            if(UIDevice.current.orientation.isLandscape)
            {
                rectEmailView.size.height = 575
            }
            else
            {
                rectEmailView.size.height = 575
            }
            imageView?.frame = rectImgView!
            rectEmailView.origin.x = 0
        }
        else
        {
            rectEmailView.size.width = rect.size.width-20
            rectEmailView.origin.x = 10
        }

        self.frame = rectEmailView
        
    }
    
    func displayWishListName(_ modelWishList : WishListModel){
        
        let listName = modelWishList.list_name.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let homeCount = modelWishList.rooms_count.integerValue
        let expCount = modelWishList.host_experience_count.integerValue
        print("counts:",homeCount,expCount)
        self.lblRoomDetail?.AlignText()
        self.lblRoomDetail?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        if (homeCount == 1){
        self.lblRoomDetail?.text =  String(format:"%@ \n%d Space ",(listName),homeCount)
        }
        if (homeCount > 1){
        self.lblRoomDetail?.text =  String(format:"%@ \n%d Spaces ",(listName),homeCount)
        }
//        if (modelWishList.arrListRooms?.count)! == 0
//        {
//            self.lblRoomDetail?.text = String(format:"%@ · \(self.lang.nothing_Title)",(listName))
//
//        }else if (homeCount == 1 && expCount == 1){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.hom_Titt) · %d \(self.lang.Exp_Titt)",(listName),homeCount,expCount)
//
//        }else if (homeCount > 1 && expCount == 1){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.Homes) · %d \(self.lang.Exp_Titt)",(listName),homeCount,expCount)
//
//        }else if (homeCount > 1 && expCount == 0){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.Homes) ",(listName),homeCount)
//
//        }else if (homeCount == 0 && expCount > 1){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.Experiences) ",(listName),expCount)
//
//        }else if (homeCount == 1 && expCount == 0){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.hom_Titt) ",(listName),homeCount)
//
//        }else if (homeCount == 0 && expCount == 1){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.Exp_Titt) ",(listName),expCount)
//
//        }else if (homeCount == 1 && expCount > 1){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.hom_Titt) · %d \(self.lang.Experiences)",(listName),homeCount,expCount)
//
//        }else if (homeCount > 1 && expCount > 1){
//
//            self.lblRoomDetail?.text = String(format:"%@ · %d \(self.lang.Homes) · %d \(self.lang.Experiences)",(listName),homeCount,expCount)
//
//        }
    }
    
}
