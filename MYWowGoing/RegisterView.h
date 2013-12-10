//
//  RegisterView.h
//  MYWowGoing
//
//  Created by duyingfeng on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "DCRoundSwitch.h"
#import "BaseController.h"
#import <ShareSDK/ShareSDK.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
@class LoginViewController;

@interface RegisterView : BaseController<MBProgressHUDDelegate,UITextFieldDelegate,ISSViewDelegate>
{
    LoginViewController *delegate;

    UITextField  *userEmail;
    UITextField  *username;
    UITextField  *password;
    UITextField  *confromPassword;
    MBProgressHUD   *HUD;
    
}
@property (nonatomic ,retain) IBOutlet UITextField  *userEmail;

@property (nonatomic ,retain) IBOutlet UITextField  *password;

@property (retain, nonatomic) IBOutlet UIButton *showPassword;

@property (nonatomic ,assign) id delegate;

-(IBAction)registerOk:(id)sender;//注册
-(IBAction)closeDone:(id)sender;
- (IBAction)showPassword:(id)sender;//显示密码
- (IBAction)sinaRegisterAction:(id)sender;//新浪微博注册
- (IBAction)qqRegisterAction:(id)sender;//腾讯微博注册


@end


