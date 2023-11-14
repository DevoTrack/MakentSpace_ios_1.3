/**
 * ML+UIViewExtension.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */



import UIKit

var messageLbl:UILabel!

extension UIView{    
    func showWatting(str:String){
        self.isUserInteractionEnabled = false
        
        let width:CGFloat = 180
        let height:CGFloat = 35
        let x:CGFloat = (self.frame.width - width) * 0.5
        let y:CGFloat = (self.frame.height - height) * 0.5
        
        let messageLblFrame = CGRect(x: 0,y: 0,width: width,height: height)
        
        if messageLbl != nil && (messageLbl.frame.equalTo(messageLblFrame) == true) {
            UIView.animate(withDuration: 0.35, animations: { () -> Void in
                messageLbl!.alpha = 1.0
            })
        }else {
            messageLbl = UILabel(frame: CGRect(x: 0,y: 0,width: width,height: height))
            messageLbl.layer.masksToBounds = true
            messageLbl.layer.cornerRadius = 5.0
            messageLbl.textAlignment = .center
            messageLbl.text = str
            messageLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            messageLbl.textColor = UIColor.white
            self.addSubview(messageLbl)
        }
    }
    
    func hideWatting(){
        self.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.35) { () -> Void in
            messageLbl.alpha = 0.0
        }
    }
}
