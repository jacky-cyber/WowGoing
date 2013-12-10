//
//  ShopInfoDetailViewController.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-25.
//
//

#import "ShopInfoDetailViewController.h"
#import "JSON.h"
#import "ShowShopAddress.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "ProductBrandDetailBS.h"
#define SHOPBUTTON  196852
@interface ShopInfoDetailViewController ()
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *shopImageView;  //店铺图片
@property (retain, nonatomic) IBOutlet UILabel *addressLable; //地址标签
@property (retain, nonatomic) IBOutlet UIImageView *brandLogoImage;
@property (retain, nonatomic) IBOutlet UIView *myView;
@property (retain, nonatomic) IBOutlet UIButton *guanZhuBut; //关注按钮
@property (retain,nonatomic) NSString *phoneNumberString;
@property (retain,nonatomic) NSString  *brandName;
@property (retain,nonatomic) NSString *shopName;
@property (retain,nonatomic) NSString  *lon; //经度
@property (retain,nonatomic) NSString  *lat; //纬度
@property (retain,nonatomic) NSDictionary  *shopDic; //存放请求回来的数据
//@property  (retain,nonatomic) UIView  *descriptionView;//品牌描述视图
@property (retain,nonatomic) NSMutableArray *shopListArray; //存放店铺信息

@end
@implementation ShopInfoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 6, 52, 32)];
		[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
		UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		self.navigationItem.leftBarButtonItem = litem;
		[litem release];
        self.title = @"品牌介绍";
    }
    return self;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark  *******查看品牌介绍描述********
- (IBAction)brandDetailDespristion:(id)sender {
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            _myView.frame = CGRectMake(0, _descriptionView.frame.origin.y +_descriptionView.frame.size.height + 10, _myView.frame.size.width, _myView.frame.size.height);
            
        } completion:^(BOOL finished) {
            _brandBtn.selected = YES;
            _brandBtn.enabled = YES;
        }];
    }else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            _myView.frame = CGRectMake(0, _descriptionView.frame.origin.y, _myView.frame.size.width, _myView.frame.size.height);
            
        } completion:^(BOOL finished) {
            _brandBtn.enabled = YES;
            _brandBtn.selected = NO;
            
        }];
    }
    
    self.mainScrollView.contentSize = CGSizeMake( self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height + _descriptionView.frame.size.height + self.shopListArray.count*31);
}


#pragma mark
#pragma mark   *********关注品牌/取消品牌********
- (IBAction)guanZhuAction:(id)sender {
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self updateMyfavoritesBrand:self.brandId :1];  //关注品牌
    }else{
        [self updateMyfavoritesBrand:self.brandId :0];  //取消品牌关注

    }
}

#pragma mark
#pragma mrak    ********点击定位**********
- (IBAction)dingWeiAction:(id)sender {
    
    ShowShopAddress *showShop=[[[ShowShopAddress alloc]initWithNibName:@"ShowShopAddress" bundle:nil] autorelease];
    showShop.shopCoordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lon doubleValue]);
    showShop.shopName = self.shopName;
    [self.navigationController pushViewController:showShop animated:YES];
//    self.navigationController.navigationBarHidden=YES;
}

#pragma mrak
#pragma mark   ********拨打电话**********
- (IBAction)callAction:(id)sender {
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
        NSString *telNum = [NSString stringWithFormat:@"%@",self.phoneNumberString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telNum]]];
    }
}

