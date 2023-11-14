/**
 * MLImagePickerGroupCell.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */


import UIKit

class MLImagePickerGroupCell: UITableViewCell {

    @IBOutlet weak var assetCountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var selectedImgV: UIImageView!
    var selectedStatus:Bool! = false {
        didSet{
            self.selectedImgV.isHidden = !self.selectedStatus
            self.selectedImgV.image = UIImage.ml_imageFromBundleNamed(named: "zl_star");
        }
    }
    
}
