//
//  SecondViewController.m
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CartViewController.h"
#import "FnalStatementVC.h"
#import "PayByWgoingVC.h"
#import "LKCustomTabBar.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

#import "ShopInforVC.h"
#import "ProductDetailViewController_Detail2.h"
#import "AddAddressViewController.h"
#import "DateUtil.h"
#import "LoginViewController.h"
#import "RegisterView.h"
#import "Single.h"
#import "CheckStockBS.h"
#import "WowgoingAccount.h"

#import "Toast+UIView.h"

static CartViewController *shareCart=nil;

@interface CartViewController ()<postProtocol>
{
    BOOL   isMember;

}
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIButton *selectAllButton;
@property (retain, nonatomic) IBOutlet UILabel *totalAmount;
@property (retain, nonatomic) IBOutlet UIButton *yuDingButton;
@property (retain, nonatomic) IBOutlet UIImageView *payOfWayImage;

@property (retain, nonatomic) IBOutlet UIImageView *duiGouImage;

@property (retain,nonatomic) NSMutableDictionary  *stockResultDic;
@property (retain,nonatomic) NSMutableDictionary   *stateForPayOnLineDic;
@property (retain,nonatomic) NSMutableDictionary   *stateForPayToShopDic;

@property (assign,nonatomic) int     sumMoney;

@property  (assign,nonatomic) BOOL  isPost; //邮寄


@end


@implementation CartViewController
@synthesize emptyCartView;
@synthesize isDidLoad;
@synthesize cartTable= _cartTable;
@synthesize productsPayOnline=_productsPayOnline;
@synthesize productsPayToShop=_productsPayToShop;
@synthesize shopID=_shopID;
@synthesize brandID=_brandID;

@synthesize takeTime=_takeTime;

@synthesize orderId=_orderId;

@synthesize _islogout;

@synthesize _isempty;
@synthesize phoneNumberString;

+ (id)shareCartController
{
    static  dispatch_once_t      once;
    static  CartViewController *shareCart;
   
    dispatch_once(&once, ^{
        shareCart = [[self alloc]  init];
    });
    
    return shareCart;
}

- (void) postProtocolMethod{  //填写地址后 执行方法
    
     [self checkProductsStockWithActivityArray:[self getActivityArray] andOrderIDArray:[self getOrderIDArray] andStrsizeArray:[self getStrSzieArray]];
    
}



#pragma mark
#pragma mark    *********选中所有商品*********
- (IBAction)selectAllProductAction:(id)sender {
    UIButton * button = (UIButton*)sender;
    button.selected = !button.selected;

    int productsCount = 0;
    if (button.selected)
    {
        _duiGouImage.hidden = NO;
        
        if (_payByOnline.selected) {
            
            productsCount = self.productsPayOnline.count;
            
            for (int i = 0; i < productsCount; i ++)
            {
                CartListCell  *cell = (CartListCell*)[self.cartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                if (cell.selectButton.enabled) {
                     [self.stateForPayOnLineDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
                }
            }
            
            self.sumMoney = [self calculateTotalAmount:self.productsPayOnline];
            
            self.totalAmount.text=[NSString stringWithFormat:@"￥%d",self.sumMoney];
            
        }else{
        
            productsCount = self.productsPayToShop.count;
            
            for (int i = 0; i < productsCount; i ++)
            {
                CartListCell  *cell = (CartListCell*)[self.cartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                if (cell.selectButton.enabled) {
                    [self.stateForPayToShopDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
                    
                    int  payState = [[[self.productsPayToShop objectAtIndex:i] objectForKey:@"payType"] intValue];
                    if (payState == 2) {
                        _isPost = YES;
                }
                    
            }
        }
            
            self.sumMoney = [self calculateTotalAmount:self.productsPayToShop];
            
             self.totalAmount.text=[NSString stringWithFormat:@"￥%d",self.sumMoney];
        }
    }else{
        
        _duiGouImage.hidden = YES;
        
        if (_payByOnline.selected) {
            
            [self.stateForPayOnLineDic  removeAllObjects];
            _isPost = NO;
            
            self.totalAmount.text = @"￥0";
            self.sumMoney = 0;
            
        }else{
            
            [self.stateForPayToShopDic  removeAllObjects];
            self.totalAmount.text = @"￥0";
            self.sumMoney = 0;
            _isPost = NO;
        }
        
    }
        [self.cartTable reloadData];
}


#pragma mark
#pragma mark  ************免费预订/去结算*********
- (IBAction)yuDingAction:(id)sender {
    
    if (self.payByToshop.selected) {
            // 没有选中商品的情况
            if (self.stateForPayToShopDic.count == 0) {
                [self.view makeToast:@"请选中您所要预定的产品" duration:0.5 position:@"center" title:nil];
                return;
            }
            // 预订的产品中有邮寄产品
            if (_isPost) {
                [self addCustomAddressForPostProduct];
            }else{
            
                [self checkUserPhoneNumber];
            
            }
    }else{
        
            // // 没有选中商品的情况
            if (self.stateForPayOnLineDic.count == 0) {
                [self.view makeToast:@"请选中您所要预定的产品" duration:0.5 position:@"center" title:nil];
                return;
            }
            // 获取选中产品的活动ID、订单ID、尺码,然后去核实产品的库存情况
            NSMutableArray   *activityArray = [self getActivityArray];
            NSMutableArray   *orderArray = [self getOrderIDArray];
            NSMutableArray   *strsizeArray = [self getStrSzieArray];
            
            [self checkProductsStockWithActivityArray:activityArray andOrderIDArray:orderArray andStrsizeArray:strsizeArray];
        }
}


#pragma mark
#pragma mark  ****************添加地址页面***********
- (void) addCustomAddressForPostProduct{

    AddAddressViewController  *addressVC = [[[AddAddressViewController alloc ] initWithNibName:@"AddAddressViewController" bundle:nil] autorelease];
    addressVC.delegate = self;
    [self presentModalViewController:addressVC animated:YES];

}

#pragma mark
#pragma mark     ************核查预订/结算产品的库存情况***********
- (void) checkProductsStockWithActivityArray:(NSMutableArray*)activityArray andOrderIDArray:(NSMutableArray*)orderIDArray andStrsizeArray:(NSMutableArray*)strsizeArray{

    CheckStockBS   *checkStockBS = [[[CheckStockBS alloc ]init ] autorelease];
    checkStockBS.delegate = self;
    if (self.payByOnline.selected) {
        checkStockBS.type = 1;
    }else{
        
        checkStockBS.type = 0;
    }
    checkStockBS.activityArray = activityArray;
    checkStockBS.orderIDArray = orderIDArray;
    [checkStockBS setOnSuccessSeletor:@selector(checkProductsStockWithOrderStringsFinished:)];
    [checkStockBS setOnFaultSeletor:@selector(checkProductsStockWithOrderStringsFault:)];
    [checkStockBS asyncExecute];
    
    [MBProgressHUD showHUDAddedTo:self.cartTable animated:YES];
    
}

- (void) checkProductsStockWithOrderStringsFinished:(ASIFormDataRequest *)requestForm{
    
    [MBProgressHUD hideHUDForView:self.cartTable animated:NO];

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
    
     self.takeTime = [dic objectForKey:@"takeTimeStr"];
      self.stockResultDic = dic;
    
    // 查询用户的电话号码
    if (!_isPost) {

        if (self.payByOnline.selected) {
            [self checkUserPhoneNumber];
        }else{
             [self showPromptBox:self.phoneNumberString];
        }
       
    }else{
        [self requestData:1 requestTag:CART_REQUEST_FRIST];
        [self requestDataQH:1 requestTag:CART_REQUEST_FRIST];
    }
   
}

- (void) checkProductsStockWithOrderStringsFault:(ASIFormDataRequest*)request{

     [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
}

#pragma mark
#pragma mark  获取专柜取货的商品数量

/**********************************
 函数名称:requestDataQH:(int)pageNumber requestTag:(int)tagNumber
 函数描述:请求专柜取货数据
 输入参数:(int)pageNumber 页数
 (int)tagNumber  tag值,用于区分请求
 输出参数:N/A
 返回值：N/A
 **********************************/
- (void)requestDataQH:(int)pageNumber requestTag:(int)tagNumber
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
   
    NSString *urlString = nil;
    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    
    urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,QH_LIST];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId]forKey: @"deviceId"];
    [jsonreq setValue:@"3" forKey:@"orderType"];
    [jsonreq setValue:[NSNumber numberWithInt:pageNumber] forKey:@"pageNumber"];
    
    NSString *sbreq = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) {//IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }else{
        SBJsonWriter *sbJsonWriter = [SBJsonWriter alloc];
        sbreq = [sbJsonWriter stringWithObject:jsonreq];
        [sbJsonWriter release];
    }

    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    requestForm.tag = tagNumber;
    
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    [requestForm setDidFinishSelector:@selector(finishRequestQH:)];
    [requestForm setDidFailSelector:@selector(failureRequestQH:)];
    [requestForm setDelegate:self];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
}

