//
//  Utilities.swift
//  Makent
//
//  Created by trioangle on 07/02/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10
public enum closureActions : Int{
    case none = 0
    case tap = 1
    case swipe_left = 2
    case swipe_right = 3
    case swipe_down = 4
    case swipe_up = 5
}
public struct closure {
    typealias emptyCallback = ()->()
    static var actionDict = [Int:[closureActions : emptyCallback]]()
    static var btnActionDict = [Int:[String: emptyCallback]]()
}

class Utilities: NSObject {
    
    var window: UIWindow?
    
    static let sharedInstance = Utilities()
    
    let lang = Language.getCurrentLanguage().rawValue
    
    class func showAlertMessage(message: String, onView: UIViewController) {
        let lang = Language.getCurrentLanguage().getLocalizedInstance()
        let alertController = UIAlertController(title: k_AppName, message: message, preferredStyle: .alert)
        let action2 = UIAlertAction(title: lang.ok_Title, style: .default) { (action:UIAlertAction) in
            alertController.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(action2)
        onView.present(alertController, animated: true, completion: nil)
        
    }
    
    //Mark:- Instant Book Symbol
    static func attributeForInstantBook(normalText:String , boldText: String , fontSize : CGFloat) -> NSMutableAttributedString{
        
        
        let attrs1 = [NSAttributedString.Key.font : UIFont (name: Fonts.CIRCULAR_BOOK, size: fontSize), NSAttributedString.Key.foregroundColor : UIColor.black]
            
        
            
        let attrs3 = [NSAttributedString.Key.font : UIFont (name: Fonts.CIRCULAR_BOLD, size: fontSize), NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont (name: Fonts.MAKENT_LOGO_FONT1, size: fontSize-2), NSAttributedString.Key.foregroundColor : Constants.instantBookColor]
        
//        if Language.getCurrentLanguage().rawValue == "en"{
            let attributedString1 = NSMutableAttributedString(string:normalText, attributes:attrs1)
            
            let attributedString2 = NSMutableAttributedString(string:"G", attributes:attrs2)
            
            let attributedString3 = NSMutableAttributedString(string:boldText, attributes:attrs3)
            
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString2)
            
            return attributedString1
//        }else{
//            let attributedString1 = NSMutableAttributedString(string:normalText, attributes:attrs1)
//
//            let attributedString2 = NSMutableAttributedString(string:"G", attributes:attrs2)
//
//            let attributedString3 = NSMutableAttributedString(string:boldText, attributes:attrs3)
//
//            attributedString2.append(attributedString3)
//            attributedString2.append(attributedString1)
//
//            return attributedString2
//        }
//
        
    }
    
    static func attributeForWishInstantBook(normalText:String , spaceName:String ,boldText: String , fontSize : CGFloat, isFirst : Bool) -> NSMutableAttributedString{
            
            
            let attrs1 = [NSAttributedString.Key.font : UIFont (name: Fonts.CIRCULAR_BOOK, size: fontSize), NSAttributedString.Key.foregroundColor : UIColor.black]

            let attrs2 = [NSAttributedString.Key.font :  UIFont (name: Fonts.MAKENT_LOGO_FONT1, size: fontSize), NSAttributedString.Key.foregroundColor : Constants.instantBookColor]
        
            let attrs3 = [NSAttributedString.Key.font : UIFont (name: Fonts.CIRCULAR_BOOK, size: fontSize), NSAttributedString.Key.foregroundColor : UIColor.black]
        
            let attrs4 = [NSAttributedString.Key.font : UIFont (name: Fonts.CIRCULAR_BOLD, size: fontSize), NSAttributedString.Key.foregroundColor : UIColor.black]
            
            
        let attributedString1 = NSMutableAttributedString(string:normalText, attributes:attrs1 as [NSAttributedString.Key : Any])
                
        let attributedString2 = NSMutableAttributedString(string:"G", attributes:attrs2 as [NSAttributedString.Key : Any])
        let attributedString3 = NSMutableAttributedString(string:spaceName, attributes:attrs3 as [NSAttributedString.Key : Any])
        let attributedString4 = NSMutableAttributedString(string:boldText, attributes:attrs4 as [NSAttributedString.Key : Any])
        
        
                attributedString1.append(attributedString2)
                attributedString3.append(attributedString4)
                attributedString1.append(attributedString3)
                
        if isFirst{
            return attributedString1
        }else{
            return attributedString3
        }
                
  
        }
    
