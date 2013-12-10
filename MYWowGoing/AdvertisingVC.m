//
//  AdvertisingVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-9.
//
//

#import "AdvertisingVC.h"
#import "AdView.h"
#import "ProductViewController.h"
#import "LKCustomTabBar.h"
 
#import "NetworkUtil.h"
#import "CustomAlertView.h"
#import "GetServerCityBS.h"
 
#import "AppDelegate.h"
#import "AdDetailsVC.h"
#import "Single.h"
#import "InvitationCodeBS.h"
#import "FileUtil.h"
#import "MobClick.h"
#import "FileBSDownload.h"
#import "FavoriteViewController.h"
#import "LoadingPageBS.h"
#import "LoginViewController.h"
#import "RegisterView.h"

static AdvertisingVC *sharedADview = nil;

@interface AdvertisingVC ()
@property (strong,nonatomic) NSArray *cityArray;
@property (strong,nonatomic) NSArray *stateArray;
@property (strong,nonatomic) NSArray *countryArray;
@property (strong,nonatomic) NSString *city;   //城市
@property (strong,nonatomic) NSString *state;   //省份
@property (strong,nonatomic) NSString *country; //国家
@property (strong,nonatomic) NSString *detailAddressString; //详细地址p
@property (assign) BOOL boolClickCity;//判断是否点击了点击定位或者是定位城市的按钮
@property (assign) BOOL requestDataBool; //标记数据是否获取成功
@property (assign) BOOL startGpsBool; //点击授权码界面的立刻定位按钮
@property (strong,nonatomic) UIView *defaultView;

@property (retain, nonatomic)ASIFormDataRequest *requestForm;

@end

@implementation AdvertisingVC
- (void)dealloc {
    [_view_Ad release],_view_Ad = nil;
    [_city release], _city = nil;
    [_state release], _state = nil;
    [_country release], _country = nil;
    [_detailAddressString release], _detailAddressString = nil;
    [_cityNameButton release];
    [_cityName release];
    [_cityArray release];
    [_stateArray release];
    [_countryArray release];
    [appStartController release];
    [_adImageView release];
    [_adView release];
    [_gpsView release];
    [_codeTextField release];
    [_gpsImageView release];
    [selectImageView release];
    [_requestForm release];
    [_defaultView release];
    [_xsImageView release];
    [_xpImageView release];
    [_gpsButton release];
    [super dealloc];
}
 
+ (AdvertisingVC *)sharedManager
{
	@synchronized(self)
	{
		if (!sharedADview)
		{
            sharedADview = [[self alloc] init];
        }
    }

	return sharedADview;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cityArray =  [NSArray array];
        self.stateArray = [NSArray array];
        self.countryArray = [NSArray array];
        _boolClickCity = YES;
        _requestDataBool = YES;
        _startGpsBool = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    //自定义数字键盘完成按钮
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    if ([Util isLogin]) {
        [self requestData:1 requestType:100];//显示购物车和专柜取货中商品的数量
    }

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)defaultPngAction {
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *lauchAdView = [[[UIView alloc] initWithFrame:appdelegate.window.bounds] autorelease];
    
    lauchAdView.backgroundColor = [UIColor whiteColor];
    [appdelegate.window addSubview:lauchAdView];
    _defaultView = lauchAdView;
    UIImageView *lauchAdIv = [[[UIImageView alloc] initWithFrame:lauchAdView.bounds] autorelease];
    if (iPhone5) {
        [lauchAdIv setImage:[UIImage imageNamed:@"Default-568h@2x"]];
    } else {
        [lauchAdIv setImage:[UIImage imageNamed:@"Default@2x"]];
    }
    [lauchAdIv setBackgroundColor:[UIColor blackColor]];
    [_defaultView addSubview:lauchAdIv];
    
    LoadingPageBS *lbs = [[[LoadingPageBS alloc] init] autorelease];
    lbs.delegate = self;
    if (!iPhone5) {
        lbs.phoneTypeString = @"2";
    }else {
        lbs.phoneTypeString = @"3";
    }
    lbs.onSuccessSeletor = @selector(loadingPageSuccess:);
    lbs.onFaultSeletor = @selector(loadingPageFault:);
    [lbs asyncExecute];
    
//    [self startLaodAD:nil];
    
}
#pragma mark ---------- 开始下载广告
- (void)startLaodAD:(NSString *)stringUrl {

    
    FileBSDownload *bs = [[[FileBSDownload alloc] init]autorelease];
    bs.url = stringUrl;
//        bs.url = @"http://www.baidupcs.com/file/58766aaa34946ce9eeb49cdcf7a908d2?xcode=f09813b145c844a6af58540aee7da73a1fc5cfe911c6275e&fid=1963414771-250528-2182601841&time=1375949655&sign=FDTAXER-DCb740ccc5511e5e8fedcff06b081203-hBMETovhvkSNeWFnxUBG8n7IYlc%3D&to=wb&fm=N,B,T&expires=8h&rt=pr&r=699252900&logid=3501986699&fn=loading.png";
    //    bs.url = @"http://a.hiphotos.bdimg.com/album/w%3D2048/sign=6f6a285f78310a55c424d9f4837d42a9/a8014c086e061d95922785947af40ad162d9ca3d.jpg";
    bs.delegate  = self;
    bs.onSuccessSeletor = @selector(onImageDownloadSuccessSeletor:);
    bs.onFaultSeletor = @selector(onImageDownloadFailedSeletor:);
    [bs asyncExecute];
    
}

