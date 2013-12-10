//
//  ProductDetailViewController_Detail2.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-11.
//
//

#import "ProductDetailViewController_Detail2.h"
#import "TTTAttributedLabel.h"
#import <ShareSDK/ShareSDK.h>
#import "MobClick.h"
#import "LoginViewController.h"
#import "RegisterView.h"
#import "EGOImageView.h"
#import "ShopInfoDetailViewController.h"
#import "SizeWebVC.h"
#import "Prodect.h"
#import "DateUtil.h"
#import "LKCustomTabBar.h"
#import "PayByWgoingVC.h"
#import "WowgoingAccount.h"
#import "FnalStatementVC.h"
#import "AddAddressViewController.h"
#import "CheckStockBS.h"
#import "BuyItNowBS.h"
#import "DetailBS.h"

//#define EXPLAIN_WIDTH 

static CGFloat const kSummaryTextFontSize = 14.0f;
static CGFloat const kAttributedVerticalMargin = 14.0f;

static NSRegularExpression *__nameRegularExpression;  //正则表达式
static inline NSRegularExpression * NameRegularExpression() {
    if (!__nameRegularExpression) {
        __nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __nameRegularExpression;
}

static NSRegularExpression *__parenthesisRegularExpression;
static inline NSRegularExpression * ParenthesisRegularExpression() {
    if (!__parenthesisRegularExpression) {
        __parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __parenthesisRegularExpression;
}


static int pushState;

@interface ProductDetailViewController_Detail2 ()<postProtocol,UITextFieldDelegate,ISSViewDelegate>
{
      BOOL  _isYuDing;
      BOOL  _isOver;
}
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;    // 主ScrollView
@property (retain, nonatomic) IBOutlet UIScrollView *productImageViewScrollView;  //展示产品图片ScrollView
@property (retain, nonatomic) IBOutlet UIPageControl *productImagePageControl;
@property (retain, nonatomic) IBOutlet UILabel *productNameLable;   //产品名称
@property (retain, nonatomic) IBOutlet UIView *vipView;
@property (retain, nonatomic) IBOutlet UILabel *vipPriceLable;   //会员价
@property (retain, nonatomic) IBOutlet UIView *customView;

@property (retain, nonatomic) IBOutlet UIView *underSizeView;
@property (retain, nonatomic) IBOutlet UILabel *timeLable;  //活动结束日期时间标签
@property (retain, nonatomic) IBOutlet UIImageView *brandLogoImage; //品牌图片
@property (retain, nonatomic) IBOutlet UILabel *colorLable;  //颜色分类
@property (retain, nonatomic) IBOutlet UILabel *materialLable;   //材质
@property (retain, nonatomic) IBOutlet UILabel *stockLable;   //库存
@property (retain, nonatomic) IBOutlet TTTAttributedLabel *productDetailLable;  //商品详情
@property (retain, nonatomic) IBOutlet UIView *phoneNumberView;
@property (retain, nonatomic) IBOutlet UILabel *phoneNumberLable;  //电话号码

//尺码和店铺信息
@property (nonatomic, retain) NSMutableArray *sizeArray;
@property (nonatomic, retain) NSMutableArray *addressArray;
@property (nonatomic, retain) NSMutableDictionary *skuDic;
@property (nonatomic, retain) NSMutableArray *tempAddressArray;
@property (nonatomic, assign) BOOL roleBOOL;
@property (nonatomic, assign) BOOL addressBOOL;
@property (nonatomic, retain) NSString *sizeName; //尺码
@property (nonatomic, retain) NSString *addressString; //地址
@property (nonatomic, retain) UIView *sizeView;
@property (nonatomic, retain) UIScrollView *sizeScro;
@property (assign) int sizeid;
@property (assign) int shopid;
@property (assign) int payState;
@property (assign) int num; //立即购买和加入购物车计数器
@property (assign) int shopViewHeight;
@property CGRect labelSizeFram;//自适应的label
@property (nonatomic,retain)NSMutableArray *klpImgArr;
@property (nonatomic, retain) NSMutableArray *klpArr;
@property (retain, nonatomic) NSMutableDictionary *shopDic;
@property(nonatomic,retain) NSString *isOne;

@property (nonatomic, assign) int productNum;
@property (nonatomic, retain) NSMutableDictionary *buyDicinfo;
@property (nonatomic, assign) int skuId; //skuid
@property (nonatomic, assign) int operateType; //操作类型 0预定 1修改
@property (nonatomic, assign) int shopId; //商铺id
@property (nonatomic, assign) int stockNum; //商铺id
@property (nonatomic,assign)   int  disprice;//价格
@property (nonatomic, retain) MBProgressHUD * HUD;
@property (nonatomic, retain) UIImageView *inPutboxImage;//电话录入视图
@property (nonatomic, retain) UIImageView *promptBox;//录入电话成功后的提示框
@property(copy,nonatomic)NSString *orderID;//单品订单号
@property(copy,nonatomic)NSString *takeTime;//取货时间
@property(retain,nonatomic)StrikeThroughLabel *discountPrice2;//单品折扣价

@property(nonatomic,retain) NSMutableDictionary *tempDic;


@property (nonatomic,retain) NSMutableDictionary  *stockResultDic;

@end

@implementation ProductDetailViewController_Detail2

- (void)dealloc {
    [_stockResultDic release];
    [_shopScrollView release];
    [_sizeScro release];
    [_mainScrollView release];
    [_productImageViewScrollView release];
    [_productImagePageControl release];
    [_productNameLable release];
    [_klpArr release];
    [_klpImgArr release];
    [_shopDic release];
    [_isOne release];
    [_vipView release];
    [_vipPriceLable release];
    [_customView release];
    [_discountPriceLable release];
    [_originalPriceLable release];
    [_underSizeView release];
    [_timeLable release];
    [_brandLogoImage release];
    [_colorLable release];
    [_materialLable release];
    [_stockLable release];
    [_productDetailLable release];
    [_phoneNumberView release];
    [_phoneNumberLable release];
    [_sizeLabel release];
    [_sizeView release];
    [_view_imgScro release];
    [_displayShopView release];
    [_explainView release];
    [_shareBtn release];
    [_shopButton release];
    [_ydButton release];
    [_gyPriceLabel release];
    [_zgPriceLabel release];
    [_gouYInLabel release];
    [_hyPricelabel release];
    [_stockImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    [self setSizeView:nil];
    [self setMainScrollView:nil];
    [self setProductImageViewScrollView:nil];
    [self setProductImagePageControl:nil];
    [self setProductNameLable:nil];
    [self setVipView:nil];
    [self setVipPriceLable:nil];
    [self setCustomView:nil];
    [self setDiscountPriceLable:nil];
    [self setOriginalPriceLable:nil];
    [self setUnderSizeView:nil];
    [self setTimeLable:nil];
    [self setBrandLogoImage:nil];
    [self setColorLable:nil];
    [self setMaterialLable:nil];
    [self setStockLable:nil];
    [self setProductDetailLable:nil];
    [self setPhoneNumberView:nil];
    [self setPhoneNumberLable:nil];
    [self setSizeLabel:nil];
    [self setView_imgScro:nil];
    [self setDisplayShopView:nil];
    [self setExplainView:nil];
    [self setShareBtn:nil];
    [self setShopButton:nil];
    [self setYdButton:nil];
    [self setGyPriceLabel:nil];
    [self setZgPriceLabel:nil];
    [self setGouYInLabel:nil];
    [self setHyPricelabel:nil];
    [self setStockImageView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *addMember = [UIButton buttonWithType:UIButtonTypeCustom];
        [addMember setFrame:CGRectMake(10, 6, 52, 32)];;
        [addMember addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [addMember setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem1 = [[UIBarButtonItem alloc] initWithCustomView:addMember];
        self.navigationItem.leftBarButtonItem = litem1;
        
        
        UIButton *addMember2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [addMember2 setFrame:CGRectMake(10, 6, 52, 32)];;
        [addMember2 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [addMember2 setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem2 = [[UIBarButtonItem alloc] initWithCustomView:addMember2];
        self.navigationItem.rightBarButtonItem = litem2;
        
        self.title = @"商品详情";
        [self.timeLable setFont:[UIFont systemFontOfSize:17.0f]];

        
        [litem1 release];
        [litem2 release];
    }
    return self;
}

- (void) postProtocolMethod{
    [self buyItNowAction:self.tempDic];
}

- (void) cancleAllRequest{

    for (ASIFormDataRequest *request  in [ASIFormDataRequest sharedQueue].operations) {
           [request clearDelegatesAndCancel];
    }

}

- (void)backAction:(id)sender {
    [self cancleAllRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 
#pragma mark   ******分享**********
- (void)shareAction:(id)sender {
    
    //微信分享的url；
    NSString *wowgoingStringUrl = [NSString stringWithFormat:@"%@/iphone",WX_SEVERURL];
    NSString *shareString = [self.prductDetailDic objectForKey:@"brandName"];
    NSString *s_discountPrice = [self.prductDetailDic objectForKey:@"price"];
    NSString *disc = [NSString stringWithFormat:@"%.1f折",[[self.prductDetailDic objectForKey:@"discount"] floatValue]];
    NSString *discountPrice = [self.prductDetailDic objectForKey:@"discountPrice"];//现价
    shareString = [shareString stringByAppendingFormat:@" 原价%@ 现价%@,上购引立享%@！ ",s_discountPrice,discountPrice,disc];
    
    shareString = [shareString stringByAppendingString:@"购引-给您线上购买、线下取货的全新购物体验！还没下载？马上在APP store搜索“购引”即刻下载！http://www.wowgoing.com"];

    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
    NSURL *imageUrl = [NSURL URLWithString:[[self.prductDetailDic objectForKey:@"picUrls"] objectAtIndex:0]];
    [imageView setImageWithURL:imageUrl];
    
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
   
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleFullScreenPopup  viewDelegate:self authManagerViewDelegate:nil];
    
    [self sendWeiBoByShareSDK:publishContent :container :authOptions];
    
    //定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                         content:shareString
                                           title:shareString
                                             url:wowgoingStringUrl
                                           image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl] fileName:nil mimeType:nil]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:shareString
                                            title:shareString
                                              url:wowgoingStringUrl
                                            image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl] fileName:nil mimeType:nil]
                                     musicFileUrl: nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];


}


////  完成授权后发送一条微博
//- (void) viewOnWillDismiss:(UIViewController *)viewController shareType:(ShareType)shareType{
//
//       BOOL  isAuthorized =  [ShareSDK hasAuthorizedWithType:shareType];
//      
//       if (isAuthorized) {
//           
//           NSString *shareString = [NSString stringWithFormat:@"授权微博"];
//           
//           UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
//           NSURL *imageUrl = [NSURL URLWithString:[[self.prductDetailDic objectForKey:@"picUrls"] objectAtIndex:0]];
//           [imageView setImageWithURL:imageUrl];
//           
//           id<ISSContent>publishContent=[ShareSDK content:shareString
//                                           defaultContent:shareString
//                                                    image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:imageUrl] fileName:nil mimeType:nil]
//                                                    title:@"购引"
//                                                      url:nil
//                                              description:nil
//                                                mediaType:SSPublishContentMediaTypeNews];
//           
//           
//           //需要定制分享视图的显示属性，使用以下接口
//           
//           id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleFullScreenPopup  viewDelegate:nil authManagerViewDelegate:nil];
//           
//           [ShareSDK shareContent:publishContent type:shareType    authOptions:authOptions statusBarTips:YES result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//               
//               if (state == SSPublishContentStateSuccess)
//               {
//                   NSLog(@"发送成功");
//               }
//               else
//               {
//                   NSLog(@"发送失败");
//               }
//
//           }];
//           
//    }
//    
//}


- (void) sendWeiBoByShareSDK:(id<ISSContent>)content :(id<ISSContainer>)container :(id<ISSAuthOptions>)authOptions{
    
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,nil]
                           content:content
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

}


#pragma mark
#pragma mark   ********选择尺码********
bool displayShopViewBool = YES;
- (void)sizeAction:(id)sender {
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         //[UIView setAnimationTransition:transition forView:buy.superview cache:YES];
                         
                         self.underSizeView.frame = CGRectMake(0, self.displayShopView.frame.origin.y+_displayShopView.frame.size.height, _underSizeView.frame.size.width, _underSizeView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    displayShopViewBool = NO;
    self.addressBOOL = NO;
    [self selectSizeAction:sender];
}

- (void)selectSizeAction:(UIButton *)btn {
    
    if (!btn) {
        return;
    }
    self.roleBOOL = NO;
    //选中尺码后店铺列表才能操作。
    [self.shopScrollView setUserInteractionEnabled:YES];
    for(int i=0; i<self.sizeArray.count; i++){
        UIButton *but= (UIButton *)[self.view viewWithTag:[[[self.sizeArray objectAtIndex:i] objectForKey:@"id"] intValue]];
        
        if (but.tag != btn.tag) {
            if (but.selected) {
                but.selected = NO;
                [but setImage:[UIImage imageNamed:@"尺码BG"] forState:UIControlStateNormal];
            } else {
            }
        } else {
            btn.selected = !btn.selected;
            if (btn.selected) {
                [but setImage:[UIImage imageNamed:@"尺码BG选中"] forState:UIControlStateNormal];
                self.roleBOOL = YES;
            }else{
            
                [but setImage:[UIImage imageNamed:@"尺码BG"] forState:UIControlStateNormal];
                self.roleBOOL = NO;
                self.addressBOOL = NO;
            }
        }
    }
    self.sizeid = btn.tag;
    self.skuId = self.sizeid;
    int stringid = [btn.titleLabel.text intValue];
    _sizeName = [[self.sizeArray objectAtIndex:stringid] objectForKey:@"name"];
    
    //点击尺码取到尺寸的id 人后根据尺码id取到skuShopList（尺码支持店铺的id）
    NSMutableArray *addresses = [self.skuDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    //遍历skuShopList中的内容
    NSMutableArray *addArray = [NSMutableArray array];
    for (int i=0; i<addresses.count; i++) {
        NSMutableDictionary *addDic = [NSMutableDictionary dictionary];
        NSString *addressID = [addresses objectAtIndex:i];
        for (int j= 0; j<self.addressArray.count; j++) {
            NSMutableDictionary *dic = [self.addressArray objectAtIndex:j];
            if ([addressID isEqualToString:[dic objectForKey:@"id"]]) {
                [addDic setValue:[dic objectForKey:@"name"] forKey:@"name"];
                [addDic setValue:[dic objectForKey:@"payState"] forKey:@"payState"];
                [addDic setValue:[dic objectForKey:@"id"] forKey:@"id"];
                [addArray addObject:addDic];
            }
        }
    }
    //执行查看店铺
    //用skuShopList取出来的id和店铺id对比。如果一样输出店铺名
    self.tempAddressArray = [NSMutableArray arrayWithArray:addArray];
    
    [self addressRefresh:_tempAddressArray];
    
    //加载了店铺后从新计算主scrollview高度 如果尺码排成两行就加上第二行尺码的高度
    if (_shopViewHeight > 0) {
        _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, _mainScrollView.frame.size.height + _underSizeView.frame.size.height + 30*_shopViewHeight + _labelSizeFram.size.height );

        return;
    }
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, _mainScrollView.frame.size.height + _underSizeView.frame.size.height + _labelSizeFram.size.height);
}

#pragma mark
#pragma mark   ********添加购物车********
- (IBAction)addCartAction:(id)sender {
    [MobClick event:@"shopCart"];//购物车事件统计ID
    if ([Util isLogin] == NO) {
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示"
                                             message:@"你还没有登录,登录后才可以查看!"
                                            delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"登录",@"注册", @"取消",nil];
        [loginAlert show];
        
        return;
    }

    [self loadReserve];

}


#pragma mark ----------  添加购物车
-(void)loadReserve
{
    
    if (_isOver) {
       
          [self.view makeToast:@"您购物车的商品已超过30件" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    if (!self.addressBOOL ||  !self.roleBOOL) {
          [self.view makeToast:@"请先选择尺码和取货店铺" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",self.productId] forKey:@"productId"];
    [jsonreq setValue:@"1" forKey:@"productNumber"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",self.shopid] forKey:@"shopId"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:@"0" forKey:@"operateType"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",self.payState] forKey:@"payState"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",self.skuId] forKey:@"skuId"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",self.activityId] forKey:@"activityId"];
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cart/add",SEVERURL];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    requestForm.delegate = self;
    [requestForm startAsynchronous];
    [requestForm setDidFinishSelector:@selector(cartAddFinish:)];
    [requestForm setDidFailSelector:@selector(cartAddFail:)];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

- (void)cartAddFail:(ASIHTTPRequest *)request {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    _num ++;
    if (_num <3) {
        [self loadReserve];
    } else {
        _num = 0;
         [self.view makeToast:@"购买失败" duration:0.5 position:@"center" title:nil];
    }
}
//成功添加
- (void)cartAddFinish:(ASIHTTPRequest *)requestForm {
    _num = 0;
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
    
    _isOver = [[dic objectForKey:@"isOverCount"] boolValue];
    
    
    if (responseStatus!=200) {
         [self.view makeToast:@"预订失败" duration:0.5 position:@"center" title:nil];
    } else {
        
        [self.view makeToast:@"预订成功" duration:0.5 position:@"center" title:nil];

        [self updatecartList:101];
    }
    
}

#pragma mark
#pragma mark   ********立即预定********
- (IBAction)yuDingAction:(id)sender {

    if ([Util isLogin] == NO) {
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                          message:@"你还没有登录,登录后才可以查看!"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"登录",@"注册", @"取消",nil];
        [loginAlert show];
        
        return;
    }else{
       
        if (!self.addressBOOL || !self.roleBOOL) {
    
             [self.view makeToast:@"请先选择尺码和取货店铺" duration:0.5 position:@"center" title:nil];
            return;
        }
        
        _isYuDing = YES;
        self.tempDic = [NSMutableDictionary dictionary];
        [self.tempDic setValue:[NSString stringWithFormat:@"%d",self.activityId]       forKey:@"activityId"];
        [self.tempDic setValue:[NSString stringWithFormat:@"%d",self.skuId] forKey:@"skuId"];
        [self.tempDic setValue:[NSString stringWithFormat:@"%d",self.shopid ]forKey:@"shopId"];
        
        if (self.payState != 2) {
            [self checkUserPhoneNumber];
//            [self buyItNowAction:self.tempDic];
        }else{
            [self addCustomAddressForPostProduct];
        }
    }
   
}

- (void) buyItNowAction:(NSMutableDictionary*)dic{
    
    BuyItNowBS  *buyNowBS = [[[BuyItNowBS alloc] init ] autorelease];
    buyNowBS.delegate = self;
    buyNowBS.productDic = dic;
    [buyNowBS setOnSuccessSeletor:@selector(buyItNowActionFinished:)];
    [buyNowBS setOnFaultSeletor:@selector(buyItNowActionFault:)];
    [buyNowBS asyncExecute];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

- (void) buyItNowActionFinished:(ASIFormDataRequest*)request{
    
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (request.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        return;
    }
    if (error) {
        return;
    }

    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    BOOL  success = [[dic objectForKey:@"success"] boolValue];
    if (!success) {
         [self.view makeToast:@"库存不足,不能生成订单" duration:0.5 position:@"center" title:nil];
        return ;
    }
    
    self.takeTime = [dic  objectForKey:@"takeTime"];
    self.stockResultDic = [NSMutableDictionary   dictionaryWithDictionary:dic];
    
    if (self.payState != 2 ) {  // 邮寄产品
//        [self checkUserPhoneNumber];
         [self showPromptBox:[Util takePhoneNumber]];
    }else{
     
        [self updatecartList:100];
    }
}

- (void) buyItNowActionFault:(ASIFormDataRequest*)request{

    [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];

}

#pragma mark
#pragma mark   ********查看品牌详情********
- (IBAction)brandDetailInfor:(id)sender {
    
    pushState = 2;
    NSString *brandid = [self.prductDetailDic objectForKey:@"brandId"];
    ShopInfoDetailViewController *shopInfoVC  = [[[ShopInfoDetailViewController alloc] initWithNibName:@"ShopInfoDetailViewController" bundle:nil] autorelease];
    shopInfoVC.brandId = brandid;
    [self.navigationController pushViewController:shopInfoVC animated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
   self.prductDetailDic = [NSMutableDictionary dictionary];
   
    _mainScrollView.contentSize = CGSizeMake(320, 600);
    self.shopDic = [NSMutableDictionary  dictionary];
    self.klpArr = [NSMutableArray array];
    self.klpImgArr = [NSMutableArray array];
    
    [self requestProductDetailInfo];

}


#pragma mark ***************** 请求商品详情数据
- (void)requestProductDetailInfo{
    
    DetailBS *db = [[[DetailBS alloc] init] autorelease];
    db.delegate = self;
    db.productIdNum = self.productId;
    db.activityIdNum = self.activityId;
    db.onSuccessSeletor = @selector(requestProductDetailInfoFinished:);
    db.onFaultSeletor = @selector(requestProductDetailInfoFail:);
    [db asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark
#pragma mark  获取订单失效时间与当前时间的时间差
-(NSString *)takeTimeDifference:(NSString *)timeDate{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[[NSDateComponents alloc] init] autorelease];//初始化目标时间
    
    NSArray *array=[[self.prductDetailDic objectForKey:@"enddate"] componentsSeparatedByString:@" "];
    NSArray *arrayNYR=[[array objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *arrayHMS=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
    [endTime setYear:[[arrayNYR objectAtIndex:0] intValue]];
    [endTime setMonth:[[arrayNYR objectAtIndex:1] intValue]];
    [endTime setDay:[[arrayNYR objectAtIndex:2] intValue]];
    
    [endTime setHour:[[arrayHMS objectAtIndex:0] intValue]];
    [endTime setMinute:[[arrayHMS objectAtIndex:1] intValue]];
    [endTime setSecond:[[arrayHMS objectAtIndex:2] intValue]];
    
    NSDate *endDateTime=[cal dateFromComponents:endTime];
    // NSDate *today=[NSDate date];
    NSDate *today = [DateUtil stringToDate:timeDate withFormat:@"yyyy-MM-dd HH:mm:ss"];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *differcnce=[cal components:unitFlags fromDate:today toDate:endDateTime options:0];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%d天%d时%d分", [differcnce day], [differcnce hour], [differcnce minute]]);
    return [NSString stringWithFormat:@"%d天%d时%d分", [differcnce day], [differcnce hour], [differcnce minute]];
    
    // int totle=[differcnce day]*3600*24+[differcnce hour]*3600+[differcnce minute]*60+[differcnce second];
}

#define EXPLAIN_X 20  // 商品说明的 x
#define EXPLAIN_Y 5
#define SPACING_WIDTH 10 //品牌和品牌描述的间距
#define EXPLAIN_FONT 12 //商品说明字体大小
#define EXPLAIN_HEIGHT 21
#define EXPLAIN_TITLE_FOUR 68  //商品说明 为四个字的时候
#define EXPLAIN_TITLE_TWO  42   //两个字的时候
#define SPACE_HEIGHT 15 //商品说明间距
#define BACKGROUNDCOLOR [UIColor darkGrayColor] // 商品说明颜色
#pragma mark ---------- 详情

- (void)requestProductDetailInfoFinished:(ASIFormDataRequest*)requestForm{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_shareBtn setEnabled:YES];
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        NSLog(@"详情内容：%@",dic);
    }else{
        return;
    }
    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }

    //是否秒杀产品
    NSDictionary *productDic = nil;
    BOOL seckillStatus = [[dic objectForKey:@"seckillStatus"] boolValue];
    if (seckillStatus) {
        self.prductDetailDic = [dic objectForKey:@"seckillactivity"];
        productDic = [dic objectForKey:@"seckillactivity"];
        [_shopButton setBackgroundImage:[UIImage imageNamed:@"收藏-灰色"] forState:UIControlStateNormal];
        [_shopButton setEnabled:NO];
        
    } else {
        self.prductDetailDic = [dic objectForKey:@"productDetail"];
        productDic = [dic objectForKey:@"productDetail"];
        [_shopButton setBackgroundImage:[UIImage imageNamed:@"加入购物车"] forState:UIControlStateNormal];
        [_shopButton setEnabled:YES];
    }
    
    //判断是否有尺码显示  如果没有尺码显示。则立即购买和购物车按钮变灰不可编辑
    NSArray *skuListArray = [productDic objectForKey:@"skuList"];
    if ([skuListArray count] == 0) {
        [_shopButton setBackgroundImage:[UIImage imageNamed:@"收藏-灰色"] forState:UIControlStateNormal];
        [_ydButton setBackgroundImage:[UIImage imageNamed:@"立即预定灰色"] forState:UIControlStateNormal];
        [_shopButton setEnabled:NO];
        [_ydButton setEnabled:NO];
    }
    
    //活动将于什么时候结束
    NSString *currentTime = [dic objectForKey:@"currentTime"];
    NSString *endDateString = [self takeTimeDifference:currentTime];
    [_timeLable setText:[NSString stringWithFormat:@"活动将于%@结束", endDateString]];

    //会员价memberPrice 购引价discountPrice  专柜价price

    BOOL IsMemberBool = [[dic objectForKey:@"IsMember"] boolValue];
    
    NSString *memberPriceString = [productDic objectForKey:@"memberPrice"];
    NSString *discountPriceStrng = [productDic objectForKey:@"discountPrice"];
    NSString *priceString = [productDic objectForKey:@"price"];
    int memberPrice = [memberPriceString intValue];
    int disPrice  = [discountPriceStrng intValue];
    int originalPrice = [priceString intValue];
    
    if (!IsMemberBool) {
        _vipView.hidden = YES;
//        _customView.frame = _vipView.frame;
        _gyPriceLabel.text = [NSString stringWithFormat:@"￥%d",disPrice];
        _zgPriceLabel.text = [NSString stringWithFormat:@"专柜价:￥%d", originalPrice];
        _zgPriceLabel.strikeThroughEnabled = YES;
        _vipView.hidden = NO;
        _hyPricelabel.hidden = YES;
        _vipPriceLable.hidden = YES;
        _gouYInLabel.hidden = NO;
        _gyPriceLabel.hidden = NO;
        _zgPriceLabel.hidden = NO;
  
    } else {
        _vipView.hidden = NO;
        _gouYInLabel.hidden = YES;
        _gyPriceLabel.hidden = YES;
        _zgPriceLabel.hidden = YES;
        _vipPriceLable.text = [NSString stringWithFormat:@"￥%d",memberPrice];
        _discountPriceLable.text = [NSString stringWithFormat:@"购引价:￥%d",disPrice];
        _originalPriceLable.text = [NSString stringWithFormat:@"专柜价:￥%d", originalPrice];
        _discountPriceLable.strikeThroughEnabled = YES;
        _originalPriceLable.strikeThroughEnabled = YES;
    }
    
    _productNameLable.text = [productDic objectForKey:@"productName"];
    [_brandLogoImage setImageWithURL:[NSURL URLWithString:[productDic objectForKey:@"brandLogo"]] placeholderImage:nil];
        
    _colorLable.text = [productDic objectForKey:@"color"];
    _stockLable.text = [productDic objectForKey:@"stock"];

    NSMutableArray *skyArray = [productDic objectForKey:@"skuList"];
    NSMutableArray *shopArray = [productDic objectForKey:@"shopList"];
    NSDictionary *skuShopList = [productDic objectForKey:@"skuShopList"];
    
    //图片集合
    _klpArr = [productDic objectForKey:@"picUrls"];
    if (_klpArr.count != 0 && _klpArr != nil) {
        [self showProductImageOnSrollView:_klpArr];
    }
    
    //遍历尺码
    int stock = [[[dic objectForKey:@"productDetail"] objectForKey:@"stock"] intValue];
    NSLog(@"库存：%d",stock);
    if (stock != 0) {
        [self shoppingAction:skyArray shopList:shopArray skuShopList:skuShopList];
    }
    else {
        [_shopButton setBackgroundImage:[UIImage imageNamed:@"收藏-灰色"] forState:UIControlStateNormal];
        [_ydButton setBackgroundImage:[UIImage imageNamed:@"立即预定灰色"] forState:UIControlStateNormal];
        [_shopButton setEnabled:NO];
        [_ydButton setEnabled:NO];
        _stockImageView.hidden = NO;
        
    }
    //商品说明
    NSString *explainStr = [productDic objectForKey:@"productionExplain"];

    UILabel *explainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, 0, EXPLAIN_TITLE_FOUR, 21)] autorelease];
    [explainLabel setText:@"商品说明:"];
    explainLabel.textColor = BACKGROUNDCOLOR;
    [explainLabel setBackgroundColor:[UIColor clearColor]];
    explainLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    [_explainView addSubview:explainLabel];
    //商品说明描述
    UILabel *explainStringLabel = [[[UILabel alloc] initWithFrame:CGRectMake(explainLabel.frame.size.width, explainLabel.frame.origin.y+3, IPHONE_WIDTH -10 - explainLabel.frame.size.width, 21)] autorelease];
    explainStringLabel.backgroundColor = [UIColor clearColor];
    explainStringLabel.numberOfLines = 0;
    NSString *string = explainStr;
//    explainStringLabel.text = explainStr;
    explainStringLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    CGSize labsize = [string sizeWithFont:[UIFont systemFontOfSize:EXPLAIN_FONT] constrainedToSize:CGSizeMake(explainStringLabel.frame.size.width, 9999) lineBreakMode:UILineBreakModeCharacterWrap];
    explainStringLabel.frame = CGRectMake(explainStringLabel.frame.origin.x +SPACING_WIDTH, explainStringLabel.frame.origin.y, explainStringLabel.frame.size.width, labsize.height);
    _labelSizeFram.size.height = explainStringLabel.frame.size.height;
    explainStringLabel.text= string;
    [_explainView addSubview:explainStringLabel];
    
    //库存数量
    UILabel *stockLabel = nil;
    //如果商品描述为空的话，库存数量的坐标
    if ([explainStr isEqualToString:@""] || ![explainStr isKindOfClass:[NSString class]]) {
        labsize.height = 21;
       _labelSizeFram.size.height = labsize.height;
        stockLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, explainLabel.frame.size.height-3, EXPLAIN_TITLE_FOUR, 21)] autorelease];
    } else {
        stockLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, explainStringLabel.frame.size.height, EXPLAIN_TITLE_FOUR, 21)] autorelease];
    }
    [stockLabel setText:@"库存数量:"];
    stockLabel.textColor = BACKGROUNDCOLOR;
    [stockLabel setBackgroundColor:[UIColor clearColor]];
    [stockLabel setFont:[UIFont systemFontOfSize:EXPLAIN_FONT]];
    [_explainView addSubview:stockLabel];
    
    UILabel *stockLabelTextString = [[[UILabel alloc] initWithFrame:CGRectMake(stockLabel.frame.size.width+SPACING_WIDTH , stockLabel.frame.origin.y, IPHONE_WIDTH-10 - stockLabel.frame.size.width, stockLabel.frame.size.height)] autorelease];
    stockLabelTextString.backgroundColor = [UIColor clearColor];
    stockLabelTextString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    stockLabelTextString.text = [productDic objectForKey:@"stock"];
    [_explainView addSubview:stockLabelTextString];
    //品牌
    UILabel *brandLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, stockLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
    [brandLabel setText:@"品牌:"];
    brandLabel.textColor = BACKGROUNDCOLOR;
    [brandLabel setBackgroundColor:[UIColor clearColor]];
    [brandLabel setFont:[UIFont systemFontOfSize:EXPLAIN_FONT]];
    [_explainView addSubview:brandLabel];
    
    UILabel *brandLabelTextString = [[[UILabel alloc] initWithFrame:CGRectMake(brandLabel.frame.size.width+SPACING_WIDTH , brandLabel.frame.origin.y, IPHONE_WIDTH-10 - brandLabel.frame.size.width, brandLabel.frame.size.height)] autorelease];
    brandLabelTextString.backgroundColor = [UIColor clearColor];
    brandLabelTextString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    brandLabelTextString.text = [productDic objectForKey:@"brandName"];
    [_explainView addSubview:brandLabelTextString];
    
    //面料
    UILabel *meterialLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, brandLabel.frame.origin.y +15, EXPLAIN_TITLE_TWO, 21)] autorelease];
    [meterialLabel setText:@"面料:"];
    meterialLabel.textColor = BACKGROUNDCOLOR;
    [meterialLabel setBackgroundColor:[UIColor clearColor]];
    [meterialLabel setFont:[UIFont systemFontOfSize:EXPLAIN_FONT]];
    [_explainView addSubview:meterialLabel];
    
    UILabel *meterialLabelTextString = [[[UILabel alloc] initWithFrame:CGRectMake(meterialLabel.frame.size.width+SPACING_WIDTH , meterialLabel.frame.origin.y, IPHONE_WIDTH-10 - meterialLabel.frame.size.width, meterialLabel.frame.size.height)] autorelease];
    meterialLabelTextString.backgroundColor = [UIColor clearColor];
    meterialLabelTextString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    meterialLabelTextString.text = [productDic objectForKey:@"material"];
    [_explainView addSubview:meterialLabelTextString];
    
    //版型
    UILabel *clothesStyleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, meterialLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
    [clothesStyleLabel setText:@"版型:"];
    clothesStyleLabel.textColor = BACKGROUNDCOLOR;
    [clothesStyleLabel setBackgroundColor:[UIColor clearColor]];
    [clothesStyleLabel setFont:[UIFont systemFontOfSize:EXPLAIN_FONT]];
    [_explainView addSubview:clothesStyleLabel];
    
    UILabel *clothesStyleLabelTextString = [[[UILabel alloc] initWithFrame:CGRectMake(clothesStyleLabel.frame.size.width +SPACING_WIDTH, clothesStyleLabel.frame.origin.y, IPHONE_WIDTH-10 - brandLabel.frame.size.width, clothesStyleLabel.frame.size.height)] autorelease];
    clothesStyleLabelTextString.backgroundColor = [UIColor clearColor];
    clothesStyleLabelTextString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    clothesStyleLabelTextString.text = [productDic objectForKey:@"clothesStyle"];
    [_explainView addSubview:clothesStyleLabelTextString];
    
    //以上的总高度