    //Mark:- Instant Book Symbol For Map Filter
    static func attributeForInstantBookMap(normalText:String , boldText: String , fontSize : CGFloat) -> NSMutableAttributedString{
        
        
        let attrs1 = [NSAttributedString.Key.font : UIFont (name: Fonts.CIRCULAR_LIGHT, size: fontSize), NSAttributedString.Key.foregroundColor : UIColor.black]
        
        
        
        let attrs3 = [NSAttributedString.Key.font : UIFont (name: Fonts.CIRCULAR_BOLD, size: fontSize), NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let attrs2 = [NSAttributedString.Key.font :  UIFont (name: Fonts.MAKENT_LOGO_FONT1, size: fontSize), NSAttributedString.Key.foregroundColor : Constants.instantBookColor]
        
        let attributedString1 = NSMutableAttributedString(string:normalText, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:"G", attributes:attrs2)
        
        let attributedString3 = NSMutableAttributedString(string:boldText, attributes:attrs3)
        
        if Language.getCurrentLanguage().rawValue == "ar"{
            attributedString2.append(attributedString3)
            attributedString2.append(attributedString1)
            return attributedString2
        }else{
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString2)
            return attributedString1
        }
        // attributedString1.append(attributedString3)
        
    }
    
    func setBorderColor (view: UIView) {
        view.clipsToBounds = true
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getCountryPhonceCode (_ country : String) -> String
    {
        var countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
        if countryDictionary[country] != nil {
            return countryDictionary[country]!
        }
        else {
            return ""
        }
        
    }
    
    func getCurrencySymbolFromCountryCode(code: String) -> String {
        return NSLocale(localeIdentifier: code).displayName(forKey: NSLocale.Key.currencySymbol, value: code) ?? ""
    }
    
    func createToastMessage(_ strMessage:String, isSuccess: Bool, viewController:UIViewController)
    {
        let lblMessage=UILabel(frame: CGRect(x: 0, y: (viewController.view.frame.size.height)+70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70))
        lblMessage.tag = 500
        lblMessage.text = strMessage
        lblMessage.textColor = (isSuccess) ? UIColor.darkGray : UIColor.red
        lblMessage.backgroundColor = UIColor.white
        lblMessage.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: CGFloat(15))
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
        lblMessage.layer.shadowColor = UIColor.black.cgColor;
        lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
        lblMessage.layer.shadowOpacity = 0.5;
        lblMessage.layer.shadowRadius = 1.0;
        moveLabelToYposition(lblMessage, viewController: viewController)
        UIApplication.shared.keyWindow?.addSubview(lblMessage)
    }
    
