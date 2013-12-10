//
//  MyCouponViewController.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-19.
//
//

#import "MyCouponViewController.h"
#import "MyCouponCell.h"
#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/CAMediaTiming.h>
#import <QuartzCore/CATransform3D.h>
#import "DetailCouponViewController.h"
#import "CouponBS.h"
#import "JSON.h"
 
#import "DateUtil.h"
 
@interface MyCouponViewController ()
@property (retain,nonatomic) NSMutableArray *listCouponArray; //优惠劵的内容
@property (retain,nonatomic) NSMutableArray *listHistoryCouponArray; //优惠劵的内容
@property (assign) BOOL isCurrentCoupon; //YES 为当前的优惠劵
@property (retain,nonatomic) NSString *proStr; 
@end

@implementation MyCouponViewController

- (void)dealloc {
    [_proStr release];
    [_listCouponArray release];
    [_detailCouponView release];
    [_couponTableView release];
    [_imageViewStatus release];
    [_backgroundImageView release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listCouponArray = [NSMutableArray array];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isCurrentCoupon = YES;
    //修改导航栏
    UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
    [self.view addSubview:titbackImageview];
    [titbackImageview release];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = litem;
    [backBtn release];
    [litem release];
    self.title = @"我的优惠券";
    [self couponLoadData:1 hsitory:@"0"];
}


//获取优惠劵
- (void)couponLoadData: (int)num hsitory:(NSString *)orderTypeString{
    
    CouponBS *couponBS = [[[CouponBS alloc] init] autorelease];
    couponBS.delegate = self;
    couponBS.pageNumber = num;
    couponBS.orderTypeString = orderTypeString;
    couponBS.onFaultSeletor = @selector(couponFault:);
    couponBS.onSuccessSeletor = @selector(couponSuccess:);
    [couponBS asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)couponFault:(ASIFormDataRequest *)requestFrom {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        dic= [NSJSONSerialization JSONObjectWithData:requestFrom.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        NSString *jsonString = [requestFrom responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    NSLog(@"优惠劵失败:%@",dic);
    
}
- (void)couponSuccess:(ASIFormDataRequest *)requestFrom {

    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        dic= [NSJSONSerialization JSONObjectWithData:requestFrom.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        NSString *jsonString = [requestFrom responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    NSMutableArray *arrayCoupon = [NSMutableArray arrayWithArray: [dic objectForKey:@"couponList"]];
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200 ) {
        [self.view makeToast:@"获取优惠券数据失败"];
        return;
    }
    //判断是下拉还是上提
    if (requestFrom.tag == REQUEST_PAGE_ONE) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        //下拉就会清除之前的缓存数据
        [self.listCouponArray removeAllObjects];
        self.listCouponArray = arrayCoupon;
        if (arrayCoupon == nil || arrayCoupon.count == 0) {
            self.couponTableView.hidden = YES;
            self.backgroundImageView.hidden = NO;
        } else {
            self.couponTableView.hidden = NO;
            self.backgroundImageView.hidden = YES;
        }
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
    }
    else{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.listCouponArray addObjectsFromArray:arrayCoupon];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
    }
    
//    //验正是不是最后一页
////    BOOL morePage = [[dic objectForKey:@"morePage"] boolValue];
//     Boolean morePage = [[dic objectForKey:@"morePage"] boolValue];
//    if (!morePage) {
//        NSLog(@"已经到最后一页了");
//        return;
//    }
    
    if (self.listCouponArray.count == 0 || self.listCouponArray == nil) {
        return;
    }

    [self.couponTableView reloadData];
    
    CGRect  _newFrame = CGRectMake(0.0f, self.couponTableView.contentSize.height,self.view.frame.size.width,self.couponTableView.bounds.size.height);
    [self createHeaderView];
    [self createFooterView];
    _refreshFooterView.frame = _newFrame;
    [self loadOk];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setCouponTableView:nil];
    [self setImageViewStatus:nil];
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listCouponArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *customCell = @"customCell";
	MyCouponCell *cell = (MyCouponCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
	
	if (cell == nil) {
		//如果没有可重用的单元，我们就从nib里面加载一个，
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyCouponCell"
													 owner:self options:nil];
		//迭代nib重的所有对象来查找NewCell类的一个实例
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[MyCouponCell class]]) {
				cell = (MyCouponCell *)oneObject;
			}
		}
	}
    
    //判断点击当前还是历史，点击历史要求cell不能编辑和点击
    if (_isCurrentCoupon) {
        [cell setUserInteractionEnabled:YES];
    }
    else {
        [cell setUserInteractionEnabled:NO];
    }

    NSDictionary *dic = [self.listCouponArray objectAtIndex:indexPath.row];
    //获取状态 0 未使用 1过期 2已经使用				
    int stateNum = [[dic objectForKey:@"state"] intValue];
    if (stateNum == 2) {
        cell.detailLabel.text = @"过期";
        cell.couponImageView.backgroundColor =[UIColor colorWithRed:149.0/255.0 green:149.0/255 blue:149.0/255.0 alpha:1.0];
    }
    else if (stateNum == 1) {
        cell.detailLabel.text = @"已使用";
        cell.couponImageView.backgroundColor =[UIColor colorWithRed:216.0/255.0 green:91.0/255 blue:93.0/255.0 alpha:1.0]; 
    }
    else {
       cell.couponImageView.backgroundColor =[UIColor colorWithRed:216.0/255.0 green:91.0/255 blue:93.0/255.0 alpha:1.0]; 
    }
   
    [cell.wxShare addTarget:self action:@selector(shareCoupon:) forControlEvents:UIControlEventTouchUpInside];
    cell.wxShare.tag = indexPath.row;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
    NSDate *refund = [DateUtil stringToDate:[dic objectForKey:@"couponEnddate"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *refundString = [DateUtil dateToString:refund withFormat:@"yyyy.MM.dd"];
    cell.endDateLael.text = refundString;
    cell.promoCodeLabel.text = [NSString stringWithFormat:@"优惠码：%@",[dic objectForKey:@"couponNumber"]];
    //使用城市
    NSString *cityString = [[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    if ([cityString isEqualToString:@""] || ![cityString isKindOfClass:[NSString class]]) {
        cityString = @"";
    }

    cell.userTheCityLabel.text = [NSString stringWithFormat:@"使用城市：%@",cityString];

    return cell;
}

-(UIImage*)convertViewToImage:(UIView*)v{

    UIGraphicsBeginImageContext(v.bounds.size);
    
//    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)shareCoupon:(id)sender {
    UIButton *button = (UIButton *)sender;
//    送你“购引”优惠劵xx元，优惠码：1234 5678 90ab cdef，点击看看在哪用~快去shopping吧~
//    http://www.wowgoing.com/coupon/?promotionsid=116
    NSString *proString = [[self.listCouponArray objectAtIndex:button.tag] objectForKey:@"shareLink"];
    NSString *wxStr = [NSString stringWithFormat:@"送你“购引”优惠券%@元，优惠码：%@，点击查看详情",[[self.listCouponArray objectAtIndex:button.tag] objectForKey:@"couponPrice"],[[self.listCouponArray objectAtIndex:button.tag] objectForKey:@"couponNumber"]];

    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"购引icon(114_114)" ofType:@".png"];
    
    id<ISSContent>publishContent=[ShareSDK content:wxStr
                                    defaultContent:wxStr
                                             image:[ShareSDK imageWithPath:path]
                                             title:@"购引"
                                               url:proString                                   description:nil
                                         mediaType:SSPublishContentMediaTypeNews];
    
    //需要定制分享视图的显示属性，使用以下接口
    id<ISSContainer>container=[ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:nil authManagerViewDelegate:nil];
    
    [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:nil
                             result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(@"success");
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     if ([error errorCode] == -22003)
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                             message:[error errorDescription]
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"知道了"
                                                                                   otherButtonTitles:nil];
                                         [alertView show];
                                         [alertView release];
                                     }
                                 }
                                 
                             }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //优惠劵连接
    NSString *proString = [[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"shareLink"];
    //价格
    NSString *priceString = [[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    //优惠劵id
    int couponid = [[[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"couponId"] intValue];
    //优惠码
    NSString *couponNumString = [[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"couponNumber"];
    //店铺名
    NSString *shopString = [[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"shopName"];
    NSString *stringCity = [[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    //日期截止
    NSDate *refund = [DateUtil stringToDate:[[self.listCouponArray objectAtIndex:indexPath.row] objectForKey:@"couponEnddate"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *refundString = [DateUtil dateToString:refund withFormat:@"YYYY.MM.dd"];
    
    DetailCouponViewController *detailCoupon = [[[DetailCouponViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    detailCoupon.myCouponView = self;
    detailCoupon.priceCoupon = priceString;
    detailCoupon.couponCord = couponNumString;
    detailCoupon.dateString = refundString;
    detailCoupon.shopNameString = shopString;
    detailCoupon.couponNum = couponid;
    detailCoupon.cityStr = stringCity;
    detailCoupon.couponShareLink = proString;
    [self.navigationController pushViewController:detailCoupon animated:YES];

}


- (IBAction)currentCouponAction:(id)sender {
    _isCurrentCoupon = YES;
    [self.couponTableView reloadData];
    self.imageViewStatus.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"当前_选中" ofType:@"png"]];
    [self couponLoadData:1 hsitory:@"0"];
    
}

- (IBAction)hsitoryCouponAction:(id)sender {
    _isCurrentCoupon = NO;
    [self.couponTableView reloadData];
    self.imageViewStatus.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"历史_选中" ofType:@"png"]];
    [self couponLoadData:1 hsitory:@"1"];
}




#pragma mark - EGORefreshTableHeader
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshFooterView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
	[self.couponTableView  addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

#pragma mark - EGORefreshTableFooter
-(void)createFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    
	if (self.couponTableView.contentSize.height>=self.view.bounds.size.height){
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.couponTableView.frame.size.height, self.couponTableView.frame.size.width, self.couponTableView.bounds.size.height)];
        _refreshFooterView.backgroundColor  = [UIColor clearColor];
        _refreshFooterView.delegate = self;
        
        [self.couponTableView addSubview:_refreshFooterView];
        
        [_refreshFooterView refreshLastUpdatedDate];
        
        CGRect  _newFrame =  CGRectMake(0.0f, self.couponTableView.frame.size.height,self.view.frame.size.width, self.couponTableView.bounds.size.height);
        _refreshFooterView.frame = _newFrame;
    }
}
#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(UIView*)view
{
    NSString *stringOrderType;
    if (_isCurrentCoupon) {
        stringOrderType = @"0";//当前
    } else {
        stringOrderType = @"1";//历史
    }
    //顶部数据刷新
    if ([view isEqual:_refreshHeaderView]) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
        [self couponLoadData:1 hsitory:stringOrderType];
        _nowPageNum =1;
    }
    //底部数据刷新
    else if([view isEqual:_refreshFooterView]) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
        
        _nowPageNum++;
        [self couponLoadData:_nowPageNum hsitory:stringOrderType];
    }
}
-(void)loadOk
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.couponTableView];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UIView*)view
{
    return _reloading;
}


#pragma mark - UIScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	[_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}




@end
