//
//  FirstViewController.m
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductViewController.h"
#import "CoordinateReverseGeocoder.h"
 
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

#import "ProductDetailViewController_Detail2.h"

 
#import "AppDelegate.h"
#import "LKCustomTabBar.h"
#import "StrikeThroughLabel.h"

#import "BaseController.h"
#import "Prodect.h"

#import "CustomAlertView.h"
#import "NetworkUtil.h"
#import "FileUtil.h"

#import "CartViewController.h"
#import "MobClick.h"

#import "Request.h"
#import "Single.h"
#import "GetServerCityBS.h"
#import "AdvertisingVC.h"
#import "XianShiCell.h"
#import "NewProductCell.h"
#import "ProductCell.h"
#import "SearchRequestBS.h"
#import "AdproductListVC.h"
#import "ADVDETAILBS.h"

#import "AdproductListVC.h"
#import "SDNestTableVC.h"
#import "AsyncImageView.h"
#define REQUEST_PAGE_ONE    1
#define REQUEST_PAGE_NEXT   2
#define TAGNUM 9924
#define QIANG
#define PRICE_FOUNT 12 //原价
#define DISCOUNTPRICE_FOUNT 17 //价格
#define DISCOUNT 10  //8.5折
#define PRODUCTNAME_FOUNT 13 // 产品名
#define kDuration 0.7   // 动画持续时间(秒)
@interface ProductViewController ()
{
    UIImageView *titbackImageview;
}
@property (nonatomic, strong) NSMutableArray *dicArray;
@property (nonatomic, assign) BOOL isload;
@property (assign) int sequenceNum; //标记点击的是那个分类排序
@property (assign) int gender;
@property (assign) BOOL sequenceBOOL; //判断是否点击排序功能
@property (assign) int num;
@property (assign) int lineNum; //显示了几个cell 顶部的
@property(nonatomic,retain)NSMutableDictionary * shaiXuanDic; //关于筛选的字典
@property(nonatomic,retain) NSDictionary *tempDic; //广告内容字典
@property(nonatomic,assign) BOOL _isShaiXuan;
@property (nonatomic,retain) UIView  *topCountView;  // 顶部显示商品数量
@property (nonatomic,retain) UILabel *titleLable;
@property (assign,nonatomic) int  totalCount;    //商品总数
@property (retain, nonatomic) IBOutlet UIView *refreshView;

@end

static ProductViewController *shareProduct=nil;

@implementation ProductViewController

@synthesize shaiXuanDic;

@synthesize tableview_myTableView=_tableview_myTableView;

- (void)dealloc {
    [_titleLable release];
    [_topCountView release];
    [_tableview_myTableView release];
    [_dicArray release];
    [titbackImageview release];
    [_qianggouBtn release];
    [_zhekouBtn release];
    [_tempDic release];
    [shaiXuanDic release];
    [_AllProducts release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    for (requestForm in [ASIFormDataRequest sharedQueue].operations) {
        [requestForm clearDelegatesAndCancel];
    }//取消所有还在进行的网络请求
    [_refreshView release];
    [super dealloc];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(10, 6, 52, 32)];;
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(260, 6, 60, 34)];;
        [shareButton addTarget:self action:@selector(toFilter:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"筛选.png"] forState:UIControlStateNormal];
        
        
        self.titleLable = [[[UILabel alloc ] initWithFrame:CGRectMake(110, 0, 100, 44)] autorelease];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.text = @"筛选结果";
        self.titleLable.font = [UIFont boldSystemFontOfSize:20.0f];
        self.titleLable.textColor = [UIColor whiteColor];
        self.titleLable.textAlignment = UITextAlignmentCenter;
        
        titbackImageview = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, 320, 44)];
        titbackImageview.userInteractionEnabled = YES;
        titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
        [titbackImageview addSubview:backButton];
        [titbackImageview addSubview:shareButton];
        [titbackImageview addSubview:self.titleLable];
       
        
        _isXianShi = [Single shareSingle].isXianShi;
        if (_isXianShi) {//限时抢购
            [MobClick event:@"xianshi"];
            [MobClick beginEvent:@"xianshi"];//限时抢购事件统计ID
            
            self.titleLable.text = @"限时抢购";

        }else{//新品折扣
            [MobClick event:@"xinpin"];//新品折扣事件统计ID
            self.titleLable.text = @"新品折扣";
        }
        
    }
    return self;

}

- (IBAction)refreshAction:(id)sender {
    if (_isXianShi) {
        [self valueChanged:0];
    } else {
        [self valueChanged:1];
    }
    nowPageNum = 1;
}

- (void)backAction:(UIButton*)sender {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [titbackImageview removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"adView" object:nil];
    
}


#pragma mark 新品折扣-全部商品
-(void)toAllNewProduct{
   
     AdproductListVC *adpvc =[[[AdproductListVC alloc]initWithNibName:@"AdproductListVC" bundle:nil] autorelease];

    [self.navigationController pushViewController:adpvc animated:YES];
  
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{ 
    [super viewDidLoad];
    
    //********  zhangMeng     主要用于去除出现在详情界面的系统返回按钮
    UIBarButtonItem *nItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem=nItem;
    [nItem release];
    self.navigationItem.hidesBackButton=YES;
    //**********zhangMeng
    
    self.AllProducts=[NSMutableArray array];
    

    self.tableview_myTableView.scrollEnabled = YES;
    self.tableview_myTableView.separatorStyle = NO;
    self.tableview_myTableView.backgroundColor = [UIColor clearColor];
    self.tableview_myTableView.tag=1871734;
    
    [self drawTopCountView];   //列表顶部产品数量
           
    [_qianggouBtn setSelected: YES];
    _isload = YES;
    _sequenceBOOL = YES;
    _sequenceNum = 0;
    
        //取点击的是限时抢购还是新品折扣  限时抢购为 yes   新品折扣为 no
        
         _isXianShi = [Single shareSingle].isXianShi;
        [self addLeftSwipeGesture];
        
        BOOL netWork = [NetworkUtil canConnect];
        if (netWork) {//有网络显示headerview
            [self createHeaderView];
        }else{
            //开始加载缓存
            [self cacheData];
            return;
        }
        
            
    self.cityName =[Util getBrowerCity];//取到城市名保存给cityName

    [self fristLoad];//第一次加载视图

    
    [MobClick beginLogPageView:@"首页"];
    
    //移除旧通知,注册新通知(关于筛选)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shaixuanProduct" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaixuanAcation:) name:@"shaixuanProduct" object:nil];
    
}


- (void) drawTopCountView{

    self.topCountView = [[[UIView alloc ]initWithFrame:CGRectMake(130, self.view_title.frame.origin.y + self.view_title.frame.size.height + 5, 60, 28)] autorelease];
    UIImageView *topCountViewImage = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, 60, 28)];
    topCountViewImage.image = [UIImage imageNamed:@"列表显示数量底图.png"];
    [self.topCountView addSubview:topCountViewImage];
    [topCountViewImage release];
    
    UILabel *countLable = [[UILabel alloc ]initWithFrame:CGRectMake(-5, -2, 70, 28)];
    countLable.textAlignment = UITextAlignmentCenter;
    countLable.textColor = [UIColor whiteColor];
    countLable.font = [UIFont systemFontOfSize:12.0f];
    countLable.backgroundColor = [UIColor clearColor];
    countLable.tag = 999;
    
    [self.topCountView addSubview:countLable];
    [countLable release];
    
    [self.view addSubview:self.topCountView];
    [self.view bringSubviewToFront:self.topCountView];
    
    self.topCountView.hidden = YES;

}