    func moveLabelToYposition(_ lblView:UILabel, viewController:UIViewController)
    {
        //        let rectImg = imgMakentIcon.frame;
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            lblView.frame = CGRect(x: 0, y: (viewController.view.frame.size.height)-70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3, delay: 3.5, options: UIView.AnimationOptions(), animations: { () -> Void in
                lblView.frame = CGRect(x: 0, y: (viewController.view.frame.size.height)+70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
            }, completion: { (finished: Bool) -> Void in
                lblView.removeFromSuperview()
            })
        })
    }
    
    func makeCurrencySymbols(encodedString : String) -> String {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
    
    func addShadowToSearchView(view:UIView,radius:CGFloat,shadowRadius:CGFloat,ShadowColor:UIColor,shadowOpacity:Float)
    {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = radius
        // if you like rounded corners
        
        view.layer.shadowOffset = CGSize(width: CGFloat(-0.5), height: CGFloat(0.5))
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowColor = ShadowColor.cgColor
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    func addShadowToView(view:UIView,radius:CGFloat,ShadowColor:UIColor,shadowOpacity:Float)
    {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = radius
        // if you like rounded corners
        view.layer.shadowOffset = CGSize(width: CGFloat(-0.5), height: CGFloat(0.5))
        
        view.layer.shadowRadius = radius
        
        view.layer.shadowOpacity = shadowOpacity
        
        view.layer.shadowColor = ShadowColor.cgColor
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    func addShadowToMapView(view:UIView,radius:CGFloat,ShadowColor:UIColor,shadowOpacity:Float)
    {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = radius
        // if you like rounded corners
        view.layer.shadowOffset = CGSize(width: CGFloat(-0.5), height: CGFloat(0.5))
        
        view.layer.shadowRadius = view.frame.width / 2
        
        view.layer.shadowOpacity = shadowOpacity
        
        view.layer.shadowColor = ShadowColor.cgColor
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    func setRatingImage(rating: Float) -> UIImage {
        print("@ rating values is  :",rating)
        if rating >= 0.5 && rating < 1.0 {
            return UIImage(named: "star0.5") ?? UIImage()
        }
        else if rating >= 1.0 && rating < 1.5 {
            return UIImage(named: "star1.0") ?? UIImage()
        }
        else if rating >= 1.5 && rating < 2.0 {
            return UIImage(named: "star1.5") ?? UIImage()
        }
        else if rating >= 2.0 && rating < 2.5 {
            return UIImage(named: "star2.0") ?? UIImage()
        }
        else if rating >= 2.5 && rating < 3.0 {
            return UIImage(named: "star2.5") ?? UIImage()
        }
        else if rating >= 3.0 && rating < 3.5 {
            return UIImage(named: "star3.0") ?? UIImage()
        }
        else if rating >= 3.5 && rating < 4.0 {
            return UIImage(named: "star3.5") ?? UIImage()
        }
        else if rating >= 4.0 && rating < 4.5 {
            return UIImage(named: "star4.0") ?? UIImage()
        }
        else if rating >= 4.5 && rating < 5.0 {
            return UIImage(named: "star4.5") ?? UIImage()
        }
        else if rating == 5.0 {
            return UIImage(named: "star5.0") ?? UIImage()
        }
        else {
             return UIImage(named: "star0.0") ?? UIImage()
        }
       
    }
    
    func randomColor(seed: String) -> UIColor {
        
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    func staticColours() -> UIColor {
        let colours = [UIColor.red,UIColor.blue,UIColor.green,UIColor.magenta,UIColor.orange,UIColor.brown,UIColor.purple,]
        guard let randomcolour = colours.randomElement() else {return UIColor.appHostThemeColor}
        return randomcolour
        }
    
    func confirmAsInt(value:Any?) -> Int{
        return Int(("\(String(describing: value ?? "0"))" as NSString).intValue)
    }
    
    func unWrapDictArray(value:Any?) -> [[String:Any]] {
        return value as? [[String:Any]] ?? [[String:Any]]()
    }
    
    
    func getJsonFormattedString(_ params: Any)-> String {
        var jsonParamString = String()
        var jsonParamDict = [String:Any]()
        do {
            if #available(iOS 11.0, *) {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
                // here "jsonData" is the dictionary encoded in JSON data
                
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                // here "decoded" is of type `Any`, decoded from JSON data
                
                // you can now cast it with the right type
                if let dictFromJSON = decoded as? [String:Any] {
                    // use dictFromJSON
                    print(dictFromJSON)
                    jsonParamString = "\(decoded)"
                    jsonParamDict = decoded as! [String : Any]
                    
                }
                do {
                    let data1 =  try JSONSerialization.data(withJSONObject: decoded, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                    jsonParamString = String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
                    print("JsonParamString:",jsonParamString)
                } catch let myJSONError {
                    print(myJSONError)
                }
            } else {
                // Fallback on earlier versions
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
        let test = String(jsonParamString.filter({!"\r".contains($0)}))
        //            String(jsonParamString.filter { !" \n\t\r".contains($0) })
        return test
    }

}
extension String{
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        
        guard let characterSpacing = characterSpacing else {return attributedString}
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
   
    
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension UIViewController:UIGestureRecognizerDelegate {
    
    var rawVal : String {
        return Language.getCurrentLanguage().rawValue
    }
    
   
    
    @objc func keyboardWillShow1(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide1(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func addtapEnd(){
       
        self.view.addTap {
            self.view.endEditing(true)
        }
    }
//
//    func getJsonFormattedString(_ params: Any)-> String {
//        var jsonParamString = String()
//        var jsonParamDict = [String:Any]()
//        do {
//            if #available(iOS 11.0, *) {
//                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
//                // here "jsonData" is the dictionary encoded in JSON data
//
//                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                // here "decoded" is of type `Any`, decoded from JSON data
//
//                // you can now cast it with the right type
//                if let dictFromJSON = decoded as? [String:Any] {
//                    // use dictFromJSON
//                    print(dictFromJSON)
//                    jsonParamString = "\(decoded)"
//                    jsonParamDict = decoded as! [String : Any]
//
//                }
//                do {
//                    let data1 =  try JSONSerialization.data(withJSONObject: decoded, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//                    jsonParamString = String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
//                    print(jsonParamString)
//                } catch let myJSONError {
//                    print(myJSONError)
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//
//
//        } catch {
//            print(error.localizedDescription)
//        }
//        let test = String(jsonParamString.filter({!" \n\t\r".contains($0)}))
////            String(jsonParamString.filter { !" \n\t\r".contains($0) })
//        return test
//    }
    
    
    
    func jsonToString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
//    func getJsonFormattedString(_ params: Any)-> String {
//        var jsonParamString = String()
//        var jsonParamDict = [String:Any]()
//        do {
//            if #available(iOS 11.0, *) {
//                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
//                // here "jsonData" is the dictionary encoded in JSON data
//
//                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                // here "decoded" is of type `Any`, decoded from JSON data
//
//                // you can now cast it with the right type
//                if let dictFromJSON = decoded as? [String:Any] {
//                    // use dictFromJSON
//                    print(dictFromJSON)
//                    jsonParamString = "\(decoded)"
//                    jsonParamDict = decoded as! [String : Any]
//
//                }
//                do {
//                    let data1 =  try JSONSerialization.data(withJSONObject: decoded, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//                    jsonParamString = String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
//                    print(jsonParamString)
//                } catch let myJSONError {
//                    print(myJSONError)
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//
//
//        } catch {
//            print(error.localizedDescription)
//        }
//        let test = String(jsonParamString.filter { !" \n\t\r".contains($0) })
//        return test
//    }
    func addDismissButton() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "Back")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (backDismissClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func backDismissClick(sender : UIButton) {
            self.dismiss(animated: true, completion: nil)
    }
    
    func addBackButton() {
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "Back")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.transform = self.getAffine
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func datesRange() -> [String] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        
        var array: [String] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm a"
        
        let startDate = "19-08-2018 11:00 PM"
        let endDate = "21-08-2018 12:00 AM"
        
        let date1 = formatter.date(from: startDate)
        let date2 = formatter.date(from: endDate)
        
        var i = 1
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*60*60))
            let string = formatter2.string(from: date!)
            
            if date! >= date2! {
                break;
            }
            
            i += 1
            array.append(string)
        }
        array.append("11:59 PM")
        print(array)
        
        return array
    }
    
    func DateDisplay(_ date:Date)->String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    func TimeDisplay(_ date:Date)->String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "hh:mm:ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func EndTimeDisplay(_ startDate:Date)->String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: 1, to: startDate)
        let myString = formatter.string(from: date!) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "hh:mm:ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    @objc func backButtonClick(sender : UIButton) {
        if !self.isPresented() {
            self.navigationController?.popViewController(animated: true)
           // self.dismiss(animated: true, completion: nil)
        }else {
           // self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkArabicNumbers(numberStr:String)->Int {
        //let NumberStr: String = "٢٠١٨-٠٦-٠٤"
        let Formatter = NumberFormatter()
        if rawVal == "ar"{
        Formatter.locale = NSLocale(localeIdentifier: "ar") as! Locale
        }else{
        Formatter.locale = NSLocale(localeIdentifier: "en") as! Locale
        }
        if let final = Formatter.number(from: numberStr.replacingOccurrences(of: "+", with: "")) {
            print(final)
            return final.intValue
        }
        return 0
    }
    
    func addbackButton(sender:UIButton,senderTitle:String,senderFontName:String, fontSize:CGFloat=20.0) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = k_AlphaThemeColor
        sender.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        sender.setTitleColor(k_AlphaThemeColor, for: .normal)
        sender.setTitle(senderTitle, for: .normal)
        
        let backButtonItem = UIBarButtonItem(customView: sender)
        let currWidthA = backButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidthA?.isActive = true
        let currHeightA = backButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeightA?.isActive = true
        sender.titleLabel?.font = UIFont(name: senderFontName, size: fontSize)
        
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    func addNavigationButtons(sender:[UIButton],senderTitle:[String],senderFontName:[String],senderTitleColor:[UIColor], fontSize:CGFloat=20.0) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = k_AlphaThemeColor
        sender[0].frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        //        let rightButtonWidth = senderTitle[1].count * 10
        sender[1].frame = CGRect(x: self.view.frame.width - 25, y: 0.0, width:  60, height: 20.0)
        if sender.count > 2 {
            sender[1].frame = CGRect(x: self.view.frame.width - 25, y: 0.0, width: 20.0, height: 20.0)
            sender[2].frame = CGRect(x: self.view.frame.width - 60, y: 0.0, width: 20.0, height: 20.0)
        }
        for index in 0...sender.count - 1 {
            sender[index].setTitleColor(senderTitleColor[index], for: .normal)
            sender[index].setTitle(senderTitle[index], for: .normal)
            sender[index].titleLabel?.font = UIFont(name: senderFontName[index], size: fontSize)
        }
        for barIndex in 0...sender.count - 1  {
            
            if barIndex == 0 {
                let backButtonItem = UIBarButtonItem(customView: sender[barIndex])
                let currWidthA = backButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24)
                currWidthA?.isActive = true
                let currHeightA = backButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24)
                currHeightA?.isActive = true
                self.navigationItem.leftBarButtonItem = backButtonItem
            }
            else if barIndex == 2 {
                let backButtonItem = UIBarButtonItem(customView: sender[1])
                let currWidthA = backButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24)
                currWidthA?.isActive = true
                let currHeightA = backButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24)
                currHeightA?.isActive = true
                let backButtonItem1 = UIBarButtonItem(customView: sender[2])
                let currWidthA1 = backButtonItem1.customView?.widthAnchor.constraint(equalToConstant: 24)
                currWidthA1?.isActive = true
                let currHeightA1 = backButtonItem1.customView?.heightAnchor.constraint(equalToConstant: 24)
                currHeightA1?.isActive = true
                self.navigationItem.rightBarButtonItems = [backButtonItem,backButtonItem1]
            } else {
                let backButtonItem = UIBarButtonItem(customView: sender[barIndex])
                let currWidthA = backButtonItem.customView?.widthAnchor.constraint(equalToConstant: 60)
                currWidthA?.isActive = true
                let currHeightA = backButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24)
                currHeightA?.isActive = true
                self.navigationItem.rightBarButtonItem = backButtonItem
            }
        }
    }
    
}



