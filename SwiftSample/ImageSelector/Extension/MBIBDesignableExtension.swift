/**
 * MBIBDesignableExtension.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */



import UIKit

extension UILabel{
    @IBInspectable var textHexColor: NSString {
        get {
            return "0xffffff";
        }
        set {
            let scanner = Scanner(string: newValue as String)
            var hexNum = 0 as UInt32
            
            if (scanner.scanHexInt32(&hexNum)){
                let r = (hexNum >> 16) & 0xFF
                let g = (hexNum >> 8) & 0xFF
                let b = (hexNum) & 0xFF
                
                self.textColor = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
            }
        }
    }
}

extension UIButton{
    @IBInspectable var textHexColor: NSString {
        get {
            return "0xffffff";
        }
        set {
            let scanner = Scanner(string: newValue as String)
            var hexNum = 0 as UInt32
            
            if (scanner.scanHexInt32(&hexNum)){
                let r = (hexNum >> 16) & 0xFF
                let g = (hexNum >> 8) & 0xFF
                let b = (hexNum) & 0xFF
                
                self.setTitleColor(UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0), for: .normal)
            }
        }
    }
}

extension UIView{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var hexRgbColor: NSString {
        get {
            return "0xffffff";
        }
        set {
            
            let scanner = Scanner(string: newValue as String)
            var hexNum = 0 as UInt32
            
            if (scanner.scanHexInt32(&hexNum)){
                    let r = (hexNum >> 16) & 0xFF
                    let g = (hexNum >> 8) & 0xFF
                    let b = (hexNum) & 0xFF
                
                    self.backgroundColor = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
            }
            
        }
    }
    
    @IBInspectable var onePx: Bool {
        get {
            return true
        }
        set {
            if (onePx == true){
                self.frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width:self.frame.size.width, height:1 / UIScreen.main.scale)
            }
        }
    }
}
