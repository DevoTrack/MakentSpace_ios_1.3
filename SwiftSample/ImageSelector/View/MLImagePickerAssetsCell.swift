/**
 * MLImagePickerAssetsCell.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */



import UIKit
import PhotosUI

protocol MLImagePickerAssetsCellDelegate {
    func imagePickerSelectAssetsCellWithSelected(indexPath:IndexPath,selected:Bool) -> Bool;
}

class MLImagePickerAssetsCell: UICollectionViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var videoMaskImgV:UIImageView?
    
    var asset:PHAsset!
    var delegate:MLImagePickerAssetsCellDelegate?
    var localIdentifier:String!
    var indexPath:IndexPath!
    var isShowVideo:Bool!{ // Default is Hide
        didSet{
            self.videoMaskImgV?.isHidden = !isShowVideo
        }
    }
    var selectButtonSelected:Bool! {
        didSet{
            if self.selectButton.isSelected == selectButtonSelected {
                return
            }
            self.selectButton.isSelected = selectButtonSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let noImage = UIImage.ml_imageFromBundleNamed(named: "zl_icon_image_no") as UIImage
        let yesImage = UIImage.ml_imageFromBundleNamed(named: "zl_icon_image_yes") as UIImage
        
        self.videoMaskImgV?.image = UIImage.ml_imageFromBundleNamed(named: "zl_video-play") as UIImage
        self.selectButton.setBackgroundImage(noImage, for: .normal)
        self.selectButton.setBackgroundImage(yesImage, for: .selected)
        
    }
    
    @IBAction func selectPhoto() {
        if self.delegate != nil {
            let btnSelected = self.delegate?.imagePickerSelectAssetsCellWithSelected(indexPath: self.indexPath, selected: !self.selectButton.isSelected)
            if btnSelected == true {
                self.selectButton.isSelected = !self.selectButton.isSelected
            }
        }
    }
}