typealias JSONS = [String: Any]

extension Dictionary where Dictionary == JSONS{
    var statusCode : Int{
        return Int(self["status_code"] as? String ?? String()) ?? Int()
    }
    var isSuccess : Bool{
        return statusCode != 0
    }
    var statusMessage:String {
        if let message =  self["status_message"] as? String, !message.isEmpty{
            return message
        }
        return self["success_message"] as? String ?? String()
        
    }
    func value<T>(forKeyPath path : String) -> T?{
        var keys = path.split(separator: ".")
        var childJSON = self
        let lastKey : String
        if let last = keys.last{
            lastKey = String(last)
        }else{
            lastKey = path
        }
        keys.removeLast()
        for key in keys{
            childJSON = childJSON.json(String(key))
        }
        return childJSON[lastKey] as? T
    }
    func array<T>(_ key : String) -> [T]{
        return self[key] as? [T] ?? [T]()
    }
    func array(_ key : String) -> [JSONS]{
        return self[key] as? [JSONS] ?? [JSONS]()
    }
    func json(_ key : String) -> JSONS{
        return self[key] as? JSONS ?? JSONS()
    }
    
    func string(_ key : String)-> String{
        // return self[key] as? String ?? String()
        let value = self[key]
        if let str = value as? String{
            return str
        }else if let int = value as? Int{
            return int.description
        }else if let double = value as? Double{
            return double.description
        }else{
            return String()
        }
    }
    func nsString(_ key: String)-> NSString {
        return self.string(key) as NSString
    }
    func int(_ key : String)-> Int{
        //return self[key] as? Int ?? Int()
        let value = self[key]
        if let str = value as? String{
            return Int(str) ?? Int()
        }else if let int = value as? Int{
            return int
        }else if let double = value as? Double{
            return Int(double)
        }else{
            return Int()
        }
    }
    func double(_ key : String)-> Double{
        //return self[key] as? Double ?? Double()
        let value = self[key]
        if let str = value as? String{
            return Double(str) ?? Double()
        }else if let int = value as? Int{
            return Double(int)
        }else if let double = value as? Double{
            return double
        }else{
            return Double()
        }
    }
    
