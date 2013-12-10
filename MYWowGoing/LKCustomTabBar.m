//
//  Ivan_UITabBar.m
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKCustomTabBar.h"
//#import "UIBadgeView.h"
//#import "LKCameraViewController.h"
 
#import "LoginViewController.h"
#import "RegisterView.h"
#import "ProductViewController.h"
#import "CartViewController.h"
static LKCustomTabBar *shareTabBar;

@implementation LKCustomTabBar
@synthesize currentSelectedIndex;
@synthesize buttons,btn,btn1,btn2,btn3,btn4;
@synthesize cusTomTabBarView;
@synthesize slideBg;
@synthesize slideQH;
static BOOL FIRSTTIME =YES;


+(LKCustomTabBar*)shareTabBar
{
    return shareTabBar;
}

- (void)viewDidAppear:(BOOL)animated{
    
	if (FIRSTTIME) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideCustomTabBar" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(hideCustomTabBar)
													 name: @"hideCustomTabBar"
												   object: nil];
				
        slideBg=[[ UIImageView alloc]initWithFrame:CGRectMake(171, 1, 21, 22)] ;
		slideBg.image = [UIImage imageNamed:@"购物车数量红圈.png"];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,-2,21,22)];
        label.font=[UIFont systemFontOfSize:11.0f];
        label.tag=1986;
        label.textAlignment=UITextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor];
        [slideBg addSubview:label];
        [label release];
        [slideBg setHidden:YES];
        
        
        slideQH=[[ UIImageView alloc]initWithFrame:CGRectMake(235, 1, 21, 22)];
		slideQH.image = [UIImage imageNamed:@"购物车数量红圈.png"];
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,-2,21,22)];
        label1.font=[UIFont systemFontOfSize:11.0f];
        label1.tag=1988;
        label1.textAlignment=UITextAlignmentCenter;
        label1.backgroundColor=[UIColor clearColor];
        label1.textColor=[UIColor whiteColor];
        [self.slideQH addSubview:label1];
        [label1 release];
        [self.slideQH setHidden:YES];
        
		[self hideRealTabBar];
		[self customTabBar];
	}
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
//			view.hidden = YES;
            [view removeFromSuperview];
			break;
		}
	}
}


//自定义tabbar
- (void)customTabBar{
	//获取tabbar的frame
	CGRect tabBarFrame = self.tabBar.frame;
	backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
	cusTomTabBarView = [[UIView alloc] initWithFrame:tabBarFrame];
    
	//设置tabbar背景
	backGroundImageView.image = [UIImage imageNamed:@"tab_bardingse.png"];
	[cusTomTabBarView addSubview:backGroundImageView];
	cusTomTabBarView.backgroundColor = [UIColor clearColor];
	
	
	//创建按钮
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
	double _width = 320 / viewCount;
	for (int i = 0; i < viewCount; i++) {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
        if (i==0) {
            //首页
            self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn.frame = CGRectMake(i*_width+5, 5, 53, 41);
            
            [self.btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
            self.btn.tag = i;
        }if(i==1) {
            //浏览
            self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn1.frame = CGRectMake(i*_width+5, 5, 53, 41);
            
            [self.btn1 addTarget:self action:@selector(selectedTab1:) forControlEvents:UIControlEventTouchDown];
            self.btn1.tag = i;
            
        } if (i==2) {
            //购物车
            self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn2.frame = CGRectMake(i*_width+5, 5, 53, 41);
            [self.btn2 addTarget:self action:@selector(selectedTab2:) forControlEvents:UIControlEventTouchDown];
            self.btn2.tag = i;
            
        }if (i==3) {
            //取货
            self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn3.frame = CGRectMake(i*_width+5, 5, 53, 41);
            
            [self.btn3 addTarget:self action:@selector(selectedTab3:) forControlEvents:UIControlEventTouchDown];
            self.btn3.tag = i;
            
        }if (i==4) {
            //我的Wow
            self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn4.frame = CGRectMake(i*_width+5, 5, 53, 41);
            
            [self.btn4 addTarget:self action:@selector(selectedTab4:) forControlEvents:UIControlEventTouchDown];
            self.btn4.tag = i;
            
        }
        
        switch (i) {
                
            case 0:
                if (self.currentSelectedIndex==0) {
                   [self.btn setBackgroundImage:[UIImage imageNamed:@"逛商场-白.png"] forState:UIControlStateNormal];
                }else{
                   [self.btn setBackgroundImage:[UIImage imageNamed:@"逛商场.png"] forState:UIControlStateNormal];
                }
                [self.btn setImage:v.tabBarItem.image forState:UIControlStateNormal];
                
                break;
                
            case 1:
                if (self.currentSelectedIndex==1) {
                    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"搜索-白.png"] forState:UIControlStateNormal];
                }else{
                    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"搜索-黑.png"] forState:UIControlStateNormal];
                }
                [self.btn1 setImage:v.tabBarItem.image forState:UIControlStateNormal];
                
                break;
   
            case 2:
                [self.btn2 setImage:v.tabBarItem.image forState:UIControlStateNormal];
                if (self.currentSelectedIndex== 2) {
                    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"购物车_选中.png"] forState:UIControlStateNormal];
                }else{
                   [self.btn2 setBackgroundImage:[UIImage imageNamed:@"购物车_未选.png"] forState:UIControlStateNormal];
                }
            
                break;
                
            case 3:
                [self.btn3 setImage:v.tabBarItem.image forState:UIControlStateNormal];
                if (self.currentSelectedIndex== 3) {
                    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"专柜取货_选中.png"] forState:UIControlStateNormal];
                }else{
                   [self.btn3 setBackgroundImage:[UIImage imageNamed:@"专柜取货_未选.png"] forState:UIControlStateNormal];
                }
                
                break;
                
            case 4:
                [self.btn4 setImage:v.tabBarItem.image forState:UIControlStateNormal];
                if (self.currentSelectedIndex== 4) {
                    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"我的wow_选中.png"] forState:UIControlStateNormal];
                }else{
                    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"我的wow_未选.png"] forState:UIControlStateNormal];
                }
                
                break;
                
            default:
                break;
        }
        
	}
    [self.buttons addObject:self.btn];
    [self.buttons addObject:self.btn1];
    [self.buttons addObject:self.btn2];
    [self.buttons addObject:self.btn3];
    [self.buttons addObject:self.btn4];
    [cusTomTabBarView addSubview:self.btn];
    [cusTomTabBarView addSubview:self.btn1];
    [cusTomTabBarView addSubview:self.btn2];
    [cusTomTabBarView addSubview:self.btn3];
    [cusTomTabBarView addSubview:self.btn4];
	[self.view addSubview:cusTomTabBarView];
	[cusTomTabBarView addSubview:slideBg];
    [cusTomTabBarView addSubview:slideQH];
    shareTabBar = self;
}