//    float height = explainStringLabel.frame.size.height + stockLabel.frame.size.height + brandLabel.frame.size.height + meterialLabel.frame.size.height + clothesStyleLabel.frame.size.height;

    UILabel *clothesLeanthLabel = nil; //衣长
    UILabel *skithesLengthLabel = nil; //裙长
    UILabel *trousersLengthLabel = nil; //裤长
    UILabel *sleeveLength = nil; //袖长
    UILabel *boxSizeLabel = nil; //箱包尺寸
    UILabel *shoesHeelLabel = nil; //跟高
    UILabel *craftLabel = nil; //工艺
    UILabel *marketTimeLabel = nil; //上市时间
    UILabel *afterSalesTerms = nil; //售后条款
    
    UILabel *clothesLeanthLabelString = nil; 
    UILabel *skithesLengthLabelString = nil;
    UILabel *trousersLengthLabelString = nil;
    UILabel *sleeveLengthString = nil;
    UILabel *boxSizeLabelString = nil;
    UILabel *shoesHeelLabelString = nil;
    UILabel *craftLabelString = nil;
    UILabel *marketTimeLabelString = nil;
    UILabel *afterSalesTermsString = nil;

    //显示相应的产品信息 上衣，包，半身裙
    NSString *styleTypeNameStr = [productDic objectForKey:@"styleTypeName"];
    NSLog(@"productdic:%@",productDic);
    NSLog(@"styleTypeNameStr:%@",styleTypeNameStr);
    if ([styleTypeNameStr isEqualToString:@""] || ![styleTypeNameStr isKindOfClass:[NSString class]]) {
         styleTypeNameStr = @"上装";
    }
    CGRect myFrame;
