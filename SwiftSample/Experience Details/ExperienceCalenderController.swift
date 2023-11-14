//
//  ExperienceCalenderController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/23/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//



import UIKit

open class ExperienceCalenderController: UIViewController, UITableViewDelegate, UITableViewDataSource, WWCalendarRowProtocol, WWClockProtocol {

    /// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
    ///
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    /// `WWCalendarTimeSelectorDone:selector:date:`
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    open var delegate: ExWWCalendarTimeSelectorProtocol?
    open var callAPI: Bool = false
    open var arrBlockedDates = [String]()
    /// A convenient identifier object. Not used by `WWCalendarTimeSelector`.
    open var optionIdentifier: AnyObject?

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
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
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

    @IBOutlet weak var where_Lik: UILabel!
    

    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet fileprivate weak var selDateView: UIView!
    @IBOutlet fileprivate weak var dayLabel: UILabel!
    @IBOutlet fileprivate weak var monthLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var yearLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var rangeStartLabel: UILabel!
    @IBOutlet fileprivate weak var rangeToLabel: UILabel!
    @IBOutlet fileprivate weak var rangeEndLabel: UILabel!
    @IBOutlet fileprivate weak var calendarTable: UITableView!
    //    @IBOutlet fileprivate weak var viewGradient: UIView!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var lineLbl: UILabel!
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
    var token = ""
    var expselectedDate = ""
    var expStartT = ""
    var expEndT = ""
    var expPernight_price = ""

    var isDateSelected : Bool = false
    var isFromExplorePage : Bool = false
    var backFromMain : Bool = false

    @IBOutlet var viewErrorHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var experienceDetails: ExperienceRoomDetails!
    var selectedDate:String!

    @IBOutlet var animatedImgBooking: FLAnimatedImageView?

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
    fileprivate var isFromDidLoad = false
    fileprivate var isFirstClick = true
    fileprivate var selTimeStateHour = true
    fileprivate var calRow1Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow2Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow3Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow1StartDate: Date = Date()
    fileprivate var calRow2StartDate: Date = Date()
    fileprivate var calRow3StartDate: Date = Date()
    fileprivate var yearRow1: Int = 2016
    fileprivate var multipleDates: [Date] { return optionCurrentDates.sorted(by: { $0.compare($1) == ComparisonResult.orderedAscending }) }
    fileprivate var multipleDatesLastAdded: Date?
    var flashDate: Date?
    fileprivate let defaultTopPanelTitleForMultipleDates = "Select Multiple Dates"
    fileprivate let portraitHeight: CGFloat = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    fileprivate let portraitWidth: CGFloat = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    fileprivate var isSelectingStartRange: Bool = false{
        didSet {
            rangeStartLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDate: optionSelectorPanelFontColorDateHighlight;
            rangeEndLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDateHighlight: optionSelectorPanelFontColorDate
        }
    }
    fileprivate var shouldResetRange: Bool = false

    /// Only use this method to instantiate the selector. All customization should be done before presenting the selector to the user.
    /// To receive callbacks from selector, set the `delegate` of selector and implement `WWCalendarTimeSelectorProtocol`.
    ///
    ///     let selector = WWCalendarTimeSelector.instantiate()
    ///     selector.delegate = self
    ///     presentViewController(selector, animated: true, completion: nil)
    ///

