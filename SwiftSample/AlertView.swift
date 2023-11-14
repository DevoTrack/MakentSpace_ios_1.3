/**
* AlertView.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
//import ifaddrs


protocol ViewOfflineDelegate
{
    func RetryTapped()
}

class AlertView : UIView
{
    var delegateView : ViewOfflineDelegate?
    
    init(frame: CGRect, andViewId viewId: String, andDelegate delegate: ViewOfflineDelegate)
    {
        super.init(frame: frame)
        self.delegateView = delegate
        let viewHolder:UIView = UIView()
        viewHolder.frame =  frame
        viewHolder.backgroundColor = UIColor.red
        
        let lblInfo:UILabel = UILabel()
        lblInfo.frame =  CGRect(x: 20, y:5, width: viewHolder.frame.size.width-80 ,height: 40)
        lblInfo.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 15)
        
        lblInfo.attributedText = self.makeAttributeTextColor(originalText: "Error: You are currently offline", normalText: "You are currently offline" as NSString, attributeText: "Error: ", font: lblInfo.font)
        lblInfo.textAlignment = NSTextAlignment.left
        lblInfo.textColor = UIColor.darkGray
        viewHolder.addSubview(lblInfo)
        
        let btnRetry = UIButton(type: .custom)
        btnRetry.frame =  CGRect(x: self.frame.size.width - 60, y:5, width: 60 ,height: 40)
        btnRetry.titleLabel?.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 15)
        btnRetry.setTitle("Retry", for: .normal)
        btnRetry.setTitle("Retry", for: .highlighted)
        btnRetry.setTitleColor(UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0), for: .normal)
        btnRetry.setTitleColor(UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0), for: .highlighted)
        btnRetry.addTarget(self, action: #selector(self.onRetryTapped), for: UIControl.Event.touchUpInside)
        viewHolder.addSubview(btnRetry)
        self.addSubview(viewHolder)
        
    }
    
    func returnView() -> UIView
    {
        return self
    }
    
    func showAlert()
    {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @objc func onRetryTapped()
    {
        delegateView?.RetryTapped()
        self.removeFromSuperview()
    }
    
    func makeAttributeTextColor(originalText : NSString ,normalText : NSString, attributeText : NSString , font : UIFont) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):font]))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, attributeText.length))
        
        return attributedString
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
