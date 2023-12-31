//
//  WWCalendarRow.swift
//  Makent
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

internal protocol WWCalendarRowProtocol {
    func WWCalendarRowGetDetails(_ row: Int) -> (type: WWCalendarRowType, startDate: Date)
    func WWCalendarRowDidSelect(_ date: Date)
}

internal class WWCalendarRow: UIView {

    internal var delegate: WWCalendarRowProtocol!
    internal var monthFont: UIFont!
    internal var monthFontColor: UIColor!
    internal var dayFont: UIFont!
    internal var dayFontColor: UIColor!
    internal var datePastFont: UIFont!
    internal var datePastFontHighlight: UIFont!
    internal var datePastFontColor: UIColor!
    internal var datePastHighlightFontColor: UIColor!
    internal var datePastHighlightBackgroundColor: UIColor!
    internal var datePastFlashBackgroundColor: UIColor!
    internal var dateTodayFont: UIFont!
    internal var dateTodayFontHighlight: UIFont!
    internal var dateTodayFontColor: UIColor!
    internal var dateTodayHighlightFontColor: UIColor!
    internal var dateTodayHighlightBackgroundColor: UIColor!
    internal var dateTodayFlashBackgroundColor: UIColor!
    internal var dateFutureFont: UIFont!
    internal var dateFutureFontHighlight: UIFont!
    internal var dateFutureFontColor: UIColor!
    internal var dateFutureHighlightFontColor: UIColor!
    internal var dateFutureHighlightBackgroundColor: UIColor!
    internal var dateFutureFlashBackgroundColor: UIColor!
    internal var flashDuration: TimeInterval!
    internal var multipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .pill
    internal var multipleSelectionEnabled: Bool = false

    internal var selectedDates: Set<Date> {
        set {
            originalDates = newValue
            comparisonDates = []
            for date in newValue {
                comparisonDates.insert(date.beginningOfDay)
            }
        }
        get {
            return originalDates
        }
    }
    fileprivate var originalDates: Set<Date> = []
    fileprivate var comparisonDates: Set<Date> = []
    fileprivate let days = ["S", "M", "T", "W", "T", "F", "S"]
    fileprivate let multipleSelectionBorder: CGFloat = 12
    fileprivate let multipleSelectionBar: CGFloat = 8
    var arrBlockedDates = [String]()
    var notAvailableDays = [String]()
    var isDateSelected : Bool = false

