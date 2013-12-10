//
//  MyWowViewController.h
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@class MyCouponViewController;
@interface MyWowViewController : BaseController
{
   UIAlertView     *loginAlert;
   
}
@property (retain, nonatomic) IBOutlet UILabel *loginLabel;
@property (retain, nonatomic) IBOutlet UILabel *jifenLabel;
@property (retain, nonatomic) IBOutlet UILabel *yuLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *logoBtn;

@property (retain, nonatomic) IBOutlet UIButton *ZXBtn;
@property (retain, nonatomic) IBOutlet UIButton *ZCBtn;
@property (retain, nonatomic) IBOutlet UIImageView *priceImageView;
@property (strong, nonatomic) MyCouponViewController *myCouponViewController;

//我的会员卡
- (IBAction)myMembershipAction:(id)sender;

//注销
- (IBAction)ZXAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)myOrderAction:(id)sender;
//浏览记录
- (IBAction)myBrowseRecoredsAction:(id)sender;
- (IBAction)mySetingAction:(id)sender;
- (IBAction)rulesAction:(id)sender;
- (IBAction)wentiAction:(id)sender;
- (IBAction)aboutAction:(id)sender;
//我的优惠劵
- (IBAction)myCouponAction:(id)sender;
@end
