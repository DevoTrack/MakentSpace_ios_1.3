//
//  PriceMarkerView.swift
//  Makent
//
//  Created by trioangle on 10/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class PriceMarkerView : UIView{
    
    @IBOutlet weak var backgroundHolderView : UIView!		
//    @IBOutlet weak var titleLabel : UILabel!
    lazy var titleLabel : UILabel = {
        let lable = UILabel()
        lable.frame = self.bounds
        lable.backgroundColor = .clear
        lable.textColor = .black
        lable.text = ""
        lable.font = UIFont(name: "AvenirNext-Medium", size: 12)
        lable.textAlignment = .center
        return lable
    }()
    private var bubbleLayer : CAShapeLayer?
    var isSelected : Bool{
        get{return self.titleLabel.textColor == UIColor.white}
        set{
            self.setSelected(newValue)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    class func initNibView(_ frame : CGRect) -> PriceMarkerView{
        let nib = UINib(nibName: "PriceMarkerView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! PriceMarkerView
        
        view.frame = frame
        
        view.addSubview(view.titleLabel)
        view.bringSubviewToFront(view.titleLabel)
        return view
    }
    func setPrice(_ value : String){
        self.titleLabel.attributedText = nil
        self.titleLabel.text = value
    }
    func setAttributePrice(_ value : NSAttributedString){
        self.titleLabel.text = ""
        self.titleLabel.attributedText = value
    }
    private func setSelected(_ value : Bool){//
        if self.bubbleLayer == nil{
            self.bubbleLayer = self.getBubleLayer()
        }
        self.bubbleLayer?.fillColor = (value ? UIColor.appGuestThemeColor : .white).cgColor
        if !(self.layer.sublayers?.contains(self.bubbleLayer!))! {
            bubbleLayer?.removeFromSuperlayer()
            
            self.backgroundHolderView.layer.addSublayer(self.bubbleLayer!)
//            self.layer.insertSublayer(self.titleLabel.layer, above: bubbleLayer)
        }
        self.titleLabel.textColor = value ? .white : UIColor.appGuestThemeColor

        
    }
    private func getBubleLayer() -> CAShapeLayer{
        let bezierPath = UIBezierPath()
        let arrowHeight : CGFloat = 4
        let arrowWidth : CGFloat = 3
        let curve : CGFloat = 3
        let elevation : CGFloat = 1
        
        /*
         * Ignore the beizer coding
         * Alter above values for changing the appearance
         * and for color go down and edit buble layer shadow color
         */
        bezierPath.move(to: CGPoint(x: 0 + curve * 2,
                                    y: 0))
        
        bezierPath.addLine(to: CGPoint(x: (self.frame.width / 2) ,
                                       y: 0))
     
        bezierPath.addLine(to: CGPoint(x: (self.frame.width - curve * 2),
                                       y: 0))
        bezierPath.addCurve(to: CGPoint(x: self.frame.width,
                                        y: 0 + curve * 2),
                            controlPoint1: CGPoint(x: self.frame.width - curve,
                                                   y: 0 ),
                            controlPoint2: CGPoint(x: self.frame.width  ,
                                                   y: 0 ))
        
        bezierPath.addLine(to: CGPoint(x: self.frame.width,
                                       y: self.frame.height - curve * 2 - arrowHeight))
        bezierPath.addCurve(to: CGPoint(x: self.frame.width - curve * 2,
                                        y: self.frame.height - arrowHeight),
                            controlPoint1: CGPoint(x: self.frame.width,
                                                   y: self.frame.height - curve - arrowHeight),
                            controlPoint2: CGPoint(x: self.frame.width  ,
                                                   y: self.frame.height - arrowHeight))
        bezierPath.addLine(to: CGPoint(x: self.frame.width / 2 + arrowWidth,
                                       y: self.frame.height - arrowHeight))
        bezierPath.addLine(to: CGPoint(x: self.frame.width / 2,
                                       y: self.frame.height))
        bezierPath.addLine(to: CGPoint(x: self.frame.width / 2 - arrowWidth,
                                       y: self.frame.height - arrowHeight))
        bezierPath.addLine(to: CGPoint(x: 0 + curve * 2,
                                       y: self.frame.height - arrowHeight))
        bezierPath.addCurve(to: CGPoint(x: 0,
                                        y: self.frame.height - curve * 2 - arrowHeight),
                            controlPoint1: CGPoint(x: 0 + curve,
                                                   y: self.frame.height - arrowHeight),
                            controlPoint2: CGPoint(x: 0  ,
                                                   y: self.frame.height - arrowHeight))
        
        bezierPath.addLine(to: CGPoint(x: 0,
                                       y: 0 + curve * 2 ))
        bezierPath.addCurve(to: CGPoint(x: 0 + curve * 2,
                                        y: 0),
                            controlPoint1: CGPoint(x: 0,
                                                   y: 0 + curve),
                            controlPoint2: CGPoint(x: 0  ,
                                                   y: 0 ))
        
        bezierPath.close()
        
        let bubleLayer = CAShapeLayer()
        bubleLayer.path = bezierPath.cgPath
        bubleLayer.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.frame.width,
                                  height: self.frame.height)
        
        bubleLayer.fillColor = UIColor.appGuestThemeColor.cgColor
        bubleLayer.masksToBounds = false
        bubleLayer.shadowColor = UIColor.black.cgColor
        bubleLayer.shadowOffset = CGSize(width: 0, height: elevation)
        bubleLayer.shadowRadius = elevation
        bubleLayer.shadowOpacity = 1
        return bubleLayer
        
    }
    
}
