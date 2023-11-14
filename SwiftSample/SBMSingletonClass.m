/**
 * SBMSingletonClass.m
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import "SBMSingletonClass.h"
static SBMSingletonClass *sharedClass = nil;

@implementation SBMSingletonClass
@synthesize arrGlobalRoomList;
@synthesize arrGlobalWishListRoom;

+ (id)sharedSingletonClass
{
    static dispatch_once_t onceToken;//The way we ensure that it’s only created once is by using the dispatch_once method from Grand Central Dispatch (GCD).
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    return sharedClass;
}
+ (void)resetSharedInstance {
    sharedClass = nil;
}
- (id)init
{
    if (self = [super init])
    {
        self.counterText=0;
        self.glblActivityRequest_count=@"0";
        self.glblActivityTotal_count=@"0";
        self.glblActivityYou_count=@"0";
        arrGlobalRoomList = [[NSMutableArray alloc] init];

        //init instance variable
    }
    return self;
}
@end