- (void)loadingPageSuccess:(ASIFormDataRequest *)request {
    
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
    }else{
        //如果网络好，但是返回数据为空。或者是有问的。就加载默认图片
        [self startLaodAD:nil];
        return;
    }
    
    //判断返回参数是否正确不正确就return
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        [self startLaodAD:nil];
        NSLog(@"default图片状态为空");
        return;
    }
    
    NSDictionary *phoneTypePic = [dic objectForKey:@"homePic"];
    NSString *urlStr = [phoneTypePic objectForKey:@"homePicure"];
    
    //开始下载default图片
    [self startLaodAD:urlStr];
 
}
- (void)loadingPageFault :(ASIFormDataRequest *)request {
    NSLog(@"默认图加载失败！");
}

// 图片下载成功
- (void)onImageDownloadSuccessSeletor:(NSString*)path {
    
    [_defaultView removeFromSuperview];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIView *lauchAdView = [[[UIView alloc] initWithFrame:appdelegate.window.bounds] autorelease];
    lauchAdView.backgroundColor = [UIColor whiteColor];
    [appdelegate.window addSubview:lauchAdView];
    UIImageView *lauchAdIv = [[[UIImageView alloc] initWithFrame:lauchAdView.bounds] autorelease];
    [lauchAdIv setBackgroundColor:[UIColor blackColor]];
    [lauchAdView addSubview:lauchAdIv];
    self.ADView = lauchAdView;
    //加载cash目录下广告图片，如果没有，加载程序自带图片
    UIImage *adImage = [UIImage imageWithContentsOfFile:path];
    
    if (adImage) {
        [lauchAdIv setImage:adImage];
        NSLog(@"有下载的图片");
    }else {
        NSLog(@"使用默认图片");
        if (iPhone5) {
            [lauchAdIv setImage:[UIImage imageNamed:@"dealf568@2x"]];
        } else {
            [lauchAdIv setImage:[UIImage imageNamed:@"dealf@2x"]];
        }
        
    }
    
    //延迟3秒删除广告界面
    if (self.removeADTimer) {
        [self.removeADTimer invalidate];
        self.removeADTimer = nil;
    }
    self.removeADTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                          target:self
                                                        selector:@selector(onLauchADTimer)
                                                        userInfo:nil
                                                         repeats:NO];
    
    

}

//定时调用方法
- (void)onLauchADTimer
{
    //    self.ADButton.userInteractionEnabled = NO;
    //透明动画
    CAKeyframeAnimation *myOpacity = [self opacity];
    [self.ADView.layer addAnimation:myOpacity forKey:@"myOpacity"];
    //删除广告界面
    [NSThread detachNewThreadSelector:@selector(removeADSViewOnOtherThread) toTarget:self withObject:nil];

}
//在子线程肿延迟删除广告界面
- (void)removeADSViewOnOtherThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:1.0];
    [self removeADSView];
    [pool release];
}

//删除广告界面
- (void)removeADSView
{
    [self.ADView removeFromSuperview];
     [self helpViewAction];//加载引导页
    
    NSString *gpsCityString = [Util getCityName];
    if (![gpsCityString isEqualToString:@""]) {
        //定位成功获得服务器返回的城市
        [self getrelatedCity];
    } else {
        self.gpsView.hidden = NO;
        [self.gpsView removeFromSuperview];
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegate.window addSubview:self.gpsView];
        
        _adImageView.hidden = YES;
        [self.view bringSubviewToFront:self.gpsView];
        
    }
    
    [self addSelectImageView]; //添加右上角按钮点击后的视图
    
}

//广告界面透明动画设置
- (CAKeyframeAnimation *)opacity
{
    CAKeyframeAnimation *opAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	opAnim.duration = 0.9;
	opAnim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0],nil];
	opAnim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1],nil];
	opAnim.fillMode = kCAFillModeForwards;
	opAnim.removedOnCompletion = NO;
	[opAnim setValue:@"opacity" forKey:@"opacity"];
    return opAnim;
}

