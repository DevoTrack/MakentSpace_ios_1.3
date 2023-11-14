/**
* ProgressHud.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/



import UIKit
import Foundation

class ProgressHud : UIViewController
{
    @IBOutlet var imgLoader: UIImageView!
    @IBOutlet var viewLoader: UIView!
    @IBOutlet var activityLoader: UIActivityIndicatorView!
    
    
    var timerAnimate = Timer()
    var getImgVal:Int = 0
    var isShowLoaderAnimaiton:Bool = false
//    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        getImgVal = 0
        imgLoader.image = UIImage(named: "loading_01")?.withRenderingMode(.alwaysTemplate)
        imgLoader.tintColor = UIColor.appHostThemeColor
        self.spinAnimation(strImgName: "loading_01")
        
        
        if isShowLoaderAnimaiton
        {
            viewLoader.isHidden = false
            timerAnimate = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ProgressHud.onModifyImage), userInfo: nil, repeats: true)
            
            timerAnimate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ProgressHud.expireTimer), userInfo: nil, repeats: true)
        }
        else
        {
            activityLoader.center = self.view.center
            viewLoader.isHidden = true
            let transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            activityLoader.transform = transform;
        }
        viewLoader.layer.cornerRadius = 8.0
    }
    
    @objc func expireTimer()
    {
//        timerAnimate.invalidate()
//        self.view.removeFromSuperview()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerAnimate.invalidate()
    }
    
    func makeLoaderAnimaiton()
    {
//        for i in 0 ..< 3
//        {
//        }
    }
    
    func spinAnimation(strImgName:String)
    {
        var rotationAnimation: CABasicAnimation
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationAnimation.toValue = Int(.pi * 2.0 * 1 * 1)
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 200
        imgLoader.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    
    @objc func onModifyImage()
    {
        if getImgVal==0
        {
            imgLoader.image = UIImage(named: "loading_02")?.withRenderingMode(.alwaysTemplate)
            getImgVal=1
        }
        else if getImgVal==1 {
            imgLoader.image = UIImage(named: "loading_03")?.withRenderingMode(.alwaysTemplate)
            getImgVal=2

        }
        else if getImgVal==2 {
            imgLoader.image = UIImage(named: "loading_04")?.withRenderingMode(.alwaysTemplate)
            getImgVal=3

        }
        else {
            imgLoader.image = UIImage(named: "loading_01")?.withRenderingMode(.alwaysTemplate)
            getImgVal=1

        }
    }
}