- (void) showProducrsCountOnTopCountView:(int)currentCount :(int)totalCount {
      UILabel *lable =(UILabel*) [self.topCountView viewWithTag:999];
      lable.text = [NSString stringWithFormat:@"%d/%d",currentCount,totalCount];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [MobClick endLogPageView:@"首页"];
}


#pragma mark ---------- 筛选界面
- (void)toFilter:(id)sender{
    
    UIButton *filterBut=(UIButton*)sender;
    filterBut.selected=!filterBut.selected;
    
    if (filterBut.selected) {
        [self addScreenInteface];
    }else{
        [self removeScreenInteface];
    }
}
#pragma mark ---------- 左滑显示筛选菜单

/****************************
 方法名称:addLeftSwipeGesture
 功能描述:添加向左滑动手势
 输入参数:N/A
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)addLeftSwipeGesture{
    
    UISwipeGestureRecognizer  *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeAction:)];
    [self.tableview_myTableView addGestureRecognizer:swipe];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [swipe release];
    
}
- (void)leftSwipeAction:(UISwipeGestureRecognizer*)sender{
    
    [self addScreenInteface];  //改变window的frame，创建并显示筛选界面
    [self addRightSwipeGesture];
     _btn_rightItem.selected=!_btn_rightItem.selected;
    
}

/****************************
 方法名称:addRightSwipeGesture
 功能描述:添加向右滑动手势
 输入参数:N/A
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)addRightSwipeGesture{
    
    UISwipeGestureRecognizer  *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeAction:)];
    [self.tableview_myTableView addGestureRecognizer:swipe];
    swipe.direction=UISwipeGestureRecognizerDirectionRight;
    [swipe release];
    
    
}
/****************************
 方法名称:rightSwipeAction:(UISwipeGestureRecognizer*)sender
 功能描述:向右滑动手势触动的方法,跳出筛选界面，恢复到原来的界面
 输入参数:(UISwipeGestureRecognizer*)sender 向右滑动手势
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)rightSwipeAction:(UISwipeGestureRecognizer*)sender{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view=[delegate.window viewWithTag:88888];
    
    self.tableview_myTableView.userInteractionEnabled=YES;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{//UIVIEW动画块
        
        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
    } completion:^(BOOL finished) {//动画完成后调用的方法
        [view.superview removeFromSuperview];
        [self.tableview_myTableView removeGestureRecognizer:sender];
    }];
}
/****************************
 方法名称:addTapGesture
 功能描述:添加单击手势
 输入参数:N/A
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)addTapGesture{
    
    //在当前页（首页）添加单击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlMaove:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    [tap release];
    
}

//添加屏幕手势-改变windows的位置
-(void)addScreenInteface{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //筛选界面SDNestTableVC
    SDNestTableVC *sdntTable=[[[SDNestTableVC alloc]init] autorelease];
    
    [Single shareSingle].isLeiBie = NO;
   
    if (_isXianShi) {   //限时抢购2 新品折扣1
        sdntTable.productType=[NSString stringWithFormat:@"2"];
        sdntTable.typeScreen =  5;
    }else{
        sdntTable.productType=[NSString stringWithFormat:@"1"];
        sdntTable.typeScreen =  4;
    }

    UIView *view=[[[UIView alloc]initWithFrame:CGRectMake(320,20, 320, IPHONE_HEIGHT)] autorelease];
    view.tag=88888;
    [view addSubview:sdntTable.tableView];
    [delegate.window addSubview:view];
    
    [UIView animateWithDuration:0.5 animations:^{
        delegate.window.frame = CGRectMake(-253,delegate.window.frame.origin.y, 640, IPHONE_HEIGHT);
    }];
    
    //设置列表不能点击
    self.tableview_myTableView.userInteractionEnabled=NO;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=NO;
    
    [self addTapGesture];
}
//改变windows的位置
-(void)removeScreenInteface{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view=[delegate.window viewWithTag:88888];
    
    self.tableview_myTableView.userInteractionEnabled=YES;
     [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
    } completion:^(BOOL finished) {
        [view.superview removeFromSuperview];
        for (UITapGestureRecognizer *tap in [self.view gestureRecognizers]) {
            [self.view removeGestureRecognizer:tap];
        }
    }];
}
//手势移动屏幕windows位置
-(void)handlMaove:(UITapGestureRecognizer*)sender{
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     UIView *view=[delegate.window viewWithTag:88888];
    
    self.tableview_myTableView.userInteractionEnabled=YES;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
        _btn_rightItem.selected=!_btn_rightItem.selected;

    } completion:^(BOOL finished) {
        [view.superview removeFromSuperview];
        [self.view removeGestureRecognizer:sender];
    }];

}

+(ProductViewController *)shareProduct
{
    return shareProduct;
}

#pragma mark
#pragma mark - 限时抢购数据请求
-(void)dataSorcePage:(NSString *)userName
            PassWord:(NSString *)password
          pageNumber:(NSNumber*)pageNmber
              Gender:(NSString *)gender
            cityName:(NSString *)cityname
          productURL:(NSString *)productUrl
         productType:(NSString *)productType
               order:(NSString *)orderType
{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:userName forKey:@"loginId"];
    [common setValue:password forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    
    [jsonreq setValue:self.cityName forKey:@"CityName"];
    [jsonreq setValue:pageNmber forKey:@"pageNumber"];
    [jsonreq setValue:orderType forKey:@"orderType"];
    [jsonreq setValue:productType forKey:@"productType"];
    [jsonreq setValue:gender forKey:@"gender"];
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

    
    NSString *urlString = productUrl;
    requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    requestForm.tag = ([pageNmber intValue] == 1) ? REQUEST_PAGE_ONE : REQUEST_PAGE_NEXT;
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
}

#pragma mark
#pragma mark - 店铺入口数据请求(即全部商品数据请求)
-(void)dataSorceBrandAllPage:(NSString *)userName
                    password:(NSString *)password
                  pageNumber:(NSNumber *)pageNumber
                    cityName:(NSString *)cityName
                 productType:(NSString *)productType
                  productUrl:(NSString *)productURL
                   orderType:(NSString *)ordertype
                      
{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:userName forKey:@"loginId"];
    [common setValue:password forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:ordertype forKey:@"orderType"];
    [jsonreq setValue:self.cityName forKey:@"cityName"];
    [jsonreq setValue:pageNumber forKey:@"pageNumber"];
    [jsonreq setValue:productType forKey:@"productType"];
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

    
    NSString *urlS = productURL;
    requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlS]];
    requestForm.tag = ([pageNumber intValue] == 1) ? REQUEST_PAGE_ONE : REQUEST_PAGE_NEXT;
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm startAsynchronous];
    
}

//AsihttpRequest代理方法-请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD  hideHUDForView:self.navigationController.view  animated:YES];
    [request clearDelegatesAndCancel];
    _num ++;
    if (_num <1) {
        [self fristLoad];
    } else {
        _num = 0;
          [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        CGRect rx = [ UIScreen mainScreen ].bounds;
        if(self.AllProducts.count/2 > rx.size.height/97){ //取到的数据有一屏
            if (self.tableview_myTableView.contentOffset.y < 0 ) {
                [self.tableview_myTableView setContentOffset:CGPointMake(0, 46) animated:YES];
                self.tableview_myTableView.bouncesZoom = NO;
            }else{
                [_refreshFooterView setHidden:YES];
                [self.tableview_myTableView setContentOffset:CGPointMake(0, self.tableview_myTableView.contentOffset.y) animated:YES];
                self.tableview_myTableView.bouncesZoom = NO;
            }
        }
        return;
    }
}

//AsihttpRequest代理方法-请求成功
- (void)requestFinished:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
    [request clearDelegatesAndCancel];
    requestForm = (ASIFormDataRequest*)request;
    NSString *jsonString = [requestForm responseString];
    NSMutableDictionary *dic=nil;
    
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        return;
    }
    if (error) {
        return;
    }

    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {

        if (request.tag == REQUEST_PAGE_ONE) {
            
            if (self._isShaiXuan) {
                
                [self.AllProducts removeAllObjects];
                [self.tableview_myTableView reloadData];
                [self showProducrsCountOnTopCountView:0 :0];
                [self.view makeToast:@"没有搜索到你查询的产品\n换个条件筛选条件试试吧..." duration:0.5 position:@"center" title:nil];
            }else{
                [self.tableview_myTableView reloadData];
                self.topCountView.hidden = YES;
                [self.view makeToast:@"没有查询到相关产品" duration:0.5 position:@"center" title:nil];
            }
        }
        
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
      NSMutableArray *products = [dic objectForKey:@"products"];
      NSMutableArray *array = [NSMutableArray arrayWithArray:[dic objectForKey:@"products"]];
    
    self.totalCount = [[dic objectForKey:@"count"]  intValue];
    
    if (responseStatus!=200) {
        [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
        [self reloadData:jsonString Add:NO];
        [self.tableview_myTableView setContentOffset:CGPointMake(0, self.tableview_myTableView.contentOffset.y) animated:YES];
        self.tableview_myTableView.bouncesZoom = NO;
        [_refreshFooterView setHidden:YES];
        return;
    }
   
    CGRect rx = [ UIScreen mainScreen ].bounds;
    int rowCount =0;
    rowCount = rx.size.height/97;
    
    if (dic == NULL || products == NULL|| [products count]==0 ) {//返回为空
        
        [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
        
        if (self._isShaiXuan) {
            if (request.tag == REQUEST_PAGE_ONE) {
                [self.AllProducts removeAllObjects];
                [self.view makeToast:@"没有搜索到你查询的产品\n换个条件筛选条件试试吧..." duration:0.5 position:@"center" title:nil];

            }else{
                 [self.view makeToast:@"没有更多数据了" duration:0.5 position:@"center" title:nil];
            }
            
        }else{
             [self.view makeToast:@"没有更多数据了" duration:0.5 position:@"center" title:nil];
        }
        
        [self.tableview_myTableView reloadData];
        _reloading = NO;
        
        if(self.AllProducts.count/2 > rowCount){//数据大于一屏
            if (self.tableview_myTableView.contentOffset.y == self.tableview_myTableView.contentOffset.y) {
                [_refreshFooterView setHidden:YES];
            }else{
                [self.tableview_myTableView setContentOffset:CGPointMake(0, self.tableview_myTableView.contentOffset.y) animated:YES];
                self.tableview_myTableView.bouncesZoom = NO;
            }
        }
        return;
    }
    
    //判断下拉还是上滑
    if (request.tag == REQUEST_PAGE_ONE) {
        //如果下拉，清除数据
        [self.AllProducts removeAllObjects];
        self.AllProducts = array;
        [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
        [self reloadData:jsonString Add:NO];
        isNOData = YES;
        self.refreshView.hidden = YES;
        self.topCountView.hidden = YES;
        [self showProducrsCountOnTopCountView:array.count :self.totalCount];
    }
    else{

        nowPageNum++;
        [self reloadData:jsonString Add:YES];
        [self.AllProducts addObjectsFromArray:array];
        _reloading = NO;
        isNOData = YES;
        self.topCountView.hidden = NO;
        [self showProducrsCountOnTopCountView:self.AllProducts.count :self.totalCount];
        
        if (self.AllProducts.count == 0 ||self.AllProducts == nil) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
            
            if(self.AllProducts.count/2 > rowCount){
                [self.tableview_myTableView setContentOffset:CGPointMake(0, self.tableview_myTableView.contentOffset.y) animated:YES];
                self.tableview_myTableView.bouncesZoom = NO;
            }
            return;
        }
    }
    [self reloadData:jsonString Add:NO];
    [self.tableview_myTableView reloadData];
    
    self.topCountView.hidden = NO;
    self.view_title.hidden = NO;
    self.refreshView.hidden = YES;
    
    self.tableview_myTableView.contentSize  = CGSizeMake(0.0f, self.tableview_myTableView.contentSize.height+30.0f);
    CGRect  _newFrame = CGRectMake(0.0f, self.tableview_myTableView.contentSize.height-40.0f,self.view.frame.size.width,self.tableview_myTableView.bounds.size.height);
    
    if(self.AllProducts.count/2 >rowCount){
        [self createFooterView];
    }
    if (array.count < 10) {
        
        [self.tableview_myTableView setContentOffset:CGPointMake(0, self.tableview_myTableView.contentOffset.y) animated:YES];
        self.tableview_myTableView.bouncesZoom = NO;
        [_refreshFooterView setHidden:YES];
    }
    
    [self createHeaderView];
    _refreshFooterView.frame = _newFrame;
    [self loadOk];
    [self.view_title setHidden:NO];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchBetin");
}

#pragma mark
#pragma mark -开始绘制界面
-(void)reloadData:(NSString*)jsonString Add:(BOOL)isAdd
{
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
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    NSMutableArray *tempArray=nil;
    
    if (_isXianShi) {
        tempArray = [dic objectForKey:@"products"];
        [tempArray  writeToFile:[FileUtil dataFilePath:kFilenameXian] atomically:YES];
        
        if ( self.AllProducts.count == 0  || self.AllProducts == nil  || ![self.AllProducts isKindOfClass:[NSMutableArray class]] ) {
            _num ++;
            if (_num <1) {
                [self fristLoad];
            } else {
                _num = 0;
                [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
                self.refreshView.hidden = NO;
                self.view_title.hidden = YES;
                self.topCountView.hidden = NO;
                return;
            }
            
        }
        
        if (dic == NULL || self.AllProducts == NULL || [self.AllProducts count]==0 ) {
            
            return;
        }
    }else{
        tempArray  = [dic objectForKey:@"products"];
        [tempArray  writeToFile:[FileUtil dataFilePath:kFileNamePing] atomically:YES];
        
        if ( self.AllProducts.count == 0  || self.AllProducts == nil  || ![self.AllProducts isKindOfClass:[NSMutableArray class]] ) {
            _num ++;
            if (_num <1) {
                [self fristLoad];
            } else {
                _num = 0;
               [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
                
                self.view_title.hidden = YES;
                self.topCountView.hidden = YES;
                self.refreshView.hidden = NO;
                return;
            }
            
        }
        
        if (dic == NULL ||  self.AllProducts== NULL || [self.AllProducts count]==0 ) {
            
            return;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar addSubview:titbackImageview];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
//缓存数据
- (void)cacheData {
    NSString *filePath;
    if (_isXianShi) {
        filePath = [FileUtil dataFilePath:kFilenameXian];//限时抢购列表缓存
    } else {
        filePath = [FileUtil dataFilePath:kFileNamePing];//新品折扣列表（店铺入口）缓存
    }
    
    if ([FileUtil fileIsExist:filePath]) {
        
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        [self.AllProducts addObjectsFromArray:array];
        [array release];
        [self.tableview_myTableView reloadData];
    }
}


#pragma mark
#pragma mark  --------Tableview
//Section总数
//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%d",self.AllProducts.count);
    
    return [self.AllProducts count]/2 + [self.AllProducts count]%2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    NSLog(@"row==== %d %d %d",indexPath.row,self.AllProducts.count,self.totalCount);
//    [self showProducrsCountOnTopCountView:indexPath.row :self.totalCount];
    //一行两列数据排列方式
    NSMutableDictionary *object =nil;
    if((indexPath.row*2) <[self.AllProducts count]){
        object = [self.AllProducts objectAtIndex:indexPath.row*2];
    }
    
    NSMutableDictionary *object2 =nil;
    if ((indexPath.row*2+1) <[self.AllProducts count]) {
        object2 = [self.AllProducts objectAtIndex:indexPath.row*2+1];
    }
    
    //读取图片
    NSString   *images = [object objectForKey:@"picUrl"];
    NSString   *images2 = [object2 objectForKey:@"picUrl"];
    
    //读取活动id
    int activityId1 = [[object objectForKey:@"activityId"]  intValue];
    
    int activityId2 = [[object2 objectForKey:@"activityId"] intValue];
    
    static NSString *xianshiTableIdentifier = @"XianShiTableIdentifier";
    XianShiCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             xianshiTableIdentifier];
        if (cell == nil) {
            //如果没有可重用的单元，我们就从nib里面加载一个，
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XianShiCell"
                owner:self options:nil];
            //迭代nib重的所有对象来查找NewCell类的一个实例
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[XianShiCell class]]) {
                    cell = (XianShiCell *)oneObject;
                }
            }
        }
        if (object == nil) {//隐藏左列控件
            [cell.demoImageViewLeft setHidden:YES];
            [cell.productImageLeft setHidden:YES];
            [cell.brandLogoLeft setHidden:YES];
            [cell.btn_Left setHidden:YES];
            [cell.img_zhekouIconLeft setHidden:YES];
            [cell.productPriceLeft setHidden:YES];
            [cell.discountPriceLeft setHidden:YES];
            [cell.discountLeft setHidden:YES];
        }else{
            [cell.demoImageViewLeft setHidden:NO];
            [cell.productImageLeft setHidden:NO];
            [cell.brandLogoLeft setHidden:NO];
            [cell.btn_Left setHidden:NO];
            [cell.img_zhekouIconLeft setHidden:NO];
            [cell.productPriceLeft setHidden:NO];
            [cell.discountPriceLeft setHidden:NO];
            [cell.discountLeft setHidden:NO];
        }
        if (object2 == nil) {//隐藏右列控件
            [cell.demoImageView setHidden:YES];
            [cell.productImageRight setHidden:YES];
            [cell.img_zhekouIcon setHidden:YES];
            [cell.brandLogoRight setHidden:YES];
            [cell.productPriceRight setHidden:YES];
            [cell.btn_Right setHidden:YES];
            [cell.discountPriceRight setHidden:YES];
            [cell.discountRight setHidden:YES];
            @autoreleasepool {
                //现价
                cell.productPriceLeft.text = [NSString stringWithFormat:@"￥%d",[[object objectForKey:@"discountPrice"] intValue]];
            
                cell.productImageLeft.placeholderImage = [UIImage imageNamed:@"限时抢购logo水印"];
                [cell.productImageLeft performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString:images] waitUntilDone:NO];
                [cell.brandLogoLeft setImageWithURL:[NSURL URLWithString:[object objectForKey:@"brandLogo"]]];//品牌logo
                
                cell.productImageLeft.tag = BRAND_PRO;
                
                //原价
                cell.discountPriceLeft.text =[NSString stringWithFormat:@"￥%d",[[object objectForKey:@"price"] intValue]];
                cell.discountPriceLeft.backgroundColor = [UIColor clearColor];
                cell.discountPriceLeft.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
                cell.discountPriceLeft.font = [UIFont systemFontOfSize:PRICE_FOUNT];
                cell.discountPriceLeft.strikeThroughEnabled = YES;
                //折扣率
                cell.discountLeft.text = [NSString stringWithFormat:@"%.1f折",[[object objectForKey:@"discount"] floatValue]];
                
                cell.btn_Left.tag = activityId1;
                cell.btn_Left.data = object;
                [cell.btn_Left addTarget:self action:@selector(activegoBookDetailsController:) forControlEvents:UIControlEventTouchUpInside];

            }
             return cell;
        }else{
            [cell.demoImageView setHidden:NO];
            [cell.productImageRight setHidden:NO];
            [cell.img_zhekouIcon setHidden:NO];
            [cell.brandLogoRight setHidden:NO];
            [cell.productPriceRight setHidden:NO];
            [cell.btn_Right setHidden:NO];
            [cell.discountPriceRight setHidden:NO];
            [cell.discountRight setHidden:NO];
        
         @autoreleasepool {
             //现价-左label
           cell.productPriceLeft.text = [NSString stringWithFormat:@"￥%d",[[object objectForKey:@"discountPrice"]intValue]];
             
             [cell.productImageLeft performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString:images] waitUntilDone:NO];
             cell.productImageLeft.placeholderImage = [UIImage imageNamed:@"限时抢购logo水印"];
             cell.productImageRight.placeholderImage = [UIImage imageNamed:@"限时抢购logo水印"];
            [cell.productImageRight performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString:images2] waitUntilDone:NO];
             [cell.brandLogoLeft setImageWithURL:[NSURL URLWithString:[object objectForKey:@"brandLogo"]]];
        
        
             cell.productImageLeft.tag = BRAND_PRO;
        
             //原价-左label
             cell.discountPriceLeft.text =[NSString stringWithFormat:@"￥%d",[[object objectForKey:@"price"]intValue]];
             cell.discountPriceLeft.backgroundColor = [UIColor clearColor];
             cell.discountPriceLeft.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
             cell.discountPriceLeft.font = [UIFont systemFontOfSize:PRICE_FOUNT];
             cell.discountPriceLeft.strikeThroughEnabled = YES;
             cell.discountLeft.text = [NSString stringWithFormat:@"%.1f折",[[object objectForKey:@"discount"] floatValue]];
        
             cell.btn_Left.tag = activityId1;
             cell.btn_Left.data = object;
            [cell.btn_Left addTarget:self action:@selector(activegoBookDetailsController:) forControlEvents:UIControlEventTouchUpInside];
             //现价-右边label
             cell.productPriceRight.text = [NSString stringWithFormat:@"￥%d",[[object2 objectForKey:@"discountPrice"]intValue]];
            
             cell.productImageRight.tag = BRAND_PRO;
             [cell.brandLogoRight setImageWithURL:[NSURL URLWithString:[object2 objectForKey:@"brandLogo"]]];        
             //原价-右边label
              cell.discountPriceRight.text =[NSString stringWithFormat:@"￥%d",[[object2 objectForKey:@"price"]intValue]];
             cell.discountPriceRight.backgroundColor = [UIColor clearColor];
             cell.discountPriceRight.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
             cell.discountPriceRight.font = [UIFont systemFontOfSize:PRICE_FOUNT];
             cell.discountPriceRight.strikeThroughEnabled = YES;

             cell.discountRight.text = [NSString stringWithFormat:@"%.1f折",[[object2 objectForKey:@"discount"] floatValue]];
        
            cell.btn_Right.tag = activityId2;
            cell.btn_Right.data = object2;
             [cell.btn_Right addTarget:self action:@selector(activegoBookDetailsController:) forControlEvents:UIControlEventTouchUpInside];
         }
            return cell;
        }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[SDImageCache sharedImageCache] clearMemory];
//     [self showProducrsCountOnTopCountView:indexPath.row :self.totalCount];

}


//行缩进
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    return row;
}

//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 97;
}

//全部
- (IBAction)selectSegment:(id)sender {
    //清空所有的数据
    [self.dicArray removeAllObjects];
    [self.tableview_myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.tableview_myTableView.bouncesZoom = NO;
    [_qianggouBtn setSelected:YES];
    [_btn_Man setSelected:NO];
    [_btn_WoMan setSelected:NO];
    _gender = 3;
    BOOL netWork = [NetworkUtil canConnect];
    if (netWork) {
        [self valueChanged:0];
    } else {
        [self cacheData];
    }

}

//程序第一次加载判断限时抢购还是新品折扣
-(void)fristLoad
{
    if (_isXianShi) {
        [self valueChanged:0];
    } else {
        [self valueChanged:1];
    }
    nowPageNum = 1;
    _reloading = NO;
}

#pragma mark - EGORefreshTableHeader
//程序运行就走这里了
-(void)createHeaderView{
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
	[self.tableview_myTableView  addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - EGORefreshTableFooter
-(void)createFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
	_refreshFooterView =  [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableview_myTableView.contentSize.height-20.0f,self.view.frame.size.width, self.tableview_myTableView.bounds.size.height)];
    
    _refreshFooterView.delegate = self;
    
	[self.tableview_myTableView  addSubview:_refreshFooterView];
    
    [_refreshFooterView refreshLastUpdatedDate];
    
    CGRect  _newFrame =  CGRectMake(0.0f, self.tableview_myTableView.contentSize.height-20.0f, self.view.frame.size.width,  self.tableview_myTableView.bounds.size.height);
    
    _refreshFooterView.frame = _newFrame;
    
}

#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(UIView*)view
{
    NSString *urlString = nil;
    NSString  *productType = nil;
    if (_isXianShi) {
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,XIANSHI_LIST];
        productType = [NSString stringWithFormat:@"2"];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,XINPING_LIST];
        productType = [NSString stringWithFormat:@"1"];
        
    }
        //限时抢购
        if ([view isEqual:_refreshHeaderView]) {//顶部数据refresh
            
            nowPageNum =1;
            
            if (!self._isShaiXuan) {
                if ([Util isLogin]) {
                    [self dataSorcePage:[Util getLoginName]
                               PassWord:[Util getPassword]
                             pageNumber:[NSNumber numberWithInt:nowPageNum]
                                 Gender:[NSString stringWithFormat:@"%d",_gender]
                               cityName:self.cityName
                             productURL:urlString
                            productType:productType
                                  order:[NSString stringWithFormat:@"%d",_sequenceNum]];
                }else{
                    [self dataSorcePage:@"123@abc.com"
                               PassWord:@"111111"
                             pageNumber:[NSNumber numberWithInt:nowPageNum]
                                 Gender:[NSString stringWithFormat:@"%d",_gender]
                               cityName:self.cityName
                             productURL:urlString
                            productType:productType
                                  order:[NSString stringWithFormat:@"%d",_sequenceNum]];
                }
            }else{
            
                [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
                [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
                [self requestDataByBSwithDic:self.shaiXuanDic];
            }
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
        } else if([view isEqual:_refreshFooterView]) { //底部数据刷新
            if (!self._isShaiXuan) {
                
                if ([Util isLogin]) {
                    [self dataSorcePage:[Util getLoginName]
                               PassWord:[Util getPassword]
                             pageNumber:[NSNumber numberWithInt:nowPageNum+1]
                                 Gender:[NSString stringWithFormat:@"%d",_gender]
                               cityName:self.cityName
                             productURL:urlString
                            productType:productType
                                  order:[NSString stringWithFormat:@"%d",_sequenceNum]];
                }else{
                    [self dataSorcePage:@"123@abc.com"
                               PassWord:@"111111"
                             pageNumber:[NSNumber numberWithInt:nowPageNum+1]
                                 Gender:[NSString stringWithFormat:@"%d",_gender]
                               cityName:self.cityName
                             productURL:urlString
                            productType:productType
                                  order:[NSString stringWithFormat:@"%d",_sequenceNum]];
                }
                
            }else{
            
                [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_NEXT] forKey:@"tag"];
                [self.shaiXuanDic setValue:[NSNumber numberWithInt:nowPageNum+1] forKey:@"pageNumber"];
                [self requestDataByBSwithDic:self.shaiXuanDic];
            
            }
        
        }
}

-(void)loadOk
{
    _reloading = NO;
    isNOData = NO;
   
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableview_myTableView];

}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UIView*)view
{
    return _reloading;
    
}


#pragma mark - UIScrollView delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    oldContentOffsetY = scrollView.contentOffset.y;
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int currentPostion = scrollView.contentOffset.y;

    CGPoint contentOffsetPoint = self.tableview_myTableView.contentOffset;
    CGRect frame = self.tableview_myTableView.frame;
 
    
    if (contentOffsetPoint.y == self.tableview_myTableView.contentSize.height - frame.size.height)
    {
            if ([self.AllProducts count] !=0 && !isNOData) {
                [self egoRefreshTableHeaderDidTriggerRefresh:_refreshFooterView];
                isNOData = NO;
            }
    }

    if (currentPostion - oldContentOffsetY > 150) {
            [UIView animateWithDuration:0.2f animations:^{
                [self.view_title setFrame:CGRectMake(0, -45, self.view_title.width, self.view_title.height)];
                
                [self.topCountView setFrame:CGRectMake(self.topCountView.frame.origin.x, self.view_title.frame.origin.y + self.view_title.frame.size.height + 5, self.view_title.frame.size.width, self.view_title.frame.size.height)];
                self.topCountView.hidden = YES;
                
                self.tableview_myTableView.frame = CGRectMake(0, 0, self.tableview_myTableView.width, IPHONE_HEIGHT-44-49-15);

            } completion:^(BOOL finished) {
            }];
        }
        else if (oldContentOffsetY - currentPostion > 150)
        {
            [UIView animateWithDuration:0.2f animations:^{
                
                self.tableview_myTableView.frame = CGRectMake(0, 45, self.tableview_myTableView.width, IPHONE_HEIGHT-44-49-15);
                [self.view_title setFrame:CGRectMake(0, 0, self.view_title.width, self.view_title.height)];
                
                [self.topCountView setFrame:CGRectMake(self.topCountView.frame.origin.x, self.view_title.frame.origin.y + self.view_title.frame.size.height + 5, self.view_title.frame.size.width, self.view_title.frame.size.height)];
                self.topCountView.hidden = NO;
            } completion:^(BOOL finished) {
            }];
        }
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark - （0 限时抢购 1 新品折扣）
-(void)valueChanged:(int)num
{
    
    nowPageNum = 1;
    switch (num) {
        case 0://限时抢购
        {
            
            if (self._isShaiXuan) {//若进行过筛选页面的跳转，则接下来的操作 需要与筛选条件进行 约束
                
                [self.shaiXuanDic setValue:[NSString stringWithFormat:@"3"] forKey:@"gender"];
                [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
                [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
                
                [self requestDataByBSwithDic:self.shaiXuanDic];
            }else{
                if ([Util isLogin]) {
                    [self dataSorcePage:[Util getLoginName]
                               PassWord:[Util getPassword]
                             pageNumber:[NSNumber numberWithInt:nowPageNum]
                                 Gender:@"0"
                               cityName:[Util getBrowerCity]
                             productURL:[NSString stringWithFormat:@"%@/%@",SEVERURL,XIANSHI_LIST]
                            productType:@"2"
                                  order:[NSString stringWithFormat:@"%d",_sequenceNum]];
                }else{
                [self dataSorcePage:@"123@abc.com"
                           PassWord:@"111111"
                         pageNumber:[NSNumber numberWithInt:nowPageNum]
                             Gender:@"0"
                           cityName:[Util getBrowerCity]
                         productURL:[NSString stringWithFormat:@"%@/%@",SEVERURL,XIANSHI_LIST]
                        productType:@"2"
                              order:[NSString stringWithFormat:@"%d",_sequenceNum]];
                }
            }

            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        }
            break;
        case 1://新品折扣
        {
            if ([Util isLogin]) {
                [self dataSorceBrandAllPage:[Util getLoginName]
                                   password:[Util getPassword]
                                 pageNumber:[NSNumber numberWithInt:nowPageNum]
                                   cityName:self.cityName
                                productType:@"1"
                                 productUrl:[NSString stringWithFormat:@"%@/%@",SEVERURL,XINPING_LIST]
                                  orderType:[NSString stringWithFormat:@"%d",_sequenceNum]];
            }else{
            [self dataSorceBrandAllPage:@"123@abc.com"
                               password:@"888888"
                             pageNumber:[NSNumber numberWithInt:nowPageNum]
                               cityName:self.cityName
                            productType:@"1"
                             productUrl:[NSString stringWithFormat:@"%@/%@",SEVERURL,XINPING_LIST]
                              orderType:[NSString stringWithFormat:@"%d",_sequenceNum]];
            }
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark
#pragma mark ------查看产品详情
-(void)activegoBookDetailsController:(UIDataButton *)buttonBook{
    
    [titbackImageview removeFromSuperview];
    [self.navigationController.navigationBar removeAllSubviews];
    
    [MobClick beginEvent:@"xianshi"];
    int activityId = buttonBook.tag;
    NSString *proid = buttonBook.titleLabel.text;
    int productid = [proid intValue];
        ProductDetailViewController_Detail2 *productDetail = [[[ProductDetailViewController_Detail2 alloc] initWithNibName:@"ProductDetailViewController_Detail2" bundle:nil] autorelease];
    productDetail.prductDetailDic = buttonBook.data;
    productDetail.activityId = activityId;
    productDetail.productId = productid;
    
    //判断点击的是显示抢购还是名品折扣 YES为限时抢购
    if (_isXianShi) {
        productDetail.isShowTimeLabel = YES;
    } else  {
        productDetail.isShowTimeLabel = NO;
    }
    [titbackImageview removeFromSuperview];
    [self.navigationController pushViewController:productDetail animated:YES];
    
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)viewDidUnload
{

    [self setQianggouBtn:nil];
    [self setZhekouBtn:nil];
    [[SDImageCache sharedImageCache] clearMemory];
    [self setRefreshView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/**
 @点击时间显示条拉长和缩短
 @
 **/
