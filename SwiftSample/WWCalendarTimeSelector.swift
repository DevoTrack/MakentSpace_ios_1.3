/**
 * WWCalendarTimeSelector.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import UserNotifications

open class WWCalendarTimeSelector: UIViewController, UITableViewDelegate, UITableViewDataSource, WWCalendarRowProtocol {
    
    /// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
    ///
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    /// `WWCalendarTimeSelectorDone:selector:date:`
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    open var delegate: WWCalendarTimeSelectorProtocol?
    open var callAPI: Bool = false
    open var arrBlockedDates = [String]()
    open var notAvailableDays = [String]()
    /// A convenient identifier object. Not used by `WWCalendarTimeSelector`.
    open var optionIdentifier: AnyObject?
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    /// Set `optionPickerStyle` with one or more of the following:
    ///
    /// `DateMonth`: This shows the the date and month.
    ///
    /// `Year`: This shows the year.
    ///
    /// `Time`: This shows the clock, users will be able to select hour and minutes as well as am or pm.
    ///
    /// - Note:
    /// `optionPickerStyle` should contain at least 1 of the following style. It will default to all styles should there be none in the option specified.
    ///
    /// - Note:
    /// Defaults to all styles.
    open var optionStyles: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle()
    
    /// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
    /// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
    ///
    /// - Note:
    /// Defaults to `OneMinute`.
    open var optionTimeStep: WWCalendarTimeSelectorTimeStep = .oneMinute
    
    /// Set to `true` will show the entire selector at the top. If you only wish to hide the *title bar*, see `optionShowTopPanel`. Set to `false` will hide the entire top container.
    ///
    /// - Note:
    /// Defaults to `true`.
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`.
    open var optionShowTopContainer: Bool = true
    
    /// Set to `true` to show the weekday name *or* `optionTopPanelTitle` if specified at the top of the selector. Set to `false` will hide the entire panel.
    ///
    /// - Note:
    /// Defaults to `true`.
    open var optionShowTopPanel = true
    
    /// Set to nil to show default title. Depending on `privateOptionStyles`, default titles are either **Select Multiple Dates**, **(Capitalized Weekday Full Name)** or **(Capitalized Month Full Name)**.
    ///
    /// - Note:
    /// Defaults to `nil`.
    open var optionTopPanelTitle: String? = nil
    
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
    open var optionSelectionType: WWCalendarTimeSelectorSelection = .single
    
    /// Set to default date when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDates`
    ///
    /// - Note:
    /// Defaults to current date and time, with time rounded off to the nearest hour.
    open var optionCurrentDate = Date().minute < 30 ? Date().beginningOfHour : Date().beginningOfHour + 1.hour
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDates: Set<Date> = []
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDateRange: WWCalendarTimeSelectorDateRange = WWCalendarTimeSelectorDateRange()
    
    /// Set the background blur effect, where background is a `UIVisualEffectView`. Available options are as `UIBlurEffectStyle`:
    ///
    /// `Dark`
    ///
    /// `Light`
    ///
    /// `ExtraLight`
    open var optionStyleBlurEffect: UIBlurEffect.Style = .dark
    
    /// Set `optionMultipleSelectionGrouping` with one of the following:
    ///
    /// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
    ///
    /// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
    ///
    /// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
    open var optionMultipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .pill
    
    
    // Fonts & Colors
    open var optionCalendarFontMonth = UIFont.systemFont(ofSize: 14)
    open var optionCalendarFontDays = UIFont.systemFont(ofSize: 16)
    open var optionCalendarFontToday = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontTodayHighlight = UIFont.boldSystemFont(ofSize: 16)
    open var optionCalendarFontPastDates = UIFont.boldSystemFont(ofSize: 16)
    open var optionCalendarFontPastDatesHighlight = UIFont.boldSystemFont(ofSize: 13)
    open var optionCalendarFontFutureDates = UIFont.boldSystemFont(ofSize: 16)
    open var optionCalendarFontFutureDatesHighlight = UIFont.boldSystemFont(ofSize: 16)
    
    open var optionCalendarFontColorMonth = UIColor.white
    open var optionCalendarFontColorDays = UIColor.white
    open var optionCalendarFontColorToday = UIColor.white
    open var optionCalendarFontColorTodayHighlight = UIColor.black
    open var optionCalendarBackgroundColorTodayHighlight = UIColor.white
    open var optionCalendarBackgroundColorTodayFlash = UIColor.white
    open var optionCalendarFontColorPastDates = UIColor.white.withAlphaComponent(0.5)
    open var optionCalendarFontColorPastDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorPastDatesHighlight = UIColor.brown
    open var optionCalendarBackgroundColorPastDatesFlash = UIColor.white
    open var optionCalendarFontColorFutureDates = UIColor.white
    open var optionCalendarFontColorFutureDatesHighlight = UIColor.black
    open var optionCalendarBackgroundColorFutureDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorFutureDatesFlash = UIColor.black
    
    open var optionCalendarFontCurrentYear = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontCurrentYearHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorCurrentYear = UIColor.darkGray
    open var optionCalendarFontColorCurrentYearHighlight = UIColor.black
    open var optionCalendarFontPastYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontPastYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorPastYears = UIColor.darkGray
    open var optionCalendarFontColorPastYearsHighlight = UIColor.black
    open var optionCalendarFontFutureYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontFutureYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorFutureYears = UIColor.darkGray
    open var optionCalendarFontColorFutureYearsHighlight = UIColor.black
    
    open var optionClockFontAMPM = UIFont.systemFont(ofSize: 18)
    open var optionClockFontAMPMHighlight = UIFont.systemFont(ofSize: 20)
    open var optionClockFontColorAMPM = UIColor.black
    open var optionClockFontColorAMPMHighlight = UIColor.white
    open var optionClockBackgroundColorAMPMHighlight = UIColor.brown
    open var optionClockFontHour = UIFont.systemFont(ofSize: 16)
    open var optionClockFontHourHighlight = UIFont.systemFont(ofSize: 18)
    open var optionClockFontColorHour = UIColor.black
    open var optionClockFontColorHourHighlight = UIColor.white
    open var optionClockBackgroundColorHourHighlight = UIColor.brown
    open var optionClockBackgroundColorHourHighlightNeedle = UIColor.brown
    open var optionClockFontMinute = UIFont.systemFont(ofSize: 12)
    open var optionClockFontMinuteHighlight = UIFont.systemFont(ofSize: 14)
    open var optionClockFontColorMinute = UIColor.black
    open var optionClockFontColorMinuteHighlight = UIColor.white
    open var optionClockBackgroundColorMinuteHighlight = UIColor.brown
    open var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.brown
    open var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
    open var optionClockBackgroundColorCenter = UIColor.black
    
    open var optionButtonTitleDone: String = "Done"
    open var optionButtonTitleCancel: String = "Cancel"
    open var optionButtonFontCancel = UIFont.systemFont(ofSize: 16)
    open var optionButtonFontDone = UIFont.boldSystemFont(ofSize: 16)
    open var optionButtonFontColorCancel = UIColor.brown
    open var optionButtonFontColorDone = UIColor.brown
    open var optionButtonFontColorCancelHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonFontColorDoneHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonBackgroundColorCancel = UIColor.clear
    open var optionButtonBackgroundColorDone = UIColor.clear
    
    open var optionTopPanelBackgroundColor = UIColor.brown
    open var optionTopPanelFont = UIFont.systemFont(ofSize: 16)
    open var optionTopPanelFontColor = UIColor.white
    
    open var optionSelectorPanelFontMonth = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontDate = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontYear = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontTime = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelection = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelectionHighlight = UIFont.systemFont(ofSize: 17)
    open var optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorMonthHighlight = UIColor.white
    
    open var optionSelectorPanelFontColorDate = UIColor.white.withAlphaComponent(0.5)
    open var optionSelectorPanelFontColorDateHighlight = UIColor.white
    
    open var optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorYearHighlight = UIColor.white
    open var optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorTimeHighlight = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelection = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
    open var optionSelectorPanelBackgroundColor = UIColor.brown.withAlphaComponent(0.9)
    
    open var optionMainPanelBackgroundColor = UIColor.white
    open var optionBottomPanelBackgroundColor = UIColor.white
    
    /// This is the month's offset when user is in selection of dates mode. A positive number will adjusts the month higher, while a negative number will adjust the month lower.
    ///
    /// - Note:
    /// Defaults to 30.
    open var optionSelectorPanelOffsetHighlightMonth: CGFloat = 30
    
    /// This is the date's offset when user is in selection of dates mode. A positive number will adjusts the date lower, while a negative number will adjust the date higher.
    ///
    /// - Note:
    /// Defaults to 24.
    open var optionSelectorPanelOffsetHighlightDate: CGFloat = 24
    
    /// This is the scale of the month when it is in active view.
    open var optionSelectorPanelScaleMonth: CGFloat = 2.5
    open var optionSelectorPanelScaleDate: CGFloat = 4.5
    open var optionSelectorPanelScaleYear: CGFloat = 4
    open var optionSelectorPanelScaleTime: CGFloat = 2.75
    
    /// This is the height calendar's "title bar". If you wish to hide the Top Panel, consider `optionShowTopPanel`
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`
    open var optionLayoutTopPanelHeight: CGFloat = 28
    
    /// The height of the calendar in portrait mode. This will be translated automatically into the width in landscape mode.
    open var optionLayoutHeight: CGFloat?
    
    /// The width of the calendar in portrait mode. This will be translated automatically into the height in landscape mode.
    open var optionLayoutWidth: CGFloat?
    
    /// If optionLayoutHeight is not defined, this ratio is used on the screen's height.
    open var optionLayoutHeightRatio: CGFloat = 0.9
    
    /// If optionLayoutWidth is not defined, this ratio is used on the screen's width.
    open var optionLayoutWidthRatio: CGFloat = 0.85
    
    /// When calendar is in portrait mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 7 / 20
    open var optionLayoutPortraitRatio: CGFloat = 7/20
    
    /// When calendar is in landscape mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 3 / 8
    open var optionLayoutLandscapeRatio: CGFloat = 3/8
    
    // All Views
    @IBOutlet fileprivate weak var topContainerView: UIView!
    @IBOutlet fileprivate weak var bottomContainerView: UIView!
    @IBOutlet fileprivate weak var backgroundDayView: UIView!
    @IBOutlet fileprivate weak var backgroundRangeView: UIView!
    @IBOutlet fileprivate weak var backgroundContentView: UIView!
    @IBOutlet fileprivate weak var backgroundButtonsView: UIView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet fileprivate weak var selDateView: UIView!
    @IBOutlet fileprivate weak var dayLabel: UILabel!
    @IBOutlet fileprivate weak var monthLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var yearLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var rangeStartLabel: UILabel!
    @IBOutlet weak var lblClearAll: UILabel!
    
    @IBOutlet fileprivate weak var rangeToLabel: UILabel!
    @IBOutlet fileprivate weak var rangeEndLabel: UILabel!
    @IBOutlet fileprivate weak var calendarTable: UITableView!
    //    @IBOutlet fileprivate weak var viewGradient: UIView!
    
    @IBOutlet fileprivate weak var yearTable: UITableView!
    @IBOutlet fileprivate weak var clockView: WWClock!
    @IBOutlet fileprivate weak var monthsView: UIView!
    @IBOutlet fileprivate var monthsButtons: [UIButton]!
    
    // All Constraints
    @IBOutlet fileprivate weak var dayViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selMonthXConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selMonthYConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateXConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateYConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeHeightConstraint: NSLayoutConstraint!
    var room_Id = ""
    var total_guest = ""
    var btntype = ""
    var pernight_price = ""
    var RoomDetailData : SpaceDetailData!
    
    var isDateSelected : Bool = false
    var isFromExplorePage : Bool = false
    var isFromExperiences : Bool = false
    
    var strTime = ""
    var edTime  = ""
   var  isResetClicked = Bool()
    @IBOutlet var viewErrorHolder: UIView!
    
    @IBOutlet weak var startEndTimeView: UIView!
    
    @IBOutlet weak var startEndTimeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectTimeImg: UIImageView!
    
    @IBOutlet weak var selectStartTime: UILabel!
    
    @IBOutlet weak var selectEndTime: UILabel!
    
    @IBOutlet weak var selectEndImg: UIImageView!
    
    @IBOutlet var lblErrorMsg: UILabel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var animatedImgBooking: FLAnimatedImageView?
    @IBOutlet weak var startTimeView: UIView!
    
    @IBOutlet weak var endTimeView: UIView!
    
    // Private Variables
    fileprivate let selAnimationDuration: TimeInterval = 0.4
    fileprivate let selInactiveHeight: CGFloat = 48
    fileprivate var portraitContainerWidth: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var portraitTopContainerHeight: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutPortraitRatio : 0 }
    fileprivate var portraitBottomContainerHeight: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - portraitTopContainerHeight }
    fileprivate var landscapeContainerHeight: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var landscapeTopContainerWidth: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutLandscapeRatio : 0 }
    fileprivate var landscapeBottomContainerWidth: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - landscapeTopContainerWidth }
    fileprivate var selCurrrent: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle(isSingular: true)
    fileprivate var isFirstLoad = false
    fileprivate var isFirstClick = true
    fileprivate var selTimeStateHour = true
    fileprivate var calRow1Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow2Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow3Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow1StartDate: Date = Date()
    fileprivate var calRow2StartDate: Date = Date()
    fileprivate var calRow3StartDate: Date = Date()
   // fileprivate var yearRow1: Int = 2016
    fileprivate var yearRow1: Int = 2019
    fileprivate var multipleDates: [Date] { return optionCurrentDates.sorted(by: { $0.compare($1) == ComparisonResult.orderedAscending }) }
    fileprivate var multipleDatesLastAdded: Date?
     var flashDate: Date?
    fileprivate let defaultTopPanelTitleForMultipleDates = "Select Multiple Dates"
    fileprivate let portraitHeight: CGFloat = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    fileprivate let portraitWidth: CGFloat = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    fileprivate var isSelectingStartRange: Bool = true { didSet { rangeStartLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDate: optionSelectorPanelFontColorDateHighlight;
        rangeEndLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDateHighlight: optionSelectorPanelFontColorDate } }
    fileprivate var shouldResetRange: Bool = false
    
    /// Only use this method to instantiate the selector. All customization should be done before presenting the selector to the user.
    /// To receive callbacks from selector, set the `delegate` of selector and implement `WWCalendarTimeSelectorProtocol`.
    ///
    ///     let selector = WWCalendarTimeSelector.instantiate()
    ///     selector.delegate = self
    ///     presentViewController(selector, animated: true, completion: nil)
    ///
    
    fileprivate var weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var selectedDate:String!
    var selecredExpDate  = ""
    var maximumYear:Int = 1
    private var maximumYearInDate = Date()
//  var minim
    
    open static func instantiate() -> WWCalendarTimeSelector {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "WWCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
        var bundle: Bundle?
        if let bundleURL = bundleURL {
            bundle = Bundle(url: bundleURL)
        }
        return UIStoryboard(name: "WWCalendarTimeSelector", bundle: bundle).instantiateInitialViewController() as! WWCalendarTimeSelector
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    fileprivate var showPlaceHolders = false
    open func showPlaceHolder(_ val : Bool){
        self.showPlaceHolders = val
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.startTimeDetails(notification:)), name: NSNotification.Name(rawValue: "startTime"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.endTimeDetails(notification:)), name: NSNotification.Name(rawValue: "endTime"), object: nil)
    }
    

    
    // handle notification
    @objc func startTimeDetails(notification: NSNotification) {
        print("Notification center")
        if let jsons = notification.userInfo as? JSONS{
            self.selectStartTime.text = jsons.string("selectStartTime")
        }
    
    }
    
    @objc func endTimeDetails(notification: NSNotification) {
        print("Notification center")
        if let jsons = notification.userInfo as? JSONS{
            self.selectEndTime.text = jsons.string("selectEndTime")
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        lblClearAll.addTap { [self] in
            print("HANDLE CLEAR")
            rangeStartLabel.text = lang.strtdat_Title
            rangeEndLabel.text = lang.enddat_Title
            optionCurrentDateRange = WWCalendarTimeSelectorDateRange()
            calendarTable.reloadData()
            self.isResetClicked = true
            self.appDelegate.multipleDates.removeAll()
           
        }
        print("Calendar selections")
        Constants().STOREVALUE(value: "notselected", keyname: "isDateSelected")
        self.maximumYearInDate.addYear(year: self.maximumYear)
        selectedDate = Date().stringFromFormat("dd-MM-YYY")
        selectedDate = appDelegate.selecredExpDate
        weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        viewErrorHolder.isHidden = true
        self.doneButton.setTitle(self.lang.save_Tit, for: .normal)
        self.doneButton.appGuestBGColor()
        self.doneButton.layer.borderColor = UIColor.white.cgColor
        
        if callAPI
        {
            self.animatedImgBooking?.isHidden = true
        }
        /// call the time filter popover view controller
        self.startTimeView.addTap
        {
            self.showTimeFilter(timeBooleans: true)
        }
        self.endTimeView.addTap
        {
            self.showTimeFilter(timeBooleans: false)
        }
        
        self.startEndTimeView.isHidden = true
        self.startEndTimeHeight.constant = 0.0
        
//       if isFromExplorePage
//       {
//       self.startEndTimeView.isHidden = false
//       self.startEndTimeHeight.constant = 73.0
//       self.selectStartTime.text = self.strTime
//       self.selectEndTime.text   = self.edTime
//       }
//       else
//       {
//        self.startEndTimeView.isHidden = true
//        self.startEndTimeHeight.constant = 0.0
//        }
        print("selected start time",strTime)
        
        if !strTime.isEmpty
        {
            if isFromExplorePage
             {
              self.startEndTimeView.isHidden = false
              self.startEndTimeHeight.constant = 73.0
              self.selectStartTime.text = self.strTime
              self.selectEndTime.text   = self.edTime
             }
             else
             {
              self.startEndTimeView.isHidden = true
              self.startEndTimeHeight.constant = 0.0
             }
        }
        
        else
        {
            self.startEndTimeView.isHidden = true
            self.startEndTimeHeight.constant = 0.0
        }
       
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek

        yearRow1 = optionCurrentDate.year - 1

        calendarTable.reloadData()
        calendarTable.setContentOffset(CGPoint(x: 0, y:150), animated:true)

        view.layoutIfNeeded()
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotateOrNot), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        doneButton.layer.cornerRadius = 6
        //        rangeEndLabel.font = optionSelectorPanelFontDate
        if self.isFromExplorePage{
            self.rangeStartLabel.text = lang.strtdat_Title//"Start date"
            self.rangeEndLabel.text = lang.enddat_Title//"End date"
        }else{
            self.rangeStartLabel.text = lang.checkin_Title//"Check-in"
            self.rangeEndLabel.text = lang.checkout_Title//"Check-out"
        }
        
        if !showPlaceHolders{
            updateDate()
        }
        isFirstLoad = true
        
    }
    
    func showTimeFilter(timeBooleans : Bool)
    {
//        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "TimeFilterVCID") as! TimeFilterViewController
//        let nav = UINavigationController(rootViewController: popoverContent)
//        nav.modalPresentationStyle = UIModalPresentationStyle.popover
//        let popover = nav.popoverPresentationController
//        popoverContent.preferredContentSize = CGSize(width: 200, height: 600)
//        popover?.delegate = self as UIPopoverPresentationControllerDelegate
//        popover?.sourceView = self.view
//        popover?.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 64)
//        self.present(nav, animated: true, completion: nil)
        
        let selectionVC = k_MakentStoryboard.instantiateViewController(withIdentifier: "TimeFilterVCID") as! TimeFilterViewController
        print("width",self.view.bounds.width/4)
        
//        selectionVC.size
        selectionVC.modalPresentationStyle = .overCurrentContext
        selectionVC.preferredContentSize = CGSize(width: 100, height: 100)
        selectionVC.timeBoolean = timeBooleans
//        if let popover: UIPopoverPresentationController = selectionVC.popoverPresentationController{
//            popover.delegate = self
//            let barBtnItem =  UIBarButtonItem(customView: startTimeView)
//            popover.barButtonItem = barBtnItem
//            popover.permittedArrowDirections = .any
//            popover.sourceView = self.startTimeView
//            popover.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 64)
//        }
        self.present(selectionVC, animated: true, completion: nil)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false // Temp fix for i6s+ bug?
            calendarTable.reloadData()
//            yearTable.reloadData()
//            if clockView != nil {
//
//                clockView.setNeedsDisplay()
//            }
//            self.didRotateOrNot()
//
//            if optionStyles.showDateMonth {
//                showDate(true)
//            }
//            else if optionStyles.showMonth {
//                showMonth(true)
//            }
//            else if optionStyles.showYear {
//                showYear(true)
//            }
//            else if optionStyles.showTime {
//                showTime(true)
//            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstLoad = false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @objc internal func didRotateOrNot() {
        let orientation = UIApplication.shared.statusBarOrientation
//        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
//            UIView.animate(
//                withDuration: selAnimationDuration,
//                delay: 0,
//                usingSpringWithDamping: 0.8,
//                initialSpringVelocity: 0,
//                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
//                animations: {
//                    self.view.layoutIfNeeded()
//            },
//                completion: nil
//            )
//            if selCurrrent.showDateMonth {
//                showDate(false)
//            }
//            else if selCurrrent.showMonth {
//                showMonth(false)
//            }
//            else if selCurrrent.showYear {
//                showYear(false)
//            }
//            else if selCurrrent.showTime {
//                showTime(false)
//            }
//        }
    }
 
    //MARK: API CALL FOR CHECKING AVAILABILITY
    func checkAvailableDatesForBooking(dates:[Date])
    {
        print("CheckAvailability")
        print("arrayBlocked Count",arrBlockedDates.count)
        print("Dates count",dates.count)
        print("Dates",dates)
        
        var startDate = ""
        var endDate   = ""
        
        if dates.count > 1
        {
            print("date values greater than zero")
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "EEEE d MMM yyyy"
            let showDate = inputFormatter.date(from: rangeStartLabel.text!)
            inputFormatter.dateFormat = "yyyy-MM-dd"
            startDate = inputFormatter.string(from: showDate!)
            print("resulting",startDate)

           let endFormatter = DateFormatter()
           endFormatter.dateFormat = "EEEE d MMM yyyy"
           let endDateValues = endFormatter.date(from: rangeEndLabel.text!)
           endFormatter.dateFormat = "yyyy-MM-dd"
           endDate = inputFormatter.string(from: endDateValues!)
           print("resulting",endDateValues)
        }
        else
        {
            print("date values zero")
             let inputFormatter = DateFormatter()
             inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let myString = inputFormatter.string(from: dates[0])
            let showDate = inputFormatter.date(from: myString)
            inputFormatter.dateFormat = "yyyy-MM-dd"
            startDate = inputFormatter.string(from: showDate!)
            endDate = inputFormatter.string(from: showDate!)
            print("convert datess",startDate)
        }
        
//        let calendar = Calendar.current
//        let date = Date()
//        print("Current Date..")
//       // let april13Date = calendar.date(from: april13Components)!
//
//        // Get the current date components for year, month, weekday and weekday ordinal
//        var components = calendar.dateComponents([.year, .month, .weekdayOrdinal, .weekday], from: date)
//        print("components",components)
//
//        // Loop thru the range, set the components to the appropriate weekday ordinal and get the date
//        for ordinal in 1..<6 { // maximum 5 occurrences
//            components.weekdayOrdinal = ordinal
//            let date = calendar.date(from: components)!
//            print("date",date)
//            if calendar.component(.month, from: date) != components.month! { break }
//            print(calendar.date(from: components)!)
//        }
       /*if let path =  Bundle.main.path(forResource: "dot_loading_white", ofType: "gif")
        {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                animatedImgBooking?.animatedImage = gif
            }
        }
        
        self.doneButton.titleLabel?.text = self.lang.save_Tit
        doneButton.setTitle(self.lang.save_Tit, for: .normal)
        let rect = MakentSupport().getScreenSize()
        
        var rectImg = animatedImgBooking?.frame
        rectImg?.origin.y = rect.size.height - 50
        animatedImgBooking?.frame = rectImg!
        animatedImgBooking?.isHidden = false
        let formalDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd-MM-yyy"
        var strCheckOutDate = ""
        let strCheckInDate = dateFormatter.string(from: startDay)
        if !shouldResetRange && formalDates.count==1
        {
            shouldResetRange = false
            let startDay = optionCurrentDateRange.start
            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
            optionCurrentDateRange.setEndDate((start?.beginningOfDay)!)
            strCheckOutDate = dateFormatter.string(from: (start)!)
        }
        else
        {
            strCheckOutDate = dateFormatter.string(from: lastDay!)
        }
        var dicts = [AnyHashable: Any]()
        appDelegate.startdate = strCheckInDate
        appDelegate.enddate = strCheckOutDate
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["start_date"] =  strCheckInDate
        dicts["end_date"] =  strCheckOutDate
        dicts["room_id"] =  room_Id
        if appDelegate.searchguest == ""
        {
            dicts["total_guest"] = "1"
        }
        else
        {
            dicts["total_guest"] =  appDelegate.searchguest
        }
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: API_ROOM_AVAILABLE_STATUS, paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
            self.animatedImgBooking?.isHidden = true
            if responseDict.isSuccess {
                self.appDelegate.pricepertnight = responseDict.int("pernight_price").description
                print(self.pernight_price,self.appDelegate.pricepertnight)
                self.onSuccess()

            }else {
                self.doneButton.setTitle(self.lang.save_Tit, for: .normal)
                self.doneButton.titleLabel?.text = self.lang.save_Tit
                self.appDelegate.createToastMessage(responseDict.statusMessage, isSuccess: true)

            }
        }*/
        
        var dicts = [AnyHashable: Any]()
