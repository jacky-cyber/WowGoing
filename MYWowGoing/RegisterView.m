//
//  RegisterView.m
//  MYWowGoing
//
//  Created by duyingfeng on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterView.h"
 
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

#import "SBJSON.h"
 
#import "ProductDetailViewController_Detail2.h"
#import "LoginViewController.h"
#import "Toast+UIView.h"
#import "LoginBS.h"
#import <ShareSDK/ShareSDK.h>
@implementation RegisterView
@synthesize delegate;
@synthesize userEmail,password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
		[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
		UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		self.navigationItem.leftBarButtonItem = litem;
		[backBtn release];
		[litem release];
        
        UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
        titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
        [self.view addSubview:titbackImageview];
        [titbackImageview release];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        [self.navigationItem setTitle:@"注册"];
    }
    return self;
}
- (void)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    userEmail.delegate = self;
    username.delegate = self;
    password.delegate = self;
    confromPassword.delegate = self;
   
}

- (void)viewDidUnload
{
    [self setShowPassword:nil];
    [super viewDidUnload];

}

-(IBAction)closeDone:(id)sender
{
    UITextField *textField = (UITextField*)sender;
    
    [textField resignFirstResponder];
    
}

- (IBAction)showPassword:(id)sender {
    if (_showPassword.selected) {
        _showPassword.selected = NO;
        self.password.secureTextEntry = YES;
    } else {
        _showPassword.selected = YES;
        self.password.secureTextEntry = NO;
    }
    
    [self.password resignFirstResponder];
}

- (IBAction)sinaRegisterAction:(id)sender {
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        [self.view makeToast:@"已经授权"];
        return;
    }
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:self authManagerViewDelegate:nil];
    
    id<ISSSinaWeiboApp> sinaapp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
    [sinaapp setSsoEnabled:NO];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
        if (result)
        {
            if (userInfo.uid == nil || userInfo.nickname == nil) {
                [self.view makeToast:@"登录失败"];
                return;
            }
            [self loginSina:userInfo.uid username:userInfo.nickname];
            [Util setLogin:userInfo.nickname password:userInfo.uid];
            [Util setLoginOk];
        }else {
            [self.view makeToast:@"登录失败"];
        }
        
    }];
}


//  完成授权后发送一条微博
- (void) viewOnWillDismiss:(UIViewController *)viewController shareType:(ShareType)shareType{
    
    BOOL  isAuthorized =  [ShareSDK hasAuthorizedWithType:shareType];
    
    if (isAuthorized) {
        
        NSString *shareString = [NSString stringWithFormat:@"我正在使用“购引”手机APP，足不出户逛遍本地商场，还有专享超低折扣，专柜取货确保正品，每天还有一款超低价秒杀商品等你抢购！你也快来体验吧~购引最新版APP下载地址iPhone版：https://itunes.apple.com/cn/app/wowgoing-gou-yin/id608833789?mt=8，Android版：http://www.wowgoing.com/WowGoing.apk，还有购引网页版 http://www.wowgoing.com"];
        
        UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
        NSURL *imageUrl = [NSURL URLWithString:@"http://www.wowgoing.com/upload/share.jpg"];
        [imageView setImageWithURL:imageUrl];
        
        id<ISSContent>publishContent=[ShareSDK content:shareString
                                        defaultContent:shareString
                                                 image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl] fileName:nil mimeType:nil]
                                                 title:@"购引"
                                                   url:nil
                                           description:nil
                                             mediaType:SSPublishContentMediaTypeNews];
        
        
        //需要定制分享视图的显示属性，使用以下接口
        
        id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleFullScreenPopup  viewDelegate:nil authManagerViewDelegate:nil];
        
        [ShareSDK shareContent:publishContent type:shareType    authOptions:authOptions statusBarTips:YES result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess)
            {
                NSLog(@"发送成功");
            }
            else
            {
                NSLog(@"发送失败");
            }
            
        }];
        
    }
    
}

- (IBAction)qqRegisterAction:(id)sender {
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeTencentWeibo]) {
        [self.view makeToast:@"已经授权"];
        return;
    }
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:self authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:ShareTypeTencentWeibo authOptions:authOptions result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSDictionary *userInfoDic = userInfo.sourceData;
            NSString *openid = [userInfoDic objectForKey:@"openid"];
            if (openid == nil || userInfo.nickname == nil)
            {
                [self.view makeToast:@"登录失败"];
                return;
            }
            [self loginSina:openid username:userInfo.nickname];
            [Util setLogin:userInfo.nickname password:userInfo.uid];
            [Util setLoginOk];
        }else {
            [self.view makeToast:@"授权失败，请重新授权"];
        }
    }];
}

- (IBAction)textEditChange:(id)sender {
    if ([self.password.text length] < 5) {
        NSString *text = self.password.text;
        self.password.text = [text substringToIndex:5];
        NSLog(@"必须大于5");
    }
}