- (void)timebuttonAction:(UIDataButton *)sender{
    // 获取点击button的数据 data数组一个数组
    UIDataButton *button = (UIDataButton *)sender;
    //格式化时间
    NSString *time = [self takeTimeDifference:[button.data objectForKey:@"endDate"]];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(9, 0, 236, 20)] autorelease];
    if(button.selected)
    {
        for (UILabel *label in [button subviews] ) {
            if ([label isKindOfClass:[UILabel class]]) {
                [label removeFromSuperview];
            }
        }
        [button setSelected:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"限时抢购时间标签"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(9, 9, 34, 33)];
        
    }else{
        [button setSelected:YES];
        label.backgroundColor = [UIColor blueColor];
        label.tag = 10000;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"活动将在%@后结束", time];
        [button addSubview:label];
        [button setBackgroundImage:[UIImage imageNamed:@"限时抢购标签长"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(9, 9, 236, 23)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}

//排序(1品牌排序 2价格从低到高3价格从高到低4折扣从高到底5折扣从低到高)
#pragma mark
#pragma mark ----------排序
- (void)loadSortDataSource  {

    //每次点击排序的条件的时候把参数设为初始位置
    nowPageNum = 1;
    [self.AllProducts removeAllObjects];
    NSString *urlString = nil;
    NSString  *productType = nil;
    if (_isXianShi) {
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,XIANSHI_LIST];
        productType = [NSString stringWithFormat:@"2"];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,XINPING_LIST];
        productType = [NSString stringWithFormat:@"1"];

    }

    if ([Util isLogin]) {
        [self dataSorcePage:[Util getLoginName]
                   PassWord:[Util getPassword]
                 pageNumber:[NSString stringWithFormat:@"%d",1]
                     Gender:[NSString stringWithFormat:@"%d",_gender]
                   cityName:self.cityName
                 productURL:urlString
                productType:productType
                      order:[NSString stringWithFormat:@"%d",_sequenceNum]];
    }else{
        [self dataSorcePage:@"123@abc.com"
                   PassWord:@"111111"
                 pageNumber:[NSString stringWithFormat:@"%d",1]
                     Gender:[NSString stringWithFormat:@"%d",_gender]
                   cityName:self.cityName
                 productURL:urlString
                productType:productType
                      order:[NSString stringWithFormat:@"%d",_sequenceNum]];
    }
    
}
//价格排序低到高
- (IBAction)priceLowToHighClick:(id)sender {
   
    [self.tableview_myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.tableview_myTableView.bouncesZoom = NO;
    _sequenceBOOL = NO; //如果点击了排序就设个no

    if (self.btn_Price.selected) {
        [self.btn_Price  setBackgroundImage:[UIImage imageNamed:@"jiage_xia.png"] forState:UIControlStateNormal];
        _sequenceNum = 3;
        [self.btn_Price setSelected:NO];
        if (self._isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",_sequenceNum] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }

    }else{

        [self.btn_Price setBackgroundImage:[UIImage imageNamed:@"jiage_shang.png"] forState:UIControlStateNormal];
        _sequenceNum = 2;
        [self.btn_Price setSelected:YES];
        if (self._isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",_sequenceNum] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }
    }

    [self.btn_Discount setSelected:NO];
    [self.btn_Discount setBackgroundImage:[UIImage imageNamed:@"zhekou.png"] forState:UIControlStateNormal];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

}

//折扣低到高
- (IBAction)discountHighToLowAction:(id)sender {
    
    [self.tableview_myTableView setContentOffset:CGPointMake(0, 0) animated:NO];

    self.tableview_myTableView.bouncesZoom = NO;

    _sequenceBOOL = NO;

    if (self.btn_Discount.selected) {
        [self.btn_Discount  setBackgroundImage:[UIImage imageNamed:@"zhekou_xia.png"] forState:UIControlStateNormal];
        _sequenceNum = 5;
        if (self._isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",_sequenceNum] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }
        [self.btn_Discount setSelected:NO];
    }else{

        [self.btn_Discount setBackgroundImage:[UIImage imageNamed:@"zhekou_shang.png"] forState:UIControlStateNormal];
        [self.btn_Discount setSelected:YES];
        _sequenceNum = 4;
        if (self._isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",_sequenceNum] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }

    }
    [self.btn_Price setSelected:NO];
    [self.btn_Price  setBackgroundImage:[UIImage imageNamed:@"jiage.png"] forState:UIControlStateNormal];
     [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

}
//男装
-(IBAction)ManCloses:(id)sender{
    
    [self.tableview_myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    self.tableview_myTableView.bouncesZoom = NO;
    _gender = 1;
    [_btn_Man setSelected:YES];
    [_qianggouBtn setSelected:NO];
    [_btn_WoMan setSelected:NO];
    _sequenceBOOL = NO;

    if (self._isShaiXuan) {
        [self.shaiXuanDic setValue:[NSString stringWithFormat:@"1"] forKey:@"gender"];
        
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
        
        [self requestDataByBSwithDic:self.shaiXuanDic];
    }else{
        [self loadSortDataSource];
    }

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}
//女装
-(IBAction)WoManCloses:(id)sender{
    
    [self.tableview_myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    self.tableview_myTableView.bouncesZoom = NO;
    
    [_btn_Man setSelected:NO];
    [_qianggouBtn setSelected:NO];
    [_btn_WoMan setSelected:YES];
    _sequenceBOOL = NO;
    _gender = 2;
    
    if (self._isShaiXuan) {
        [self.shaiXuanDic setValue:[NSString stringWithFormat:@"2"] forKey:@"gender"];
        
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
        
        [self requestDataByBSwithDic:self.shaiXuanDic];
    }else{
        [self loadSortDataSource];
    }

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

//用指定分隔符将字符串分割成数组
- (NSArray *) split:(NSString*) separator
{
    return nil;
}

#pragma mark
#pragma mark  *********发送筛选请求******
-(void)shaixuanAcation:(NSNotification*)notification{
    
    _btn_rightItem.selected=!_btn_rightItem.selected;
    self.shaiXuanDic=nil;
    self._isShaiXuan=YES;
    
    nowPageNum=1;
    NSMutableDictionary *dic = notification.object;//通过消息传递筛选条件
    
    self.titleLable.text = [dic objectForKey:@"conditionStr"];
    self.titleLable.font = [UIFont systemFontOfSize:13.0f];
    
    [dic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
    [dic setValue:[NSNumber numberWithInt:nowPageNum] forKey:@"pageNumber"];
    [dic setValue:[NSNumber numberWithInt:0] forKey:@"orderType"];
    [dic setValue:[NSString stringWithFormat:@"3"] forKey:@"gender"];
    
    self.shaiXuanDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    
    [self requestDataByBSwithDic:dic];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

}

//筛选
-(void)requestDataByBSwithDic:(NSMutableDictionary*)dic{

    SearchRequestBS  *searchBS = [[[SearchRequestBS  alloc] init]autorelease];
    searchBS.delegate  = self;
    searchBS.parameterDic=dic;
    searchBS.onSuccessSeletor = @selector(requestFinished:);
    searchBS.onFaultSeletor = @selector(requestFailed:);
    [searchBS asyncExecute];
}

//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [touches anyObject];
//	CGPoint point = [touch locationInView:self.view];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"string");
////	CGFloat PointX = fabsf(FirstPoint.x - SecondPoint.x);
////	Page=[[[NSUserDefaults standardUserDefaults]objectForKey:@"MusicName"] intValue];
////	
////	if(touchMove == NO)
////	{
////	}else
////	{
////		if (FirstPoint.x >= 384 && SecondPoint.x <= 384 && PointX > 240 || FirstPoint.y >= 512 && SecondPoint.y <= 512)
////		{
////			NSLog(@"%d     ",Page);
////			if(Page < 6)
////			{
////				Page++;
////				CGContextRef context = UIGraphicsGetCurrentContext();
////				[UIView beginAnimations:nil context:context];
////				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
////				[self.view setAlpha:0.5];
////				[UIView setAnimationDuration:0.05];
////				[UIView commitAnimations];
////				[self performSelector:@selector(ChangeImage) withObject:nil afterDelay:0.1];
////			}
////		}else if (FirstPoint.x <= 384 && SecondPoint.x >= 384 && PointX > 240 || FirstPoint.y <= 512 && SecondPoint.y >= 512){
////			if(Page >= 2)
////			{
////				Page--;
////				CGContextRef context = UIGraphicsGetCurrentContext();
////				[UIView beginAnimations:nil context:context];
////				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
////				[self.view setAlpha:0.5];
////				[UIView setAnimationDuration:0.05];
////				[UIView commitAnimations];
////				[self performSelector:@selector(ChangeImage) withObject:nil afterDelay:0.1];
////			}
////		}
////	}
//}

@end
