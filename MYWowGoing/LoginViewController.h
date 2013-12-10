//
//  LoginViewController.h
//  MYWowGoing
//
//  Created by duyingfeng on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BaseController.h"
#import <ShareSDK/ShareSDK.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
@interface LoginViewController : BaseController<UITextFieldDelegate,ISSViewDelegate>
{

    id delegate;
    
    MBProgressHUD   *HUD;
}
@property (nonatomic ,assign) id delegate;

@property (nonatomic ,retain) IBOutlet UITextField *userEmail;
@property (nonatomic ,retain) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UIButton *selectAutoLogoBtn;


-(IBAction)login:(id)sender;//登陆
- (IBAction)sinaLogin:(id)sender;//新浪微博登陆
- (IBAction)qqLogin:(id)sender;//QQ登陆
- (IBAction)selectAutoLogoin:(id)sender;//记住密码设置

+ (LoginViewController *)sharedInstance;

@end
