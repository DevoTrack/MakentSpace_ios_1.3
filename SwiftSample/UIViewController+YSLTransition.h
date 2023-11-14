/**
 * UIViewController+YSLTransition.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <UIKit/UIKit.h>
#import "YSLTransitionAnimator.h"

@interface UIViewController (YSLTransition) <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSNumber *toViewControllerImagePointY;
@property (nonatomic, strong) NSNumber *cancelAnimationPointY;
@property (nonatomic, strong) NSNumber *animationDuration;


- (void)ysl_pushTransitionAnimationWithToViewControllerImagePointY:(CGFloat)toViewControllerImagePointY
                                                 animationDuration:(CGFloat)animationDuration;

- (void)ysl_popTransitionAnimationWithCurrentScrollView:(UIScrollView*)scrollView
                                  cancelAnimationPointY:(CGFloat)cancelAnimationPointY
                                      animationDuration:(CGFloat)animationDuration
                                isInteractiveTransition:(BOOL)isInteractiveTransition;


- (void)ysl_addTransitionDelegate:(UIViewController*)viewController;
- (void)ysl_removeTransitionDelegate;

- (void)ysl_setUpReturnBtnWithColor:(UIColor *)color callBackHandler:(void (^)())callBackHandler;
- (void)ysl_setupReturnBtnWithImage:(UIImage *)image color:(UIColor *)color callBackHandler:(void (^)())callBackHandler;

@end
