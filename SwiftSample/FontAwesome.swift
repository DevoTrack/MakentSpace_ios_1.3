/**
 * FontAwesome.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import CoreText

// MARK: - Public

/// A FontAwesome extension to UIFont.
public extension UIFont {

    /// Get a UIFont object of FontAwesome.
    ///
    /// - parameter ofSize: The preferred font size.
    /// - returns: A UIFont object of FontAwesome.
    public class func fontAwesome(ofSize fontSize: CGFloat) -> UIFont {
        let name = "FontAwesome"
        if UIFont.fontNames(forFamilyName: name).isEmpty {
            FontLoader.loadFont(name)
        }

        return UIFont(name: name, size: fontSize)!
    }
}

/// A FontAwesome extension to String.
public extension String {

    /// Get a FontAwesome icon string with the given icon name.
    ///
    /// - parameter name: The preferred icon name.
    /// - returns: A string that will appear as icon with FontAwesome.
    public static func fontAwesomeIcon(name: FontAwesome) -> String {
        return name.rawValue.substring(to: name.rawValue.characters.index(name.rawValue.startIndex, offsetBy: 1))
    }

    /// Get a FontAwesome icon string with the given CSS icon code. Icon code can be found here: http://fontawesome.io/icons/
    ///
    /// - parameter code: The preferred icon name.
    /// - returns: A string that will appear as icon with FontAwesome.
    public static func fontAwesomeIcon(code: String) -> String? {

        guard let name = self.fontAwesome(code: code) else {
            return nil
        }

      return self.fontAwesomeIcon(name: name)
    }

    /// Get a FontAwesome icon with the given CSS icon code. Icon code can be found here: http://fontawesome.io/icons/
    ///
    /// - parameter code: The preferred icon name.
    /// - returns: An internal corresponding FontAwesome code.
    public static func fontAwesome(code: String) -> FontAwesome? {

        guard let raw = FontAwesomeIcons[code], let icon = FontAwesome(rawValue: raw) else {
            return nil
        }

        return icon
    }
}

/// A FontAwesome extension to UIImage.
public extension UIImage {

    /// Get a FontAwesome image with the given icon name, text color, size and an optional background color.
    ///
    /// - parameter name: The preferred icon name.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: A string that will appear as icon with FontAwesome
    public static func fontAwesomeIcon(name: FontAwesome, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear) -> UIImage {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center

        // Taken from FontAwesome.io's Fixed Width Icon CSS
        let fontAspectRatio: CGFloat = 1.28571429

        let fontSize = min(size.width / fontAspectRatio, size.height)
        let attributedString = NSAttributedString(string: String.fontAwesomeIcon(name: name), attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.fontAwesome(ofSize: fontSize), convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): textColor, convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor): backgroundColor, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph]))
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) / 2, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /// Get a FontAwesome image with the given icon css code, text color, size and an optional background color.
    ///
    /// - parameter code: The preferred icon css code.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: A string that will appear as icon with FontAwesome
    public static func fontAwesomeIcon(code: String, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear) -> UIImage? {
        guard let name = String.fontAwesome(code: code) else { return nil }
        return fontAwesomeIcon(name: name, textColor: textColor, size: size, backgroundColor: backgroundColor)
    }
}

// MARK: - Private

private class FontLoader {
    class func loadFont(_ name: String) {
        let bundle = Bundle(for: FontLoader.self)
        let identifier = bundle.bundleIdentifier

        var fontURL: URL
        if identifier?.hasPrefix("org.cocoapods") == true {
            // If this framework is added using CocoaPods, resources is placed under a subdirectory
            fontURL = bundle.url(forResource: name, withExtension: "otf", subdirectory: "FontAwesome.swift.bundle")!
        } else {
            fontURL = bundle.url(forResource: name, withExtension: "otf")!
        }
        let data = try! Data(contentsOf: fontURL)
        let provider = CGDataProvider(data: data as CFData)
        let font = CGFont(provider!)

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font!, &error) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
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
