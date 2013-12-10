//
//  MyWowViewController.m
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyWowViewController.h"

#import "LKCustomTabBar.h"
 
#import "LoginViewController.h"
#import "RegisterView.h"
#import "MySettingViewController.h"
#import "MyOrderViewController.h"
#import "JFVC.h"
#import "CustomAlertView.h"
 
#import "MembershipCardVC.h"
#import "CartViewController.h"
#import "CustomAlertView.h"
#import "AboutVC.h"
#import "WTVC.h"
#import "Single.h"
 
#import <ShareSDK/ShareSDK.h>
#import "HistoryVC.h"
#import "HistoryListBS.h"
#import "MyCouponViewController.h"

#import "GetintegralBS.h"
#import "MobClick.h"
@interface MyWowViewController ()
@property GetintegralBS *getinBS;

@end


@implementation MyWowViewController
@synthesize getinBS=_getinBS;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark – viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"myWow"];//我的wow事件统计ID
     _getinBS=[[GetintegralBS alloc] init];
    _priceImageView.hidden = YES;
    
    UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
    [self.view addSubview:titbackImageview];
    [titbackImageview release];
    
    //自定义标题
//    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)] autorelease];
//    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
//    titleLabel.font = [UIFont boldSystemFontOfSize:15];  //设置文本字体与大小
//    titleLabel.textColor = [UIColor colorWithRed:(0.0/255.0) green:(255.0 / 255.0) blue:(0.0 / 255.0) alpha:1];  //设置文本颜色
//    titleLabel.textAlignment = UITextAlignmentCenter;
//    titleLabel.text = @"自定义标题";  //设置标题
//    self.navigationItem.titleView = titleLabel;
    self.title = @"我的Wow";
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WowCreads" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takWowCreads:) name:@"WowCreads" object:nil];
    

    if ([Util isLogin]) {
        _logoBtn.hidden = YES;
        _ZXBtn.hidden = NO;
        _ZCBtn.hidden = YES;
        [self getintegral]; // 获取用户积分金额
    } else {
        _logoBtn.hidden = NO;
        _ZXBtn.hidden = YES;
        _ZCBtn.hidden = NO;
    }
      
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, (iPhone5)? IPHONE_HEIGHT:420-50);

	// Do any additional setup after loading the view.
}

