    //
//  BaseController.m
//  HuaShang
//
//  Created by Alur on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#define kDuration 0.5   // 动画持续时间(秒)
#define USER_NAME @"USER_NAME"
#define PASS_WORD @"PASS_WORD"
#define IS_SAVE @"ISSAVE" //判断是否自动登陆的状态
@interface BaseController ()

@property (nonatomic, assign) id messageBoxDelegate;
@property (nonatomic, assign) SEL onMiddleAction;
@property (nonatomic, assign) SEL onLeftAction;
@property (nonatomic, assign) SEL onRightAction;
@property (retain, nonatomic) UIView *coverView;
@property (retain, nonatomic) UIView *viewMessBox;
@property (retain, nonatomic) iToast *toast;
@property (retain, nonatomic) NSMutableArray *bsArray;

@end

@implementation BaseController
#pragma mark - HUD delegate
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    [hud release];
    //加载View消失后的操作
    //    theTabelView.frame=CGRectMake(10, 60, 300, [dataSource count]*CellHeight);
    //    theScrollView.contentSize=CGSizeMake(320, 60+[dataSource count]*CellHeight+20);
    //
    //    [theTabelView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        self.bsArray = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [_viewMessBox release];
    [_coverView release];
    [_loadingView release];
    [_toast release];
    [_bsArray release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _actionLocker = FALSE;
}

- (void)showLPV
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.backgroundColor = [UIColor blackColor];
//	hud.dimBackground = YES;
	hud.labelText = @"";
}

- (void)showLPVC
{
	MBProgressHUD *hud = [MBProgressHUD showCancelHUDAddedTo:self.navigationController.view delegate:self animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"";
}

- (void)hideLPV
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)showLoadingView
{
    [self performSelectorOnMainThread:@selector(showLPV) withObject:nil waitUntilDone:YES];
}

- (void)showLoadingViewWithCancelButton
{
    [self performSelectorOnMainThread:@selector(showLPVC) withObject:nil waitUntilDone:YES];
}

- (void)hideLoadingView
{
    [self performSelectorOnMainThread:@selector(hideLPV) withObject:nil waitUntilDone:YES];
}

// 顶部显示加载中view
-(void)showTipMessage:(NSString*)text
{
    if(!_loadingView)
    {
        self.loadingView = [[[UIView alloc] init] autorelease];
        _loadingView.backgroundColor = [UIColor blackColor];
        _loadingView.alpha = 0.7;
        _loadingView.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
        _loadingView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        activity.tag = 101;
        label.tag    = 102;
        
        if(self.view.frame.size.height < 500) // IPhone
        {
            CGFloat w = self.view.frame.size.width;
            _loadingView.frame = CGRectMake(0, 0, w, 20);
            activity.frame = CGRectMake((w - 220) / 2 + 10, 0, 20, 20);
            label.frame = CGRectMake((w - 220) / 2 + 20, 0, 200, 20);
        }
        else if(self.view.frame.size.height  >= 500) // IPad
        {
            CGFloat w = self.view.frame.size.width;
            _loadingView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            //UIDeviceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
            activity.frame = CGRectMake((w - 160) /  2, 0, 30, 30);
            label.frame = CGRectMake((w - 240) /  2 + 40, 0, 200, 30);
        }
        
        activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:15];
        [activity startAnimating];
        [label setText:text];
        
        [_loadingView addSubview:label];
        [_loadingView addSubview:activity];
        [label release];
        [activity release];
        
        [self.view addSubview:_loadingView];
        [self.view bringSubviewToFront:_loadingView];
    }
    
    self.loadingView.hidden = FALSE;
    [self.view bringSubviewToFront:_loadingView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if(_loadingView)
    {
        UIDeviceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
        if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
        {
            //翻转为竖屏时
            UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[self.loadingView  viewWithTag:101];
            UILabel *label     = (UILabel*)[self.loadingView viewWithTag:102];
            activity.frame = CGRectMake(270, 0, 30, 30);
            label.frame = CGRectMake(320, 0, 200, 30);
        }
        else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
        {
            //翻转为横屏时
            UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[self.loadingView  viewWithTag:101];
            UILabel *label     = (UILabel*)[self.loadingView viewWithTag:102];
            activity.frame = CGRectMake(420, 0, 30, 30);
            label.frame = CGRectMake(450, 0, 200, 30);
        }
    }
}