#pragma mark
#pragma mark   ***********请求店铺详情数据************
-(void)requestData:(NSString*)brandid
{
    ProductBrandDetailBS *pbs = [[[ProductBrandDetailBS alloc] init] autorelease];
    pbs.delegate = self;
    pbs.brandId = brandid;
    pbs.onSuccessSeletor = @selector(requestFinished:);
    pbs.onFaultSeletor = @selector(requestFail:);
    [pbs asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];    
}
-(void)requestFinished:(ASIHTTPRequest *)request{
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

    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    BOOL isFavoriteBool = [[dic objectForKey:@"isFavorite"] boolValue];
    if (isFavoriteBool) {
        _guanZhuBut.selected = YES;
    } else {
        _guanZhuBut.selected = NO;
    }

    self.shopDic = dic;

    _descriptionTextView.text = [[dic  objectForKey:@"brandDetail"] objectForKey:@"description"];

    [self.brandLogoImage setImageWithURL:[NSURL URLWithString:[[dic  objectForKey:@"brandDetail"] objectForKey:@"brandLogo"]] placeholderImage:nil];
    //店铺列表信息
    self.shopListArray = [dic  objectForKey:@"shopList"];
    //显示店铺
    if (self.shopListArray.count == 0) {
        return;
    }
    
    [self  showAllShopOnTheBrand:self.shopListArray];

    NSDictionary *dicShopList = [self.shopListArray objectAtIndex:0];
    
    if (dicShopList == nil || ![dicShopList isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self.shopImageView setImageWithURL:[NSURL URLWithString:[dicShopList objectForKey:@"shopPicture"]] placeholderImage:nil];
    self.addressLable.text = [dicShopList objectForKey:@"address"];
    self.phoneNumberString = [dicShopList objectForKey:@"phone1"];
    self.lon = [dicShopList objectForKey:@"latitude"];
    self.lat= [dicShopList objectForKey:@"longitude"];
    self.shopName = [dicShopList objectForKey:@"shopName"];
}

-(void)requestFail:(ASIHTTPRequest *)request{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

#pragma mark 
#pragma mark   *******关注品牌/取消关注**********
-(void)updateMyfavoritesBrand:(NSString*)brandID :(int)type{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }
    
    NSString *urlString=nil;
    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    
    if (type==1) {//添加
        urlString = [NSString stringWithFormat:@"%@/favorites/add",SEVERURL];
        [jsonreq setValue:brandID forKey:@"brandIdListStr"];
    }else{  //取消
        urlString =[NSString stringWithFormat:@"%@/favorites/cancel",SEVERURL];
        [jsonreq setValue:[NSNumber numberWithInt:[brandID intValue]] forKey:@"brandId"];
    }
    
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey: @"deviceId"];
    
    
    NSString *sbreq=nil;
    //IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm setDidFinishSelector:@selector(updateMyfavoritesBrandFinish:)];
    [requestForm setDidFailSelector:@selector(updateMyfavoritesBrandFail:)];
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
}
-(void)updateMyfavoritesBrandFinish:(ASIHTTPRequest *)request{
    
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
    }else{
        return;
    }
    if (error) {
        return;
    }
    
    BOOL isSuccess = [[dic objectForKey:@"isSuccess"] boolValue];
    if (isSuccess) {
        [self.view makeToast:@"操作成功"];
        
    } else {
        [self.view makeToast:@"操作失败"];
    }
   
}
-(void)updateMyfavoritesBrandFail:(ASIHTTPRequest *)request{
    
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
    }else{
        return;
    }
    if (error) {
        return;
    }
    
}