- (void)finishRequestQH:(ASIHTTPRequest *)request{
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        NSError *error = nil;
        if (requestForm.responseData.length > 0) {
            dic = [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return;
        }
        if (error) {
        return;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser = [SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }
    NSMutableArray *productListArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"shoppePickup"]];
    
    [Util SaveShoppeArray:productListArray];
    
    LKCustomTabBar *customTabbar = [LKCustomTabBar shareTabBar];
    UILabel *countLable = (UILabel*)[customTabbar.slideQH viewWithTag:1988];
    countLable.text = [NSString stringWithFormat:@"%d",productListArray.count];
    if ([countLable.text integerValue] != 0) {
        customTabbar.slideQH.hidden = NO;
    }else{
        customTabbar.slideQH.hidden = YES;
    }
}

#pragma mark
#pragma mark  查询用户电话

/******************************
 函数名称:checkUserPhoneNumber
 函数描述:向后台查询用户电话是否已录入
 输入参数:N/A
 输出参数:N/A
 返回值：N/A
 ******************************/
- (void)checkUserPhoneNumber{ //向后台查询用户电话是否已录入
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviveId"];
    
    
    NSString *sbreq = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) {//IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
        NSError *error = nil;
        NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }else{
        SBJsonWriter *sbJsonWriter = [SBJsonWriter alloc];
        sbreq = [sbJsonWriter stringWithObject:jsonreq];
        [sbJsonWriter release];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@/user/userSize",SEVERURL];
    
    ASIFormDataRequest *requestForm =[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(checkUserPhoneNumberFinish:)];
    [requestForm startAsynchronous];
    
}
- (void)checkUserPhoneNumberFinish:(ASIHTTPRequest*)request{
    ASIFormDataRequest *requestForm=(ASIFormDataRequest*)request;
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

    NSString *phone=[dic objectForKey:@"phone"];
    
    if (phone==nil || [phone isEqualToString:@""]) {
        [self showIputBox];
    }else{
        
        self.phoneNumberString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"phone"]];
        
        if (self.payByToshop.isSelected && !_isPost) {
            
            // 获取选中产品的活动ID、订单ID、尺码,然后去核实产品的库存情况
            NSMutableArray   *activityArray = [self getActivityArray];
            NSMutableArray   *orderArray = [self getOrderIDArray];
            NSMutableArray   *strsizeArray = [self getStrSzieArray];
            
            [self checkProductsStockWithActivityArray:activityArray andOrderIDArray:orderArray andStrsizeArray:strsizeArray];
        }else{
            
             [self showPromptBox:self.phoneNumberString];
        
        }
    }
}
#pragma mark
#pragma mark   展示电话录入框

/******************************
 函数名称:showIputBox
 函数描述:电话录入弹框
 输入参数:N/A
 输出参数:N/A
 返回值：N/A
 ******************************/
