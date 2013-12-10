//
//  MyOrderViewController.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import "MyOrderViewController.h"
#import "PayCell.h"
#import "SlipVC.h"
#import "NoPayCell.h"
 
#import "CustomAlertView.h"
 
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "LoginViewController.h"
#import "InvalidPayCell.h"
#import "DateUtil.h"
#import "ProductViewController.h"
#import "ShoppingTicketVC.h"
#import <ShareSDK/ShareSDK.h>
#import "ProductViewController.h"
#import "LKCustomTabBar.h"
#import "FnalStatementVC.h"
#define CONTENT @"我正在使用WoWgoing,这里的商品质量都很好，价格也优惠!大家都来一起购物吧~~"
#define IMAGE_NAME @"sharesdk_img.jpg"
#define CART_REQUEST_FRIST       3
#define CART_REQUEST_PAGE_UPDATE    1
#define CART_REQUEST_PAGE_NEXT   2

#define REQUEST_PAGE_ONE    1
#define REQUEST_PAGE_NEXT   2

@interface MyOrderViewController ()
@property(nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) int orderNum; //判断点击的是未付款还是已付款还是失效
@property (nonatomic, retain) NSString *ordID; //订单id。跳到购物车要用的
@property (nonatomic, retain) NSMutableArray *payArray; //订单的数据
- (IBAction)backAction:(id)sender;
@end

@implementation MyOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.payArray = [NSMutableArray array];
    }
    return self;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if (self.noPayBtn.selected && [[FnalStatementVC shareFnalStatementController] _notPay]) {
        [self noPayAction:self.noPayBtn];
        [[FnalStatementVC shareFnalStatementController]set_notPay:NO];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayNav];
    _orderNum = 0;
    _nowPageNum = 1;
//    [self payOkAction:nil];
    [self requestData:1];
    self.myTableView.tag = 300;
    // Do any additional setup after loading the view from its nib.
}

- (void)displayNav {
    self.title = @"无效订单";
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
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_ordID release];
    [_payArray release];
    [_noPayBtn release];
    [_payBtn release];
    [_invalidBtn release];
    [_myTableView release];
    [_baseView release];
    [_alertViewPhone release];
    [_refreshHeaderView release];
    [_refreshFooterView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNoPayBtn:nil];
    [self setPayBtn:nil];
    [self setInvalidBtn:nil];
    [self setMyTableView:nil];
    [self setBaseView:nil];
    [self setAlertViewPhone:nil];
    [self invalidAction:nil];
    [super viewDidUnload];
}

/**
 *未付款订单
 */
- (IBAction)shopGoAction:(id)sender {
    UIButton *button=(UIButton*)[self.view viewWithTag:0];
    [[LKCustomTabBar shareTabBar] selectedTab:button];
    [LKCustomTabBar shareTabBar].currentSelectedIndex=0;
}

- (IBAction)noPayAction:(id)sender {
    _orderNum = 1;
    [self.noPayBtn setBackgroundImage:[UIImage imageNamed:@"未付款_选中"] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"已购买_未选"] forState:UIControlStateNormal];
    [self.invalidBtn setBackgroundImage:[UIImage imageNamed:@"无效_未选"] forState:UIControlStateNormal];
    [self.myTableView setTag:100];
}
/**
 *已付款订单
 */
- (IBAction)payOkAction:(id)sender {
    _orderNum = 0;
    [self.noPayBtn setBackgroundImage:[UIImage imageNamed:@"未付款_未选"] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"已购买_选中"] forState:UIControlStateNormal];
    [self.invalidBtn setBackgroundImage:[UIImage imageNamed:@"无效_未选"] forState:UIControlStateNormal];
    self.myTableView.tag = 200;
    
}
/**
 *无效订单
 */
- (IBAction)invalidAction:(id)sender {

    _orderNum = 2;
    [self.noPayBtn setBackgroundImage:[UIImage imageNamed:@"未付款_未选"] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"已购买_未选"] forState:UIControlStateNormal];
    [self.invalidBtn setBackgroundImage:[UIImage imageNamed:@"无效_选中"] forState:UIControlStateNormal];
    self.myTableView.tag = 300;
}

