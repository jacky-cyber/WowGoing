//
//  DetailCouponViewController.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-24.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "UIImageView+ForScrollView.h"
@class MyCouponViewController;

@interface DetailCouponViewController : BaseController
//价格
@property (strong, nonatomic) NSString *priceCoupon;
//优惠码
@property (strong, nonatomic) NSString *couponCord;
//使用时期
@property (strong, nonatomic) NSString *dateString;
//使用城市
@property (strong, nonatomic) NSString *cityStr;
//优惠劵连接
@property (strong, nonatomic) NSString *couponShareLink;
@property (assign) int *couponNum;
//使用日期
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
//优惠码
@property (retain, nonatomic) IBOutlet UILabel *couponLabel;
//使用城市
@property (retain, nonatomic) IBOutlet UILabel *cityLab;
//使用说明
@property (retain, nonatomic) IBOutlet UITextView *userShopTV;
//使用店铺
@property (retain, nonatomic) IBOutlet UILabel *userShopLab;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

//限时使用店铺
@property (retain, nonatomic) IBOutlet UILabel *shopStrLabel;

@property (retain, nonatomic) IBOutlet UILabel *priceLael;
@property (strong, nonatomic) NSString *shopNameString;
@property (retain, nonatomic) IBOutlet UILabel *explantionLabelString;
@property (retain, nonatomic) IBOutlet UITextView *explanationTextVIEW;
@property (strong, nonatomic) MyCouponViewController *myCouponView;
@property (retain, nonatomic) IBOutlet UILabel *expLabel;
- (IBAction)shareAction:(id)sender;

@end
