 //
//  ShopInforVC.m
//  MYWowGoing
//
//  Created by 马奕兆 on 13-1-8.
//
//

#import "ShopInforVC.h"
 
#import "JSON.h"
#import "ShowShopAddress.h"
 
#import "SBJsonWriter.h"
#import "SBJsonParser.h"

#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "ShopListCell.h"

 

@interface ShopInforVC ()

@property(nonatomic,retain)NSMutableDictionary   *shopInforDic;
@property (retain, nonatomic) IBOutlet UILabel *phoneNumLabel;//电话号码
@property (retain, nonatomic) IBOutlet UIImageView *brandLogoImageView;//品牌logo
@property (retain, nonatomic) IBOutlet UILabel *shopAddress;//商铺地址
@property (retain, nonatomic) IBOutlet UILabel *telePhoneLabel;//电话
@property (retain, nonatomic) IBOutlet UIImageView *shopLogo;//商店的logo
@property (nonatomic,copy)NSString  *lat;//纬度
@property (nonatomic,copy)NSString  *lon;//经度
@property(nonatomic,retain)NSString  *currShopID;  //从商铺列表请求的
@end

@implementation ShopInforVC

@synthesize shopInforDic  =_shopInforDic;


@synthesize currShopID = _currShopID;
@synthesize shopName=_shopName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shopInforDic = [[NSMutableDictionary alloc] initWithCapacity:0];
               
    }
    return self;
}


//返回按钮
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)findProductsOfBand:(UITapGestureRecognizer*)semder{
    
//    BrowResultViewController *brow = [[[BrowResultViewController alloc] initWithNibName:@"BrowResultViewController" bundle:nil] autorelease];
//    brow.otherID = self.brandID;
//    brow.otherName=self.brandName;
//    [self.navigationController pushViewController:brow animated:YES];

}

- (void) viewDidAppear:(BOOL)animated{
  
     self.navigationController.navigationBarHidden = YES ;

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self requestData:self.brandID];
    
}

-(void)loadView
{
    [super loadView];

    [self.shopLogo setImageWithURL:[NSURL URLWithString:[_shopInforDic objectForKey:@"shopPicture"]] placeholderImage:[UIImage imageNamed:@""]];
    
    [self.brandLogoImageView setImageWithURL:[NSURL URLWithString:[_shopInforDic objectForKey:@"brandLogo"]] placeholderImage:[UIImage imageNamed:@""]];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(findProductsOfBand:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    self.brandLogoImageView.userInteractionEnabled=YES;
    [self.brandLogoImageView addGestureRecognizer:tap];
    [tap release];

    self.phoneNumLabel.text  = [_shopInforDic objectForKey:@"phone1"];
    self.shopAddress.text  = [_shopInforDic objectForKey:@"address"];
    self.brandName=[_shopInforDic objectForKey:@"brandName"];

}

#pragma mark
#pragma mark----ASIHttpRequest   
-(void)requestData:(NSString*)brandid
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }else
    {
        [common setValue:@"123@abc.com" forKey:@"loginId"];
        [common setValue:@"888888" forKey:@"password"];
    }
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:self.shopId  forKey:@"shopId"];
    
    NSString *urlString=nil;
    
    if (self.type == 1) {
        [jsonreq setValue:self.activatyID  forKey:@"activityId"];
         urlString = [NSString stringWithFormat:@"%@/cart/findShopInfor",SEVERURL];
    }else{
        [jsonreq setValue:self.brandID  forKey:@"brandId"];
         urlString = [NSString stringWithFormat:@"%@/brand/findShopInfor",SEVERURL];
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
    
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    [requestForm setDidFinishSelector:@selector(requestFinished:)];
    [requestForm setDidFailSelector:@selector(requestFail:)];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

-(void)requestFinished:(ASIHTTPRequest *)request{
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

    
    if (dic == NULL  ) {
   
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        [self.view makeToast:@"您的网络不给力,请重新试试吧"];
        return;
    }
        NSDictionary *shopDic = [dic objectForKey:@"shopDto"];
        [_shopInforDic removeAllObjects];
        [_shopInforDic addEntriesFromDictionary:shopDic];
        [self loadView];
       self.lat = [shopDic objectForKey:@"longitude"];
       self.lon = [shopDic objectForKey:@"latitude"];
}
-(void)requestFail:(ASIHTTPRequest *)request{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
//地图按钮
- (IBAction)mapAction:(id)sender {
    
    ShowShopAddress *showShop=[[[ShowShopAddress alloc]initWithNibName:@"ShowShopAddress" bundle:nil] autorelease];
    showShop.shopCoordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lon doubleValue]);
    showShop.shopName=self.shopName;
    [self.navigationController pushViewController:showShop animated:YES];
   
}
//电话按钮
- (IBAction)phoneAction:(id)sender {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否拨打电话" message:nil delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该设备不支持电话功能" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString *telNum = [NSString stringWithFormat:@"%@",self.phoneNumLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telNum]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_activatyID release];
    [_phoneNumLabel release];
    [_brandLogoImageView release];
    [_shopAddress release];
    [_telePhoneLabel release];
    [_shopLogo release];
    
    [_shopInforDic release];
    [_shopName release];
    [_brandName release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPhoneNumLabel:nil];
    [self setBrandLogoImageView:nil];
    [self setShopAddress:nil];
    [self setTelePhoneLabel:nil];
    [self setShopLogo:nil];
    [super viewDidUnload];
}
@end