//    NSString *styleTypeNameStr = @"上装";
    if ([styleTypeNameStr isEqualToString:@"上装"]) {
        clothesLeanthLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, clothesStyleLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
        clothesLeanthLabel.backgroundColor = [UIColor clearColor];
        clothesLeanthLabel.text = @"衣长:";
        clothesLeanthLabel.textColor = BACKGROUNDCOLOR;
        clothesLeanthLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        clothesLeanthLabelString  = [[[UILabel alloc] initWithFrame:CGRectMake(clothesLeanthLabel.frame.size.width+SPACING_WIDTH, clothesLeanthLabel.frame.origin.y, IPHONE_WIDTH-10 - clothesLeanthLabel.frame.size.width, clothesLeanthLabel.frame.size.height)] autorelease];
        clothesLeanthLabelString.backgroundColor = [UIColor clearColor];
        clothesLeanthLabelString.text =[productDic objectForKey:@"clothesLength"];
        [clothesLeanthLabelString setFont:[UIFont systemFontOfSize:EXPLAIN_FONT]];

        
//        skithesLengthLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, clothesStyleLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
//        skithesLengthLabel.backgroundColor = [UIColor clearColor];
//        skithesLengthLabel.text = @"裙长:";
//        skithesLengthLabel.textColor = BACKGROUNDCOLOR;
//        skithesLengthLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
//        
//        skithesLengthLabelString  = [[[UILabel alloc] initWithFrame:CGRectMake(skithesLengthLabel.frame.size.width+SPACING_WIDTH, skithesLengthLabel.frame.origin.y, IPHONE_WIDTH-10 - skithesLengthLabel.frame.size.width, skithesLengthLabel.frame.size.height)] autorelease];
//        skithesLengthLabelString.backgroundColor = [UIColor clearColor];
//        skithesLengthLabelString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
//        skithesLengthLabelString.text = [productDic objectForKey:@"clothesLength"];
        
        [_explainView addSubview:clothesLeanthLabel];
//        [_explainView addSubview:skithesLengthLabel];
        [_explainView addSubview:clothesLeanthLabelString];
//        [_explainView addSubview:skithesLengthLabelString];
        
        myFrame.origin.y = clothesLeanthLabel.frame.origin.y;
        
    }
    else if([styleTypeNameStr isEqualToString:@"裤装"]) {
        
        trousersLengthLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, clothesStyleLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
        trousersLengthLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        trousersLengthLabel.text = @"裤长:";
        trousersLengthLabel.textColor = BACKGROUNDCOLOR;
        trousersLengthLabel.backgroundColor = [UIColor clearColor];
        [_explainView addSubview:trousersLengthLabel];
    
        trousersLengthLabelString  = [[[UILabel alloc] initWithFrame:CGRectMake(trousersLengthLabel.frame.size.width+SPACING_WIDTH, trousersLengthLabel.frame.origin.y, IPHONE_WIDTH-10 - trousersLengthLabel.frame.size.width, trousersLengthLabel.frame.size.height)] autorelease];
        trousersLengthLabelString.backgroundColor = [UIColor clearColor];
        trousersLengthLabelString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        trousersLengthLabelString.text = [productDic objectForKey:@"trousersLength"];
        [_explainView addSubview:trousersLengthLabelString];
        
        myFrame.origin.y = trousersLengthLabel.frame.origin.y;
    }
    else if([styleTypeNameStr isEqualToString:@"鞋"]) {
        
        shoesHeelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, clothesStyleLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
        shoesHeelLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        shoesHeelLabel.text = @"跟高:";
        shoesHeelLabel.textColor = BACKGROUNDCOLOR;
        shoesHeelLabel.backgroundColor = [UIColor clearColor];
        [_explainView addSubview:shoesHeelLabel];
        
        shoesHeelLabelString  = [[[UILabel alloc] initWithFrame:CGRectMake(shoesHeelLabel.frame.size.width+SPACING_WIDTH, shoesHeelLabel.frame.origin.y, IPHONE_WIDTH-10 - shoesHeelLabel.frame.size.width, shoesHeelLabel.frame.size.height)] autorelease];
        shoesHeelLabelString.backgroundColor = [UIColor clearColor];
        shoesHeelLabelString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        shoesHeelLabelString.text =[productDic objectForKey:@"shoesHeel"];
        [_explainView addSubview:shoesHeelLabelString];
        myFrame.origin.y = shoesHeelLabel.frame.origin.y;
    }
    else if([styleTypeNameStr isEqualToString:@"内衣"]) {
        myFrame.origin.y = clothesStyleLabel.frame.origin.y;
    }
    else if([styleTypeNameStr isEqualToString:@"裙装"]) {
        
        skithesLengthLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, clothesStyleLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
        skithesLengthLabel.backgroundColor = [UIColor clearColor];
        skithesLengthLabel.text = @"裙长:";
        skithesLengthLabel.textColor = BACKGROUNDCOLOR;
        skithesLengthLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];

        skithesLengthLabelString  = [[[UILabel alloc] initWithFrame:CGRectMake(skithesLengthLabel.frame.size.width+SPACING_WIDTH, skithesLengthLabel.frame.origin.y, IPHONE_WIDTH-10 - skithesLengthLabel.frame.size.width, skithesLengthLabel.frame.size.height)] autorelease];
        skithesLengthLabelString.backgroundColor = [UIColor clearColor];
        [skithesLengthLabelString setFont:[UIFont systemFontOfSize:EXPLAIN_FONT]];
        skithesLengthLabelString.text = [productDic objectForKey:@"skirtLength"];
        
        
        sleeveLength = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, skithesLengthLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
        sleeveLength.backgroundColor = [UIColor clearColor];
        sleeveLength.text = @"袖长:";
        sleeveLength.textColor  = BACKGROUNDCOLOR;
        sleeveLength.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        
        sleeveLengthString  = [[[UILabel alloc] initWithFrame:CGRectMake(sleeveLength.frame.size.width+SPACING_WIDTH, sleeveLength.frame.origin.y, IPHONE_WIDTH-10 - sleeveLength.frame.size.width, skithesLengthLabel.frame.size.height)] autorelease];
        sleeveLengthString.backgroundColor = [UIColor clearColor];
        sleeveLengthString.text =[productDic objectForKey:@"sleeveLength"];
        sleeveLengthString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        
        [_explainView addSubview:skithesLengthLabel];
        [_explainView addSubview:skithesLengthLabelString];
        [_explainView addSubview:sleeveLength];
        [_explainView addSubview:sleeveLengthString];
        
        myFrame.origin.y = sleeveLength.frame.origin.y;

    }