//切换tabbar
- (void)selectedTab:(UIButton *)button{
    [self.btn setBackgroundImage:[UIImage imageNamed:@"逛商场-白.png"] forState:UIControlStateNormal];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"搜索-黑.png"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"购物车_未选.png"] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"专柜取货_未选.png"] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"我的wow_未选.png"] forState:UIControlStateNormal];
    self.currentSelectedIndex = button.tag;
    self.selectedIndex = self.currentSelectedIndex;
}


#pragma mark
#pragma mark  购物车
- (void)selectedTab2:(UIButton *)button{
    
    [self.btn setBackgroundImage:[UIImage imageNamed:@"逛商场.png"] forState:UIControlStateNormal];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"搜索-黑.png"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"购物车_选中.png"] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"专柜取货_未选.png"] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"我的wow_未选.png"] forState:UIControlStateNormal];
    
    self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;

}


//浏览
- (void)selectedTab1:(UIButton *)button{
    [self.btn setBackgroundImage:[UIImage imageNamed:@"逛商场.png"] forState:UIControlStateNormal];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"搜索-白.png"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"购物车_未选.png"] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"专柜取货_未选.png"] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"我的wow_未选.png"] forState:UIControlStateNormal];
    self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
    
}

- (void)selectedTab3:(UIButton *)button{
    
    [self.btn setBackgroundImage:[UIImage imageNamed:@"逛商场.png"] forState:UIControlStateNormal];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"搜索-黑.png"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"购物车_未选.png"] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"专柜取货_选中.png"] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"我的wow_未选.png"] forState:UIControlStateNormal];
    self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;

}

- (void)selectedTab4:(UIButton *)button{
    
    [self.btn setBackgroundImage:[UIImage imageNamed:@"逛商场.png"] forState:UIControlStateNormal];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"搜索-黑.png"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"购物车_未选.png"] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"专柜取货_未选.png"] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"我的wow_选中.png"] forState:UIControlStateNormal];
    self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
}


//隐藏自定义tabbar
- (void)hideCustomTabBar{
	[self performSelector:@selector(hideRealTabBar)];
    
    UIViewController *controller = [self.viewControllers objectAtIndex:0];
    controller.view.frame = CGRectMake(0, 0, 320, 480);
}


- (void) dealloc{
	[backGroundImageView release];
    [cusTomTabBarView release];
    [self.buttons release];
    [slideBg release];
    [slideQH release];
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:loginAlert]) {
        
        if (buttonIndex == 1) {
            
            LoginViewController *loginView = [[[LoginViewController alloc] init] autorelease];
            loginView.delegate = self;
            [self presentModalViewController:loginView animated:YES];
        }
        else if(buttonIndex == 2)
        {
            RegisterView *registerView = [[[RegisterView alloc] init] autorelease];
            registerView.delegate = self;
            [self presentModalViewController:registerView animated:YES];
        }
        
    }
}


@end
