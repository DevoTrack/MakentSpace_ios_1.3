/**
 * FontAwesomeView.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit

/// A view for FontAwesome icons.
@IBDesignable public class FontAwesomeView : UIView {

    @IBInspectable
    public var iconCode:String = "" {
        didSet{
          self.iconView.text = String.fontAwesomeIcon(code: iconCode)
        }
    }

    private var iconView = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override public func prepareForInterfaceBuilder() {
        setupViews()
    }

    /// Add a UILabel subview containing FontAwesome icon
    func setupViews() {
        // Fits icon in the view
        self.iconView.textAlignment = NSTextAlignment.center
        self.iconView.text = String.fontAwesomeIcon(code: self.iconCode)
        self.iconView.textColor = self.tintColor
        self.addSubview(iconView)
    }

    override public func tintColorDidChange() {
        self.iconView.textColor = self.tintColor
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.iconView.font = UIFont.fontAwesome(ofSize: bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height)
        self.iconView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: bounds.size.width, height: bounds.size.height))
    }
}
