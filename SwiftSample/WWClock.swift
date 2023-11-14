//
//  WWClock.swift
//  Makent
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

internal protocol WWClockProtocol {
    func WWClockGetTime() -> Date
    func WWClockSwitchAMPM(isAM: Bool, isPM: Bool)
    func WWClockSetHourMilitary(_ hour: Int)
    func WWClockSetMinute(_ minute: Int)
}

internal class WWClock: UIView {
    
    internal var delegate: WWClockProtocol!
    internal var backgroundColorClockFace: UIColor!
    internal var backgroundColorClockFaceCenter: UIColor!
    internal var fontAMPM: UIFont!
    internal var fontAMPMHighlight: UIFont!
    internal var fontColorAMPM: UIColor!
    internal var fontColorAMPMHighlight: UIColor!
    internal var backgroundColorAMPMHighlight: UIColor!
    internal var fontHour: UIFont!
    internal var fontHourHighlight: UIFont!
    internal var fontColorHour: UIColor!
    internal var fontColorHourHighlight: UIColor!
    internal var backgroundColorHourHighlight: UIColor!
    internal var backgroundColorHourHighlightNeedle: UIColor!
    internal var fontMinute: UIFont!
    internal var fontMinuteHighlight: UIFont!
    internal var fontColorMinute: UIColor!
    internal var fontColorMinuteHighlight: UIColor!
    internal var backgroundColorMinuteHighlight: UIColor!
    internal var backgroundColorMinuteHighlightNeedle: UIColor!
    
    internal var showingHour = true
    internal var minuteStep: WWCalendarTimeSelectorTimeStep! {
        didSet {
            minutes = []
            let iter = 60 / minuteStep.rawValue
            for i in 0..<iter {
                minutes.append(i * minuteStep.rawValue)
            }
        }
    }
    
    fileprivate let border: CGFloat = 8
    fileprivate let ampmSize: CGFloat = 52
    fileprivate var faceSize: CGFloat = 0
    fileprivate var faceX: CGFloat = 0
    fileprivate let faceY: CGFloat = 8
    fileprivate let amX: CGFloat = 8
    fileprivate var pmX: CGFloat = 0
    fileprivate var ampmY: CGFloat = 0
    fileprivate let numberCircleBorder: CGFloat = 12
    fileprivate let centerPieceSize = 4
    fileprivate let hours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    fileprivate var minutes: [Int] = []
    
