/**
* MakentSupport.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
//import ifaddrs

class MakentSupport: NSObject {
    var userDefaults = UserDefaults.standard
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static let instance = MakentSupport()
    
    func onGetCurrentBGColor() -> UIColor{
        let backgroundColor = userDefaults.integer(forKey: "bgcolors")
        var color = UIColor()
        if(backgroundColor==111)
        {
            color = UIColor(red:(30/255.0), green:(118/255.0), blue:(197/255.0), alpha:1.00)
        }
        else if(backgroundColor==222)
        {
            color = UIColor(red:(102/255.0), green:(102/255.0), blue:(153/255.0), alpha:1.00)
        }
        else if(backgroundColor==333)
        {
            color = UIColor(red:(0/255.0), green:(151/255.0), blue:(149/255.0), alpha:1.00);
        }
        else if(backgroundColor==444)
        {
            color = UIColor(red:(185/255.0), green:(8/255.0), blue:(76/255.0), alpha:1.00)
        }
        else if(backgroundColor==555)
        {
            color = UIColor(red:(151/255.0), green:(56/255.0), blue:(143/255.0), alpha:1.00)
        }
        else if(backgroundColor==666)
        {
            color = UIColor(red:(119/255.0), green:(155/255.0), blue:(75/255.0), alpha:1.00)
        }
        else if(backgroundColor==777)
        {
            color = UIColor(red:(3/255.0), green:(121/255.0), blue:(161/255.0), alpha:1.00)
        }
        else if(backgroundColor==888)
        {
            color = UIColor(red:(170/255.0), green:(70/255.0), blue:(92/255.0), alpha:1.00)
        }
        else if(backgroundColor==999)
        {
            color = UIColor(red:(197/255.0), green:(58/255.0), blue:(10/255.0), alpha:1.00)
        }
        else if(backgroundColor==101010)
        {
            color = UIColor(red:(166/255.0), green:(93/255.0), blue:(89/255.0), alpha:1.00)
        }
        else if(backgroundColor==111111)
        {
            color = UIColor(red:(255/255.0), green:(0/255.0), blue:(128/255.0), alpha:1.00)
        }
        else if(backgroundColor==121212)
        {
            color = UIColor(red:(215/255.0), green:(66/255.0), blue:(60/255.0), alpha:1.00)
        }
        else if(backgroundColor==131313)
        {
            color = UIColor(red:(96/255.0), green:(60/255.0), blue:(187/255.0), alpha:1.00)
        }
        else if(backgroundColor==141414)
        {
            color = UIColor(red:(184/255.0), green:(150/255.0), blue:(112/255.0), alpha:1.00)
        }
        else if(backgroundColor==151515)
        {
            color = UIColor(red:(75/255.0), green:(199/255.0), blue:(207/255.0), alpha:1.00)
        }
        else if(backgroundColor==161616)
        {
            color = UIColor(red:(250/255.0), green:(70/255.0), blue:(129/255.0), alpha:1.00)
        }
        else if(backgroundColor==171717)
        {
            color = UIColor(red:(95/255.0), green:(167/255.0), blue:(120/255.0), alpha:1.00)
        }
        else if(backgroundColor==181818)
        {
            color = UIColor(red:(255/255.0), green:(83/255.0), blue:(73/255.0), alpha:1.00)
        }
        else if(backgroundColor==191919)
        {
            color = UIColor(red:(166/255.0), green:(166/255.0), blue:(166/255.0), alpha:1.00)
        }
        else if(backgroundColor==202020)
        {
            color = UIColor(red:(214/255.0), green:(82/255.0), blue:(30/255.0), alpha:1.00)
        }
        else if(backgroundColor==212121)
        {
            color = UIColor(red:(151/255.0), green:(154/255.0), blue:(170/255.0), alpha:1.00)
        }
        else if(backgroundColor==222222)
        {
            color = UIColor(red:(221/255.0), green:(122/255.0), blue:(43/255.0), alpha:1.00);
        }
        else if(backgroundColor==232323)
        {
            color = UIColor(red:(29/255.0), green:(138/255.0), blue:(207/255.0), alpha:1.00)
        }
        else if(backgroundColor==242424)
        {
            color = UIColor(red:(255/255.0), green:(84/255.0), blue:(112/255.0), alpha:1.00)
        }
        else if(backgroundColor==252525)
        {
            color = UIColor(red:(0/255.0), green:(0/255.0), blue:(0/255.0), alpha:1.00)
        }
        return color
    }
    
    
    //MARK: SET DOT LOADER GIF
    func setDotLoader(animatedLoader:FLAnimatedImageView)
    {
        if let path =  Bundle.main.path(forResource: "dot_loading", ofType: "gif")
        {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                animatedLoader.animatedImage = gif
            }
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validateZipCode(strZipCode:String) -> Bool
    {
        let postcodeRegex: String = "^[0-9]{6}$"
        let postcodeValidate : NSPredicate = NSPredicate(format: "SELF MATCHES %@", postcodeRegex)
        if postcodeValidate.evaluate(with: strZipCode) == true {
            return true
        }
        else {
            return false
        }
    }
    
    func isNetworkRechable(_ viewctrl : UIViewController) -> Bool
    {
        if !YSSupport.isNetworkRechable()
        {
//            let myView = AlertView.init(frame: CGRect(x: 0, y:5, width: viewctrl.view.frame.size.width ,height: 50), andViewId: "100", andDelegate: viewctrl as! ViewOfflineDelegate)
//            myView.delegateView = viewctrl as? ViewOfflineDelegate
//            viewctrl.view.addSubview(myView.returnView())
            return false
        }
        else
        {
            return true
        }
    }
    
    func checkNetworkIssue(_ viewctrl : UIViewController, errorMsg: String) -> Bool
    {
        if !YSSupport.isNetworkRechable()
        {
//            let myView = AlertView.init(frame: CGRect(x: 0, y:467.0, width: viewctrl.view.frame.size.width ,height: 50), andViewId: "100", andDelegate: viewctrl as! ViewOfflineDelegate)

//            let myView = AlertView.init(frame: CGRect(x: 0, y:viewctrl.view.frame.size.height - ((appDelegate.makentTabBarCtrler.view.isHidden) ? 150 : 200), width: viewctrl.view.frame.size.width ,height: 50), andViewId: "100", andDelegate: viewctrl as! ViewOfflineDelegate)
//            myView.delegateView = viewctrl as? ViewOfflineDelegate
//            viewctrl.view.addSubview(myView.returnView())
            
//            UIView.animate(withDuration: 1.3, animations: { () -> Void in
//                myView.showView()
//            })

            return false
        }
        else if errorMsg.count > 0
        {
            appDelegate.createToastMessage(errorMsg, isSuccess: false)
            return false
        }
        else
        {
            return true
        }
    }
    
    //MARK: Check Param Type
    func checkParamTypes(params:NSDictionary, keys:NSString) -> NSString
    {
        if let latestValue = params[keys] as? NSString {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? String {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? Int {
            return String(format:"%d",latestValue) as NSString
        }
        else if (params[keys] as? NSNull) != nil {
            return ""
        }
        else
        {
            return ""
        }
    }
    
    func showProgress(viewCtrl:UIViewController , showAnimation:Bool)
    {
        
        let viewProgress = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
//        let viewProgress = viewCtrl.storyboard?.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        viewProgress.isShowLoaderAnimaiton = showAnimation
        viewProgress.view.tag = Int(123456)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = true
        viewCtrl.view.addSubview(viewProgress.view)
    }
    
    func removeProgress(viewCtrl:UIViewController)
    {
        viewCtrl.view.viewWithTag(Int(123456))?.removeFromSuperview()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = true
    }
    
    func showProgressInWindow(viewCtrl:UIViewController , showAnimation:Bool)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
        let viewProgress = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
//        let viewProgress = viewCtrl.storyboard?.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        viewProgress.isShowLoaderAnimaiton = showAnimation
        //        viewProgress.willMove(toParentViewController: viewCtrl)
        viewProgress.view.tag = Int(123456)
        appDelegate.window?.isUserInteractionEnabled = true
        appDelegate.window?.addSubview(viewProgress.view)
    }
    
    func removeProgressInWindow(viewCtrl:UIViewController)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        DispatchQueue.main.async {
            if ((appDelegate.window?.viewWithTag(Int(123456))?.isDescendant(of: appDelegate.window!))!){
            appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
            appDelegate.window?.isUserInteractionEnabled = true
            }
        }

    }

    
    func runSpinAnimation(view: UIView, duration: CGFloat, rotations: CGFloat, repeatcounts : Float) {
        var rotationAnimation: CABasicAnimation?
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationAnimation!.toValue = Int(.pi * 2.0 * rotations * duration)
        rotationAnimation!.duration = CFTimeInterval(duration)
        rotationAnimation!.isCumulative = true
        rotationAnimation!.repeatCount = repeatcounts
        view.layer.add(rotationAnimation!, forKey: "rotationAnimation")
    }
    
    func makeViewAnimaiton(viewObj:UIView) {
        //        let rectImg = imgMakentIcon.frame;
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
            viewObj.frame = CGRect(x: 0, y: viewObj.frame.origin.y,width: viewObj.frame.size.width ,height: viewObj.frame.size.height)
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    func isPad() -> Bool
    {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom)
        {
        case .pad:
            return true
        case .phone:
            return false
        default:
            break
        }
        return false
    }
    
    
    func getScreenSize() -> CGRect
    {
        var rect = UIScreen.main.bounds as CGRect
        let orientation = UIApplication.shared.statusBarOrientation as UIInterfaceOrientation

        if MakentSupport().isPad()
        {
            if(orientation.isLandscape)
            {
                rect = CGRect(x: 0, y:0,width: 1024 ,height: 768)
            }
            else
            {
                rect = CGRect(x: 0, y:0,width: 768 ,height: 1024)
            }
        }
        return rect
    }
    
    func makeSquareBorderLayer(btnLayer:UIButton)
    {
        btnLayer.layer.borderColor = UIColor.darkGray.cgColor
        btnLayer.layer.borderWidth = 1.0
        btnLayer.layer.cornerRadius = 5
    }
    
    func makeSquareBorder(btnLayer:UIButton , color:UIColor , radius:CGFloat)
    {
        btnLayer.layer.borderColor = color.cgColor
        btnLayer.layer.borderWidth = 1.0
        btnLayer.layer.cornerRadius = radius
    }

    func keyboardWillShowOrHide(keyboarHeight: CGFloat , btnView : UIButton)
    {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            let rect = self.getScreenSize()
            btnView.frame.origin.y = (rect.size.height) - btnView.frame.size.height - keyboarHeight - ((self.isPad()) ? 30 : 20)
        })
    }
    
    func keyboardWillShowOrHideForView(keyboarHeight: CGFloat , btnView : UIView)
    {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            let rect = self.getScreenSize()
            btnView.frame.origin.y = (rect.size.height) - btnView.frame.size.height - keyboarHeight - 0
        })
    }

    func getAttributedString(originalText: NSString, arrtributeText: String) -> NSMutableAttributedString
    {
        let mainString: NSMutableAttributedString = NSMutableAttributedString(string: originalText as String)
        let range = originalText.range(of: arrtributeText)
        mainString.addAttribute(NSAttributedString.Key.font, value:  UIFont (name: Fonts.CIRCULAR_BOLD, size: 18)!, range: NSRange(location: range.location, length: arrtributeText.count))
        return mainString
    }
    
    func getBigAndNormalString(originalText : NSString ,normalText : NSString, attributeText : NSString , font : UIFont) -> NSMutableAttributedString
    {
        let mainString: NSMutableAttributedString = NSMutableAttributedString(string: originalText as String)
        let range = originalText.range(of: attributeText as String)
        mainString.addAttribute(NSAttributedString.Key.font, value:  UIFont (name: Fonts.CIRCULAR_BOOK, size: 18)!, range: NSMakeRange(range.location, attributeText.length))
        return mainString
    }
    
    func getUnderLineString(originalText : NSString) -> NSMutableAttributedString
    {
        let mainString: NSMutableAttributedString = NSMutableAttributedString(string: originalText as String)
        return mainString
    }
    
    func makeAttributeTextColor(originalText : NSString ,normalText : NSString, attributeText : NSString , font : UIFont) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):font]))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appTitleColor, range: NSMakeRange(normalText.length, attributeText.length))
        
        return attributedString
    }
    func makeAttributeTextColorWithBold(originalText : NSString ,normalText : NSString, attributeText : NSString , boldText: String , fontSize : CGFloat) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize)!]))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appTitleColor, range: NSMakeRange(normalText.length, attributeText.length))
        
        let boldFontAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont (name: Fonts.CIRCULAR_BOLD, size: fontSize)!]
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(boldFontAttribute), range: originalText.range(of: boldText))
      
        return attributedString
    }
    
    
    
    
    func makeHostAttributeTextColor(originalText : NSString ,normalText : NSString, attributeText : NSString , font : UIFont) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):font]))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), range: NSMakeRange(normalText.length, attributeText.length))

        return attributedString
    }
    
    func makeExperienceTitleAppBlueColor(originalText : NSString ,normalText : NSString, attributeText : NSString , fontSize : CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize)!]))
        let instantFontAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):  UIFont (name: Fonts.MAKENT_LOGO_FONT1, size: fontSize)!]
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 31/255, green: 144/255, blue: 147/255, alpha: 1.0), range: originalText.range(of: originalText as String))
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(instantFontAttribute), range: originalText.range(of: "G"))
        return attributedString
    }
   

    func createRatingStar(ratingValue : NSString) -> NSString
    {
        //U -> Fullstar Y -> half star V -> empty star
        let rangeYours = ratingValue.range(of: ".")
        if rangeYours.location != NSNotFound
        {
            
        }
        if ratingValue == "0"
        {
            return "VVVVV"
        }
        
        let arrRating = ratingValue.components(separatedBy: ".")
        var strStar = ""
        let rateFloat = ratingValue.floatValue
        if arrRating.count == 1
        {
            if arrRating[0] == "1"
            {
                strStar = "UVVVV"
            }
            else if arrRating[0] == "2"
            {
                strStar = "UUVVV"
            }
            else if arrRating[0] == "3"
            {
                strStar = "UUUVV"
            }
            else if arrRating[0] == "4"
            {
                strStar = "UUUUV"
            }
            else if arrRating[0] == "5"
            {
                strStar = "UUUUU"
            }
        }
        else
        {
            if ratingValue == "0.5" || rateFloat < 0.5
            {
                strStar = "YVVVV"
            }
            else if ratingValue == "1.5" || rateFloat < 1.5
            {
                strStar = "UYVVV"
            }
            else if ratingValue == "2.5" || rateFloat < 2.5
            {
                strStar = "UUYVV"
            }
            else if ratingValue == "3.5" || rateFloat < 3.5
            {
                strStar = "UUUYV"
            }
            else if ratingValue == "4.5" || rateFloat < 4.5
            {
                strStar = "UUUUV"
            }
        }
        return strStar as NSString
    }
    
    func attributedText(originalText: NSString, boldText: String , fontSize : CGFloat)->NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize)!]))
        
        let boldFontAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont (name: Fonts.CIRCULAR_BOLD, size: fontSize)!]
        
        // Part of string to be bold
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(boldFontAttribute), range: originalText.range(of: boldText))
        
        return attributedString
    }

    
    func attributedConversationText(originalText: NSString,normalText: NSString,textColor: UIColor, boldText: NSString , fontSize : CGFloat)->NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize)!]))
        
        let boldFontAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize - 4)!]
//        print(originalText.length,normalText.length, boldText.length)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor.withAlphaComponent(0.7), range: NSMakeRange(normalText.length+2, boldText.length))

        // Part of string to be bold
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(boldFontAttribute), range: NSMakeRange(normalText.length+2, boldText.length))

        return attributedString
    }

    
    func attributedInstantBookText(originalText: NSString, boldText: String , fontSize : CGFloat)->NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize)!]))
        
        let boldFontAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont (name: Fonts.CIRCULAR_BOLD, size: fontSize)!]
        let instantFontAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):  UIFont (name: Fonts.MAKENT_LOGO_FONT1, size: fontSize)!]
        // Part of string to be bold
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(boldFontAttribute), range: originalText.range(of: boldText))
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(instantFontAttribute), range: originalText.range(of: "G"))

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), range: NSMakeRange(0, 1))

        return attributedString
    }
    
    func attributedTextboldText(originalText: NSString, boldText: String , fontSize : CGFloat)->NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize-8)!]))
        
        let boldFontAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont (name: Fonts.CIRCULAR_BOLD, size: fontSize)!]
        
        // Part of string to be bold
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(boldFontAttribute), range: originalText.range(of: boldText))
        
        return attributedString
    }
    
    func addAttributeFont(originalText: String,attributedText: String,attributedFontName:String,attributedColor:UIColor,attributedFontSize:CGFloat) -> NSMutableAttributedString {
        let strName = originalText
        let string_to_color2 = attributedText
        let attributedString1 = NSMutableAttributedString(string:strName)
        let range2 = (strName as NSString).range(of: string_to_color2)
        attributedString1.addAttribute(NSAttributedString.Key.font, value: UIFont(name: attributedFontName, size: attributedFontSize) as Any, range: range2)
        attributedString1.addAttributes(convertToNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: attributedFontName, size: UIFont.labelFontSize) as Any,convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):attributedColor]), range: range2)
        return attributedString1
    }
    
    func addAttributeText(originalText: String,attributedText: String,attributedColor:UIColor) -> NSMutableAttributedString {
        let strName = originalText
        let string_to_color2 = attributedText
        let attributedString1 = NSMutableAttributedString(string:strName)
        let range2 = (strName as NSString).range(of: string_to_color2)
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: attributedColor, range: range2)
        
        return attributedString1
    }
    


    func makeGradientColor(gradientView:UIView)
    {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = gradientView.bounds
        let color1 = UIColor(red: 0.0 / 255.0, green: 163.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0).cgColor as CGColor
        let color2 = UIColor(red: 0.0 / 255.0, green: 124.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0).cgColor as CGColor
        let color3 = UIColor(red: 0.0 / 255.0, green: 124.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0).cgColor as CGColor
        let color4 = UIColor(red: 0.0 / 255.0, green: 124.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0).cgColor as CGColor
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 1.0]
        let radient = (0)/225.0 * M_PI_2
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat(radient), 0, 0, 1)
        
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func onGetCurrentTextColor() -> UIColor
    {
        let textColor = userDefaults.integer(forKey: "textcolors")

        var color = UIColor()
        if(textColor==1111)
        {
            color = UIColor(red:(255/255.0), green:(255/255.0), blue:(255/255.0), alpha:1.00);
        }
        else if(textColor==2222)
        {
            color = UIColor(red:(0/255.0), green:(0/255.0), blue:(0/255.0), alpha:1.00);
        }
        return color
    }
    
    func onGetFontAndStyle()-> UIFont
    {
        return UIFont(name: onGetCurrentFontStyleName(), size: onGetCurrentTextSize())!
    }
    
    func onGetCurrentTextSize() -> CGFloat
    {
        let textColor = userDefaults.float(forKey: "fontsize")
        return CGFloat(textColor)
    }
    
    func onGetCurrentFontStyleName() -> String
    {
        let fontName = userDefaults.value(forKey: "fontname")
        return fontName as! String
    }
    
    func onGetStringHeight(_ width:CGFloat, strContent:NSString, font:UIFont) -> CGFloat
    {
        let sizeOfString = strContent.boundingRect( with: CGSize(width: width, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): font]), context: nil).size
        return sizeOfString.height
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    // MARK: Convert Currency Code to Symbol
    func getSymbolForCurrencyCode(code: NSString) -> NSString?
    {
        let locale = NSLocale(localeIdentifier: code as String)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) as NSString?
    }
    
}

extension UIImageView {
    func addRemoteImage(imageURL: String,placeHolderURL: String,isRound: Bool=false) {
        if isRound {
            self.layer.cornerRadius = self.frame.size.width / 2
            self.clipsToBounds = true
        }
        self.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: placeHolderURL))
            //.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: placeHolderURL))
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension UILabel {
    func customFont(_ name:CustomFont,textColor:UIColor = UIColor.darkGray) {
        self.font = UIFont(name: name.instance, size: self.font.pointSize)
        self.textColor = textColor
    }
    func AlignText(){
        self.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
    }
}

enum CustomFont {
    case bold
    case light
    case medium
    var instance:String {
        switch self {
        case .bold:
            return Fonts.CIRCULAR_BOLD
        case .light:
            return Fonts.CIRCULAR_LIGHT
        case .medium:
            return Fonts.CIRCULAR_BOOK
        }
    }
}