    fileprivate var weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    open override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    
    func getDateFromString(dateStr: String) -> (date: Date?,conversion: Bool)
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponentArray = dateStr.components(separatedBy: "/")
        if dateComponentArray.count == 3 {
            var components = DateComponents()
            components.year = Int(dateComponentArray[2])
            components.month = Int(dateComponentArray[1])
            components.day = Int(dateComponentArray[0])
            components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            guard let date = calendar.date(from: components) else {
                return (nil , false)
            }
            print(date)
            return (date,true)
        } else {
            return (nil,false)
        }
    }
    
    
    
    func getRoomDetails(room_id:Int) {
        let viewProgress = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        viewProgress.isShowLoaderAnimaiton = true
        viewProgress.view.tag = Int(123456)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = true
        self.view.addSubview(viewProgress.view)
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        if appDelegate.lastPageMaintain == "ExpContact"{
            dicts["host_experience_id"] = appDelegate.expRoomID
        }
        else{
            dicts["host_experience_id"] = room_id
        }
        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_EXPERIENCE as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let roomModel = response as! ExperienceRoomDetails
            OperationQueue.main.addOperation {
                if roomModel.statusCode == "1"
                {
                    self.experienceDetails = roomModel
                    self.priceLabel.attributedText = MakentSupport().getBigAndNormalString(originalText: String(format: "%@ %@ \(self.lang.perprsn_Tit)",(self.experienceDetails.currencySymbol! as String).stringByDecodingHTMLEntities, "\(self.experienceDetails.experiencePrice!)" as String) as NSString, normalText: self.lang.perprsn_Tit as NSString, attributeText: "\(self.experienceDetails.experiencePrice!)" as NSString, font: (self.priceLabel.font)!)
//                    self.modelRoomDetails = roomModel
//                    var images:[String] = []
//                    self.modelRoomDetails.experienceImages?.forEach{
//                        images.append($0.name!)
//                    }
//                    self.setTableHeaderImages(arrHeaderImgs: images as NSArray)
//                    self.setRoomsInformation(ModelRooms: roomModel)
//                    self.arrlengthStayData.removeAllObjects()
//                    self.arrEarlybirdData.removeAllObjects()
//                    self.arrLastMinData.removeAllObjects()
//                    self.availability.removeAllObjects()
//                    self.arraminities.removeAllObjects()
//                    self.tblRoomDetail.reloadData()
                }
                else
                {
                    if roomModel.successMessage == "token_invalid" || roomModel.successMessage == "user_not_found" || roomModel.successMessage == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
 
            }
            DispatchQueue.main.async {
                self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                self.appDelegate.window?.isUserInteractionEnabled = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                DispatchQueue.main.async {
                    self.appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
                    self.appDelegate.window?.isUserInteractionEnabled = true
                }
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        token = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN) as String
        selectedDate = Date().stringFromFormat("dd-MM-YYY")
        Constants().STOREVALUE(value: "notselected", keyname: "isDateSelected")
        isFirstLoad = true
        isFromDidLoad = true
        where_Lik.text = self.lang.whrlik_Msg
        where_Lik.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        weekDays = [lang.sun_Title,lang.mon_Title,lang.tue_Title,lang.wed_Title,lang.thurs_Title,lang.fri_Title,lang.sat_Title]
        lineLbl.appGuestBGColor()
        doneButton.appGuestBGColor()
//        where_Lik.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        self.doneButton.setTitle(self.lang.choos_Tit, for: .normal)
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
        yearRow1 = optionCurrentDate.year - 5
        calendarTable.setContentOffset(CGPoint(x: 0, y:250), animated:true)
        view.layoutIfNeeded()
//        if experienceDetails.blockedDates != nil{
//            if (experienceDetails.blockedDates?.count)! > 0{
//                self.arrBlockedDates = NSMutableArray(array: experienceDetails.blockedDates!)
//            }
//        }
        
        if callAPI
        {
            self.animatedImgBooking?.isHidden = true
        }
       
        if appDelegate.selecredExpDate  != "" {
            self.experienceDetails = appDelegate.experienceDetails
            selectedDate = appDelegate.selecredExpDate
            let strCurrency = Constants().GETVALUE(keyname: APPURL.USER_CURRENCY_SYMBOL) as String
            self.room_Id = appDelegate.strRoomID
            timeLabel.text = (appDelegate.expStartTime) + "-" + appDelegate.expEndTime
            expStartT = appDelegate.expStartTime
            expEndT = appDelegate.expEndTime
            expPernight_price = appDelegate.expPricepertnight
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.locale = Locale(identifier: "en_US")
            //            let date1:Date = dateFormatter.date(from: "\(appDelegate.selecredExpDate)")!
            let oldSelectedDate = dateFormatter.date(from: selectedDate)!
            if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: oldSelectedDate) ?? true {
                optionCurrentDate = optionCurrentDate.change(year: oldSelectedDate.year, month: oldSelectedDate.month, day: oldSelectedDate.day)
                WWCalendarRowDidSelect(oldSelectedDate)
            }

            rangeStartLabel.text = oldSelectedDate.stringFromFormat("MMM d, yyyy")
            priceLabel.attributedText = MakentSupport().getBigAndNormalString(originalText: String(format: "%@ %@ \(self.lang.perprsn_Tit)",strCurrency.stringByDecodingHTMLEntities, "\(appDelegate.expPricepertnight)" as String) as NSString, normalText: "\(self.lang.perprsn_Tit)" as NSString, attributeText: "\(appDelegate.expPricepertnight)" as NSString, font: (priceLabel.font)!)
        }
        else{
            timeLabel.text = (experienceDetails.startTime!) + "-" + experienceDetails.endTime!
            rangeStartLabel.text = Date().stringFromFormat("MMM d, yyyy")
            priceLabel.attributedText = MakentSupport().getBigAndNormalString(originalText: String(format: "%@ %@ \(self.lang.perprsn_Tit)",(experienceDetails.currencySymbol! as String).stringByDecodingHTMLEntities, "\(experienceDetails.experiencePrice!)" as String) as NSString, normalText: "\(self.lang.perprsn_Tit)" as NSString, attributeText: "\(experienceDetails.experiencePrice!)" as NSString, font: (priceLabel.font)!)
        }
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotateOrNot), name: UIDevice.orientationDidChangeNotification, object: nil)
        
