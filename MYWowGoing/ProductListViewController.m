//
//  ProductListViewController.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-27.
//
//

#import "ProductListViewController.h"
#import "NewProductCell.h"
#import "ProductDetailViewController_Detail2.h"
#import "AppDelegate.h"
#import "SDNestTableVC.h"
#import "SearchRequestBS.h"


#import "UIImageView+WebCache.h"
#import "JSON.h"
#import "NetworkUtil.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#define REQUEST_PAGE_ONE    1
#define REQUEST_PAGE_NEXT   2
@interface ProductListViewController ()<EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    int nowPageNum;
    BOOL _isShaiXuan;
    BOOL isNOData;
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    int  flagForButtonSelected;
    int flagForSex;
    
    UIImageView   *topBackgroungImageView;
    
    
    
}
@property (retain, nonatomic) IBOutlet UITableView *productTableView;
@property (retain, nonatomic) IBOutlet UIView *viewForButon;
@property (retain,nonatomic) NSMutableArray  *productsArray;
@property (retain,nonatomic) NSMutableDictionary  *shaiXuanDic;
@property (retain, nonatomic) IBOutlet UIButton *shaiXuanBut;

@property (retain, nonatomic) IBOutlet UIButton *allSelectBut;

@property (retain, nonatomic) IBOutlet UIButton *wanSelectBut;

@property (retain, nonatomic) IBOutlet UIButton *womenSelectBut;

@property (retain, nonatomic) IBOutlet UIButton *priceOrderBut;

@property (retain, nonatomic) IBOutlet UIButton *discountPriceOrderBut;
@property (retain,nonatomic) UILabel *conditionLable;

@end

@implementation ProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(10, 6, 52, 32)];;
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(260, 6, 60, 34)];;
        [shareButton addTarget:self action:@selector(shaiXuanAction:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"筛选.png"] forState:UIControlStateNormal];
        
        
        self.conditionLable = [[[UILabel alloc ] initWithFrame:CGRectMake(70, 0, 180, 44)] autorelease];
        self.conditionLable.backgroundColor = [UIColor clearColor];
        self.conditionLable.font = [UIFont systemFontOfSize:13.0f];
        self.conditionLable.textColor = [UIColor whiteColor];
        self.conditionLable.textAlignment = UITextAlignmentCenter;
    
        topBackgroungImageView = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, 320, 44)];
        topBackgroungImageView.userInteractionEnabled = YES;
        topBackgroungImageView.image = [UIImage imageNamed:@"top_bar.png"];
        [topBackgroungImageView addSubview:backButton];
        [topBackgroungImageView addSubview:shareButton];
        [topBackgroungImageView addSubview:self.conditionLable];
       
    }
    return self;
}