#pragma mark ---------- 引导页
- (void)helpViewAction {
    NSLog(@"开始引导页啦");
    //加载引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        appStartController = [[GuidanceVC alloc] initWithNibName:@"GuidanceVC" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:appStartController.view];
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickPushAdview" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAdViewNotification:) name:@"adView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adPushAction:) name:@"clickPushAdview" object:nil];
    
    //启动时广告显示底图
    if (iPhone5) {
        _adImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页底图-568.jpg"]];
        [_adImageView setFrame:CGRectMake(10, 46, 302, 318)];
        _gpsImageView.image = [UIImage imageNamed:@"定位切图-iPhone5"];
        _codeTextField.frame = CGRectMake(_codeTextField.frame.origin.x, _codeTextField.frame.origin.y-20, _codeTextField.frame.size.width, _codeTextField.frame.size.height);
    } else {
        _adImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页底图.jpg"]];
        [_adImageView setFrame:CGRectMake(10, 46, 302, 235)];
        _codeTextField.frame = CGRectMake(_codeTextField.frame.origin.x, _codeTextField.frame.origin.y, _codeTextField.frame.size.width, _codeTextField.frame.size.height);
//        _gpsImageView.frame = CGRectMake(_gpsImageView.frame.origin.x, _gpsImageView.frame.origin.y, _gpsImageView.frame.size.width, IPHONE_HEIGHT);
        _gpsImageView.image = [UIImage imageNamed:@"定位"];
    }
    [self.view addSubview:_adImageView];
}

- (void)viewDidLoad
{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAdViewLoading) name:@"addAdViewLoading" object:nil];
    //加载初始化图片
    [self.gpsView setHidden:YES]; //隐藏定位界面
    BOOL netWork = [NetworkUtil canConnect];
    if (netWork) {
        [self defaultPngAction];
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.gpsView];
    if (!iPhone5) {
        _xsImageView.frame = CGRectMake(_xsImageView.frame.origin.x, _xsImageView.frame.origin.y, _xsImageView.frame.size.width, 118);
        _xpImageView.frame = CGRectMake(_xpImageView.frame.origin.x, _xpImageView.frame.origin.y, _xpImageView.frame.size.width, 118);
        //如果是非iphone5
        
        _gpsButton.frame = CGRectMake(_gpsButton.frame.origin.x, _gpsButton.frame.origin.y-10, _gpsButton.frame.size.width, _gpsButton.frame.size.height);
    }else {
        _gpsButton.frame = CGRectMake(_gpsButton.frame.origin.x, _gpsButton.frame.origin.y-10, _gpsButton.frame.size.width, _gpsButton.frame.size.height);
    }
    NSLog(@"%f",_xpImageView.frame.size.width);
    NSLog(@"%f",_xpImageView.frame.size.height);
    
    
}

