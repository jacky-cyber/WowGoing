//
//  LoginViewController.m
//  MYWowGoing
//
//  Created by duyingfeng on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterView.h"
#import "SBJSON.h"
#import "ProductDetailViewController_Detail2.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
 
#import "LKCustomTabBar.h"
#import "CoordinateReverseGeocoder.h"
#import "LoginViewController.h"
#import "CartViewController.h"

#import "Single.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginBS.h"
#import "Request.h"

#import "Toast+UIView.h"

@implementation LoginViewController
@synthesize delegate;
@synthesize userEmail,password;
+ (LoginViewController *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static LoginViewController * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[LoginViewController alloc] init];
    });
    return sSharedInstance;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
		[backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
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
        self.title = @"登陆";
    }
    return self;
}

- (void)backAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WowCreads" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userEmail.delegate=self;
    self.password.delegate=self;
    
    if (self.selectAutoLogoBtn.selected) {
        self.selectAutoLogoBtn.selected = YES;
    } else {
        self.selectAutoLogoBtn.selected = NO;
    }
    if (![[self getUserName] isEqualToString:@""] || ![[self getPassword] isEqualToString:@""]) {
        self.userEmail.text = [self getUserName];
        self.password.text = [self getPassword];
    } else {
        self.userEmail.text = @"";
        self.password.text = @"";
    }
}

- (void)viewDidUnload
{
    [self setSelectAutoLogoBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma - mark button event

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

-(IBAction)login:(id)sender
{
    [self.userEmail resignFirstResponder];
    
    if (![self isValidEmailAddress:userEmail.text]) {
        [self.view makeToast:@"请输入正确的邮箱地址" duration:0.5 position:@"center" title:nil];
        return;
    }
    if ([self.userEmail.text isEqualToString:@""] || self.userEmail.text ==nil || [self.password.text isEqualToString:@""] || self.password.text == nil){
        [self.view makeToast:@"请填写完整内容" duration:0.5 position:@"center" title:nil];
        return;
    }
    //发送 登陆请求 
    LoginBS *bs = [[[LoginBS alloc] init]autorelease];
    bs.userName = self.userEmail.text;
    bs.password = self.password.text;
    bs.delegate  = self;
    bs.onSuccessSeletor = @selector(loginSucess:);//登陆请求成功后执行代理
    bs.onFaultSeletor = @selector(loginFail:);//登陆请求失败后执行代理

    [bs asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

}

- (void)loginFail:(ASIHTTPRequest *)request
{

    [self.view makeToast:@"登录失败" duration:0.5 position:@"center" title:nil];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)loginSucess:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (request.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
            
        }else{
            return;
        }
        
    }else{
        NSString *jsonString = [request responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }
  
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus==401 ) {

        [self.view makeToast:@"用户名或者密码错误" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    if (responseStatus!=200 ) {

         [self.view makeToast:@"登录失败" duration:0.5 position:@"center" title:nil];
        return;
    }
    else
    {
        if ([[dic objectForKey:@"customerID"] intValue] != 0) {

            [Single shareSingle].isResf = YES;
    
            if (![userEmail.text isEqual:@""] && ![password.text isEqual:@""] && ![Util isLogin]) {//针对 一般登陆（非新浪和腾讯微博登陆）
                [Util setLogin:userEmail.text password:password.text];//储存登录名和密码
//                [Util setLoginOk];//更改登录状态
            }
            
            if (self.selectAutoLogoBtn.selected) {//下次自动登录
                if (![Util isLogin]) {
                    [self saveUserNameOrPassword:userEmail.text password:password.text];
                }
                
            }
            
            [Util setCustomerID:(NSString*)[dic objectForKey:@"customerID"]]; //存储当前用户 ID
            [Util setLoginOk];
            
            [self requestData:1 requestType:100];//登陆成功后显示用户购物车和专柜取货中的商品数

        }else
        {

             [self.view makeToast:@"登录失败" duration:0.5 position:@"center" title:nil];
        }
    }

}

-(void)requestData:(int)pageNumber requestType:(int)type
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    
    NSString *urlString;
    if (type==100) {//专柜取货 请求
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,QH_LIST];
        
        [jsonreq setValue:@"3" forKey:@"orderType"];
         
    }else{  //购物车  请求
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_LIST];
    }
    
    [jsonreq setValue:[NSNumber numberWithInt:pageNumber] forKey:@"pageNumber"];
    
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

    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    requestForm.tag=type;
    [requestForm setDidFinishSelector:@selector(getListCountFinish:)];//发送请求成功后执行的代理
    [requestForm setDidFailSelector:@selector(getListCountFailed:)];//发送请求失败后执行的代理
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];

}
-(void)getListCountFinish:(ASIHTTPRequest *)request{
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

    NSMutableArray *products= nil;
    
    if (requestForm.tag==100) { //专柜取货
        
        products = [dic objectForKey:@"shoppePickup"];
        
        [Util SaveShoppeArray:products];
        [self showListCount:requestForm.tag];
        [self requestData:1 requestType:101];
    }else if (requestForm.tag==101){ //购物车
        
        products = [dic objectForKey:@"cartList"];

        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
      
        [Util saveCartListCount:[NSString stringWithFormat:@"%d",products.count]];
        [Util saveCartProducts:products];
        
        [self showListCount:requestForm.tag];

         [self.navigationController.view makeToast:@"登录成功" duration:0.5 position:@"center" title:nil];
        
        [self backAction];
        
    }
}

