//
//  BaseController.h
//  HuaShang
//
//  Created by Alur on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iToast.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
@interface BaseController : UIViewController
    <UIAlertViewDelegate, MBProgressHUDDelegate>

#pragma mark - property
@property (retain, nonatomic) UIView *loadingView;
@property (assign, nonatomic) BOOL actionLocker;

#pragma mark - toast view
// Toast方式显示提示消息sMsg, nTime后消失.
// 提示位置： 1.正下方 2.正中间 3.指定的view正中间 4.指定点的位置 
- (void)showToastMessage:(NSString *)sMsg;
- (void)showToastMessageAtCenter:(NSString *)sMsg;
- (void)showToastMessageAtCenter:(NSString*)sMsg inView:(UIView*)view;
- (void)showToastMessageBottomAtPoint:(NSString*)sMsg withPoint:(CGPoint)point;

#pragma mark - loading view at top
// 提示 顶部
-(void)showTipMessage:(NSString*)text;
-(void)hideTipMessage;

#pragma mark - loading view at center
// 加载提示全锁屏 中间
- (void)showLoadingView;
#pragma mark - loading view at center with cancel button
// 加载提示全锁屏 中间 带取消按钮
- (void)showLoadingViewWithCancelButton;
- (void)hideLoadingView;
// 如果要响应加载的取消按钮, 请重写onCancelAction方法, 并调用[super onCancelAction];
- (void)onLoadingCancelAction;

#pragma mark - choose view
// 提示框  带图片 可以添加0-2个按钮
// 只有一个按钮时 middle 两个时为left right
// 不用的btn赋值为nil即可
- (void)showMessageBox:(NSString*)mess  picFlag:(NSInteger)p  btnFlag:(NSInteger)b  btnTitle:(NSArray*)a   withTarget:(id)messageBoxDelegate  andSel_M:(SEL)onMAction  andSel_L:(SEL)onLAction  andSel_R:(SEL)onRAction;

#pragma mark - alert
// 弹出模态警告框. 标题为sTitle, 内容为sContent, buttonList为按钮列表(NSString对象).
- (void)showAlertWithTitle:(NSString *)sTitle andMessage:(NSString *)sContent andButtonList:(NSArray *)buttonList;
// 虚方法.当按钮按下时执行此方法, 根据按钮ID判断按键.
- (void) onAlertButtonClick:(int)nButtonIndex;
- (CATransition *)moveAnim:(int)tag typeid: (int)typeID  view:(UIView *)currentView;
//时间格式化天时分秒
-(int)takeTimeDifference:(NSString *)takeTime currentTime:(NSString *)todayTime;

-(NSString *)takeTimeDifference:(NSString *)time;
- (void)saveUserNameOrPassword:(NSString *)username password:(NSString *)password;
- (NSString *)getUserName;
- (NSString *)getPassword;
- (void)cancelUserName;
-(BOOL)isSaveUserPass;
//判断是否为整形
- (BOOL)isPureInt:(NSString *)string;

//保存从服务器返回的城市
- (void)saveBrowerCity:(NSString *)cityName;
- (NSString *)getBrowerCity;
//返回的数据解析
//- (NSMutableDictionary *)requestData:(ASIFormDataRequest *)request;

@end