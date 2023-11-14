/**
 * SBMSingletonClass.h
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

@interface SBMSingletonClass : NSObject
{
    //declare instance variable
}

@property(nonatomic,assign)     BOOL           isFacebookSelected,isTwitterSelected;
@property(nonatomic,strong)     UIImage        *selectedPostMintImage;
@property(nonatomic,assign)     BOOL           isProfileScreenSelected,isAnyuserMuted;

@property(nonatomic,strong)     UIImage        *selectedImage;
@property(nonatomic,strong)     NSString       *descriptionText;
@property(nonatomic,strong)     NSString       *categoryname;
@property(nonatomic,strong)     NSString       *categoryIds;
@property(nonatomic,strong)     NSString       *selectedVideoThumb;
@property(nonatomic,strong)     UIImage        *selectedVideoThumbImage;
@property(nonatomic,strong)     NSString       *fromFacebook;

@property(nonatomic,strong)     NSString       *remoteVideoURLString,*mintdetail_url;
@property(nonatomic,assign)     BOOL           isCameraSelectedForUserProfile;

@property(nonatomic,strong)     NSURL          *localVideopath;
@property(nonatomic,strong)     NSData         *selectVideoData;
@property(nonatomic,assign)     NSInteger       login_user_streak;
@property(nonatomic,assign)     BOOL           isUser_mint_streak;


@property(nonatomic,assign)     NSInteger      counterText,glblactivitySelectedSegmentIndex;
@property(nonatomic,strong)     NSMutableArray *selectedSpecialFetaures;
@property(nonatomic,strong)     NSMutableArray *showroomData;
@property(nonatomic,strong)     NSMutableArray *arrayMyShowMintData;
@property(nonatomic,strong)     NSURL          *mintDetailImgURL;

@property(nonatomic,strong)     NSString       *glblActivityTotal_count;
@property(nonatomic,strong)     NSString       *glblActivityYou_count;
@property(nonatomic,strong)     NSString       *glblActivityRequest_count;

@property(nonatomic,strong)     NSDictionary   *addMintInfo;

@property(nonatomic,strong)     NSMutableArray *arrGlobalRoomList;
@property(nonatomic,strong)     NSMutableArray *arrGlobalWishListRoom;

@property(nonatomic,strong)     NSString       *filterCategoryName;
@property(nonatomic,assign)     int       filterShowroomCount;


+ (id)sharedSingletonClass;
+ (void)resetSharedInstance;
@end