    internal override func draw(_ rect: CGRect) {
        let detail = delegate.WWCalendarRowGetDetails(tag)
        let startDate = detail.startDate.beginningOfDay

        let ctx = UIGraphicsGetCurrentContext()
        let boxHeight = rect.height
        let boxWidth = rect.width / 7
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center

        if detail.type == .month {
            let monthName = startDate.stringFromFormat("MMMM yyyy").capitalized
            let monthHeight = ceil(monthFont.lineHeight)

            let str = NSAttributedString(string: monthName, attributes: [NSAttributedString.Key.font: monthFont, NSAttributedString.Key.foregroundColor: monthFontColor, NSAttributedString.Key.paragraphStyle: paragraph])
            str.draw(in: CGRect(x: 0, y: boxHeight - monthHeight, width: rect.width, height: monthHeight))
        }
        else if detail.type == .day {
            let dayHeight = ceil(dayFont.lineHeight)
            let y = (boxHeight - dayHeight) / 2

            for (index, element) in days.enumerated() {
                let str = NSAttributedString(string: element, attributes: [NSAttributedString.Key.font: dayFont, NSAttributedString.Key.foregroundColor: dayFontColor, NSAttributedString.Key.paragraphStyle: paragraph])
                str.draw(in: CGRect(x: CGFloat(index) * boxWidth, y: y, width: boxWidth, height: dayHeight))
            }
        }
        else {
            let today = Date().beginningOfDay
            var date = startDate
            var str: NSMutableAttributedString

            for i in 1...7 {
                if date.weekday == i {
                    var font = comparisonDates.contains(date) ? dateFutureFontHighlight : dateFutureFont
                    var fontColor = dateFutureFontColor
                    var fontHighlightColor = dateFutureHighlightFontColor
                    var backgroundHighlightColor = dateFutureHighlightBackgroundColor.cgColor
                    if date == today {
                        font = comparisonDates.contains(date) ? dateTodayFontHighlight : dateTodayFont
                        fontColor = dateTodayFontColor
                        fontHighlightColor = dateTodayHighlightFontColor
                        backgroundHighlightColor = dateTodayHighlightBackgroundColor.cgColor
                    }
                    else if date.compare(today) == ComparisonResult.orderedAscending {
                        font = comparisonDates.contains(date) ? datePastFontHighlight : datePastFont
                        fontColor = datePastFontColor
                        fontHighlightColor = datePastHighlightFontColor
                        backgroundHighlightColor = datePastHighlightBackgroundColor.cgColor
                    }

                    //                    let strStart_Date = "2017-01-15T00:00:00Z"
                    //                    let strEnd_Date = "2017-01-14T00:00:00Z"

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    //                    let start_date = dateFormatter.date(from:strStart_Date)
                    //                    let end_date = dateFormatter.date(from:strEnd_Date)

                    dateFormatter.dateStyle = DateFormatter.Style.medium

                    dateFormatter.timeStyle = DateFormatter.Style.none
                    dateFormatter.dateFormat = "dd-MM-yyy"
                    let strCheckInDate = dateFormatter.string(from: date)

                    if Constants().GETVALUE(keyname: "isDateSelected") == "notselected"
                    {
                        if arrBlockedDates.count>0
                        {
                            for i in 0...arrBlockedDates.count-1
                            {
                                let strBlocked = arrBlockedDates[i] as! NSString
                                if strCheckInDate == strBlocked as String
                                {
                                    font = comparisonDates.contains(date) ? datePastFontHighlight : datePastFont
                                    fontColor = UIColor.white
                                    fontHighlightColor = UIColor.white.withAlphaComponent(0.5)
                                    backgroundHighlightColor = UIColor.clear.cgColor
                                }
                            }
                        }
                    }
                    else if Constants().GETVALUE(keyname: "isDateSelected") == "selected"
                    {
                        if date.compare(today) == ComparisonResult.orderedAscending {
                            font = comparisonDates.contains(date) ? datePastFontHighlight : datePastFont
                            fontColor = UIColor.lightGray
                            fontHighlightColor = UIColor.lightGray
                            backgroundHighlightColor = UIColor.clear.cgColor
                        }

                    }
                    
                    if today - date < 0 {
                        if self.notAvailableDays.count > 0 {
                            for j in 0...self.notAvailableDays.count - 1 {
                                if "\(i)" == notAvailableDays[j] {
                                    fontColor = datePastFontColor
                                    fontHighlightColor = datePastHighlightFontColor
                                    backgroundHighlightColor = UIColor.clear.cgColor
                                }
                            }
                        }
                                
                    }
                    
//                    for j in 0...self.notAvailableDays.count - 1 {
//                        if "\(i)" == notAvailableDays[j] {
//                            fontColor = datePastFontColor
//                            fontHighlightColor = datePastHighlightFontColor
//                            backgroundHighlightColor = datePastHighlightBackgroundColor.cgColor
//                        }
//                    }
//                    if self.notAvailableDays.contains(obj: i) {
//                        if date.weekday == i {
//                            fontColor = datePastFontColor
//                            fontHighlightColor = datePastHighlightFontColor
//                            backgroundHighlightColor = datePastHighlightBackgroundColor.cgColor
//                        }
//                    }

                    let dateHeight = ceil(font!.lineHeight) as CGFloat
                    let y = (boxHeight - dateHeight) / 2

                    if comparisonDates.contains(date) {
                        ctx?.setFillColor(backgroundHighlightColor)

                        if multipleSelectionEnabled {
                            var testStringSize = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.font: dateTodayFontHighlight, NSAttributedString.Key.paragraphStyle: paragraph]).size()
                            var dateMaxWidth = testStringSize.width
                            var dateMaxHeight = testStringSize.height
                            if dateFutureFontHighlight.lineHeight > dateTodayFontHighlight.lineHeight {
                                testStringSize = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.font: dateFutureFontHighlight, NSAttributedString.Key.paragraphStyle: paragraph]).size()
                                dateMaxWidth = testStringSize.width
                                dateMaxHeight = testStringSize.height
                            }
                            if datePastFontHighlight.lineHeight > dateFutureFontHighlight.lineHeight {
                                testStringSize = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.font: datePastFontHighlight, NSAttributedString.Key.paragraphStyle: paragraph]).size()
                                dateMaxWidth = testStringSize.width
                                dateMaxHeight = testStringSize.height
                            }

                            let size = min(max(dateHeight, dateMaxWidth) + multipleSelectionBorder, min(boxHeight, boxWidth))
                            let maxConnectorSize = min(max(dateMaxHeight, dateMaxWidth) + multipleSelectionBorder, min(boxHeight, boxWidth))
                            let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                            let y = (boxHeight - size) / 2