- (void)backAction:(id)sender {
    [topBackgroungImageView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark    *********筛选相关操作*******
- (void)shaiXuanAction:(id)sender {
    UIButton *filterBut=(UIButton*)sender;
    filterBut.selected=!filterBut.selected;
    
    if (filterBut.selected) {
        [self addScreenInteface];
    }else{
        [self removeScreenInteface];
    }

}

/****************************
 方法名称:addLeftSwipeGesture
 功能描述:添加向左滑动手势
 输入参数:N/A
 输出参数:N/A
 返回值:N/A
 ****************************/
- (void)addLeftSwipeGesture{
    
    UISwipeGestureRecognizer  *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeAction:)];
    [self.productTableView addGestureRecognizer:swipe];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [swipe release];
    
}
- (void)leftSwipeAction:(UISwipeGestureRecognizer*)sender{
    
    [self addScreenInteface];  //改变window的frame，创建并显示筛选界面
    [self addRightSwipeGesture];
    _shaiXuanBut.selected=!_shaiXuanBut.selected;
    
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
    [self.productTableView addGestureRecognizer:swipe];
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
    
    self.productTableView.userInteractionEnabled=YES;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{//UIVIEW动画块
        
        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
    } completion:^(BOOL finished) {//动画完成后调用的方法
        [view.superview removeFromSuperview];
        [self.productTableView removeGestureRecognizer:sender];
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
    
    if (self.flagForBrandOrShop == 1) {   //品牌
        sdntTable.typeScreen = 2;
        [Single shareSingle].isLeiBie = NO;
    }else   if (self.flagForBrandOrShop == 2){  //店铺
        sdntTable.typeScreen = 1;
        [Single shareSingle].isLeiBie = NO;
    }else  if (self.flagForBrandOrShop == 3){   //类别
        sdntTable.typeScreen = 3;
        [Single shareSingle].isLeiBie = YES;
    }else if(self.flagForBrandOrShop == 4){
         sdntTable.typeScreen = 8;
        [Single shareSingle].isLeiBie = NO;
    }else{
        sdntTable.typeScreen = 9;
        [Single shareSingle].isLeiBie = NO;
    }
    
    UIView *view=[[[UIView alloc]initWithFrame:CGRectMake(320,20, 320, IPHONE_HEIGHT)] autorelease];
    view.tag=88888;
    [view addSubview:sdntTable.tableView];
    [delegate.window addSubview:view];
    
    [UIView animateWithDuration:0.5 animations:^{
        delegate.window.frame = CGRectMake(-253,delegate.window.frame.origin.y, 640, IPHONE_HEIGHT);
    }];
    
    //设置列表不能点击
    self.productTableView.userInteractionEnabled=NO;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=NO;
    
    [self addTapGesture];
}
//改变windows的位置
-(void)removeScreenInteface{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view=[delegate.window viewWithTag:88888];
    
    self.productTableView.userInteractionEnabled=YES;
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
    
    self.productTableView.userInteractionEnabled=YES;
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
        
        _shaiXuanBut.selected=!_shaiXuanBut.selected;
        
    } completion:^(BOOL finished) {
        [view.superview removeFromSuperview];
        [self.view removeGestureRecognizer:sender];
    }];
    
}