- (void)loginSina:(NSString *)uid username:(NSString *)nickname {
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:@"" forKey:@"loginId"];
    [common setValue:@"" forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:uid forKey:@"password"];
    [jsonreq setValue:nickname forKey:@"loginname"];
    [jsonreq setValue:nickname forKey:@"email"];
    [jsonreq setValue:[Util getDeviceToken] forKey:@"deviceNum"];
    [jsonreq setValue:[Util getCityName] forKey:@"city"];
    [jsonreq setValue:@"2" forKey:@"mobileType"];
    
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

    NSString *urlString = [NSString stringWithFormat:@"%@/account/register",SEVERURL];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
   
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
        [self.view makeToast:@"注册失败"];
        return;
    }
    else
    {
        [Util setLogin:userEmail.text password:password.text];
        [self loginSinaQQ:nickname password:uid];
    }
    
}

- (void)loginSinaQQ:(NSString *)userName password:(NSString *)uid {
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:userName forKey:@"loginId"];
    [common setValue:uid forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getCityName] forKey:@"city"];
    [jsonreq setValue:@"" forKey:@"province"];
    [jsonreq setValue:@"2" forKey:@"mobileType"];
    
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

    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,ACCOUNT_LOGIN];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDidFinishSelector:@selector(loginSucess:)];
    [requestForm setDidFailSelector:@selector(loginFail:)];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}
- (void)loginFail:(ASIHTTPRequest *)request
{
    [self.view makeToast:@"登录失败"];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
}
- (void)loginSucess:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        dic= [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        NSString *jsonString = [request responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus==401 ) {
        [self.view makeToast:@"网络错误！请重试"];
        return;
    }
    
    if (responseStatus!=200 ) {
        [self.view makeToast:@"登录失败"];
        return;
    }
    else
    {
        if ([[dic objectForKey:@"customerID"] intValue] != 0) {
            
            [Single shareSingle].isResf = YES;
            
            if (![userEmail.text isEqual:@""] && ![password.text isEqual:@""] && ![Util isLogin]) {
                [Util setLogin:userEmail.text password:password.text];
                [Util setLoginOk];
            }
            
            [Util setCustomerID:(NSString*)[dic objectForKey:@"customerID"]];
            [Util setLoginOk];
            
            [self.view makeToast:@"注册成功,已经登录"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WowCreads" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }else
        {
            [self.view makeToast:@"登录失败"];
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - button event


-(BOOL)isValidEmailAddress:(NSString *)email 
{
	
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:email];
	
}

- (BOOL)isAvailableEmail:(NSString*)emailString {
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:emailString] ;
}
#pragma mark ---------- 注册
-(IBAction)registerOk:(id)sender
{
    if ([self.userEmail.text isEqualToString:@""]) {
        [self.view makeToast:@"邮箱不能为空"];
        return;
    }

    if (![self isValidEmailAddress:userEmail.text]) {
        [self.view makeToast:@"邮箱不能为空"];
        return;
    }
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:@"" forKey:@"loginId"];
    [common setValue:@"" forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:password.text forKey:@"password"];
    [jsonreq setValue:userEmail.text forKey:@"loginname"];
    [jsonreq setValue:userEmail.text forKey:@"email"];
    [jsonreq setValue:[Util getDeviceToken] forKey:@"deviceNum"];
    [jsonreq setValue:[Util getCityName] forKey:@"city"];
    [jsonreq setValue:@"2" forKey:@"mobileType"];
    [jsonreq setValue:@"2" forKey:@"gender"];
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/account/register",SEVERURL];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDidFailSelector:@selector(requestFailed:)];
    [requestForm setDidFinishSelector:@selector(registerFinish:)];
    [requestForm startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

#pragma mark ---------- 注册成功
- (void)registerFinish:(ASIFormDataRequest *)requestForm {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
    
    //判断邮箱，是否被注册 true 注册
    NSString  *emailString = [dic objectForKey:@"isExistEmail"];
    //当前用户登录名已存在
    NSString  *loginNameString = [dic objectForKey:@"isLoginnameExist"];
    if ([emailString isEqualToString:@"true"] || [loginNameString isEqualToString:@"true"]) {
//        [self showToastMessageAtCenter:@"用户名或邮箱已存在"];
        [self.view makeToast:@"用户名或邮箱已存在"];
        return;
    }
    
    if (responseStatus!=200) {
//        [self showToastMessageAtCenter:@"注册失败"];
        [self.view makeToast:@"注册失败"];
        return;
    }
    else
    {
        [Util setLogin:userEmail.text password:password.text];
        NSString *costomerId = [dic objectForKey:@"customerid"];
        [Util setCustomerID:costomerId];
        [self loginRequest];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.view makeToast:@"注册失败"];
}

-(void)loginRequest{
    LoginBS *bs = [[[LoginBS alloc] init]autorelease];
    bs.userName = self.userEmail.text;
    bs.password = self.password.text;
    bs.delegate  = self;
    bs.onSuccessSeletor = @selector(loginSucess:);
    bs.onFaultSeletor = @selector(loginFail:);
    [bs asyncExecute];
}

#pragma mark - HUD delegate
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [HUD removeFromSuperview];
    [HUD release];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [ProductDetailViewController_Detail2 setPushState:1];
}

- (void)dealloc {
    
    [_showPassword release];
    [super dealloc];
}
@end
