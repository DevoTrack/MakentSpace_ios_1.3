/**
 * MapRoomVC.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit

class MapRoomCell: UICollectionViewCell {
    
    @IBOutlet weak var imgRoom: UIImageView?
    @IBOutlet weak var lblPrice: UILabel!
    //@IBOutlet weak var txtRoomDetais: UITextView?
    @IBOutlet weak var txtRoomDetais: UILabel!
    
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var viewExtraImg: UIView?
    @IBOutlet weak var imgRoomOne: UIImageView?
    @IBOutlet weak var imgRoomTwo: UIImageView?
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var lblRating: UILabel?
    @IBOutlet weak var btnBookmark: UIButton?
    @IBOutlet weak var lblSelection: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func setMapDetailsData(modelMap : ExploreModel) {
        let currencySymbol = (modelMap.currency_symbol as String).stringByDecodingHTMLEntities
        if modelMap.instant_book == "No" {
            lblPrice?.attributedText =  MakentSupport().attributedText(originalText: (String(format: "%@ %@ %@",currencySymbol,(modelMap.room_price), modelMap.room_name) as NSString), boldText: (String(format: "%@ %@",currencySymbol, modelMap.room_price) as NSString) as String, fontSize: 15.0)
        } else {
            lblPrice?.attributedText = Utilities.attributeForInstantBook(normalText:  (String(format: "%@ %@ %@",currencySymbol,(modelMap.room_price), modelMap.room_name)), boldText: (String(format: "%@ %@",currencySymbol, modelMap.room_price)), fontSize: 15.0)
                
                //MakentSupport().attributedInstantBookText(originalText: (String(format: "G %@ %@ %@",currencySymbol,(modelMap.room_price), modelMap.room_name) as NSString), boldText: (String(format: "%@ %@",currencySymbol, modelMap.room_price) as NSString) as String, fontSize: 15.0)
        }
        if (modelMap.reviews_count != "0" || modelMap.reviews_count != "") {
            //modelMap.rating_value as NSString
            lblRating?.text = MakentSupport().createRatingStar(ratingValue: modelMap.rating_value as NSString) as String
            //MakentSupport().createRatingStar(ratingValue: "5") as String
            lblRating?.appGuestTextColor()
        }
        imgRoom?.addRemoteImage(imageURL: modelMap.room_thumb_image as String ?? "", placeHolderURL: "")
            //.sd_setImage(with: URL(string: modelMap.room_thumb_image as String), placeholderImage:UIImage(named:""))
        lblReviewCount?.text = String(format:(modelMap.reviews_count == "1") ? "%@ \(self.lang.rev_Title)" : "%@ \(self.lang.revs_Title)", modelMap.reviews_count as String)
        lblRating?.isHidden = (modelMap.reviews_count == "0" || modelMap.reviews_count == "") ? true : false
        lblReviewCount?.isHidden = (modelMap.reviews_count == "0" || modelMap.reviews_count == "") ? true : false
        btnBookmark?.setTitle((modelMap.is_whishlist == "Yes") ? "C" : "B", for: .normal)
        if (modelMap.is_whishlist == "Yes") {
            btnBookmark?.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
        } else {
            btnBookmark?.setTitleColor(UIColor.white, for: .normal)
        }
        

    }
/* ####### HIDE HOST EXPLERIENCE ####### @START */
    func setMapDetailsExpData(modelMap: ExploreModel) {
        let currencySymbol = (modelMap.ex_currency_symbol as String).stringByDecodingHTMLEntities
      //  lblPrice?.text = "\(currencySymbol)\(modelMap.experience_price) - \(modelMap.experience_name)"
         lblPrice?.attributedText =  MakentSupport().attributedText(originalText: (String(format: "%@ %@ %@",currencySymbol,(modelMap.experience_price), modelMap.experience_name) as NSString), boldText: (String(format: "%@ %@",currencySymbol, modelMap.experience_price) as NSString) as String, fontSize: 15.0)
        if (modelMap.ex_reviews_count).integerValue != 0 {
            //modelMap.rating_value as NSString
            lblRating?.text = MakentSupport().createRatingStar(ratingValue: modelMap.rating_value as NSString) as String
            //akentSupport().createRatingStar(ratingValue: "5") as String
            lblRating?.appGuestTextColor()
        }
        imgRoom?.addRemoteImage(imageURL: modelMap.experience_thumb_images as String ?? "", placeHolderURL: "")
            //.sd_setImage(with: URL(string: modelMap.experience_thumb_images as String), placeholderImage:UIImage(named:""))
        lblReviewCount?.text = String(format:((modelMap.reviews_count).integerValue == 1) ? "%@ \(self.lang.rev_Title)" : "%@ \(self.lang.revs_Title)", "\(modelMap.reviews_count)")
        lblRating?.isHidden = ((modelMap.reviews_count).integerValue == 0 ) ? true : false
        lblReviewCount?.isHidden = ((modelMap.reviews_count).integerValue == 0) ? true : false
        btnBookmark?.setTitle((modelMap.is_whishlist == "Yes") ? "C" : "B", for: .normal)
        if (modelMap.is_whishlist == "Yes") {
            btnBookmark?.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
        } else {
            btnBookmark?.setTitleColor(UIColor.white, for: .normal)
        }

    }
 /* ####### HIDE HOST EXPLERIENCE ####### @END */

    func setWishListData(modelWishList: WishListModel) {
        
        if let images = modelWishList.arrListRooms as? [String], images.count > 0 {
            viewExtraImg?.isHidden = true
            imgRoom?.backgroundColor = UIColor.lightGray
//            imgRoom?.sd_setImage(with: URL(string: modelWishList.arrListRooms?[0] as! String), placeholderImage:UIImage(named: ""))
            imgRoom?.addRemoteImage(imageURL: images[0], placeHolderURL: "", isRound: false)
            if images.count > 2 {
                viewExtraImg?.isHidden = false
                imgRoomOne?.addRemoteImage(imageURL: images[1], placeHolderURL: "", isRound: false)
                imgRoomTwo?.addRemoteImage(imageURL: images[2] , placeHolderURL: "", isRound: false)

            }
        } else {
            viewExtraImg?.isHidden = true
            imgRoom?.image = UIImage(named: "")
        }
        if modelWishList.arrListRooms?.count == 0 {
            lblRoomName.text = String(format:"%@ · \(self.lang.nothing_Title)",modelWishList.list_name.replacingOccurrences(of: "%20", with: " "))
        }
        else if modelWishList.arrListRooms?.count == 1 {
            txtRoomDetais.text = " \((modelWishList.arrListRooms?.count)!)" + " \(self.lang.listing_Title)"
            lblRoomName.text = "\(modelWishList.list_name.replacingOccurrences(of: "%20", with: " "))"
                //String(format:"%@ · %d \(self.lang.listing_Title)",modelWishList.list_name.replacingOccurrences(of: "%20", with: " "), (modelWishList.arrListRooms?.count)!)
          
        } else {
            print("Response",modelWishList.list_name,"count",modelWishList.arrListRooms?.count)
//            txtRoomDetais?.text = String(format:"%@ · %d \(self.lang.listings_Title)",modelWishList.list_name.replacingOccurrences(of: "%20", with: " "), (modelWishList.arrListRooms?.count)!)
            txtRoomDetais.text = " \((modelWishList.arrListRooms?.count)!)" + " \(self.lang.listings_Title)"
            lblRoomName.text = "\(modelWishList.list_name.replacingOccurrences(of: "%20", with: " "))"
                //String(format:"%@ · %d \(self.lang.listings_Title)",modelWishList.list_name.replacingOccurrences(of: "%20", with: " "))
        }
    }
}
