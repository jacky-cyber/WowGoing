//
//  AppDelegate.m
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
 
#import "CoordinateReverseGeocoder.h"
#import "ProductViewController.h"
#import "Reachability.h"
#import <ShareSDK/ShareSDK.h>
#import "FnalStatementVC.h"
#import "CartViewController.h"
#import "WXApi.h"
#import "CustomAlertView.h"
#import "Single.h"
#import "ExitBS.h"
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import <sys/utsname.h>
#import "MobClick.h"
#import "Single.h"
#import "AdvertisingVC.h"
#import "UMFeedbackViewController.h"
//@interface AppDelegate()
//-(void)parseURL:(NSURL *)url application:(UIApplication *)application;
//@end


@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBar;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)umengTrack {
//    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行 
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
       //  友盟的方法本身是异步执行，所以不需要再异步调用
    NSLog(@"当前app版本：%@",APP_VERSION);
    [self umengTrack];
    [WXApi registerApp:@"wx3d4f6fc7da88940a"];
//    [QQApi registerPluginWithId:@"QQC2956C2E"];
    [ShareSDK registerApp:@"4ce8c7640b"];
    
    [ShareSDK connectWeChatWithAppId:@"wx3d4f6fc7da88940a" wechatCls:[WXApi class]];
    
    [ShareSDK connectSinaWeiboWithAppKey:@"1923335646" appSecret:@"e341f178b4d867598465d7774d9bc4b5" redirectUri:@"http://www.bshare.cn"];//添加新浪微博应用
    
    [ShareSDK connectTencentWeiboWithAppKey:@"801173916" appSecret:@"0f2eb888d75cfb5c1aa80ff9884ae85b" redirectUri:@"http://127.0.0.1/success.html" wbApiCls:[WBApi class]];//添加腾讯微博应用
   

    //获取uuid
    [Util setDefauts];
    //根据版本不同加载不同的api

    //用户反馈
    [UMFeedback setLogEnabled:YES];
    [UMFeedback checkWithAppkey:UMENG_APPKEY];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(umCheck:) name:UMFBCheckFinishedNotification object:nil];
    
//    [NSThread sleepForTimeInterval:1];

    /** 注册推送通知功能, */
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];

    
   // 极光推送 相关
    [APService registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    [APService setupWithOption:launchOptions];
    

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:[storyboard instantiateInitialViewController]] autorelease];
    nav.navigationBarHidden = YES;

    [self.window setRootViewController:nav];
    
    

//    self.window.rootViewController = [[[LaunchImageTransition alloc] initWithViewController:nav animation:UIModalTransitionStyleCrossDissolve] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        NSLog(@"查看feedback");
//        [self.viewController webFeedback:nil];
//    } else {
//        
//    }
//}


- (void)umCheck:(NSNotification *)notification {
    UIAlertView *alertView;
    if (notification.userInfo) {
        NSArray *newReplies = [notification.userInfo objectForKey:@"newReplies"];
        NSLog(@"newReplies = %@", newReplies);
        NSString *title = [NSString stringWithFormat:@"有%d条意见回复", [newReplies count]];
        NSMutableString *content = [NSMutableString string];
        for (NSUInteger i = 0; i < [newReplies count]; i++) {
            NSString *dateTime = [[newReplies objectAtIndex:i] objectForKey:@"datetime"];
            NSString *_content = [[newReplies objectAtIndex:i] objectForKey:@"content"];
            [content appendString:[NSString stringWithFormat:@"%d .......%@.......\r\n", i + 1, dateTime]];
            [content appendString:_content];
            [content appendString:@"\r\n\r\n"];
        }
        
        alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        alertView.tag = 9924100;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            ((UILabel *) [[alertView subviews] objectAtIndex:1]).textAlignment = NSTextAlignmentLeft;
        }
        [alertView show];
        
    } else {
//        alertView = [[UIAlertView alloc] initWithTitle:@"没有新回复" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    }
    
}