    func bool(_ key:String) -> Bool {
        if let bool = self[key] as? Bool {
            return bool
        }
        else  {
            if let str = self[key] as? String {
                return str.updateToBool()
            }
            return false
        }
    }
    
    
}

enum StoryBoard
{
    
    case main
    case guest
    case host
    case Space
    case Spacehostlist
    case detail
    case account
    
    var instance : UIStoryboard {
        switch self {
        case .main:
            return UIStoryboard(name: "Main", bundle: nil)
        case .guest:
            return UIStoryboard(name: "MakentCars", bundle: nil)
        case .host:
            return UIStoryboard(name: "HostRoomList", bundle: nil)
        case .Space:
            return UIStoryboard(name: "SpaceListing", bundle: nil)
        case .Spacehostlist:
            return UIStoryboard(name: "HostListStep", bundle: nil)
        case .detail:
            return UIStoryboard(name: "DetailDescription", bundle: nil)
        case .account:
            return UIStoryboard(name: "Account", bundle: nil)
        default:
            return UIStoryboard(name: "Main", bundle: nil)
        }
    }
}
extension UILabel{
//    func autoresize() {
//        if let textNSString: NSString = self.text as NSString? {
//            let rect = textNSString.boundingRect(with: CGSizeMake(self.frame.size.width, CGFloat.max),
//                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                                                 attributes: [NSAttributedString.Key.font: self.font],
//                                                         context: nil)
//            self.frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y,width: self.frame.size.width,height: rect.height)
//        }
//    }
    
    func DescFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 18.0)
        self.numberOfLines = 0
        self.textColor = .darkGray
    }
    func TitleFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOLD, size: 18.0)
        self.numberOfLines = 0
        self.textColor = .black
    }
    
    func TextFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 12.0)
        self.numberOfLines = 0
        self.textAlignment = .center
        self.textColor = .black
    }
    func textHourFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 11.0)
        self.numberOfLines = 0
        self.textAlignment = .center
        self.textColor = .black
    }
    
    func textHourTitleFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOLD, size: 20.0)
        self.numberOfLines = 0
        self.textAlignment = .center
        self.textColor = .black
    }
    
    func TextTitleFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 18.0)
        self.numberOfLines = 0
        self.textColor = .black
    }
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
extension UITextField{
    
    func TextTitleFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 15.0)
        self.textColor = .black
    }
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let lang = Language.getCurrentLanguage().getLocalizedInstance()
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: lang.done_Title, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
extension UITextView{
   