//    else if([styleTypeNameStr isEqualToString:@"半身裙"]) {
//        
//        skithesLengthLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, clothesStyleLabel.frame.origin.y + 15, EXPLAIN_TITLE_TWO, 21)] autorelease];
//        skithesLengthLabel.backgroundColor = [UIColor clearColor];
//        skithesLengthLabel.text = @"裙长:";
//        skithesLengthLabel.textColor = BACKGROUNDCOLOR;
//        skithesLengthLabelString  = [[[UILabel alloc] initWithFrame:CGRectMake(skithesLengthLabel.frame.size.width+SPACING_WIDTH, skithesLengthLabel.frame.origin.y, IPHONE_WIDTH-10 - skithesLengthLabel.frame.size.width, skithesLengthLabel.frame.size.height)] autorelease];
//        skithesLengthLabelString.backgroundColor = [UIColor clearColor];
//        skithesLengthLabelString.text = [productDic objectForKey:@"skirtLength"];
//        [skithesLengthLabelString setFont:[UIFont systemFontOfSize:EXPLAIN_FONT]];
//        [_explainView addSubview:skithesLengthLabel];
//        [_explainView addSubview:skithesLengthLabelString];
//        
//        myFrame.origin.y = skithesLengthLabel.frame.origin.y;
//        
//    }
    else if([styleTypeNameStr isEqualToString:@"配饰"]) {
        NSLog(@"走了配饰");
        myFrame.origin.y = clothesStyleLabel.frame.origin.y;
//        return;
    }
    else if([styleTypeNameStr isEqualToString:@"包"]) {
        boxSizeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, clothesStyleLabel.frame.origin.y + 15, EXPLAIN_TITLE_FOUR, 21)] autorelease];
        boxSizeLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        boxSizeLabel.backgroundColor = [UIColor clearColor];
        boxSizeLabel.text = @"箱包尺寸:";
        boxSizeLabel.textColor = BACKGROUNDCOLOR;
        [_explainView addSubview:boxSizeLabel];
        
        boxSizeLabelString  = [[[UILabel alloc] initWithFrame:CGRectMake(boxSizeLabel.frame.size.width+SPACING_WIDTH, boxSizeLabel.frame.origin.y, IPHONE_WIDTH-10 - boxSizeLabel.frame.size.width, boxSizeLabel.frame.size.height)] autorelease];
        boxSizeLabelString.backgroundColor = [UIColor clearColor];
        boxSizeLabelString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
        boxSizeLabelString.text = [productDic objectForKey:@"boxSize"];
        [_explainView addSubview:boxSizeLabelString];

        myFrame.origin.y = boxSizeLabel.frame.origin.y;
    }

    craftLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X,myFrame.origin.y+15, EXPLAIN_TITLE_TWO, EXPLAIN_HEIGHT)] autorelease];
    craftLabel.backgroundColor = [UIColor clearColor];
    craftLabel.text = @"工艺:";
    craftLabel.textColor = BACKGROUNDCOLOR;
    craftLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    [_explainView addSubview:craftLabel];
    
    craftLabelString = [[[UILabel alloc] initWithFrame:CGRectMake(craftLabel.frame.size.width+SPACING_WIDTH, craftLabel.frame.origin.y, IPHONE_WIDTH - craftLabel.frame.size.width, 21)] autorelease];
    craftLabelString.text = [productDic objectForKey:@"craft"];
    craftLabelString.backgroundColor = [UIColor clearColor];
    craftLabelString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    [_explainView addSubview:craftLabelString];
    //开始计算商品说明你等字段的Fram
    
    marketTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X,craftLabel.frame.origin.y + 15, EXPLAIN_TITLE_FOUR, EXPLAIN_HEIGHT)] autorelease];
    marketTimeLabel.backgroundColor = [UIColor clearColor];
    marketTimeLabel.text = @"上市时间:";
    marketTimeLabel.textColor = BACKGROUNDCOLOR;
    marketTimeLabel.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    [_explainView addSubview:marketTimeLabel];
    
    marketTimeLabelString = [[[UILabel alloc] initWithFrame:CGRectMake(marketTimeLabel.frame.size.width+SPACING_WIDTH, marketTimeLabel.frame.origin.y, IPHONE_WIDTH - marketTimeLabel.frame.size.width, 21)] autorelease];
    NSString *dataString = [productDic objectForKey:@"marketTime"];
    if (dataString == nil || ![dataString isKindOfClass:[NSString class]]) {

    } else {
        NSDate *marketTime = [DateUtil stringToDate:dataString withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *marketTimeString = [DateUtil dateToString:marketTime withFormat:@"YYYY年MM月dd日"];
        marketTimeLabelString.text = marketTimeString;
    }

    
    marketTimeLabelString.backgroundColor = [UIColor clearColor];
    marketTimeLabelString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    [_explainView addSubview:marketTimeLabelString];
    
    afterSalesTerms = [[[UILabel alloc] initWithFrame:CGRectMake(EXPLAIN_X, marketTimeLabel.frame.origin.y+15, EXPLAIN_TITLE_FOUR, EXPLAIN_HEIGHT)] autorelease];
    afterSalesTerms.backgroundColor = [UIColor clearColor];
    afterSalesTerms.text = @"售后条款:";
    afterSalesTerms.textColor = BACKGROUNDCOLOR;
    afterSalesTerms.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    [_explainView addSubview:afterSalesTerms];
    
    afterSalesTermsString = [[[UILabel alloc] initWithFrame:CGRectMake(afterSalesTerms.frame.size.width+SPACING_WIDTH, afterSalesTerms.frame.origin.y, IPHONE_WIDTH - afterSalesTerms.frame.size.width-20, 60)] autorelease];
    [afterSalesTermsString setLineBreakMode:UILineBreakModeCharacterWrap];
    afterSalesTermsString.text = [productDic objectForKey:@"afterSalesTerms"];
    [afterSalesTermsString setNumberOfLines:3];
    
    NSString *string1 = afterSalesTermsString.text;
    //    explainStringLabel.text = explainStr;
    afterSalesTermsString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    CGSize labsize1 = [string1 sizeWithFont:[UIFont systemFontOfSize:EXPLAIN_FONT] constrainedToSize:CGSizeMake(afterSalesTermsString.frame.size.width, 9999) lineBreakMode:UILineBreakModeCharacterWrap];
    afterSalesTermsString.frame = CGRectMake(afterSalesTerms.frame.size.width + 10, afterSalesTerms.frame.origin.y+4, afterSalesTermsString.frame.size.width, labsize1.height);
    afterSalesTermsString.text= string1;

    afterSalesTermsString.backgroundColor = [UIColor clearColor];
    afterSalesTermsString.font = [UIFont systemFontOfSize:EXPLAIN_FONT];
    [_explainView addSubview:afterSalesTermsString];

    if (_shopViewHeight > 0) {
        _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, _mainScrollView.frame.size.height + _underSizeView.frame.size.height + 30*_shopViewHeight + _labelSizeFram.size.height+3 + marketTimeLabel.frame.size.height + afterSalesTerms.frame.size.height + craftLabel.frame.size.height-200);
        return;
    }
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, _mainScrollView.frame.size.height + _underSizeView.frame.size.height+ _labelSizeFram.size.height+3 + + marketTimeLabel.frame.size.height + afterSalesTerms.frame.size.height + craftLabel.frame.size.height-200);

}
-(void)requestProductDetailInfoFail:(ASIFormDataRequest*)request{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   [self.view makeToast:NETWORK_STRING  duration:0.5 position:@"center" title:nil];

}