#pragma mark - 实现远程推送需要实现的监听接口
/** 接收从苹果服务器返回的唯一的设备token，该token需要发送回推送服务器*/
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // 极光推送
    [APService registerDeviceToken:deviceToken];
    
    NSString *deviceTokenLocal = [[deviceToken description]
								  stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<> "]];
	deviceTokenLocal = [deviceTokenLocal stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"apns -> 生成的devToken:%@", deviceTokenLocal);
    [Util saveDeviceToken:deviceTokenLocal];
    
    
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:@"123@abc.com" forKey:@"loginId"];
    [common setValue:@"111111" forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:deviceTokenLocal forKey:@"deviceNum"];
    
    NSString *sbreq=nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {//IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
        NSError *error=nil;
        NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }else{
        SBJsonWriter *sbJsonWriter=[SBJsonWriter alloc];
        sbreq = [sbJsonWriter stringWithObject:jsonreq];
        [sbJsonWriter release];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL, PUSH_SERVER];
    NSLog(@"向服务器发送的apns的参数%@\n%@",urlString, sbreq);

     ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(cartAcceptRefundFinish:)];
    [requestForm setDidFailSelector:@selector(cartAcceptRefundFail:)];
    
}

- (void)cartAcceptRefundFinish:(ASIFormDataRequest*)request {
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return;
        }
        if (error) {
        return;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    NSLog(@"apns -> 设备标识已发送到服务器");
    NSLog(@"返回的apns--->%@",dic);
}

- (void)cartAcceptRefundFail:(ASIFormDataRequest*)request {
    NSLog(@"apns -> 设备标识发送失败");
}

//程序处于启动状态，或者在后台运行时，会接收到推送消息，解析处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    //把icon上的标记数字设置为0,
    application.applicationIconBadgeNumber = 0;
    
    // 极光推送
    [APService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    ExitBS *exitBS=[[[ExitBS alloc]init] autorelease];//用户点击HOME键推出时向服务器发送请求
    exitBS.delegate=self;
    [exitBS asyncExecute];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
    
}

//程序运行后走这里，点击app图标走这里
- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [CoordinateReverseGeocoder getCurrentCity];
    NSLog(@"applicationDidBecomeActive");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addAdViewLoading" object:nil];
//    [[AdvertisingVC sharedManager]  addAdViewLoading];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [[ProductViewController shareProduct] loadGPSData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadgps" object:nil];
}
//然后,在处理请求 URL 的委托方法中加入 ShareSDK 的处理方法,如下:
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//   return [ShareSDK handleOpenURL:url wxDelegate:self];
//}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     [self parseURL:url application:application];
     [ShareSDK handleOpenURL:url wxDelegate:self];    
    return  YES;
}


#pragma mark
#pragma mark  更新列表订单状态
-(void)updateAllList:(NSString*)payState :(NSString*)isSuccess{
    
    FnalStatementVC *counaVC=[FnalStatementVC shareFnalStatementController];

    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviveId"];
    [jsonreq setValue:counaVC.orderIdString forKey:@"orderId"];
    [jsonreq setValue:payState forKey:@"payType"];
    [jsonreq setValue:isSuccess forKey:@"isSuccess"];
    
     NSString *sbreq=nil;
     NSError *error=nil;
     NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
     NSString *urlString = [NSString stringWithFormat:@"%@/cart/updateOrderList",SEVERURL];
    
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
}

