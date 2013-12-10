//
//  AppDelegate.h
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomTabBar.h"
#import "WXApi.h"   // 微信
#import "WBApi.h"   
#import "UMFeedback.h"   // 友盟统计
#import "AboutVC.h"

#import "APService.h"  //  极光推送

//514296b456240b14c0001536 //测试id
//50d181945270157c65000023 //正是id

#define UMENG_APPKEY @"50d181945270157c65000023"
@class ViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate>
{
    LKCustomTabBar  *tabBar;

}
@property(strong, nonatomic) AboutVC *viewController;
@property (nonatomic ,retain) IBOutlet LKCustomTabBar  *tabBar;
@property (strong, nonatomic) UIWindow *window;

@end