#pragma mark ---------- 数字键盘
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    if (_doneInKeyboardButton.superview)
    {
        [_doneInKeyboardButton removeFromSuperview];
    }
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    if (_doneInKeyboardButton == nil)
    {
        _doneInKeyboardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if(screenHeight==568.0f){//爱疯5
            _doneInKeyboardButton.frame = CGRectMake(0, 568 - 53, 106, 53);
        }else{//3.5寸
            _doneInKeyboardButton.frame = CGRectMake(0, 480 - 53, 106, 53);
        }
        
        _doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        
        [_doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_up@2x.png"] forState:UIControlStateNormal];
        [_doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    _doneInKeyboardButton.selected=NO;
    if (_doneInKeyboardButton.superview == nil)
    {
        [tempWindow addSubview:_doneInKeyboardButton];    // 注意这里直接加到window上
    }
    
}
#pragma mark ---------- 数据键盘完成按钮
-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    NSLog(@"关闭了键盘");
    
}

- (void)invitationAction {
    if (NET_WORK) {
        InvitationCodeBS *invitationBS = [[[InvitationCodeBS alloc] init] autorelease];
        invitationBS.delegate = self;
        invitationBS.onSuccessSeletor = @selector(invitationRequestSuccess:);
        invitationBS.onFaultSeletor = @selector(invitationFaultSuccess:);
        invitationBS.invitetionCodeString = _codeTextField.text;
        [invitationBS asyncExecute];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    } else {
        [self.view makeToast:@"网络错误，请检查网络"];
    }
   
}

- (void)invitationRequestSuccess:(ASIFormDataRequest *)request {
    
    NSLog(@"邀请码定位成功开始解析");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
            _gpsView.hidden = YES;
        }else{
//             _gpsView.hidden = NO;
              _gpsView.hidden = YES;
            [self.view makeToast:NETWORK_STRING];
            return;
        }
        if (error) {
//             _gpsView.hidden = NO;
              _gpsView.hidden = YES;
            [self.view makeToast:NETWORK_STRING];
            return;
        }
        
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    NSLog(@"%d",resultStatus);
    if (!resultStatus) {
        return;
    }
    
    if ([dic objectForKey:@"dto"] == nil || ![dic isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    NSLog(@"dto==%@",[dic objectForKey:@"dto"]);
    //邀请码对应的城市
    NSString *cityString = [dic objectForKey:@"cityName"];
    if (cityString == nil || ![cityString isKindOfClass:[NSString class]]) {
        return;
        
    }
    NSDictionary *dtoDic = [dic objectForKey:@"dto"];
    
    //邀请码关联城市
    NSString *subsidiarycityName = [dtoDic objectForKey:@"subsidiarycityName"];
    if (subsidiarycityName == nil || ![subsidiarycityName isKindOfClass:[NSString class]]) {
        return;
        
    }
    self.cityName = subsidiarycityName;
    [Util saveCity:subsidiarycityName]; //保存城市替换原来定位成功后保存的城市
    [self saveBrowerCity:subsidiarycityName];  //保存城市供浏览使用
    [Util saveAdViewCity:subsidiarycityName]; //保存广告的定位城市
    //显示左上角的按钮
    [self.cityNameButton setTitle:subsidiarycityName forState:UIControlStateNormal];
    //开始加载广告
    [self addAdViewLoading];
    
}

- (void)invitationFaultSuccess:(ASIFormDataRequest *)request {
//    _gpsView.hidden = NO;
      _gpsView.hidden = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.view makeToast:NETWORK_STRING];
    
}

#pragma mark ---------- 初始化城市数据
- (void)cityLoadData {
    self.cityArray = [NSArray arrayWithObjects:@"西安市",@"哈尔滨市",@"石家庄市",@"兰州市",@"昆明市",@"成都市",@"长春市",@"沈阳市",@"西宁市",@"郑州市",@"济南市",@"太原市",@"合肥市",@"武汉市",@"长沙市",@"南京市",@"贵阳市",@"南宁市",@"杭州市",@"南昌市",@"广州市",@"福州市",@"台北市",@"海口市",@"呼和浩特市",@"银川市",@"乌鲁木齐市",@"拉萨市",@"澳门",@"北京市",@"上海市",@"香港",@"天津市",@"重庆市", nil];
    
}

#pragma mark ---------- 开始加载广告框
- (void)addAdViewLoading {
    NSLog(@"adviewLoading");
    //    /* -> 添加广告框 */
    
//    AdView *adview=(AdView*)[self.view viewWithTag:19871007];
    if (_view_Ad != nil) {
        [_view_Ad removeFromSuperview];
    }
    
    _view_Ad = [[AdView alloc] initWithFrame:CGRectMake(10.f, 46.f, 302.f, 280.f)];
    _view_Ad.tag=19871007;
    
    
    _view_Ad.adDelegate = self;
    _view_Ad.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_view_Ad];
    
    _view_Ad.backgroundColor = [UIColor clearColor];

    //显示广告框
    _view_Ad.hidden =NO;
    [self.adImageView removeFromSuperview];
    
}

- (void)startGPS {
   //加载城市数据
    [self cityLoadData];
     //判断网络是否开启 
    BOOL netWork = [NetworkUtil canConnect];
    if (netWork) {
        [self loadGPSData];
    } else {
        [self addAdViewLoading];
        //启动时广告显示底图1
        
        if (_adImageView != nil) {
            [_adImageView removeFromSuperview];
        }
        if (iPhone5) {
            _adImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页底图-568.jpg"]];
            [_adImageView setFrame:CGRectMake(10, 46, 302, 318)];
        } else {
            _adImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页底图.jpg"]];
            [_adImageView setFrame:CGRectMake(10, 46, 302, 235)];
        }
        [self.view addSubview:_adImageView];
        CustomAlertView *customAlert = [[[CustomAlertView alloc] initWithTitle:nil
                                                                       message:@"请检查您的网络是否有问题" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil]
                                        autorelease];
        [customAlert show];
    }
    
}

#pragma mark – 显示授权码界面
- (void)showGpaView {
    //定位失败隐藏广告栏。显示定位view；
//    self.gpsView.hidden = NO;
    self.gpsView.hidden = YES;
    [_view_Ad setHidden:YES];
    [_adImageView setHidden:YES];
}