// 隐藏顶部显示的加载中view
- (void)hideTipMessage
{
    if(_loadingView)
    {
        self.loadingView.hidden = TRUE;
    }
}


// 弹出模态警告框. 标题为sTitle, 内容为sContent, buttonList为按钮列表.
- (void) showAlertWithTitle:(NSString *)sTitle andMessage:(NSString *)sContent andButtonList:(NSArray *)buttonList
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:sTitle message:sContent delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    if (buttonList!=nil) 
    {
        for (int i = 0; i < buttonList.count; ++i)
        {
            [alertView addButtonWithTitle:[buttonList objectAtIndex:i]];
        } 
    }
    [alertView show];
    [alertView release];
}

// 虚方法. 当按钮按下时执行此方法, 根据按钮ID判断按键.
- (void) onAlertButtonClick:(int)nButtonIndex
{
    // 请子类继承重写
}

// Toast方式显示提示消息sMsg, nTime后消失.
- (void)showToastMessage:(NSString *)sMsg
{
    if(_toast)
    {
        [_toast hideToast:nil];
        [_toast release];
        _toast = nil;
    }
    
    self.toast = [iToast makeToast:sMsg];
    [_toast setToastPosition:kToastPositionBottom];
    [_toast setToastDuration:kToastDurationNormal];
    [_toast show];
}

- (void)showToastMessageAtCenter:(NSString *)sMsg;
{
    if(_toast)
    {
        [_toast hideToast:nil];
        [_toast release];
        _toast = nil;
    }

    self.toast = [iToast makeToast:sMsg];
    [_toast setToastPosition:kToastPositionCenter];
    [_toast setToastDuration:kToastDurationNormal];
    [_toast show];
}

- (void)showToastMessageAtCenter:(NSString*)sMsg inView:(UIView*)view
{
    if(_toast)
    {
        [_toast hideToast:nil];
        [_toast release];
        _toast = nil;
    }

    self.toast = [iToast makeToast:sMsg];
    [_toast setToastPosition:kToastPositionCenter];
    [_toast setToastDuration:kToastDurationNormal];
    [_toast showInView:view];
}

- (void)showToastMessageBottomAtPoint:(NSString*)sMsg withPoint:(CGPoint)point
{
    if(_toast)
    {
        [_toast hideToast:nil];
        [_toast release];
        _toast = nil;
    }

    self.toast = [iToast makeToast:sMsg];
    [_toast setToastPosition:kToastPositionBottom];
    [_toast setToastDuration:kToastDurationNormal];
    [_toast showatPoint:point];
}