//        appDelegate.startdate = strCheckInDate
//        appDelegate.enddate = strCheckOutDate
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
//        dicts["start_date"] =  strCheckInDate
//        dicts["end_date"] =  strCheckOutDate
//        dicts["start_date"] =  "2019-10-23"
//        dicts["end_date"] =  "2019-10-25"
        dicts["start_date"] =  startDate
        dicts["end_date"]   =  endDate
        dicts["space_id"]   =  room_Id
        dicts["start_time"] = "00:00:00"
        dicts["end_time"] = "23:59:59"
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        print("TimeZone",localTimeZoneIdentifier)
        dicts["time_zone"]  = localTimeZoneIdentifier
        
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "get_availability_times", paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            self.animatedImgBooking?.isHidden = true
            print("success message",responseDict.string("success_message"))
            if responseDict.isSuccess {
                let eventView     = k_MakentStoryboard.instantiateViewController(withIdentifier: "ChooseTimingVC") as! ChooseTimingViewController
                eventView.availableTimes = GetAvailabilityTimeData(availabilityTimeJson: responseDict)
                eventView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(eventView, animated: true)
            }
            else
            {
              self.appDelegate.createToastMessage(responseDict.string("success_message"), isSuccess: false)
            }
        }
    }
   
    
    func onSuccess()
    {
 
        /// Time comparisions
        if isFromExplorePage
        {
            if self.selectStartTime.text! == "Select"
            {
                self.appDelegate.createToastMessage(self.lang.pleaseSelectStartTime)
            }
            
            else if self.selectEndTime.text! == "Select"
            {
                self.appDelegate.createToastMessage(self.lang.pleaseSelectEndTime)
            }
            
            else
            {
                if !self.timeComparision(self.selectStartTime.text!, self.selectEndTime.text!)
                {
                    self.appDelegate.createToastMessage(self.lang.endTimeShouldBeGreaterThanTheStartTime)
                }
                else
                {
                    self.calTimeSelectorDone()
                }
            }
        }
        else
        {
            self.calTimeSelectorDone()
        }
    }
    
    func timeComparision (_ stTime : String,_ edTime : String) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let sDate = dateFormatter.date(from: stTime) ?? Date()
        let eDate = dateFormatter.date(from: edTime) ?? Date()
        if sDate < eDate{
            print("true")
            return true
        }else{
            print("false")
            return false
        }
    }
    
    func calTimeSelectorDone()
    {
         print("on successs")
                print("selected start time",self.selectStartTime.text!)
                print("selected end time",self.selectEndTime.text!)
                Constants().STOREVALUE(value: self.selectStartTime.text! as NSString, keyname: "START_TIME")
                Constants().STOREVALUE(value: self.selectEndTime.text! as NSString, keyname: "END_TIME")
                let picker = self
                let del = delegate
                switch optionSelectionType {
                case .single:
                    del?.WWCalendarTimeSelectorDone?(picker, date: optionCurrentDate)
                case .multiple:
                    del?.WWCalendarTimeSelectorDone?(picker, dates: appDelegate.multipleDates)
                case .range:
                    del?.WWCalendarTimeSelectorDone?(picker, dates: optionCurrentDateRange.array)
                }
                
                del?.WWCalendarTimeSelectorWillDismiss?(picker)
        //      if(isFromExperiences != true ){
        //                  appDelegate.startdate = self.rangeStartLabel.text!
        //                  appDelegate.enddate = self.rangeEndLabel.text!
                 Constants().STOREVALUE(value: appDelegate.startdate as NSString, keyname: "START_DATE")
                 Constants().STOREVALUE(value: appDelegate.enddate as NSString, keyname: "END_DATE")
               
                     if isFromExplorePage
                        {
                          let _ = navigationController?.popViewController(animated: false)
                         }
                     else
                         {
                            dismiss(animated: true) {
                              del?.WWCalendarTimeSelectorDidDismiss?(picker)
                            }
                         }
    }
    
    var fromContact = false
    @IBAction func done() {
        print("done button")
//        if isFromExplorePage && !fromContact
//        {
//            self.onSuccess()
//            return
//        }
//        self.checkAvailableDatesForBooking(dates: optionCurrentDateRange.array)
        if optionCurrentDateRange.array.count > 1 {
           self.checkAvailableDatesForBooking(dates: optionCurrentDateRange.array)
       }

       else {
           self.checkAvailableDatesForBooking(dates: optionCurrentDateRange.array)
       }
    }
    
    @IBAction func closeErrorView() {
        viewErrorHolder.isHidden = true
    }
    
    
    fileprivate func showDate(_ userTap: Bool) {
       
        if userTap {
            let seventhRowStartDate = optionCurrentDate.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 1, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        else {
            calendarTable.reloadData()
        }
        
        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
            animations: {
                self.calendarTable.alpha = 1
        },
            completion: nil
        )
    }
    
    
    
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "d' 'MMM' 'yyyy"
        formatter.locale = Language.getCurrentLanguage().locale
