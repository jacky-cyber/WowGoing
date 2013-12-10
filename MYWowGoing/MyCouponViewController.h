//
//  MyCouponViewController.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-19.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "BaseController.h"
@class DetailCouponViewController;

@interface MyCouponViewController : BaseController  <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

@property (retain, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (retain, nonatomic) EGORefreshTableFooterView *refreshFooterView;
@property (retain, nonatomic) IBOutlet UITableView *couponTableView;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewStatus;
@property (strong, nonatomic) DetailCouponViewController *detailCouponView;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (assign) int nowPageNum;
@property (assign) BOOL reloading;
- (IBAction)currentCouponAction:(id)sender;
- (IBAction)hsitoryCouponAction:(id)sender;

@end