- (IBAction)okRefundAction:(id)sender {
    
    self.alertViewPhone.hidden = YES;
    [self moveAnim:102 typeid:1 view:self.alertViewPhone];
    [self.myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self invalidAction:nil];
    
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myTableView.tag==100) {
        static NSString *customCell = @"customCell";
        NoPayCell *cell = (NoPayCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
        
        if (cell == nil) {
            //如果没有可重用的单元，我们就从nib里面加载一个，
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoPayCell"
                                                         owner:self options:nil];
            //迭代nib重的所有对象来查找NewCell类的一个实例
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[NoPayCell class]]) {
                    cell = (NoPayCell *)oneObject;
                }
            }
        }
        NSDate *takeDate = [DateUtil stringToDate:[[_payArray objectAtIndex:indexPath.row] objectForKey:@"takeTimeStr"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *takeDateString = [DateUtil dateToString:takeDate withFormat:@"等待付款YYYY年MM月dd日 HH:mm"];
        [cell.waitTime setText:takeDateString];
        [cell.orderID setText:[NSString stringWithFormat:@"订单号:%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"orderNumber"]]];
        [cell.productImage setImageWithURL:[NSURL URLWithString:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"限时抢购logo水印"]];
        [cell.sizeLab setText:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"strsize"]];
        //原价 吊牌价
        [cell.priceLab setText:[NSString stringWithFormat:@"%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"price"]]];
        //总价 折扣价
        [cell.totalPrice setText:[NSString stringWithFormat:@"%@",[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"discountPrice"]]];
        int price = [[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"price"] intValue];
        int discountPrice = [[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"discountPrice"] intValue];
        int provicePriceNum = price - discountPrice;
        //节省
        [cell.provincePrice setText:[NSString stringWithFormat:@"%d",provicePriceNum]];
        //店铺地址
        [cell.takeTime setText:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"address"]];
        //产品名字
        [cell.prductName setText:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"productName"]];
        cell.detailBtn.tag = indexPath.row;
        cell.payBtn.tag = indexPath.row;
        [cell.payBtn addTarget:self action:@selector(piaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.detailBtn addTarget:self action:@selector(piaoAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else if (self.myTableView.tag == 200) {
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
            
        }
        //产品logog
        [cell.productLogo setImageWithURL:[NSURL URLWithString:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"限时抢购logo水印"]];
        //产品名字
        cell.productName.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"productName"];
        
        NSString  *color   = [[_payArray objectAtIndex:indexPath.row] objectForKey:@"color"];
        if (![color isKindOfClass:[NSString class]]) {
            color = @"";
            
        }
        NSString  *sizestr = [[_payArray objectAtIndex:indexPath.row] objectForKey:@"strsize"];
        NSString  *discount= [[_payArray objectAtIndex:indexPath.row] objectForKey:@"discount"];
        
        //颜色/尺码/折扣
        cell.sizeLabel.text = [NSString stringWithFormat:@"%@/%@/%@折",color,sizestr,discount];
        //订单号
//        cell.orderID.text = [NSString stringWithFormat:@"订单号:%@",[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderNumber"]];
        //总价也就是折扣价
        cell.priceLabel.text = [NSString stringWithFormat:@"%@", [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"discountPrice"]];
        
        //购买时间
//        NSDate *dateTime = [DateUtil stringToDate:[[_payArray objectAtIndex:indexPath.row] objectForKey:@"takeTimeStr"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *datestringtime = [DateUtil dateToString:dateTime withFormat:@"YYYY/MM/dd"];
//        cell.timeLab.text = datestringtime;
        //取货时间
        NSDate *takeDate = [DateUtil stringToDate:[[_payArray objectAtIndex:indexPath.row] objectForKey:@"takeTimeStr"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *takeDateString = [DateUtil dateToString:takeDate withFormat:@"YYYY年MM月dd日 HH:mm"];
        
        cell.takeLab.text =[NSString stringWithFormat:@"您已于%@到%@取货,交易完成",takeDateString,[[_payArray objectAtIndex:indexPath.row] objectForKey:@"shopName"]];
        cell.shareBtn.tag = indexPath.row+8720;
        [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.slipBtn.tag = indexPath.row+8721;
        [cell.slipBtn addTarget:self action:@selector(slipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    else {
        static NSString *customCell = @"InvalidPayCell";
        InvalidPayCell *cell = (InvalidPayCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
        
        if (cell == nil) {
            //如果没有可重用的单元，我们就从nib里面加载一个，
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvalidPayCell"
                                                         owner:self options:nil];
            //迭代nib重的所有对象来查找NewCell类的一个实例
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[InvalidPayCell class]]) {
                    cell = (InvalidPayCell *)oneObject;
                }
            }
        }
        NSDictionary *dic = [self.payArray objectAtIndex:indexPath.row];
        [cell.productLogo setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"限时抢购logo水印"]];
        cell.productNameLab.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"productName"];
        //尺码
        NSString  *color   = [[_payArray objectAtIndex:indexPath.row] objectForKey:@"color"];
        if (![color isKindOfClass:[NSString class]]) {
            color = @"";
            
        }
        NSString  *sizestr = [[_payArray objectAtIndex:indexPath.row] objectForKey:@"strsize"];
        NSString  *discount= [[_payArray objectAtIndex:indexPath.row] objectForKey:@"discount"];
        cell.roleLab.text = [NSString stringWithFormat:@"%@/%@/%@折",color,sizestr,discount];
        //订单号
        cell.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderNumber"]];
        //总价
        cell.countPrice.text = [NSString stringWithFormat:@"%@", [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"discountPrice"]];
        //        STATE_0("0", "有效（购物车）"),
        //        STATE_1("1", "购物车超时，不退款"),
        //        STATE_2("2", "有效（我的订单，等待付款）"),
        //        STATE_3("3", "有效（等待取货）"),
        //        STATE_4("4", "失效（我的订单，等待付款超时），不退款"),
        //        STATE_5("5", "失效（我的订单，等待付款手机端取消），不退款"),
        //        STATE_6("6", "失效（超时），需退款"),
        //        STATE_61("61", "失效（超时），需退款，已退款至wowgoing账户"),
        //        STATE_62("62", "失效（超时），需退款，已退款至顾客"),
        //        STATE_7("7", "失效（手机端取消），需退款"),
        //        STATE_71("71", "失效（手机端取消），需退款，已退款至wowgoing账户"),
        //        STATE_72("72", "失效（手机端取消），需退款，已退款至顾客"),
        //        STATE_8("8", "失效（店铺端取消），需退款"),
        //        STATE_81("81", "失效（店铺端取消），需退款，已退款至wowgoing账户"),
        //        STATE_82("82", "失效（店铺端取消），需退款，已退款至顾客"),
        //        STATE_9("9", "失效（超时），不退款"),
        //        STATE_10("10", "失效（手机端取消），无需退款"),
        //        STATE_11("11", "失效（店铺端取消），无需退款"),
        //        STATE_12("12", "成功交易");
        //取消状态
        NSDate *refund = [DateUtil stringToDate:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"takeTimeStr"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *refundString = [DateUtil dateToString:refund withFormat:@"YYYY年MM月dd日 HH:mm"];
        
        //在线付款
        if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 1)
        {
            cell.payTypeLab.text = @"订单超时失效";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@失效", refundString];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 2)
        {
            cell.payTypeLab.text = @"等待付款";
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 3)
        {
            
            cell.payTypeLab.text = @"等待取货";
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue]==4)
        {
            cell.payTypeLab.text =@"订单超时失效";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@失效", refundString];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 5) {
            cell.payTypeLab.text = @"订单已取消";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@手机端取消", refundString];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 6) {
            cell.payTypeLab.text = @"订单超时，等待退款";
            cell.refundTypeBtn.hidden  = NO;
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@失效", refundString];
            [cell.refundTypeBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 61)
        {
            cell.payTypeLab.text = @"订单已取消，已退款至WowGoing账户";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@退款成功", refundString];
            [cell.refundTypeBtn setHidden:NO];
            [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            [cell.refundTypeBtn setEnabled:NO];
            [cell.refundTypeBtn setAlpha:0.9f];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 62)
        {
            cell.payTypeLab.text = @"订单超时，已退款";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@退款成功", refundString];
        }
//        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 620)
//        {
//            cell.payTypeLab.text = @"退款受理中";
//            cell.refundTypeBtn.hidden = NO;
//            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@失效", refundString];
//            [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
//            [cell.refundTypeBtn setEnabled:NO];
//            [cell.refundTypeBtn setAlpha:0.8f];
//
//        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] ==7)
        {
            cell.payTypeLab.text = @"订单已取消，等待退款";
            cell.refundTypeBtn.hidden = NO;
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@手机取消", refundString];
            [cell.refundTypeBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 71)
        {
            cell.payTypeLab.text = @"订单已取消，已退款至WowGoing账户";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@退款成功", refundString];
            [cell.refundTypeBtn setHidden:NO];
            [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            [cell.refundTypeBtn setEnabled:NO];
            [cell.refundTypeBtn setAlpha:0.9f];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 72)
        {
            cell.payTypeLab.text = @"订单已取消，已退款";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@退款成功", refundString];
        }
//        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 720)
//        {
//            cell.payTypeLab.text = @"退款受理中";
//            cell.refundTypeBtn.hidden = NO;
//             cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@失效", refundString];
//            [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
//            [cell.refundTypeBtn setEnabled:NO];
//            [cell.refundTypeBtn setAlpha:0.8f];
//
//        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 8)
        {
            cell.payTypeLab.text = @"订单已取消，等待退款";
            cell.refundTypeBtn.hidden = NO;
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@到店取消", refundString];
            [cell.refundTypeBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        } else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 81)
        {
            cell.payTypeLab.text = @"订单已取消，已退款至WowGoing账户";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@退款成功", refundString];
            [cell.refundTypeBtn setHidden:NO];
            [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            [cell.refundTypeBtn setEnabled:NO];
            [cell.refundTypeBtn setAlpha:0.9f];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 82)
        {
            cell.payTypeLab.text = @"订单已取消，已退款";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@退款成功", refundString];
        }
//        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 820)
//        {
//            cell.payTypeLab.text = @"退款受理中";
//            cell.refundTypeBtn.hidden = NO;
//            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@失效", refundString];
//            [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
//            [cell.refundTypeBtn setEnabled:NO];
//            [cell.refundTypeBtn setAlpha:0.8f];
//
//        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 9)
        {
            cell.payTypeLab.text = @"订单超时";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@失效", refundString];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 10)
        {
            cell.payTypeLab.text = @"订单已取消";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@手机取消", refundString];
        }
        else if ([[[_payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"] intValue] == 11)
        {
            cell.payTypeLab.text = @"订单已取消";
            cell.refundTypeLab.text = [NSString stringWithFormat:@"订单于%@到店取消", refundString];
        }
        else
        {
            cell.payTypeLab.text = @"成功交易";
        }
        //购买日期
        NSDate *dateTime = [DateUtil stringToDate:[[_payArray objectAtIndex:indexPath.row] objectForKey:@"takeTimeStr"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *datestringtime = [DateUtil dateToString:dateTime withFormat:@"YYYY/MM/dd"];
        cell.buyDate.text = datestringtime;
       
        cell.refundTypeBtn.tag = indexPath.row+54321;
        NSString *orderStatusString = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"];
        if ([orderStatusString isEqualToString:@"620"] || [orderStatusString isEqualToString:@"720"] || [orderStatusString isEqualToString:@"820"]) {
            [cell.refundTypeBtn setHidden:NO];
            [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            [cell.refundTypeBtn setEnabled:NO];
            [cell.refundTypeBtn setAlpha:0.9f];
        }
        [cell.refundTypeBtn addTarget:self action:@selector(refundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark----失效订单  申请退款按钮

-(void)refundBtnAction:(id)sender
{
    assert(sender && [sender isKindOfClass:[UIButton class]]);
    UIButton  *btn = (UIButton*)sender;
    int row =  btn.tag-54321;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    InvalidPayCell *cell = (InvalidPayCell*)[self.myTableView cellForRowAtIndexPath:indexPath];
    
    if (cell.refundTypeBtn.isSelected == NO) {
        //点击申请退款
        [self acceptRefund:row];
//        cell.refundTypeBtn.hidden = NO;
//        [cell.refundTypeBtn setTitle:@"退款成功" forState:UIControlStateNormal];
//        [cell.refundTypeBtn setEnabled:NO];
//        [cell.refundTypeBtn setAlpha:0.8f];
    }else
    {
        
    }
}

//点击申请退款的请求方法
- (void)acceptRefund:(int)row {
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[[self.payArray objectAtIndex:row] objectForKey:@"orderId"] forKey:@"orderId"];
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

    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL, CART_ACCEPTREFUND];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    requestForm.tag = row;

    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(cartAcceptRefundFinish:)];
      [requestForm setDidFailSelector:@selector(cartAcceptRefundFail:)];
      [self showLoadingView];
}
- (void)cartAcceptRefundFail:(ASIFormDataRequest *)request{
    [self hideLoadingView];
    

}
- (void)cartAcceptRefundFinish:(ASIFormDataRequest *)request {
    [self hideLoadingView];
   
    self.alertViewPhone.hidden = NO;
    [self moveAnim:102 typeid:3 view:self.alertViewPhone];
    
}
#pragma mark----已购买中的  购物小票按钮
- (void)slipBtnAction:(id)sender {
    UIButton  *btn = (UIButton*)sender;
    int  index = btn.tag-8721;
    NSDictionary  *dic  = [_payArray objectAtIndex:index];
    NSString *orderId = [dic objectForKey:@"orderId"];
    [self requestTickData:orderId];
}

-(IBAction)login:(id)sender
{
    
}

- (void)requestTickDataloginFail:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.view makeToast:@"您的网络不给力,请重新试试吧"];
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

#pragma mark---购买中分享按钮
-(void)shareAction:(id)sender
{
    UIButton  *btn = (UIButton*)sender;
    
    int  index = btn.tag-8720;
    
    NSDictionary  *dic  = [self.payArray  objectAtIndex:index];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.myTableView.tag == 200) {
//        return 165;
//    } else if (self.myTableView.tag == 100) {
//        return 201;
//    } else {
//        return 185;
//    }
    
    return 185;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat
{
    
}
- (void)piaoAction:(id)sender {
    
//    UIButton *button = (UIButton *)sender;
//    CartDetailVC *cartDetail = [[[CartDetailVC alloc] initWithNibName:nil bundle:nil] autorelease];
//    self.ordID = [[self.payArray objectAtIndex:button.tag] objectForKey:@"orderId"];
//    cartDetail.orderID = self.ordID;
//    cartDetail.isPayOnline = YES;
//
//    NSString *lastTime=[[self.payArray objectAtIndex:button.tag] objectForKey:@"takeTimeStr"];
//    NSString *lastTimeString=[self getMyTime:lastTime];
//    
//    cartDetail.isNotPay=YES;
//    cartDetail.delegate=self;
//    
//    [self.navigationController pushViewController:cartDetail animated:YES];
//    self.navigationController.navigationBarHidden=YES;
//    
//    cartDetail.timeLable.text=[NSString stringWithFormat:@"最晚付款时间%@,请尽快付款",lastTimeString];
}

-(NSString*)getMyTime:(NSString*)inputTimeStr
{
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:inputTimeStr];
    
    
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
    
    NSString *outTimeStr = [outputFormatter stringFromDate:inputDate];
    return outTimeStr;
}
#pragma mark
#pragma 请求数据
-(void)requestData:(int)pageNumber 
{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    } else {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil
                                                                message:@"没有登陆，请登录"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"取消",@"确定", nil];
        [alert show];
        [alert release];
    }
    
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerid"];
    [jsonreq setValue:[NSNumber numberWithInt:pageNumber] forKey:@"pageNumber"];
    
    NSString *sbreq=nil;
    
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/history/orderlist",SEVERURL];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    requestForm.tag = (pageNumber == 1) ? REQUEST_PAGE_ONE : REQUEST_PAGE_NEXT;
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    [MBProgressHUD setAnimationsEnabled:YES];
    
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [_refreshFooterView setHidden:YES];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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

    NSMutableArray *array=[NSMutableArray arrayWithArray:[dic objectForKey:@"efficacyOrderlist"]];
     self.payArray = array;
    //判断是下拉还是上提
//    if (request.tag == REQUEST_PAGE_ONE) {
//        //下拉就会清除之前的缓存数据
//        [self.payArray removeAllObjects];
//        self.payArray = array;
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//        if (array == nil || array.count == 0) {
//            self.myTableView.hidden = YES;
//            self.baseView.hidden = NO;
//        } else {
//            self.myTableView.hidden = NO;
//            self.baseView.hidden = YES;
//        }
//        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
//        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
//    }
//    else{
//        
//        [self.payArray addObjectsFromArray:array];
//        _reloading = NO;
//        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
//        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
//    }
//    
//    if (self.payArray.count == 0 || self.payArray == nil) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//        [_refreshHeaderView setHidden:YES];
//        [_refreshFooterView setHidden:YES];
//        [self.myTableView reloadData];
//        return;
//    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {
        [self.view makeToast:@"您的网络不给力,请重新试试吧"];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        return;
    }
    //验正是不是最后一页
    NSString *morePage = [dic objectForKey:@"morePage"];
    
    if ([@"flase" isEqualToString:morePage]) {
        NSLog(@"已经到最后一页了");
        return;
    }
    
    
    [self.myTableView reloadData];
    
//    CGRect  _newFrame = CGRectMake(0.0f, self.myTableView.contentSize.height,self.view.frame.size.width,self.myTableView.bounds.size.height);
//    
//    [self createHeaderView];
//    [self createFooterView];
//    _refreshFooterView.frame = _newFrame;
//    [self loadOk];
    
}
#pragma mark - EGORefreshTableHeader
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshFooterView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)] ;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
	[self.myTableView  addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

#pragma mark - EGORefreshTableFooter
-(void)createFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    if (self.myTableView.contentSize.height>=self.view.bounds.size.height){
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.myTableView.contentSize.height, self.myTableView.frame.size.width, self.myTableView.bounds.size.height)];
        _refreshFooterView.backgroundColor  = [UIColor clearColor];
        _refreshFooterView.delegate = self;
        
        [self.myTableView addSubview:_refreshFooterView];
        
        [_refreshFooterView refreshLastUpdatedDate];
        
        CGRect  _newFrame =  CGRectMake(0.0f, self.myTableView.contentSize.height,self.view.frame.size.width, self.myTableView.bounds.size.height);
        _refreshFooterView.frame = _newFrame;
    
    }
}
#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(UIView*)view
{
    NSString *orderString = @"";
    if (_orderNum == 0) { //已付款
        orderString = @"12";
    } else if (_orderNum == 1) {  //未付款
        orderString = @"2";
    } else { //无效
        orderString = @"00";
    }
    //顶部数据刷新
    if ([view isEqual:_refreshHeaderView]) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
        [self requestData:1 orderType:orderString];
        _nowPageNum =1;
    }
    //底部数据刷新
    else if([view isEqual:_refreshFooterView]) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
        
        _nowPageNum++;
        [self requestData:_nowPageNum orderType:orderString];
    }
}
-(void)loadOk
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
    
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

#pragma mark -- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.myTableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.myTableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.myTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


@end
