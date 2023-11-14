//
//  YTTransition.swift
//  Makent
//
//  Created by trioangle on 30/11/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class YTAnimation {
    private var deleteBtnFlag = false
    private var rotateAniFlag = false

    class func vibrateAnimation(_ AniView: UIView?) {
        let rvibrateAni = CAKeyframeAnimation()
        rvibrateAni.keyPath = "transform.rotation"
        let angle: CGFloat = (Double.pi) / 18
        rvibrateAni.values = [NSNumber(value: Float(-angle)), NSNumber(value: Float(angle)), NSNumber(value: Float(-angle))]
        rvibrateAni.repeatCount = MAXFLOAT
        rvibrateAni.duration = 1.5
        AniView?.layer.add(rvibrateAni, forKey: "shake")
    }
}