-(void)showListCount:(int)type{ //显示购物车和专柜取货中的商品数量
    
    LKCustomTabBar *customTabbar=[LKCustomTabBar shareTabBar];
    
    if (type==100) {  //专柜取货
        UILabel *countLable1=(UILabel*)[customTabbar.slideQH viewWithTag:1988];
        countLable1.text=[NSString stringWithFormat:@"%d",[Util getShoppeArray].count];
        
        if ([countLable1.text integerValue]!=0) {
            customTabbar.slideQH.hidden=NO;
        }else{
            customTabbar.slideQH.hidden=YES;
        }
    }else if (type==101){  //购物车
        UILabel *countLable=(UILabel*)[customTabbar.slideBg viewWithTag:1986];
        countLable.text=[NSString stringWithFormat:@"%@",[Util takeCartListCount]];
        
        if ([countLable.text integerValue]!=0) {
            customTabbar.slideBg.hidden=NO;
        }else{
            customTabbar.slideBg.hidden=YES;
        }
    }
    
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

- (IBAction)sinaLogin:(id)sender {  //新浪微博注册 、登陆
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:self authManagerViewDelegate:nil];
    
    id<ISSSinaWeiboApp> sinaapp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
    [sinaapp setSsoEnabled:NO];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
        if (result)
        {
            if (userInfo.uid == nil || userInfo.nickname == nil) {

                 [self.view makeToast:@"登录失败" duration:0.5 position:@"center" title:nil];
                return;
            }
            [self loginSina:userInfo.uid username:userInfo.nickname];
            [Util setLogin:userInfo.nickname password:userInfo.uid];
            [Util setLoginOk];
        }else {

             [self.view makeToast:@"登录失败" duration:0.5 position:@"center" title:nil];
        }
        
    }];
}

- (void)loginSina:(NSString *)uid username:(NSString *)nickname { //新浪微博注册
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:@"" forKey:@"loginId"];
    [common setValue:@"" forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:nickname forKey:@"name"];
    [jsonreq setValue:uid forKey:@"password"];
    [jsonreq setValue:nickname forKey:@"loginname"];
    [jsonreq setValue:nickname forKey:@"email"];
    [jsonreq setValue:@"" forKey:@"gender"];
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

         [self.view makeToast:@"登录失败" duration:0.5 position:@"center" title:nil];
        return;
    }
    else
    {
        [self loginSinaQQ:nickname password:uid];//微博登陆
    }
}

- (void)loginSinaQQ:(NSString *)userName password:(NSString *)uid {//微博登陆
        
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


- (IBAction)qqLogin:(id)sender {  //获取微博授权   获取微博信息

    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:self authManagerViewDelegate:nil];
    
    
    [ShareSDK getUserInfoWithType:ShareTypeTencentWeibo authOptions:authOptions result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSDictionary *userInfoDic = userInfo.sourceData;
            NSString *openid = [userInfoDic objectForKey:@"openid"];
            if (openid == nil || userInfo.nickname == nil)
            {

                 [self.view makeToast:@"登录失败" duration:0.5 position:@"center" title:nil];
                return;
            }
            NSLog(@"openid== %@",userInfo.uid);
            [self loginSina:openid username:userInfo.nickname];
            [Util setLogin:userInfo.nickname password:userInfo.uid];
            [Util setLoginOk];
        }else {
             [self.view makeToast:@"授权失败，请重新授权" duration:0.5 position:@"center" title:nil];
        }
    }];
}

//选择自动登录
- (IBAction)selectAutoLogoin:(id)sender {
    if (self.selectAutoLogoBtn.selected) {
        self.selectAutoLogoBtn.selected = NO;
        [self cancelUserName];
    } else {
        self.selectAutoLogoBtn.selected = YES;
        [self saveUserNameOrPassword:self.userEmail.text password:self.password.text];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [ProductDetailViewController_Detail2 setPushState:1];
}

- (void)dealloc {
    [_selectAutoLogoBtn release];
    [super dealloc];
}
@end