#define COLUMN 4
- (void)shoppingAction:(NSMutableArray *)skulist shopList:(NSMutableArray *)shopArray skuShopList:(NSDictionary *)skushop {

    self.sizeArray = [NSArray arrayWithArray:skulist];
    self.addressArray = [NSArray arrayWithArray:shopArray];
    self.skuDic = [NSDictionary dictionaryWithDictionary:skushop];
    
    //遍历有多少个尺寸显示
//    int rows = (_sizeArray.count / COLUMN) + ((_sizeArray.count % COLUMN) > 0 ? 1 : 0);
    for (int i=0; i<_sizeArray.count; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.text = [NSString stringWithFormat:@"%d",i];
        [button setTitleColor:[UIColor colorWithRed:240.0f/255.0f green:96.0f/255.0f blue:0.0f alpha:1.0] forState:UIControlStateNormal];
        [button setTag:[[[self.sizeArray objectAtIndex:i] objectForKey:@"id"] intValue]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        //如果尺码大于一行
        _shopViewHeight = row;
        button.frame = CGRectMake(68+62*column, 346+30*row , 60, 28);

        [button setBackgroundImage:[UIImage imageNamed:@"尺码BG"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"尺码BG选中"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(sizeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(68+62*column, 346+30*row , 60, 28)];
        NSString *size = [[self.sizeArray objectAtIndex:i] objectForKey:@"name"];

        
        label.text = size;
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self.mainScrollView addSubview:label];
        [label release];
    }
    
    //重新调整显示店铺的view和店铺之下的view
    if (_shopViewHeight > 0) {
        _displayShopView.frame = CGRectMake(_displayShopView.frame.origin.x, _displayShopView.frame.origin.y + 30*_shopViewHeight, _displayShopView.bounds.size.width, _displayShopView.bounds.size.height);
        _underSizeView.frame = CGRectMake(_underSizeView.frame.origin.x, _underSizeView.frame.origin.y + 30*_shopViewHeight, _underSizeView.bounds.size.width, _underSizeView.bounds.size.height);
        NSLog(@"%@",_underSizeView);
    }
    
    _sizeView.frame = CGRectMake(_sizeView.frame.origin.x, _sizeView.frame.origin.y, _sizeArray.count*30, 30);
    _sizeScro.contentSize = CGSizeMake(_sizeArray.count*30, 31);
    _sizeScro.backgroundColor = [UIColor blueColor];
    //遍历有多少个店铺1
    for (int i=0; i<_addressArray.count; i++) {
        
        UILabel *shopLab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, i*44 , 150, 20)];
        shopLab1.text = [[_addressArray objectAtIndex:i] objectForKey:@"name"];
        
        shopLab1.textColor = [UIColor orangeColor];
        shopLab1.backgroundColor = [UIColor clearColor];
        shopLab1.font = [UIFont systemFontOfSize:DIANPU_FOUNT];
        [_shopScrollView addSubview:shopLab1];
        [shopLab1 release];
        
        UIImageView *wayOfPayImage=[[UIImageView alloc]initWithFrame:CGRectMake(_shopScrollView.frame.size.width-135,shopLab1.frame.origin.y+3, 13, 13.5)];
        
        [_shopScrollView addSubview:wayOfPayImage];
        [wayOfPayImage release];
        
        UILabel *isToShopLab1 = [[UILabel alloc]initWithFrame:CGRectMake(wayOfPayImage.frame.origin.x+wayOfPayImage.frame.size.width+3, shopLab1.frame.origin.y,150, 20)];
        
        int payStateid= [[[_addressArray objectAtIndex:i] objectForKey:@"payState"] intValue];
        if (payStateid == 0) {
            isToShopLab1.text = @"仅支持到店支付";
            wayOfPayImage.image=[UIImage imageNamed:@"店切图.png"];
        } else if (payStateid == 1) {
            isToShopLab1.text = @"仅支持在线支付";
            wayOfPayImage.image=[UIImage imageNamed:@"线橘色.png"];
        } else {
            isToShopLab1.text = @"仅支持邮寄";
            wayOfPayImage.image=[UIImage imageNamed:@"邮寄.png"];
            
        }
 
        //支持店铺的颜色 
        isToShopLab1.textColor = [UIColor colorWithRed:94.0f/255.0f green:94.0f/255.0f blue:94.0f/255 alpha:1.0];
        isToShopLab1.backgroundColor = [UIColor clearColor];
        isToShopLab1.font = [UIFont systemFontOfSize:DIANPU_FOUNT];
        [_shopScrollView addSubview:isToShopLab1];
        [isToShopLab1 release];
    }
    [self addressRefresh:_addressArray];
}