                            // connector
                            switch multipleSelectionGrouping {
                            case .simple:
                                break
                            case .pill:
                                if comparisonDates.contains(date - 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth, y: y, width: boxWidth / 2 + 1, height: maxConnectorSize))
                                }
                                if comparisonDates.contains(date + 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth + boxWidth / 2, y: y, width: boxWidth / 2 + 1, height: maxConnectorSize))
                                }
                            case .linkedBalls:
                                if comparisonDates.contains(date - 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth, y: (boxHeight - multipleSelectionBar) / 2, width: boxWidth / 2 + 1, height: multipleSelectionBar))
                                }
                                if comparisonDates.contains(date + 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth + boxWidth / 2, y: (boxHeight - multipleSelectionBar) / 2, width: boxWidth / 2 + 1, height: multipleSelectionBar))
                                }
                            }

                            // ball
                            ctx?.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
                        }
                        else {
                            let size = min(boxHeight, boxWidth)
                            let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                            let y = (boxHeight - size) / 2
                            ctx?.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
                        }


                        str =  NSMutableAttributedString(string: "\(date.day)")

                        //                        print("coming")
                        if arrBlockedDates.count>0
                        {
                            for i in 0...arrBlockedDates.count-1
                            {
                                let strBlocked = arrBlockedDates[i] as! NSString
                                if strCheckInDate == strBlocked as String
                                {
                                    str.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, str.length))
                                }
                                else{
                                    
                                }
                            }
                        }

                        str.addAttributes([NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: fontHighlightColor!, NSAttributedString.Key.paragraphStyle: paragraph], range: NSMakeRange(0, str.length))

                        //                        str = NSMutableAttributedString(string: "\(date.day)", attributes: [NSFontAttributeName: font!, NSForegroundColorAttributeName: fontHighlightColor!, NSParagraphStyleAttributeName: paragraph])

                    }
                    else {
                        str =  NSMutableAttributedString(string: "\(date.day)")
                        //                        str = NSMutableAttributedString(string: "\(date.day)", attributes: [NSFontAttributeName: font!, NSForegroundColorAttributeName: fontColor!, NSParagraphStyleAttributeName: paragraph])

                        //                        str = NSMutableAttributedString(string: "\(date.day)", attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.patternDash.rawValue])



                        if arrBlockedDates.count>0
                        {
                            for i in 0...arrBlockedDates.count-1
                            {
                                let strBlocked = arrBlockedDates[i] as! NSString
                                if strCheckInDate == strBlocked as String
                                {
                                   str.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, str.length))
                                }
                                else{

                                }
                            }
                        }

                        str.addAttributes([NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: fontColor!, NSAttributedString.Key.paragraphStyle: paragraph], range: NSMakeRange(0, str.length))

                    }

                    str.draw(in: CGRect(x: CGFloat(i - 1) * boxWidth, y: y, width: boxWidth, height: dateHeight))
                    date = date + 1.day
                    if date.month != startDate.month {
                        break
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let detail = delegate.WWCalendarRowGetDetails(tag)
        if detail.type == .date {
            let boxWidth = bounds.width / 7
            if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
                let boxIndex = Int(floor(touch.location(in: self).x / boxWidth))
                let dateTapped = detail.startDate + boxIndex.days - (detail.startDate.weekday - 1).days
                if dateTapped.month == detail.startDate.month {
                    delegate.WWCalendarRowDidSelect(dateTapped)
                }
            }
        }
    }

     func flashDate(_ date: Date) -> Bool {
        let detail = delegate.WWCalendarRowGetDetails(tag)

        if detail.type == .date {
            let today = Date().beginningOfDay
        let startDate = detail.startDate.beginningOfDay
            let flashDate = date.beginningOfDay
            let boxHeight = bounds.height
            let boxWidth = bounds.width / 7
            var date = startDate

            for i in 1...7 {
                if date.weekday == i {
                    if date == flashDate {
                        var flashColor = dateFutureFlashBackgroundColor
                        if flashDate == today {
                            flashColor = dateTodayFlashBackgroundColor
                        }
                        else if flashDate.compare(today) == ComparisonResult.orderedAscending {
                            flashColor = datePastFlashBackgroundColor
                        }

                        let flashView = UIView(frame: CGRect(x: CGFloat(i - 1) * boxWidth, y: 0, width: boxWidth, height: boxHeight))
                        flashView.backgroundColor = flashColor
                        flashView.alpha = 0
                        addSubview(flashView)
                        UIView.animate(
                            withDuration: flashDuration / 2,
                            delay: 0,
                            options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseOut],
                            animations: {
                                flashView.alpha = 0.75
                        },
                            completion: { _ in
                                UIView.animate(
                                    withDuration: self.flashDuration / 2,
                                    delay: 0,
                                    options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseIn],
                                    animations: {
                                        flashView.alpha = 0
                                },
                                    completion: { _ in
                                        flashView.removeFromSuperview()
                                }
                                )
                        }
                        )
                        return true
                    }
                    date = date + 1.day
                    if date.month != startDate.month {
                        break
                    }
                }
            }
        }
        return false
    }
}