    func TextTitleFont(){
        self.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 15.0)
        self.textColor = .black
    }
    
        @IBInspectable var doneAccessory: Bool{
            get{
                return self.doneAccessory
            }
            set (hasDone) {
                if hasDone{
                    addDoneButtonOnKeyboard()
                }
            }
        }
    func placeHolder(_ index: Int, holdVal : String) {
        self.textColor = .lightGray
        //let newIndex = index + 1
        self.text =  holdVal
    }
    
    func placeTextHolder( holdVal : String) {
        self.textColor = .lightGray
        self.text = holdVal
    }
    
        func addDoneButtonOnKeyboard()
        {
            let lang = Language.getCurrentLanguage().getLocalizedInstance()
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: lang.done_Title, style: .done, target: self, action: #selector(self.doneButtonAction))
            
            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            
            self.inputAccessoryView = doneToolbar
        }
        
    @objc func doneButtonAction()
        {
            self.resignFirstResponder()
        }
    
}
extension UITableView {
   
    func setEmptyMessage(title:String,subTitle: String,attriSubTitle: String,attriSubTitleColor: UIColor,removeFilterButton:UIButton, imageWidth: CGFloat, imageHeight: CGFloat) {
       
        let messageView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        let emptyView = UIView()
        emptyView.frame = CGRect(x: 0, y: 0, width: messageView.frame.width, height: self.bounds.size.height/4 * 2)
        let resultnoImageView = UIImageView()
        resultnoImageView.frame = CGRect(x: emptyView.frame.size.width/4 + ((emptyView.frame.size.width/4)*2 - imageWidth)/2, y: 0, width: imageWidth, height: imageHeight)
        
        //        resultnoImageView.backgroundColor = UIColor.cyan
//        resultnoImageView.image = removeFilterButton
        resultnoImageView.image = nil
        let resultLabel = UILabel()
        if imageWidth == 50 {
            resultLabel.frame = CGRect(x: 0, y: Int(resultnoImageView.frame.height + resultnoImageView.frame.origin.y) + 50, width: Int(emptyView.frame.width), height: 20)
        } else {
            resultLabel.frame = CGRect(x: 0, y: Int(resultnoImageView.frame.height + resultnoImageView.frame.origin.y) + 10, width: Int(emptyView.frame.width), height: 20)
        }
        //        resultLabel.frame = CGRect(x: 0, y: Int(resultnoImageView.frame.height + resultnoImageView.frame.origin.y) + 10, width: Int(emptyView.frame.width), height: 20)
        resultLabel.text = title
        resultLabel.font = UIFont(name: k_ApplicationFontBook, size: 16)
        let resultDescriptionLabel = UILabel()
        resultDescriptionLabel.numberOfLines = 0
        if resultLabel.text == "" {
            resultDescriptionLabel.frame = CGRect(x: 0, y: Int(resultnoImageView.frame.height + resultnoImageView.frame.origin.y) + 10, width: Int(emptyView.frame.width) , height: 70)
        } else {
            resultDescriptionLabel.frame = CGRect(x: 0, y: Int(resultLabel.frame.origin.y) + 15, width: Int(emptyView.frame.width) , height: 70)
        }
        
        
        
        //        resultDescriptionLabel.frame = CGRect(x: 0, y: Int(resultLabel.frame.height + resultnoImageView.frame.height ) + 10, width: Int(emptyView.frame.width) , height: 70)
        resultDescriptionLabel.text = subTitle
        resultDescriptionLabel.font = UIFont(name: k_ApplicationFontBook, size: 14)
        resultDescriptionLabel.textColor = UIColor.darkGray
        let strName = subTitle
        let string_to_color2 = attriSubTitle
        let attributedString1 = NSMutableAttributedString(string:strName)
        let range2 = (strName as NSString).range(of: string_to_color2)
        let lang = Language.getCurrentLanguage().getLocalizedInstance()
//        attributedString1.addAttribute(.font, value: UIFont(name: k_ApplicationFontBold, size: 16)!, range: range2)
//        attributedString1.addAttribute(NSAttributedStringKey.foregroundColor, value: attriSubTitleColor , range: range2)
        resultDescriptionLabel.attributedText = attributedString1
        
        removeFilterButton.frame = CGRect(x: 0, y: Int(resultDescriptionLabel.frame.height + resultDescriptionLabel.frame.origin.y) + 10, width: 200, height: 50)
        removeFilterButton.center = emptyView.center
        removeFilterButton.setTitle(lang.remfilt_Tit, for: .normal)
        removeFilterButton.setTitleColor(UIColor.appGuestThemeColor, for: .normal)
        removeFilterButton.clipsToBounds = true
        removeFilterButton.layer.borderColor = UIColor.appGuestThemeColor.cgColor
        removeFilterButton.layer.borderWidth = 2.0
        removeFilterButton.layer.cornerRadius = 2.0
        
        
        emptyView.addSubview(resultnoImageView)
        emptyView.addSubview(resultLabel)
        emptyView.addSubview(resultDescriptionLabel)
        emptyView.addSubview(removeFilterButton)
        
        resultLabel.textAlignment = .center
        resultDescriptionLabel.textAlignment = .center
        
        messageView.addSubview(emptyView)
        emptyView.center = messageView.center
        self.backgroundView = messageView
    }
    func restore() {
        self.backgroundView = nil
    }
}