//        optionSelectionType = .single
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if isFirstLoad {
            isFirstLoad = false // Temp fix for i6s+ bug?
            calendarTable.reloadData()
            if clockView != nil {
                clockView.setNeedsDisplay()
            }
            self.didRotateOrNot()
            if optionStyles.showDateMonth {
                showDate(true)
            }
            else if optionStyles.showMonth {
                showMonth(true)
            }
            else if optionStyles.showYear {
                showYear(true)
            }
            else if optionStyles.showTime {
                showTime(true)
            }
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFromDidLoad {
            self.getRoomDetails(room_id: Int(room_Id)!)
            isFromDidLoad = true
        }
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isFromDidLoad = false
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isFirstLoad = false
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    internal func didRotateOrNot() {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
            
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
                animations: {
                    self.view.layoutIfNeeded()
            },
                completion: nil
            )

            if selCurrrent.showDateMonth {
                showDate(false)
            }
            else if selCurrrent.showMonth {
                showMonth(false)
            }
            else if selCurrrent.showYear {
                showYear(false)
            }
            else if selCurrrent.showTime {
                showTime(false)
            }
        }
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }

    open override var shouldAutorotate: Bool {
        return false
    }

    @IBAction func selectMonth(_ sender: UIButton) {
        let date = (optionCurrentDate.beginningOfYear + sender.tag.months).beginningOfDay
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day).beginningOfDay
        }
    }

    @IBAction func selectStartRange() {
        if isSelectingStartRange == true {
            let date = optionCurrentDateRange.start
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 15, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        else {
            isSelectingStartRange = true
        }
        shouldResetRange = false
//        updateDate()
    }

    @IBAction func selectEndRange() {
        if isSelectingStartRange == false {
            let date = optionCurrentDateRange.end
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        else {
            isSelectingStartRange = false
        }
        shouldResetRange = false
//        updateDate()
    }

    @IBAction func showDate() {
        if optionStyles.showDateMonth {
            showDate(true)
        }
        else {
            showMonth(true)
        }
    }

    @IBAction func showYear() {
        showYear(true)
    }

    @IBAction func showTime() {
        showTime(true)
    }

    @IBAction func cancel() {
        if isFromExplorePage
        {
            self.cancelTapped()
            self.navigationController?.popViewController(animated: false)
            return
        }
        if backFromMain == true {
//            let experienceDetailsStoryboard = UIStoryboard(name: "ExperienceDetails", bundle: nil)
//            let experienceDetails = experienceDetailsStoryboard.instantiateViewController(withIdentifier: "ExperienceDetailsController") as! ExperienceDetailsController
//            experienceDetails.hidesBottomBarWhenPushed = true
//            experienceDetails.strRoomId = Int(appDelegate.strRoomID)!
            appDelegate.expPricepertnight = ""
            appDelegate.expStartTime = ""
            appDelegate.expEndTime = ""
            appDelegate.selecredExpDate = ""
//            experienceDetails.isFromCal = true
//            self.navigationController?.pushViewController(experienceDetails, animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            let picker = self
            let del = delegate
            if optionSelectionType == .single {
                del?.WWCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
            }
            else {
                del?.WWCalendarTimeSelectorCancel?(picker, dates: appDelegate.multipleDates)
            }
            del?.WWCalendarTimeSelectorWillDismiss?(picker)
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
            appDelegate.expPricepertnight = ""
            appDelegate.expStartTime = ""
            appDelegate.expEndTime = ""
            appDelegate.selecredExpDate = ""
            navigationController?.popViewController(animated: true)
        }

    }

    func cancelTapped() {
        let picker = self
        let del = delegate
        del?.WWCalendarTimeSelectorCancel?(picker, dates: appDelegate.multipleDates)
    }

    //MARK: API CALL FOR CHECKING AVAILABILITY
    func checkAvailableDatesForBooking()
    {
        if let path =  Bundle.main.path(forResource: "dot_loading_white", ofType: "gif")
        {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                animatedImgBooking?.animatedImage = gif
            }
        }

        doneButton.alpha = 0.5
        doneButton.isUserInteractionEnabled = false

        let rect = MakentSupport().getScreenSize()

//        var rectImg = animatedImgBooking?.frame
//        rectImg?.origin.y = rect.size.height - 50
//        rectImg?.origin.x = doneButton.frame.size.width - 80
//        animatedImgBooking?.frame = rectImg!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
//        selectedDate = selectedDate.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.-:").inverted)
        let date = dateFormatter.date(from:selectedDate)
       
        dateFormatter.locale = Locale(identifier: "en_US")
        selectedDate = dateFormatter.string(from: date ?? Date())
        
        animatedImgBooking?.isHidden = false
        print(" Date:",selectedDate)
        var dicts = [AnyHashable: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["date"] = selectedDate
        dicts["host_experience_id"] =  room_Id

        MakentAPICalls().GetRequest(dicts,methodName: APPURL.METHOD_EXPERIENCE_ROOM_AVAILABLE_STATUS as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! CheckDateAvailablity
            OperationQueue.main.addOperation {
                if gModel.statusCode == "1"{
                    self.onSuccess(model: gModel)
                }else if gModel.statusCode == "0" {
                    self.doneButton.setTitle(self.lang.save_Tit, for: .normal)
                    self.doneButton.titleLabel?.text = self.lang.save_Tit
                    if gModel.successMessage == "The date must be a date after today."{
                      self.appDelegate.createToastMessage(self.lang.date_Error, isSuccess: true)
                    }else{
                    self.appDelegate.createToastMessage(gModel.successMessage as! String, isSuccess: true)
                    }
                }else{
                    self.doneButton.setTitle(self.lang.save_Tit, for: .normal)
                    self.doneButton.titleLabel?.text = self.lang.save_Tit
                    self.disPlayErrorView()
                    if gModel.successMessage == "token_invalid" || gModel.successMessage == "user_not_found" || gModel.successMessage == "Authentication Failed"{
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.animatedImgBooking?.isHidden = true
                self.doneButton.alpha = 1.0
                self.doneButton.isUserInteractionEnabled = true
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.animatedImgBooking?.isHidden = true
                self.doneButton.alpha = 1.0
                self.doneButton.isUserInteractionEnabled = true
            }
        })

    }

    func disPlayErrorView(){
        let formalDates = optionCurrentDateRange.array
        WWCalendarRowDidSelect(formalDates[0])
        shouldResetRange = true
        calendarTable.reloadData()
        lblErrorMsg.text = lang.date_Error//"The date must be a date after today."
        viewErrorHolder.isHidden = false
        //        updateDate()
        let rangeDate = formalDates[0].beginningOfDay
        let start = Calendar.current.date(byAdding: .day, value: 1, to: rangeDate)
        //        optionCurrentDateRange.setEndDate((start?.beginningOfDay)!)
        let getLastDayWeek = self.getDayOfWeek(today: (start?.stringFromFormat("d' 'MMM' 'yyyy"))!)
         weekDays = [lang.sun_Title,lang.mon_Title,lang.tue_Title,lang.wed_Title,lang.thurs_Title,lang.fri_Title,lang.sat_Title]
        rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek-1], (start?.stringFromFormat("d' 'MMM' 'yyyy"))!) as NSString) as String
        doneButton.isUserInteractionEnabled = true
        doneButton.alpha = 1.0

    }

    func onSuccess(model:CheckDateAvailablity){
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
        
        let reviewGuestRequirementScene = UIStoryboard(name: "GuestPage", bundle: nil).instantiateViewController(withIdentifier: "ReviewGuestRequirementsController") as! ReviewGuestRequirementsController
        reviewGuestRequirementScene.checkAvailablityModel = model
        reviewGuestRequirementScene.experienceDetails = experienceDetails
        reviewGuestRequirementScene.datePicked = selectedDate
        self.navigationController?.pushViewController(reviewGuestRequirementScene, animated: true)
    }

    var fromContact = false
    @IBAction func done() {
        if appDelegate.userToken != "" || token != "" {
            
            self.checkAvailableDatesForBooking()
        }
        
         else{
          
            
            let mainPage = StoryBoard.account.instance.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            
                mainPage.hidesBottomBarWhenPushed = true
//                if backFromMain  == true {
//                    appDelegate.expStartTime = expStartT
//                    appDelegate.expEndTime = expEndT
//                    appDelegate.expPricepertnight = expPernight_price
//                }
//                else{
//                    appDelegate.expStartTime = experienceDetails.startTime!
//                    appDelegate.expEndTime = experienceDetails.endTime!
//                    appDelegate.expPricepertnight = "\(experienceDetails.experiencePrice!)"
//                  }
//            appDelegate.selecredExpDate = selectedDate
            appDelegate.expStartTime = experienceDetails.startTime!
            appDelegate.expEndTime = experienceDetails.endTime!
            appDelegate.expPricepertnight = "\(experienceDetails.experiencePrice!)"
            appDelegate.lastPageMaintain = "ExpCal"
            appDelegate.strRoomID = self.room_Id
            appDelegate.experienceDetails = self.experienceDetails
            
            let navController = UINavigationController(rootViewController: mainPage)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated:true, completion: nil)
//            self.navigationController?.pushViewController(mainPage, animated: false)
        }
    }

    @IBAction func closeErrorView() {
        viewErrorHolder.isHidden = true
    }

    fileprivate func showDate(_ userTap: Bool) {
        changeSelDate()

        if userTap {
            let seventhRowStartDate = optionCurrentDate.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.top, animated: true)
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

    fileprivate func showMonth(_ userTap: Bool) {
        changeSelMonth()

        if userTap {

        }
        else {

        }

        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.monthsView.alpha = 1
                self.yearTable.alpha = 0
                self.clockView.alpha = 0
        },
            completion: nil
        )
    }

    fileprivate func showYear(_ userTap: Bool) {
        changeSelYear()

        if userTap {
            yearRow1 = optionCurrentDate.year - 5
            yearTable.reloadData()
            yearTable.scrollToRow(at: IndexPath(row: 3, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        else {
            yearTable.reloadData()
        }

        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.monthsView.alpha = 0
                self.yearTable.alpha = 1
                self.clockView.alpha = 0
        },
            completion: nil
        )
    }

    fileprivate func showTime(_ userTap: Bool) {
        if userTap {
            if selCurrrent.showTime {
                selTimeStateHour = !selTimeStateHour
            }
            else {
                selTimeStateHour = true
            }
        }

        if optionTimeStep == .sixtyMinutes {
            selTimeStateHour = true
        }

        changeSelTime()

        if userTap {
            clockView.showingHour = selTimeStateHour
        }
        clockView.setNeedsDisplay()

        UIView.transition(
            with: clockView,
            duration: selAnimationDuration / 2,
            options: [UIView.AnimationOptions.transitionCrossDissolve],
            animations: {
                self.clockView.layer.displayIfNeeded()
        },
            completion: nil
        )

        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.monthsView.alpha = 0
                self.yearTable.alpha = 0
                self.clockView.alpha = 1
        },
            completion: nil
        )
    }

    func getDayOfWeek(today:String)->Int {

        let formatter  = DateFormatter()
        formatter.dateFormat = "d' 'MMM' 'yyyy"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }

    fileprivate func updateDate() {
       /* if let topPanelTitle = optionTopPanelTitle {
            dayLabel.text = topPanelTitle
        }

        rangeStartLabel.text = optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")
        rangeEndLabel.text = optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")

        let getWeekDay = self.getDayOfWeek(today: optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy"))

        var getLastDayWeek = self.getDayOfWeek(today: optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy"))

        rangeStartLabel.text = (String(format: "%@ %@",weekDays[getWeekDay-1], optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")) as NSString) as String

        rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek-1], optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")) as NSString) as String


        if shouldResetRange {
            rangeStartLabel.textColor = optionSelectorPanelFontColorDateHighlight
            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
        }
        else {
        }

        if rangeStartLabel.text == rangeEndLabel.text
        {
            shouldResetRange = false
            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
            let startDay = optionCurrentDateRange.start
            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
            if getLastDayWeek==7
            {
                getLastDayWeek = 0
            }
            rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek], (start?.stringFromFormat("d' 'MMM' 'yyyy"))!) as NSString) as String
        }*/
    }
    fileprivate func changeSelDate() {
    }

    fileprivate func changeSelMonth() {

    }

    fileprivate func changeSelYear() {
        let selInactiveHeight = self.selInactiveHeight

    }

    fileprivate func changeSelTime() {
        let selInactiveHeight = self.selInactiveHeight
        selDateYConstraint.constant = 0
        selMonthYConstraint.constant = 0
        selTimeTopConstraint.constant = 0
        selTimeLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        selDateLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        if optionStyles.showDateMonth || optionStyles.showMonth {
            selDateHeightConstraint.constant = selInactiveHeight
            if optionStyles.showYear {
                selYearHeightConstraint.constant = selInactiveHeight
            }
            else {
                selDateRightConstraint.constant = 0
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
            }
        }
        else {
            selDateHeightConstraint.constant = 0
            selDateTopConstraint.constant = 0
            if optionStyles.showYear {
                selYearHeightConstraint.constant = selInactiveHeight
                selYearLeftConstraint.constant = 0
            }
            else {
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
            }
        }
        timeLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleTime
        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
            animations: {
                self.timeLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleTime, y: self.optionSelectorPanelScaleTime)
                self.monthLabel.transform = CGAffineTransform.identity
                self.dateLabel.transform = CGAffineTransform.identity
                self.yearLabel.transform = CGAffineTransform.identity
                self.view.layoutIfNeeded()
        },
            completion: { _ in
                if self.selCurrrent.showTime {
                    self.monthLabel.contentScaleFactor = UIScreen.main.scale
                    self.dateLabel.contentScaleFactor = UIScreen.main.scale
                    self.yearLabel.contentScaleFactor = UIScreen.main.scale
                }
        }
        )
        selCurrrent.showTime(true)
        //updateDate()
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == calendarTable {
            return tableView.frame.height / 8
        }
        return tableView.frame.height / 5
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == calendarTable {
            return 16
        }
        return appDelegate.multipleDates.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        if tableView == calendarTable {
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                let calRow = WWCalendarRow()
                calRow.translatesAutoresizingMaskIntoConstraints = false
                calRow.delegate = self
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
                if arrBlockedDates.count>0
                {
                    calRow.arrBlockedDates = arrBlockedDates
                    calRow.isDateSelected = isDateSelected
                }
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
                    if flashDate != nil{
                    if let fd = flashDate {
                        if calRow.flashDate(fd) {
                            flashDate = nil
                        }
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
                print("newDate: \(newDate!)")
                rangeStartLabel.text = optionCurrentDate.stringFromFormat("d' 'MMM' 'yyyy")
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
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate

                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - twoRow * 2)
                calendarTable.reloadData()
            }
        }
        else if scrollView == yearTable {
            let triggerPoint = backgroundContentView.frame.height / 10 * 3
            if offsetY < triggerPoint {
                yearRow1 = yearRow1 - 3

                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + triggerPoint * 2)
                yearTable.reloadData()
            }
            else if offsetY > triggerPoint * 3 {
                yearRow1 = yearRow1 + 3

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
        print("date\(date)")
        rangeStartLabel.text = date.stringFromFormat("MMM d, yyyy")
        selectedDate = date.stringFromFormat("dd-MM-yyyy")
//        let date = dateFormatter.date(from:selectedDate)
//        //        print(date as Any)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        selectedDate = dateFormatter.string(from: date)
        let date1 = dateFormatter.date(from: selectedDate) ?? Date()

        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date1) ?? true {
            switch optionSelectionType {
            case .single:
                optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day)

            case .multiple:
                break
            case .range:
                let date1 : NSDate = date as NSDate
                let date2 : NSDate = NSDate() //initialized by default with the current date
                let yesterday = date2.addingTimeInterval(-24 * 60 * 60)
                print("date1\(date1) date2 \(date2) yesterday\(yesterday)")

                let compareResult = date1.compare(yesterday as Date)
                let compareResult1 = date1.compare(date2 as Date)
                if compareResult == ComparisonResult.orderedAscending {

                    return
                }else{
                    if isFirstClick{
                        
                    }
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.none
                dateFormatter.dateFormat = "MM/dd/yyy"
                let strCheckInDate = dateFormatter.string(from: date)
                if arrBlockedDates.count>0
                {
                    isDateSelected = true
                    for i in 0...arrBlockedDates.count-1
                    {
                        let strBlocked = arrBlockedDates[i] as! NSString
                        if strCheckInDate == strBlocked as String {
                            return
                        }
                    }
                }

                let rangeDate = date.beginningOfDay
                if shouldResetRange {
                    optionCurrentDateRange.setStartDate(rangeDate)
                    optionCurrentDateRange.setEndDate(rangeDate)
                    isSelectingStartRange = false
                    shouldResetRange = false
                }
                else {
                    if isSelectingStartRange {
                        //single
                        optionCurrentDateRange.setStartDate(rangeDate)
                        isSelectingStartRange = false

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
            }
            calendarTable.reloadData()
        }
    }

    internal func WWClockGetTime() -> Date {
        return optionCurrentDate
    }

    internal func WWClockSwitchAMPM(isAM: Bool, isPM: Bool) {
        var newHour = optionCurrentDate.hour
        if isAM && newHour >= 12 {
            newHour = newHour - 12
        }
        if isPM && newHour < 12 {
            newHour = newHour + 12
        }

        optionCurrentDate = optionCurrentDate.change(hour: newHour)
        clockView.setNeedsDisplay()
        UIView.transition(
            with: clockView,
            duration: selAnimationDuration / 2,
            options: [UIView.AnimationOptions.transitionCrossDissolve, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.beginFromCurrentState],
            animations: {
                self.clockView.layer.displayIfNeeded()
        },
            completion: nil
        )
    }

    internal func WWClockSetHourMilitary(_ hour: Int) {
        optionCurrentDate = optionCurrentDate.change(hour: hour)
        clockView.setNeedsDisplay()
    }

    internal func WWClockSetMinute(_ minute: Int) {
        optionCurrentDate = optionCurrentDate.change(minute: minute)
        clockView.setNeedsDisplay()
    }
    
}


@objc public protocol ExWWCalendarTimeSelectorProtocol {

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
    @objc optional func WWCalendarTimeSelectorDone(_ selector: ExperienceCalenderController, dates: [Date])

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
    @objc optional func WWCalendarTimeSelectorDone(_ selector: ExperienceCalenderController, date: Date)

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
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: ExperienceCalenderController, dates: [Date])

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
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: ExperienceCalenderController, date: Date)

    /// Method called before the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    @objc optional func WWCalendarTimeSelectorWillDismiss(_ selector: ExperienceCalenderController)

    /// Method called after the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that has been dismissed.
    @objc optional func WWCalendarTimeSelectorDidDismiss(_ selector: ExperienceCalenderController)

    /// Method if implemented, will be used to determine if a particular date should be selected.
    ///
    /// - Parameters:
    ///     - selector: The selector that is checking for selectablity of date.
    ///     - date: The date that user tapped, but have not yet given feedback to determine if should be selected.
    @objc optional func WWCalendarTimeSelectorShouldSelectDate(_ selector: ExperienceCalenderController, date: Date) -> Bool
}