- (void)addressRefresh:(NSMutableArray *)addressShopArray {
    [_shopScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //遍历有多少个店铺1
    for (int i=0; i<addressShopArray.count; i++) {
        
        UILabel *shopLab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, i*20 , 150, 20)];
        shopLab1.textColor = [UIColor colorWithRed:240.0f/255.0f green:96.0f/255.0f blue:0.0f alpha:1.0];
        shopLab1.text = [[addressShopArray objectAtIndex:i] objectForKey:@"name"];
//        shopLab1.textColor = [UIColor orangeColor];
        shopLab1.backgroundColor = [UIColor clearColor];
        shopLab1.font = [UIFont systemFontOfSize:DIANPU_FOUNT];
        [_shopScrollView addSubview:shopLab1];
        [shopLab1 release];
        
        UIImageView *wayOfPayImage=[[UIImageView alloc]initWithFrame:CGRectMake(_shopScrollView.frame.size.width-135,shopLab1.frame.origin.y+3, 13, 13.5)];
        
        [_shopScrollView addSubview:wayOfPayImage];
        [wayOfPayImage release];
        
        UILabel *isToShopLab1 = [[UILabel alloc]initWithFrame:CGRectMake(wayOfPayImage.frame.origin.x+wayOfPayImage.frame.size.width+3,shopLab1.frame.origin.y,150, 20)];

        
        int payStateid= [[[addressShopArray objectAtIndex:i] objectForKey:@"payState"] intValue];
        
        NSLog(@"%@", [addressShopArray objectAtIndex:i]);
        
        if (payStateid == 0) {
            isToShopLab1.text = @"仅支持到店支付";
            wayOfPayImage.image=[UIImage imageNamed:@"店切图.png"];
        } else if(payStateid == 1){
            isToShopLab1.text = @"仅支持在线支付";
            wayOfPayImage.image=[UIImage imageNamed:@"线橘色.png"];
        } else {
            isToShopLab1.text = @"仅支持邮寄";
            wayOfPayImage.image=[UIImage imageNamed:@"邮寄.png"];

        }
        
        isToShopLab1.textColor = [UIColor colorWithRed:94.0f/255.0f green:94.0f/255.0f blue:94.0f/255 alpha:1.0];
        isToShopLab1.backgroundColor = [UIColor clearColor];
        isToShopLab1.font = [UIFont systemFontOfSize:DIANPU_FOUNT];
        [_shopScrollView addSubview:isToShopLab1];
        [isToShopLab1 release];
        
        //点击选中打钩
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setTag:[[[addressShopArray objectAtIndex:i] objectForKey:@"id"] intValue]];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"勾选框_未选"] forState:UIControlStateNormal];
        [selectButton setFrame:CGRectMake(0, i*20, 320, 20)];
        [selectButton addTarget:self action:@selector(selectShopAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shopScrollView addSubview:selectButton];
//        [selectButton sendSubviewToBack:_shopScrollView];
        
    }
    [self.displayShopView addSubview:_shopScrollView];
    _shopScrollView.contentSize = CGSizeMake(_shopScrollView.frame.size.width, addressShopArray.count*27);
    
}

- (void)selectShopAction:(id)sender {
    UIButton *but = (UIButton *)sender;
    if (!but) {
        return;
    }
    self.addressBOOL = NO;
    
    for (int i=0; i<self.addressArray.count; i++) {
        
        if ([[[self.addressArray objectAtIndex:i] objectForKey:@"id"] isEqualToString:[NSString stringWithFormat:@"%d", but.tag]]) {
            int payStateid= [[[self.addressArray objectAtIndex:i] objectForKey:@"payState"] intValue];
            //储存到店支付状态
            _payState = payStateid;
            _addressString = [[self.addressArray objectAtIndex:i] objectForKey:@"name"];
        }
        UIButton *button = (UIButton *)[self.view viewWithTag:[[[self.addressArray objectAtIndex:i] objectForKey:@"id"] intValue]];
        if (!self.roleBOOL) {
            [self.view makeToast:@"请先选中尺码!" duration:0.5 position:@"center" title:nil];
            if (button.selected) {
                button.selected = NO;
                [button setImage:[UIImage imageNamed:@"勾选框_未选"] forState:UIControlStateNormal];
            } else {
            }
            
        } else {
            
            if (button.tag != but.tag) {
                if (button.selected) {
                    button.selected = NO;
                    [button setImage:[UIImage imageNamed:@"勾选框_未选"] forState:UIControlStateNormal];
                } else {
                }
            } else {
                button.selected = YES;
                [button setImage:[UIImage imageNamed:@"勾选框_选中"] forState:UIControlStateNormal];
                self.payState = [[[self.addressArray objectAtIndex:i] objectForKey:@"payState"] intValue];
                self.addressBOOL = YES;
            }
            
        }
    }
    
    self.shopid = but.tag;
    NSLog(@"%d",but.tag);
}

#pragma mark
#pragma mark   显示商品所有图片
/*
 方法名称:showProductImageOnSrollView:(NSMutableArray*)productImageArray
 功能描述: 在请求完成以后显示商品的所有图片
 传入参数:(NSMutableArray*)productImageArray,传入前请确保数组非空
 传出参数：N/A
 返回值:N/A
 */
- (void) showProductImageOnSrollView:(NSMutableArray*)productImageArray{
    
    if (!productImageArray || ![productImageArray isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    [_productImageViewScrollView setContentSize:CGSizeMake(251*productImageArray.count , 230)];//设置ScrollView滚动范围
    _productImageViewScrollView.clipsToBounds = NO;
    _productImageViewScrollView.delegate = self;
    _productImagePageControl.currentPage = 0;
    for (int i = 0; i < productImageArray.count; i++) {
        //创建图片
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake((228+ 20)*i+10, 0,228, 230)];
        [imageview setImageWithURL:[NSURL URLWithString:[productImageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"详情水印"]];
//        [imageview setImageURL:[NSURL URLWithString:[productImageArray objectAtIndex:i]]];
        imageview.userInteractionEnabled = YES;
        [_productImageViewScrollView addSubview:imageview];
        [imageview release];
    }
    //设置PageControl页数
    [_productImagePageControl setNumberOfPages:productImageArray.count];
    [_mainScrollView bringSubviewToFront:_productImagePageControl];
    [self.productImageViewScrollView bringSubviewToFront:_stockImageView];

}

#pragma mark
#pragma mark   UIScrollViewDelegate M
/*
 方法名称:scrollViewDidScroll:(UIScrollView *)scrollView
 功能描述: 在scrollView的代理方法中修改pageControl的坐标
 传入参数:(UIScrollView *)scrollView
 传出参数：N/A
 返回值:N/A
 */
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.productImagePageControl.currentPage = scrollView.contentOffset.x/251;
}

#pragma mark
#pragma mark   ********商品详情分字段设置颜色、字体样式、字体大小*********
- (void)setSummaryText:(NSString *)text {
 
    [self willChangeValueForKey:@"summaryText"];
    [self didChangeValueForKey:@"summaryText"];
    
    [self.productDetailLable setText:text   afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *regexp = NameRegularExpression();//正则表达式
        NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];  //使用正则表达式进行匹配
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:kSummaryTextFontSize];
        CTFontRef boldFont = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL); //字体转换,UIfont ——>CTFont
        if (boldFont) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)boldFont range:nameRange];  //给字符串设置字体
            CFRelease(boldFont);
            
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:nameRange];  //设置颜色
            
        }
        //正则匹配剩下的部分
        regexp = ParenthesisRegularExpression();
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            UIFont *italicSystemFont = [UIFont italicSystemFontOfSize:kSummaryTextFontSize];
            CTFontRef italicFont = CTFontCreateWithName((CFStringRef)italicSystemFont.fontName, italicSystemFont.pointSize, NULL);
            if (italicFont) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)italicFont range:result.range];
                CFRelease(italicFont);
                
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:result.range];
            }
        }];
        
        return mutableAttributedString;
    }];
    
}

