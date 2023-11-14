/**
 * ML+UIImageExtension.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */



import UIKit

extension UIImage{
    class func ml_imageFromBundleNamed(named:String)->UIImage{
        let image = UIImage(named: "MLImagePickerController.bundle".appendingFormat("/"+(named as String)))!
        return image
    }
}