#pragma mark
#pragma mark   *********创建用于显示品牌介绍的插入视图********
- (void) creatDescriptionView:(NSString *)descriptionString{
    
    if (_descriptionView != nil) {
        
        UILabel *lable = (UILabel*)[_descriptionView viewWithTag:50];
        UIImageView *backimage = (UIImageView*) [_descriptionView viewWithTag:51];
        
        CGSize size = [descriptionString sizeWithFont:lable.font constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        lable.frame = CGRectMake(15, 10, 290, size.height);
        
       lable.text = descriptionString;

        _descriptionView.frame = CGRectMake(0, 55, 320, size.height + 20);
        backimage.frame = CGRectMake(backimage.frame.origin.x, backimage.frame.origin.y,backimage.frame.size.width, lable.frame.size.height);

    }else{
    
        UILabel *descriptionLable = [[UILabel alloc] init];
        descriptionLable.numberOfLines = 0;
        descriptionLable.tag = 50;
        descriptionLable.font = [UIFont systemFontOfSize:14.0f];
        CGSize size = [descriptionString sizeWithFont:descriptionLable.font constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        descriptionLable.frame = CGRectMake(15, 10, 290, size.height);
        descriptionLable.textColor = [UIColor darkGrayColor];
        descriptionLable.text = descriptionString;
        
        _descriptionView = [[UIView  alloc ]initWithFrame:CGRectMake(0, 55, 320, size.height + 20)];
        _descriptionView.backgroundColor = [UIColor clearColor];
        
        [_mainScrollView addSubview:_descriptionView];
        
        
        UIImageView *backImage = [[UIImageView alloc ]initWithFrame:_descriptionView.frame];
        backImage.tag = 51;
        [_descriptionView addSubview:backImage];
        [backImage release];
        
        [_descriptionView addSubview:descriptionLable];
        [descriptionLable release];
        
//        _descriptionView.hidden = YES;

       }
    }

#pragma mark
#pragma mark   ******对该品牌下的所以店铺进行布局*********
- (void) showAllShopOnTheBrand:(NSMutableArray*)shopArray{
    
    int rowCount = shopArray.count/2 + shopArray.count%2;
    int  loopCount = 0;

    UIButton  * button;
    for (int i =0; i < rowCount; i++) {
        for (int j = 0; j < 2; j++) {
            if(loopCount>shopArray.count - 1){
                break;
            }
            
            button = (UIButton*)[_myView viewWithTag:loopCount + SHOPBUTTON];
            [button removeFromSuperview];
            NSLog(@"shopArray===%d",shopArray.count);
            UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
            shopButton.frame = CGRectMake(5 + 145 * j +10, 286 + 31*i + 10*(i - 1), 145, 31);
            [shopButton  setTitle:[[shopArray objectAtIndex:loopCount]  objectForKey:@"shopName"] forState:UIControlStateNormal];
            if (loopCount == 0) {
                shopButton.selected = YES;
            }
            [shopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [shopButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [shopButton setBackgroundImage:[UIImage imageNamed:@"店铺介绍-未选中按钮.png"] forState:UIControlStateNormal];
            [shopButton setBackgroundImage:[UIImage imageNamed:@"店铺介绍-选中.png"] forState:UIControlStateSelected];
            [shopButton addTarget:self action:@selector(changeAddressLabeString:) forControlEvents:UIControlEventTouchUpInside];
            shopButton.tag = loopCount + SHOPBUTTON;
            [_myView addSubview:shopButton];
            loopCount++;
        }
    }
    
     self.mainScrollView.contentSize = CGSizeMake( self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height + _descriptionView.frame.size.height + 31*rowCount+1);

}


#pragma mark
#pragma mark   **********点击店铺按钮后修改相应的地址标签信息********
- (void) changeAddressLabeString:(UIButton *)sender{
    
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        btn.selected  = NO;
    } else {
        btn.selected = YES;
    }
    
    for(int i=0; i<self.shopListArray.count; i++){
        
        UIButton  *button = (UIButton*)[self.view viewWithTag:i+SHOPBUTTON];
        if (button.tag != btn.tag) {
            button.selected = NO;
        }
    }
    
    NSDictionary *dic = [self.shopListArray objectAtIndex:sender.tag - SHOPBUTTON];

    [self .shopImageView setImageWithURL:[NSURL URLWithString:[ dic objectForKey:@"shopPicture"]] placeholderImage:nil];
    self.addressLable.text = [dic objectForKey:@"address"];
    self.phoneNumberString = [dic objectForKey:@"phone1"];
    self.lon = [dic objectForKey:@"latitude"];
    self.lat= [dic objectForKey:@"longitude"];
    self.shopName = [dic objectForKey:@"shopName"];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shopDic = [NSDictionary dictionary];
    self.shopListArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    
    [self requestData:self.brandId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    for (_requestForm in [ASIFormDataRequest sharedQueue].operations) {
        [_requestForm clearDelegatesAndCancel];
    }
    [_shopName release];
    [_addressLable release];
    [_mainScrollView release];
    [_myView release];
    [_guanZhuBut release];
    [_shopId release];
    [_brandId release];
    [_phoneNumberString release];
    [_brandName release];
    [_shopDic release];
    [_shopListArray release];
    [_brandLogoImage release];
    [_shopImageView release];
    [_descriptionTextView release];
    [_descriptionView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAddressLable:nil];
    [self setMainScrollView:nil];
    [self setMyView:nil];
    [self setGuanZhuBut:nil];
    [self setBrandLogoImage:nil];
    [self setShopImageView:nil];
    [self setDescriptionTextView:nil];
    [self setDescriptionView:nil];
    [super viewDidUnload];
}
@end
