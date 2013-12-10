//
//  ScanningVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-1-11.
//
//

#import "ScanningVC.h"
 
#import "JSON.h"
 
#import "MemberInSaoMiaoBS.h"
#import "Single.h"
#import "MobClick.h"

#import "Toast+UIView.h"

@interface ScanningVC ()

@end

@implementation ScanningVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 6, 52, 32)];
        [backBtn addTarget:self action:@selector(back) forControlEvents:  UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = litem;
        [litem release];
        self.title = @"扫一扫";
    }
    return self;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [MobClick event:@"mytjr"];//我的推荐人事件统计ID
    ZBarReaderView *readView=[ZBarReaderView new];
    readView.frame=CGRectMake(0,0, 320, IPHONE_HEIGHT);
    readView.tag=88;
    readView.readerDelegate=self;
    readView.allowsPinchZoom=NO;
    
    UIImageView *overLay=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320,IPHONE_HEIGHT-49)];
    overLay.image=[UIImage imageNamed:@"二维码_扫描框.png"];
    [readView addSubview:overLay];
    [overLay release];

    UIImageView *remindImageView;
    if (iPhone5) {
      remindImageView=[[UIImageView alloc]initWithFrame:CGRectMake(50,IPHONE_HEIGHT-210,222, 50)];
    }else{
      remindImageView=[[UIImageView alloc]initWithFrame:CGRectMake(50,300,222, 50)];
    }
    remindImageView.image=[UIImage imageNamed:@"二维码_提示框.png"];
    [overLay addSubview:remindImageView];
    [remindImageView release];
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(57, 5, 156, 40)];
    lable.numberOfLines=0;
    lable.lineBreakMode=UILineBreakModeWordWrap;
    lable.backgroundColor=[UIColor clearColor];
    lable.text=@"将二维码图案放在取景框内即可自动扫描";
    lable.textColor=[UIColor whiteColor];
    [remindImageView addSubview:lable];
    [lable release];
    
    [self.view addSubview:readView];

    [readView start];//开始扫描
    [readView release];
    
}
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{
    // 得到扫描的条码内容
     const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    
     NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    
    if (self.type == 2) {
        NSArray *array=[symbolStr componentsSeparatedByString:@"wowgoing"];
        
        if (array.count==1) {
            [self.view makeToast:@"您扫描的不是有效的二维码" duration:0.5 position:@"center" title:nil];
            return ;
        }
        NSString *channelid=[array objectAtIndex:0];//渠道ID
        NSString *shopAssistantID=[array objectAtIndex:1];//店员ID
        
        NSString *devicecode=[Util getDeviceId];//用户设备码
        
        if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) { // 是否QR二维码
            [self commitScanningResult:channelid :shopAssistantID :devicecode];
        }else{
           [self.view makeToast:@"您扫描的不是有效的二维码" duration:0.5 position:@"center" title:nil];
        }

    }else{
    
        NSArray *array=[symbolStr componentsSeparatedByString:@"wowgoing"];
        
        if (array.count==1 || array.count == 2) {
            [self.view makeToast:@"您扫描的不是有效的二维码" duration:0.5 position:@"center" title:nil];            return ;
        }
        NSString *channelid=[array objectAtIndex:0];//渠道ID
        NSString *shopAssistantID=[array objectAtIndex:1];//店员ID
        NSString * memberInfoId= [array objectAtIndex:2];//会员卡卡号
        
        if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) { // 是否QR二维码
            
            [self requestMeberCard:channelid :shopAssistantID :memberInfoId];
            
        }else{
          [self.view makeToast:@"您扫描的不是有效的二维码" duration:0.5 position:@"center" title:nil];
        }
    }
    
}

-(void)hiddenScanningFish{
    ZBarReaderView *read=(ZBarReaderView*)[self.view viewWithTag:88];
    UIImageView *image=(UIImageView*)[read viewWithTag:10000];
    [image removeFromSuperview];
    [read start];
}

#pragma mark
#pragma mark      **************扫描推荐人*************
-(void)commitScanningResult:(NSString*)channelID :(NSString*)shopAssistantID :(NSString*)deviceCode{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    
    [jsonreq setValue:channelID  forKey:@"channelid"];
    [jsonreq setValue:deviceCode forKey:@"deviceId"];
    [jsonreq setValue:deviceCode forKey:@"devicecode"];
    [jsonreq setValue:shopAssistantID forKey:@"userid"];
    
    SBJsonWriter *sbjison=[SBJsonWriter alloc];
    
    NSString  *sbreq = [sbjison stringWithObject:jsonreq];
    
    [sbjison release];
   
    NSString *urlString = [NSString stringWithFormat:@"%@/user/dealwithscore",SEVERURL];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
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
        [self.view makeToast:@"网络不可用" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
         [self.view makeToast:@"您扫描的不是有效的二维码" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    ZBarReaderView *readerView=(ZBarReaderView*)[self.view viewWithTag:88];
    
    UIImageView *scanningFinsh=[[UIImageView alloc]initWithFrame:CGRectMake(36, 125, 253, 95)];
    scanningFinsh.image=[UIImage imageNamed:@"二维码_弹框.png"];
    scanningFinsh.tag=10000;
    [readerView addSubview:scanningFinsh];
    [scanningFinsh release];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, scanningFinsh.frame.size.width, scanningFinsh.frame.size.height)];
    label.numberOfLines=0;
    label.lineBreakMode=UILineBreakModeWordWrap;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.text=[dic objectForKey:@"result"];
    [scanningFinsh addSubview:label];
    [label release];
    
    [readerView stop];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenScanningFish) userInfo:nil repeats:NO];
}

#pragma mark
#pragma mark    *************扫描会员卡************
- (void)requestMeberCard:(NSString*)qudao :(NSString*)dianYuan :(NSString*)cardNumber{
    
    MemberInSaoMiaoBS  *memBerBS = [[[MemberInSaoMiaoBS alloc ]init] autorelease];
    memBerBS.delegate = self;
    memBerBS.quDaoID = qudao;
    memBerBS.huiYuanKaID = cardNumber;
    memBerBS.tuiJianRenID =  dianYuan;
    [memBerBS setOnSuccessSeletor:@selector(requestMeberCardSuccess:)];
    [memBerBS setOnFaultSeletor:@selector(requestMeberCardFault:)];
    [memBerBS asyncExecute];
}

- (void)requestMeberCardSuccess:(ASIFormDataRequest*)request{

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
        [self.view makeToast:@"网络不可用" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    
    BOOL  isSuccess = [dic objectForKey:@"successStatus"];
    if (!isSuccess) {
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        [self.view makeToast:@"您扫描的不是有效的二维码" duration:0.5 position:@"center" title:nil];
        return;
    }
    
    ZBarReaderView *readerView=(ZBarReaderView*)[self.view viewWithTag:88];
    
    UIImageView *scanningFinsh=[[UIImageView alloc]initWithFrame:CGRectMake(36, 125, 253, 95)];
    scanningFinsh.image=[UIImage imageNamed:@"二维码_弹框.png"];
    scanningFinsh.tag=10000;
    [readerView addSubview:scanningFinsh];
    [scanningFinsh release];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, scanningFinsh.frame.size.width, scanningFinsh.frame.size.height)];
    label.numberOfLines=0;
    label.lineBreakMode=UILineBreakModeWordWrap;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.text=[dic objectForKey:@"result"];
    [scanningFinsh addSubview:label];
    [label release];
    
    [readerView stop];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenScanningFish) userInfo:nil repeats:NO];

}

- (void)requestMeberCardFault:(ASIFormDataRequest*)request{
    [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
