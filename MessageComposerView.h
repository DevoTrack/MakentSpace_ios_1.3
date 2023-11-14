/**
 * MessageComposerView.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MSGSTTweetHotViewWord) {
    MSGSTTweetViewHandle = 0,
    MSGSTTweetViewHashtag,
    MSGSTTweetViewStartag,
    MSGSTTweetViewLink,
};

@protocol MessageComposerViewDelegate;


@interface MessageComposerView : UIView<UITextViewDelegate>
@property(nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) NSRegularExpression *textCheckingRegularExpression;
@property (nonatomic, strong) NSRegularExpression *urlRegex;

@property (strong) NSTextStorage *textStorage;
@property (strong) NSLayoutManager *layoutManager;
@property (strong) NSTextContainer *textContainer;

@property (nonatomic, strong) NSString *cleanText;
@property (nonatomic, copy) NSAttributedString *cleanAttributedText;

@property (strong) NSMutableArray *rangesOfHotWords;

@property (nonatomic, strong) NSDictionary *attributesText;
@property (nonatomic, strong) NSDictionary *attributesHandle;
@property (nonatomic, strong) NSDictionary *attributesHashtag;
@property (nonatomic, strong) NSDictionary *attributesStartag;
@property (nonatomic, strong) NSDictionary *attributesLink;
@property (nonatomic, assign) BOOL isRTL;
@property(nonatomic, weak) id<MessageComposerViewDelegate> delegate;
@property(nonatomic, strong) UITextView *messageTextView;
@property(nonatomic, strong) NSString *messagePlaceholder;
@property(nonatomic, strong) UIButton *sendButton;
@property(nonatomic) UIEdgeInsets composerBackgroundInsets;
@property(nonatomic) UIEdgeInsets composerTVInsets;
@property(nonatomic) NSInteger keyboardHeight;
@property(nonatomic) NSInteger keyboardAnimationCurve;
@property(nonatomic) CGFloat keyboardAnimationDuration;
@property(nonatomic) NSInteger keyboardOffset;
@property(nonatomic, assign) BOOL isCompliMintEdited;
// configuration method.
- (void)setup;
// layout method
- (void)setupFrames;

// init with screen width and default height. Offset provided is space between composer and keyboard/bottom of screen
- (id)initWithFrame:(CGRect)frame isRTL:(BOOL)isRTL;
- (id)initWithKeyboardOffset:(NSInteger)offset andMaxHeight:(CGFloat)maxTVHeight;
// init with provided frame and offset between composer and keyboard/bottom of screen
- (id)initWithFrame:(CGRect)frame andKeyboardOffset:(NSInteger)offset;
// init with provided frame and offset between composer and keyboard/bottom of screen. Also set a max height on composer.
- (id)initWithFrame:(CGRect)frame andKeyboardOffset:(NSInteger)offset andMaxHeight:(CGFloat)maxTVHeight;
// provide a function to scroll the textview to bottom manually in fringe cases like loading message drafts etc.
- (void)scrollTextViewToBottom;
// for adding accessory views to the left of the messageTextView
- (void)configureWithAccessory:(UIView *)accessoryView;
// keyboarding resizing function in case you want to overwrite it
- (void)keyboardWillChangeFrame:(NSNotification *)notification;

// returns the current keyboard height. 0 if keyboard dismissed.
- (CGFloat)currentKeyboardHeight;

// To avoid exposing the UITextView and attempt to prevent bad practice, startEditing and finishEditing
// are available to become and resign first responder. This means you shouldn't have an excuse to
// do [messageComposerView.messageTextView resignFirstResponder] etc.
- (void)startEditing;
- (void)finishEditing;
- (void)beginTextEditing;


@property (nonatomic, strong) NSArray *validProtocols;
@property (nonatomic, assign) BOOL leftToRight;
@property (nonatomic, assign) BOOL textSelectable;
@property (nonatomic, strong) UIColor *selectionColor;
@property (nonatomic, copy) void (^detectionBlock)(MSGSTTweetHotViewWord hotWord, NSString *string, NSString *protocol, NSRange range);

@property (nonatomic,readwrite) NSRange   suggestionRange;
@property (nonatomic,readwrite,getter = isSuggesting)   BOOL      suggesting;

- (void)setAttributes:(NSDictionary *)attributes;
- (void)setAttributes:(NSDictionary *)attributes hotWord:(MSGSTTweetHotViewWord)hotWord;

- (NSDictionary *)attributes;
- (NSDictionary *)attributesForHotWord:(MSGSTTweetHotViewWord)hotWord;
- (id)initWithFrame:(CGRect)frame;
- (CGSize)suggestedFrameSizeToFitEntireStringConstrainedToWidth:(CGFloat)width;

-(void)removeShowroomNameInTweetTextView:(NSString *)strSelectedShowRoomName;

- (void)determineHotWordsNew;


@end

@protocol MessageComposerViewDelegate <NSObject>
// delegate method executed after the user clicks the send button. Message is the message contained within the
// text view when send is pressed
- (void)messageComposerSendMessageClickedWithMessage:(NSString*)message;
//- (void)textPassToKeyboard:(NSString *)str;
//- (void)endSuggesting;
//- (void)textDidChange:(MessageComposerView*)commentView;


@optional
// executed whenever the MessageComposerView's frame changes. Provides the frame it is changing to and the animation duration
- (void)messageComposerFrameDidChange:(CGRect)frame withAnimationDuration:(CGFloat)duration __attribute__((deprecated));
// executed whenever the MessageComposerView's frame changes. Provides the frame it is changing to and the animation duration
- (void)messageComposerFrameDidChange:(CGRect)frame withAnimationDuration:(CGFloat)duration andCurve:(NSInteger)curve;
// executed whenever the user is typing in the text view
- (void)messageComposerUserTyping;
- (void)determineHotWordsNew;


@end
