//
//  DeletedUserVC.swift
//  Makent
//
//  Created by trioangle on 02/09/22.
//  Copyright © 2022 Vignesh Palanivel. All rights reserved.
//

import UIKit

class DeletedUserVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var reasonOne: UILabel!
    
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var reasonTwo: UILabel!
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let isRTL = Language.getCurrentLanguage().isRTL
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
       
    }
    
    class func initWithStory() -> DeletedUserVC{
        return UIStoryboard.init(name: "MakentMainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DeletedUserVC") as! DeletedUserVC
    }
    func initLayout() {
        backbutton.setTitle("", for: .normal)
        backbutton.transform = isRTL ? CGAffineTransform(rotationAngle: .pi) : .identity
        imageHolderView.elevated(width: 1, height: 1, cornerRadius: 25, shadowColor: .lightGray, shadowOpacity: 0.3)
        let attributedString = NSMutableAttributedString(string: lang.deleteUser6)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 10 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        // *** Set Attributed String to your label ***
        titleLbl.attributedText = attributedString
        reasonOne.text = lang.deleteUser1
        reasonTwo.text = lang.deleteUser2
        contactLbl.text = lang.deleteUser7
        
        
        
        
        
    }
    @IBAction func didTapBackBtn(_ sender: Any) {
        if self.isPresented() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