#pragma mark
#pragma mark
- (void)requestFinished:(ASIHTTPRequest *)request{//订单状态更新完毕后 执行的代理方法
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return;
        }
        if (error) {
        return;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    if (dic == NULL) {
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {
        return;
    }
    
    FnalStatementVC *counaVC=[FnalStatementVC shareFnalStatementController];
    if ([counaVC _isCartList]) { //购物车列表购买
        [Util saveCartListCount:[NSString stringWithFormat:@"%d",[[Util takeCartListCount] intValue]-counaVC.productsArray.count]];
        [counaVC set_isCartList:NO];
        
    }else{
        
        if ([counaVC _shouYe]) { //首页 立即购买
            [counaVC.navigationController popViewControllerAnimated:NO];
            [counaVC set_shouYe:NO];
            return;
        }else{
            [counaVC.navigationController popViewControllerAnimated:NO];
        }
    }
}

//支付宝 安全支付 客户端  回调方法  包含支付结果
- (void)parseURL:(NSURL *)url application:(UIApplication *)application{
    
    AlixPay *alixpay = [AlixPay shared];
    AlixPayResult *result = [alixpay handleOpenURL:url];
    if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
            
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
                
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"支付成功"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                alertView.tag=11986;
				[alertView show];
				[alertView release];
                
			}//验签错误
			else {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"签名错误"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                alertView.tag=11987;
				[alertView show];
				[alertView release];
			}
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else  if(6001 == result.statusCode) {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                message:@"用户中途取消"
                delegate:self
                cancelButtonTitle:@"确定"
                otherButtonTitles:nil];
            alertView.tag=11988;
			[alertView show];
			[alertView release];
		}else{
        
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                message:result.statusMessage
                delegate:self
                cancelButtonTitle:@"确定"
                otherButtonTitles:nil];
            alertView.tag=11989;
			[alertView show];
			[alertView release];
        }
	}
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
//    navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    navigationController.navigationBar.translucent = NO;
    [self presentModalViewController:feedbackViewController animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    FnalStatementVC *counterVC=[FnalStatementVC shareFnalStatementController];
    if (alertView.tag==11986){
        
        NSString *blance=[NSString stringWithFormat:@"-%.2f",[counterVC.balanceString  floatValue]];
    
        if (counterVC.productsArray.count>0) {   // 支付宝支付成功

         [self updateWowgoingAmount:[blance floatValue]];  //使用wowgoing账户支付
            return;
        }

        [self updateWowgoingAmount:[blance floatValue]];

    }else if (alertView.tag==11987 ){  //支付宝支付失败
       
             [self updateAllList:@"1" :@"0"];
             
    }else if(alertView.tag==11988){  //用户中途取消
       
            [self updateAllList:@"1" :@"0"];
    }
}

#pragma mark
#pragma mark  更新wowgoing账户
-(void)updateWowgoingAmount:(float)price{ //更新wowgoing账户余额
    
    FnalStatementVC *fnalVC=[FnalStatementVC shareFnalStatementController];
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerId"];
    [jsonreq setValue:fnalVC.orderIdString forKey:@"orderId"];
   
    NSString *sbreq=nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {//IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
        NSError *error=nil;
        NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }else{
        SBJsonWriter *sbJsonWriter=[SBJsonWriter alloc];
        sbreq = [sbJsonWriter stringWithObject:jsonreq];
        [sbJsonWriter release];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_UPDATE_ORDER];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(updateWowgoingAmountFinished:)];
    [requestForm setDidFailSelector:@selector(updateWowgoingAmountFailed:)];
    [requestForm startAsynchronous];
}

- (void)updateWowgoingAmountFinished:(ASIHTTPRequest *)request
{//更新wowgoing账户后回调的方法
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return;
        }
        if (error) {
        return;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        return;
    }
    if (dic == NULL  ) {
        
        return;
    }
    
    FnalStatementVC *counaVC = [FnalStatementVC shareFnalStatementController];
    if ([counaVC _isCartList]) { //购物车列表购买
        [Util saveCartListCount:[NSString stringWithFormat:@"%d",[[Util takeCartListCount] intValue]-counaVC.productsArray.count]];
        [counaVC.navigationController popViewControllerAnimated:NO];
        [counaVC set_isCartList:NO];
        
    }else{
        
        if ([counaVC _shouYe]) { //首页 立即购买
            [counaVC.navigationController popViewControllerAnimated:NO];
            [counaVC set_shouYe:NO];
        }else{
        
            [counaVC.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)updateWowgoingAmountFailed:(ASIHTTPRequest *)request
{//更新wowgoing账户失败
    FnalStatementVC *counterVC=[FnalStatementVC shareFnalStatementController];
    [self updateWowgoingAmount:[counterVC.balanceString intValue]];
  
}

@end