-(void)takWowCreads:(NSNotification*)sender{
    if ([Util isLogin]) {
        [self getintegral];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    
    if ([Util isLogin]) {
        _logoBtn.hidden = YES;
        _ZXBtn.hidden = NO;
        _ZCBtn.hidden = YES;
        _loginLabel.text = [Util getLoginName];
       
    } else {
        _logoBtn.hidden = NO;
        _ZXBtn.hidden = YES;
        _ZCBtn.hidden = NO;
        _loginLabel.text = @"尚未登录";
        _jifenLabel.text = @"";
        _yuLabel.text = @"";
    }
    
}

- (void)getintegral {
    _getinBS.delegate=self;
    _getinBS.onSuccessSeletor=@selector(requestGetintegralFinished:);
    _getinBS.onFaultSeletor=@selector(requestGetintegralFailed:);
    [_getinBS asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)requestGetintegralFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
  
    [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];

}
- (void)requestGetintegralFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
          [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
    if (dic == NULL  ) {
          [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
    
    NSString *costomerId = [dic objectForKey:@"customerid"];
    [Util setCustomerID:costomerId];
     _priceImageView.hidden = NO;
    _yuLabel.text = [dic objectForKey:@"wowgoingAccount"];
    _jifenLabel.text = [dic objectForKey:@"credits"];
    [Util saveUserPhoneNumber:[dic objectForKey:@"phone"]];
    if (![[dic objectForKey:@"credits"] isKindOfClass:[NSString class]]) {
        _jifenLabel.text = @"0";
    } else {
       
        _jifenLabel.text = [dic objectForKey:@"credits"];
    }
    
}

- (void)viewDidUnload
{
    [self setLoginLabel:nil];
    [self setJifenLabel:nil];
    [self setYuLabel:nil];
    [self setScrollView:nil];
    [self setLogoBtn:nil];
    [self setZXBtn:nil];
    [self setZCBtn:nil];
    [self setPriceImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma mark 注销
- (IBAction)ZXAction:(id)sender {
    _priceImageView.hidden = YES;
    [Util cancelLogin];
    [Util cancelSinaLogin];
    [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    if (self.isSaveUserPass == NO ) {
         [self cancelUserName];
    }
    self.loginLabel.text = @"尚未登录";
    _jifenLabel.text = @"";
    _yuLabel.text = @"";
    [[CartViewController shareCartController] set_islogout:YES];
    
    [[LKCustomTabBar shareTabBar].slideBg setHidden:YES];
    [[LKCustomTabBar shareTabBar].slideQH setHidden:YES];
    [[[CartViewController shareCartController] productsPayOnline] removeAllObjects];
    [[[CartViewController shareCartController] productsPayToShop] removeAllObjects];
    
     [[[CartViewController shareCartController] cartTable] reloadData];
    
    [Util saveCartListCount:@""];
    [Util saveCartProducts:[NSMutableArray array]];
    
    [Util SaveShoppeArray:[NSMutableArray array]];
    
    
   
    if ([Util isLogin]) {
        _logoBtn.hidden = YES;
        _ZXBtn.hidden = NO;
        _ZCBtn.hidden = YES;
    } else {
        _logoBtn.hidden = NO;
        _ZXBtn.hidden = YES;
        _ZCBtn.hidden = NO;
    }
}


- (IBAction)loginAction:(id)sender {
    LoginViewController *login = [[[LoginViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:login animated:YES];
//    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)registerAction:(id)sender {
    RegisterView *registeView = [[[RegisterView alloc] initWithNibName:nil bundle:nil] autorelease]; 
    [self.navigationController pushViewController:registeView animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
}

- (IBAction)myOrderAction:(id)sender {
    if ([Util isLogin]) {
        MyOrderViewController *myorder = [[[MyOrderViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [self.navigationController pushViewController:myorder animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"没有登录，请登录"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"登录",@"注册",@"取消", nil];
        [alert show];
        [alert release];
        
        return;
    }
}


- (IBAction)myBrowseRecoredsAction:(id)sender {
    if ([Util isLogin]) {
        HistoryVC *historyVc = [[[HistoryVC alloc] initWithNibName:nil bundle:nil] autorelease];
        [self.navigationController pushViewController:historyVc animated:YES];
        //        HistoryListBS *hisbs = [[[HistoryListBS alloc] init] autorelease];
        //        hisbs.delegate = self;
        //        hisbs.onSuccessSeletor = @selector(historeSucess:);
        //        hisbs.onFaultSeletor = @selector(historyFault:);
//        [hisbs asyncExecute];
//        [self showLoadingView];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"没有登录，请登录"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"登录",@"注册",@"取消", nil];
        [alert show];
        [alert release];
        
        return;
    }

}

- (IBAction)mySetingAction:(id)sender {
    
//    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"敬请期待"
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
//    [alert show];
//    [alert release];
    if ([Util isLogin]) {
        MySettingViewController *mysetting = [[[MySettingViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        
        [self.navigationController pushViewController:mysetting animated:YES];
//        self.navigationController.hidesBottomBarWhenPushed = YES;
    } else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil
                                                        message:@"没有登录，请登录"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"登录",@"注册",@"取消", nil]
                                                    autorelease];
        [alert show];
    }
    
}

- (IBAction)rulesAction:(id)sender {
    JFVC *fview = [[[JFVC alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:fview animated:YES];
}

- (IBAction)wentiAction:(id)sender {

    WTVC *wt = [[[WTVC alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:wt animated:YES];
}

- (IBAction)aboutAction:(id)sender {
    AboutVC *about = [[[AboutVC alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:about animated:YES];
}

- (IBAction)myCouponAction:(id)sender {
    
    if ([Util isLogin]) {
        MyCouponViewController *myCoupon = [[[MyCouponViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        
        [self.navigationController pushViewController:myCoupon animated:YES];
    }
    else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil
                                                         message:@"没有登录，请登录"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"登录",@"注册",@"取消", nil]
                              autorelease];
        [alert show];
    }

}

#pragma  - mark login and regiest

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        LoginViewController *loginView = [[[LoginViewController alloc] init] autorelease];
        loginView.delegate = self;
        [self.navigationController pushViewController:loginView animated:YES];
    } else if (buttonIndex == 1) {
        RegisterView *reg = [[[RegisterView alloc] initWithNibName:nil bundle:nil] autorelease];
        reg.delegate = self;
        [self.navigationController pushViewController:reg animated:YES];
    } else {
        
    }
}

-(void)requestData:(int)pageNumber requestType:(int)type
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }
    
    NSString *urlString ;//= [NSString stringWithFormat:@"%@/wowgoing/brandAction/brandList",SEVERURL];
    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    
    if (type==100) {
        urlString = [NSString stringWithFormat:@"%@/history/orderlisttoBuy",SEVERURL];
        [jsonreq setValue:@"3" forKey:@"orderType"];
    }else{
        urlString = [NSString stringWithFormat:@"%@/cart/list",SEVERURL];
    }
    
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey: @"deviceId"];
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
    requestForm.tag=type;
    
    [requestForm setDidFinishSelector:@selector(getListCountFinish:)];
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
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

    NSMutableArray *products= [dic objectForKey:@"products"];
    if (requestForm.tag==100) {
        [Util SaveShoppeArray:products];
        [self requestData:1 requestType:101];
    }else if (requestForm.tag==101){
    
        [Util saveCartListCount:[NSString stringWithFormat:@"%d",products.count]];
        [Util saveCartProducts:products];
    }
    [self showListCount:requestForm.tag];

}

-(void)showListCount:(int)type{ //显示购物车和专柜取货中的商品数量
    
    LKCustomTabBar *customTabbar=[LKCustomTabBar shareTabBar];
    
    if (type==100) {
        UILabel *countLable1=(UILabel*)[customTabbar.slideQH viewWithTag:1988];
        countLable1.text=[NSString stringWithFormat:@"%d",[Util getShoppeArray].count];
        
        if ([countLable1.text integerValue]!=0) {
            customTabbar.slideQH.hidden=NO;
        }else{
            customTabbar.slideQH.hidden=YES;
        }
    }else if (type==101){
       UILabel *countLable=(UILabel*)[customTabbar.slideBg viewWithTag:1986];
       countLable.text=[NSString stringWithFormat:@"%@",[Util takeCartListCount]];
    
      if ([countLable.text integerValue]!=0) {
           customTabbar.slideBg.hidden=NO;
       }else{
           customTabbar.slideBg.hidden=YES;
    }
  }
    
}

- (void)dealloc {
    [_myCouponViewController release];
    [_loginLabel release];
    [_yuLabel release];
    [_scrollView release];
    [_logoBtn release];
    [_ZXBtn release];
    [_ZCBtn release];
    [_priceImageView release];
    [_getinBS release];
    [super dealloc];
}
- (IBAction)myMembershipAction:(id)sender {
    if ([Util isLogin]) {
        MembershipCardVC *membershipVC = [[[MembershipCardVC alloc] initWithNibName:nil bundle:nil] autorelease];
        [self.navigationController pushViewController:membershipVC animated:YES];
    }
    else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil
                                                         message:@"没有登录，请登录"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"登录",@"注册",@"取消", nil]
                              autorelease];
        [alert show];
    }

    
   }
@end