#pragma mark
#pragma mrak   ********计算商品详情的高度*********
- (CGFloat)heightForCellWithText:(NSString *)text {
    CGFloat height = 10.0f;
    height += ceilf([text sizeWithFont:[UIFont systemFontOfSize:kSummaryTextFontSize] constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    height += kAttributedVerticalMargin;
    return height;
}

+(void)setPushState:(int)state{
    
    pushState = state;
    
}

#pragma mark ---------- 点击尺码
- (IBAction)selectSizeSeeAction:(id)sender {
    
    NSDictionary *sizeDic = self.prductDetailDic;
    NSString *brandidStr = [sizeDic objectForKey:@"brandId"];
    NSString *styleTypeStr = [sizeDic objectForKey:@"styleTypeId"];
    NSString *genderStr = [sizeDic objectForKey:@"gender"];
    SizeWebVC *swc = [[[SizeWebVC alloc] initWithNibName:nil bundle:nil] autorelease];
    swc.brandidString = brandidStr;
    swc.styleTypeIdString = styleTypeStr;
    swc.genderString = genderStr;
////     brandId=4 styletypeid=1 gender=2
//    swc.brandidString = @"4";
//    swc.styleTypeIdString = @"1";
//    swc.genderString = @"2";
    [self.navigationController pushViewController:swc animated:YES];
//    [self presentModalViewController:swc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (pushState!=2) {
        [self setHidesBottomBarWhenPushed:NO];
        
    }
    [MobClick endLogPageView:@"TowPage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark --------UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        LoginViewController *login = [[[LoginViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [self.navigationController pushViewController:login animated:YES];  //此处不能启用动画，否则登陆界面导航栏会出现问题
        
        [self.navigationController setNavigationBarHidden:NO]; //此处导航栏属性不能设为YES，否则登陆界面导航栏完全不能显示
        
    } else if (buttonIndex == 1) {
        
        RegisterView *regist  = [[[RegisterView alloc] initWithNibName:nil bundle:nil] autorelease];
        [self.navigationController pushViewController:regist animated:YES];
        
        [self.navigationController setNavigationBarHidden:NO]; //此处导航栏属性不能设为YES，否则登陆界面导航栏完全不能显示
        
    }
    
}

#pragma mark
#pragma mark----使用张猛那边的方法

-(void)checkUserPhoneNumber{ //向后台查询用户电话是否已录入
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviveId"];
    
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
    NSString *urlString = [NSString stringWithFormat:@"%@/user/userSize",SEVERURL];
    
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];//  发送同步请求
    
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
    
    if ([dic objectForKey:@"phone"]) {
//        [self showPromptBox:[dic objectForKey:@"phone"]];
        [Util saveUserPhoneNumber:[dic objectForKey:@"phone"]];
        [self buyItNowAction:self.tempDic];
        
    }else{
        [self showIputBox];
    }
}