- (void)loadGPSData {
    //启动GPS
    [CoordinateReverseGeocoder getCurrentCity];
    if (_checkGPSTimer != nil) {
        [_checkGPSTimer invalidate];
        _checkGPSTimer = nil;
        
    }
    //去掉定位功能
    _checkGPSTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(checkGPS)
                                                    userInfo:nil
                                                     repeats:YES];
    
    _HUD=[[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    [self.navigationController.view addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.labelText = @"正在定位中...";
    [_HUD show:YES];
}

- (void) checkCityName{

 


}


#pragma mark ---------- 定位成功好后
-(void)checkGPS
{
//    [Util deleteCityName]; //删除存储的城市
    //获得城市
    NSString *cityLocation = [[CoordinateReverseGeocoder getShareCoord] city];
    //获得省份
    NSString *stateString = [[CoordinateReverseGeocoder getShareCoord] stateHK];
    //获得国家
    NSString *countryString = [[CoordinateReverseGeocoder getShareCoord] Country];
    //详细信息
    NSString *detailAddString = [[CoordinateReverseGeocoder getShareCoord] detailAdressName];

    if (_HUD) {
        _HUD.hidden = YES;
    }
    //1 是yes 0是no
    //测试使用。屏蔽以下消息
    if ([[CoordinateReverseGeocoder getShareCoord] isOver] == YES) {
        //取消定时器
        if (_checkGPSTimer != nil) {
            [_checkGPSTimer invalidate];
            _checkGPSTimer = nil;
        }
        
        // 如果定位城市为西安市或石家庄市 则直接保存定位城市   -----11.29改
        if ([cityLocation isEqualToString:@"西安市"] || [cityLocation isEqualToString:@"石家庄市"]) {
             [Util saveCity:cityLocation];
             self.cityName = cityLocation;
            [self.cityNameButton setTitle:self.cityName forState:UIControlStateNormal];
            [self saveBrowerCity:self.cityName];  //保存城市供浏览使用
            [Util saveAdViewCity:self.cityName]; //保存广告的定位城市
            [self addAdViewLoading];
            
            return;
        }
        // --------2013.11.29改
        
        
        
        
        //如果城市不为空，就直接去城市进行对比，如果城市为空，那就取省份对比。否则就取国家对比
        if (cityLocation != nil) {
            //判断cityArray数组中是否存在某元素
            BOOL isValue = [_cityArray containsObject:cityLocation];
            //如果包含就直接保存定位城市，
            if (isValue) {
                NSLog(@"有%@这个城市",cityLocation);
                if (_boolClickCity == YES) {
                    [Util saveCity:cityLocation];
                }
                self.cityName = cityLocation;
            } else { //如果不包含就取省份
                BOOL isValue = [_cityArray containsObject:stateString];
                if (isValue) { //如果是否存在就保存省份
                    NSLog(@"有%@这个城市",stateString);
                    if (_boolClickCity == YES) {
                        [Util saveCity:stateString];
                    }
                    self.cityName = stateString;
                } else  { //否则取国家
                    BOOL isValue = [_cityArray containsObject:countryString];
                    if (isValue) { //存在，保存国家
                        NSLog(@"有%@这个城市",countryString);
                        if (_boolClickCity == YES) {
                            [Util saveCity:countryString];
                        }
                        self.cityName = countryString;
                        
                    }
                }
    
            }
        } else if (stateString != nil) {
            BOOL isValue = [_cityArray containsObject:stateString];
            if (isValue) {
                NSLog(@"有%@这个城市",stateString);
                if (_boolClickCity == YES) {
                    [Util saveCity:stateString];
                }
                self.cityName = stateString;
                
            } else  {
                BOOL isValue = [_cityArray containsObject:countryString];
                if (isValue) {
                    NSLog(@"有%@这个城市",countryString);
                    if (_boolClickCity == YES) {
                        [Util saveCity:countryString];
                    }
                    self.cityName = countryString;
                }
            }
        } else if (countryString != nil ) {
            
            BOOL isValue = [_cityArray containsObject:countryString];
            if (isValue) {
                NSLog(@"有%@这个城市",countryString);
                if (_boolClickCity == YES) {
                    [Util saveCity:countryString];
                }
                self.cityName = countryString;
            }
            
        }

        //如果全部为空就重新定位
        if (cityLocation == nil && stateString == nil && countryString == nil && detailAddString == nil) {
            [self.cityNameButton setTitle:@"点击定位" forState:UIControlStateNormal];
            //定位失败隐藏广告栏。显示定位view；
            self.gpsView.hidden = NO;
            [_view_Ad removeFromSuperview];
            [_adImageView removeFromSuperview];
            
        }
        
        NSString *cityGpsString = [Util getCityName];
        
        //如果没有点击左上角的按钮情况，也就是程序第一次运行的时候走这里
        if (_boolClickCity == NO) {
            if ([cityGpsString isEqualToString:self.cityName]) {
                [self.view makeToast:[NSString stringWithFormat:@"到了其他城市，再用定位切换城市吧！"]];
                //如果上次服务器关联城市么有获得到
                if (_requestDataBool == NO) {
                    NSLog(@"没有得到关联城市");
                    [self getrelatedCity];
                }
            }
            else {
                //如果当前定位的城市和上次保存的城市不相同的话
                
                [Util saveCity:self.cityName];
                [self getrelatedCity];
            }
        }
        
        //如果不相同  定位成功获得服务器返回的城市 boolClickCity == YES 初始化的是就是yes 如果点击了左上角的位置按钮，boolcilickCity变成 no
        if (_boolClickCity) {
            [Util saveCity:self.cityName];
            [self getrelatedCity];
        }
        
    } else {
        _gpsTimer++;
        if(_gpsTimer>7)
        {
            //取消定时器
            if (_checkGPSTimer != nil) {
                [_checkGPSTimer invalidate];
                _checkGPSTimer = nil;
            }
            NSString *gpsString = [Util getCityName];
            
            if (gpsString == nil) {
                //定位失败隐藏广告栏。显示定位view；
//                [self showGpaView];
                //在没有点击点击定位按钮时不走这段代码，如果点击了点击定位，并且没有定位成功后走这里
                if (_boolClickCity == YES) {    
                    [Util saveCity:@""];
                }
            } else {
                
                [self.view makeToast:@"无法定位，请继续查看当前内容"];
                //无法定位时候 定位界面出现
//                [self showGpaView];

            }
            
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}


#pragma mark ---------- uialertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"指向上次成功的定位城市"]) {
        
        if (buttonIndex == 0)
        {
           
            [self startGPS];
            _gpsTimer = 0;
        }
        else
        {
            [self.cityNameButton setTitle:[Util getCityName] forState:UIControlStateNormal];
            self.cityName = [Util getCityName];
            [self getrelatedCity];
            
        }
        
    }
    if ([alertView.message isEqualToString:@"无法定位,请重新定位"]){
        [self startGPS];
        _isGPSOk = NO;
        _gpsTimer = 0;
        
    }
    
    if ([alertView.title isEqualToString:@"我们给您提供的是您身边的商场的服装信息，购引需要知道您来自何方?"]) {
        [self startGPS];
        _isGPSOk = NO;
        _gpsTimer = 0;
    }
    
    if ([alertView.message isEqualToString:@"您还未登录,请先登录"]) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
            {
                LoginViewController *loginVC=[[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil] autorelease];
                [self.navigationController pushViewController:loginVC animated:YES];
                self.navigationController.navigationBarHidden = NO;
            }
                break;
            case 2:
            {
                RegisterView *registerVC=[[[RegisterView alloc]initWithNibName:@"RegisterView" bundle:nil] autorelease];
                [self.navigationController pushViewController:registerVC animated:YES];
                self.navigationController.navigationBarHidden = NO;
            }
                break;
            default:
                break;
        }
    }

}

