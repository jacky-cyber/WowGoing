
//
//  AdproductListVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-4-24.
//
//

#import "AdproductListVC.h"
#import "NewProductCell.h"
#import "AdproductsListBS.h"
#import "ProductDetailViewController_Detail2.h"
#import "LoginViewController.h"
#import "RegisterView.h"
#import "ASIHTTPRequest.h"
#import "Api.h"
#import "JSON.h"
#import "WowgoingAccount.h"
#import "PayByWgoingVC.h"
#import "FnalStatementVC.h"
#import "UIImageView+WebCache.h"
#import "SearchRequestBS.h"
#import "SDNestTableVC.h"
#import "AppDelegate.h"

#define kDuration 0.7   // 动画持续时间(秒)
#define REQUEST_PAGE_ONE    1
#define REQUEST_PAGE_NEXT   2


@interface AdproductListVC ()
@property (assign) int sequenceNum; //标记点击的是那个分类排序
@property (assign) int gender;
@property(nonatomic,retain) NSMutableArray *productArray;
@property(nonatomic,retain) NSDictionary *tempDic;//临时接受数据的字典
@property (assign) BOOL sequenceBOOL; //判断是否点击排序功能
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)NSMutableDictionary *shaiXuanDic;//储存接受从筛选界面 选定的筛选条件

@property(nonatomic,assign) BOOL *_isShaiXuan;//是否跳转至筛选界面
@property(nonatomic,assign) int backNumber;// 特殊 计数（用来解决进入 广告详情页后不能跳出首页的情况）
@property(nonatomic,retain) UIImageView *topImage;//顶部导航栏
@end


