/**
 * YSLTransitionAnimator.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YSLTransitionAnimatorDataSource <NSObject>

- (UIImageView *)pushTransitionImageView;
- (UIImageView *)popTransitionImageView;

@end

@interface YSLTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isForward;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) CGFloat toViewControllerImagePointY;

@end
