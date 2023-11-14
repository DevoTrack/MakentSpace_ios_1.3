//
//  WWCalendarTimeSelectorStyle.swift
//  Makent
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation


@objc public final class WWCalendarTimeSelectorStyle: NSObject {
    fileprivate(set) public var showDateMonth: Bool = true
    fileprivate(set) public var showMonth: Bool = false
    fileprivate(set) public var showYear: Bool = true
    fileprivate(set) public var showTime: Bool = true
    fileprivate var isSingular = false
    
    
    public func showDateMonth(_ show: Bool) {
        showDateMonth = show
        showMonth = show ? false : showMonth
        if show && isSingular {
            showMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showMonth(_ show: Bool) {
        showMonth = show
        showDateMonth = show ? false : showDateMonth
        if show && isSingular {
            showDateMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showYear(_ show: Bool) {
        showYear = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showTime = false
        }
    }
    
    public func showTime(_ show: Bool) {
        showTime = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showYear = false
        }
    }
    
    fileprivate func countComponents() -> Int {
        return (showDateMonth ? 1 : 0) +
            (showMonth ? 1 : 0) +
            (showYear ? 1 : 0) +
            (showTime ? 1 : 0)
    }
    
    convenience init(isSingular: Bool) {
        self.init()
        self.isSingular = isSingular
        showDateMonth = true
        showMonth = false
        showYear = false
        showTime = false
    }
}
/// Set `optionSelectionType` with one of the following:
///
/// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
///
/// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// - Note:
/// Selection styles will only affect date selection. It is currently not possible to select multiple/range
@objc public enum WWCalendarTimeSelectorSelection: Int {
    /// Single Selection.
    case single
    /// Multiple Selection. Year and Time interface not available.
    case multiple
    /// Range Selection. Year and Time interface not available.
    case range
}

/// Set `optionMultipleSelectionGrouping` with one of the following:
///
/// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
///
/// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
///
/// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
@objc public enum WWCalendarTimeSelectorMultipleSelectionGrouping: Int {
    /// Displayed as individual circular selection
    case simple
    /// Rounded rectangular grouping
    case pill
    /// Individual circular selection with a bar between adjacent dates
    case linkedBalls
}

/// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
///
/// - Note:
/// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
/// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
///
/// - Note:
/// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
@objc public enum WWCalendarTimeSelectorTimeStep: Int {
    /// 1 Minute interval, but clock will display intervals of 5 minutes.
    case oneMinute = 1
    /// 5 Minutes interval.
    case fiveMinutes = 5
    /// 10 Minutes interval.
    case tenMinutes = 10
    /// 15 Minutes interval.
    case fifteenMinutes = 15
    /// 30 Minutes interval.
    case thirtyMinutes = 30
    /// Disables the selection of minutes.
    case sixtyMinutes = 60
}

@objc open class WWCalendarTimeSelectorDateRange: NSObject {
    fileprivate(set) open var start: Date = Date().beginningOfDay
    fileprivate(set) open var end: Date = Date().beginningOfDay
    open var array: [Date] {
        var dates: [Date] = []
        var i = start.beginningOfDay
        let j = end.beginningOfDay
        while i.compare(j) != .orderedDescending {
            print("∂DateValues:",i)
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateStyle = DateFormatter.Style.medium
            //            dateFormatter.timeStyle = DateFormatter.Style.none
            //            dateFormatter.locale = Language.getCurrentLanguage().locale
            //            dateFormatter.dateFormat = "dd-MM-yyy"
            //            strCheckInDate =
            //            let dateStr = dateFormatter.string(from: i)
            //
            dates.append(i)
            i = i + 1.day
            //            dates.append(dateFormatter.date(from: dateStr)!)
            //            i = i + 1.day
        }
        return dates
    }
    
    open func setStartDate(_ date: Date) {
        start = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            end = start
        }
    }
    
    open func setEndDate(_ date: Date) {
        end = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            start = end
        }
    }
}
