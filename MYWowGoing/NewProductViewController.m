//
//  NewProductViewController.m
//  MYWowGoing
//  新品折扣
//  Created by 杨景超 on 13-4-13.
//  Copyright (c) 2013年 西安沃购网络科技有限公司. All rights reserved.
//

#import "NewProductViewController.h"
#import "CoordinateReverseGeocoder.h"
#import "ASIFormDataRequest.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "ProductDetailViewController.h"
#import "brandDetailViewController.h"

#import "Util.h"
#import "LoginViewController.h"
#import "RegisterView.h"
#import "AppDelegate.h"
#import "LKCustomTabBar.h"
#import "StrikeThroughLabel.h"
#import "SelectSizeViewController.h"
#import "BaseController.h"
#import "Prodect.h"
#import "Util.h"
#import "Api.h"
#import "CustomAlertView.h"
#import "NetworkUtil.h"
#import "FileUtil.h"
#import "CountersignToBuy.h"
#import "CartViewController.h"
#import "MobClick.h"
#import "GuidanceVC.h"
#import "WowgoingAccount.h"
#import "FnalStatementVC.h"
#import "PayByWgoingVC.h"
#import "Request.h"
#import "Single.h"




#define REQUEST_PAGE_ONE    1
#define REQUEST_PAGE_NEXT   2
@interface NewProductViewController ()

@end
static ProductViewController *shareProduct;
@implementation NewProductViewController
@synthesize Srollview_NewProduct;
+(ProductViewController *)shareProduct
{
    return shareProduct;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark
#pragma mark - 新品折扣数据请求
-(void)dataSorcePage:(NSString *)userName
            PassWord:(NSString *)password
          PageNumber:(NSString *)pagenNumber
            cityName:(NSString *)cityname
          productURL:(NSString *)productUrl
{
    
    NSMutableDictionary *common = [[NSMutableDictionary alloc] init];
    [common setValue:userName forKey:@"loginId"];
    [common setValue:password forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [[NSMutableDictionary alloc] init];
    [jsonreq setValue:common forKey:@"common"];
    
    [jsonreq setValue:cityname forKey:@"CityName"];
    [jsonreq setValue:pagenNumber forKey:@"pageNumber"];
    
    
    NSString  *sbreq = [[SBJsonWriter alloc] stringWithObject:jsonreq];
    
    NSString *urlString = productUrl;
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    requestForm.tag = ([pagenNumber intValue] == 1) ? REQUEST_PAGE_ONE : REQUEST_PAGE_NEXT;
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    [common release];
    [jsonreq release];
    
}

#pragma mark
#pragma mark   定位服务
- (void)viewDidLoad
{
    _isload = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadGPSDataNotification:)
                                                 name:@"loadgps"
                                               object:nil];
    
    BOOL netWork = [NetworkUtil canConnect];
    if (netWork) {
        
    [self dataSorcePage:@"123@abc.com"
               PassWord:@"111111"
             PageNumber:[NSString stringWithFormat:@"%d",1]
               cityName:@"西安市"
             productURL:[NSString stringWithFormat:@"%@/api/brandList",SEVERURL]];
        
    } else {
        //开始加载缓存
        [self cacheData];
    }
    self.Srollview_NewProduct.showsVerticalScrollIndicator = YES;
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

//缓存图片
- (void)cacheData {
    NSString *filePath;
    
    filePath = [FileUtil dataFilePath:kFilenameXian];
    
    if ([FileUtil fileIsExist:filePath]) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        //        [self starLoadingData:array isaddBool:NO];加载数据
    }
}

