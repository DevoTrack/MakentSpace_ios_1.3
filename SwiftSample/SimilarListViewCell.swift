/**
* SimilarListViewCell.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import UIKit
import MapKit

//protocol SimilarListDelegate
//{
//    func onSimilarListTapped(strRoomId: NSString)
//    func onWishList(index: Int)
//}

class SimilarListViewCell: UITableViewCell {
    @IBOutlet var viewSimilarList: UIView!
    @IBOutlet var scrollSimilarListing: UIScrollView?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var delegate: SimilarListDelegate?

    func setSimilarListData(modelRooms : RoomDetailModel)
    {
        let rect = UIScreen.main.bounds as CGRect
        var rectEmailView = self.frame
        rectEmailView.size.width = rect.size.width-20
        rectEmailView.origin.x = 10
        self.frame = rectEmailView
        
        if modelRooms.similar_list_details != nil && modelRooms.similar_list_details.count > 0
        {
            if MakentSupport().isPad() {
                self.downloadiPadRoomDetailImages(arrSimilarData: modelRooms.similar_list_details)
            }
            else{
                self.downloadRoomDetailImages(arrSimilarData: modelRooms.similar_list_details)
            }
        }
    }
    
    func downloadRoomDetailImages(arrSimilarData:NSArray)
    {
        let rect = UIScreen.main.bounds as CGRect
        
        var xPosition:CGFloat = 0
        scrollSimilarListing?.frame =  CGRect(x: 0, y:35, width:rect.size.width ,height: 235)
        //        viewSimilarList?.layer.borderColor = UIColor.red.cgColor
        //        viewSimilarList?.layer.borderWidth = 2.0
        
        for i in 0 ..< arrSimilarData.count
        {
            let viewHolder:UIView = UIView()
            viewHolder.frame =  CGRect(x: xPosition, y:0, width: (scrollSimilarListing?.frame.size.width)! ,height: (scrollSimilarListing?.frame.size.height)!)
            
            let myImageView:UIImageView = UIImageView()
            myImageView.frame =  CGRect(x: 20, y:0, width: viewHolder.frame.size.width-40 ,height: viewHolder.frame.size.height-40)

            
            myImageView.addRemoteImage(imageURL: ((arrSimilarData[i] as AnyObject).value(forKey: "room_thumb_image") as! String) ?? "", placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: ((arrSimilarData[i] as AnyObject).value(forKey: "room_thumb_image") as! String))! as URL, placeholderImage:UIImage(named:""))

            
            viewHolder.addSubview(myImageView)
            myImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            //            viewHolder.layer.borderColor = UIColor.red.cgColor
            //            viewHolder.layer.borderWidth = 2.0
            
            
            let myButton:UIButton = UIButton()
            myButton.frame =  CGRect(x: 20, y:0, width: viewHolder.frame.size.width-40 ,height: viewHolder.frame.size.height)
            myButton.tag = ((arrSimilarData[i] as AnyObject).value(forKey: "room_id") as! Int)
            //            myButton.backgroundColor = UIColor.red
            myButton.addTarget(self, action: #selector(self.onImageTapped), for: UIControl.Event.touchUpInside)
            myButton.isUserInteractionEnabled = true
            scrollSimilarListing?.isUserInteractionEnabled = true
            let btnFavourite:UIButton = UIButton()
            btnFavourite.frame =  CGRect(x: myImageView.frame.size.width-30
                , y: 0, width: 50 ,height: 50)
            btnFavourite.tag = i//((arrSimilarData[i] as AnyObject).value(forKey: "room_id") as! Int)
            btnFavourite.addTarget(self, action: #selector(self.onBookMarkTapped), for: UIControl.Event.touchUpInside)
//            btnFavourite.setImage(UIImage(named: "heart_normal.png"), for: UIControlState.normal)
            btnFavourite.setTitle((((arrSimilarData[i] as AnyObject).value(forKey: "is_whishlist") as! String) == "Yes") ? "C" : "B", for: .normal)
            btnFavourite.titleLabel?.font =  UIFont (name: Fonts.MAKENT_LOGO_FONT1, size: 20)!
            
            if (((arrSimilarData[i] as AnyObject).value(forKey: "is_whishlist") as! String) == "Yes")
            {
                btnFavourite.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
            }
            else
            {
                btnFavourite.setTitleColor(UIColor.white, for: .normal)
            }

            
            
//            btnFavourite.layer.borderColor = UIColor.red.cgColor
//            btnFavourite.layer.borderWidth = 2.0
            
            let lblRoomName:UILabel = UILabel()
            lblRoomName.frame =  CGRect(x: 20, y:190, width: viewHolder.frame.size.width ,height: 35)
            lblRoomName.text = ((arrSimilarData[i] as AnyObject).value(forKey: "room_name") as! String)
            viewHolder.addSubview(lblRoomName)
            
            
            let lblRate:UILabel = UILabel()
            lblRate.frame =  CGRect(x: 20, y:218, width: 70 ,height: 16)
            lblRate.font =  UIFont (name: Fonts.MAKENT_LOGO_FONT1, size: 10)!
            lblRate.textColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
            viewHolder.addSubview(lblRate)

            let lblRating:UILabel = UILabel()
            lblRating.frame =  CGRect(x: 75, y:217, width: 120 ,height: 20)
            if ((arrSimilarData[i] as! NSDictionary).value(forKey: "reviews_value") as! String) == "0"
            {
                lblRating.isHidden = true
                lblRate.isHidden = true
            }
            else
            {
                let str = ((arrSimilarData[i] as! NSDictionary).value(forKey: "rating_value") as! CVarArg) as! String
                //String(format:"%@",str) as NSString
                lblRate.text = MakentSupport().createRatingStar(ratingValue: String(format:"%@",str) as NSString) as String
                //MakentSupport().createRatingStar(ratingValue: "5") as String
                lblRate.appGuestTextColor()
                lblRating.isHidden = false
                lblRate.isHidden = false
            }
            //\(self.lang.rev_Title) \(self.lang.revs_Title)
            lblRating.text = String(format:(((arrSimilarData[i] as! NSDictionary).value(forKey: "reviews_value") as! String) == "1") ? "%@ " : "%@ ", ((arrSimilarData[i] as! NSDictionary).value(forKey: "reviews_value") as! String))
            lblRating.font = UIFont.systemFont(ofSize: 12)
            viewHolder.addSubview(lblRating)
            viewHolder.addSubview(myButton)
            viewHolder.addSubview(btnFavourite)

            scrollSimilarListing?.addSubview(viewHolder)
            
            //            myButton.layer.borderColor = UIColor.red.cgColor
            //            myButton.layer.borderWidth = 2.0
            
            xPosition+=(viewHolder.frame.size.width)
        }
        //        scrollSimilarListing?.layer.borderColor = UIColor.black.cgColor
        //        scrollSimilarListing?.layer.borderWidth = 2.0
        
        let widht = CGFloat(xPosition)
        scrollSimilarListing?.contentSize = CGSize(width: widht, height:  (scrollSimilarListing?.frame.size.height)!)
    }
    
    func downloadiPadRoomDetailImages(arrSimilarData:NSArray)
    {
        for view in (scrollSimilarListing?.subviews)!
        {
            view.removeFromSuperview()
        }
        
        let rect = MakentSupport().getScreenSize()
        
        var xPosition:CGFloat = 0
        scrollSimilarListing?.frame =  CGRect(x: 0, y:75, width:rect.size.width ,height: 225)
        //        viewSimilarList?.layer.borderColor = UIColor.red.cgColor
        //        viewSimilarList?.layer.borderWidth = 2.0
        
        for i in 0 ..< arrSimilarData.count
        {
            let viewHolder:UIView = UIView()
            viewHolder.frame =  CGRect(x: xPosition+50, y:0, width: ((scrollSimilarListing?.frame.size.width)!+110)/3 ,height: (scrollSimilarListing?.frame.size.height)!)
            
            let myImage = UIImage(named: (arrSimilarData[i] as! NSString) as String)
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            myImageView.frame =  CGRect(x: 0, y:0, width: viewHolder.frame.size.width ,height: viewHolder.frame.size.height-40)

            viewHolder.addSubview(myImageView)
            myImageView.addRemoteImage(imageURL: arrSimilarData[i] as! String ?? "", placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: arrSimilarData[i] as! String) as! URL, placeholderImage:UIImage(named:""))
            
            let myButton:UIButton = UIButton()
            myButton.frame =  CGRect(x: 20, y:0, width: viewHolder.frame.size.width ,height: viewHolder.frame.size.height)
            myButton.tag = i;
            myButton.addTarget(self, action: #selector(self.onImageTapped), for: UIControl.Event.touchUpInside)
            myButton.isUserInteractionEnabled = true
            scrollSimilarListing?.isUserInteractionEnabled = true
            let btnFavourite:UIButton = UIButton()
            btnFavourite.frame =  CGRect(x: myImageView.frame.size.width-50
                , y: 20, width: 30 ,height: 30)
            btnFavourite.tag = i;
            btnFavourite.addTarget(self, action: #selector(self.onBookMarkTapped), for: UIControl.Event.touchUpInside)
            btnFavourite.setImage(UIImage(named: "heart_normal.png"), for: UIControl.State.normal)
            viewHolder.addSubview(btnFavourite)
            
            let lblRoomName:UILabel = UILabel()
            lblRoomName.frame =  CGRect(x: 0, y:180, width: viewHolder.frame.size.width ,height: 35)
            lblRoomName.text = "Mani"
            viewHolder.addSubview(lblRoomName)
            
            let rateImg = UIImage(named: "rating.png")
            let imgRating:UIImageView = UIImageView()
            imgRating.image = rateImg?.withRenderingMode(.alwaysTemplate)
            imgRating.tintColor = UIColor.appGuestThemeColor
            imgRating.frame =  CGRect(x: 0, y:210, width: 50 ,height: 10)
            viewHolder.addSubview(imgRating)
            
            let lblRating:UILabel = UILabel()
            lblRating.frame =  CGRect(x: 60, y:205, width: 120 ,height: 20)
            lblRating.text = "875 Reviews"
            lblRating.font = UIFont.systemFont(ofSize: 12)
            viewHolder.addSubview(lblRating)
            viewHolder.addSubview(myButton)
            
            if ((arrSimilarData[i] as AnyObject).value(forKey: "reviews_value") as! Int) == 0
            {
                lblRating.isHidden = true
                imgRating.isHidden = true
            }
            else
            {
                lblRating.isHidden = false
                imgRating.isHidden = false
            }

            scrollSimilarListing?.addSubview(viewHolder)
            
            xPosition+=(viewHolder.frame.size.width)+10
        }
        
        let widht = CGFloat(xPosition+50)
        scrollSimilarListing?.contentSize = CGSize(width: widht, height:  (scrollSimilarListing?.frame.size.height)!)
    }

    
    @objc func onImageTapped(sender:UIButton)
    {
        delegate?.onSimilarListTapped(strRoomID: (String(format:"%d", sender.tag) as NSString) as String)
    }
    
    @IBAction func onBookMarkTapped(sender:UIButton)
    {
        let del = delegate
        del?.onWishList(index: sender.tag, sender: sender)
    }
}
