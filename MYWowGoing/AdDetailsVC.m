//
//  AdDetailsVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-18.
//
//

#import "AdDetailsVC.h"
#import "ADVDETAILBS.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import <ShareSDK/ShareSDK.h>
#import "AdproductListVC.h"

#import "Single.h"

@interface AdDetailsVC ()
@property (retain, nonatomic) IBOutlet UIScrollView *adView;
@property (retain,nonatomic) NSMutableDictionary *tempDic;

@end

@implementation AdDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *backBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBut setFrame:CGRectMake(10, 6, 52, 32)];;
        [backBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBut  setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem1 = [[UIBarButtonItem alloc] initWithCustomView:backBut];
        self.navigationItem.leftBarButtonItem = litem1;
        
        UIButton *shaiXuan = [UIButton buttonWithType:UIButtonTypeCustom];
        [shaiXuan setFrame:CGRectMake(10, 6, 52, 32)];;
        [shaiXuan addTarget:self action:@selector(shareActionAddetailImage:) forControlEvents:UIControlEventTouchUpInside];
        [shaiXuan setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem2 = [[UIBarButtonItem alloc] initWithCustomView:shaiXuan];
        self.navigationItem.rightBarButtonItem = litem2;
        [litem1 release];
        [litem2 release];
        
        self.title = @"活动详情";
        
    }
    return self;
}

- (void)backAction:(UIButton*)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark
#pragma mrak  ******分享广告详情大图******

- (void) shareActionAddetailImage:(UIButton*)sender{
    
    NSString *wowgoingStringUrl = [NSString stringWithFormat:@"%@/iphone",WX_SEVERURL];
    
    NSString *shareString=[self.tempDic objectForKey:@"advertisementText"];
    NSLog(@"分享内容：%@",shareString);
    NSString *shareImageUrl = [self.tempDic objectForKey:@"detailPic"];
    
    id<ISSContent>publishContent=[ShareSDK content:shareString
                                    defaultContent:shareString
                                             image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]] fileName:nil mimeType:nil]
                                             title:nil
                                               url:nil
                                       description:nil
                                         mediaType:SSPublishContentMediaTypeNews];
    
    //需要定制分享视图的显示属性，使用以下接口
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleModal  viewDelegate:nil authManagerViewDelegate:nil];
    
    
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"内容分享" oneKeyShareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,nil]
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
                                             url:wowgoingStringUrl
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeApp]
                                          content:shareString
                                            title:@"购引"
                                              url:wowgoingStringUrl
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.tempDic = [NSMutableDictionary dictionary];
    [self requestAdvertisementDetail:[Single shareSingle].advertisementId]; //根据广告ID请求广告详情大图
    
}

#pragma mark
#pragma mark   ***********ADVDETAILBS***********
-(void)requestAdvertisementDetail:(NSString*)advertisementId{//请求广告详情（广告大图）
    ADVDETAILBS *adDetail=[[[ADVDETAILBS alloc]init] autorelease];
    adDetail.delegate=self;
    adDetail.advertisementId = advertisementId;//广告ID
    adDetail.onSuccessSeletor=@selector(requestAdvertisementDetailFinish:);
    adDetail.onFaultSeletor=@selector(requestAdvertisementDetailFail:);
    [adDetail asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}
-(void)requestAdvertisementDetailFail:(ASIHTTPRequest*)request{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.view makeToast:@"您的网络不给力,请重新试试吧"];
}

-(void)requestAdvertisementDetailFinish:(ASIFormDataRequest*)request{
    [request clearDelegatesAndCancel];
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (request.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
        return;
    }
    
    NSString *dicUrl=[dic objectForKey:@"detailPic"];
    self.tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [self hiddenProductView:dicUrl];
    
}

//加载广告页面。隐藏产品页面的一些元素
- (void)hiddenProductView:(NSString*)imageUrl{
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.adView.bounds] autorelease];
    
    imageView.tag=19860923;
    
    if (iPhone5) {
        imageView.frame = CGRectMake(0, 0, 320, imageView.frame.size.height);
    } else {
        imageView.frame = CGRectMake(0, 44, 320, imageView.frame.size.height);
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //选择此模式的话，图片会填充满画框并不会变形失真，但是图片的某些区域会显示在画框以外，所以需要对画框大小做出相应调整
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];//加载图片
    
    [imageView setUserInteractionEnabled:YES];
    
    [self performSelector:@selector(drawContenSize:) withObject:imageView afterDelay:3.0];//延迟3秒调用此方法 根据图片原始大小设置画框大小
    
        
    //判断不能广告是否能点击 0可看
    if ([Single shareSingle].advertisementPriority == 0) {
        //广告下面的按钮 查看详情
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [adButton setFrame:CGRectMake(0, IPHONE_HEIGHT - 44 - 49 - 20 - 35, 320, 35)];
        
        [adButton addTarget:self action:@selector(adDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [adButton setBackgroundImage:[UIImage imageNamed:@"点击查看详情"] forState:UIControlStateNormal];
        [self.view addSubview:adButton];
    }
}


#pragma mark
#pragma mark  ******对下载的广告详情图进行处理********

#define  AD_IMAGE_SCALE  2.25
#define  AD_IMAGE_SCALE_X2  4.5
#define  AD_IMAGE_HEIGHT  1035 //广告大图宽高各按照2.25缩小后得到的高度
//此处 三个关于广告详情大图 宏  不要随意改动
-(void)drawContenSize:(UIImageView*)imageView{
    
    [self.adView setContentSize:CGSizeMake(self.adView.frame.size.width,imageView.image.size.height/AD_IMAGE_SCALE)];//根据广告详情大图的原始尺寸（广告大图尺寸：宽度670，高度不定）设置广告试图的contentSize
    
    CGFloat height=(imageView.image.size.height-AD_IMAGE_HEIGHT)/AD_IMAGE_SCALE_X2;//此高度为 广告大图 需要纠偏的高度（由于广告大图填充后 有些区域会不能显示在画框中）
    
    if (imageView.image.size.height>AD_IMAGE_HEIGHT) {//广告大图原始尺寸若大于 等比缩小后的高度，则进行纠偏
        if (iPhone5) {//针对爱疯5
            imageView.frame=CGRectMake(self.adView.frame.origin.x, self.adView.frame.origin.y+height+3, self.adView.frame.size.width, self.adView.frame.size.height);
        }else{
            imageView.frame=CGRectMake(self.adView.frame.origin.x, self.adView.frame.origin.y+height+48, self.adView.frame.size.width, self.adView.frame.size.height);
        }
    }
    [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
    imageView.backgroundColor = [UIColor clearColor];
    [self.adView addSubview:imageView];
    
}


#pragma mark
#pragma mark  ******根据广告ID获取产品列表*******
-(void)adDetailAction:(UIButton*)sender{
    
    AdproductListVC* adpvc=[[[AdproductListVC alloc]initWithNibName:@"AdproductListVC" bundle:nil] autorelease];
    adpvc.advertisementId=[[Single shareSingle] advertisementId];
    [self.navigationController pushViewController:adpvc animated:YES];
    self.navigationController.navigationBarHidden=NO;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [_tempDic release];
    [_adView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAdView:nil];
    [super viewDidUnload];
}
@end
