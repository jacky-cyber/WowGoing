//
//  QHViewController.m
//  MYWowGoing
//
//  Created by wkf on 12-12-18.
//
//

#import "QHViewController.h"
#import "ShoppeTakeCell.h"
#import "NoYetPayCell.h"
#import "PayCell.h"
#import "ShopInforVC.h"
#import "ShoppingTicketVC.h"
#import "ShopInfoDetailViewController.h"
#import "ProductDetailViewController_Detail2.h"
#import "ShopIntroduceVC.h"
#import "GetCommodiyCell.h"
#import "FnalStatementVC.h"
#import "PayByWgoingVC.h"
#import "ProductViewController.h"
#import "LKCustomTabBar.h"
#import "CancelReasonViewController.h"
#import "EvaluationViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import <ShareSDK/ShareSDK.h>
 
#import "NetworkUtil.h"
#import "RegisterView.h"
#import "CheckStockBS.h"
#import "Request.h"

#import "LoginViewController.h"
#import "DateUtil.h"

#import "MobClick.h"
@interface QHViewController ()<CancleReasonProtocol>
{
     BOOL   isMember;

}

@property (retain, nonatomic) IBOutlet UITableView *produceTableView;

@property (retain, nonatomic) IBOutlet UILabel *costiomCountLable;
@property (retain, nonatomic) IBOutlet UIButton *noPayBut;
@property (retain, nonatomic) IBOutlet UIButton *waitTakeBut;
@property (retain, nonatomic) IBOutlet UIButton *hadTakenBut;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UILabel *totalMoneyLable;
@property (retain, nonatomic) IBOutlet UIImageView *duiGouImage;
@property (retain, nonatomic) IBOutlet UIButton *allBut;

@property (assign,nonatomic) int  sumMoney;
@property (retain,nonatomic) NSMutableDictionary  *stockResultDic;

@property (retain,nonatomic) NSMutableDictionary  *stateForPayOnLineDic;


@property (nonatomic,retain) NSMutableDictionary  *staeForShanChuBut;

@property (copy, nonatomic) NSString *orderId;
@property (retain,nonatomic) NSMutableArray *productArray;
@property (assign ,nonatomic) int  selectIndex;

@end

@implementation QHViewController
@synthesize emptImageView;
@synthesize label1;
@synthesize label2;
@synthesize goShopBtn;
@synthesize produceTableView=_produceTableView;
@synthesize detailViewController=_detailViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark
#pragma mark   *********CancleReasonProtocol*********

- (void) cancleReasonProtocolMethed{
  
    [self deleteOrderRequest:self.selectIndex];
    
}


- (IBAction)editAction:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    [self showAllShanChuButOnCell:button.selected];
    
}