-(void)showIputBox{
    _inPutboxImage=[[UIImageView alloc]initWithFrame:CGRectMake(36,20,253,202)];
    _inPutboxImage.image=[UIImage imageNamed:@"弹出框.png"];
    _inPutboxImage.userInteractionEnabled=YES;
    [self.view  addSubview:_inPutboxImage];
    [_inPutboxImage release];
    
    UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(20, 10, 210, 80)];
    textview.font=[UIFont systemFontOfSize:14.0f];
    textview.backgroundColor=[UIColor clearColor];
    textview.textColor=[UIColor whiteColor];
    textview.editable=NO;
    
    textview.text=@"您还没有留下联系方式，为方便店柜导购与您确认订单\n请输入您的手机号码：\n";
    [_inPutboxImage addSubview:textview];
    [textview release];
    
    
    UIImageView *inputFieldImage=[[UIImageView alloc]initWithFrame:CGRectMake(25, textview.frame.origin.x+textview.frame.size.height, 195, 30)];
    inputFieldImage.image=[UIImage imageNamed:@"弹出框_电话号码输入框.png"];
    inputFieldImage.userInteractionEnabled=YES;
    [_inPutboxImage addSubview:inputFieldImage];
    [inputFieldImage release];
    
    UITextField *inputField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 195, 30)];
    inputField.keyboardType=UIKeyboardTypeNumberPad;
    [inputField setReturnKeyType:UIReturnKeyDone];
    inputField.tag = 100;
    inputField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [inputFieldImage addSubview:inputField];
    [inputField release];
    
    UIButton *quXiao=[UIButton buttonWithType:UIButtonTypeCustom];
    quXiao.frame=CGRectMake(25, inputFieldImage.frame.origin.y+inputFieldImage.frame.size.height+20, 75, 30);
    [quXiao setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
    [quXiao setTitle:@"取消" forState:UIControlStateNormal];
    [quXiao setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [quXiao addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_inPutboxImage addSubview:quXiao];
    
    UIButton *queRen=[UIButton buttonWithType:UIButtonTypeCustom];
    queRen.frame=CGRectMake(145, inputFieldImage.frame.origin.y+inputFieldImage.frame.size.height+20, 75, 30);
    [queRen setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
    [queRen setTitle:@"确认" forState:UIControlStateNormal];
    [queRen setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [queRen addTarget:self action:@selector(countersignAction:) forControlEvents:UIControlEventTouchUpInside];
    [_inPutboxImage addSubview:queRen];
}

-(void)cancleAction:(UIButton*)sender{ //电话录入框上的取消按钮
    UITextField *field=(UITextField*)[_inPutboxImage viewWithTag:100];
    [field resignFirstResponder];
    _inPutboxImage.hidden=YES;
    [self updatecartList:100];
}
#pragma mark
#pragma mark  提示信息框
-(void)showPromptBox:(NSString*)phoneNumber{

    _promptBox=[[UIImageView alloc]initWithFrame:CGRectMake(36,60,253,202)];
    _promptBox.image=[UIImage imageNamed:@"弹出框.png"];
    _promptBox.userInteractionEnabled=YES;
    [self.view addSubview:_promptBox];
    [_promptBox release];
    
    [self.mainScrollView setUserInteractionEnabled:NO];
    
    NSString *textViewString = nil;
    
    if (_payState==0) {
        NSString *timeString=[DateUtil getMyTime:self.takeTime];
        NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date=[outputFormatter dateFromString:timeString];
        NSString *week=[DateUtil  GetWeekDayFromDate:date];
        
        textViewString=[NSString stringWithFormat:@"请您于%@(%@)前到店取货",timeString,week];
    }else if (_payState == 1){
        textViewString=[NSString stringWithFormat:@"请您在支付成功后到店取货,过期货品将不为您保留"];
    }else{

        textViewString=[NSString stringWithFormat:@"您货品会在稍后为您寄出,如有疑问请与客服联系"];
    
    }
    UILabel *textview=[[UILabel alloc]initWithFrame:CGRectMake(20,35,210,10)];
    textview.font=[UIFont systemFontOfSize:15.0f];
    textview.backgroundColor=[UIColor clearColor];
    textview.textColor=[UIColor whiteColor];
    
    textview.numberOfLines=0;
    CGRect rect=textview.frame;
    CGSize size=[textViewString sizeWithFont:textview.font constrainedToSize:CGSizeMake(210, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    rect.size.height=size.height;
    [textview setFrame:CGRectMake(20, 20, 210, rect.size.height)];
    textview.text=textViewString;
    [_promptBox addSubview:textview];
    [textview release];
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(18, textview.frame.origin.y+textview.frame.size.height+10,80,20)];
    lable.text=[NSString stringWithFormat:@"您的手机号:"];
    lable.textColor=[UIColor whiteColor];
    lable.backgroundColor=[UIColor clearColor];
    lable.font=[UIFont systemFontOfSize:15.0];
    [_promptBox addSubview:lable];
    [lable release];
    
    UITextField *phonrField=[[UITextField alloc]initWithFrame:CGRectMake(lable.frame.origin.x+lable.frame.size.width, lable.frame.origin.y, 120, 20)];
    phonrField.borderStyle=UITextBorderStyleLine;
    phonrField.tag = 2008;
    phonrField.keyboardType=UIKeyboardTypeNumberPad;
    phonrField.text=phoneNumber;
    phonrField.delegate=self;
    phonrField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    phonrField.backgroundColor=[UIColor whiteColor];
    [_promptBox addSubview:phonrField];
    [phonrField release];
    
    UIButton *zhiDao=[UIButton buttonWithType:UIButtonTypeCustom];
    zhiDao.frame=CGRectMake(85,phonrField.frame.origin.y+phonrField.frame.size.height+10, 75, 30);
    [zhiDao setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
    [zhiDao setTitle:@"确定" forState:UIControlStateNormal];
    [zhiDao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [zhiDao addTarget:self action:@selector(iKnow:) forControlEvents:UIControlEventTouchUpInside];
    [_promptBox addSubview:zhiDao];
    
    if (_payState==1) {
        zhiDao.frame=CGRectMake(45,phonrField.frame.origin.y+phonrField.frame.size.height+10, 75, 30);
        
        UIButton *quxiao=[UIButton buttonWithType:UIButtonTypeCustom];
        quxiao.frame=CGRectMake(zhiDao.frame.origin.x+zhiDao.frame.size.width+20, zhiDao.frame.origin.y, 75, 30);
        
        [quxiao setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
        [quxiao setTitle:@"取消" forState:UIControlStateNormal];
        [quxiao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [quxiao addTarget:self action:@selector(quXiaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_promptBox addSubview:quxiao];

    }
    
}
-(void)quXiaoAction:(UIButton*)sender{
    [self.mainScrollView setUserInteractionEnabled:YES];
    [_inPutboxImage removeFromSuperview];
    [_promptBox removeFromSuperview];
    
}

#pragma mark
#pragma mark   确定电话录入
-(void)countersignAction:(UIButton*)sender{//电话录入框上的确定按钮
    
    UITextField *field=(UITextField*)[_inPutboxImage viewWithTag:100];
    
    if (![Util checkPhoneNumber:field.text]) {
        [self.view makeToast:@"请您输入正确的电话号码" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    [field resignFirstResponder];
    _inPutboxImage.hidden=YES;
    if (![self saveUserPhoneNumber:field.text]) {
        [self.mainScrollView setUserInteractionEnabled:YES];
        [_inPutboxImage removeFromSuperview];
        return;
    }
    
     [self buyItNowAction:self.tempDic];

    
}
#pragma mark
#pragma mark  保存录入电话
-(BOOL)saveUserPhoneNumber:(NSString*)phoneNumber{ //向后台存放用户录入
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq =[NSMutableDictionary dictionary] ;
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviveId"];
    [jsonreq setValue:phoneNumber forKey:@"phone"];
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/add",SEVERURL];
    
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];//  发送同步请求
    
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return  NO;
        }
        if (error) {
            return NO;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        
         [self.view makeToast:@"保存电话失败" duration:0.5 position:@"center" title:nil];
        return NO;
    }
    
    [Util saveUserPhoneNumber:phoneNumber];
    return  YES;
}

#pragma mark ---------- 更新订单状态 立即够买提交订单
-(void)updateOder:(NSString*)orderId{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq =[NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviveId"];
    [jsonreq setValue:[NSNumber numberWithInt:3] forKey:@"orderItemStatus"];
    [jsonreq setValue:orderId forKey:@"orderId"];
    
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
    NSString *urlString = [NSString stringWithFormat:@"%@/cart/updateOrder",SEVERURL];
    
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];//  发送同步请求
    
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
    
    if (responseStatus!=200) {
      
          [self.view makeToast:@"更新订单状态失败" duration:0.5 position:@"center" title:nil];
        return;
    }
    self.takeTime=[dic objectForKey:@"takeTimeStr"];
}

-(void)iKnow:(UIButton*)sender{//录入电话后的提示框上的知道按钮
    
    UITextField *field=(UITextField*)[_promptBox viewWithTag:2008];
    
    if (![Util checkPhoneNumber:field.text]) {
        [self.view makeToast:@"请您输入正确的电话号码" duration:0.5 position:@"center" title:nil];
        return;
    }
        
    [self saveUserPhoneNumber:field.text];
    
    if (_payState==0  || self.payState == 2) {
        
        [self updatecartList:100];
        
    }else if (_payState==1){  //在线支付
        
        [self payOnlineAction];
        
    }
    [_inPutboxImage removeFromSuperview];
    [_promptBox removeFromSuperview];
    
    [self.mainScrollView setUserInteractionEnabled:YES];
}

- (void) payOnlineAction{
    
     // wowgoing账户余额
    float  wowgoingAcount=[[self.stockResultDic objectForKey:@"wowgoingAccount"] floatValue];
   
      //所选商品总价
    float   price=[[[self.stockResultDic objectForKey:@"toBuyNow"]  objectForKey:@"discountPrice"]  floatValue];
    
    NSMutableArray *productArray = [NSMutableArray array];
    
    NSDictionary *buyNowDic = [self.stockResultDic objectForKey:@"toBuyNow"];
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[buyNowDic objectForKey:@"count"] forKey:@"count"];
    [dic setValue:[buyNowDic objectForKey:@"discountPrice"] forKey:@"discountPrice"];
    [dic setValue:[buyNowDic objectForKey:@"orderId"] forKey:@"orderId"];
    [dic setValue:[buyNowDic objectForKey:@"productName"] forKey:@"productName"];
     [productArray addObject:dic];

    if (wowgoingAcount>=price) {
        PayByWgoingVC *payVC=[PayByWgoingVC shareFnalStatementController];
        
        payVC.productsArray=productArray;//商品数组
        [payVC  set_isCartList:NO];
        [payVC set_shouYe:YES];
        [payVC set_notPay:NO];
        payVC.productDic = self.stockResultDic;
        
        [self.navigationController pushViewController:payVC animated:YES];
        self.navigationController.navigationBarHidden=YES;
        
    }else{
        
        FnalStatementVC *fnalVC=[FnalStatementVC shareFnalStatementController];
        
        fnalVC.productsArray = productArray;//商品数组
        
        [fnalVC set_shouYe:YES];
        [fnalVC set_isCartList:NO];
        [fnalVC set_notPay:NO];
        fnalVC.productDic = self.stockResultDic;
        
        [self.navigationController pushViewController:fnalVC animated:YES];
        self.navigationController.navigationBarHidden = YES;
    }
    
}


- (void) addCustomAddressForPostProduct{
    
    AddAddressViewController  *addressVC = [[[AddAddressViewController alloc ] initWithNibName:@"AddAddressViewController" bundle:nil] autorelease];
    addressVC.delegate = self;
    [self presentModalViewController:addressVC animated:YES];
    
}

#pragma mark
#pragma mark    *************获取购物车和专柜取货的商品数**********

-(void)updatecartList:(int)type{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
        
    NSString *urlString;
    if (type==100) {
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,QH_LIST];
        [jsonreq setValue:@"3" forKey:@"orderType"];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_LIST];
    }

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
    requestForm.tag=type;
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm setDidFailSelector:@selector(updatecartListFail:)];
    [requestForm setDidFinishSelector:@selector(updatecartListFinish:)];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [requestForm startAsynchronous];
    
}

- (void)updatecartListFail:(ASIHTTPRequest *)request {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
}


-(void)updatecartListFinish:(ASIHTTPRequest *)request {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
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
    
    NSMutableArray *products=  nil;
    if (requestForm.tag==100) {
        
         products = [dic objectForKey:@"shoppePickup"];
        [Util SaveShoppeArray:products];
        
    }else if (requestForm.tag==101){
        
        products = [dic objectForKey:@"cartList"];
        [Util saveCartListCount:[NSString stringWithFormat:@"%d",products.count]];
        [Util saveCartProducts:products];
    
        [self updatecartList:100];
    }
    [self showListCount:requestForm.tag];
    
}

-(void)showListCount:(int)type{ //显示购物车和专柜取货中的商品数量
    
    LKCustomTabBar *customTabbar=[LKCustomTabBar shareTabBar];
    
    if (type==100) {
        UILabel *countLable1=(UILabel*)[customTabbar.slideQH viewWithTag:1988];
        countLable1.text=[NSString stringWithFormat:@"%d",[Util getShoppeArray].count];
        
        if ([countLable1.text integerValue]!=0) {
            customTabbar.slideQH.hidden=NO;
        }else{
            customTabbar.slideQH.hidden=YES;
        }
        
    }else if (type==101){
        UILabel *countLable=(UILabel*)[customTabbar.slideBg viewWithTag:1986];
        countLable.text=[NSString stringWithFormat:@"%@",[Util takeCartListCount]];
        
        if ([countLable.text integerValue]!=0) {
            customTabbar.slideBg.hidden=NO;
        }else{
            customTabbar.slideBg.hidden=YES;
        }
    }
    
}

#pragma mark
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

//#pragma mark
//#pragma mark  获取wowgoing账户余额
//- (void)takeWowgoingAmount {  //获取wowgoing账户余额
//    
//    WowgoingAccount *wowgoing = [[[WowgoingAccount alloc] init]autorelease];
//    wowgoing.delegate  = self;
//    wowgoing.onSuccessSeletor = @selector(takeWowgoingAmountFinished:);
//    wowgoing.onFaultSeletor = @selector(takeWowgoingAmountFailed:);
//    [wowgoing asyncExecute];
//}
//
//- (void)takeWowgoingAmountFailed:(ASIHTTPRequest *)request
//{
//    [self showToastMessageAtCenter:@"您的网络不给力,请重新试试吧"];
//    
//}
//- (void)takeWowgoingAmountFinished:(ASIHTTPRequest *)request
//{
//    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
//    NSMutableDictionary *dic=nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
//        NSError *error=nil;
//        if (requestForm.responseData.length>0) {
//            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
//        }else{
//            return;
//        }
//        if (error) {
//            return;
//        }
//    }else{
//        NSString *jsonString = [requestForm responseString];
//        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
//        dic = [sbJsonParser objectWithString:jsonString];
//        [sbJsonParser release];
//    }
//    
//    
//    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
//    
//    if (responseStatus!=200) {
//        [self showToastMessageAtCenter:@"您的网络不给力,请重新试试吧"];
//        return;
//    }
//    if (dic == NULL  ) {
//        [self showToastMessageAtCenter:@"您的网络不给力,请重新试试吧"];
//        return;
//    }
//    
//    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"wowgoingAccount"]];
//    float wowgoingAcount=[string floatValue];
//    float productPrice=[[self.tempDic objectForKey:@"totalAmount"] floatValue];
//    
//    
//    Prodect *product=nil;
//    product=[self.tempDic objectForKey:@"product"];
//    //差品牌名 brandName
//    
//    if (wowgoingAcount>=productPrice) {
//        PayByWgoingVC *payVC=[[[PayByWgoingVC alloc]initWithNibName:@"PayByWgoingVC" bundle:nil] autorelease];
//        
//        payVC.orderId=[self.tempDic objectForKey:@"orderID"];
//        
//        [self.navigationController pushViewController:payVC animated:YES];
//        self.navigationController.navigationBarHidden = YES;
//        
//        payVC.productsPrice.text=[self.tempDic objectForKey:@"totalAmount"];
//        payVC.balanceAcount.text=[NSString stringWithFormat:@"%.2f",(float)wowgoingAcount];
//        
//    }else{
//        
//        FnalStatementVC *fnalVC=[FnalStatementVC shareFnalStatementController];
//        
//        fnalVC.orderId=[self.tempDic objectForKey:@"orderID"];
//        
//        [self.navigationController pushViewController:fnalVC animated:YES];
//        self.navigationController.navigationBarHidden = YES;
//        
//        fnalVC.totalPrices.text=[NSString stringWithFormat:@"%.2f",(float)[[self.tempDic objectForKey:@"totalAmount"] intValue]];
//
//        fnalVC.accountBalance.text=[NSString stringWithFormat:@"%.2f",(float)wowgoingAcount];
//        
//    }
//    
//}
//


@end
