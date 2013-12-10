//
//  DetailCouponViewController.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-24.
//
//

#import "DetailCouponViewController.h"

#import "CouponDetailBS.h"

 

#import "JSON.h"

 

#import <ShareSDK/ShareSDK.h>
@interface DetailCouponViewController ()
@property (nonatomic,retain) NSString *promotionsidString;
@end

@implementation DetailCouponViewController
- (void)dealloc {
    [_cityStr release];
    [_promotionsidString release];
    [_couponCord release];
    [_dateString release];
    [_priceCoupon release];
    [_shopNameString release];
    [_explanationTextVIEW release];
    [_priceLael release];
    [_dateLabel release];
    [_couponLabel release];
    [_cityLab release];
    [_userShopTV release];
    [_userShopLab release];
    [_scrollView release];
    [_expLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"我的优惠券";
        // Custom initialization
        //返回按钮
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
        [self.navigationController.navigationItem.backBarButtonItem setTitle:@"返回"];
    }
    return self;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.priceLael.text = [NSString stringWithFormat:@"￥%@",self.priceCoupon];
    self.couponLabel.text = self.couponCord;
    self.dateLabel.text = self.dateString;
    self.cityLab.text = self.cityStr;
    
    self.userShopTV.text = self.shopNameString;
    self.userShopTV.tag = noDisableVerticalScrollTag;
   
    [self loadViewData];
}

- (void)couponSuccess:(ASIFormDataRequest *)requestFrom{
    [self hideLoadingView];
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

    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200 ) {
        [self.view makeToast:@"获取优惠劵数据失败"];
        return;
    }
    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        NSLog(@"返回结果错误");
        return;
    }
    

    
    int proid = [[dic objectForKey:@"promotionsId"] intValue];
    self.promotionsidString = [NSString stringWithFormat:@"%d", proid];
    //使用店铺
//    self.shopNameString = [[dic objectForKey:@"detailDto"] objectForKey:@"shopName"];
    NSString *explainStr = [[dic objectForKey:@"detailDto"] objectForKey:@"shopName"];
    NSString *string = explainStr;
    self.shopStrLabel.numberOfLines = 0;
    CGSize labsize = [string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.shopStrLabel.frame.size.width, 9999) lineBreakMode:UILineBreakModeCharacterWrap];
    self.shopStrLabel.frame = CGRectMake(self.shopStrLabel.frame.origin.x, self.shopStrLabel.frame.origin.y, self.shopStrLabel.frame.size.width, labsize.height);
    self.shopStrLabel.text = string;
    
    self.expLabel.frame = CGRectMake(self.expLabel.frame.origin.x, self.shopStrLabel.frame.size.height +110, self.expLabel.frame.size.width, self.expLabel.frame.size.height);
    //使用说明
    self.explantionLabelString.text = [[dic objectForKey:@"detailDto"] objectForKey:@"couponContent"];
    NSString *stringExplantion = self.explantionLabelString.text;
    self.explantionLabelString.numberOfLines = 0;
    CGSize labsizeExp = [stringExplantion sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.explantionLabelString.frame.size.width, 9999) lineBreakMode:UILineBreakModeCharacterWrap];
    self.explantionLabelString.frame = CGRectMake(self.explantionLabelString.frame.origin.x, self.shopStrLabel.frame.size.height+130, self.explantionLabelString.frame.size.width, labsizeExp.height);
    self.explantionLabelString.text = stringExplantion;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, labsize.height + labsizeExp.height + 150);
    
     [self.userShopTV flashScrollIndicators];

}

- (void)couponFault:(ASIFormDataRequest *)requestFrom {
    [self hideLoadingView];
    [self.view makeToast:@"您的网络不给力,请重新试试吧"];
}

- (void)loadViewData {
    CouponDetailBS *couponBS = [[[CouponDetailBS alloc] init] autorelease];
    couponBS.delegate = self;
    couponBS.couponIdNum = self.couponNum;
    couponBS.onFaultSeletor = @selector(couponFault:);
    couponBS.onSuccessSeletor = @selector(couponSuccess:);
    [couponBS asyncExecute];
    [self showLoadingView];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(320, 600);
    self.userShopTV.showsVerticalScrollIndicator = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setExplanationTextVIEW:nil];
    [self setPriceLael:nil];
    [self setDateLabel:nil];
    [self setCouponLabel:nil];
    [self setCityLab:nil];
    [self setUserShopTV:nil];
    [self setUserShopLab:nil];
    [self setScrollView:nil];
    [self setExpLabel:nil];
    [super viewDidUnload];
}
- (IBAction)shareAction:(id)sender {
 
    NSString *proString = self.couponShareLink;
    NSString *wxStr = [NSString stringWithFormat:@"送你“购引”优惠券%@元，优惠码：%@，点击查看详情",self.priceCoupon,self.couponCord];
    
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"购引icon(114_114)" ofType:@".png"];
    
    id<ISSContent>publishContent=[ShareSDK content:wxStr
                                    defaultContent:wxStr
                                             image:[ShareSDK imageWithPath:path]
                                             title:@"购引"
                                               url:proString
                                       description:nil
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
@end
