//
//  UserSetViewController.m
//  MYWowGoing
//
//  Created by mac on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserSetViewController.h"
 
#import "LoginViewController.h"
//#import "SinaWeibo.h"

//#define kWBSDKDemoAppKey  @"1923335646"
//#define kWBSDKDemoAppSecret @"bc6fe7a933e008c199f444b44f71a9e1"


@class RegisterView;

@interface UserSetViewController ()

@end

@implementation UserSetViewController
@synthesize userLoginInfo;
@synthesize cancelLoginButton;
@synthesize weiBoInfo;
//@synthesize weiBoEngine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
//    [engine setRootViewController:self];
//    [engine setDelegate:self];
//    [engine setRedirectURI:@"http://"];
//    [engine setIsUserExclusive:NO];
//    self.weiBoEngine = engine;
//    [engine release];
    
    if ([Util isLogin] == YES) {
        userLoginInfo.text = [NSString stringWithFormat:@"%@ 已经登录",[Util getLoginName]];
        [cancelLoginButton setHidden:NO];
    }
    else
    {
        [cancelLoginButton setHidden:YES];
    }
    
//    weiBoInfo.text = [NSString stringWithFormat:@"绑定微薄"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f 
                                             target:self 
                                           selector:@selector(updatePosition) 
                                           userInfo:nil 
                                            repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma - mark updata 
-(void)updatePosition
{
    if ([Util isLogin] == YES) {
        [cancelLoginButton setHidden:NO];
        userLoginInfo.text = [NSString stringWithFormat:@"%@ 已经登录",[Util getLoginName]];
    
    }else{
        userLoginInfo.text = @"您还没有登录,点击此处登录";
        [cancelLoginButton setHidden:YES];
    }
    
//    if ([Util getBingWeibo] == 0) {
//        weiBoInfo.text = @"您还没有绑定微薄,点击绑定";
//    }
//    else if ([Util getBingWeibo] == 1) {
//        weiBoInfo.text = @"您已经绑定新浪微薄,点击取消绑定";
//    }
//    else if ([Util getBingWeibo] == 2) {
//        weiBoInfo.text = @"您已经绑定腾讯微薄,点击取消绑定";
//    }

}

#pragma - mark button event

-(IBAction)userLogin:(id)sender
{

    if ([Util isLogin] == YES) {
        userLoginInfo.text = [NSString stringWithFormat:@"%@已经登录",[Util getLoginName]];
    }
    else
    {
        loginAlert = [[UIAlertView alloc]initWithTitle:@"登录" 
                                  message:@""
                                 delegate:self 
                        cancelButtonTitle:@"取消" 
                        otherButtonTitles:@"使用现有账户",@"注册新账户", nil];
        [loginAlert show];
    }

}
-(IBAction)cancelLogin:(id)sender
{

    logOutAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                    message:@"你确定要注销吗?" 
                                                   delegate:self 
                                          cancelButtonTitle:@"取消" 
                                          otherButtonTitles:@"确定", nil];
    [logOutAlert show];

}

//-(IBAction)bingWeibo:(id)sender
//{
//    
//    switch ([Util getBingWeibo]) {
//        case 0://绑定微薄
//        {
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"绑定微薄" 
//                                                               delegate:self 
//                                                      cancelButtonTitle:@"取消" 
//                                                 destructiveButtonTitle:@"新浪微薄" 
//                                                      otherButtonTitles:@"腾讯微薄", nil];
//            [sheet showInView:self.view];
//        }
//            break;
//        case 1://取消新浪绑定
//        {
//            cancelSinaWeibo=[[UIAlertView alloc]initWithTitle:@"警告" 
//                                                            message:@"你确定要注销新浪微薄吗?" 
//                                                           delegate:self 
//                                                  cancelButtonTitle:@"取消" 
//                                                  otherButtonTitles:@"确定", nil];
//            [cancelSinaWeibo show];
//        }
//            break;
//        case 2://取消腾讯绑定
//        {
//            cancelTengXunWeibo=[[UIAlertView alloc]initWithTitle:@"警告" 
//                                                      message:@"你确定要注销腾讯微薄吗?" 
//                                                     delegate:self 
//                                            cancelButtonTitle:@"取消" 
//                                            otherButtonTitles:@"确定", nil];
//            [cancelTengXunWeibo show];
//        }
//            break;
//        default:
//            break;
//    }
//    
//
//
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    NSLog(@"button index %d ",buttonIndex);
//    
//    switch (buttonIndex) {
//        case 0: //新浪微薄
//        {
//            [[SinaWeibo shareSinaWeibo] setWeiboRootController:self];
//            [[[SinaWeibo shareSinaWeibo] weiBoEngine] logIn];
//        }
//            break;
//        case 1://腾讯微薄
//        {
//            
//        }
//            break;
//        case 2://取消
//        {
//        
//        }
//            break;
//        default:
//            break;
//    }
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
//    if ([alertView isEqual:loginAlert]) {
//        
//        if (buttonIndex == 1) {
//            LoginViewController *loginView = [[[LoginViewController alloc] init] autorelease];
//            [self presentModalViewController:loginView animated:YES];
//        }
//        else if(buttonIndex == 2)
//        {
//            RegisterView *registerView = [[[RegisterView alloc] init] autorelease];
//            [self presentModalViewController:registerView animated:YES];
//        }
//        
//    }else if([alertView isEqual:logOutAlert]){
//        if (buttonIndex == 1) {
//            userLoginInfo.text = @"您还没有登陆,点击此处登陆";
//            [cancelLoginButton setHidden:YES];
//            [Util cancelLogin];
//        }
//    }
    
    //weibo
    
//    if ([alertView isEqual:cancelSinaWeibo]) {
//        if (buttonIndex==1) {
//            //退出新浪微薄
//            [[[SinaWeibo shareSinaWeibo] weiBoEngine] logOut];
//            [Util setBingWeibo:0];
//        }
//    }
//    else if ([alertView isEqual:cancelTengXunWeibo]) {
//        if (buttonIndex == 1) {
//            //退出腾讯微薄
//            
//            
//        }
//    }
}
@end
