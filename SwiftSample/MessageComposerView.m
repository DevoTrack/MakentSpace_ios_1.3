/**
 * MessageComposerView.m
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#define STURLRegex @"(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))"

#define MAXCOMMENTLENGTH 500

#import "MessageComposerView.h"
//@protocol Language;

@interface MessageComposerView()
{
    BOOL _isTouchesMoved;
    NSRange _selectableRange;
    NSInteger _firstCharIndex;
    CGPoint _firstTouchLocation;
    NSInteger compliMintTxtCount;
    NSString *currentInput;
    //Class<LanguageProtocol> lang;
}

- (IBAction)sendClicked:(id)sender;
@property(nonatomic, strong) UIView *accessoryView;
@property(nonatomic, strong) UIView *accessoryViewSubView;
@property(nonatomic) CGFloat composerTVMaxHeight;
@end

@implementation MessageComposerView

const NSInteger defaultHeight = 44;
const NSInteger defaultMaxHeight = 100;

- (id)init {
    return [self initWithKeyboardOffset:0 andMaxHeight:defaultMaxHeight];
}

- (id)initWithKeyboardOffset:(NSInteger)offset andMaxHeight:(CGFloat)maxTVHeight {
    return [self initWithFrame:CGRectMake(0,[self currentScreenSize].height-defaultHeight,[self currentScreenSize].width,defaultHeight)
             andKeyboardOffset:offset
                  andMaxHeight:maxTVHeight];
}

- (void)textPassToKeyboard:(NSString *)str
{
    
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andKeyboardOffset:0];
}

- (id)initWithFrame:(CGRect)frame andKeyboardOffset:(NSInteger)offset {
    return [self initWithFrame:frame andKeyboardOffset:offset andMaxHeight:defaultMaxHeight];
}

- (id)initWithFrame:(CGRect)frame andKeyboardOffset:(NSInteger)offset andMaxHeight:(CGFloat)maxTVHeight {
    self = [super initWithFrame:frame];
    
    [self setupLabel];
    if (self)
    {
        // Insets for the entire MessageComposerView. Top inset is used as a minimum value of top padding.
        _composerBackgroundInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        // Insets only for the message UITextView. Default to 10 on the right (between )
        _composerTVInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        
        // Default animation time for 5 <= iOS <= 7. Should be overwritten by first keyboard notification.
        _keyboardAnimationDuration = 0.25;
        _keyboardAnimationCurve = 7;
        _keyboardOffset = offset;
        _composerBackgroundInsets.top = MAX(_composerBackgroundInsets.top, frame.size.height - _composerBackgroundInsets.bottom - 34);
        _composerTVMaxHeight = maxTVHeight;
        
        
        _textStorage   = [NSTextStorage new];
        _layoutManager = [NSLayoutManager new];
        _textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
        
        [_layoutManager addTextContainer:_textContainer];
        [_textStorage addLayoutManager:_layoutManager];
        
        // alloc necessary elements
        self.sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.sendButton addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = [[UIView alloc] init];
        
        // fix ridiculous jumpy scrolling bug inherant in native UITextView since 7.0
        // http://stackoverflow.com/a/19339716/740474
        NSString *reqSysVer = @"7.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        BOOL osVersionSupported = ([currSysVer compare:reqSysVer  options:NSNumericSearch] != NSOrderedAscending);
        if (osVersionSupported)  {
//            NSTextStorage* textStorage = [[NSTextStorage alloc] init];
//            NSLayoutManager* layoutManager = [NSLayoutManager new];
//            [textStorage addLayoutManager:layoutManager];
//            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
//            [layoutManager addTextContainer:textContainer];
            
            self.messageTextView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:_textContainer];
        } else {
            self.messageTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        }
        
        self.messageTextView.textColor = [UIColor darkGrayColor];

        self.messageTextView.tintColor = [UIColor colorWithRed:41.0/255 green:152.0/255 blue:134.0/255 alpha:1.0];
        // configure elements
        self.messagePlaceholder = @"Write a message";
        
        [self setup];
        
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:_messageTextView.frame];
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = _messageTextView.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.text =  @" Write a message";
        [_placeHolderLabel setHidden:YES];
        UIEdgeInsets myLabelInsets = {10, 20, 10, 0};
        [_placeHolderLabel drawTextInRect:UIEdgeInsetsInsetRect(_placeHolderLabel.frame, myLabelInsets)];

        // insert elements above MessageComposerView
        [self addSubview:self.sendButton];
        [self addSubview:self.accessoryView];
        [self addSubview:self.messageTextView];
        [self addSubview:_placeHolderLabel];
        
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup
{
//    currentInput = @"";

    self.backgroundColor = [UIColor whiteColor];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    
    [self.sendButton setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin)];
    [self.sendButton.layer setCornerRadius:5];
    [self.sendButton setTitleColor:[UIColor colorWithRed:216.0/255 green:127.0/255 blue:0.0/255 alpha:0.5] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithRed:216.0/255 green:127.0/255 blue:0.0/255 alpha:0.5] forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[UIColor colorWithRed:216.0/255 green:127.0/255 blue:0.0/255 alpha:0.5] forState:UIControlStateSelected];
    [self.sendButton setBackgroundColor:[UIColor clearColor]];
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendButton.titleLabel setFont:[UIFont fontWithName:@"CircularAirPro-Book" size:17.0]];
    
    [self.accessoryView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin)];
    
    [self.messageTextView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];
    [self.messageTextView setShowsHorizontalScrollIndicator:NO];
    [self.messageTextView.layer setCornerRadius:5];
//    [self.messageTextView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.messageTextView.layer setBorderWidth:0.7];


    [self.messageTextView setFont:[UIFont fontWithName:@"CircularAirPro-Light" size:17.0]];
    [self.messageTextView setTextColor:[UIColor lightGrayColor]];
    [self.messageTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.messageTextView setDelegate:self];
    
    [self setupFrames];
    
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    [self setupLabel];
}

- (void)setupFrames {
    CGRect sendButtonFrame = self.bounds;
    sendButtonFrame.size.width = 60;
    sendButtonFrame.size.height = sendButtonFrame.size.height - _composerBackgroundInsets.top - _composerBackgroundInsets.bottom;
    sendButtonFrame.origin.x = self.frame.size.width - _composerBackgroundInsets.right - sendButtonFrame.size.width+5;
    sendButtonFrame.origin.y = self.bounds.size.height - _composerBackgroundInsets.bottom - sendButtonFrame.size.height-4;
    [self.sendButton setFrame:sendButtonFrame];
    CGRect accessoryFrame = self.bounds;
    accessoryFrame.size.width = self.accessoryViewSubView.frame.size.width;
    accessoryFrame.size.height = accessoryFrame.size.height - _composerBackgroundInsets.top - _composerBackgroundInsets.bottom;
    accessoryFrame.origin.x = _composerBackgroundInsets.left;
    accessoryFrame.origin.y = self.bounds.size.height - _composerBackgroundInsets.bottom - accessoryFrame.size.height;
    [self.accessoryView setFrame:accessoryFrame];
    [self.accessoryViewSubView setCenter:CGPointMake(self.accessoryView.frame.size.width/2, self.accessoryView.frame.size.height/2)];
    
    CGRect messageTextViewFrame = self.bounds;
    messageTextViewFrame.origin.x = _composerTVInsets.left + _composerBackgroundInsets.left ;
    if (accessoryFrame.size.width > 0) {
        messageTextViewFrame.origin.x += accessoryFrame.size.width;
    }
    messageTextViewFrame.origin.y = 200;
    messageTextViewFrame.size.width = sendButtonFrame.origin.x - _composerTVInsets.right - accessoryFrame.size.width - _composerTVInsets.left - _composerBackgroundInsets.left;
    messageTextViewFrame.size.height = messageTextViewFrame.size.height - _composerBackgroundInsets.top - _composerBackgroundInsets.bottom;
    [self.messageTextView setFrame:messageTextViewFrame];
    
    [_placeHolderLabel setFrame:CGRectMake(messageTextViewFrame.origin.x+2, messageTextViewFrame.origin.y, messageTextViewFrame.size.width, messageTextViewFrame.size.height)];
}

- (void)layoutSubviews {
    // Due to inconsistent handling of rotation when receiving UIDeviceOrientationDidChange notifications
    // ( see http://stackoverflow.com/q/19974246/740474 ) rotation handling and view resizing is done here.
    CGFloat oldHeight = self.messageTextView.frame.size.height;
    CGFloat newHeight = [self sizeWithText:self.messageTextView.text];
    
    if (newHeight >= _composerTVMaxHeight) {
        [self scrollTextViewToBottom];
    }
    if (oldHeight == newHeight) {
        // In cases where the height remains the same after the text change/rotation only change the y origin
        CGRect frame = self.frame;
        frame.origin.y = ([self currentScreenSize].height - [self currentKeyboardHeight]) - frame.size.height - _keyboardOffset;
        self.frame = frame;
        
        // Even though the height didn't change the origin did so notify delegates
        // TODO: remove deprecated method
        if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:)]) {
            [self.delegate messageComposerFrameDidChange:frame withAnimationDuration:_keyboardAnimationDuration];
        }
        if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:andCurve:)]) {
            [self.delegate messageComposerFrameDidChange:frame withAnimationDuration:_keyboardAnimationDuration andCurve:_keyboardAnimationCurve];
        }
    } else {
        // The view is already animating as part of the rotation so we just have to make sure it
        // snaps to the right place and resizes the textView to wrap the text with the new width. Changing
        // to add an additional animation will overload the animation and make it look like someone is
        // shuffling a deck of cards.
        // Recalculate MessageComposerView container frame
        CGRect newContainerFrame = self.frame;
        newContainerFrame.size.height = newHeight + _composerBackgroundInsets.top + _composerBackgroundInsets.bottom + _composerTVInsets.top + _composerTVInsets.bottom;
        newContainerFrame.origin.y = ([self currentScreenSize].height - [self currentKeyboardHeight]) - newContainerFrame.size.height - _keyboardOffset;
        
        // Recalculate send button frame
        CGRect newSendButtonFrame = self.sendButton.frame;
        newSendButtonFrame.origin.y = newContainerFrame.size.height - (_composerBackgroundInsets.bottom + newSendButtonFrame.size.height);
        
        // Recalculate accessory frame
        CGRect newAccessoryFrame = self.accessoryView.frame;
        newAccessoryFrame.origin.y = newContainerFrame.size.height - (_composerBackgroundInsets.bottom + newAccessoryFrame.size.height);
        
        // Recalculate UITextView frame
        CGRect newTextViewFrame = self.messageTextView.frame;
        newTextViewFrame.size.height = newHeight;
        newTextViewFrame.origin.y = _composerBackgroundInsets.top + _composerTVInsets.top;
        
        self.frame = newContainerFrame;
        self.sendButton.frame = newSendButtonFrame;
        self.accessoryView.frame = newAccessoryFrame;
        self.messageTextView.frame = newTextViewFrame;
        
        [_placeHolderLabel setFrame:CGRectMake(newTextViewFrame.origin.x+2, newTextViewFrame.origin.y, newTextViewFrame.size.width, newTextViewFrame.size.height)];

//        [_placeHolderLabel setFrame:self.messageTextView.frame];
        [self scrollTextViewToBottom];
        
        // TODO: remove deprecated method
        if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:)]) {
            [self.delegate messageComposerFrameDidChange:newContainerFrame withAnimationDuration:0];
        }
        if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:andCurve:)]) {
            [self.delegate messageComposerFrameDidChange:newContainerFrame withAnimationDuration:0 andCurve:0];
        }
    }
}

#pragma mark - ============ @ # * FEATURE IMPLEMENTATION =============

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
//        [self.sendButton setTitle:(_isCompliMintEdited)?@"Update":@"Post" forState:UIControlStateNormal];
        [_placeHolderLabel setHidden:YES];
    }
    else
    {
//        [self.sendButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_placeHolderLabel setHidden:NO];
    }
    [self layoutSubviews];
    if ([textView.text isEqualToString:self.messagePlaceholder] || [textView.text length] == 0 || [self isStringOnlyWhiteSpace:textView.text]) {
//        [self.sendButton setEnabled:NO];
        //[UIColor colorWithRed:41.0/255 green:152.0/255 blue:134.0/255 alpha:0.5]
        [self.sendButton setTitleColor:[UIColor colorWithRed:216.0/255 green:127.0/255 blue:0.0/255 alpha:0.5] forState:UIControlStateNormal];
        //appGuestTextColor()

    } else {
        //[UIColor colorWithRed:41.0/255 green:152.0/255 blue:134.0/255 alpha:0.5]
        
        [self.sendButton setTitleColor:[UIColor colorWithRed:216.0/255 green:127.0/255 blue:0.0/255 alpha:1.0] forState:UIControlStateNormal];
        [self.sendButton setEnabled:YES];
        self.messageTextView.textColor = [UIColor blackColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(messageComposerUserTyping)])
        [self.delegate messageComposerUserTyping];
    
    [self determineHotWordsForMsgCompose];
}

- (void)setupURLRegularExpression {
    
    NSError *regexError = nil;
    self.urlRegex = [NSRegularExpression regularExpressionWithPattern:STURLRegex options:0 error:&regexError];
}

#pragma mark - Responder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:[_cleanText substringWithRange:_selectableRange]];
    
    @try {
        [_textStorage removeAttribute:NSBackgroundColorAttributeName range:_selectableRange];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)setupLabel
{
//    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:NO];
    [self setUserInteractionEnabled:YES];
    
    _leftToRight = YES;
    _textSelectable = YES;
    _selectionColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
        _attributesText = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"CircularAirPro-Light" size:17.0]};

    
    self.validProtocols = @[@"http", @"https"];
}


/*-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    currentInput = text;
    
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    
    if ([text containsString:@"*"]) {
        return NO;
    }
        
    if (textView.text.length==0)
    {
        if ([self.delegate isKindOfClass:[MSMintDetails class]])
        {
            if([text isEqualToString:@"\n"])
                [textView resignFirstResponder];
            //[self removeFromSuperview];
        }
    }
    if ([text isEqualToString: @""])
    {
        return YES;
    }
    else if([text isEqualToString:@"\n"]) {
        [self.messageTextView resignFirstResponder];
        return NO;
    }
    
    __block NSString *word = nil;
    __block NSRange ranges = NSMakeRange(NSNotFound, 0);
    NSString *textViewTXT = self.messageTextView.text;
    
    [self.textCheckingRegularExpression enumerateMatchesInString:textViewTXT
                                                         options:0
                                                           range:NSMakeRange(0, textViewTXT.length)
                                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         NSRange textSelectedRange = self.messageTextView.selectedRange;
         if (textSelectedRange.location > result.range.location && textSelectedRange.location <= result.range.location + result.range.length) {
             word = [textViewTXT substringWithRange:result.range];
             ranges = result.range;
             *stop = YES;
         }
     }];
    
    if ([text isEqualToString:@"@"] || [text isEqualToString:@"#"])
    {
        return YES;
    }
    
    NSUInteger newLength = (compliMintTxtCount - range.length) + [text stringByRemovingEmoji].length;
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    
    if(newLength <= MAXCOMMENTLENGTH)
    {
        return YES;
    }
    else
    {
        if (text.isIncludingEmoji)
        {
            if ([text stringByRemovingEmoji].length)
            {
                return NO;
            }
            return YES;
        }
        
        NSUInteger emptySpace = MAXCOMMENTLENGTH - (compliMintTxtCount - range.length);
        textView.text = [[[textView.text substringToIndex:range.location] stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        [self determineHotWordsNew];
        return NO;
    }
    
    return YES;
}*/
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    currentInput = text;
    
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    if ([text isEqualToString: @""])
    {
        return YES;
    }
    
    if ([text containsString:@"*"]) {
        return NO;
    }
    
    else if([text isEqualToString:@"\n"]) {
        [self.messageTextView resignFirstResponder];
        return NO;
    }
    
    
    
    __block NSString *word = nil;
    __block NSRange ranges = NSMakeRange(NSNotFound, 0);
    NSString *textViewTXT = self.messageTextView.text;
    
    [self.textCheckingRegularExpression enumerateMatchesInString:textViewTXT
                                                         options:0
                                                           range:NSMakeRange(0, textViewTXT.length)
                                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         NSRange textSelectedRange = self.messageTextView.selectedRange;
         if (textSelectedRange.location > result.range.location && textSelectedRange.location <= result.range.location + result.range.length) {
             word = [textViewTXT substringWithRange:result.range];
             ranges = result.range;
             *stop = YES;
         }
     }];
    
    if ([currentInput isEqualToString:@"@"] || [currentInput isEqualToString:@"#"] || [currentInput isEqualToString:@"*"])
    {
        return YES;
    }
    else if (word.length >= 1 && ranges.location != NSNotFound)
    {
        NSString *first = [word substringToIndex:1];
        
        if ([first isEqualToString:@"@"] || [first isEqualToString:@"#"] || [first isEqualToString:@"*"])
        {
            return YES;
        }
    }
    
    NSUInteger newLength = compliMintTxtCount + text.length;
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    
    if(newLength <= MAXCOMMENTLENGTH)
    {
        return YES;
    }
    else
    {
        NSUInteger emptySpace = MAXCOMMENTLENGTH - compliMintTxtCount;
        if (!(emptySpace>[text length])) {
            return NO;
        }
        if (emptySpace>MAXCOMMENTLENGTH) {
            return NO;
        }
        
        @try {
            NSUInteger emptySpace = MAXCOMMENTLENGTH - (compliMintTxtCount - range.length);
            textView.text = [[[textView.text substringToIndex:range.location] stringByAppendingString:[text substringToIndex:emptySpace]]
                             stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
            [_placeHolderLabel setHidden:(textView.text.length)?YES:NO];
            
            [self determineHotWordsNew];
        } @catch (...)
        {
        } @finally {
            return NO;
        }
        
        return NO;
    }
    
    return YES;
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    currentInput = text;
//    
//    if (range.location == 0 && [text isEqualToString:@" "]) {
//        return NO;
//    }
//    if ([text isEqualToString: @""])
//    {
//        return YES;
//    }
//    
//    if ([text containsString:@"*"]) {
//        return NO;
//    }
//    
//    else if([text isEqualToString:@"\n"]) {
//        [self.messageTextView resignFirstResponder];
//        return NO;
//    }
//    
//    
//    
//    __block NSString *word = nil;
//    __block NSRange ranges = NSMakeRange(NSNotFound, 0);
//    NSString *textViewTXT = self.messageTextView.text;
//    
//    [self.textCheckingRegularExpression enumerateMatchesInString:textViewTXT
//                                                         options:0
//                                                           range:NSMakeRange(0, textViewTXT.length)
//                                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
//     {
//         NSRange textSelectedRange = self.messageTextView.selectedRange;
//         if (textSelectedRange.location > result.range.location && textSelectedRange.location <= result.range.location + result.range.length) {
//             word = [textViewTXT substringWithRange:result.range];
//             ranges = result.range;
//             *stop = YES;
//         }
//     }];
//
//    if ([currentInput isEqualToString:@"@"] || [currentInput isEqualToString:@"#"] || [currentInput isEqualToString:@"*"])
//    {
//        return YES;
//    }
//    else if (word.length >= 1 && ranges.location != NSNotFound)
//    {
//        NSString *first = [word substringToIndex:1];
//        
//        if ([first isEqualToString:@"@"] || [first isEqualToString:@"#"] || [first isEqualToString:@"*"])
//        {
//            return YES;
//        }
//    }
//    
//    NSUInteger newLength = (compliMintTxtCount - range.length) + [text stringByRemovingEmoji].length;
//    if (range.location == 0 && [text isEqualToString:@" "]) {
//        return NO;
//    }
//    
//    if(newLength <= MAXCOMMENTLENGTH)
//    {
//        return YES;
//    }
//    else
//    {
//        if (text.isIncludingEmoji)
//        {
//            if ([text stringByRemovingEmoji].length)
//            {
//                return NO;
//            }
//            return YES;
//        }
//        NSUInteger emptySpace = MAXCOMMENTLENGTH - (compliMintTxtCount - range.length);
//        textView.text = [[[textView.text substringToIndex:range.location] stringByAppendingString:[text substringToIndex:emptySpace]]
//                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
//        [_placeHolderLabel setHidden:(textView.text.length)?YES:NO];
//
//        [self determineHotWordsNew];
//        return NO;
//    }
//    
//    return YES;
//}

- (void)determineHotWordsForMsgCompose
{
//    [self determineHotWordsNew];
//    __block NSString *word = nil;
//    __block NSRange range = NSMakeRange(NSNotFound, 0);
//    //    _cleanText = self.textView.text;
//    [self.delegate textDidChange:self];
//    NSString *textViewTXT = self.messageTextView.text;
//    
//    [self.textCheckingRegularExpression enumerateMatchesInString:textViewTXT
//                                                         options:0
//                                                           range:NSMakeRange(0, textViewTXT.length)
//                                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
//     {
//         NSRange textSelectedRange = self.messageTextView.selectedRange;
//         if (textSelectedRange.location > result.range.location && textSelectedRange.location <= result.range.location + result.range.length) {
//             word = [textViewTXT substringWithRange:result.range];
//             range = result.range;
//             *stop = YES;
//         }
//     }];
//    
//    if (word.length >= 1 && range.location != NSNotFound)
//    {
//        NSString *first = [word substringToIndex:1];
//        NSString *rest = [word substringFromIndex:1];
//        
//        if ([first isEqualToString:@"@"])
//        {
//            self.suggesting = YES;
//            self.suggestionRange = NSMakeRange(range.location + 1, range.length - 1);
//            NSLog(@"Making Range =====>  %@",NSStringFromRange(NSMakeRange(range.location + 1, range.length - 1)));
//            if (self.delegate) {
//                [self.delegate beginSuggestingForTextView:EntityTypeMention query:rest  Inrange:self.suggestionRange];
//            }
//        }
//        else if ([first isEqualToString:@"#"])
//        {
//            self.suggesting = YES;
//            self.suggestionRange = NSMakeRange(range.location + 1, range.length - 1);
//            if (self.delegate)
//            {
//                [self.delegate beginSuggestingForTextView:EntityTypeHashTag query:rest Inrange:self.suggestionRange];
//            }
//        }
//        else if ([first isEqualToString:@"*"])
//        {
//            self.suggesting = YES;
//            self.suggestionRange = NSMakeRange(range.location + 1, range.length - 1);
//            if (self.delegate) {
//                self.suggestionType = EntityTypeshowroom;
//                [self.delegate beginSuggestingForTextView:EntityTypeshowroom query:rest Inrange:self.suggestionRange];
//            }        }else {
//                self.suggestionRange = NSMakeRange(NSNotFound, 0);
//                self.suggesting = NO;
//                [self.delegate endSuggesting];
//            }
//    }
//    else
//    {
//        self.suggestionRange = NSMakeRange(NSNotFound, 0);
//        self.suggesting = NO;
//        [self.delegate endSuggesting];
//    }
}

- (NSRegularExpression *)textCheckingRegularExpression
{
    if (!_textCheckingRegularExpression)
    {
        _textCheckingRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[@#*]([^\\s/:：@#*]?)+$?" options:NSRegularExpressionCaseInsensitive error:NULL];
    }
    return _textCheckingRegularExpression;
}

- (void)setValidProtocols:(NSArray *)validProtocols {
    _validProtocols = validProtocols;
    if(self.messageTextView.text.length>0)
        [self determineHotWordsNew];
}

- (void)determineHotWordsNew
{
    _cleanText =self.messageTextView.text;
    NSMutableString *tmpText = [[NSMutableString alloc] initWithString:_cleanText];
    
    NSString *hotCharacters = @"@#*";
    NSCharacterSet *hotCharactersSet = [NSCharacterSet characterSetWithCharactersInString:hotCharacters];
    
    // Define a character set for the complete world (determine the end of the hot word)
    NSMutableCharacterSet *validCharactersSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [validCharactersSet removeCharactersInString:@"!@#$%^&*()-={[]}|;:',<>.?/"];
    [validCharactersSet addCharactersInString:@""];
    
    _rangesOfHotWords = [[NSMutableArray alloc] init];
    
    //    NSLog(@"%lu And Length %lu",(unsigned long)[tmpText rangeOfCharacterFromSet:hotCharactersSet].location,(unsigned long)tmpText.length);
    while ([tmpText rangeOfCharacterFromSet:hotCharactersSet].location < tmpText.length)
    {
        NSRange range = [tmpText rangeOfCharacterFromSet:hotCharactersSet];

        MSGSTTweetHotViewWord hotWord;
        
        switch ([tmpText characterAtIndex:range.location])
        {
            case '@':
                hotWord = MSGSTTweetViewHandle;
                break;
            case '#':
                hotWord = MSGSTTweetViewHashtag;
                break;
            case '*':
                hotWord = MSGSTTweetViewStartag;
                break;
                
            default:
                break;
        }
        
        [tmpText replaceCharactersInRange:range withString:@"%"];
        
        // Determine the length of the hot word
        int length = (int)range.length;
        
        // Register the hot word and its range
        while (range.location + length < tmpText.length) {
            BOOL charIsMember = [validCharactersSet characterIsMember:[tmpText characterAtIndex:range.location + length]];
            
            if (charIsMember)
                length++;
            else
                break;
        }
        
        if (length > 1)
            [_rangesOfHotWords addObject:@{@"hotWord": @(hotWord), @"range": [NSValue valueWithRange:NSMakeRange(range.location, length)]}];
        
        //        NSLog(@"My range %@",NSStringFromRange(NSMakeRange(range.location, length)));
        
        // If the hot character is not preceded by a alphanumeric characater, ie email (sebastien@world.com)
        if (range.location > 0 && [validCharactersSet characterIsMember:[tmpText characterAtIndex:range.location - 1]])
            continue;
    }
    
    [self calculateCompliMintTxtCount];
    NSLog(@"%@",_rangesOfHotWords);
    [self determineLinks];
    
    [self updateText];
}

//-(void)calculateCompliMintTxtCount    // calculate text with tag text
//{
//    int nHotWordLength = 0;
//    NSString *strLength = self.messageTextView.text;
//    strLength = [[strLength stringByRemovingEmoji]stringByReplacingOccurrencesOfString:@" " withString:@""];
//    compliMintTxtCount = strLength.length-nHotWordLength;
//}

-(void)calculateCompliMintTxtCount    // calculate without tag text and emoji
{
    int nHotWordLength = 0;
    NSString *strLength = self.messageTextView.text;
    strLength = [strLength stringByReplacingOccurrencesOfString:@"#" withString:@""];
    strLength = [strLength stringByReplacingOccurrencesOfString:@"*" withString:@""];
    strLength = [strLength stringByReplacingOccurrencesOfString:@"@" withString:@""];
    
    if (_rangesOfHotWords)
    {
        for (NSDictionary *dictionary in _rangesOfHotWords)
        {
            NSRange range = [dictionary[@"range"] rangeValue];
            nHotWordLength += range.length-1;
        }
    }
    
    compliMintTxtCount = strLength.length-nHotWordLength;
}

- (void)determineLinks
{
    NSMutableString *tmpText = [[NSMutableString alloc] initWithString:_cleanText];
    
    [self.urlRegex enumerateMatchesInString:tmpText options:0 range:NSMakeRange(0, tmpText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *protocol     = @"http";
        NSString *link         = [tmpText substringWithRange:result.range];
        NSRange  protocolRange = [link rangeOfString:@":"];
        if (protocolRange.location != NSNotFound) {
            protocol = [link substringToIndex:protocolRange.location];
        }
        
        if ([_validProtocols containsObject:protocol.lowercaseString]) {
            [_rangesOfHotWords addObject:@{ @"hotWord"  : @(MSGSTTweetViewLink),
                                            @"protocol" : protocol,
                                            @"range"    : [NSValue valueWithRange:result.range]
                                            }];
        }
    }];
}

#pragma mark - Printing and calculating text


- (void)updateText {
    [_textStorage beginEditing];
    
    NSAttributedString *attributedString = _cleanAttributedText ?: [[NSMutableAttributedString alloc] initWithString:_cleanText];
    [_textStorage setAttributedString:attributedString];
    [_textStorage setAttributes:_attributesText range:NSMakeRange(0, attributedString.length)];
    
    for (NSDictionary *dictionary in _rangesOfHotWords)  {
        NSRange range = [dictionary[@"range"] rangeValue];
        MSGSTTweetHotViewWord hotWord = (MSGSTTweetHotViewWord)[dictionary[@"hotWord"] intValue];
        [_textStorage setAttributes:[self attributesForHotWord:hotWord] range:range];
    }
    
    [_textStorage endEditing];
}

#pragma mark - Public methods

- (CGSize)suggestedFrameSizeToFitEntireStringConstrainedToWidth:(CGFloat)width {
    if (_cleanText == nil)
        return CGSizeZero;
    
    return [_messageTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

- (CGSize) intrinsicContentSize {
    CGSize size = [self suggestedFrameSizeToFitEntireStringConstrainedToWidth:CGRectGetWidth(self.frame)];
    return CGSizeMake(size.width, size.height + 1);
}

#pragma mark - Private methods

- (NSArray *)hotWordsList {
    return _rangesOfHotWords;
}

#pragma mark - Setters

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self invalidateIntrinsicContentSize];
}

- (void)setText:(NSString *)text {
    //    [super setText:@""];
    _selectableRange = NSMakeRange(NSNotFound, 0);
    
    _cleanText = @"hi @inthe begining";
    //    [self determineHotWords];
    [self invalidateIntrinsicContentSize];
}

- (void)setAttributes:(NSDictionary *)attributes {
    if (!attributes[NSFontAttributeName]) {
        NSMutableDictionary *copy = [attributes mutableCopy];
        copy[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        attributes = [NSDictionary dictionaryWithDictionary:copy];
    }
    
    if (!attributes[NSForegroundColorAttributeName]) {
        NSMutableDictionary *copy = [attributes mutableCopy];
        copy[NSForegroundColorAttributeName] = [UIColor blackColor];
        attributes = [NSDictionary dictionaryWithDictionary:copy];
    }
    
    _attributesText = attributes;
    
    [self determineHotWordsNew];
}

- (void)setAttributes:(NSDictionary *)attributes hotWord:(MSGSTTweetHotViewWord)hotWord {
    if (!attributes[NSFontAttributeName]) {
        NSMutableDictionary *copy = [attributes mutableCopy];
        copy[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        attributes = [NSDictionary dictionaryWithDictionary:copy];
    }
    
    if (!attributes[NSForegroundColorAttributeName])
    {
        NSMutableDictionary *copy = [attributes mutableCopy];
        copy[NSForegroundColorAttributeName] = [UIColor blackColor];
        attributes = [NSDictionary dictionaryWithDictionary:copy];
    }
    
    switch (hotWord)
    {
        case MSGSTTweetViewHandle:
            _attributesHandle = attributes;
            break;
        case MSGSTTweetViewHashtag:
            _attributesHashtag = attributes;
            break;
        case MSGSTTweetViewStartag:
            _attributesStartag = attributes;
            break;
            
        case MSGSTTweetViewLink:
            _attributesLink = attributes;
            break;
            
        default:
            break;
    }
    
    [self determineHotWordsNew];
}

- (void)setLeftToRight:(BOOL)leftToRight {
    _leftToRight = leftToRight;
    
    [self determineHotWordsNew];
}

//- (void)setTextAlignment:(NSTextAlignment)textAlignment {
//    [super setTextAlignment:textAlignment];
//    _textView.textAlignment = textAlignment;
//}

- (void)setDetectionBlock:(void (^)(MSGSTTweetHotViewWord, NSString *, NSString *, NSRange))detectionBlock {
    if (detectionBlock) {
        _detectionBlock = [detectionBlock copy];
        self.userInteractionEnabled = YES;
    } else {
        _detectionBlock = nil;
        self.userInteractionEnabled = NO;
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _cleanAttributedText = [attributedText copy];
    self.text = _cleanAttributedText.string;
}

#pragma mark - Getters

- (NSString *)text {
    return _cleanText;
}

- (NSDictionary *)attributes {
    return _attributesText;
}

- (NSDictionary *)attributesForHotWord:(MSGSTTweetHotViewWord)hotWord {
    switch (hotWord) {
        case MSGSTTweetViewHandle:
            return _attributesHandle;
            
        case MSGSTTweetViewHashtag:
            return _attributesHashtag;
            
        case MSGSTTweetViewStartag:
            return _attributesStartag;
            
        case MSGSTTweetViewLink:
            return _attributesLink;
            
        default:
            break;
    }
    return nil;
}

- (BOOL)isLeftToRight {
    return _leftToRight;
}

#pragma mark - ================ End ===================
- (void)textViewDidBeginEditing:(UITextView*)textView {
    if ([textView.text isEqualToString:self.messagePlaceholder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        [self.placeHolderLabel setHidden:NO];

//        [self.sendButton setEnabled:NO];
    }
    
    CGRect frame = self.frame;
    frame.origin.y = ([self currentScreenSize].height - [self currentKeyboardHeight]) - frame.size.height - _keyboardOffset;
    
    [UIView animateWithDuration:_keyboardAnimationDuration
                          delay:0.0
                        options:(_keyboardAnimationCurve << 16)
                     animations:^{self.frame = frame;}
                     completion:nil];
    
    // TODO: remove deprecated method
    //    if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:)]) {
    //        [self.delegate messageComposerFrameDidChange:frame withAnimationDuration:_keyboardAnimationDuration];
    //    }
    //    if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:andCurve:)]) {
    //        [self.delegate messageComposerFrameDidChange:frame withAnimationDuration:_keyboardAnimationDuration andCurve:_keyboardAnimationCurve];
    //    }
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    if ([textView.text isEqualToString:@""] || [textView.text length] == 0 || [self isStringOnlyWhiteSpace:textView.text])
    {
        textView.text = self.messagePlaceholder;
        textView.textColor = [UIColor lightGrayColor];
        [self.sendButton setEnabled:YES];
        [self.placeHolderLabel setHidden:YES];
    }
    
    CGRect frame = self.frame;
    frame.origin.y = [self currentScreenSize].height - self.frame.size.height - _keyboardOffset;
    
    [UIView animateWithDuration:_keyboardAnimationDuration
                          delay:0.0
                        options:(_keyboardAnimationCurve << 16)
                     animations:^{self.frame = frame;}
                     completion:nil];
    
    // TODO: remove deprecated method
    //    if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:)]) {
    //        [self.delegate messageComposerFrameDidChange:frame withAnimationDuration:_keyboardAnimationDuration];
    //    }
    //    if ([self.delegate respondsToSelector:@selector(messageComposerFrameDidChange:withAnimationDuration:andCurve:)]) {
    //        [self.delegate messageComposerFrameDidChange:frame withAnimationDuration:_keyboardAnimationDuration andCurve:_keyboardAnimationCurve];
    //    }
}


#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification*)notification {
    // Because keyboard animation time and cure vary by iOS version, and we don't want to build the library
    // on top of spammy keyboard notifications we use UIKeyboardWillShowNotification ONLY to dynamically set our
    // animation duration. As a UIKeyboardWillShowNotification is fired BEFORE textViewDidBeginEditing
    // is triggered we can use the following values for all of animations including the first.
    _keyboardAnimationDuration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _keyboardAnimationCurve = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect rect = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect converted = [self convertRect:rect fromView:nil];
    self.keyboardHeight = converted.size.height;
    [self setNeedsLayout];
}


#pragma mark - IBAction
- (IBAction)sendClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(messageComposerSendMessageClickedWithMessage:)]) {
        [self.delegate messageComposerSendMessageClickedWithMessage:self.messageTextView.text];
    }
    
    [self.messageTextView setText:@""];
    // Manually trigger the textViewDidChange method as setting the text when the messageTextView is not first responder the
    // UITextViewTextDidChangeNotification notification does not get fired.
    [self textViewDidChange:self.messageTextView];
}


#pragma mark - Utils
- (void)setMessagePlaceholder:(NSString *)messagePlaceholder {
    _messagePlaceholder = messagePlaceholder;
    [self.messageTextView setText:_messagePlaceholder];
    // Manually trigger the textViewDidChange method as setting the text when the messageTextView is not first responder the
    // UITextViewTextDidChangeNotification notification does not get fired.
    [self textViewDidChange:self.messageTextView];
}
- (void)configureWithAccessory:(UIView *)accessoryView {
    // add the accessory view (camera icons etc) to the left of the message text view and rejig the frames to accomodate.
    self.accessoryViewSubView = accessoryView;
    [self.accessoryViewSubView removeFromSuperview];
    [self.accessoryView addSubview:self.accessoryViewSubView];
    [self setupFrames];
}

- (void)scrollTextViewToBottom {
    // scrollRangeToVisible:NSMakeRange is a pretty buggy function. Manually setting the content offset seems to work better
    CGPoint offset = CGPointMake(0, self.messageTextView.contentSize.height - self.messageTextView.frame.size.height);
    [self.messageTextView setContentOffset:offset animated:NO];
}

- (CGFloat)currentKeyboardHeight {
    if ([self.messageTextView isFirstResponder]) {
        return self.keyboardHeight;
    } else {
        return 0;
    }
}

- (CGFloat)sizeWithText:(NSString*)text {
    CGFloat fixedWidth = self.messageTextView.frame.size.width;
    CGSize newSize = [self.messageTextView sizeThatFits:CGSizeMake(fixedWidth, CGFLOAT_MAX)];
    return MIN(_composerTVMaxHeight, newSize.height);
}

- (void)startEditing {
    if ([self.messageTextView isFirstResponder] == NO)
        [self.messageTextView becomeFirstResponder];
}
- (void)beginTextEditing
{
//    if (self.messageTextView.editable) {
//        return;
//    }
    
    self.messageTextView.editable = YES;
    self.messageTextView.textColor = [UIColor blackColor];
    [self layoutSubviews];

    
    if (!self.isFirstResponder) {
        //[self layoutIfNeeded];
    }
}

- (void)finishEditing {
    if ([self.messageTextView isFirstResponder])
        [self.messageTextView resignFirstResponder];
}

- (BOOL)isStringOnlyWhiteSpace:(NSString*)text {
    if ([self isStringEmpty:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isStringEmpty:(NSString*)inputString {
    //http://stackoverflow.com/a/3675518/740474
    //isEmpty will return true if the string equates to @"" or nil. Has to be static as
    //calling a method on a nil NSString will not execute the method.
    return (inputString == nil)
    || [inputString isKindOfClass:[NSNull class]]
    || ([inputString respondsToSelector:@selector(length)]
        && [(NSData *)inputString length] == 0)
    || ([inputString respondsToSelector:@selector(count)]
        && [(NSArray *)inputString count] == 0);
}


#pragma mark - Screen Size Computation
- (CGSize)currentScreenSize {
    // return the screen size with respect to the orientation
    return [self currentScreenSizeInInterfaceOrientation:[self currentInterfaceOrientation]];
}

- (CGSize)currentScreenSizeInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // http://stackoverflow.com/a/7905540/740474
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    
    // if the orientation at this point is landscape but it hasn't fully rotated yet use landscape size instead.
    // handling differs between iOS 7 && 8 so need to check if size is properly configured or not. On
    // iOS 7 height will still be greater than width in landscape without this call but on iOS 8
    // it won't
    if (UIInterfaceOrientationIsLandscape(orientation) && size.height > size.width) {
        size = CGSizeMake(size.height, size.width);
    }
    
    id nav = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navc = (UINavigationController *) nav;
        if (!navc.navigationBarHidden) {
            size.height -= navc.navigationBar.frame.size.height;
        }
        if (navc.navigationBar.barPosition == UIBarPositionTopAttached) {
            size.height -= application.statusBarFrame.size.height;
        }
    }
    
    return size;
}

- (UIInterfaceOrientation)currentInterfaceOrientation {
    // Returns the orientation of the Interface NOT the Device. The two do not happen in exact unison so
    // this point is important.
    return [UIApplication sharedApplication].statusBarOrientation;
}



@end