extension Dictionary {
    mutating func merge(dict:[Key:Value]) {
        for (k,v) in dict {
            self[k] = v
            //updateValue(v, forKey: k)
        }
    }
}
extension UINavigationController {
    func popViewControllerWithHandler(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    func pushView(viewController: UIViewController){
        self.pushViewController(viewController, animated: true)
    }
    func pushViewController(viewController: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    static var progressBar = UIProgressView(progressViewStyle: .bar)
    
    func addProgress(){
        
        self.navigationBar.barTintColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        let progressBar = UINavigationController.progressBar
        progressBar.frame = CGRect(x: 0, y: 0, width: self.navigationBar.frame.width, height: 3)
        progressBar.tintColor = UIColor.init(hex: "FF0F29")
        progressBar.setProgress(0.0, animated: true)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
        self.navigationBar.addSubview(progressBar)
        
    }
    func removeProgress(){
        UINavigationController.progressBar.removeFromSuperview()
    }
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
    @objc func backAct(){
        self.navigationController?.popViewController(animated: true)
    }
}
extension Int {
    var boolValue: Bool { return self != 0 }
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension UIView {
    func addCenterView(centerView:UIView) {
        _ = centerView.frame
        centerView.frame = self.frame
        self.addSubview(centerView)
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveLinear, animations: {
            centerView.center = self.center
        }) { (hide) in
        }
    }
    
    func BorderView(){
        
//        self.layer.cornerRadius = 5
//        self.isElevated = true
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.borderWidth = 1.0
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
    }
    
    func addCenterViewHideTableView(centerView:UIView) {
        _ = centerView.frame
        self.addSubview(centerView)
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveLinear, animations: {
            centerView.center = self.center
        }) { (hide) in
            if let tableView = self.subviews.compactMap({$0 as? UITableView}).first {
                tableView.isHidden = hide
            }
        }
    }
    
    func addFooterView(footerView:UIView) {
        var frame = footerView.frame
        frame = CGRect(x: 0, y: self.frame.height - footerView.frame.height, width: self.frame.width, height: footerView.frame.height)
        footerView.frame = frame
        self.addSubview(footerView)
        self.endEditing(true)
        footerView.frame.origin.y += footerView.frame.height
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveLinear, animations: {
            var frame = footerView.frame
            frame = CGRect(x: 0, y: self.frame.height - footerView.frame.height, width: self.frame.width, height: footerView.frame.height)
            footerView.frame = frame
            self.layoutIfNeeded()
        }) { (hide) in
            if let tableView = self.subviews.compactMap({$0 as? UITableView}).first {
                tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.width, height: tableView.frame.height - footerView.frame.height)
            }
        }
    }
    
    
    func removeAddedSubview(view:UIView) {
        if self.subviews.contains(view) {
            view.removeFromSuperview()
        }
    }
    
   
    func addBottomView(bottomView:UIView) {
        
        if !self.subviews.contains(bottomView) {
            var frame = bottomView.frame
            let notch = UIDevice.current.hasNotch
            if notch {
                frame = CGRect(x: 0, y: (self.frame.height - (bottomView.frame.height+75)), width: self.frame.width, height: bottomView.frame.height)
            } else {
                frame = CGRect(x: 0, y: (self.frame.height - (bottomView.frame.height+30)), width: self.frame.width, height: bottomView.frame.height)
            }
            bottomView.frame = frame
            self.addSubview(bottomView)
            self.bringSubviewToFront(bottomView)
        }
        
        bottomView.isHidden = false
    }
    
    func removeBottomView(bottomView:UIView) {
        bottomView.isHidden = true
        bottomView.removeFromSuperview()
    }
        
   
    
}
extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        return (keyWindow?.safeAreaInsets.bottom ?? 0) > 0
    }
}