-(void)showIputBox{
    
    inPutboxImage=[[UIImageView alloc]initWithFrame:CGRectMake(36,50,253,202)];
    inPutboxImage.image=[UIImage imageNamed:@"弹出框.png"];
    inPutboxImage.userInteractionEnabled=YES;
    [self.view addSubview:inPutboxImage];
    [inPutboxImage release];
    
    UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(20, 10, 210, 80)];
    textview.font=[UIFont systemFontOfSize:14.0f];
    textview.backgroundColor=[UIColor clearColor];
    textview.textColor=[UIColor whiteColor];
    textview.editable=NO;
    textview.text=@"您还没有留下联系方式,为方便店柜导购与您确认订单\n请输入您的手机号码：\n";
    [inPutboxImage addSubview:textview];
    [textview release];
    
    UIImageView *inputFieldImage=[[UIImageView alloc]initWithFrame:CGRectMake(25, textview.frame.origin.x+textview.frame.size.height, 195, 30)];
    inputFieldImage.image=[UIImage imageNamed:@"弹出框_电话号码输入框.png"];
    inputFieldImage.userInteractionEnabled=YES;
    [inPutboxImage addSubview:inputFieldImage];
    [inputFieldImage release];
    
    UITextField *inputField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 195, 30)];
    inputField.delegate=self;
    inputField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    inputField.keyboardType=UIKeyboardTypeNumberPad;
    inputField.tag=100;
    inputField.enabled = NO;
    [inputFieldImage addSubview:inputField];
    [inputField release];
    
    UIButton *quXiao=[UIButton buttonWithType:UIButtonTypeCustom];
    quXiao.frame=CGRectMake(25, inputFieldImage.frame.origin.y+inputFieldImage.frame.size.height+20, 75, 30);
    [quXiao setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
    [quXiao setTitle:@"取消" forState:UIControlStateNormal];
    [quXiao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quXiao addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [inPutboxImage addSubview:quXiao];
    
    UIButton *queRen=[UIButton buttonWithType:UIButtonTypeCustom];
    queRen.frame=CGRectMake(145, inputFieldImage.frame.origin.y+inputFieldImage.frame.size.height+20, 75, 30);
    [queRen setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
    [queRen setTitle:@"确认" forState:UIControlStateNormal];
    [queRen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [queRen addTarget:self action:@selector(countersignAction:) forControlEvents:UIControlEventTouchUpInside];
    [inPutboxImage addSubview:queRen];
    
    [self keepScreenOutOperation];

}
#pragma mark
#pragma mark  取消电话录入
-(void)cancleAction:(UIButton*)sender{ //电话录入框上的取消按钮
    UITextField *field=(UITextField*)[inPutboxImage viewWithTag:100];
    [field resignFirstResponder];
    inPutboxImage.hidden=YES;
    if (self.payByToshop.selected) {
        [self requestData:1 requestTag:CART_REQUEST_FRIST];
        [self requestDataQH:1 requestTag:CART_REQUEST_FRIST];
    }
    [self keepScreenOnOperation];
    
}

#pragma mark
#pragma mark  提示信息框

/******************************
 函数名称:showPromptBox:(NSString*)phoneNumber
 函数描述:提示信息弹框
 输入参数:(NSString*)phoneNumber 电话号码
 输出参数:N/A
 返回值：N/A
 ******************************/
- (void)showPromptBox:(NSString*)phoneNumber{
    
    promptBox = [[UIImageView alloc]initWithFrame:CGRectMake(36,94,253,202)];
    promptBox.image = [UIImage imageNamed:@"弹出框.png"];
    promptBox.userInteractionEnabled=YES;
    [self.view addSubview:promptBox];
    [promptBox release];
    
    NSString *textViewString = nil;
    
    if (self.payByToshop.selected) {
        NSString *timeString = [self getMyTime:self.takeTime];
        NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date = [outputFormatter dateFromString:timeString];
        NSString *week = [DateUtil  GetWeekDayFromDate:date];

        textViewString = [NSString stringWithFormat:@"请您于%@(%@)前到店取货",timeString,week];
    }else{
        textViewString = [NSString stringWithFormat:@"请您在支付成功后到店取货,过期货品将不为您保留"];
    }
    UILabel *textview = [[UILabel alloc]initWithFrame:CGRectMake(20,35,210,10)];
    textview.font = [UIFont systemFontOfSize:15.0f];
    textview.backgroundColor = [UIColor clearColor];
    textview.textColor = [UIColor whiteColor];
    
    textview.numberOfLines = 0;
    CGRect rect = textview.frame;
    CGSize size = [textViewString sizeWithFont:textview.font constrainedToSize:CGSizeMake(210, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    rect.size.height = size.height;
    [textview setFrame:CGRectMake(20, 20, 210, rect.size.height)];
    textview.text = textViewString;
    [promptBox addSubview:textview];
    [textview release];

    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, textview.frame.origin.y+textview.frame.size.height+10,80,20)];
    lable.text = [NSString stringWithFormat:@"您的手机号:"];
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:15.0];
    [promptBox addSubview:lable];
    [lable release];
    
    UITextField *phonrField = [[UITextField alloc]initWithFrame:CGRectMake(lable.frame.origin.x+lable.frame.size.width, lable.frame.origin.y, 120, 20)];
    phonrField.borderStyle = UITextBorderStyleLine;
    phonrField.tag = 2008;
    phonrField.text = phoneNumber;
    phonrField.keyboardType = UIKeyboardTypeNumberPad;
    phonrField.delegate = self;
    phonrField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phonrField.backgroundColor = [UIColor whiteColor];
    [promptBox addSubview:phonrField];
    [phonrField release];
    
       
    UIButton *zhiDao = [UIButton buttonWithType:UIButtonTypeCustom];
    zhiDao.frame = CGRectMake(85,phonrField.frame.origin.y+phonrField.frame.size.height+10, 75, 30);
    [zhiDao setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
    [zhiDao setTitle:@"确定" forState:UIControlStateNormal];
    [zhiDao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [zhiDao addTarget:self action:@selector(iKnow:) forControlEvents:UIControlEventTouchUpInside];
    [promptBox addSubview:zhiDao];
    
    if (self.payByOnline.selected) {
        zhiDao.frame = CGRectMake(45,phonrField.frame.origin.y+phonrField.frame.size.height+10, 75, 30);
        
        UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
        quxiao.frame = CGRectMake(zhiDao.frame.origin.x+zhiDao.frame.size.width+20, zhiDao.frame.origin.y, 75, 30);
        
        [quxiao setBackgroundImage:[UIImage imageNamed:@"注销按钮_点击.png"] forState:UIControlStateNormal];
        [quxiao setTitle:@"取消" forState:UIControlStateNormal];
        [quxiao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [quxiao addTarget:self action:@selector(quXiaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [promptBox addSubview:quxiao];
        
    }
    
    [self keepScreenOutOperation];
}

-(void)quXiaoAction:(UIButton*)sender{
    [inPutboxImage removeFromSuperview];
    [promptBox removeFromSuperview];
    
    [self keepScreenOnOperation];
    
}

#pragma mark
#pragma mark   确定电话录入

/******************************
 函数名称:countersignAction:(UIButton*)sender
 函数描述:电话录入弹框框上的确定按钮所关联的方法,在这里主要进行电话号码的校验、校验之后的保存
 输入参数:(UIButton*)sender
 输出参数:N/A
 返回值：N/A
 ******************************/

- (void)countersignAction:(UIButton*)sender{//电话录入框上的确定按钮
    
    UITextField *field=(UITextField*)[inPutboxImage viewWithTag:100];
    if (![Util checkPhoneNumber:field.text]) {
        [self.view makeToast:@"请您输入正确的电话号码" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    [field resignFirstResponder];
    inPutboxImage.hidden=YES;
    if (![self saveUserPhoneNumber:field.text]) {

        [inPutboxImage removeFromSuperview];
    
    }else{
        
        [Util saveUserPhoneNumber:field.text];
        
        if (self.payByToshop.isSelected && !_isPost) {
            
            // 获取选中产品的活动ID、订单ID、尺码,然后去核实产品的库存情况
            NSMutableArray   *activityArray = [self getActivityArray];
            NSMutableArray   *orderArray = [self getOrderIDArray];
            NSMutableArray   *strsizeArray = [self getStrSzieArray];
            
            [self checkProductsStockWithActivityArray:activityArray andOrderIDArray:orderArray andStrsizeArray:strsizeArray];
            
        }else{
            
            [self showPromptBox:field.text];
            
        }
    }
}

#pragma mark
#pragma mark  保存录入电话

/******************************
 函数名称:saveUserPhoneNumber:(NSString*)phoneNumber
 函数描述:向后台存放用户录入的电话号码
 输入参数:(NSString*)phoneNumber 电话号码
 输出参数:N/A
 返回值：BOOL  保存成功返回YES  否则 NO
 ******************************/

- (BOOL)saveUserPhoneNumber:(NSString*)phoneNumber{ //向后台存放用户录入的电话号码
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
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
            return NO;
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


/******************************
 函数名称:iKnow:(UIButton*)sender
 函数描述:提示弹框上的确定按钮
 输入参数:(UIButton*)sender
 输出参数:N/A
 返回值：N/A
 ******************************/
- (void)iKnow:(UIButton*)sender{//录入电话后的提示框上的知道按钮
    
    UITextField *field=(UITextField*)[promptBox viewWithTag:2008];
    
    if (![field.text isEqualToString:self.phoneNumberString]) {
        
        if (![Util checkPhoneNumber:field.text]) {

            [self.view makeToast:@"请您输入正确的电话号码" duration:0.5 position:@"center" title:nil];
            return;
        }else{
            [self saveUserPhoneNumber:field.text];
        }
    }
    
    [inPutboxImage removeFromSuperview];
    [promptBox removeFromSuperview];
     [self keepScreenOnOperation];
    
    if (self.payByOnline.selected) {
        
        [self payOnlineAction];
    }else{
        [self requestData:1 requestTag:CART_REQUEST_FRIST];
        [self requestDataQH:1 requestTag:CART_REQUEST_FRIST];
    }
}


- (void) payOnlineAction{
    
    float  wowgoingAcount=[[self.stockResultDic objectForKey:@"wowgoingAccount"] floatValue];// wowgoing账户余额
   float   price=[[self.stockResultDic objectForKey:@"countPrice"] floatValue];  //所选商品总价
    
    
    NSMutableArray *productArray = [self.stockResultDic objectForKey:@"toSettleDetail"];
    
        
    if (wowgoingAcount>=price) {
        PayByWgoingVC *payVC=[PayByWgoingVC shareFnalStatementController];
        [payVC  set_isCartList:YES];
        [payVC set_shouYe:NO];
        [payVC set_notPay:NO];
        payVC.productsArray=productArray;//商品数组
       
        payVC.productDic = self.stockResultDic;
        
        [self.navigationController pushViewController:payVC animated:YES];
        self.navigationController.navigationBarHidden=YES;
        
    }else{
        
        FnalStatementVC *fnalVC=[FnalStatementVC shareFnalStatementController];
        
        fnalVC.productsArray=productArray;//商品数组
       
        [fnalVC set_isCartList:YES];
        [fnalVC set_shouYe:NO];
        [fnalVC set_notPay:NO];
        fnalVC.productDic = self.stockResultDic;
        
        [self.navigationController pushViewController:fnalVC animated:YES];
        self.navigationController.navigationBarHidden=YES;
    }

}

#pragma mark
#pragma mark  获取店铺详情
-(void)shopAddress:(UIButton*)sender{//单机放大镜后触发的方法
    
    NSString *shopName=[NSString string];
    NSString *activityIdString = nil;
    if (self.payByOnline.selected) {
        self.brandID=[NSString stringWithFormat:@"%@",[[self.productsPayOnline objectAtIndex:sender.tag-100] objectForKey:@"brandId"]];
        self.shopID=[NSString stringWithFormat:@"%@",[[self.productsPayOnline objectAtIndex:sender.tag-100] objectForKey:@"shopId"]];
        shopName=[[self.productsPayOnline objectAtIndex:sender.tag-100] objectForKey:@"address"];
        
        activityIdString = [[self.productsPayOnline objectAtIndex:sender.tag-100] objectForKey:@"activityId"];
        
    }else if (self.payByToshop.selected){
        self.brandID=[NSString stringWithFormat:@"%@",[[self.productsPayToShop objectAtIndex:sender.tag-100] objectForKey:@"brandId"]];
        self.shopID=[NSString stringWithFormat:@"%@",[[self.productsPayToShop objectAtIndex:sender.tag-100] objectForKey:@"shopId"]];
        
        shopName=[[self.productsPayToShop objectAtIndex:sender.tag-100] objectForKey:@"address"];
        activityIdString = [[self.productsPayToShop objectAtIndex:sender.tag-100] objectForKey:@"activityId"];

    }

    ShopInforVC *shopVC=[[[ShopInforVC alloc]initWithNibName:@"ShopInforVC" bundle:nil] autorelease];
    shopVC.brandID=self.brandID;
    shopVC.shopId=self.shopID;
    shopVC.shopName=shopName;
    shopVC.activatyID = activityIdString;
    shopVC.type = 1;
    [self.navigationController pushViewController:shopVC animated:YES];
    
    self.navigationController.navigationBarHidden=YES;
}
#pragma mark
#pragma mark  查看商品详情
-(void)productDetail:(AsyncImageView*)sender{//点击商品图片触发的方法
    
   ProductDetailViewController_Detail2 *detailVC=[[[ProductDetailViewController_Detail2 alloc]initWithNibName:@"ProductDetailViewController_Detail2" bundle:nil] autorelease];
    
    if (self.payByOnline.selected) { //在线支付
          detailVC.activityId = [[self.productsPayOnline objectAtIndex:sender.tag - 200] objectForKey:@"activityId"];
          detailVC.productId =  [[self.productsPayOnline objectAtIndex:sender.tag - 200] objectForKey:@"productId"];
        
    }else if(self.payByToshop.selected){ //到店支付
        detailVC.activityId = [[[self.productsPayToShop objectAtIndex:sender.tag - 200] objectForKey:@"activityId"] intValue];
        detailVC.productId =  [[[self.productsPayToShop objectAtIndex:sender.tag - 200] objectForKey:@"productId"] intValue];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark
#pragma mark  购物车为空
- (IBAction)goToShopping:(id)sender {//当购物车为空时,点击此按钮去首页
    
    UIButton *button=(UIButton*)[self.view viewWithTag:0];
    [[LKCustomTabBar shareTabBar] selectedTab:button];
    [LKCustomTabBar shareTabBar].currentSelectedIndex=0;
    
}

#pragma mark
#pragma mark  计算购物车内商品总额
-(int)calculateTotalAmount:(NSMutableArray*)productsArray{//计算购物车内商品的总金额
    int sum=0;
    for (int i=0; i<productsArray.count; i++) {
        
         int sellState = [[[productsArray   objectAtIndex:i] objectForKey:@"sellState"] intValue];
        
        if (sellState != 2 && sellState != 3) {
            NSDictionary *dic=[productsArray objectAtIndex:i];
            if (isMember) {
                sum+=[[dic objectForKey:@"memberPrice"] intValue];
            }else{
               sum+=[[dic objectForKey:@"discountPrice"] intValue];
            }
        }

    }
    return sum;
}


#pragma mark
#pragma mark  在线支付
- (IBAction)payOnline:(id)sender {//在线支付
    UIButton *button=(UIButton*)sender;
    
    [self.yuDingButton setTitle:@"去结算" forState:UIControlStateNormal];
    
    if (!button.selected) {
        button.selected=YES;
        self.payByToshop.selected=NO;
        self.payOfWayImage.image = [UIImage imageNamed:@"手机支付.png"];
        self.sumMoney = [self calculateTotalAmount:self.productsPayOnline];
        self.totalAmount.text = [NSString stringWithFormat:@"￥%d",self.sumMoney];
        if (self.productsPayOnline.count!=0) {
            self.cartTable.hidden=NO;
            emptyCartView.hidden = YES;
            [self.cartTable reloadData];
            [self createFooterView];
        }else{
            self.cartTable.hidden=YES;
             [self.view bringSubviewToFront:emptyCartView];
            emptyCartView.hidden = NO;
        }
    }
}

#pragma mark
#pragma mark  到店支付
- (IBAction)payOnShop:(id)sender {//到店支付
    UIButton *button=(UIButton*)sender;
    [self.yuDingButton setTitle:@"免费预订" forState:UIControlStateNormal];
    if (!button.selected) {
        button.selected=YES;
        self.payOfWayImage.image = [UIImage imageNamed:@"线下支付.png"];

        self.payByOnline.selected=NO;
        
        self.sumMoney = [self calculateTotalAmount:self.productsPayToShop];
        self.totalAmount.text = [NSString stringWithFormat:@"￥%d",self.sumMoney];
    
        if (self.productsPayToShop.count!=0) {
            self.cartTable.hidden=NO;
            emptyCartView.hidden = YES;
            [self.cartTable reloadData];
            [self createFooterView];
        }else{
            self.cartTable.hidden=YES;
            emptyCartView.hidden = NO;
            [self.view bringSubviewToFront:emptyCartView];
        }
    }
}

#pragma mark
#pragma mark  viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stockResultDic = [NSMutableDictionary dictionary];
    
    UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
    [self.view addSubview:titbackImageview];
    [titbackImageview release];
    
    if ([Util isLogin]) {
        [self drawInterface];
    }
}

-(void)drawInterface{
    
    [emptyCartView setHidden:YES]; //当购物车为空时显示
     nowPageNum=1;
    
    self.cartTable=[[[UITableView alloc]initWithFrame:CGRectMake(0,33,320,IPHONE_HEIGHT - 44 - 49 - 20 - 38 - 33) style:UITableViewStylePlain] autorelease];  //显示购物车中商品的表视图
    self.cartTable.delegate=self;
    self.cartTable.backgroundColor=[UIColor clearColor];
    self.cartTable.dataSource=self;
    self.cartTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cartTable];
    
    self.productsPayOnline=[NSMutableArray array];
    self.productsPayToShop=[NSMutableArray array];
    self.stateForPayOnLineDic = [NSMutableDictionary dictionary];
    self.stateForPayToShopDic = [NSMutableDictionary dictionary];
    
  if ([[Util takeCartListCount] isEqualToString:@"0"]) {
        [emptyCartView setHidden:NO];
        [self.view bringSubviewToFront:emptyCartView];
      _bottomView.hidden = YES;
       
        [self.productsPayOnline removeAllObjects];
        [self.productsPayToShop removeAllObjects];
        [self showProductsCount];
       
        self.totalAmount.text=@"￥0";
        self.payByOnline.selected=NO;
        self.payByToshop.selected=YES;

    }else{
        _bottomView.hidden = NO;
        if (iPhone5) {
            _bottomView.frame = CGRectMake(0, 415, 320, 38);
        }else{
           _bottomView.frame = CGRectMake(0, 330, 320, 38);
        }
        [self requestData:1 requestTag:CART_REQUEST_FRIST];
                   
        _reloading = NO;
       
        shareCart = self;
    }
}

-(void)requestData:(int)pageNumber requestTag:(int)tagNumber
{
  
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_LIST];
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
    [requestForm setDidFinishSelector:@selector(request_CART_Finished:)];
    [requestForm setDidFailSelector:@selector(request_CART_Failed:)];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    
    [MBProgressHUD showHUDAddedTo:self.cartTable animated:YES];

}


#pragma mark - EGORefreshTableHeader
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView =[[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
	[self.cartTable  addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - EGORefreshTableFooter
-(void)createFooterView{
    
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    if (self.cartTable.contentSize.height>=self.view.bounds.size.height){
       _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.cartTable.contentSize.height, self.cartTable.frame.size.width, self.cartTable.bounds.size.height)];
        _refreshFooterView.backgroundColor  = [UIColor clearColor];
        _refreshFooterView.delegate = self;
        [self.cartTable addSubview:_refreshFooterView];
        [_refreshFooterView refreshLastUpdatedDate];
        CGRect  _newFrame =  CGRectMake(0.0f, self.cartTable.contentSize.height,self.view.frame.size.width, self.cartTable.bounds.size.height);
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.cartTable];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.cartTable];

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

#pragma mark - ASIHTTPRequestDelegate
- (void)request_CART_Failed:(ASIHTTPRequest *)request
{
    
    
    [MBProgressHUD hideHUDForView:self.cartTable animated:NO];
    
    if ([Util takeCartProducts].count==0) {
        emptyCartView.hidden=NO;
        [self.view bringSubviewToFront:emptyCartView];
        self.cartTable.hidden=YES;
        
        self.totalAmount.text=@"￥0";
        self.payByOnline.selected=NO;
        self.payByToshop.selected=YES;
        
    }else{
    
    emptyCartView.hidden=YES;
    [self.view sendSubviewToBack:emptyCartView];
   
    [self.productsPayOnline removeAllObjects];
    [self.productsPayToShop removeAllObjects];
        
    for (int i=0; i<[Util takeCartProducts].count; i++) {
        NSDictionary *dic=[[Util takeCartProducts] objectAtIndex:i];
        int payType=[[dic objectForKey:@"payType"] intValue];  //  0. 到店  1. 在线 3.邮寄
          
        if (payType==0  || payType == 2) {
            [self.productsPayToShop addObject:dic];
        }else{
            [self.productsPayOnline addObject:dic];
        }
    }

    if (self.productsPayOnline.count==0) {
        self.payByOnline.selected=NO;
        self.payByToshop.selected=YES;
        self.payOfWayImage.image = [UIImage imageNamed:@"线下支付.png"];
        self.totalAmount.text=[NSString stringWithFormat:@"￥%d",[self calculateTotalAmount:self.productsPayToShop]];
    }else if (self.productsPayToShop.count==0){
        self.payByOnline.selected=YES;
        self.payByToshop.selected=NO;
       self.payOfWayImage.image = [UIImage imageNamed:@"手机支付.png"];
        self.totalAmount.text=[NSString stringWithFormat:@"￥%d",[self calculateTotalAmount:self.productsPayOnline]];
    }else{
        self.payByOnline.selected=YES;
        self.payByToshop.selected=NO;
        self.payOfWayImage.image = [UIImage imageNamed:@"线下支付.png"];
        self.totalAmount.text=[NSString stringWithFormat:@"￥%d",[self calculateTotalAmount:self.productsPayOnline]];
    }
    
    [_refreshFooterView setHidden:YES];
    [_refreshHeaderView setHidden:YES];
    [self showProductsCount];
    self.cartTable.hidden=NO;
    [self.cartTable reloadData];
    }
}

- (void)request_CART_Finished:(ASIHTTPRequest *)request
{
    self.cartTable.hidden=NO;
   
    if (self.cartTable==nil) {
       self.cartTable=[[[UITableView alloc]initWithFrame:CGRectMake(0,33,320,IPHONE_HEIGHT - 44 - 49 - 20 - 38 - 33) style:UITableViewStylePlain] autorelease];
        self.cartTable.delegate=self;
        self.cartTable.backgroundColor=[UIColor clearColor];
        self.cartTable.dataSource=self;
        [self.view addSubview:self.cartTable];
        
        self.productsPayOnline=[NSMutableArray array];
        self.productsPayToShop=[NSMutableArray array];
    }
    
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            [MBProgressHUD hideHUDForView:self.cartTable animated:NO];
            return;
        }
        if (error) {
            [MBProgressHUD hideHUDForView:self.cartTable animated:NO];
        return;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    if (dic == NULL) {
        emptyCartView.hidden=NO;
       [self.view bringSubviewToFront:emptyCartView];
       self.totalAmount.text=@"0";
        self.sumMoney = 0;
       self.payByOnline.selected=NO;
       self.payByToshop.selected=YES;
        [MBProgressHUD hideHUDForView:self.cartTable animated:NO];
       return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {
         [MBProgressHUD hideHUDForView:self.cartTable animated:NO];

        [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }

    [MBProgressHUD hideHUDForView:self.cartTable animated:NO];
    
     NSMutableArray *products= [dic objectForKey:@"cartList"];
    isMember = [[dic objectForKey:@"IsMember"] boolValue];
    
    if (request.tag==CART_REQUEST_FRIST || request.tag==CART_REQUEST_PAGE_UPDATE){
        [self.productsPayToShop removeAllObjects];
        [self.productsPayOnline removeAllObjects];
        
        [Util saveCartProducts:products];
    }else if (request.tag==CART_REQUEST_PAGE_NEXT){
        if (products.count!=0) {
            NSMutableArray *productArray=[NSMutableArray arrayWithArray:[Util takeCartProducts]];
            for (int i=0; i<products.count; i++) {
                [productArray addObject:[products objectAtIndex:i]];
            }
            [Util saveCartProducts:productArray];
        }
    }
    
  [_refreshFooterView setHidden:NO];
    self.orderId=[dic objectForKey:@"orderId"];
    self.orderItemStatus=[dic objectForKey:@"orderItemStatus"];
    
    if (products.count!=0) {
       
        [Util saveCartListCount:[NSString stringWithFormat:@"%d",products.count]];
        _bottomView.hidden = NO;
        
        [self.view bringSubviewToFront:_bottomView];
    }
    for (int i=0; i<products.count; i++) {
        NSDictionary *dic=[products objectAtIndex:i];
        int payType=[[dic objectForKey:@"payType"] intValue];   //到店 0  在线 1 邮寄 2
        
        if (payType==0 || payType == 2) {
            
            [self.productsPayToShop addObject:dic];

        }else{
            [self.productsPayOnline addObject:dic];

        }
    }
    
    if (request.tag==CART_REQUEST_FRIST) {
        
        if (self.productsPayOnline.count==0) {
            self.payByOnline.selected=NO;
            self.payByToshop.selected=YES;
            [self.yuDingButton setTitle:@"免费预订" forState:UIControlStateNormal];
           self.payOfWayImage.image = [UIImage imageNamed:@"线下支付.png"];
        
            self.sumMoney = [self calculateTotalAmount:self.productsPayToShop];
    
        }else if (self.productsPayToShop.count==0){
            self.payByOnline.selected=YES;
            self.payByToshop.selected=NO;
            [self.yuDingButton setTitle:@"去结算" forState:UIControlStateNormal];
           self.payOfWayImage.image = [UIImage imageNamed:@"手机支付.png"];
             self.sumMoney = [self calculateTotalAmount:self.productsPayOnline];
        }else{
           
            if (self.payByOnline.selected) {
                [self.yuDingButton setTitle:@"去结算" forState:UIControlStateNormal];
                self.payOfWayImage.image = [UIImage imageNamed:@"手机支付.png"];
                self.sumMoney = [self calculateTotalAmount:self.productsPayOnline];
            }else if (self.payByToshop.selected){
            
                [self.yuDingButton setTitle:@"免费预订" forState:UIControlStateNormal];
                self.payOfWayImage.image = [UIImage imageNamed:@"线下支付.png"];
                
                self.sumMoney = [self calculateTotalAmount:self.productsPayToShop];

            }else{
            
                [self.yuDingButton setTitle:@"去结算" forState:UIControlStateNormal];
                self.payOfWayImage.image = [UIImage imageNamed:@"手机支付.png"];
                self.sumMoney = [self calculateTotalAmount:self.productsPayOnline];
            }
        }
            int count = 0;
            if (self.payByOnline.selected) {
                count = self.productsPayOnline.count;
                for (int i = 0; i < count; i++) {
                    int sellState = [[[self.productsPayOnline   objectAtIndex:i] objectForKey:@"sellState"] intValue];
                    if (sellState != 2 && sellState != 3) {
                        [self.stateForPayOnLineDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
                    }
                }
            }else{
                count = self.productsPayToShop.count;
                for (int i = 0; i < count; i++) {
                    int sellState = [[[self.productsPayToShop   objectAtIndex:i] objectForKey:@"sellState"] intValue];
                    if (sellState != 2 && sellState != 3) {
                        [self.stateForPayToShopDic   setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
                        
                        int  payState = [[[self.productsPayToShop objectAtIndex:i] objectForKey:@"payType"] intValue];
                        if (payState == 2) {
                            _isPost = YES;
                        }
                    }
                }
            }
    
        self.totalAmount.text=[NSString stringWithFormat:@"￥%d",self.sumMoney];

    }
    
    [self showProductsCount];
    [self.cartTable reloadData];

    //验正是不是最后一页
    NSString *morePage = [dic objectForKey:@"morePage"];
    if ([@"flase" isEqualToString:morePage] || [products count] == 0) {
       
        if (request.tag == CART_REQUEST_FRIST) {
            if ([products count] == 0) {
                
                [emptyCartView setHidden:NO];
                [self.view bringSubviewToFront:emptyCartView];
                
                
                self.cartTable.hidden=YES;
               
                [self showProductsCount];
            
                self.totalAmount.text=@"￥0";
                self.payByOnline.selected=NO;
                self.payByToshop.selected=YES;
                self.payOfWayImage.image = [UIImage imageNamed:@"线下支付.png"];
                [Util saveCartListCount:@""];
                [Util saveCartProducts:[NSMutableArray array]];

              return;
            }else {
        
                [emptyCartView setHidden:YES];
                [self.view sendSubviewToBack:emptyCartView];
               
                [self showProductsCount];
                
                self.cartTable.hidden=NO;
            }
        }
        [self loadOk];
        
        return;
    }
    
    switch (request.tag) {
        case CART_REQUEST_FRIST:
        {
            
            if ([products count] == 0) {
                
                [emptyCartView setHidden:NO];
                [self.view bringSubviewToFront:emptyCartView];
                               
                self.cartTable.hidden=YES;
                
                [self.payByOnline setUserInteractionEnabled:NO];
                [self.payByToshop setUserInteractionEnabled:NO];
    
                [self showProductsCount];
               self.totalAmount.text=@"￥0";
                self.sumMoney = 0;
                self.payByOnline.selected=NO;
                self.payByToshop.selected=YES;
                self.payOfWayImage.image = [UIImage imageNamed:@"线下支付.png"];
                _bottomView.hidden = YES;
                [Util saveCartListCount:@""];
                [Util saveCartProducts:[NSMutableArray array]];
                
                return;
            }else {
                [self.payByOnline setUserInteractionEnabled:YES];
                [self.payByToshop setUserInteractionEnabled:YES];
                [emptyCartView setHidden:YES];
                [self.view sendSubviewToBack:emptyCartView];
        
                self.cartTable.hidden=NO;
            }
                       
            //更新分页箭头位置
            CGRect  _newFrame = CGRectMake(0.0f, self.cartTable.contentSize.height,self.view.frame.size.width,self.cartTable.bounds.size.height);
            
            [self createHeaderView];
            [self createFooterView];
            _refreshFooterView.frame = _newFrame;
            
            [self loadOk];
        }
            break;
        case CART_REQUEST_PAGE_UPDATE:
        {
            CGRect  _newFrame =  CGRectMake(0.0f, self.cartTable.contentSize.height,self.view.frame.size.width,  self.cartTable.bounds.size.height);
            [self createHeaderView];
            [self createFooterView];
            _refreshFooterView.frame = _newFrame;
            
            [self loadOk];
            
            
        }
            break;
        case CART_REQUEST_PAGE_NEXT:
        {
            CGRect  _newFrame =  CGRectMake(0.0f, self.cartTable.contentSize.height,self.view.frame.size.width,  self.cartTable.bounds.size.height);
            [self createHeaderView];
            [self createFooterView];
            _refreshFooterView.frame = _newFrame;
            
            [self loadOk];
            
            nowPageNum++;
            
        }
            break;
        default:
            break;
    }
    
 }



#pragma mark
#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.payByOnline.selected) {
        return self.productsPayOnline.count;
    }else{
        return self.productsPayToShop.count;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identify=@"Cell";
    CartListCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        NSArray *cellArray = [[NSBundle mainBundle]  loadNibNamed:@"CartListCell" owner:self options:nil];
        for (id oneObject in cellArray) {
            if ([oneObject isKindOfClass:[CartListCell class]]) {
                cell = (CartListCell *)oneObject;
            }
        }
        cell.productImage = [[[AsyncImageView alloc ] initWithFrame:CGRectMake(28, 8, 92, 92)] autorelease];
        cell.productImage.backgroundColor = [UIColor clearColor];
        [cell addSubview:cell.productImage];
        
        
        cell.soldOutImage = [[[UIImageView alloc ]initWithFrame:CGRectMake(-5, 0, 35, 27)] autorelease];
        [cell.productImage addSubview:cell.soldOutImage];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell prepareForReuse];
    }
    NSDictionary *productDic = nil;
    NSString   *flagString = nil;
    if (self.payByOnline.selected) {
        productDic=[self.productsPayOnline objectAtIndex:indexPath.row];
        flagString = [self.stateForPayOnLineDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    else {
        productDic=[self.productsPayToShop objectAtIndex:indexPath.row];
        flagString = [self.stateForPayToShopDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    
    //商品图片显示
    NSString *picString=[productDic objectForKey:@"picUrl"];
    if (picString==nil || [picString isEqualToString:@""]) {
        [cell.productImage setImage:[UIImage imageNamed:@"名品折扣logo水印"]];
    }else{
        cell.productImage.urlString=[productDic objectForKey:@"picUrl"];
    }
    cell.productImage.tag=indexPath.row+200;
    [cell.productImage addTarget:self action:@selector(productDetail:) forControlEvents:UIControlEventTouchUpInside];//点击商品图片后进入商品的详情页

    //是否选择商品按钮
    [cell.selectButton addTarget:self action:@selector(selectButtonPressAtion:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectButton.tag = indexPath.row +300;
    if ([flagString isEqualToString:@"1"]) {   //选中后设置背景图片
        cell.selectButton.selected = YES;
    }else{   //取消选中后更换背景图片
        cell.selectButton.selected = NO;
    }
    
   //商品的名称
    NSString *content=[productDic objectForKey:@"productName"];  

    cell.productNameLable.text=content;

    //商品的颜色、尺寸、折扣的综合信息

    NSString *sizeString=[productDic objectForKey:@"strsize"];//尺寸
    NSString *colorString=[productDic objectForKey:@"color"];//颜色
    NSString *discountString=[productDic objectForKey:@"discount"];//折扣
    cell.colorAndSizeLable.text=[NSString stringWithFormat:@"%@/%@/%@折",colorString,sizeString,discountString];         

     //商品价格
    NSString *memberPrice = [productDic objectForKey:@"memberPrice"];
    if (!isMember) {
          cell.priceLable.text=[NSString  stringWithFormat:@"￥%@",[productDic objectForKey:@"discountPrice"]];
    }else{
        cell.priceLable.text=[NSString  stringWithFormat:@"￥%@",memberPrice];
    }
    
    //取货店铺的地址
    
    NSString *contentAddress= nil;
    int  payType = [productDic objectForKey:@"payType"];
    if (payType == 2) {
       contentAddress=[NSString stringWithFormat:@"邮寄店铺:%@",[productDic objectForKey:@"address"]]; 
    }else{
      
        contentAddress=[NSString stringWithFormat:@"取货店铺:%@",[productDic objectForKey:@"address"]]; 
    }

    cell.addressLabe.numberOfLines = 0;
//    CGRect rectAddress=cell.addressLabe.frame;
    CGSize sizeAddress=[contentAddress sizeWithFont:cell.addressLabe.font constrainedToSize:CGSizeMake(150,100) lineBreakMode:UILineBreakModeWordWrap];
    cell.addressLabe.frame=CGRectMake(cell.colorAndSizeLable.frame.origin.x, cell.priceLable.frame.origin.y+cell.priceLable.frame.size.height,sizeAddress.width, sizeAddress.height);
    cell.addressLabe.text=contentAddress;
    cell.addressLabe.textColor = [UIColor colorWithRed:138.0/255.0 green:91.0/255.0 blue:10.0/255.0 alpha:1.0];
    
    //放大镜图片
    cell.magnifierImage.frame=CGRectMake(cell.addressLabe.frame.origin.x+sizeAddress.width, cell.addressLabe.frame.origin.y,20,20);
    
    //查看取货店铺按钮
    cell.addressButton.frame=CGRectMake(cell.addressLabe.frame.origin.x, cell.addressLabe.frame.origin.y, cell.addressLabe.frame.size.width+30, cell.addressLabe.frame.size.height+30);
    cell.addressButton.tag=indexPath.row+100;
    [cell.addressButton addTarget:self action:@selector(shopAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    //商品是否售罄、下线
    int sellState = [[productDic objectForKey:@"sellState"] intValue];
    if (sellState == 2) {  //售罄
        cell.soldOutImage.hidden = NO;
        cell.soldOutImage.image = [UIImage imageNamed:@"售罄标签.png"];
        cell.selectButton.enabled = NO;
        [cell bringSubviewToFront:cell.soldOutImage];
    }else  if(sellState == 3){   //过期
        cell.selectButton.enabled = NO;
        cell.soldOutImage.image = [UIImage imageNamed:@"已下架 切图.png"];
    }else{  
        cell.soldOutImage.hidden= YES;
        cell.selectButton.enabled = YES;

    }
    
    [cell.deleteButton addTarget:self action:@selector(deleteExecuteByCancleBut:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = indexPath.row;
    

    CGRect cellframe=cell.frame;
    cellframe.size.height=cell.productNameLable.frame.size.height+cell.colorAndSizeLable.frame.size.height+cell.addressLabe.frame.size.height;
    if (cellframe.size.height>=cell.productImage.frame.size.height) {
        [cell setFrame:CGRectMake(cellframe.origin.x, cellframe.origin.y, cellframe.size.width, cellframe.size.height)];
    }else{
        [cell setFrame:CGRectMake(cellframe.origin.x, cellframe.origin.y, cellframe.size.width, cell.productImage.frame.size.height+10)];
    }

    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"购引提示" message:@"您确定要删除此预订订单么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = indexPath.row + 2000;
        [alert show];
        [alert release];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void) selectButtonPressAtion:(UIButton*) sender{
    CartListCell  *cell = (CartListCell*)[self.cartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 300 inSection:0]];
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (self.payByOnline.selected) {
        
            if (cell.selectButton.enabled) {
                [self.stateForPayOnLineDic  setValue:@"1" forKey:[NSString stringWithFormat:@"%d",sender.tag - 300]];
                
                NSDictionary *dic=[self.productsPayOnline  objectAtIndex:sender.tag - 300];
                if (isMember) {
                    self.sumMoney+=[[dic objectForKey:@"memberPrice"] intValue];
                }else{
                    self.sumMoney+=[[dic objectForKey:@"discountPrice"] intValue];
                }

                if (self.stateForPayOnLineDic.count == self.productsPayOnline.count) {
                    _duiGouImage.hidden = NO;
                    self.selectAllButton.selected = YES;
                }
            }
            
        }else{
            if (cell.selectButton.enabled) {
                [self.stateForPayToShopDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",sender.tag - 300]];
                int  payState = [[[self.productsPayToShop objectAtIndex:sender.tag - 300] objectForKey:@"payType"] intValue];
                if (payState == 2) {
                    _isPost = YES;
                }
            
                NSDictionary *dic=[self.productsPayToShop  objectAtIndex:sender.tag - 300];
                if (isMember) {
                    self.sumMoney+=[[dic objectForKey:@"memberPrice"] intValue];
                }else{
                    self.sumMoney+=[[dic objectForKey:@"discountPrice"] intValue];
                }
                
                if (self.stateForPayToShopDic.count == self.productsPayToShop.count) {
                    _duiGouImage.hidden = NO;
                    self.selectAllButton.selected = YES;
                }
            }
        }
            
    }else{
        
        _duiGouImage.hidden = YES;
        self.selectAllButton.selected = NO;
        
        if (self.payByOnline.selected) {
            
            [self.stateForPayOnLineDic  removeObjectForKey:[NSString stringWithFormat:@"%d",sender.tag - 300]];

            NSDictionary *dic=[self.productsPayOnline  objectAtIndex:sender.tag - 300];
            if (isMember) {
                self.sumMoney-= [[dic objectForKey:@"memberPrice"] intValue];
            }else{
                self.sumMoney-=[[dic objectForKey:@"discountPrice"] intValue];
            }


        }else{
            [self.stateForPayToShopDic removeObjectForKey:[NSString stringWithFormat:@"%d",sender.tag - 300]];
                int  payState = [[[self.productsPayToShop objectAtIndex:sender.tag - 300] objectForKey:@"payType"] intValue];
            if (payState == 2) {
                _isPost = NO;
            }
            
            NSDictionary *dic=[self.productsPayToShop  objectAtIndex:sender.tag - 300];
            if (isMember) {
                self.sumMoney-= [[dic objectForKey:@"memberPrice"] intValue];
            }else{
                self.sumMoney-=[[dic objectForKey:@"discountPrice"] intValue];
            }
        }
    }

      self.totalAmount.text = [NSString stringWithFormat:@"￥%d",self.sumMoney];
    
}

#pragma mark
#pragma mark  Method of deleteExecute

- (void) deleteExecuteByCancleBut:(UIButton*)sender{
    
    UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"购引提示" message:@"您确定要取消此预订订单么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = sender.tag + 2000;
    [alert show];
    [alert release];
}

-(void)deleteExecute:(int)indexNumber  //取消订单
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
   
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    
    NSString *orderID=nil;
    int payType=0;

    if (self.payByOnline.selected) {
        orderID=[[self.productsPayOnline objectAtIndex:indexNumber] objectForKey:@"orderId"];
        payType=1;

    }
    if(self.payByToshop.selected){
        orderID=[[self.productsPayToShop objectAtIndex:indexNumber] objectForKey:@"orderId"];
        payType=[[self.productsPayToShop objectAtIndex:indexNumber] objectForKey:@"payType"];

    }
    
    [jsonreq setValue:orderID forKey:@"orderId"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",payType] forKey:@"payState"];
    
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    
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

    NSString *urlString = [NSString stringWithFormat:@"%@/cart/cancel",SEVERURL];
    
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(deleteExecuteFinished:)];
    requestForm.tag=indexNumber;
    [requestForm startAsynchronous];
    
    [MBProgressHUD showHUDAddedTo:self.cartTable animated:YES];
    

}
-(void)deleteExecuteFinished:(ASIHTTPRequest*)request{

    ASIFormDataRequest *requestForm=(ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            
            [MBProgressHUD hideHUDForView:self.cartTable animated:NO];
            return;
        }
        if (error) {
            
            [MBProgressHUD hideHUDForView:self.cartTable    animated:NO];

        return;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    
    BOOL   isSuccess = [dic objectForKey:@"isSuccess"];
    if (!isSuccess) {
        
        [MBProgressHUD hideHUDForView:self.cartTable animated:NO];

         [self.view makeToast:[dic objectForKey:@"message"] duration:0.5 position:@"center" title:nil];
        
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    [MBProgressHUD hideHUDForView:self.cartTable animated:NO];
    
    if (responseStatus==200) {
    
        if (self.payByOnline.selected) {
            [self.productsPayOnline removeObjectAtIndex:requestForm.tag];
        }
        if (self.payByToshop.selected){
            [self.productsPayToShop removeObjectAtIndex:requestForm.tag];
        }
        [self.cartTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:requestForm.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self requestData:1 requestTag:CART_REQUEST_FRIST];
    }else{
        
        [self.view makeToast:@"删除失败" duration:0.5 position:@"center" title:nil];
    
    }
}
#pragma mark
#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5 animations:^{
        if (textField.tag==100) {
            inPutboxImage.frame=CGRectMake(36, 0, 253, 202);
        }else{
        
            promptBox.frame=CGRectMake(36,34, 253, 202);
        }
    }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;

}


#pragma mark
#pragma mark  showProductsCount
-(void)showProductsCount{ //显示购物车上的红色数量圈
   
    LKCustomTabBar *customTabbar=[LKCustomTabBar shareTabBar];
    UILabel *countLable=(UILabel*)[customTabbar.slideBg viewWithTag:1986];
    countLable.text=[NSString stringWithFormat:@"%d",self.productsPayOnline.count+self.productsPayToShop.count];
    if ([countLable.text integerValue]!=0) {
        customTabbar.slideBg.hidden=NO;
    }else{
        customTabbar.slideBg.hidden=YES;
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqualToString:@"您还未登录,请先登录"]) {
        switch (buttonIndex) {
            case 0:
              
                break;
            case 1:
            {
                LoginViewController *loginVC=[[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil] autorelease];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
                break;
            case 2:
            {
                RegisterView *registerVC=[[[RegisterView alloc]initWithNibName:@"RegisterView" bundle:nil] autorelease];
                [self.navigationController pushViewController:registerVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        if (buttonIndex == 1) {
            [self deleteExecute:alertView.tag - 2000];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
       if (![Util isLogin]) {
        
        [self.productsPayOnline removeAllObjects];
        [self.productsPayToShop removeAllObjects];
        [self.cartTable reloadData];
           
        [self.cartTable setHidden:YES];
        [self createFooterView];
        [_refreshFooterView setHidden:YES];
        [self.cartTable setHidden:YES];
        [emptyCartView setHidden:NO];
        _bottomView.hidden = YES;
        _bottomView.frame = CGRectMake(0, IPHONE_HEIGHT - 49 -38, 320, 38);
        [self showProductsCount];
        self.totalAmount.text=@"";
        
       [[CartViewController shareCartController]  set_islogout:NO];
        UIAlertView *custom=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录,请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",@"注册",nil];
        [custom show];
        [custom release];
       }else{
           
           if (iPhone5) {
               _bottomView.frame = CGRectMake(0, 415, 320, 38);
           }else{
               _bottomView.frame = CGRectMake(0, 330, 320, 38);
           }
           
            [self requestData:1 requestTag:CART_REQUEST_FRIST];
       }
    
      self.navigationController.navigationBarHidden=NO;
}

#pragma mark
#pragma mark  获取订单失效时间与当前时间的时间差
-(int)takeTimeDifference:(NSString*)timeAddCart :(NSString*)currenTime{
    
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[[NSDateComponents alloc] init] autorelease];//初始化目标时间
    
    NSArray *array=[timeAddCart componentsSeparatedByString:@" "];
    NSArray *arrayNYR=[[array objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *arrayHMS=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
    [endTime setYear:[[arrayNYR objectAtIndex:0] intValue]];
    [endTime setMonth:[[arrayNYR objectAtIndex:1] intValue]];
    [endTime setDay:[[arrayNYR objectAtIndex:2] intValue]];
    
    [endTime setHour:[[arrayHMS objectAtIndex:0] intValue]];
    [endTime setMinute:[[arrayHMS objectAtIndex:1] intValue]];
    [endTime setSecond:[[arrayHMS objectAtIndex:2] intValue]];
    
    NSDate *endDate=[cal dateFromComponents:endTime];
    

    NSDate *today = [DateUtil stringToDate:currenTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *differcnce=[cal components:unitFlags fromDate:today toDate:endDate options:0];

    int totle=[differcnce day]*3600*24+[differcnce hour]*3600+[differcnce minute]*60+[differcnce second];
    
    return totle;
}


- (NSString*)getMyTime:(NSString*)inputTimeStr
{
     NSDate *inputDate = [DateUtil stringToDate:inputTimeStr withFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *outTimeStr = [outputFormatter stringFromDate:inputDate];
    return outTimeStr;
}

#pragma mark 键盘
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    if (doneInKeyboardButton.superview)
    {
        [doneInKeyboardButton removeFromSuperview];
    }
    
    [self comeBack];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if(screenHeight==568.0f){//爱疯5
            doneInKeyboardButton.frame = CGRectMake(0, 568 - 53, 106, 53);
        }else{//3.5寸
            doneInKeyboardButton.frame = CGRectMake(0, 480 - 53, 106, 53);
        }
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        
        [doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_up@2x.png"] forState:UIControlStateNormal];
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    if (doneInKeyboardButton.superview == nil)
    {
        [tempWindow addSubview:doneInKeyboardButton];    // 注意这里直接加到window上
    }
    
}

-(void)comeBack{
    UIImageView *imageView1=(UIImageView*)[self.view viewWithTag:100];
    UIImageView *imageView2=(UIImageView*)[self.view viewWithTag:2008];
    [UIView animateWithDuration:0.5 animations:^{
        if (imageView1!=nil) {
            inPutboxImage.frame=CGRectMake(36, 50, 253, 202);
        }
        if (imageView2!=nil) {
            promptBox.frame=CGRectMake(36, 94, 253, 202);
        }
    }];
}

-(void)finishAction{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

#pragma mark 
#pragma mark   ************获取选中产品的活动ID***********
- (NSMutableArray*)getActivityArray{
    NSMutableArray *activityArray = [NSMutableArray array];
     NSArray *keyArray = nil;
    
    if (self.payByOnline.selected) {
        keyArray = [self.stateForPayOnLineDic allKeys];
    }else{
        keyArray = [self.stateForPayToShopDic allKeys];
    }
    int count = keyArray.count;
    for (int i = 0; i < count ; i++ ) {
        int index = [[keyArray objectAtIndex:i] intValue];
        NSString *activityString = nil;
        
        if (self.payByOnline.selected) {
            activityString = [[self.productsPayOnline objectAtIndex:index] objectForKey:@"activityId"];
        }else{
            
            activityString = [[self.productsPayToShop objectAtIndex:index] objectForKey:@"activityId"];
            
        }
        
        [activityArray addObject:[NSNumber numberWithInteger:[activityString integerValue]]];
    }

    return  activityArray;
}

- (NSMutableArray*)getOrderIDArray{
    NSMutableArray *orderIDArray = [NSMutableArray array];
    NSArray *keyArray = nil;
    
    if (self.payByOnline.selected) {
        keyArray = [self.stateForPayOnLineDic allKeys];
    }else{
        keyArray = [self.stateForPayToShopDic allKeys];
    }
    int count = keyArray.count;
    for (int i = 0; i < count ; i++ ) {
        int index = [[keyArray objectAtIndex:i] intValue];
        NSString *activityString = nil;
        
        if (self.payByOnline.selected) {
            activityString = [[self.productsPayOnline objectAtIndex:index] objectForKey:@"orderId"];
        }else{
            
            activityString = [[self.productsPayToShop objectAtIndex:index] objectForKey:@"orderId"];
            
        }
        
        [orderIDArray addObject:[NSNumber numberWithInteger:[activityString integerValue]]];
    }
    
    return  orderIDArray;
}

- (NSMutableArray*)getStrSzieArray{
    NSMutableArray *strsizeArray = [NSMutableArray array];
    NSArray *keyArray = nil;
    
    if (self.payByOnline.selected) {
        keyArray = [self.stateForPayOnLineDic allKeys];
    }else{
        keyArray = [self.stateForPayToShopDic allKeys];
    }
    int count = keyArray.count;
    for (int i = 0; i < count ; i++ ) {
        int index = [[keyArray objectAtIndex:i] intValue];
        NSString *activityString = nil;
        
        if (self.payByOnline.selected) {
            activityString = [[self.productsPayOnline objectAtIndex:index] objectForKey:@"strsize"];
        }else{
            
            activityString = [[self.productsPayToShop objectAtIndex:index] objectForKey:@"strsize"];
            
        }
        
        [strsizeArray addObject:activityString];
    }
    
    return  strsizeArray;
}

- (void) keepScreenOutOperation{
    [self.cartTable  setUserInteractionEnabled:NO];
    self.yuDingButton.enabled = NO;
    self.selectAllButton.enabled = NO;
    if (self.payByOnline.selected) {
        self.payByToshop.enabled = NO;
    }else if (self.payByToshop.selected){
        self.payByOnline.enabled = NO;    
    }
}

- (void) keepScreenOnOperation{
    self.yuDingButton.enabled = YES;
    self.selectAllButton.enabled = YES;
    [self.cartTable  setUserInteractionEnabled:YES];
    if (self.payByOnline.selected) {
        self.payByToshop.enabled = YES;
    }else if (self.payByToshop.selected){
        self.payByOnline.enabled = YES;
    }

}


#pragma mark -view mothed
- (void)viewDidUnload
{
    [self setTotalAmount:nil];
    [self setPayByOnline:nil];
    [self setPayByToshop:nil];

    [self setBottomView:nil];
    [self setSelectAllButton:nil];
    [self setTotalAmount:nil];
    [self setYuDingButton:nil];
    [self setPayOfWayImage:nil];
    [self setDuiGouImage:nil];
    [super viewDidUnload];

}

-(void)viewWillDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    
    [_stockResultDic release];
    [_stateForPayOnLineDic release];
    [_stateForPayToShopDic release];
    [_cartTable release];
    [_productsPayOnline release];
    [_productsPayToShop release];
      [_totalAmount release];
    [_payByOnline release];
    [_payByToshop release];
    [_shopID release];
    [_brandID release];
 
    [_takeTime release];
    [_orderId release];
    [_orderItemStatus release];
   
    [phoneNumberString release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    
    for (ASIFormDataRequest *request in [ASIFormDataRequest sharedQueue].operations) {
        [request clearDelegatesAndCancel];
    }
    
    [_bottomView release];
    [_selectAllButton release];
    [_totalAmount release];
    [_yuDingButton release];
    [_payOfWayImage release];
    [_duiGouImage release];
    [super dealloc];
}
@end