// 显示提示框，默认有图片(1)  提示内容 按钮看参数 默认为0
// 参数1 ：提示内容
// 参数2：图片类型    0 表示叉号 1表示对号
// 参数3：是否有按钮 0 表示没有 1表示有1个 2表示有2个
-(void)showMessageBox:(NSString*)mess  picFlag:(NSInteger)p  btnFlag:(NSInteger)b  btnTitle:(NSArray*)a   withTarget:(id)delegate  andSel_M:(SEL)onMAction  andSel_L:(SEL)onLAction  andSel_R:(SEL)onRAction
{
    self.onMiddleAction = onMAction;
    self.onLeftAction = onLAction;
    self.onRightAction = onRAction;
    self.messageBoxDelegate = delegate;
    
    if(self.coverView)
    {
        [_coverView removeFromSuperview];
        [_coverView release];
        _coverView = nil;
    }
    // 锁屏
    self.coverView = [[[UIView alloc] init] autorelease];
    _coverView.backgroundColor = [UIColor clearColor];
    
    // 屏幕宽高
    CGFloat w = self.view.frame.size.width;
    CGFloat h  =  self.view.frame.size.height;
    
    _coverView.frame = CGRectMake(0, 0, w, h);
    
    // box宽高
    CGFloat iw = w * 0.8;
    CGFloat ih = h * 0.26;
    
    // 根据设计图计算出 间隔 图片 label btn 的宽高
    CGFloat space = 0.06 * ih;         // 间隔
    CGFloat pic_w_h = 0.30 * ih; // 图片 宽高 相同
    CGFloat label_w = iw;               // label 宽
    CGFloat label_h = 0.12 * ih;    // label 高
    CGFloat btn_w = 0.3 * iw;     // 按钮宽 0.27
    CGFloat btn_h = 0.27 * ih;        // 按钮高
    
    // box透明
    self.viewMessBox = [[[UIView alloc] init] autorelease];
    self.viewMessBox.backgroundColor = [UIColor blackColor];
    self.viewMessBox.alpha = 0.85;
    self.viewMessBox.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.viewMessBox.layer.borderWidth = 3.0;
    self.viewMessBox.layer.cornerRadius = 6.0;
    
    _viewMessBox.frame = CGRectMake( (w - iw ) / 2, (h - h * 0.4 ) / 2, iw, ih);  // 左右居中 Y轴靠上 
    _viewMessBox.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    
    // 图片 pic
    UIImageView *pic = [[UIImageView alloc] init]; // 最后rel
     pic.frame = CGRectMake((iw - pic_w_h ) / 2, space + 5, pic_w_h, pic_w_h);
    if(0 == p)
        [pic setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dialog_error_notice_icon" ofType:@"png"]]]; // 叉号
    else
        [pic setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dialog_pass_notice_icon" ofType:@"png"]]]; // 对号
    
    // 提示信息 位置根据有无按钮在变化  之间的间隔为5
    UILabel *label = [[UILabel alloc] init]; // 最后rel
    CGFloat iy = (ih - pic_w_h - label_h) / 2; // 无按钮时label的Y值
    if(b > 0) // 有按钮
        label.frame =  CGRectMake(0, space + pic_w_h + space + 5, label_w, label_h);
    else       // 无按钮
        label.frame = CGRectMake(0,  pic_w_h + space + iy, label_w, label_h + 10); // .?
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label setTextColor:[UIColor whiteColor]];
    [label setNumberOfLines:0];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    label.text = mess;
    
    // 假设现在最多只能放下2个btn  label与btn之间没有留间隔5
    //  单个按钮时宽度 高度 随view大小变化
    // 计算按钮的Y值
    CGFloat  btn_y = space + pic_w_h+ space + label_h + space + 5;
    
    if(1 ==b)
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dialog_button_bg" ofType:@"png"]] forState: UIControlStateNormal];
        btn.frame = CGRectMake( (iw - btn_w) / 2,  btn_y, btn_w, btn_h);
        if([a objectAtIndex:0] != nil)
            [btn setTitle:[a objectAtIndex:0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onMiddleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_viewMessBox addSubview:btn];
        [btn release]; // rel
    }
    else if(2 == b )
    {
        UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_left setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dialog_button_bg" ofType:@"png"]] forState: UIControlStateNormal];
        btn_left.frame = CGRectMake( (iw/2 - btn_w) / 2, btn_y, btn_w, btn_h);
        [btn_left.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        btn_left.layer.borderColor = [[UIColor whiteColor] CGColor];
        if([a objectAtIndex:0] != nil)
            [btn_left setTitle:[a objectAtIndex:0] forState:UIControlStateNormal];
        [btn_left addTarget:self action:@selector(onLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_right setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dialog_button_bg" ofType:@"png"]] forState: UIControlStateNormal];
        btn_right.frame = CGRectMake( (iw/2 - btn_w) / 2 + iw / 2, btn_y, btn_w, btn_h);
        [btn_right.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [btn_right setTitleColor:[UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal]; // 蓝色 RGB 80 187 239
        if([a objectAtIndex:1] != nil)
            [btn_right setTitle:[a objectAtIndex:1] forState:UIControlStateNormal];
        [btn_right addTarget:self action:@selector(onRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewMessBox addSubview:btn_left];
        [_viewMessBox addSubview:btn_right];
    }
    
    [_viewMessBox addSubview:label];
    [_viewMessBox addSubview: pic];
    [_coverView addSubview: _viewMessBox];
    [self.view addSubview: _coverView];
    [self.view bringSubviewToFront:_coverView];
    
    [label release];
    [pic release];
    
    if(0 == b) // 没有按钮时 自动1秒后移除
    {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                             target:self selector:@selector(onRemoveMessgeBox)
                                           userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)onRemoveMessgeBox
{
    if(_coverView)
    {
        [_coverView removeFromSuperview];
        [_coverView release];
        _coverView = nil;
    }
}

// 按钮事件 1个按钮
-(void)onMiddleBtnAction
{
    if (_messageBoxDelegate && _onMiddleAction && [_messageBoxDelegate respondsToSelector:_onMiddleAction])
    {
        [_messageBoxDelegate performSelector:_onMiddleAction withObject:nil];
    }
    if (_coverView)
    {
        [_coverView removeFromSuperview];
        [_coverView release];
        _coverView = nil;
    }
}

// 2个按钮 左
-(void)onLeftBtnAction
{
    if (_messageBoxDelegate && _onLeftAction && [_messageBoxDelegate respondsToSelector:_onLeftAction])
    {
        [_messageBoxDelegate performSelector:_onLeftAction withObject:nil];
    }
    if (_coverView)
    {
        [_coverView removeFromSuperview];
        [_coverView release];
        _coverView = nil;
    }
}

// 右
-(void)onRightBtnAction
{
    if (_messageBoxDelegate && _onRightAction && [_messageBoxDelegate respondsToSelector:_onRightAction])
    {
        [_messageBoxDelegate performSelector:_onRightAction withObject:nil];
    }
    if (_coverView)
    {
        [_coverView removeFromSuperview];
        [_coverView release];
        _coverView = nil;
    }
}

#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self onAlertButtonClick:buttonIndex];
}
- (void)onLoadingCancelAction
{
    [self.bsArray removeAllObjects];
}


//移动
- (CATransition *)moveAnim:(int)tag typeid: (int)typeID  view:(UIView *)currentView
{
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.duration = 1.5f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.fillMode = kCAFillModeForwards;
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromRight;
//    return animation;
    
    // 使用Core Animation创建动画
    
    // 创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    animation.delegate = self;
    // 设定动画时间
    animation.duration = kDuration;
    // 设定动画快慢(开始与结束时较慢)
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    int tag = 102;
    // 12种类型
    switch (tag) {
        case 101:
            // 设定动画类型
            // kCATransitionFade 淡化
            // kCATransitionPush 推挤
            // kCATransitionReveal 揭开
            // kCATransitionMoveIn 覆盖
            // @"cube" 立方体
            // @"suckEffect" 吸收
            // @"oglFlip" 翻转
            // @"rippleEffect" 波纹
            // @"pageCurl" 翻页
            // @"pageUnCurl" 反翻页
            // @"cameraIrisHollowOpen" 镜头开
            // @"cameraIrisHollowClose" 镜头关
            animation.type = kCATransitionFade;
            break;
        case 102:
            animation.type = kCATransitionPush;
            break;
        case 103:
            animation.type = kCATransitionReveal;
            break;
        case 104:
            animation.type = kCATransitionMoveIn;
            break;
        case 201:
            animation.type = @"cube";
            break;
        case 202:
            animation.type = @"suckEffect";
            break;
        case 203:
            animation.type = @"oglFlip";
            break;
        case 204:
            animation.type = @"rippleEffect";
            break;
        case 205:
            animation.type = @"pageCurl";
            break;
        case 206:
            animation.type = @"pageUnCurl";
            break;
        case 207:
            animation.type = @"cameraIrisHollowOpen";
            break;
        case 208:
            animation.type = @"cameraIrisHollowClose";
            break;
        default:
            break;
    }
    // 四个方向
//    int typeID = 3;
    switch (typeID) {
        case 0:
            // 设定动画方向
            animation.subtype = kCATransitionFromLeft;
            break;
        case 1:
            animation.subtype = kCATransitionFromBottom;
            break;
        case 2:
            animation.subtype = kCATransitionFromRight;
            break;
        case 3:
            animation.subtype = kCATransitionFromTop;
            break;
        default:
            break;
    }
    
    // 动画开始
    [[currentView layer] addAnimation:animation forKey:@"animation"];
    return animation;

}

-(int)takeTimeDifference:(NSString *)takeTime currentTime:(NSString *)todayTime{
    
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[[NSDateComponents alloc] init] autorelease];//初始化目标时间
    NSArray *array=[takeTime componentsSeparatedByString:@" "];
    NSArray *arrayNYR=[[array objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *arrayHMS=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
    [endTime setYear:[[arrayNYR objectAtIndex:0] intValue]];
    [endTime setMonth:[[arrayNYR objectAtIndex:1] intValue]];
    [endTime setDay:[[arrayNYR objectAtIndex:2] intValue]];
    
    [endTime setHour:[[arrayHMS objectAtIndex:0] intValue]];
    [endTime setMinute:[[arrayHMS objectAtIndex:1] intValue]];
    [endTime setSecond:[[arrayHMS objectAtIndex:2] intValue]];
    
    NSDate *endDate=[cal dateFromComponents:endTime];
    NSDate *today=[NSDate date];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *differcnce=[cal components:unitFlags fromDate:today toDate:endDate options:0];
    
    int totle=[differcnce day]*3600*24+[differcnce hour]*3600+[differcnce minute]*60+[differcnce second];
    
    return totle;
    
}


#pragma mark
#pragma mark  获取订单失效时间与当前时间的时间差
-(NSString *)takeTimeDifference:(NSString *)time{
    
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[[NSDateComponents alloc] init] autorelease];//初始化目标时间
    
    NSArray *array=[time componentsSeparatedByString:@" "];
    NSArray *arrayNYR=[[array objectAtIndex:0] componentsSeparatedByString:@"-"];
//    NSArray *arrayHMS=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
    [endTime setYear:[[arrayNYR objectAtIndex:0] intValue]];
    [endTime setMonth:[[arrayNYR objectAtIndex:1] intValue]];
    [endTime setDay:[[arrayNYR objectAtIndex:2] intValue]];
    
//    [endTime setHour:[[arrayHMS objectAtIndex:0] intValue]];
//    [endTime setMinute:[[arrayHMS objectAtIndex:1] intValue]];
//    [endTime setSecond:[[arrayHMS objectAtIndex:2] intValue]];
    
    NSDate *endDate=[cal dateFromComponents:endTime];
    NSDate *today=[NSDate date];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *differcnce=[cal components:unitFlags fromDate:today toDate:endDate options:0];
    
    return [NSString stringWithFormat:@"%d天%d时%d分", [differcnce day], [differcnce hour], [differcnce minute]];
    
    //    int totle=[differcnce day]*3600*24+[differcnce hour]*3600+[differcnce minute]*60+[differcnce second];
}

-(BOOL)isSaveUserPass
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_SAVE] == YES) {
        return YES;
    }
    else{
        return NO;
    }
}

//下次自动登陆
- (void)saveUserNameOrPassword:(NSString *)username password:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:PASS_WORD];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_SAVE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//取消密码和用户名保存
- (void)cancelUserName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASS_WORD];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_SAVE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)getUserName
{
    NSString *stringUserName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    return stringUserName;
}
- (NSString *)getPassword
{
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:PASS_WORD];
    return password;
}


- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

//保存服务器返回的城市
- (void)saveBrowerCity:(NSString *)cityName {
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"serverCityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获得城市
- (NSString *)getBrowerCity {
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverCityName"];
    if (cityName == nil) {
        return @"当前位置";
    }
    return cityName;
}
//#pragma mark ---------- //返回的数据解析
//- (NSMutableDictionary *)requestData:(ASIFormDataRequest *)request {
//    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
//    NSMutableDictionary *dic=nil;
//    NSError *error=nil;
//    if (requestForm.responseData.length>0) {
//        
//        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
//    }else{
//        return nil;
//    }
//    if (error) {
//        return nil;
//    }
//    return dic;
//}

@end
