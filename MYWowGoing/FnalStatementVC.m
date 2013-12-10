//
//  FnalStatementVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-3-16.
//
//

#import "FnalStatementVC.h"

#import "WowgoingAccount.h"
#import "SurePayBS.h"
#import "WebviewVC.h"

#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import <sys/utsname.h>

#import "Toast+UIView.h"
#import "CartViewController.h"


static FnalStatementVC *shareFnalStatementVC;
@interface FnalStatementVC ()
{

    NSMutableArray *activityArray;
    NSMutableArray  *orderIDArray;
}

@end

@implementation FnalStatementVC

+(FnalStatementVC*)shareFnalStatementController
{
    if (shareFnalStatementVC == nil) {
        shareFnalStatementVC = [[FnalStatementVC alloc] init];
    }
    return shareFnalStatementVC;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}



- (IBAction)commitOrder:(id)sender {
    if (self._notPay) {
        self.orderIdString = [[self.productDic objectForKey:@"orderId"] componentsJoinedByString:@","];
        [self pay];
    }else{
         [self surePayRequest];
    }
   
}

- (IBAction)submitOrder:(id)sender {
    if (self._notPay) {
         self.orderIdString = [[self.productDic objectForKey:@"orderId"] componentsJoinedByString:@","];
        [self pay];
    }else{
        [self surePayRequest];
    }
}

- (IBAction)payByWeb:(id)sender {//支付宝网页版支付
    UIButton*button=(UIButton*)sender;
    if (!button.selected) {
        button.selected=YES;
        self.select.hidden=NO;
        self.payByClient.selected=NO;
        self.selectByClient.hidden=YES;
    }
}
- (IBAction)payByClient:(id)sender {//支付宝客户端支付
    
    UIButton*button=(UIButton*)sender;
    if (!button.selected) {
        button.selected=YES;
        self.selectByClient.hidden=NO;
        self.payByWeb.selected=NO;
        self.select.hidden=YES;
    }
}


- (void) drawInterFace{

    [self.scrollViewProducts removeAllSubviews];
    
    self.scrollViewProducts.contentSize=CGSizeMake(self.scrollViewProducts.frame.size.width,self.productsArray.count*25);
    
    self.productsCount.text = [self.productDic objectForKey:@"countActivity"];
    
    int arrayCount = self.productsArray.count;
    
    
    NSMutableArray *orderidArray = [NSMutableArray array];
    
    
    for (int i=0; i<arrayCount; i++) {
        
        NSDictionary *productDic = [self.productsArray objectAtIndex:i];
        
        UILabel *productName=[[UILabel alloc]initWithFrame:CGRectMake(3, i*20+5,200, 20)];
        productName.backgroundColor=[UIColor clearColor];
        productName.font=[UIFont systemFontOfSize:14.0];
        productName.text = [productDic objectForKey:@"productName"];
        
        UILabel *productCount=[[UILabel alloc]initWithFrame:CGRectMake(productName.frame.origin.x+productName.frame.size.width+10, productName.frame.origin.y, 10, 20)];
        productCount.backgroundColor=[UIColor clearColor];
        productCount.font=[UIFont systemFontOfSize:14.0];
        productCount.text = [productDic objectForKey:@"count"];
        
        UILabel *productPrice=[[UILabel alloc]initWithFrame:CGRectMake(productCount.frame.origin.x+productCount.frame.size.width, productName.frame.origin.y,60, 20)];
        productPrice.backgroundColor=[UIColor clearColor];
        productPrice.font=[UIFont systemFontOfSize:14.0];
        productPrice.text = [NSString stringWithFormat:@"￥%.2f",   [[productDic objectForKey:@"discountPrice"]  floatValue]];
    
        [self.scrollViewProducts addSubview:productName];
        [self.scrollViewProducts addSubview:productCount];
        [self.scrollViewProducts addSubview:productPrice];
        
        [productName release];
        [productCount release];
        [productPrice release];
        
        
        NSString *orderID = [productDic objectForKey:@"orderId"];
        [orderidArray addObject:orderID];
    }
    
    
    self.orderIdString = [orderidArray componentsJoinedByString:@","];
    
    self.totalPrices.text = [NSString stringWithFormat:@"￥%.2f",[[self.productDic objectForKey:@"countPrice"]  floatValue]];
    
    self.accountBalance.text = [NSString stringWithFormat:@"￥%.2f",[[self.productDic objectForKey:@"wowgoingAccount"] floatValue]];
    self.balanceString = [self.productDic objectForKey:@"wowgoingAccount"];
    
    float  totalMoney = [[self.productDic objectForKey:@"countPrice"] floatValue];
    float  accountMoney = [[self.productDic objectForKey:@"wowgoingAccount"]  floatValue];
    
    float  blanceMoney = totalMoney - accountMoney;
    self.payment.text = [NSString stringWithFormat:@"￥%.2f",blanceMoney];
    self.paymentString = [NSString stringWithFormat:@"%.2f",blanceMoney];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self drawInterFace];
    if (self._shouYe) {
        
        [activityArray  addObject:[self.productDic objectForKey:@"activityId"]];
        [orderIDArray addObject:[[self.productDic objectForKey:@"toBuyNow"]   objectForKey:@"orderId"]];
        
    }else  if (self._isCartList){
        
        activityArray = [self.productDic objectForKey:@"activityId"];
        orderIDArray = [self.productDic objectForKey:@"orderId"];
    }
   
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize=CGSizeMake(320,520);
    self.scrollView.alwaysBounceVertical=NO;
    
    activityArray = [[NSMutableArray alloc ] init];
    
    orderIDArray = [[NSMutableArray alloc ]init];

}