//      formatter.calendar = Language.getCurrentLanguage().calIdentifier
       
        let todayDate = formatter.date(from: today)!
//        let hijriCalendar = NSCalendar.init(identifier: NSCalendar.Identifier.islamicCivil)
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            //Language.getCurrentLanguage().identifier//NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        myCalendar.locale = Language.getCurrentLanguage().locale
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }
    
    //Selecting Date Click Act And View Load
    fileprivate func updateDate() {
        print("Row Updated")
        if let topPanelTitle = optionTopPanelTitle {
            dayLabel.text = topPanelTitle
        }
        rangeStartLabel.text = optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")
        rangeEndLabel.text = optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")
//
        let getWeekDay = self.getDayOfWeek(today: optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy"))
        var getLastDayWeek = self.getDayOfWeek(today: optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy"))
        
        rangeStartLabel.text = (String(format: "%@ %@",weekDays[getWeekDay-1], optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")) as NSString) as String

        rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek-1], optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")) as NSString) as String
        
//        rangeStartLabel.text = self.lang.checkin_Title
//        rangeEndLabel.text   = self.lang.checkout_Title
        
        if shouldResetRange {
            print("shouldResetRange")
            rangeStartLabel.textColor = optionSelectorPanelFontColorDateHighlight
            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
            //            doneButton.alpha = 1.0
            //            doneButton.isUserInteractionEnabled = true
        }
        else {
            
            print("not shouldResetRange")
            rangeStartLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDate: optionSelectorPanelFontColorDateHighlight
            rangeEndLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDateHighlight: optionSelectorPanelFontColorDate
            //            doneButton.alpha = 0.5
            //            doneButton.isUserInteractionEnabled = false
        }
        
//        if rangeStartLabel.text == rangeEndLabel.text
//        {
//            print("start time and end time same")
//            shouldResetRange = false
//            //            doneButton.alpha = 0.5
//            //            doneButton.isUserInteractionEnabled = false
//            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
//            //            rangeEndLabel.text = "Check out"
//            //            let formalDates = optionCurrentDateRange.start
//            let startDay = optionCurrentDateRange.start
//            //let start = Calendar.current.date(byAdding: .day, value: 0, to: startDay)
//            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
//            //            let dateFormatter = DateFormatter()
//            //
//            //            dateFormatter.dateStyle = DateFormatter.Style.medium
//            //
//            //            dateFormatter.timeStyle = DateFormatter.Style.none
//            //            dateFormatter.dateFormat = "yyy-MM-dd"
//            //
//            //            let strCheckInDate = dateFormatter.string(from: startDay)
//            
//            if getLastDayWeek==7
//            {
//                getLastDayWeek = 0
//            }
//            rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek], (start?.stringFromFormat("d' 'MMM' 'yyyy"))!) as NSString) as String
//            //            optionCurrentDateRange.setEndDate((start?.beginningOfDay)!)
//            //            shouldResetRange = true
//        }
    }
    
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == calendarTable {
            return tableView.frame.height / 8
        }
        return tableView.frame.height / 5
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("calendar count",appDelegate.multipleDates.count)
        if tableView == calendarTable {
            print("if conditions")
//            return 16
            return 16
           // return 1
        }
        return appDelegate.multipleDates.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if tableView == calendarTable {
//            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
//                cell = c
//            }
         //   else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                let calRow = WWCalendarRow()
                calRow.translatesAutoresizingMaskIntoConstraints = false
                calRow.delegate = self
            calRow.notAvailableDays = self.notAvailableDays
                calRow.backgroundColor = UIColor.clear
                calRow.monthFont = optionCalendarFontMonth
                calRow.monthFontColor = optionCalendarFontColorMonth
                calRow.dayFont = optionCalendarFontDays
                calRow.dayFontColor = optionCalendarFontColorDays
                calRow.datePastFont = optionCalendarFontPastDates
                calRow.datePastFontHighlight = optionCalendarFontPastDatesHighlight
                calRow.datePastFontColor = optionCalendarFontColorPastDates
                calRow.datePastHighlightFontColor = optionCalendarFontColorPastDatesHighlight
                calRow.datePastHighlightBackgroundColor = optionCalendarBackgroundColorPastDatesHighlight
                calRow.datePastFlashBackgroundColor = optionCalendarBackgroundColorPastDatesFlash
                calRow.dateTodayFont = optionCalendarFontToday
                calRow.dateTodayFontHighlight = optionCalendarFontTodayHighlight
                calRow.dateTodayFontColor = optionCalendarFontColorToday
                calRow.dateTodayHighlightFontColor = optionCalendarFontColorTodayHighlight
                calRow.dateTodayHighlightBackgroundColor = optionCalendarBackgroundColorTodayHighlight
                calRow.dateTodayFlashBackgroundColor = optionCalendarBackgroundColorTodayFlash
                calRow.dateFutureFont = optionCalendarFontFutureDates
                calRow.dateFutureFontHighlight = optionCalendarFontFutureDatesHighlight
                calRow.dateFutureFontColor = optionCalendarFontColorFutureDates
                calRow.dateFutureHighlightFontColor = optionCalendarFontColorFutureDatesHighlight
                calRow.dateFutureHighlightBackgroundColor = optionCalendarBackgroundColorFutureDatesHighlight
                calRow.dateFutureFlashBackgroundColor = optionCalendarBackgroundColorFutureDatesFlash
                calRow.flashDuration = selAnimationDuration
                calRow.multipleSelectionGrouping = optionMultipleSelectionGrouping
                calRow.multipleSelectionEnabled = optionSelectionType != .single
                
                cell.contentView.addSubview(calRow)
                cell.backgroundColor = UIColor.clear
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
                
//                let today = Date().beginningOfDay
//                print("today day",today.weekday)
//            let dates = self.arrBlockedDates.mutableCopy() as! NSMutableArray
//                calRow.arrBlockedDates = dates
//                calRow.isDateSelected = isDateSelected
                    

         //   }
            
            if arrBlockedDates.count>0
            {
                calRow.arrBlockedDates = arrBlockedDates
                calRow.isDateSelected = isDateSelected
            }
            
            for sv in cell.contentView.subviews {
                if let calRow = sv as? WWCalendarRow {
                    calRow.tag = (indexPath as NSIndexPath).row + 1
                    switch optionSelectionType {
                    case .single:
                        calRow.selectedDates = [optionCurrentDate]
                    case .multiple:
                        calRow.selectedDates = optionCurrentDates
                    case .range:
                        calRow.selectedDates = Set(optionCurrentDateRange.array)
                    }
                    calRow.setNeedsDisplay()
                    if let fd = flashDate {
                        if calRow.flashDate(fd) {
                            flashDate = nil
                        }
                    }
                }
            }
        }
            
        else { // multiple dates table
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.backgroundColor = UIColor.clear
            }
            
            let date = appDelegate.multipleDates[(indexPath as NSIndexPath).row]
            cell.textLabel?.font = date == multipleDatesLastAdded ? optionSelectorPanelFontMultipleSelectionHighlight : optionSelectorPanelFontMultipleSelection
            cell.textLabel?.textColor = date == multipleDatesLastAdded ? optionSelectorPanelFontColorMultipleSelectionHighlight : optionSelectorPanelFontColorMultipleSelection
            cell.textLabel?.text = date.stringFromFormat("EEE', 'd' 'MMM' 'yyyy")
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == yearTable {
            let displayYear = yearRow1 + (indexPath as NSIndexPath).row
            let newDate = optionCurrentDate.change(year: displayYear)
            if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: newDate!) ?? true {
                optionCurrentDate = newDate!
                updateDate()
                tableView.reloadData()
            }
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if scrollView == calendarTable {
            let twoRow = bottomContainerView.frame.height / 4
            if offsetY < twoRow {
                // every row shift by 4 to the back, recalculate top 3 towards earlier dates
                
                let detail1 = WWCalendarRowGetDetails(-3)
                let detail2 = WWCalendarRowGetDetails(-2)
                let detail3 = WWCalendarRowGetDetails(-1)
                
//                if detail3.startDate.compare(Date()) == .orderedDescending {
//                    return
//                }
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + twoRow * 2)
                calendarTable.reloadData()
            }
            else if offsetY > twoRow * 3 {
                // every row shift by 4 to the front, recalculate top 3 towards later dates
                
                let detail1 = WWCalendarRowGetDetails(5)
                let detail2 = WWCalendarRowGetDetails(6)
                let detail3 = WWCalendarRowGetDetails(7)
                if self.maximumYearInDate.compare(detail1.startDate) == .orderedSame {
                   
//                    self.sharedAppDelegete.createToastMessage("No more date")
                    return
                }
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                print(calRow1StartDate.toString())
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - twoRow * 2)
                calendarTable.reloadData()
                
            }
        }
        else if scrollView == yearTable {
            let triggerPoint = backgroundContentView.frame.height / 10 * 3
            if offsetY < triggerPoint {
                //yearRow1 = yearRow1 - 3
                yearRow1 = yearRow1 - 1
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + triggerPoint * 2)
                yearTable.reloadData()
            }
            else if offsetY > triggerPoint * 3 {
                //yearRow1 = yearRow1 + 3
                 yearRow1 = yearRow1 + 1
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - triggerPoint * 2)
                yearTable.reloadData()
            }
        }
    }
    
    // CAN DO BETTER! TOO MANY LOOPS!
    internal func WWCalendarRowGetDetails(_ row: Int) -> (type: WWCalendarRowType, startDate: Date) {
        if row == 1 {
            return (calRow1Type, calRow1StartDate)
        }
        else if row == 2 {
            return (calRow2Type, calRow2StartDate)
        }
        else if row == 3 {
            return (calRow3Type, calRow3StartDate)
        }
        else if row > 3 {
            var startRow: Int
            var startDate: Date
            var rowType: WWCalendarRowType
            if calRow3Type == .date {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            
            for _ in startRow..<row {
                if rowType == .month {
                    rowType = .day
                }
                else if rowType == .day {
                    rowType = .date
                    startDate = startDate.beginningOfMonth
                }
                else {
                    let newStartDate = startDate.endOfWeek + 1.day
                    if newStartDate.month != startDate.month {
                        rowType = .month
                    }
                    startDate = newStartDate
                }
            }
            return (rowType, startDate)
        }
        else {
            // row <= 0
            var startRow: Int
            var startDate: Date
            var rowType: WWCalendarRowType
            if calRow1Type == .date {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            
            for _ in row..<startRow {
                if rowType == .date {
                    if startDate.day == 1 {
                        rowType = .day
                    }
                    else {
                        let newStartDate = (startDate - 1.day).beginningOfWeek
                        if newStartDate.month != startDate.month {
                            startDate = startDate.beginningOfMonth
                        }
                        else {
                            startDate = newStartDate
                        }
                    }
                }
                else if rowType == .day {
                    rowType = .month
                }
                else {
                    rowType = .date
                    startDate = (startDate - 1.day).beginningOfWeek
                }
            }
            return (rowType, startDate)
        }
    }
    
    //MARK: *************** Select date *****************
    
    internal func WWCalendarRowDidSelect(_ date: Date) {
      
        
        
            if self.notAvailableDays.contains(String(date.weekday)) {
                return
            }
            
        
        
        print("date\(date)")
        print("RowDidSelect")
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            switch optionSelectionType {
            case .single:
                optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day)
                //updateDate()
               //  selectedDate = date.stringFromFormat("dd-MM-YYY")
                selectedDate  =  date.stringFromFormat("d' 'MMM' 'yyyy")
//                updateDateExperiences()
                 updateDate()
            case .multiple:
                break
            case .range:
                
               // viewErrorHolder.isHidden = false
                if !viewErrorHolder.isHidden
                {
                    viewErrorHolder.isHidden = true
                }
                
                if isFromExplorePage
                {
                    self.startEndTimeView.isHidden = false
                    self.startEndTimeHeight.constant = 73.0
                    
                }
                else
                {
                    self.startEndTimeView.isHidden = true
                    self.startEndTimeHeight.constant = 0.0
                }
                
                let date1 : NSDate = date as NSDate
                let date2 : NSDate = NSDate() //initialized by default with the current date
                let calendar = Calendar.current.date(byAdding: .day, value: -1, to: date1 as Date)
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date1 as Date)
//                    \date2.addingTimeInterval(-24 * 60 * 60)
                print("date1\(date1) date2 \(date2) yesterday\(yesterday)")
                
                let compareResult = date1.compare(yesterday as! Date)
                let compareResult1 = date1.compare(date2 as Date)
                if compareResult == ComparisonResult.orderedAscending {
                    return
                }
                if compareResult1 == ComparisonResult.orderedAscending {
                    return
                }else{
                    if isFirstClick{
                        //isFirstClick = false
                        //shouldResetRange=false;
                        //isSelectingStartRange=false;
                    }
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                
                dateFormatter.timeStyle = DateFormatter.Style.none
                dateFormatter.dateFormat = "dd-MM-yyy"
                //"MM/dd/yyy"
                dateFormatter.locale = Language.getCurrentLanguage().locale
                let strCheckInDate = dateFormatter.string(from: date)
                
                if arrBlockedDates.count>0
                    {
                    isDateSelected = true
                    if self.arrBlockedDates.contains(String(strCheckInDate)) {
                        appDelegate.createToastMessage(lang.date_Avail)
                        return
                    }
                }
                
//                if arrBlockedDates.count>0
//                {
//                    isDateSelected = true
//                    for i in 0...arrBlockedDates.count-1
//                    {
//                        let strBlocked = arrBlockedDates[i] as! NSString
//                        if strCheckInDate == strBlocked as String {
//                            appDelegate.createToastMessage("Dates are bloacked")
//                            return
//                        }
//                    }
//                }
                
                let rangeDate = date.beginningOfDay
                if shouldResetRange {
                    optionCurrentDateRange.setStartDate(rangeDate)
                    optionCurrentDateRange.setEndDate(rangeDate)
                    isSelectingStartRange = false
                    shouldResetRange = false
                }
                else {
                    print(isSelectingStartRange)
                    if isSelectingStartRange {
                        //single
                        optionCurrentDateRange.setStartDate(rangeDate)
                        isSelectingStartRange = false
                        //                        appDelegate.singledate = rangeDate
                    }
                    else {
                        // multiple select
                        let date0 : Date = rangeDate // end date
                        let date1 : Date = optionCurrentDateRange.start // start date
                        optionCurrentDateRange.setStartDate(min(date0, date1))
                        optionCurrentDateRange.setEndDate(max(date0, date1))
                        shouldResetRange = true
                    }
                }
                /* else {
                 if isSelectingStartRange {
                 optionCurrentDateRange.setStartDate(rangeDate)
                 isSelectingStartRange = false
                 }
                 else {
                 optionCurrentDateRange.setEndDate(rangeDate)
                 shouldResetRange = true
                 }
                 }*/
                updateDate()
            }
            calendarTable.reloadData()
        }
    }
    
    @IBAction func cancel() {
        if isFromExplorePage
        {
            self.cancelTapped()
            let _ = navigationController?.popViewController(animated: false)
            return
        }
        let picker = self
        let del = delegate
        if optionSelectionType == .single {
            del?.WWCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
        }
        else {
            del?.WWCalendarTimeSelectorCancel?(picker, dates: appDelegate.multipleDates)
        }
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        self.dismiss(animated: true) {
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
        }
    }
    
    func cancelTapped() {
        let picker = self
        let del = delegate
        del?.WWCalendarTimeSelectorCancel?(picker, dates: appDelegate.multipleDates)
    }
   
}

extension WWCalendarTimeSelector:UIPopoverPresentationControllerDelegate{
    @nonobjc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        print("adaptive was called")
        return .none
    }
}



@objc internal enum WWCalendarRowType: Int {
    case month, day, date
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





/// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
///
/// `WWCalendarTimeSelectorDone:selector:dates:`
/// `WWCalendarTimeSelectorDone:selector:date:`
/// `WWCalendarTimeSelectorCancel:selector:dates:`
/// `WWCalendarTimeSelectorCancel:selector:date:`
/// `WWCalendarTimeSelectorWillDismiss:selector:`
/// `WWCalendarTimeSelectorDidDismiss:selector:`
@objc public protocol WWCalendarTimeSelectorProtocol {
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    @objc optional func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method called after the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that has been dismissed.
    @objc optional func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method if implemented, will be used to determine if a particular date should be selected.
    ///
    /// - Parameters:
    ///     - selector: The selector that is checking for selectablity of date.
    ///     - date: The date that user tapped, but have not yet given feedback to determine if should be selected.
    @objc optional func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool
}