extension UIScrollView {
    @objc func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

public extension UIView{
    var closureId:Int{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func actionHandleBlocks(_ type : closureActions = .none,action:(() -> Void)? = nil) {
        
        if type == .none{
            return
        }
        //        print("∑type : ",type)
        var actionDict : [closureActions : closure.emptyCallback]
        if self.closureId == Int(){
            self.closureId = closure.actionDict.count + 1
            closure.actionDict[self.closureId] = [:]
        }
        if action != nil {
            actionDict = closure.actionDict[self.closureId]!
            actionDict[type] = action
            closure.actionDict[self.closureId] = actionDict
        } else {
            let valueForId = closure.actionDict[self.closureId]
            if let exe = valueForId![type]{
                exe()
            }
        }
    }
    
    @objc public func triggerTapActionHandleBlocks() {
        self.actionHandleBlocks(.tap)
    }
    @objc public func triggerSwipeLeftActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_left)
    }
    @objc public func triggerSwipeRightActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_right)
    }
    @objc public func triggerSwipeUpActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_up)
    }
    @objc public func triggerSwipeDownActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_down)
    }
    
    @objc func OnOffAct(_ swt : UISwitch){
        
        swt.isOn = !swt.isOn
    }
    
    public func addTap(Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    public func addAction(for type: closureActions ,Action action:@escaping() -> Void){
        
        self.isUserInteractionEnabled = true
        self.actionHandleBlocks(type,action:action)
        switch type{
        case .none:
            return
        case .tap:
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_left:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .left
            
            gesture.addTarget(self, action: #selector(triggerSwipeLeftActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_right:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .right
            gesture.addTarget(self, action: #selector(triggerSwipeRightActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_up:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .up
            gesture.addTarget(self, action: #selector(triggerSwipeUpActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_down:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .down
            gesture.addTarget(self, action: #selector(triggerSwipeDownActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        }
        
        
    }
}


extension String {
    
    static func format(strings: [String],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = UIColor.blue,
                    inString string: String,
                    font: UIFont = UIFont.systemFont(ofSize: 14),
                    color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                    attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
    
    func getDateFormattedString()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        //        let date =
        
        
        return self
    }
    
    func toInt()->Int {
        let number = (self as? NSString ?? "0").integerValue
        return number
    }
    
    func updateToBool()-> Bool {
        if self.capitalized == "Yes" {
            return true
        }
        return false
    }
    
    
}

extension Bool {
    func updateToString()->String {
        if !self {
            return "No"
        }
        return "Yes"
    }
}


extension UIViewController {
    
    
    
    func coloredAttributedText(normal Text:String,_ attributedText:String) -> NSAttributedString{
    
    // create the attributed colour
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.init(name: Fonts.CIRCULAR_BOOK, size: 17.0)]
        let boldFontAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.darkText, NSAttributedString.Key.font: UIFont.init(name: Fonts.CIRCULAR_BOOK, size: 16.0)]
       
    // create the attributed string
    let attributedString = NSAttributedString(string: attributedText, attributes: boldFontAttributes)
        
    // create the attributed string
    let normalString = NSAttributedString(string: Text + " ", attributes: boldFontAttributes1)
    let combination = NSMutableAttributedString()
        
    combination.append(normalString)
    combination.append(attributedString)
    return combination
    }
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "h:mm a"

        return dateFormatter.string(from: dt!)
    }

    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"

        return dateFormatter.string(from: dt!)
    }
    
    func datesHourRange(from: String, to: String,isFromAMPM:Bool = false,isDateSec:Bool = false) -> [String] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        print("AmisDateSec",isFromAMPM,isDateSec)
        let dateFormat = DateFormatter()
        if !isFromAMPM {
            if isDateSec{
                dateFormat.dateFormat = "HH:mm:ss"
            }else{
                dateFormat.dateFormat = "HH:mm"
            }
           
        }else {
            if isDateSec{
                 dateFormat.dateFormat = "HH:mm:ss"
                if let date = dateFormat.date(from: from){
                  dateFormat.dateFormat = "HH:mm:ss"
                }else{
                  dateFormat.dateFormat = "hh:mm a"
                }
            }else{
                dateFormat.dateFormat = "hh:mm a"
            }

        }
        
        if from > to {
            
             dateFormat.dateFormat = "hh:mm a"
            if let startTime = dateFormat.date(from: from), let endTime = dateFormat.date(from: to), startTime.compare(endTime) == .orderedAscending
            {
                print(dateFormat.string(from: startTime))
            }else {
                return [String]()
            }
            
            
        }
        
       
        var tempDate = dateFormat.date(from: from) ?? Date()
        let last = dateFormat.date(from: to) ?? Date()
        //Mark:- Adding Time List Array
        var array = [String]()
        dateFormat.dateFormat = "hh:mm a"
        while tempDate <= last {
            
            let strDate = dateFormat.string(from: tempDate)
            array.append(strDate)
            tempDate = Calendar.current.date(byAdding: .hour, value: 1, to: tempDate)!
        }
        let strDate = dateFormat.string(from: last)
        array.append(strDate)
        
        return array
    }
    
    
    
}
/*if !isFromAMPM {
 if isDateSec{
 dateFormat.dateFormat = "HH:mm:ss"
 }else{
 dateFormat.dateFormat = "HH:mm"
 }
 
 }else {
 if isDateSec{
 
 dateFormat.dateFormat = "hh:mm a"
 }else{
 dateFormat.dateFormat = "HH:mm:ss"
 }
 
 }*/
