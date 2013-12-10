//
//  ShoppingTicketVC.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-25.
//
//

#import "ShoppingTicketVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

#import <ShareSDK/ShareSDK.h>
#import "Single.h"
@interface ShoppingTicketVC ()

@end

@implementation ShoppingTicketVC
@synthesize alertMessageLab = _alertMessageLab;
@synthesize phoneNumber = _phoneNumber;
@synthesize stampImageView = _stampImageView;
@synthesize moneyLabel = _moneyLabel;
@synthesize priceLabel = _priceLabel;
@synthesize productName = _productName;
@synthesize productCount = _productCount;

@synthesize imageView = _imageView;
@synthesize commityName = _commityName;
@synthesize shopName = _shopName;
@synthesize orderNum = _orderNum;
@synthesize takeTime = _takeTime;
@synthesize tickDic = _tickDic;
@synthesize sellerName = _sellerName;
@synthesize commityNum = _commityNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tickDic = [NSMutableDictionary dictionary];
        
        self.navigationController.navigationBar.hidden = NO;
    }
    return self;
}


- (IBAction)shareAction:(id)sender { //分享
    
    NSString *prodeuctName=[[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"productName"];//产品名
    NSString *address=[[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"shopName"];//取货店铺
    NSString *discount=[[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"discount"];//折扣
    
    NSString *shareString=[NSString stringWithFormat:@"我在%@买了正品%@,%@折,只有在WowGoing才可以享受折扣哦！你羡慕吧！http://www.wowgoing.com",address,prodeuctName,discount];
    
    NSURL *imageUrl = [NSURL URLWithString:[[self.tickDic  objectForKey:@"cardInfor"] objectForKey:@"picUrl"]];
    
    //微信分享的url 腾讯和新浪不用这个
    NSString *urlString = [NSString stringWithFormat:@"%@/iphone",WX_SEVERURL];

    id<ISSContent>publishContent=[ShareSDK content:shareString
                                    defaultContent:shareString
                                             image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl] fileName:nil mimeType:nil]
                                             title:@"购引"
                                               url:nil
                                       description:nil
                                         mediaType:SSPublishContentMediaTypeNews];
    
    
    //需要定制分享视图的显示属性，使用以下接口
    
    id<ISSContainer>container=[ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:nil authManagerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,nil]
                           content:publishContent
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
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                         content:shareString
                                           title:@"购引"
                                             url:urlString
                                           image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl] fileName:nil mimeType:nil]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:shareString
                                            title:@"购引"
                                              url:urlString
                                            image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl] fileName:nil mimeType:nil]
                                     musicFileUrl: nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayNav];
    

    [self.imageView setImageWithURL:[NSURL URLWithString:[[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"picUrls"]] placeholderImage:[UIImage imageNamed:@"限时抢购logo水印.png"]];
    
    self.commityName.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"productName"];
    //商品货号
    self.productName.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"productNumber"];
    
    //取货时间
    self.takeTime.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"takeTime"];
    //原价
    self.priceLabel.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"price"];
    //产品数量
    self.productCount.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"count"];
    //现价
    self.moneyLabel.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"discountPrice"];
//    self.moneyLabel.text = [NSString stringWithFormat:@"%d",[[[self.tickDic objectForKey:@"product"] objectForKey:@"discountPrice"] intValue] * [[[self.tickDic objectForKey:@"product"] objectForKey:@"count"] intValue]];
    //店铺名称
    self.shopName.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"shopName"];
    //店员
    self.sellerName.text = [self.tickDic objectForKey:@"shoperName"];
    //订单号
    self.orderNum.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"orderNumber"];
    //店铺印章
    [self.stampImageView setImageWithURL:[NSURL URLWithString:[[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"shopPic"]]];
    //描述
    self.alertMessageLab.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"AfterSalesTerms"];
    //电话 afterSalesTel
    self.phoneNumber.text = [[self.tickDic objectForKey:@"cardInfor"] objectForKey:@"afterSalesTel"];
    
}

- (void)displayNav {
    self.title = @"购物小票";
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

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setCommityName:nil];
    [self setShopName:nil];
    [self setOrderNum:nil];
    [self setSellerName:nil];
    [self setTakeTime:nil];
    [self setCommityNum:nil];
    [self setProductName:nil];
    [self setProductCount:nil];
    [self setPriceLabel:nil];
    [self setMoneyLabel:nil];
    [self setAlertMessageLab:nil];
    [self setPhoneNumber:nil];
    [self setStampImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [_tickDic release];
    [_imageView release];
    [_commityName release];
    [_shopName release];
    [_orderNum release];
    [_sellerName release];
    [_takeTime release];
    [_commityNum release];
    [_productName release];
    [_productCount release];
    [_priceLabel release];
    [_moneyLabel release];
    [_alertMessageLab release];
    [_phoneNumber release];
    [_stampImageView release];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
