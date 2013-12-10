//
//  UserSetViewController.h
//  MYWowGoing
//
//  Created by mac on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
//#import "WBEngine.h"





@interface UserSetViewController : UIViewController<UIActionSheetDelegate>
{
//    WBEngine *weiBoEngine;
    
    UIAlertView  *loginAlert;
    UIAlertView  *logOutAlert;
    
    NSTimer *timer;

//    UIAlertView *cancelSinaWeibo;
//    UIAlertView *cancelTengXunWeibo;
}

@property (nonatomic ,retain) IBOutlet UILabel *userLoginInfo;

@property (nonatomic ,retain) IBOutlet UILabel *weiBoInfo;

@property (nonatomic ,retain) IBOutlet UIButton *cancelLoginButton;

//@property (nonatomic, retain) WBEngine *weiBoEngine;

-(IBAction)userLogin:(id)sender;
-(IBAction)cancelLogin:(id)sender;

@end