- (void) showAllShanChuButOnCell:(BOOL)isEdit{
    
    [self.staeForShanChuBut removeAllObjects];
    
    int  count = self.productArray.count;

    for (int i = 0; i < count ; i++) {
            if (isEdit) {
                [self.staeForShanChuBut setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
            }else{
                 [self.staeForShanChuBut  removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
            }
    }
    
    [self.produceTableView reloadData];
}


- (IBAction)selectAllProducts:(id)sender {
    
    UIButton * button = (UIButton*)sender;
    button.selected = !button.selected;
    
    int productsCount = 0;
    if (button.selected)
    {
            _duiGouImage.hidden = NO;
    
            productsCount = self.productArray.count;
            
            for (int i = 0; i < productsCount; i ++)
            {
                                
                 [self.stateForPayOnLineDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
    
            }

             self.sumMoney = [self calculateTotalAmount:self.productArray];
             self.totalMoneyLable.text=[NSString stringWithFormat:@"￥%d",self.sumMoney];
        }
     else{
        
           _duiGouImage.hidden = YES;
            [self.stateForPayOnLineDic  removeAllObjects];
            self.totalMoneyLable.text = @"￥0";
            self.sumMoney = 0;
     }
    
    [self.produceTableView reloadData];
}

- (void)selectButtonPressAtion:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    NoYetPayCell  *cell =(NoYetPayCell*) [self.produceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 300  inSection:0]];
    if (sender.selected) {
        
        if (cell.selectButton.enabled) {
            [self.stateForPayOnLineDic  setValue:@"1" forKey:[NSString stringWithFormat:@"%d",sender.tag - 300]];
            
            NSDictionary *dic=[self.productArray  objectAtIndex:sender.tag - 300];
            if (isMember) {
                self.sumMoney+=[[dic objectForKey:@"memberPrice"] intValue];
            }else{
                self.sumMoney+=[[dic objectForKey:@"discountPrice"] intValue];
            }
            
            if (self.stateForPayOnLineDic.count == self.productArray.count) {
                _duiGouImage.hidden = NO;
                self.allBut.selected = YES;
            }

        }
    }else{
        _duiGouImage.hidden = YES;
        self.allBut.selected = NO;
        
            [self.stateForPayOnLineDic  removeObjectForKey:[NSString stringWithFormat:@"%d",sender.tag - 300]];
            
           NSDictionary *dic=[self.productArray  objectAtIndex:sender.tag - 300];
           if (isMember) {
                self.sumMoney-= [[dic objectForKey:@"memberPrice"] intValue];
           }else{
            self.sumMoney-=[[dic objectForKey:@"discountPrice"] intValue];
          }
        
    }
    
          self.totalMoneyLable.text = [NSString stringWithFormat:@"￥%d",self.sumMoney];
    
}

- (IBAction)jieSuanAction:(id)sender {
    
    if (self.stateForPayOnLineDic == nil || self.stateForPayOnLineDic.count == 0) {
      
         [self.view makeToast:@"请选中您要结算的产品" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    NSMutableArray   *activityArray = [self getActivityArray];
    NSMutableArray   *orderArray = [self getOrderIDArray];
    NSMutableArray   *strsizeArray = [self getStrSizeArray];
    
    [self checkProductsStockWithActivityArray:activityArray andOrderIdArray:orderArray andStrsizeArray:strsizeArray];
    
}


- (IBAction)noPayButPressAction:(id)sender {
    UIButton *buttonNoPay = (UIButton*)sender;
    if (!buttonNoPay.selected) {
        buttonNoPay.selected = YES;
        self.waitTakeBut.selected = NO;
        self.hadTakenBut.selected = NO;
       
        if (iPhone5) {
            _bottomView.frame = CGRectMake(0, 415, 320, 38);
        }else{
            _bottomView.frame = CGRectMake(0, 330, 320, 38);
        }

        [self requestData:1 requestTag:CART_REQUEST_FRIST];
    }
}

- (IBAction)waitTakeButPressAction:(id)sender {
    UIButton *buttonwaitTake= (UIButton*)sender;
    if (!buttonwaitTake.selected) {
        buttonwaitTake.selected = YES;
        self.noPayBut.selected = NO;
        self.hadTakenBut.selected = NO;
        _bottomView.hidden = YES;
         [self requestData:1 requestTag:CART_REQUEST_FRIST];
    }

}

- (IBAction)hadTakenPressAction:(id)sender {
    UIButton *buttonhadTaken= (UIButton*)sender;
    if (!buttonhadTaken.selected) {
        buttonhadTaken.selected = YES;
        self.noPayBut.selected = NO;
        self.waitTakeBut.selected = NO;
        _bottomView.hidden = YES;
        [self requestData:1 requestTag:CART_REQUEST_FRIST];
    }
}


- (void) checkProductsStockWithActivityArray:(NSMutableArray*)activityArray andOrderIdArray:(NSMutableArray*)orderIdArray andStrsizeArray:(NSMutableArray*)strsizeArray{
    
    CheckStockBS   *checkStockBS = [[[CheckStockBS alloc ]init ] autorelease];
    checkStockBS.delegate = self;
    checkStockBS.type = 1;
    checkStockBS.isNoPay = YES;
    checkStockBS.activityArray = activityArray;
    checkStockBS.orderIDArray = orderIdArray;
    [checkStockBS setOnSuccessSeletor:@selector(checkProductsStockWithOrderStringsFinished:)];
    [checkStockBS setOnFaultSeletor:@selector(checkProductsStockWithOrderStringsFault:)];
    [checkStockBS asyncExecute];
}

- (void) checkProductsStockWithOrderStringsFinished:(ASIFormDataRequest *)requestForm{
    
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
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
     
         [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
    if (dic == NULL  ) {
         [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
    
    self.stockResultDic = dic;
    [self payOnlineAction];
    

}

- (void) checkProductsStockWithOrderStringsFault:(ASIFormDataRequest*)request{
    
    [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
    
}

- (void) payOnlineAction{
    
    float  wowgoingAcount=[[self.stockResultDic objectForKey:@"wowgoingAccount"] floatValue];// wowgoing账户余额
    float   price=[[self.stockResultDic objectForKey:@"countPrice"] floatValue];  //所选商品总价
    
    NSMutableArray *productArray = [self.stockResultDic objectForKey:@"toSettleDetail"];
    
    if (wowgoingAcount>=price) {
        PayByWgoingVC *payVC=[PayByWgoingVC shareFnalStatementController];
        [payVC  set_isCartList:NO];
        [payVC set_shouYe:NO];
        [payVC set_notPay:YES];
        payVC.productsArray=productArray;//商品数组
        
        payVC.productDic = self.stockResultDic;
        
        [self.navigationController pushViewController:payVC animated:YES];
        self.navigationController.navigationBarHidden=YES;
        
    }else{
        
        FnalStatementVC *fnalVC=[FnalStatementVC shareFnalStatementController];
        
        fnalVC.productsArray=productArray;//商品数组
        [fnalVC  set_isCartList:NO];
        [fnalVC set_shouYe:NO];
        [fnalVC set_notPay:YES];
        fnalVC.productDic = self.stockResultDic;
        
        [self.navigationController pushViewController:fnalVC animated:YES];
        self.navigationController.navigationBarHidden=YES;
    }
    
}

#pragma mark
#pragma mark   ************获取选中产品的活动ID***********
- (NSMutableArray*)getActivityArray{
    NSMutableArray *activityArray = [NSMutableArray array];
    NSArray *keyArray = [self.stateForPayOnLineDic allKeys];
    
    int count = keyArray.count;
    for (int i = 0; i < count ; i++ ) {
        int index = [[keyArray objectAtIndex:i] intValue];
        NSString *activityString = [[self.productArray objectAtIndex:index] objectForKey:@"activityId"];
        
        [activityArray addObject:[NSNumber numberWithInteger:[activityString integerValue]]];
    }
    
    return  activityArray;
}

#pragma mark
#pragma mark   ************获取选中产品的订单ID***********
- (NSMutableArray*)getOrderIDArray{
    NSMutableArray *orderIDArray = [NSMutableArray array];
    NSArray *keyArray = nil;

    keyArray = [self.stateForPayOnLineDic allKeys];
   
    int count = keyArray.count;
    for (int i = 0; i < count ; i++ ) {
        int index = [[keyArray objectAtIndex:i] intValue];
        NSString *activityString = nil;
        
        activityString = [[self.productArray objectAtIndex:index] objectForKey:@"orderId"];
        
        [orderIDArray addObject:[NSNumber numberWithInteger:[activityString integerValue]]];
    }
    
    return  orderIDArray;
}


- (NSMutableArray*)getStrSizeArray{
    NSMutableArray *strsizeArray = [NSMutableArray array];
    NSArray *keyArray = nil;
    
    keyArray = [self.stateForPayOnLineDic allKeys];
    
    int count = keyArray.count;
    for (int i = 0; i < count ; i++ ) {
        int index = [[keyArray objectAtIndex:i] intValue];
        NSString *activityString = nil;
        
        activityString = [[self.productArray objectAtIndex:index] objectForKey:@"strsize"];
        
        [strsizeArray addObject:activityString];
    }
    
    return  strsizeArray;
}


-(void)loadTableview
{
    _produceTableView.hidden = YES;
    nowPageNum=1;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [LKCustomTabBar shareTabBar].currentSelectedIndex = 3;
    
    BOOL netWork = [NetworkUtil canConnect];
    if (!netWork && [Util isLogin]) {    //有网络显示headerview
        self.costiomCountLable.text = [NSString stringWithFormat:@"取货账号:%@",[Util  getCustomerID]];
        self.productArray = [Util getShoppeArray];
        if (self.productArray.count != 0) {
            _produceTableView.hidden =NO;
            self.emptImageView.hidden = YES;
            self.label1.hidden = YES;
            self.label2.hidden = YES;
            self.goShopBtn.hidden = YES;
            self.waitTakeBut.selected = YES;
            [self.produceTableView reloadData];
        }
    }else{
    
        //    判断是否登录
        if ([Util isLogin]) {
            
          self.costiomCountLable.text = [NSString stringWithFormat:@"取货账号:%@",[Util  getCustomerID]];
            
            NSArray *array  = [Util getShoppeArray];
            int count = array.count;
            
            if (count<1) {
                _produceTableView.hidden =YES;
                self.emptImageView.hidden = NO;
                self.label1.hidden = NO;
                self.label2.hidden = NO;
                self.goShopBtn.hidden = NO;
                self.waitTakeBut.selected = YES;
                self.hadTakenBut.selected = NO;
                self.noPayBut.selected= NO;
              _bottomView.hidden = YES;
                [self requestData:1 requestTag:CART_REQUEST_FRIST];
            }
            else
            {
                _produceTableView.hidden =NO;
                self.emptImageView.hidden = YES;
                self.label1.hidden = YES;
                self.label2.hidden = YES;
                self.goShopBtn.hidden = YES;
                
                if (self.waitTakeBut.selected) {
                    self.hadTakenBut.selected = NO;
                    self.noPayBut.selected = NO;
                }else if(self.noPayBut.selected){
                    self.hadTakenBut.selected = NO;
                    self.waitTakeBut.selected = NO;
                    self.bottomView.hidden = NO;
                }else if(self.hadTakenBut.selected){
                    
                    self.noPayBut.selected = NO;
                    self.waitTakeBut.selected = NO;
                    
                }else{
                    
                    self.waitTakeBut.selected = YES;
                    
                }
                
                [self requestData:1 requestTag:CART_REQUEST_FRIST];
            }
        } else
        {
            _produceTableView.hidden = YES;
            UIAlertView *custom=[[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录,请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",@"注册",nil] autorelease];
            custom.tag = 34783;
            [custom show];
        }
        self.navigationController.navigationBarHidden=NO;

    }
}

- (void)viewDidLoad
{
    [MobClick event:@"quhuo"];//专柜取货事件统计ID
    [super viewDidLoad];
    
    self.productArray = [NSMutableArray array];
    self.stateForPayOnLineDic = [NSMutableDictionary dictionary];
    self.stockResultDic = [NSMutableDictionary dictionary];
    self.staeForShanChuBut = [NSMutableDictionary dictionary];
    
    self.produceTableView.frame = CGRectMake(0, 64, 320, IPHONE_HEIGHT - 64 - 49 - 20 - 44);
    
    UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
    

    [self.view addSubview:titbackImageview];
    [titbackImageview release];
    [self loadTableview];
    
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

//店铺介绍
- (IBAction)shopIntroduce:(id)sender {
    
   ShopIntroduceVC  *shopInfoVC = [[[ShopIntroduceVC alloc ]initWithNibName:@"ShopIntroduceVC" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:shopInfoVC animated:YES];
    self.navigationController.navigationBarHidden=YES;
}

//去购物  跳转到首页
- (IBAction)goShoppingAction:(id)sender {
    UIButton *button=(UIButton*)[self.view viewWithTag:0];
    [[LKCustomTabBar shareTabBar] selectedTab:button];
    [LKCustomTabBar shareTabBar].currentSelectedIndex=0;
}


#pragma mark
#pragma mark     *******UITableViewDelegate/UITableViewDataSource*********
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.noPayBut.selected) {
        return 132;
    }else if (self.waitTakeBut.selected){
        return 188;
    }else{
        return 170;
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([Util isLogin]) {
        return  self.productArray.count;
    }else
    {
        return  0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.noPayBut.selected)   // 未付款 
    {
        static NSString *identify=@"Cell";
        NoYetPayCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell==nil) {
            NSArray *cellArray = [[NSBundle mainBundle]  loadNibNamed:@"NoYetPayCell" owner:self options:nil];
            for (id oneObject in cellArray) {
                if ([oneObject isKindOfClass:[NoYetPayCell class]]) {
                    cell = (NoYetPayCell *)oneObject;
                }
            }
           
            cell.productImage = [[[AsyncImageView alloc ]initWithFrame:CGRectMake(34, 31, 90, 90)] autorelease];
            cell.productImage.userInteractionEnabled = YES;
            [cell addSubview:cell.productImage];
           
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            [cell prepareForReuse];
        }
        NSDictionary *productDic = [[Util takeNoPayArray] objectAtIndex:indexPath.row];
        
        
        
        NSString  *inputTimeStr = [productDic   objectForKey:@"takeTimeStr"];
    
        cell.lastTimeLable.text = [NSString stringWithFormat:@"最晚付款时间%@",[self getMyTime:inputTimeStr]];
            
    
        //商品图片显示
        NSString *picString=[productDic objectForKey:@"picUrl"];
        if (picString==nil || [picString isEqualToString:@""]) {
            [cell.productImage setImage:[UIImage imageNamed:@"名品折扣logo水印.png"]];
        }else{
            cell.productImage.urlString=[productDic objectForKey:@"picUrl"];
        }
        cell.productImage.tag=indexPath.row+99999;
        [cell.productImage addTarget:self action:@selector(productDetail:) forControlEvents:UIControlEventTouchUpInside];//点击商品图片后进入商品的详情页
        
        //是否选择商品按钮
        [cell.selectButton addTarget:self action:@selector(selectButtonPressAtion:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectButton.tag = indexPath.row +300;
        
        NSString * flagString = [self.stateForPayOnLineDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];

        if ([flagString isEqualToString:@"1"]) {   //选中后设置背景图片
            cell.selectButton.selected = YES;
        }else{   //取消选中后更换背景图片
            cell.selectButton.selected = NO;
        }
        
        //商品的名称
        NSString *content=[productDic objectForKey:@"productName"];
        //    CGRect rect=cell.productNameLable.frame;
        //    cell.productNameLable.numberOfLines=2;
        //    CGSize size=[content sizeWithFont:cell.productNameLable.font constrainedToSize:CGSizeMake(175, 1000) lineBreakMode:UILineBreakModeWordWrap];
        //    rect.size.height=size.height;
        //    cell.productNameLable.frame=rect;
        cell.productNameLable.text=content;
        
        //商品的颜色、尺寸、折扣的综合信息
        //    cell.colorAndSizeLable.frame=CGRectMake(127, cell.productNameLable.frame.origin.y+rect.size.height, 175, 20);
        NSString *sizeString=[productDic objectForKey:@"strsize"];//尺寸
        NSString *colorString=[productDic objectForKey:@"color"];//颜色
        NSString *discountString=[productDic objectForKey:@"discount"];//折扣
        cell.colorAndSizeLable.text=[NSString stringWithFormat:@"%@/%@码/%@折",colorString,sizeString,discountString];
        
        //商品价格
        
        NSString *memberPrice = [productDic objectForKey:@"memberPrice"];
        if (!isMember) {
            cell.priceLable.text=[NSString  stringWithFormat:@"￥%@",[productDic objectForKey:@"discountPrice"]];
        }else{
            cell.priceLable.text=[NSString  stringWithFormat:@"￥%@",memberPrice];
        }

        //取货店铺的地址
        NSString *contentAddress=[NSString stringWithFormat:@"取货店铺:%@",[productDic objectForKey:@"address"]];
        cell.addressLabe.numberOfLines= 0;

        CGSize sizeAddress=[contentAddress sizeWithFont:cell.addressLabe.font constrainedToSize:CGSizeMake(145,100) lineBreakMode:UILineBreakModeWordWrap];
        cell.addressLabe.frame=CGRectMake(cell.colorAndSizeLable.frame.origin.x, cell.priceLable.frame.origin.y+cell.priceLable.frame.size.height,sizeAddress.width,sizeAddress.height);
        cell.addressLabe.text=contentAddress;
        cell.addressLabe.textColor = [UIColor colorWithRed:138.0/255.0 green:91.0/255.0 blue:10.0/255.0 alpha:1.0];
        
        //放大镜图片
        cell.magnifierImage.frame=CGRectMake(cell.addressLabe.frame.origin.x+sizeAddress.width, cell.addressLabe.frame.origin.y,20,20);
        
        //查看取货店铺按钮
        cell.addressButton.frame=CGRectMake(cell.addressLabe.frame.origin.x, cell.addressLabe.frame.origin.y, cell.addressLabe.frame.size.width+30, cell.addressLabe.frame.size.height+30);
        cell.addressButton.tag=indexPath.row+1782;
        [cell.addressButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        
                
        [cell.deleteButton addTarget:self action:@selector(deleteExecuteByCancleBut:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag = indexPath.row;
        
        [cell.shanChuBut addTarget:self action:@selector(deleteExecuteByCancleBut:) forControlEvents:UIControlEventTouchUpInside];
        cell.shanChuBut.tag = indexPath.row;
        
        
        
        NSString *stateString = [self.staeForShanChuBut objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        if ([stateString isEqualToString:@"1"]) {
            cell.shanChuBut.hidden = NO;
            cell.deleteButton.hidden = YES;
        }else{
        
            cell.shanChuBut.hidden = YES;
            cell.deleteButton.hidden= NO;
        }
            
       CGRect cellframe=cell.frame;
        cellframe.size.height=cell.productNameLable.frame.size.height+cell.colorAndSizeLable.frame.size.height+cell.addressLabe.frame.size.height;
       if (cellframe.size.height>=cell.productImage.frame.size.height) {
             [cell setFrame:CGRectMake(cellframe.origin.x, cellframe.origin.y, cellframe.size.width, cellframe.size.height)];
         }else{
               [cell setFrame:CGRectMake(cellframe.origin.x, cellframe.origin.y, cellframe.size.width, cell.productImage.frame.size.height+10)];
         }
        
        return cell;

    } else if (self.waitTakeBut.selected)  //待取货
    {
        static NSString *CellIdentifier = @"GetCommodiyCell";
        GetCommodiyCell *cell = (GetCommodiyCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GetCommodiyCell" owner:self options:nil];
            cell = (GetCommodiyCell *)[nib objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
            cell.magnifierBtn.tag = indexPath.row + 1782;
            [cell.magnifierBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.returnedBtn.tag  = indexPath.row+12312;
        
        
          NSString *payState=[[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"payType"];
        
         NSString  *inputTimeStr = [[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"takeTimeStr"];
        
          if ([payState intValue] !=2) {
              
              cell.dueLabel.text = [NSString stringWithFormat:@"最晚取货日期%@",[DateUtil getMyTime:inputTimeStr]];
              
          }else{
          
              cell.dueLabel.text = [NSString stringWithFormat:@"最晚发货日期%@",[DateUtil getMyTime:inputTimeStr]];
          }
    
            cell.commodityNameLabel.text = [[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"productName"];
            
        NSString  *payString  = [[[Util getShoppeArray ] objectAtIndex:indexPath.row] objectForKey:@"orderContent"];
            
           CGSize size = [payString sizeWithFont:cell.wayOfPay.font constrainedToSize:CGSizeMake(200, 21) lineBreakMode:NSLineBreakByWordWrapping];
           cell.wayOfPay.frame = CGRectMake(cell.wayOfPay.frame.origin.x, cell.wayOfPay.frame.origin.y, size.width, cell.wayOfPay.frame.size.height);
        
           cell.wayOfPay.text = payString;
           cell.moneyLabel.frame = CGRectMake(cell.wayOfPay.frame.origin.x + size.width +3, cell.wayOfPay.frame.origin.y, cell.moneyLabel.frame.size.width, cell.moneyLabel.frame.size.height);
        
            cell.moneyLabel.text=[NSString  stringWithFormat:@"￥%@",[[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"discountPrice"]];
       
            NSString  *color   = [[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"color"];
            NSString  *sizestr = [[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"strsize"];
            NSString  *discount= [[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"discount"];
              
            cell.concessionalLabel.text = [NSString stringWithFormat:@"%@/%@/%@折",color,sizestr,discount];  //颜色/尺码/折扣
              NSDate* now = [NSDate date];
              NSString  * currStm = [self stringFromDate:now];//获取当前时间的字符串
              [DateUtil getMyTime:currStm];

              NSString  *createTimeStr = [[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"createTimeStr"];
        
              [DateUtil getMyTime:createTimeStr];
              if ([[DateUtil getMyTime:currStm] isEqualToString:[DateUtil getMyTime:createTimeStr]]) {
              }else
              {
                  cell.todayImageView.hidden = YES;
              }
        
            NSString  *contentAddress = nil;
              if ([payState intValue] == 2) {
                  contentAddress = [NSString stringWithFormat:@"邮寄店铺:%@",[[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"address"]];
               }else{
                   contentAddress = [NSString stringWithFormat:@"取货店铺:%@",[[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"address"]];
                 }
        
            //取货店铺的地址
              cell.shoppingAddressLabel.numberOfLines= 0;
        
              CGSize sizeAddress=[contentAddress sizeWithFont:cell.shoppingAddressLabel.font constrainedToSize:CGSizeMake(170,100) lineBreakMode:UILineBreakModeWordWrap];
              cell.shoppingAddressLabel.frame=CGRectMake(cell.concessionalLabel.frame.origin.x, cell.moneyLabel.frame.origin.y+cell.moneyLabel.frame.size.height,sizeAddress.width,sizeAddress.height);
              cell.shoppingAddressLabel.text=contentAddress;
              cell.shoppingAddressLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:91.0/255.0 blue:10.0/255.0 alpha:1.0];
        
           //放大镜图片
             cell.magnifierImage.frame=CGRectMake(cell.shoppingAddressLabel.frame.origin.x+sizeAddress.width, cell.shoppingAddressLabel.frame.origin.y,20,20);
        
         //查看取货店铺按钮
            cell.magnifierBtn.frame=CGRectMake(cell.shoppingAddressLabel.frame.origin.x, cell.shoppingAddressLabel.frame.origin.y, cell.shoppingAddressLabel.frame.size.width+30, cell.shoppingAddressLabel.frame.size.height+30);
             cell.magnifierBtn.tag=indexPath.row+1782;
            [cell.magnifierBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];

        
              [cell.commodityLogo setImageWithURL:[NSURL URLWithString:[[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"名品折扣logo水印"]];
              
              cell.commodityBut.tag=indexPath.row+99999;
              [cell.commodityBut addTarget:self action:@selector(productDetail:) forControlEvents:UIControlEventTouchUpInside];
              
              if (!cell.returnedBtn.selected) {
                  [cell.returnedBtn setTitle:@"我要取货" forState:UIControlStateNormal];
              }
              [cell.returnedBtn addTarget:self action:@selector(getNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        
            [cell.shanChuBut addTarget:self action:@selector(deleteExecuteByCancleBut:) forControlEvents:UIControlEventTouchUpInside];
            cell.shanChuBut.tag = indexPath.row;
        
          NSString *stateString = [self.staeForShanChuBut objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        
          if ([stateString isEqualToString:@"1"]) {
              cell.shanChuBut.hidden = NO;
           }else{
              cell.shanChuBut.hidden = YES;
            }
              return cell;
        
    }else{       // 已取货
    
        static NSString *customCell = @"customCell";
        PayCell *cell = (PayCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
        
        if (cell == nil) {
            //如果没有可重用的单元，我们就从nib里面加载一个，
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PayCell"
                                                         owner:self options:nil];
            //迭代nib重的所有对象来查找NewCell类的一个实例
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[PayCell class]]) {
                    cell = (PayCell *)oneObject;
                }
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        //产品logog
        [cell.productLogo setImageWithURL:[NSURL URLWithString:[[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"限时抢购logo水印"]];
    
        //产品名字
        cell.productName.text = [[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"productName"];
        
        NSString  *color   = [[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"color"];
        if (![color isKindOfClass:[NSString class]]) {
            color = @"";
            
        }
        NSString  *sizestr = [[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"strsize"];
        NSString  *discount= [[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"discount"];
        
        //颜色/尺码/折扣
        cell.sizeLabel.text = [NSString stringWithFormat:@"%@/%@/%@折",color,sizestr,discount];
       
        //总价也就是折扣价
            
        cell.priceLabel.text = [NSString stringWithFormat:@"%@", [[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"discountPrice"]];

        //取货时间
        NSDate *takeDate = [DateUtil stringToDate:[[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"takeTimeStr"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *takeDateString = [DateUtil dateToString:takeDate withFormat:@"YYYY年MM月dd日 HH:mm"];
        
        cell.takeLab.text =[NSString stringWithFormat:@"您已于%@到%@取货,交易完成",takeDateString,[[[Util takeHadTakenArray] objectAtIndex:indexPath.row] objectForKey:@"address"]];
        cell.shareBtn.tag = indexPath.row+8720;
        [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.slipBtn.tag = indexPath.row+8721;
        [cell.slipBtn addTarget:self action:@selector(slipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
       int   isTips = [[[[Util takeHadTakenArray]  objectAtIndex:indexPath.row]  objectForKey:@"isTips"] integerValue];
        
        if (isTips == 0) {
            [cell.commentBut addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
        
            [cell.commentBut setBackgroundImage:[UIImage imageNamed:@"已评价.png"] forState:UIControlStateNormal];
            cell.commentBut.enabled = NO;
        }
        cell.commentBut.tag = indexPath.row +8723;
        
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.hadTakenBut.selected) {
         return  NO;
    }else{
        return YES;
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==  UITableViewCellEditingStyleDelete) {
        
        if (self.waitTakeBut.selected) {
            CancelReasonViewController  *cancelVC = [[[CancelReasonViewController alloc ]initWithNibName:@"CancelReasonViewController" bundle:nil] autorelease];
            
            cancelVC.productDic = [self.productArray objectAtIndex:indexPath.row];
            self.selectIndex = indexPath.row;
            cancelVC.delegate = self;
            [self presentModalViewController:cancelVC animated:YES];
        }else{
        
            [self deleteOrderRequest:indexPath.row];
        }
        
    }
    
}


#pragma mark
#pragma mark    **************分享操作*****************
- (void) shareAction:(UIButton*)sender{
    UIButton  *btn = (UIButton*)sender;
    
    int  index = btn.tag-8720;
    
    NSDictionary  *dic  = [[Util takeHadTakenArray]  objectAtIndex:index];
    
    NSString *prodeuctName=[dic objectForKey:@"productName"];//产品名
    NSString *address=[dic objectForKey:@"address"];//取货店铺
    NSString *discount=[dic objectForKey:@"discount"];//折扣
    
    NSString *shareString=[NSString stringWithFormat:@"我在%@买了正品%@,%@折,只有在WowGoing才可以享受折扣哦！你羡慕吧！http://www.wowgoing.com",address,prodeuctName,discount];
    
    NSURL *imageUrl = [NSURL URLWithString:[dic objectForKey:@"picUrl"]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/iphone",WX_SEVERURL];
    id<ISSContent>publishContent=[ShareSDK content:shareString
                                    defaultContent:shareString
                                             image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl]
                                                                  fileName:nil
                                                                  mimeType:nil]
                                             title:nil
                                               url:nil
                                       description:nil
                                         mediaType:SSPublishContentMediaTypeNews];
    
    
    //需要定制分享视图的显示属性，使用以下接口
    id<ISSContainer>container=[ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:nil authManagerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,nil] content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                          oneKeyShareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,nil]
                                                           qqButtonHidden:YES
                                                    wxSessionButtonHidden:YES
                                                   wxTimelineButtonHidden:YES
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:nil
                                                      friendsViewDelegate:nil
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"发送成功");
                                }
                                else
                                {
                                    NSLog(@"发送失败");
                                }
                                
                            }];
    
    //定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeApp]
                                         content:shareString
                                           title:@"购引"
                                             url:urlString
                                           image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl]
                                                                fileName:nil mimeType:nil]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeApp]
                                          content:shareString
                                            title:@"购引"
                                              url:urlString
                                            image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl]
                                                                 fileName:nil mimeType:nil]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];

}


#pragma mark
#pragma mark     *************购物小票***************
//购物小票
- (void) slipBtnAction:(UIButton*)sender{
    UIButton  *btn = (UIButton*)sender;
    int  index = btn.tag-8721;
    NSDictionary  *dic  = [[Util takeHadTakenArray] objectAtIndex:index];
    NSString *orderId = [dic objectForKey:@"orderId"];
    [self requestTickData:orderId];

}

//购物小票请求
- (void)requestTickData:(NSString *)orderNum
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    NSMutableDictionary *jsonreq =[NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:orderNum forKey:@"orderId"];
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,HISTORY_PRINTCARD];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setTimeOutSeconds:8];
    [requestForm startAsynchronous];
    [requestForm setDidFinishSelector:@selector(requestTickDataSucess:)];
    [requestForm setDidFailSelector:@selector(requestTickDataloginFail:)];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}


- (void)requestTickDataloginFail:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
     [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
}

- (void)requestTickDataSucess:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
    if (responseStatus!=200 ) {
        
        return;
    }
    else
    {
        ShoppingTicketVC   *sTicketVc = [[[ShoppingTicketVC alloc] initWithNibName:@"ShoppingTicketVC" bundle:nil] autorelease];
        sTicketVc.tickDic = dic;
        [self.navigationController pushViewController:sTicketVc animated:YES];
    }
    
}


#pragma mark
#pragma mark   **********评价*************
//评价
- (void) commentAction:(UIButton*)sender{
    
    EvaluationViewController   *evaluationVC = [[[EvaluationViewController alloc ]initWithNibName:@"EvaluationViewController" bundle:nil] autorelease];
    evaluationVC.productDic = (NSMutableDictionary*)[[Util takeHadTakenArray]  objectAtIndex:sender.tag - 8723];
    [self.navigationController pushViewController:evaluationVC animated:YES];
    
}


#pragma mark   
#pragma mark     *********跳转至商品详情**************
//跳转至产品详情
-(void)productDetail:(UIButton*)sender{
    
    ProductDetailViewController_Detail2 *prodetailVC = [[[ProductDetailViewController_Detail2 alloc] initWithNibName:@"ProductDetailViewController_Detail2" bundle:nil] autorelease];
    
    prodetailVC.activityId = [[[self.productArray objectAtIndex:sender.tag - 99999] objectForKey:@"activityId"]  intValue];
    prodetailVC.productId =  [[[self.productArray objectAtIndex:sender.tag - 99999] objectForKey:@"productId"] intValue];
    
    NSLog(@"%d,%d",prodetailVC.activityId,prodetailVC.productId);

    [self.navigationController pushViewController:prodetailVC animated:YES];
   
}


#pragma mark
#pragma mark    ***********获取取货码/退货码*********
-(void)getNumber:(id)sender
{
    assert(sender && [sender isKindOfClass:[UIButton class]]);
    UIButton  *btn = (UIButton*)sender;
    int row =  btn.tag-12312;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    GetCommodiyCell *cell = (GetCommodiyCell*)[self.produceTableView cellForRowAtIndexPath:indexPath];
    
    if (cell.returnedBtn.isSelected == NO) {
        cell.getCommodiyNum.text =[NSString stringWithFormat:@"取货码:%@",[[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"takeCode"]];
        [cell.returnedBtn setTitle:@"我要退货" forState:UIControlStateNormal];
        [cell.returnedBtn setSelected:YES];
    }else
    {
        cell.getCommodiyNum.text = [NSString stringWithFormat:@"退货码:%@",[[[Util getShoppeArray] objectAtIndex:indexPath.row] objectForKey:@"returnCode"]];;
        [cell.returnedBtn setTitle:@"我要取货" forState:UIControlStateNormal];
        [cell.returnedBtn setSelected:NO];
    }

    [cell.returnedBtn setBackgroundImage:[UIImage imageNamed:@"白色按钮_正常.png"] forState:UIControlStateNormal];
}


#pragma mark
#pragma mark       *********放大镜 跳转至品牌及店铺介绍页面**********
//放大镜
-(void)checkAction:(id)sender
{
    assert(sender && [sender isKindOfClass:[UIButton class]]);
    int index = ((UIButton *)sender).tag - 1782;
    ShopInforVC  *shopInfo = [[[ShopInforVC alloc] initWithNibName:@"ShopInforVC" bundle:nil] autorelease];
    shopInfo.type = 1;
    shopInfo.brandID = [[self.productArray objectAtIndex:index] objectForKey:@"brandId"];
    shopInfo.shopId = [[self.productArray objectAtIndex:index] objectForKey:@"shopId"];
    shopInfo.shopName=[[self.productArray objectAtIndex:index] objectForKey:@"address"];
    shopInfo.activatyID = [[self.productArray objectAtIndex:index] objectForKey:@"activityId"];
    [self.navigationController pushViewController:shopInfo animated:YES];
    self.navigationController.navigationBarHidden=YES;

}
 

#pragma mark
#pragma mark  ***********发送列表数据请求*********
-(void)requestData:(int)pageNumber requestTag:(int)tagNumber
{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];

    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,QH_LIST] ;
    
    if (self.waitTakeBut.selected) {  //等待取货
        [jsonreq setValue:@"3" forKey:@"orderType"];
    }else if (self.noPayBut.selected){  //未付款
        [jsonreq setValue:@"2" forKey:@"orderType"];
    }else if (self.hadTakenBut.selected){  //已取货
        [jsonreq setValue:@"12" forKey:@"orderType"];
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
    requestForm.tag=tagNumber;
    [requestForm setDidFinishSelector:@selector(requestQHFinished:)];
    [requestForm setDidFailSelector:@selector(requestQHFailed:)];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

#pragma mark----ASIHTTPRequest 代理方法
- (void)requestQHFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
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
   
//    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
//    if (!resultStatus)
//    {
//        return;
//    }

    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {

        return;
    }
    
    NSMutableArray *productListArray = [dic objectForKey:@"shoppePickup"];
    
    isMember = [[dic objectForKey:@"IsMember"]  boolValue];
    
    if (!productListArray || ![productListArray isKindOfClass:[NSArray class]])
    {
        return ;
    }
    
     self.productArray = productListArray;
    
    if (request.tag==CART_REQUEST_FRIST||request.tag==CART_REQUEST_PAGE_UPDATE) {
        if (self.noPayBut.selected) {
            [Util saveNoPayArray:productListArray];
        }else if (self.waitTakeBut.selected){
              [Util SaveShoppeArray:productListArray];
        }else{
            [Util saveHadTakenArray:productListArray];
        }
       
    }else if (request.tag==CART_REQUEST_PAGE_NEXT){
        
            if (self.noPayBut.selected) {
                self.productArray= [NSMutableArray arrayWithArray:[Util takeNoPayArray]];             
            }else if (self.waitTakeBut.selected){
               self.productArray=[NSMutableArray arrayWithArray:[Util getShoppeArray]];
            }else{
               self.productArray= [NSMutableArray arrayWithArray:[Util takeHadTakenArray]];
            }
            for (int i=0; i<productListArray.count; i++) {
                [self.productArray addObject:[productListArray objectAtIndex:i]];
            }
            if (self.noPayBut.selected) {
                [Util saveNoPayArray:self.productArray];
            }else if (self.waitTakeBut.selected){
                [Util SaveShoppeArray:self.productArray];
            }else{
                [Util saveHadTakenArray:self.productArray];
            }
        }
    [_produceTableView reloadData];
    
    [self showProductsCount:[Util getShoppeArray].count];
    
    switch (request.tag) {
        case CART_REQUEST_FRIST:
        {
            
            if (productListArray.count<1) {
                _promptlabel1.hidden = NO;
                _promptLabel2.hidden = NO;
                _emptyImageView.hidden = NO;
                _shoppingBtn.hidden = NO;
                if (self.noPayBut.selected) {
                      _bottomView.hidden = YES;
                }
                _produceTableView.hidden = YES;
                return;
            }else
            {
                _promptlabel1.hidden = YES;
                _promptLabel2.hidden = YES;
                _emptyImageView.hidden = YES;
                _shoppingBtn.hidden = YES;
                if (self.noPayBut.selected) {
                    _bottomView.hidden = NO;
                    
                    int count = self.productArray.count;
                    for (int i = 0; i < count; i++) {
                       
                        [self.stateForPayOnLineDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];

                    }
                    
                self.sumMoney = [self calculateTotalAmount:self.productArray];
                 self.totalMoneyLable.text = [NSString stringWithFormat:@"%d",self.sumMoney];
                    
                }
                _produceTableView.hidden = NO;
            }


            
            [self createHeaderView];

            
            [self loadOk];
        }
            break;
        case CART_REQUEST_PAGE_UPDATE:
        {

            [self createHeaderView];

            
            [self loadOk];
        }
            break;
        case CART_REQUEST_PAGE_NEXT:
        {

            [self createHeaderView];

           [self loadOk];
            
        }
            break;
        default:
            break;
    }
    
    
}
- (void)requestQHFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [_refreshFooterView setHidden:YES];
    [_refreshHeaderView setHidden:YES];
    
    if (self.waitTakeBut.selected) {
        
        self.productArray = [Util getShoppeArray];
        [self showProductsCount:[Util getShoppeArray].count];
        
    } else if (self.hadTakenBut.selected) {
     
        self.productArray = [Util takeHadTakenArray];
    
    } else{
    
        self.productArray = [Util takeNoPayArray];
    
    }
    
    if (self.productArray.count != 0) {
        _promptlabel1.hidden = YES;
        _promptLabel2.hidden = YES;
        _emptyImageView.hidden = YES;
        _shoppingBtn.hidden = YES;
        _produceTableView.hidden = NO;
    }else{
    
        _promptlabel1.hidden = NO;
        _promptLabel2.hidden = NO;
        _emptyImageView.hidden = NO;
        _shoppingBtn.hidden = NO;
    
    }
    
      [_produceTableView reloadData];
}
#pragma mark
#pragma mark  显示专柜取货的商品数量
-(void)showProductsCount:(int)count{ //显示专柜取货/购物车上的红色数量圈
    
    LKCustomTabBar *customTabbar=[LKCustomTabBar shareTabBar];
    UILabel *countLable=(UILabel*)[customTabbar.slideQH viewWithTag:1988];
    countLable.text=[NSString stringWithFormat:@"%d",count];
    if ([countLable.text integerValue]!=0) {
        customTabbar.slideQH.hidden=NO;
    }else{
        customTabbar.slideQH.hidden=YES;
    }
    
    UILabel *countLableCart=(UILabel*)[customTabbar.slideBg viewWithTag:1986];
    countLableCart.text=[NSString stringWithFormat:@"%@",[Util takeCartListCount]];
    if ([countLableCart.text integerValue]!=0) {
        customTabbar.slideBg.hidden=NO;
    }else{
        customTabbar.slideBg.hidden=YES;
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==34783) {
        
        if (buttonIndex ==0) {  //取消
               
        }else if(buttonIndex==1)
        {
            LoginViewController  *login  = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:login animated:YES];
        }else
        {
            RegisterView *registerVC=[[[RegisterView alloc]initWithNibName:@"RegisterView" bundle:nil] autorelease];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
 
    }
}


#pragma mark
#pragma mark   ********取消订单操作********

- (void) deleteExecuteByCancleBut:(UIButton*)sender{
    
    if (self.waitTakeBut.selected) {
        CancelReasonViewController  *cancelVC = [[[CancelReasonViewController alloc ]initWithNibName:@"CancelReasonViewController" bundle:nil] autorelease];
        
        cancelVC.productDic = [self.productArray objectAtIndex:sender.tag];
        self.selectIndex = sender.tag;
        cancelVC.delegate = self;
        [self presentModalViewController:cancelVC animated:YES];

    }else{
       [self deleteOrderRequest:sender.tag];
    }
    
}

- (void) deleteOrderRequest:(int) indexPathNumber{
    
    Request *request = [[[Request alloc]init]autorelease];
    request.delegate = self;
    self.orderId = [[self.productArray objectAtIndex:indexPathNumber] objectForKey:@"orderId"];
    request.orderID = [NSNumber numberWithInt:[self.orderId intValue]];
    if (self.waitTakeBut.selected) {
        request.orderType = [NSString stringWithFormat:@"3"];
        request.requestTpye = 4;
    }else if (self.noPayBut.selected){
       request.orderType = [NSString stringWithFormat:@"2"];
       request.requestTpye = 5;
    }
    request.requestTag = indexPathNumber;
    request.onSuccessSeletor=@selector(deleteOrderRequestFinished:);
    request.onFaultSeletor=@selector(deleteOrderRequestFailed:);
   [request asyncExecute];

}

- (void) deleteOrderRequestFinished:(ASIFormDataRequest*)requestForm{

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
    
    if (responseStatus==200) {
        
        [self.productArray removeObjectAtIndex:requestForm.tag];
        [self.produceTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:requestForm.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self requestData:1 requestTag:CART_REQUEST_FRIST];
    }

}
- (void) deleteOrderRequestFailed:(ASIFormDataRequest*)request{

}


#pragma mark - EGORefreshTableHeader
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
    [self.produceTableView  addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

#pragma mark - EGORefreshTableFooter
-(void)createFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    if (self.produceTableView.contentSize.height>=self.view.bounds.size.height){
    
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.produceTableView.contentSize.height, self.produceTableView.frame.size.width, self.produceTableView.bounds.size.height)] ;
        _refreshFooterView.backgroundColor  = [UIColor clearColor];
        _refreshFooterView.delegate = self;
        
        [self.produceTableView addSubview:_refreshFooterView];
        
        [_refreshFooterView refreshLastUpdatedDate];
        
        CGRect  _newFrame =  CGRectMake(0.0f, self.produceTableView.contentSize.height,self.view.frame.size.width, self.produceTableView.bounds.size.height);
        _refreshFooterView.frame = _newFrame;
    }
}
#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(UIView*)view
{
    //顶部数据刷新
    if ([view isEqual:_refreshHeaderView]) {
        [self requestData:1 requestTag:CART_REQUEST_PAGE_UPDATE];
        nowPageNum =1;
    }
    //底部数据刷新
    else if([view isEqual:_refreshFooterView]) {
       [self requestData:nowPageNum+1 requestTag:CART_REQUEST_PAGE_NEXT];
    }
}
-(void)loadOk
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.produceTableView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.produceTableView];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
    NSString *destDateString = [dateFormatter stringFromDate:date];

    
    [dateFormatter release];
    
    return destDateString;
    
}


#pragma mark
#pragma mark  计算未付款商品总额
-(int)calculateTotalAmount:(NSMutableArray*)productsArray{//计算购物车内商品的总金额
    int sum=0;
    for (int i=0; i<productsArray.count; i++) {
            NSDictionary *dic=[productsArray objectAtIndex:i];
            if (isMember) {
                sum+=[[dic objectForKey:@"memberPrice"] intValue];
            }else{
                sum+=[[dic objectForKey:@"discountPrice"] intValue];
        }
    }
    return sum;
}


-(void)drawBack{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
   
    self.produceTableView.frame=CGRectMake(0,0, 320, 366);
    [UIView commitAnimations];

}

-(void)drawDown{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.01f];
     
    self.produceTableView.frame=CGRectMake(0,50, 320, 316);
    [UIView commitAnimations];
}


- (NSString*)getMyTime:(NSString*)inputTimeStr
{
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:inputTimeStr];
    
    
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSString *outTimeStr = [outputFormatter stringFromDate:inputDate];
    return outTimeStr;
}


- (void)viewDidUnload
{
    [self setEmptyImageView:nil];
    [self setShoppingBtn:nil];
    [self setPromptlabel1:nil];
    [self setPromptLabel2:nil];
    [self setEmptImageView:nil];
    [self setLabel1:nil];
    [self setLabel2:nil];
    [self setGoShopBtn:nil];
    [[SDImageCache sharedImageCache] clearMemory];
    [self setProduceTableView:nil];
    [self setCostiomCountLable:nil];
    [self setNoPayBut:nil];
    [self setWaitTakeBut:nil];
    [self setHadTakenBut:nil];
    [self setBottomView:nil];
    [self setTotalMoneyLable:nil];
    [self setDuiGouImage:nil];
    [self setAllBut:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    [_stockResultDic release];
    [_stateForPayOnLineDic release];
    [_orderId release];
    [_productArray release];
    [_detailViewController release];
    [_emptyImageView release];
    [_shoppingBtn release];
    [_promptlabel1 release];
    [_promptLabel2 release];
    [emptImageView release];
    [label1 release];
    [label2 release];
    [goShopBtn release];
    [_refreshHeaderView release];
    [_refreshFooterView release];
    [_produceTableView release];
    [_costiomCountLable release];
    [_noPayBut release];
    [_waitTakeBut release];
    [_hadTakenBut release];
    [_bottomView release];
    [_totalMoneyLable release];
    [_duiGouImage release];
    [_allBut release];
    [super dealloc];
}
@end