#pragma mark
#pragma mark   使用支付宝客户端进行支付
-(void)payByzhifubaoClent{ //支付宝客户端支付
    
    NSString *partner = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"Partner"];//签约账号
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];  //商户账号
	
	//partner和seller获取失败,提示
	if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    
    AlixPayOrder *order=[[[AlixPayOrder alloc]init] autorelease];
    order.partner=partner;//签约ID
    order.seller=seller;
    if (self.productsArray.count>0) {
        NSMutableArray *productNameArray=[NSMutableArray array];
        NSMutableArray *productDescriptionArray=[NSMutableArray array];
        for (int i=0; i<self.productsArray.count;i++) {
            NSDictionary *prodic = [self.productsArray objectAtIndex:i];
            
            NSString *productName = [prodic objectForKey:@"productName"];
            NSString *orderNumaber = [prodic objectForKey:@"orderNumber"];
            
            NSString *count = [prodic objectForKey:@"count"];
            NSString *discountPrice = [prodic objectForKey:@"discountPrice"];
            
            NSString *str=[NSString stringWithFormat:@"%@/%@/%@/%@",productName,discountPrice,orderNumaber,count];
            [productDescriptionArray addObject:str];
            [productNameArray addObject:productName];
        }
        order.tradeNO=[self generateTradeNO];
        order.productName=[productNameArray componentsJoinedByString:@"/"];
        order.productDescription=[productDescriptionArray componentsJoinedByString:@"/"];
       
        order.amount=self.paymentString; //支付宝支付金额

    }
    order.notifyURL=@"http://www.wowgoing.com";//回调URL
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"MYWowGoing";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
           
            UIImageView *promptBox=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-127, self.view.center.y-78, 255, 156)];
            promptBox.image=[UIImage imageNamed:@"温馨提示框.png"];
            promptBox.tag=19860923;
            promptBox.userInteractionEnabled=YES;
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(80, 107, 92, 34);
            [button setImage:[UIImage imageNamed:@"温馨提示框2.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(removeProptBox:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=promptBox.tag+1;
            
            [promptBox addSubview:button];
            [self.view addSubview:promptBox];
            [promptBox release];
            
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
	}
}

-(void)removeProptBox:(UIButton*)sender{
    UIImageView *imageview=(UIImageView*)[self.view viewWithTag:sender.tag-1];
    
    [imageview removeFromSuperview];
}


#pragma mark
#pragma mark  随机生成15位订单号
- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}


-(void)pay{
    if (self.payByClient.selected) { //支付宝客户端支付
        [self payByzhifubaoClent];
    }else  if(self.payByWeb.selected){
        
        WebviewVC *web=[[[WebviewVC alloc]initWithNibName:@"WebviewVC" bundle:nil] autorelease];
        
       web.urlString=[NSString stringWithFormat:@"http://www.wowgoing.com/wowgoing/web/trade/?id=%@&customerId=%@",self.orderIdString,[Util getCustomerID]];
        
//        web.urlString=[NSString stringWithFormat:@"http://192.168.1.161:8080/wowgoing2/web/trade/?id=%@&customerId=%@",self.orderIdString,[Util getCustomerID]];
    
        [self.navigationController pushViewController:web animated:YES];
    }else{
    
        [self.view makeToast:@"请选择支付方式" duration:0.5 position:@"center" title:nil];
    
    }
}

-(NSMutableDictionary*)takeProductsCount:(NSMutableArray*)productsArray{
    NSMutableDictionary *productsDic=[NSMutableDictionary dictionary];
    for (int i=0; i<=productsArray.count-1; i++) {
        int count=0;
        Prodect  *product=[productsArray objectAtIndex:i];
        NSString *productNmae=product.productName;
        if (![[productsDic allKeys] containsObject:productNmae]) {
            for (int j=i; j<productsArray.count; j++) {
                Prodect  *product=[productsArray objectAtIndex:j];
                NSString *productNmae2=product.productName;
                if ([productNmae isEqualToString:productNmae2]) {
                    count++;
                }
            }
            [productsDic setValue:[NSString stringWithFormat:@"%d",count] forKey:productNmae];
        }
    }
    return productsDic;
}


- (void) surePayRequest{
    
    SurePayBS *sureBS = [[[SurePayBS alloc ]init ] autorelease];
    sureBS.delegate = self;
    sureBS.activityArray = activityArray;
    sureBS.orderIDArray = orderIDArray;

    [sureBS setOnSuccessSeletor:@selector(surePayRequestSuccess:)];
    [sureBS setOnFaultSeletor:@selector(surePayRequestFault:)];
    [sureBS asyncExecute];
}

- (void) surePayRequestSuccess:(ASIFormDataRequest*)request{
   
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
    
    BOOL  resultStates = [[dic objectForKey:@"resultStatus"] boolValue];
    
    if (!resultStates) {
       
        [self.view makeToast:@"库存不足" duration:0.5 position:@"center" title:nil];
        
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

   self.productDic = dic;
    self.productsArray = [dic objectForKey:@"orderActivityList"];

    [self drawInterFace];
    
    [self pay];

}
- (void) surePayRequestFault:(ASIFormDataRequest*)request{

    [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_productsCount release];
    [_scrollViewProducts release];
    [_select release];
    [_payByWeb release];
    [_selectByClient release];
    [_payByClient release];
    [_totalPrices release];
    [_accountBalance release];
    [_payment release];
    [_productDic release];
    [_productsArray release];
    [_orderId release];
    [_orderIdString release];
    [_paymentString release];
    [_balanceString release];
    [super dealloc];
}
@end
