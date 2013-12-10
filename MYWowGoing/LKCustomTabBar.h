//
//  Ivan_UITabBar.h
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LKCustomTabBar : UITabBarController {
	NSMutableArray *buttons;
	int currentSelectedIndex;
	UIImageView *slideBg;
	UIView *cusTomTabBarView;
	UIImageView *backGroundImageView;
   
    UIAlertView *loginAlert;
}

@property (nonatomic ,readonly) UIView *cusTomTabBarView;

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;

@property(nonatomic,retain) UIImageView *slideBg;//购物车中显示商品数量
@property(nonatomic,retain) UIImageView  *slideQH;//专柜取货中显示商品数量

@property(nonatomic,retain)UIButton *btn;
@property (nonatomic,retain) UIButton *btn1;
@property(nonatomic,retain)UIButton *btn2;
//wkf：
@property(nonatomic,retain)UIButton *btn3;
@property(nonatomic,retain)UIButton *btn4;
@property (assign) BOOL tabBarBool;
- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void)selectedTab2:(UIButton *)button;

- (void)hideCustomTabBar;
+(LKCustomTabBar*)shareTabBar;


@end
