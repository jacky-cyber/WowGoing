//
//  PayByWgoingVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-3-20.
//
//

#import "PayByWgoingVC.h"
#import "Paybywowgoing.h"
#import "SurePayBS.h"

#import "Toast+UIView.h"

static PayByWgoingVC *shareFnalStatementVC;
@interface PayByWgoingVC ()
{

    NSMutableArray *activityArray;
    NSMutableArray  *orderIDArray;
}

@end

@implementation PayByWgoingVC

+(PayByWgoingVC*)shareFnalStatementController
{
    if (shareFnalStatementVC == nil) {
        shareFnalStatementVC = [[PayByWgoingVC alloc] init];
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

- (IBAction)countersignToPay:(id)sender {
    if (self._notPay) {
        self.orderIdString = [[self.productDic objectForKey:@"orderId"] componentsJoinedByString:@","];
         [self updateWowgoingAmount:[self.totolPrice floatValue]];
    }else{
        [self surePayRequest];
    }
}

- (IBAction)confirmToBuy:(id)sender {
    if (self._notPay) {
         self.orderIdString = [[self.productDic objectForKey:@"orderId"] componentsJoinedByString:@","];
         [self updateWowgoingAmount:[self.totolPrice floatValue]];
    }else{
        [self surePayRequest];
    }
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

- (void)drawInterFace{

    [self.productsScroll    removeAllSubviews];
    
    self.productsScroll.contentSize=CGSizeMake(self.productsScroll.frame.size.width,self.productsArray.count*25);
    
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
        
        UILabel *productPrice=[[UILabel alloc]initWithFrame:CGRectMake(productCount.frame.origin.x+productCount.frame.size.width+10, productName.frame.origin.y,60, 20)];
        productPrice.backgroundColor=[UIColor clearColor];
        productPrice.font=[UIFont systemFontOfSize:14.0];
        productPrice.text = [NSString stringWithFormat:@"￥%@",[productDic objectForKey:@"discountPrice"] ];
        
        
        [self.productsScroll addSubview:productName];
        [self.productsScroll addSubview:productCount];
        [self.productsScroll addSubview:productPrice];
        
        [productName release];
        [productCount release];
        [productPrice release];
        
        
        NSString *orderID = [productDic objectForKey:@"orderId"];
        [orderidArray addObject:orderID];
    }
    
    
    self.orderIdString = [orderidArray componentsJoinedByString:@","];
    
    
    self.totolPrice = [self.productDic objectForKey:@"countPrice"];
    self.productsPrice.text = [NSString stringWithFormat:@"￥%.2f",[self.totolPrice floatValue]];
    
    self.balanceAcount.text = [NSString stringWithFormat:@"￥%.2f",[[self.productDic objectForKey:@"wowgoingAccount"] floatValue]];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    activityArray = [[NSMutableArray alloc ] init];
    
    orderIDArray = [[NSMutableArray alloc ]init];
    
}

#pragma mark
#pragma mark  更新wowgoing账户
-(void)updateWowgoingAmount:(float)price{ //更新wowgoing账户余额
    
    Paybywowgoing *payByWowgoing=[[[Paybywowgoing alloc]init] autorelease];
    payByWowgoing.delegate=self;
    payByWowgoing.productsArray=self.productsArray;
    payByWowgoing.orderId=self.orderId;
    payByWowgoing.orderIdString=self.orderIdString;
    payByWowgoing.onSuccessSeletor = @selector(updateWowgoingAmountFinished:);
    payByWowgoing.onFaultSeletor = @selector(updateWowgoingAmountFailed:);
    [payByWowgoing asyncExecute];
    
}

- (void)updateWowgoingAmountFinished:(ASIHTTPRequest *)request
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
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
    if (dic == NULL  ) {
       [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
    [self.view makeToast:@"更新wowgoing账户成功" duration:0.5 position:@"center" title:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateWowgoingAmountFailed:(ASIHTTPRequest *)request
{
    [self.view makeToast:@"更新wowgoing账户失败" duration:0.5 position:@"center" title:nil];
    [self updateWowgoingAmount:[self.totolPrice floatValue]];
    
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
    
     [self updateWowgoingAmount:[self.totolPrice floatValue]];
    
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
    [_productDic release];
    [_productsCount release];
    [_productsScroll release];
    [_productsPrice release];
    [_balanceAcount release];
    [_productsArray release];
    [_orderId release];
    [_orderIdString release];
    [_totolPrice release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProductsCount:nil];
    [self setProductsScroll:nil];
    [self setProductsPrice:nil];
    [self setBalanceAcount:nil];
    [self setProductsArray:nil];
    [self setOrderId:nil];
    [self setOrderIdString:nil];
    [self setTotolPrice:nil];
    [super viewDidUnload];
}
@end