//请求服务器发回对应城市
- (void)getrelatedCity
{
    GetServerCityBS *serverCity  = [[[GetServerCityBS alloc] init] autorelease];
    serverCity.delegate = self;
    serverCity.onSuccessSeletor = @selector(getrelatedCitySucess:);
    serverCity.onFaultSeletor = @selector(getrelatedCityFault:);
    [serverCity asyncExecute];
    
}

#pragma mark ---------- 从服务器返回的城市处理

- (void)getrelatedCitySucess:(ASIFormDataRequest *)request
{
    NSLog(@"返回城市");
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        NSLog(@"返回的城市=== %@",dic);
        //如果发回测数据没有城市字段
        
        if (dic == nil && ![dic isKindOfClass:[NSMutableDictionary class]]) {
            _requestDataBool = NO;
        } else {
            _requestDataBool = YES;
        }
        _gpsView.hidden = YES;
        
    }else{
        [self.view makeToast:@"您的网络不给力,请重新试试吧"];
//        [self showGpaView];
        return;
    }
    if (error) {
//        [self showGpaView];
        return;
    }
    
    _view_Ad.hidden = YES; //数据没有加载完之前隐藏广告框
    NSString *cityString = [dic objectForKey:@"subsidiarycityName"];
    NSLog(@"定位城市返回字段：subsidiarycityName == %@",cityString);

    
     //如果发回测数据没有城市字段,直接跳出 不做任何处理，包括更新左上角的城市位置
    if (cityString == nil || ![cityString isKindOfClass:[NSString class]]) {
        _requestDataBool = NO;
        return;
    }
    self.cityName = cityString;
    [self saveBrowerCity:self.cityName];  //保存城市供浏览使用
    [Util saveAdViewCity:self.cityName]; //保存广告的定位城市
    //如何服务器返回的城市为空
    if ([cityString isEqualToString:@""] || ![cityString isKindOfClass:[NSString class]]) {
        [self.cityNameButton setTitle:@"点击定位" forState:UIControlStateNormal];
        [self.view makeToast:[NSString stringWithFormat:@"您现在所在的当前位置没有开通，请再等等吧"]];
        return;
    }

    //获取定位的城市
    NSString *locateCity = [Util getAdViewCity];
    NSString *gpsCityName = [Util getCityName];//gps定位成功的城市
    if ([cityString isEqualToString:@""] || ![cityString isKindOfClass:[NSString class]]) {
        [self.view makeToast:[NSString stringWithFormat:@"您现在所在的当前位置没有开通，请再等等吧"]];
        [self.cityNameButton setTitle:@"点击定位" forState:UIControlStateNormal];
        return;
    }
    
    //判断定位城市和服务器返回的城市是否相等。如果相等说明开通了服务。否则就是关联
    if ([gpsCityName isEqualToString:self.cityName]) {
        [self.view makeToast:[NSString stringWithFormat:@"您现在当前位置:%@\n您将浏览%@商场的折扣信息",locateCity,self.cityName]];
        
    } else {
        [self.view makeToast:[NSString stringWithFormat:@"当前位置尚未开通，你将浏览%@商场的折扣信息",self.cityName]];
        
    }
    [self.cityNameButton setTitle:self.cityName forState:UIControlStateNormal];
    [self addAdViewLoading];

}

