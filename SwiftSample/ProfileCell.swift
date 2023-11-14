/**
* ProfileCell.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet var lblName: UILabel?
    @IBOutlet var imgSetting: UIImageView?
    let lang = Language.getCurrentLanguage()
    func setData()
    {
        let rect = UIScreen.main.bounds as CGRect
        
        var rectEmailView = self.frame
        rectEmailView.size.width = rect.size.width-20
        rectEmailView.origin.x = 10
        self.frame = rectEmailView
        imgSetting?.transform = lang.getAffine
        lblName?.textAlignment = lang.getTextAlignment(align: .left)
        
//        lblName?.text = "Mani"
    }
}