#pragma mark 
#pragma mark  ********全部按钮**********
- (IBAction)allProductsAction:(id)sender {
    
    [self.productsArray removeAllObjects];
    [self.productTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.productTableView.bouncesZoom = NO;
    [self.allSelectBut   setSelected:YES];
    [self.wanSelectBut setSelected:NO];
    [self.womenSelectBut setSelected:NO];
    flagForSex = 3;
    
    [self requestData];
}

#pragma mark
#pragma mark  ********男装**********
- (IBAction)productsForManAction:(id)sender {
    [self.productTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    self.productTableView.bouncesZoom = NO;
    flagForSex= 1;
    [self.wanSelectBut setSelected:YES];
    [self.allSelectBut setSelected:NO];
    [self.womenSelectBut setSelected:NO];
//    _sequenceBOOL = NO;
    
    if (_isShaiXuan) {
        [self.shaiXuanDic setValue:[NSString stringWithFormat:@"1"] forKey:@"gender"];
        
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
        
        [self requestDataByBSwithDic:self.shaiXuanDic];
    }else{
        [self loadSortDataSource];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


#pragma mark
#pragma mark  ********女装**********
- (IBAction)productsForWomanAction:(id)sender {
    
    [self.productTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    self.productTableView.bouncesZoom = NO;
    
    [self.wanSelectBut setSelected:NO];
    [self.allSelectBut setSelected:NO];
    [self.womenSelectBut setSelected:YES];
//    _sequenceBOOL = NO;
    flagForSex = 2;
    
    if (_isShaiXuan) {
        [self.shaiXuanDic setValue:[NSString stringWithFormat:@"2"] forKey:@"gender"];
        
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
        [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
        
        [self requestDataByBSwithDic:self.shaiXuanDic];
    }else{
        [self loadSortDataSource];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark
#pragma mark  ********价格排序**********
- (IBAction)priceOrderAction:(id)sender {
    
    [self.productTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.productTableView.bouncesZoom = NO;
//    _sequenceBOOL = NO; //如果点击了排序就设个no
    
    if (self.priceOrderBut.selected) {
        [self.priceOrderBut  setBackgroundImage:[UIImage imageNamed:@"jiage_xia.png"] forState:UIControlStateNormal];
        flagForButtonSelected = 3;
        [self.priceOrderBut setSelected:NO];
        if (_isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",flagForButtonSelected] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }
        
    }else{
        
        [self.priceOrderBut setBackgroundImage:[UIImage imageNamed:@"jiage_shang.png"] forState:UIControlStateNormal];
        flagForButtonSelected = 2;
        [self.priceOrderBut setSelected:YES];
        if (_isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",flagForButtonSelected] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }
    }
    
    [self.discountPriceOrderBut setSelected:NO];
    [self.discountPriceOrderBut setBackgroundImage:[UIImage imageNamed:@"zhekou.png"] forState:UIControlStateNormal];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

#pragma mark
#pragma mark  ********折扣排序**********
- (IBAction)discountPriceOrderAction:(id)sender {
    
    [self.productTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    self.productTableView.bouncesZoom = NO;
    
//    _sequenceBOOL = NO;
    
    if (self.discountPriceOrderBut.selected) {
        [self.discountPriceOrderBut  setBackgroundImage:[UIImage imageNamed:@"zhekou_xia.png"] forState:UIControlStateNormal];
       flagForButtonSelected = 5;
        if (_isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",flagForButtonSelected] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }
        [self.discountPriceOrderBut setSelected:NO];
    }else{
        
        [self.discountPriceOrderBut setBackgroundImage:[UIImage imageNamed:@"zhekou_shang.png"] forState:UIControlStateNormal];
        [self.discountPriceOrderBut setSelected:YES];
       flagForButtonSelected = 4;
        if (_isShaiXuan) {
            [self.shaiXuanDic setValue:[NSString stringWithFormat:@"%d",flagForButtonSelected] forKey:@"orderType"];
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }else{
            [self loadSortDataSource];
        }
        
    }
    [self.priceOrderBut setSelected:NO];
    [self.priceOrderBut  setBackgroundImage:[UIImage imageNamed:@"jiage.png"] forState:UIControlStateNormal];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

#pragma mark
#pragma mark ----------排序
- (void)loadSortDataSource  {
    
    //每次点击排序的条件的时候把参数设为初始位置
    nowPageNum = 1;
    [self.productsArray removeAllObjects];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,PRODUCT_LIST]; //品牌;
    NSString  *productType = 0;

    if ([Util isLogin]) {
        [self dataSorceByBrandIdPage:[Util  getLoginName]
                                       password:[Util getPassword]
                                  pageNumber:[NSNumber numberWithInt:nowPageNum]
                                       cityName:[Util getBrowerCity]
                                      productUrl:urlString
                                     productType:productType
                                        orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                                           Gender:[NSString stringWithFormat:@"%d",flagForSex]];
    }else{
        [self dataSorceByBrandIdPage:USERNAME
                            password:PASSWORD
                          pageNumber:[NSNumber numberWithInt:nowPageNum]
                            cityName:[Util getBrowerCity]
                          productUrl:urlString
                         productType:productType
                           orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                              Gender:[NSString stringWithFormat:@"%d",flagForSex]];

    }
    
}


#pragma mark
#pragma mark  ************UITableViewDataSource/UITableViewDelegate*********
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productsArray.count/2 + self.productsArray.count%2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 156;

}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static  NSString *productsTableIdentifier = @"productsCell";
    NewProductCell *cell = [tableView dequeueReusableCellWithIdentifier:productsTableIdentifier];
    if (cell == nil) {
        NSArray  *nibArray = [[NSBundle mainBundle] loadNibNamed:@"NewProductCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    NSDictionary *proDic=nil;
    if ((indexPath.row*2) <[self.productsArray count]) {
        proDic=[self.productsArray objectAtIndex:indexPath.row*2];
    }
    NSDictionary *proDic2=nil;
    if ((indexPath.row*2+1) <[self.productsArray count]) {
        proDic2 = [self.productsArray objectAtIndex:indexPath.row*2+1];
        
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
            [cell.productImageLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"水印-大图.png"]];
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
            cell.btn_Left.tag = [[proDic objectForKey:@"activityId"] integerValue];
            cell.btn_Left.data=[NSMutableDictionary dictionaryWithDictionary:proDic];
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
            [cell.productImageLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"水印-大图.png"]];
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
            cell.btn_Left.tag = [[proDic objectForKey:@"activityId"] integerValue];
            cell.btn_Left.data=[NSMutableDictionary dictionaryWithDictionary:proDic];
            
            
            [cell.productImageRight setImageWithURL:[NSURL URLWithString:[proDic2 objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"水印-大图.png"]];
            cell.productImageRight.tag = BRAND_PRO;
            
            [cell.brandLogoRight setImageWithURL:[NSURL URLWithString:[proDic2 objectForKey:@"brandLogo"]] placeholderImage:nil];
            
            cell.productPriceRight.text = [NSString stringWithFormat:@"￥%d",[[proDic2  objectForKey:@"discountPrice"]intValue]];
            
            cell.discountPriceRight.backgroundColor = [UIColor clearColor];
            cell.discountPriceRight.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
            cell.discountPriceRight.strikeThroughEnabled=YES;
            cell.discountPriceRight.font = [UIFont systemFontOfSize:12];
            cell.discountPriceRight.text=[NSString stringWithFormat:@"￥%@",[proDic2 objectForKey:@"price"]];
            
            cell.discountRight.text=[NSString stringWithFormat:@"%@折",[proDic2 objectForKey:@"discount"]];
            cell.label_productName.text=[proDic2 objectForKey:@"productName"];
            [cell.btn_Right addTarget:self action:@selector(productDetaiAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Right.tag = [[proDic2 objectForKey:@"activityId"] integerValue];
            cell.btn_Right.data=[NSMutableDictionary dictionaryWithDictionary:proDic2];
            
        }
    }
    return cell;
 }

#pragma mark
#pragma mark   ***********数据请求**********
-(void)dataSorceByBrandIdPage:(NSString *)userName
                     password:(NSString *)password
                   pageNumber:(NSNumber *)pagenumber
                     cityName:(NSString *)cityname
                   productUrl:(NSString *)productURL
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
    if (self.flagForBrandOrShop == 1) {
          [jsonreq setValue:self.brandID forKey:@"brandId"];
    }else  if(self.flagForBrandOrShop == 2){
          [jsonreq setValue:self.shopID forKey:@"marketID"];
    }else if (self.flagForBrandOrShop == 3){
         [jsonreq setValue:self.styleTypeName forKey:@"styleTypeName"];
         [jsonreq setValue:self.type forKey:@"type"];
    }else{
        [jsonreq setValue:self.styleTypeName forKey:@"productDetailKey"];
    }
    [jsonreq setValue:@"1" forKey:@"brandType"];
    [jsonreq setValue:cityname forKey:@"cityName"];
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
   ASIFormDataRequest* requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlS]];
    requestForm.tag = ([pagenumber intValue] == 1) ? REQUEST_PAGE_ONE : REQUEST_PAGE_NEXT;
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(requestDataForProductsFinish:)];//请求成功
    [requestForm setDidFailSelector:@selector(requestDataForProductsFail:)];//请求失败
    [requestForm startAsynchronous];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) requestDataForProductsFinish:(ASIFormDataRequest*)requestForm{
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
   
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
    
    NSMutableArray *products = [dic objectForKey:@"products"];
  
    if (responseStatus!=200) {
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
    
        [self.productTableView setContentOffset:CGPointMake(0, self.productTableView.contentOffset.y) animated:YES];
        self.productTableView.bouncesZoom = NO;
        [_refreshFooterView setHidden:YES];
        return;
    }

    CGRect rx = [ UIScreen mainScreen ].bounds;
    int rowCount =0;
    rowCount = rx.size.height/156;
    
    if (dic == NULL || products == NULL|| [products count]==0 ) {//返回为空
        
       [MBProgressHUD hideHUDForView:self.view  animated:NO];
        
        if (_isShaiXuan) {
            if (requestForm.tag == REQUEST_PAGE_ONE) {
                [self.productsArray removeAllObjects];
    
                 [self.view makeToast:@"没有搜索到你查询的产品\n换个条件筛选条件试试吧..." duration:0.5 position:@"center" title:nil];
            }else{
              
                [self.view makeToast:@"没有更多数据了" duration:0.5 position:@"center" title:nil];
                
            }
            
        }else{
              [self.view makeToast:@"没有更多数据了" duration:0.5 position:@"center" title:nil];
        }
        
        [self.productTableView   reloadData];
        _reloading = NO;
        
        if(self.productsArray.count/2 > rowCount){//数据大于一屏
            if (self.productTableView.contentOffset.y == self.productTableView.contentOffset.y) {
                [_refreshFooterView setHidden:YES];
            }else{
                [self.productTableView setContentOffset:CGPointMake(0, self.productTableView.contentOffset.y) animated:YES];
                self.productTableView.bouncesZoom = NO;
            }
        }
        return;
    }
    
    //判断下拉还是上滑
    if (requestForm.tag == REQUEST_PAGE_ONE) {
        //如果下拉，清除数据
        [self.productsArray removeAllObjects];
        self.productsArray = products;
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
         isNOData = YES;
    }
    else{
        nowPageNum++;
         isNOData = YES;
        [self.productsArray addObjectsFromArray:products];
        _reloading = NO;
        
        if (self.productsArray.count == 0 ||self.productsArray== nil) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
            
            if(self.productsArray.count/2 > rowCount){
                [self.productTableView setContentOffset:CGPointMake(0, self.productTableView.contentOffset.y) animated:YES];
                self.productTableView.bouncesZoom = NO;
            }
            return;
        }
    }
 
    [self.productTableView reloadData];
    self.productTableView.contentSize  = CGSizeMake(0.0f, self.productTableView.contentSize.height+30.0f);
    CGRect  _newFrame = CGRectMake(0.0f, self.productTableView.contentSize.height-40.0f,self.view.frame.size.width,self.productTableView.bounds.size.height);
    
    if(self.productsArray.count/2 >rowCount){
        [self createFooterView];
    }
    if (products.count < 10) {
        
        [self.productTableView setContentOffset:CGPointMake(0, self.productTableView.contentOffset.y) animated:YES];
        self.productTableView.bouncesZoom = NO;
        [_refreshFooterView setHidden:YES];
    }
    
    [self createHeaderView];
    _refreshFooterView.frame = _newFrame;
    [self loadOk];
    [self.viewForButon setHidden:NO]; 
}

- (void) requestDataForProductsFail:(ASIFormDataRequest*)requestForm{
    
     [MBProgressHUD hideHUDForView:self.view  animated:NO];

}

#pragma mark
#pragma mark   ************查看商品详情*************
- (void) productDetaiAction:(UIDataButton*) sender{

    ProductDetailViewController_Detail2 *productDetail = [[[ProductDetailViewController_Detail2 alloc] initWithNibName:@"ProductDetailViewController_Detail2" bundle:nil] autorelease];
    productDetail.prductDetailDic = sender.data;
    productDetail.activityId = sender.tag;
    productDetail.productId = [[sender.data objectForKey:@"productId"] integerValue];
    [topBackgroungImageView removeFromSuperview];
    [self.navigationController pushViewController:productDetail animated:YES];

}

#pragma mark
#pragma mark   ***********下拉刷新/上提请求更多**********
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
	[self.productTableView  addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - EGORefreshTableFooter
-(void)createFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
	_refreshFooterView =  [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.productTableView.contentSize.height-20.0f,self.view.frame.size.width, self.productTableView.bounds.size.height)];
    
    _refreshFooterView.delegate = self;
    
	[self.productTableView  addSubview:_refreshFooterView];
    
    [_refreshFooterView refreshLastUpdatedDate];
    
    CGRect  _newFrame =  CGRectMake(0.0f, self.productTableView.contentSize.height-20.0f, self.view.frame.size.width,  self.productTableView.bounds.size.height);
    
    _refreshFooterView.frame = _newFrame;
    
}

#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(UIView*)view
{
    NSString *urlString = nil;
    NSString  *productType = nil;
    urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,XIANSHI_LIST];
       
    //限时抢购
    if ([view isEqual:_refreshHeaderView]) {//顶部数据refresh
        if (!_isShaiXuan) {
            if ([Util isLogin]) {
                [self dataSorceByBrandIdPage:[Util getLoginName]
                           password:[Util getPassword]
                         pageNumber:[NSNumber numberWithInt:nowPageNum]
                         cityName:[Util getBrowerCity]
                         productUrl:urlString
                        productType:productType
                            orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                          Gender:[NSString stringWithFormat:@"%d",flagForSex] ];
            }else{
                [self dataSorceByBrandIdPage:@"123@abc.com"
                                    password:@"888888"
                                  pageNumber:[NSNumber numberWithInt:nowPageNum]
                                    cityName:[Util getBrowerCity]
                                  productUrl:urlString
                                 productType:productType
                                   orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                                      Gender:[NSString stringWithFormat:@"%d",flagForSex] ];

            }
        }else{
            
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
            [self.shaiXuanDic setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
            [self requestDataByBSwithDic:self.shaiXuanDic];
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        nowPageNum =1;
    } else if([view isEqual:_refreshFooterView]) { //底部数据刷新
        if (!_isShaiXuan) {
            
            if ([Util isLogin]) {
                [self dataSorceByBrandIdPage:[Util getLoginName]
                                    password:[Util getPassword]
                                  pageNumber:[NSNumber numberWithInt:nowPageNum + 1]
                                    cityName:[Util getBrowerCity]
                                  productUrl:urlString
                                 productType:productType
                                   orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                                      Gender:[NSString stringWithFormat:@"%d",flagForSex] ];

            }else{
                [self dataSorceByBrandIdPage:@"123@abc.com"
                                    password:@"888888"
                                  pageNumber:[NSNumber numberWithInt:nowPageNum + 1]
                                    cityName:[Util getBrowerCity]
                                  productUrl:urlString
                                 productType:productType
                                   orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                                      Gender:[NSString stringWithFormat:@"%d",flagForSex] ];

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
  
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.productTableView];
    
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
    
    CGPoint contentOffsetPoint = self.productTableView.contentOffset;
    CGRect frame = self.productTableView.frame;
    
    
    if (contentOffsetPoint.y == self.productTableView.contentSize.height - frame.size.height)
    {
        if ([self.productsArray count] !=0 && !isNOData ) {
            [self egoRefreshTableHeaderDidTriggerRefresh:_refreshFooterView];
            isNOData = NO;
        }
    }
    
    if (currentPostion - oldContentOffsetY > 150) {
        [UIView animateWithDuration:0.2f animations:^{
            [self.viewForButon setFrame:CGRectMake(0, -44, self.viewForButon.width, self.viewForButon.height)];
            [self.view sendSubviewToBack:self.viewForButon];
            self.productTableView.frame = CGRectMake(0, 0, self.productTableView.frame.size.width, IPHONE_HEIGHT-44-49-15);
            
        } completion:^(BOOL finished) {
        }];
    }
    else if (oldContentOffsetY - currentPostion > 150)
    {
        [UIView animateWithDuration:0.2f animations:^{
            
            self.productTableView.frame = CGRectMake(0, 44, self.productTableView.width, IPHONE_HEIGHT-44-49-15);
            [self.viewForButon setFrame:CGRectMake(0, 0, self.viewForButon.width, self.viewForButon.height)];
            [self.view bringSubviewToFront:self.viewForButon];
        } completion:^(BOOL finished) {
        }];
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark
#pragma mark   *********筛选方法执行************
//筛选
-(void)requestDataByBSwithDic:(NSMutableDictionary*)dic{
    
    SearchRequestBS  *searchBS = [[[SearchRequestBS  alloc] init]autorelease];
    searchBS.delegate  = self;
    searchBS.parameterDic=dic;
    searchBS.isSearch  = YES;
    searchBS.onSuccessSeletor = @selector(requestDataForProductsFinish:);
    searchBS.onFaultSeletor = @selector( requestDataForProductsFail:);
    [searchBS asyncExecute];
}

- (void) shaixuanAcation:(NSNotification*)notification
{
    _shaiXuanBut.selected=!_shaiXuanBut.selected;
    self.shaiXuanDic=nil;
    _isShaiXuan=YES;
    
    self.productTableView.userInteractionEnabled = YES;
    
    nowPageNum=1;
    NSMutableDictionary *dic=notification.object;//通过消息传递筛选条件
    
    self.conditionLable.text = [NSString stringWithFormat:@"%@/%@",self.conditionStr,[dic objectForKey:@"conditionStr"]];
    
    [dic setValue:[NSNumber numberWithInt:REQUEST_PAGE_ONE] forKey:@"tag"];
    [dic setValue:[NSNumber numberWithInt:nowPageNum] forKey:@"pageNumber"];
    [dic setValue:[NSNumber numberWithInt:0] forKey:@"orderType"];
    [dic setValue:[NSString stringWithFormat:@"3"] forKey:@"gender"];
    
    if (self.flagForBrandOrShop == 1) {
        [dic setValue:self.brandID forKey:@"brandId"];
    }else  if(self.flagForBrandOrShop == 2){
       [dic setValue:self.shopID forKey:@"marketID"];
    }else if(self.flagForBrandOrShop ==3){
        [dic setValue:self.leiBieStr forKey:@"styleTypeName"];
        [dic setValue:self.type forKey:@"type"];
    }else{
        [dic setValue:self.leiBieStr forKey:@"styleTypeName"];

    }
    
    self.shaiXuanDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    
    [self requestDataByBSwithDic:dic];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    
    self.productsArray = [NSMutableArray array];
    
    self.allSelectBut.selected = YES;
    
    self.productTableView.frame = CGRectMake(0, 44, 320, IPHONE_HEIGHT - 49 - 44);
    
    nowPageNum = 1;
    _reloading = NO;
    
    self.conditionLable.text = self.conditionStr;
    
    [self requestData];
    
    //移除旧通知,注册新通知(关于筛选)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shaixuanProductList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaixuanAcation:) name:@"shaixuanProductList" object:nil];

}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:topBackgroungImageView];
    self.navigationController.navigationBarHidden = NO;
}


- (void) requestData{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,PRODUCT_LIST];
    NSString *productType = @"0";
    
    if ([Util isLogin]) {
        [self dataSorceByBrandIdPage:[Util  getLoginName]
                            password:[Util getPassword]
                          pageNumber:[NSNumber numberWithInt:nowPageNum]
                            cityName:[Util getBrowerCity]
                          productUrl:urlString
                         productType:productType
                           orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                              Gender:[NSString stringWithFormat:@"%d",flagForSex]];
    }else{
        [self dataSorceByBrandIdPage:USERNAME
                            password:PASSWORD
                          pageNumber:[NSNumber numberWithInt:nowPageNum]
                            cityName:[Util getBrowerCity]
                          productUrl:urlString
                         productType:productType
                           orderType:[NSString stringWithFormat:@"%d",flagForButtonSelected]
                              Gender:[NSString stringWithFormat:@"%d",flagForSex]];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_type release];
    [_conditionLable release];
    [topBackgroungImageView release];
    [_styleTypeName release];
    [_productTableView release];
    [_viewForButon release];
    [_productsArray release];
    [_brandID release];
    [_shopID release];
    [_leiBieStr release];
    [_shaiXuanDic release];
    [_shaiXuanBut release];
    [_allSelectBut release];
    [_wanSelectBut release];
    [_womenSelectBut release];
    [_priceOrderBut release];
    [_discountPriceOrderBut release];
    
    for (ASIFormDataRequest *request in [ASIFormDataRequest sharedQueue].operations) {
        [request clearDelegatesAndCancel];
    }
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProductTableView:nil];
    [self setViewForButon:nil];
    [self setShaiXuanBut:nil];
    [self setAllSelectBut:nil];
    [self setWanSelectBut:nil];
    [self setWomenSelectBut:nil];
    [self setPriceOrderBut:nil];
    [self setDiscountPriceOrderBut:nil];
    [super viewDidUnload];
}
@end