//请求城市失败
- (void)getrelatedCityFault:(ASIFormDataRequest *)request
{  
    [self.view makeToast:@"您的网络不给力,请重新试试吧"];
//    [self showGpaView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCityNameButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:@"clickPushAdview"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"adView"];
    
    [self setAdImageView:nil];
    [self setAdView:nil];
    [self setGpsView:nil];
    [self setCodeTextField:nil];
    [self setGpsImageView:nil];
    [self setXsImageView:nil];
    [self setXpImageView:nil];
    [self setGpsButton:nil];
    [super viewDidUnload];
}

#pragma mark ---------- 限时抢购
- (IBAction)xsClick:(id)sender {
    
    [MobClick beginEvent:@"xianshi"];
    [Single shareSingle].isXianShi = YES;
    [Single shareSingle].isADV = NO;

    ProductViewController *provc = [[[ProductViewController alloc ]initWithNibName:@"ProductViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:provc animated:YES];
}

- (IBAction)newDIscountAction:(id)sender {
    
    [Single shareSingle].isXianShi = NO;
    [Single shareSingle].isADV = NO;

    ProductViewController *provc = [[[ProductViewController alloc ]initWithNibName:@"ProductViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:provc animated:YES];
    
}

#pragma mark ---------- 点击左上角的城市开始重新定位
- (IBAction)resetGPSAction:(id)sender {
    _boolClickCity = NO;
    [self startGPS];
    
}

#pragma mark ---------- 点击广告
- (void)adPushAction:(NSNotification *)notification {
    
    [Single shareSingle].isADV = YES;

    AdDetailsVC  *adDetailVC = [[[AdDetailsVC alloc ] initWithNibName:@"AdDetailsVC" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:adDetailVC animated:YES];
    
}
- (void)pushAdViewNotification:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------- /委托实现点击广告
- (void)pushADViewAction {
    
    [Single shareSingle].isADV = YES;

    ProductViewController *provc = [[[ProductViewController alloc ]initWithNibName:@"ProductViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:provc animated:YES];
    
}

- (void)pushAdView {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)evaluateAction:(id)sender {
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id = 608833789"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark ---------- 点击立刻定位 授权码的界面
- (IBAction)gpsStartAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (!button) {
        return;
    }

    _boolClickCity = YES;
    [self finishAction];
    //判断点击textfied
    if (_codeTextField.text.length != 0) {
        [self invitationAction];
    } else {
        [self startGPS];
    }

    self.gpsView.hidden = YES;
    _adImageView.hidden = NO;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GPSBOOL"];
   
}

#pragma mark ---------- 通用方法不让键盘遮住UITextField
- (void)moveView:(UITextField *)textField leaveView:(BOOL)leave
{
    UIView *accessoryView = textField.inputAccessoryView;
    UIView *inputview     = textField.inputView;
    
    int textFieldY = 0;
    int accessoryY = 0;
    if (accessoryView && inputview)
    {
        CGRect accessoryRect = accessoryView.frame;
        CGRect inputViewRect = inputview.frame;
        accessoryY = IPHONE_HEIGHT - (accessoryRect.size.height + inputViewRect.size.height);
    }
    else if (accessoryView)
    {
        CGRect accessoryRect = accessoryView.frame;
        accessoryY = IPHONE_HEIGHT - (accessoryRect.size.height + 216);
    }
    else if (inputview)
    {
        CGRect inputViewRect = inputview.frame;
        accessoryY = IPHONE_HEIGHT -inputViewRect.size.height;
    }
    else
    {
//        accessoryY = 264; //480 - 216;
        accessoryY = IPHONE_HEIGHT-226;
    }
    
    
    CGRect textFieldRect = textField.frame;
    textFieldY = textFieldRect.origin.y + textFieldRect.size.height+20;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int offsetY = textFieldY - accessoryY;
    if (!leave && offsetY > 0)
    {
        int y_offset = -5;
        
        y_offset += -offsetY;
        
//        CGRect viewFrame = CGRectMake(0, 0, 320, 480);
        CGRect viewFrame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
        viewFrame.origin.y += y_offset;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [appdelegate.window setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else
    {
//        CGRect viewFrame = CGRectMake(0, 0, 320, 480);
        CGRect viewFrame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [appdelegate.window setFrame:viewFrame];
        [UIView commitAnimations];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveView:textField leaveView:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self moveView:textField leaveView:YES];
}
- (IBAction)skipAction:(id)sender {
    
    _gpsView.hidden = YES;
}

#pragma mark ---------- 关注右上角
- (IBAction)showFavoriteBrand:(id)sender {
    
    if (![Util isLogin]) {
        UIAlertView *custom=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录,请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",@"注册",nil];
        [custom show];
        [custom release];
        return;
    }

    
    FavoriteViewController *brandVC = [[[FavoriteViewController alloc ]initWithNibName:@"FavoriteViewController" bundle:nil] autorelease];
    
    UINavigationController   *nv = [[[UINavigationController alloc ]initWithRootViewController:brandVC] autorelease];
    nv.navigationBarHidden= YES;
    
    [self presentModalViewController:nv animated:YES];
    
}

#pragma mark
#pragma mark  添加首页右上角选项底图
- (void)addSelectImageView{

    selectImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(200, 45, 100, 70)];
    selectImageView.backgroundColor = [UIColor redColor];
    selectImageView.userInteractionEnabled = YES;
    UIButton *scanningButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scanningButton.frame = CGRectMake(0, 0, 100, 35);
    [scanningButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    scanningButton.tag = 802000;
    [scanningButton addTarget:self action:@selector(goToScanningOrFavorBrandAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectImageView addSubview:scanningButton];
    
    UIButton *favorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    favorButton.frame = CGRectMake(0, 35, 100, 35);
    favorButton.tag = 802020;
    favorButton.backgroundColor = [UIColor redColor];
    [favorButton setTitle:@"关注品牌" forState:UIControlStateNormal];
    [favorButton addTarget:self action:@selector(goToScanningOrFavorBrandAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectImageView addSubview:favorButton];
    
    selectImageView.hidden = YES;
    [self.view addSubview:selectImageView];
   
}

#pragma mark
#pragma mark  *****购物车和专柜取货*******
-(void)requestData:(int)pageNumber requestType:(int)type//请求数据库获取专柜购物车及专柜取货中的数据
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    NSString *urlString=nil;
    if (type==100) {
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,QH_LIST];
        [jsonreq setValue:@"3" forKey:@"orderType"];
    }else{
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
    
    _requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [_requestForm setTimeOutSeconds:10];
    _requestForm.tag=type;
    [_requestForm setDidFinishSelector:@selector(getListCountFinish:)];
    [_requestForm setDidFailSelector:@selector(getListCountFailed:)];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [_requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [_requestForm startAsynchronous];
    [_requestForm setDelegate:self];
}
-(void)getListCountFinish:(ASIFormDataRequest *)request{
    [request clearDelegatesAndCancel];
    _requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (_requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:_requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return;
        }
        if (error) {
            return;
        }
    }else{
        NSString *jsonString = [_requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }
    
    NSMutableArray *products = nil;
    if (_requestForm.tag ==100) {
        
        products = [dic objectForKey:@"shoppePickup"];
        [Util SaveShoppeArray:products];
        [self showListCount:_requestForm.tag :products.count];
        [self requestData:1 requestType:101];
    }else {
        
        products = [dic objectForKey:@"cartList"];
        
        [Util saveCartListCount:[NSString stringWithFormat:@"%d",products.count]];
        [Util saveCartProducts:products];
        [self showListCount:_requestForm.tag :products.count];
    }
    
}
-(void)getListCountFailed:(ASIHTTPRequest *)request{
    int cartCount=[[Util takeCartListCount] intValue];
    int qhCount=[Util getShoppeArray].count;
    [self showListCount:101 :cartCount];
    [self showListCount:100 :qhCount];
    
}
#pragma mark – 显示购物车和专柜取货中的商品数量
-(void)showListCount:(int)type :(int)count{ //
    
    LKCustomTabBar *customTabbar=[LKCustomTabBar shareTabBar];
    
    if (type==100) {
        UILabel *countLable1=(UILabel*)[customTabbar.slideQH viewWithTag:1988];
        countLable1.text=[NSString stringWithFormat:@"%d",count];
        
        if ([countLable1.text intValue]!=0) {
            customTabbar.slideQH.hidden=NO;
        }else{
            customTabbar.slideQH.hidden=YES;
        }
    }else {
        UILabel *countLable=(UILabel*)[customTabbar.slideBg viewWithTag:1986];
        countLable.text=[NSString stringWithFormat:@"%d",count];
        
        if ([countLable.text intValue]!=0) {
            customTabbar.slideBg.hidden=NO;
        }else{
            customTabbar.slideBg.hidden=YES;
        }
    }
}

@end