//写界面
-(void)reloadData:(NSString*)jsonString Add:(BOOL)isAdd
{
    NSMutableDictionary *dic = [[SBJsonParser alloc] objectWithString:jsonString];
    NSMutableArray *products = [dic objectForKey:@"products"];
    NSLog(@"首页数据：%@", products);
    if ( products.count == 0 || products == nil || ![products isKindOfClass:[NSMutableArray class]]) {
        _num ++;
        if (_num <3) {
            [self fristLoad];
        } else {
            _num = 0;
            [self showToastMessageAtCenter:@"数据加载失败"];
        }
        
    }
    [self.productArray writeToFile:[FileUtil dataFilePath:kFilenameXian] atomically:YES];
    
    //新品折扣的布局
    int count_rows=[products count];
    
    for (int i=0; i<count_rows; i++) {
        rows = i%2;
        cols = i/2;
        int stockid = [[[products objectAtIndex:i] objectForKey:@"stock"] intValue];
        //wkf：计算每个row的高度
        UIScrollView *row = [[UIScrollView alloc] initWithFrame:CGRectMake(rows*150+0,
                                                                           ((isAdd == YES) ? Srollview_NewProduct.contentSize.height+cols*100:(0+110*cols) ),
                                                                           150,
                                                                           100)];
        row.tag=i+100;
        row.backgroundColor = [UIColor clearColor];
        row.pagingEnabled = YES;
        //            row.contentSize = CGSizeMake(300, 300);
        row.contentSize = CGSizeMake(150, 100);
        row.showsVerticalScrollIndicator = YES;
        row.showsHorizontalScrollIndicator = YES;
        row.delegate=self;
        
        //书架row背景
        //            UIImageView *v = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)] autorelease];
        UIImageView *v = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 140, 100)] autorelease];
        v.image=[UIImage imageNamed:@"底图.png"];
        //            v.backgroundColor = [UIColor clearColor];
        [row addSubview:v];
        [Srollview_NewProduct addSubview:row];
        
        NSMutableDictionary *object = [products objectAtIndex:i];
        NSString   *images = [object objectForKey:@"picUrl"];
        int   activityId = [[object objectForKey:@"activityId"] intValue];
        
        //点击品牌跳转
        //            UIDataButton *btn = [[UIDataButton alloc] initWithFrame:CGRectMake(15, 0, 285, 247)];
        UIDataButton *btn = [[UIDataButton alloc] initWithFrame:CGRectMake(12, 2, 70,96)];
        
        btn.tag = activityId;
        btn.titleLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"productId"]];
        btn.data = object;
        [btn addTarget:self action:@selector(activegoBookDetailsController:) forControlEvents:UIControlEventTouchUpInside];
        [row addSubview:btn];
        [btn release];
        
        //logo图片
        img_logo =[[UIImageView alloc]initWithFrame:CGRectMake(85, 3, 100, 20)];
        [self.img_logo setImageWithURL:[NSURL URLWithString:[object objectForKey:@"brandLogo"]]];
        [row addSubview:img_logo];
        
        
    }
    if (isAdd == NO) {
        self.Srollview_NewProduct.contentSize = CGSizeMake(rows *150,10+135 *cols);
        
    }
    else{
        self.Srollview_NewProduct.contentSize = CGSizeMake(150,self.Srollview_NewProduct.contentSize.height+ 110 * count_rows);
    }
    
//    CGRect  _newFrame =  CGRectMake(0.0f, defaultMagazineView.contentSize.height+10,
//                                    self.view.frame.size.width,  defaultMagazineView.bounds.size.height);
//    [self createHeaderView];
//    [self createFooterView];
//    _refreshFooterView.frame = _newFrame;
}
-(void)fristLoad
{
    [self dataSorcePage:@"123@abc.com"
               PassWord:@"111111"
             PageNumber:[NSString stringWithFormat:@"%d",1]
               cityName:@"西安市"
             productURL:[NSString stringWithFormat:@"%@/api/brandList",SEVERURL]];
    
    [self showHUDLoading];
    //    [self valueChanged:0];
    nowPageNum = 1;
    self.Srollview_NewProduct.showsVerticalScrollIndicator = YES;
    self.Srollview_NewProduct.showsHorizontalScrollIndicator = NO;
    
    _reloading = NO;
}
- (void)showHUDLoading {
    [self showLoadingView];
}
#pragma mark
#pragma mark GPS定位
- (void)loadGPSDataNotification:(NSNotification *)noteification {
    isGPSFailed = NO;
    isGPSOk = NO;
    
    [self loadGPSData];
    
}
- (void)loadGPSData {
    [CoordinateReverseGeocoder getCurrentCity];
    isGPSFailed = NO;
    isGPSOk = NO;
    cityName = @"当前位置";
    if (checkGPSTimer != nil) {
        checkGPSTimer = nil;
        [checkGPSTimer invalidate];
    }
    //去掉定位功能
    checkGPSTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(checkGPS)
                                                   userInfo:nil
                                                    repeats:YES];
    
    HUD=[[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText=@"GPS定位中...";
    [HUD show:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