@implementation AdproductListVC
@synthesize productArray=_productArray;
@synthesize advertisementId=_advertisementId;
@synthesize tempDic=_tempDic;
@synthesize shaiXuanDic=_shaiXuanDic;
@synthesize lableName=_lableName;
@synthesize btnFilter=_btnFilter;
@synthesize topImage=_topImage;
@synthesize requestForm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.productArray=[NSMutableArray array];
       
    }
    return self;
}
- (void)back:(id)sender {
    self.backNumber++;
    //*******特殊处理*******
    if (self.backNumber!=1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adView" object:nil];
        
        return;
    }
    //*******特殊处理*******
    [_topImage  removeFromSuperview];
    [self.navigationController popViewControllerAnimated:NO];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

#pragma mark
#pragma mark   ***********筛选界面*********
- (void)fire:(id)sender {
    UIButton *fireBut=(UIButton*)sender;
    fireBut.selected=!fireBut.selected;
    if (fireBut.selected) {
        [self addFireInterface];
        [self addTapGesture];
    }else{
        [self removeFireInterace];
    }
}

#pragma mark
#pragma mark  ***********左滑显示筛选菜单***********

/****************************
 方法名称:addLeftSwipeGesture
 功能描述:添加向左滑动手势
 输入参数:N/A
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)addLeftSwipeGesture{

    UISwipeGestureRecognizer  *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeAction:)];
    [self.adProductTbale addGestureRecognizer:swipe];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [swipe release];

}
- (void)leftSwipeAction:(UISwipeGestureRecognizer*)sender{
    
    [self addFireInterface];  //改变window的frame，创建并显示筛选界面
    [self addRightSwipeGesture]; //添加向右滑动手势
    
    _btnFilter.selected=!_btnFilter.selected;
    
    
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
    [self.adProductTbale addGestureRecognizer:swipe];
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
    
    self.adProductTbale.userInteractionEnabled=YES;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{//UIVIEW动画块
        
        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
    } completion:^(BOOL finished) {//动画完成后调用的方法
        [view.superview removeFromSuperview];
        [self.adProductTbale removeGestureRecognizer:sender];
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
- (void)handlMaove:(UITapGestureRecognizer*)sender{//单击手势相应方法  从当前页（首页）移除筛选界面
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view=[delegate.window viewWithTag:88888];
    
    self.adProductTbale.userInteractionEnabled=YES;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{//UIVIEW动画块
        
        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
        _btnFilter.selected=!_btnFilter.selected;
        
        
    } completion:^(BOOL finished) {//动画完成后调用的方法
        [view.superview removeFromSuperview];
        [self.view removeGestureRecognizer:sender];
    }];
}

/****************************
 方法名称:addFireInterface
 功能描述:改变window的frame，创建并显示筛选界面
 输入参数:N/A
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)addFireInterface{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SDNestTableVC *sdntTable=[[[SDNestTableVC alloc]init] autorelease];
    [Single shareSingle].isLeiBie = NO;
    sdntTable.typeScreen = 6;
    sdntTable.productType=[NSString stringWithFormat:@"1"];//新品折扣
    
    UIView *view=[[[UIView alloc]initWithFrame:CGRectMake(320,20, 320, IPHONE_HEIGHT)] autorelease];
    view.tag=88888;
    [view addSubview:sdntTable.tableView];
    [delegate.window addSubview:view];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        delegate.window.frame = CGRectMake(-253,delegate.window.frame.origin.y, 640, IPHONE_HEIGHT);
        
    }];
    
    self.adProductTbale.userInteractionEnabled=NO;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=NO;
}
/****************************
 方法名称:removeFireInterace
 功能描述:改变window的frame，恢复到原有界面
 输入参数:N/A
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)removeFireInterace{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view=[delegate.window viewWithTag:88888];
    
    self.adProductTbale.userInteractionEnabled=YES;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{//UIVIEW动画块
        
        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
    } completion:^(BOOL finished) {//动画完成后调用的方法
        [view.superview removeFromSuperview];
        for (UITapGestureRecognizer *tap in [self.view gestureRecognizers]) {
            [self.view removeGestureRecognizer:tap];
        }
    }];
}

#pragma mark
#pragma mark  ********创建发送筛选请求**********

/****************************
 方法名称:shaixuanAcation:(NSNotification*)notification
 功能描述:筛选消息出触发的方法,用来创建并发送筛选请求
 输入参数:(NSNotification*)notification 消息
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)shaixuanAcation:(NSNotification*)notification{
    _btnFilter.selected=!_btnFilter.selected;
    self.shaiXuanDic=nil;
    self._isShaiXuan=YES;
    nowPageNum=1;
    NSMutableDictionary *dic=notification.object;//消息传递过来的数据
    
    [dic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
    [dic setValue:[NSNumber numberWithInt:nowPageNum] forKey:@"pageNumber"];
    [dic setValue:[NSNumber numberWithInt:0] forKey:@"orderType"];
    [dic setValue:[NSString stringWithFormat:@"3"] forKey:@"gender"];

    self.shaiXuanDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    
    [self requestDataByBSwithDic:dic];//发送筛选请求
    
    if (self.navigationController.view!=nil) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
}

- (void)requestDataByBSwithDic:(NSMutableDictionary*)dic{//创建 筛选请求并发送
    SearchRequestBS  *searchBS = [[[SearchRequestBS  alloc] init]autorelease];
    searchBS.delegate  = self;
    searchBS.parameterDic=dic;
    searchBS.onSuccessSeletor = @selector(requestDataForAddetailFinish:);//请求成功后执行的代理方法
    searchBS.onFaultSeletor = @selector(requestDataForAddetailFail:);//请求失败后执行的代理方法
    [searchBS asyncExecute];
}
//排序(1品牌排序 2价格从低到高3价格从高到低4折扣从高到底5折扣从低到高)


- (void)showHUDLoading {
    [self showLoadingView];
}
-(void)viewWillAppear:(BOOL)animated{
    [_topImage setHidden:NO];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;//隐藏自带的导航栏 返回按钮
}

-(void)addTopBarImage{//在自带导航栏上进行自定义 
    //标题
    _lableName=[[UILabel alloc]initWithFrame:CGRectMake(110, 0, 110, 44)];
    _lableName.backgroundColor=[UIColor clearColor];
    _lableName.textAlignment=UITextAlignmentCenter;
    _lableName.textColor=[UIColor whiteColor];
    _lableName.text=[NSString stringWithFormat:@"活动详情"];
    _lableName.font=[UIFont boldSystemFontOfSize:20.0f];

    //返回按钮
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(6, 6, 52, 32);
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
    
    //筛选按钮
    _btnFilter=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnFilter.frame=CGRectMake(260, 6, 52, 32);
    _btnFilter.tag=19860923;
    [_btnFilter addTarget:self action:@selector(fire:) forControlEvents:UIControlEventTouchUpInside];
    [_btnFilter setBackgroundImage:[UIImage imageNamed:@"筛选.png"] forState:UIControlStateNormal];
    

    //导航栏底图
    _topImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 88)];
    _topImage.image=[UIImage imageNamed:@"top_bar.png"];
    _topImage.userInteractionEnabled=YES;
    
    [_topImage addSubview:_lableName];
    [_topImage addSubview:backButton];
    [_topImage addSubview:_btnFilter];

    [self.navigationController.navigationBar addSubview:_topImage];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backNumber=0;
  [self addTopBarImage];
    
    self.adProductTbale.tag=1871734;
    
    self.adProductTbale.frame = CGRectMake(0,0,self.adProductTbale.width,IPHONE_HEIGHT-49-44-15);
    
    self.cityName = [self getBrowerCity];//获取定位城市
    nowPageNum=1;
    
    //移除旧消息,注册新消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shaixuan" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaixuanAcation:) name:@"shaixuan" object:nil];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [self.btnFilter setHidden:YES];
    [self requestDataForAddetail:1 tag:REQUEST_PAGE_ONE];

}
#pragma mark
#pragma mark - 店铺入口数据请求(即全部商品数据请求)
-(void)dataSorceBrandAllPage:(NSString *)userName
                    password:(NSString *)password
                  pageNumber:(NSString *)pageNumber
                    cityName:(NSString *)cityName
                 productType:(NSString *)productType
                  productUrl:(NSString *)productURL
                   orderType:(NSString *)ordertype
                      Gender:(NSString *)gender
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
    [jsonreq setValue:gender forKey:@"gender"];
    NSString *sbreq=nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {//IOS 自带
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
    [requestForm setDidFinishSelector:@selector(requestDataForAddetailFinish:)];
    [requestForm setDidFailSelector:@selector(requestDataForAddetailFail:)];
    [requestForm startAsynchronous];
    
}
#pragma mark
#pragma mark - 产看品牌下的所有商品请求
-(void)dataSorceByBrandIdPage:(NSString *)userName
                     password:(NSString *)password
                   pageNumber:(NSString *)pagenumber
                     cityName:(NSString *)cityname
                   productUrl:(NSString *)productURL
                      brandid:(NSString *)brandId
                  productType:(NSString *)producttype
                    orderType:(NSString *)ordertype
                       Gender:(NSString *)gender
{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:userName forKey:@"loginId"];
    [common setValue:password forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:brandId forKey:@"brandId"];
    [jsonreq setValue:self.cityName forKey:@"cityName"];
    [jsonreq setValue:ordertype forKey:@"orderType"];
    [jsonreq setValue:pagenumber forKey:@"pageNumber"];
    [jsonreq setValue:gender forKey:@"gender"];
    [jsonreq setValue:producttype forKey:@"productType"];
    NSString *sbreq=nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {//IOS 自带
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
    requestForm.tag = ([pagenumber intValue] == 1) ? REQUEST_PAGE_ONE : REQUEST_PAGE_NEXT;
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(requestDataForAddetailFinish:)];//请求成功
    [requestForm setDidFailSelector:@selector(requestDataForAddetailFail:)];//请求失败
    [requestForm startAsynchronous];
}


#pragma mark
#pragma mark   **********获取广告对应的活动产品********
-(void)requestDataForAddetail:(int)pageNumber tag:(int)requestTag{
    AdproductsListBS *adProductBS=[[[AdproductsListBS alloc]init] autorelease];
    adProductBS.delegate=self;
    adProductBS.pageNumber=pageNumber;
    adProductBS.requestTag=requestTag;
    adProductBS.advertisementId=self.advertisementId;
    adProductBS.onSuccessSeletor=@selector(requestDataForAddetailFinish:);
    adProductBS.onFaultSeletor=@selector(requestDataForAddetailFail:);
    [adProductBS asyncExecute];
    
}


//请求成功
-(void)requestDataForAddetailFinish:(ASIHTTPRequest*)request{
    [request clearDelegatesAndCancel];
    [request setDelegate:nil];
    [request cancel];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        return;
    }

    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {
        [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
        [self.adProductTbale setContentOffset:CGPointMake(0, self.adProductTbale.contentOffset.y) animated:YES];
        self.adProductTbale.bouncesZoom = NO;
        [_refreshFooterView setHidden:YES];
        return;
    }
    NSArray *tempArray=nil;
    
        tempArray=[dic objectForKey:@"productList"];
        if (requestForm.tag==REQUEST_PAGE_ONE) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.productArray removeAllObjects];
            [self.productArray addObjectsFromArray:tempArray];
            
        }else{
            if (tempArray.count!=0) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self.productArray addObjectsFromArray:tempArray];
                //isBottom = NO;
            }
            if (tempArray.count == 0) {
                [_refreshFooterView setHidden:YES];
                [self.view makeToast:@"没有更多地数据了"];
                [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
                CGRect rx = [ UIScreen mainScreen ].bounds;
                if(self.productArray.count/2 > rx.size.height/156){
                    [self.adProductTbale setContentOffset:CGPointMake(0, self.adProductTbale.contentOffset.y) animated:YES];
                    self.adProductTbale.bouncesZoom = NO;
                }
                return;
        }
    
             if (self.productArray.count==0) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.view makeToast:@"暂时没有产品呦..."];
            [_refreshFooterView setHidden:YES];
            _reloading = NO;
            
            return;
        }
    }
    [self.adProductTbale reloadData];

   
    switch (requestForm.tag) {
        case REQUEST_PAGE_ONE:
        {
            //更新分页箭头位置
            [self makeNewFrame];
        }
            break;
            
        case REQUEST_PAGE_NEXT:
        {
            //更新分页箭头位置
            [self makeNewFrame];
            nowPageNum++;
            
        }
            break;
        default:
            break;
    }
    
    
    if (dic == NULL || tempArray == NULL|| [tempArray count]==0 ) {
    
        CGRect rx = [ UIScreen mainScreen ].bounds;
        if(self.productArray.count/2 > rx.size.height/156){
            if (self.adProductTbale.contentOffset.y == self.adProductTbale.contentOffset.y) {
                [_refreshFooterView setHidden:YES];
            }else{
                [self.adProductTbale setContentOffset:CGPointMake(0, self.adProductTbale.contentOffset.y) animated:YES];
                self.adProductTbale.bouncesZoom = NO;
            }
        }
        return;
    }

}

//请求失败
-(void)requestDataForAddetailFail:(ASIHTTPRequest*)request{
    [request clearDelegatesAndCancel];
    [request setDelegate:nil];
    [request cancel];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    requestForm = (ASIFormDataRequest*)request;
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

    if ([dic count] == 0) {
        CGRect rx = [ UIScreen mainScreen ].bounds;
        
        if(self.productArray.count/2 > rx.size.height/156){
            if (self.adProductTbale.contentOffset.y < 0 ) {
                [self.adProductTbale setContentOffset:CGPointMake(0, 46) animated:YES];
                self.adProductTbale.bouncesZoom = NO;
            }else{
                
            [self.adProductTbale setContentOffset:CGPointMake(0, self.adProductTbale.contentOffset.y) animated:YES];
            self.adProductTbale.bouncesZoom = NO;
            }
            
        }
        return;
    }
}
#pragma mark
#pragma mark  *****UITableViewDataSource/UITableViewDelegate*****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.productArray count ]/2 +[self.productArray count ]%2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 156;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *adTableIdentifier = @"NewProductCell";
    NewProductCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            adTableIdentifier];
    
    if (cell == nil) {
        //如果没有可重用的单元，我们就从nib里面加载一个，
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewProductCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[NewProductCell class]]) {
                cell = (NewProductCell *)oneObject;
            }
        }
    }
    
    NSMutableDictionary *proDic = nil;
    if ((indexPath.row*2) <[self.productArray count]) {
        proDic=[self.productArray objectAtIndex:indexPath.row*2];
    }
    NSMutableDictionary *proDic2 = nil;
    if ((indexPath.row*2+1) <[self.productArray count]) {
        proDic2 = [self.productArray objectAtIndex:indexPath.row*2+1];
        
    }
    if (proDic2 == nil) {
        [cell.productImageRight setHidden: YES];
        [cell.img1 setHidden:YES];
        [cell.productPriceRight  setHidden:YES];
        [cell.img_money setHidden:YES];
        [cell.discountRight setHidden:YES];
        [cell.discountPriceRight setHidden:YES];
        [cell.img_touming setHidden:YES];
        [cell.btn_Right setHidden:YES];
        [cell.brandLogoRight setHidden:YES];
        @autoreleasepool {
        cell.productImageLeft.placeholderImage = [UIImage imageNamed:@"水印-大图.png"];
        [cell.productImageLeft setImageURL:[NSURL URLWithString:[proDic objectForKey:@"picUrl"]]];
        
        cell.productImageLeft.tag = BRAND_PRO;
        
        [cell.brandLogoLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"brandLogo"]] placeholderImage:nil];
        
        cell.productPriceLeft.text = [NSString stringWithFormat:@"￥%d",[[proDic  objectForKey:@"discountPrice"]intValue]];
        
        cell.discountPriceLeft.backgroundColor = [UIColor clearColor];
        cell.discountPriceLeft.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
        cell.discountPriceLeft.strikeThroughEnabled=YES;
        cell.discountPriceLeft.font = [UIFont systemFontOfSize:12];
        cell.discountPriceLeft.text=[NSString stringWithFormat:@"￥%@",[proDic objectForKey:@"price"]];
        
        cell.discountLeft.text=[NSString stringWithFormat:@"%@折",[proDic objectForKey:@"discount"]];
        cell.label_productName.text=[proDic objectForKey:@"productName"];
        [cell.btn_Left addTarget:self action:@selector(productDetaiAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Left.data=proDic;
        }
        
    }else{
        [cell.productImageRight setHidden: NO];
        [cell.img1 setHidden:NO];
        [cell.productPriceRight  setHidden:NO];
        [cell.img_money setHidden:NO];
        [cell.discountRight setHidden:NO];
        [cell.discountPriceRight setHidden:NO];
        [cell.img_touming setHidden:NO];
        [cell.btn_Right setHidden:NO];
        [cell.brandLogoRight setHidden:NO];
        @autoreleasepool {

        cell.productImageLeft.placeholderImage = [UIImage imageNamed:@"水印-大图.png"];
            [cell.productImageLeft setImageURL:[NSURL URLWithString:[proDic objectForKey:@"picUrl"]]];
            
            cell.productImageLeft.tag = BRAND_PRO;
        
       
            [cell.brandLogoLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"brandLogo"]] placeholderImage:nil];
            

            cell.productPriceLeft.text = [NSString stringWithFormat:@"￥%d",[[proDic  objectForKey:@"discountPrice"]intValue]];
            
            cell.discountPriceLeft.backgroundColor = [UIColor clearColor];
            cell.discountPriceLeft.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
            cell.discountPriceLeft.strikeThroughEnabled=YES;
            cell.discountPriceLeft.font = [UIFont systemFontOfSize:12];
            cell.discountPriceLeft.text=[NSString stringWithFormat:@"￥%@",[proDic objectForKey:@"price"]];
            
            cell.discountLeft.text=[NSString stringWithFormat:@"%@折",[proDic objectForKey:@"discount"]];
            cell.label_productName.text=[proDic objectForKey:@"productName"];
            [cell.btn_Left addTarget:self action:@selector(productDetaiAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Left.data = proDic;
        
          cell.productImageRight.placeholderImage = [UIImage imageNamed:@"水印-大图.png"];
            [cell.productImageRight setImageURL:[NSURL URLWithString:[proDic2 objectForKey:@"picUrl"]]];
            
            cell.productImageRight.tag = BRAND_PRO;
        
            [cell.brandLogoRight setImageWithURL:[NSURL URLWithString:[proDic2 objectForKey:@"brandLogo"]] placeholderImage:nil];
            
            cell.productPriceRight.text = [NSString stringWithFormat:@"￥%@",[proDic2  objectForKey:@"discountPrice"]];
            
            cell.discountPriceRight.backgroundColor = [UIColor clearColor];
            cell.discountPriceRight.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
            cell.discountPriceRight.strikeThroughEnabled=YES;
            cell.discountPriceRight.font = [UIFont systemFontOfSize:12];
            cell.discountPriceRight.text=[NSString stringWithFormat:@"￥%@",[proDic2 objectForKey:@"price"]];
            
            cell.discountRight.text=[NSString stringWithFormat:@"%@折",[proDic2 objectForKey:@"discount"]  ];
            cell.label_productName.text=[proDic2 objectForKey:@"productName"];
            [cell.btn_Right addTarget:self action:@selector(productDetaiAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Right.data= proDic2;
    
        }
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[SDImageCache sharedImageCache] clearMemory];
    
}
#pragma mark 
#pragma mark  ********产品详情*********
-(void)productDetaiAction:(UIDataButton*)sender{
    
    ProductDetailViewController_Detail2 *productDetail=[[[ProductDetailViewController_Detail2 alloc]initWithNibName:@"ProductDetailViewController_Detail2" bundle:nil] autorelease];
    productDetail.productId=[[sender.data objectForKey:@"productId"] intValue];
    productDetail.activityId=[[sender.data objectForKey:@"activityId"] intValue];
    productDetail.prductDetailDic=sender.data;
    [_topImage setHidden:YES];
    self.navigationController.navigationBarHidden = YES;
     [self.navigationController pushViewController:productDetail animated:NO];
    
}

#pragma mark - EGORefreshTableHeader
-(void)createHeaderView{
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
	[self.adProductTbale  addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}
#pragma mark - EGORefreshTableFooter
-(void)createFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
	_refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                          CGRectMake(0.0f, self.adProductTbale.contentSize.height-20,
                                     self.view.frame.size.width, self.adProductTbale.bounds.size.height)];
    _refreshFooterView.backgroundColor  = [UIColor clearColor];
    _refreshFooterView.delegate = self;
    
	[self.adProductTbale  addSubview:_refreshFooterView];
    
    [_refreshFooterView refreshLastUpdatedDate];
    
    CGRect  _newFrame =  CGRectMake(0.0f, self.adProductTbale.contentSize.height-20,
                                    self.view.frame.size.width,  self.adProductTbale.bounds.size.height);
    
    _refreshFooterView.frame = _newFrame;
    
}

#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(UIView*)view
{
           //顶部数据刷新
    if ([view isEqual:_refreshHeaderView]) {
        
            [self requestDataForAddetail:1 tag:REQUEST_PAGE_ONE];
            nowPageNum =1;
        }
        //底部数据刷新
        else if([view isEqual:_refreshFooterView]) {
                        [self requestDataForAddetail:nowPageNum+1 tag:REQUEST_PAGE_NEXT];
        }
    
}
-(void)loadOk
{
    _reloading = NO;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.adProductTbale];

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
  
    CGPoint contentOffsetPoint = self.adProductTbale.contentOffset;
    CGRect frame = self.adProductTbale.frame;

    if (contentOffsetPoint.y == self.adProductTbale.contentSize.height - frame.size.height)
        {
            
            if ([self.productArray count] !=0 )
            {
                [self egoRefreshTableHeaderDidTriggerRefresh:_refreshFooterView];
            }
        }
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

-(void)makeNewFrame{
    self.adProductTbale.contentSize  = CGSizeMake(0.0f, self.adProductTbale.contentSize.height+30.0f);
    CGRect  _newFrame = CGRectMake(0.0f, self.adProductTbale.contentSize.height-40.0f,self.view.frame.size.width,self.adProductTbale.bounds.size.height);
    
    [self createHeaderView];
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    if(self.productArray.count/2 > rx.size.height/156){
        [self createFooterView];
    }
    _refreshFooterView.frame = _newFrame;
    
    [self loadOk];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory]; //收到内存警告时 释放缓存
    [[SDImageCache sharedImageCache] cleanDisk];
}

- (void)dealloc {
    [_adProductTbale release];
    [_productArray release];
    [_advertisementId release];
    [_tempDic release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    [_shaiXuanDic release];
    [_lableName release];
    [_topImage release];
    [_cityName release], _cityName = nil;
   
    for (requestForm in [ASIFormDataRequest sharedQueue].operations) {
        [requestForm clearDelegatesAndCancel];
    }
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAdProductTbale:nil];
    [self setProductArray:nil];
    [self setAdvertisementId:nil];
    self.tempDic=nil;
    [[SDImageCache sharedImageCache] clearMemory];
    [super viewDidUnload];
}

@end