    internal override func draw(_ rect: CGRect) {
        // update frames
        faceSize = min(rect.width - border * 2, rect.height - border * 2 - ampmSize / 3 * 2)
        faceX = (rect.width - faceSize) / 2
        pmX = rect.width - border - ampmSize
        ampmY = rect.height - border - ampmSize
        
        let time = delegate.WWClockGetTime()
        let ctx = UIGraphicsGetCurrentContext()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        ctx?.setFillColor(backgroundColorClockFace.cgColor)
        ctx?.fillEllipse(in: CGRect(x: faceX, y: faceY, width: faceSize, height: faceSize))
        
        ctx?.setFillColor(backgroundColorAMPMHighlight.cgColor)
        if time.hour < 12 {
            ctx?.fillEllipse(in: CGRect(x: amX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontAMPMHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorAMPMHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph]))
            var ampmHeight = fontAMPMHighlight.lineHeight
            str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontAMPM, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorAMPM, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph]))
            ampmHeight = fontAMPM.lineHeight
            str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        else {
            ctx?.fillEllipse(in: CGRect(x: pmX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontAMPM, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorAMPM, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph]))
            var ampmHeight = fontAMPM.lineHeight
            str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontAMPMHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorAMPMHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph]))
            ampmHeight = fontAMPMHighlight.lineHeight
            str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        
        if showingHour {
            let textAttr = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontHour, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorHour, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph] as [String : Any]
            let textAttrHighlight = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontHourHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorHourHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph] as [String : Any]
            
            let templateSize = NSAttributedString(string: "12", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttr)).size()
            let templateSizeHighlight = NSAttributedString(string: "12", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttrHighlight)).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
            let highlightCircleSize = maxSizeHighlight + numberCircleBorder
            let radius = faceSize / 2 - maxSize
            let radiusHighlight = faceSize / 2 - maxSizeHighlight
            
            ctx?.saveGState()
            ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(hours.count)
            let currentHour = get12Hour(time)
            
            for (index, element) in hours.enumerated() {
                let angle = getClockRad(CGFloat(index) * degreeIncrement)
                
                if element == currentHour {
                    // needle
                    ctx?.saveGState()
                    ctx?.setStrokeColor(backgroundColorHourHighlightNeedle.cgColor)
                    ctx?.setLineWidth(1)
                    ctx?.move(to: CGPoint(x: 0, y: 0))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleSize / 2) * sin(angle))))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.strokePath()
                    ctx?.restoreGState()
                    
                    // highlight
                    ctx?.saveGState()
                    ctx?.setFillColor(backgroundColorHourHighlight.cgColor)
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.fillEllipse(in: CGRect(x: -highlightCircleSize / 2, y: -highlightCircleSize / 2, width: highlightCircleSize, height: highlightCircleSize))
                    ctx?.restoreGState()
                    
                    // numbers
                    let hour = NSAttributedString(string: "\(element)", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttrHighlight))
                    ctx?.saveGState()
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
                    hour.draw(at: CGPoint.zero)
                    ctx?.restoreGState()
                }
                else {
                    // numbers
                    let hour = NSAttributedString(string: "\(element)", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttr))
                    ctx?.saveGState()
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
                    hour.draw(at: CGPoint.zero)
                    ctx?.restoreGState()
                }
            }
        }
        else {
            let textAttr = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontMinute, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorMinute, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph] as [String : Any]
            let textAttrHighlight = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): fontMinuteHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fontColorMinuteHighlight, convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph] as [String : Any]
            let templateSize = NSAttributedString(string: "60", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttr)).size()
            let templateSizeHighlight = NSAttributedString(string: "60", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttrHighlight)).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
            let minSize: CGFloat = 0
            let highlightCircleMaxSize = maxSizeHighlight + numberCircleBorder
            let highlightCircleMinSize = minSize + numberCircleBorder
            let radius = faceSize / 2 - maxSize
            let radiusHighlight = faceSize / 2 - maxSizeHighlight
            
            ctx?.saveGState()
            ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(minutes.count)
            let currentMinute = get60Minute(time)
            
            for (index, element) in minutes.enumerated() {
                let angle = getClockRad(CGFloat(index) * degreeIncrement)
                
                if element == currentMinute {
                    // needle
                    ctx?.saveGState()
                    ctx?.setStrokeColor(backgroundColorMinuteHighlightNeedle.cgColor)
                    ctx?.setLineWidth(1)
                    ctx?.move(to: CGPoint(x: 0, y: 0))
                    ctx?.scaleBy(x: -1, y: 1)
                    if minuteStep.rawValue < 5 && element % 5 != 0 {
                        ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMinSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMinSize / 2) * sin(angle))))
                    }
                    else {
                        ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMaxSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMaxSize / 2) * sin(angle))))
                    }
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.strokePath()
                    ctx?.restoreGState()
                    
                    // highlight
                    ctx?.saveGState()
                    ctx?.setFillColor(backgroundColorMinuteHighlight.cgColor)
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    if minuteStep.rawValue < 5 && element % 5 != 0 {
                        ctx?.fillEllipse(in: CGRect(x: -highlightCircleMinSize / 2, y: -highlightCircleMinSize / 2, width: highlightCircleMinSize, height: highlightCircleMinSize))
                    }
                    else {
                        ctx?.fillEllipse(in: CGRect(x: -highlightCircleMaxSize / 2, y: -highlightCircleMaxSize / 2, width: highlightCircleMaxSize, height: highlightCircleMaxSize))
                    }
                    ctx?.restoreGState()
                    
                    // numbers
                    if minuteStep.rawValue < 5 {
                        if element % 5 == 0 {
                            let min = NSAttributedString(string: "\(element)", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttrHighlight))
                            ctx?.saveGState()
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                            min.draw(at: CGPoint.zero)
                            ctx?.restoreGState()
                        }
                    }
                    else {
                        let min = NSAttributedString(string: "\(element)", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttrHighlight))
                        ctx?.saveGState()
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                        min.draw(at: CGPoint.zero)
                        ctx?.restoreGState()
                    }
                }
                else {
                    // numbers
                    if minuteStep.rawValue < 5 {
                        if element % 5 == 0 {
                            let min = NSAttributedString(string: "\(element)", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttr))
                            ctx?.saveGState()
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                            min.draw(at: CGPoint.zero)
                            ctx?.restoreGState()
                        }
                    }
                    else {
                        let min = NSAttributedString(string: "\(element)", attributes: convertToOptionalNSAttributedStringKeyDictionary(textAttr))
                        ctx?.saveGState()
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                        min.draw(at: CGPoint.zero)
                        ctx?.restoreGState()
                    }
                }
            }
        }
        
        // center piece
        ctx?.setFillColor(backgroundColorClockFaceCenter.cgColor)
        ctx?.fillEllipse(in: CGRect(x: -centerPieceSize / 2, y: -centerPieceSize / 2, width: centerPieceSize, height: centerPieceSize))
        ctx?.restoreGState()
    }
    
    fileprivate func get60Minute(_ date: Date) -> Int {
        return date.minute
    }
    
    fileprivate func get12Hour(_ date: Date) -> Int {
        let hr = date.hour
        return hr == 0 || hr == 12 ? 12 : hr < 12 ? hr : hr - 12
    }
    
    fileprivate func getClockRad(_ degrees: CGFloat) -> CGFloat {
        let radOffset = 90.degreesToRadians // add this number to get 12 at top, 3 at right
        return degrees.degreesToRadians + radOffset
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
            let pt = touch.location(in: self)
            
            // see if tap on AM or PM, making the boundary bigger
            let amRect = CGRect(x: 0, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
            let pmRect = CGRect(x: bounds.width - ampmSize - border, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
            
            if amRect.contains(pt) {
                delegate.WWClockSwitchAMPM(isAM: true, isPM: false)
            }
            else if pmRect.contains(pt) {
                delegate.WWClockSwitchAMPM(isAM: false, isPM: true)
            }
            else {
                touchClock(pt: pt)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
            let pt = touch.location(in: self)
            touchClock(pt: pt)
        }
    }
    
    fileprivate func touchClock(pt: CGPoint) {
        let touchPoint = CGPoint(x: pt.x - faceX - faceSize / 2, y: pt.y - faceY - faceSize / 2) // this means centerpoint will be 0, 0
        
        if showingHour {
            let degreeIncrement = 360 / CGFloat(hours.count)
            
            var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
            if angle < 0 {
                angle = 0
            }
            angle = angle - degreeIncrement / 2
            var index = Int(floor(angle / degreeIncrement)) + 1
            
            if index < 0 || index > (hours.count - 1) {
                index = 0
            }
            
            let hour = hours[index]
            let time = delegate.WWClockGetTime()
            if hour == 12 {
                delegate.WWClockSetHourMilitary(time.hour < 12 ? 0 : 12)
            }
            else {
                delegate.WWClockSetHourMilitary(time.hour < 12 ? hour : 12 + hour)
            }
        }
        else {
            let degreeIncrement = 360 / CGFloat(minutes.count)
            
            var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
            if angle < 0 {
                angle = 0
            }
            angle = angle - degreeIncrement / 2
            var index = Int(floor(angle / degreeIncrement)) + 1
            
            if index < 0 || index > (minutes.count - 1) {
                index = 0
            }
            
            let minute = minutes[index]
            delegate.WWClockSetMinute(minute)
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
}

private extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

private extension Int {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}
