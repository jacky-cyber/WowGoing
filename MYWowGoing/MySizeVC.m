//
//  MySizeVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import "MySizeVC.h"
#import "SizeCell.h"
 
#import "JSON.h"

#import "ASIHTTPRequest.h"
 
#import "LoginViewController.h"
#import "RegisterView.h"
#import "CustomAlertView.h"
@interface MySizeVC ()
@property (nonatomic, retain) NSMutableArray *sizeArray; //尺码
@property (nonatomic, retain) NSMutableArray *ageArray;    //年龄
@property (nonatomic, retain) NSMutableArray *sexArray;    //性别
@property (nonatomic, retain) NSMutableArray *heightArray; //身高
@property (nonatomic, retain) NSMutableArray *weightArray; //体重
@property (nonatomic, retain) NSMutableArray *coatArray;   //上衣
@property (nonatomic, retain) NSMutableArray *kuArray;     //裤子
@property (nonatomic, retain) NSMutableArray *shoesArray;  //鞋子
@property (nonatomic, retain) NSMutableArray *arrayData;
@property (nonatomic, retain) NSString *stringText; //尺码内容
@property (nonatomic, assign) int btnTag;
@property (nonatomic, assign) int sexNum; //0男 1女
@property (nonatomic, assign) BOOL sexBool;

@end

@implementation MySizeVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        返回按钮
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
        UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = litem;
        [backBtn release];
        [litem release];
        
        UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(256, 6, 60, 34)];
        [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"botton.png"] forState:UIControlStateNormal];
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
        UIBarButtonItem *litemsubmitBtn = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
        self.navigationItem.rightBarButtonItem = litemsubmitBtn;
        [submitBtn release];
        [litemsubmitBtn release];
        
        UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
        titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
        [self.view addSubview:titbackImageview];
        [titbackImageview release];

    }
    return self;
}


- (void)submitAction:(id)sender {
    
//    if (_ageBtn.text == nil || _heightBtn.text == nil || _weightBtn.text == nil|| _bmiBtn.text == nil || _shangSizeBtn.text == nil || _kuSizeBtn.text == nil || _shoesBtn.text==nil) {
//        [self showToastMessageAtCenter:@"请填写完整的数据"];
//        return;
//    }
    if ([_sexBtn.text isEqualToString:@"男"]) {
        _sexNum = 0;
    } else {
        _sexNum = 1;
    }
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[NSNumber numberWithInt:[_ageBtn.text intValue]] forKey:@"age"];
    [jsonreq setValue:[NSNumber numberWithInt:_sexNum] forKey:@"gender"];
    [jsonreq setValue:[NSNumber numberWithInt:[_heightBtn.text doubleValue]] forKey:@"height"];
    [jsonreq setValue:[NSNumber numberWithInt:[_weightBtn.text doubleValue]] forKey:@"weight"];
    [jsonreq setValue:[NSNumber numberWithInt:[_shoesBtn.text doubleValue]] forKey:@"shoesSize"];
    [jsonreq setValue:[NSNumber numberWithInt:[_kuSizeBtn.text doubleValue]] forKey:@"pantsSize"];
    [jsonreq setValue:_shangSizeBtn.text forKey:@"clothesSize"];
    [jsonreq setValue:_bmiBtn.titleLabel.text forKey:@"BMI"];
    [jsonreq setValue:@"" forKey:@"phone"];
    [jsonreq setValue:@"" forKey:@"wowgoingAccount"];
    [jsonreq setValue:@"" forKey:@"city"];
    [jsonreq setValue:@"" forKey:@"province"];
    NSLog(@"brandid : %@",jsonreq);
    
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

    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,USER_ADD];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(submitSizeFinish:)];
     [requestForm setDidFailSelector:@selector(submitSizeFail:)];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}
- (void)submitSizeFail:(ASIFormDataRequest *)reqeust {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
- (void)submitSizeFinish:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        dic= [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        NSString *jsonString = [request responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus==200 ) {
    
        [self.view makeToast:@"提交成功"];
        return;
    } else {
        [self.view makeToast:@"提交失败"];
    }
}
-(void)backAction {
//    if (_sexBtn.selected) {
//        _sexBtn.selected = NO;
//    } else {
//        _sexBtn.selected = YES;
//    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"我的尺码"];
//    [[NSUserDefaults standardUserDefaults] boolForKey:@"boolSex"];
    [self requestSizeData];
    self.sizeArray = [NSArray arrayWithObjects:@"我的年龄",@"我的性别", @"我的身高",@"我的体重",@"我的bmi",@"我的上衣尺码",@"我的裤装尺码",@"我的鞋码", nil];
    [self loadData]; //初始化所有数据
     
}


- (void)requestSizeFail:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.view makeToast:NETWORK_STRING];
    
}

- (void)requestSizeSucess:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        dic= [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        NSString *jsonString = [request responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200 ) {
        [self.view makeToast:NETWORK_STRING];
        return;
    }
    else
    {
        int sexNum = [[dic objectForKey:@"gender"] intValue];
        if (sexNum == 1) {
            _sexBtn.text = @"女";
        } else {
            _sexBtn.text = @"男";
        }
        [_ageBtn setText:[dic objectForKey:@"age"]];
        [_heightBtn setText:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"height"] intValue]]];
        NSString *weightNum = [dic objectForKey:@"weight"];
        [_weightBtn setText:[NSString stringWithFormat:@"%d",[weightNum intValue]]];
        [_bmiBtn setTitle:[dic  objectForKey:@"BMI"] forState:UIControlStateNormal];
        [_shangSizeBtn setText:[dic objectForKey:@"clothesSize"]];
        [_kuSizeBtn setText:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"pantsSize"] intValue]]];
        NSString *shoesNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shoesSize"]];
        [_shoesBtn setText:[NSString stringWithFormat:@"%d",[shoesNum intValue]]];
        NSLog(@"%@",shoesNum);
    }
    
}


- (void)requestSizeData {

    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
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

    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,USER_USERSIZE];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDidFinishSelector:@selector(requestSizeSucess:)];
    [requestForm setDidFailSelector:@selector(requestSizeFail:)];

}

- (void)loadData {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 18; i<100; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    self.ageArray = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *heightArray = [NSMutableArray array];
    for (int i = 140; i<220; i++) {
        [heightArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    self.heightArray = [NSMutableArray arrayWithArray:heightArray];
    
    NSMutableArray *weight = [NSMutableArray array];
    for (int i = 30; i<121; i++) {
        [weight addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    self.weightArray = [NSMutableArray arrayWithArray:weight];
    
    NSArray *coatA = [NSArray arrayWithObjects:@"XXS",@"XS",@"S",@"M",@"L",@"XL",@"XXL",@"XXXL", nil];
    self.coatArray = [NSMutableArray arrayWithArray:coatA];
//    裤装尺码：23-44
//    鞋码：33-45
    NSMutableArray *sex = [NSArray arrayWithObjects:@"男",@"女", nil];
    self.sexArray = [NSMutableArray arrayWithArray:sex];
    
    NSMutableArray *ku = [NSMutableArray array];
    for (int i = 23; i<45; i++) {
        [ku addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    self.kuArray = [NSMutableArray arrayWithArray:ku];
    
    NSMutableArray *shoe = [NSMutableArray array];
    for (int i = 33; i<46; i++) {
        [shoe addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    self.shoesArray = [NSMutableArray arrayWithArray:shoe];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_ageArray release];
    [_sexArray release];
    [_heightArray release];
    [_weightArray release];
    [_coatArray release];
    [_kuArray release];
    [_shoesArray release];
    [_sizeArray release];
    [_pickView release];
    [_pv release];
    [_ageBtn release];
    [_weightBtn release];
    [_heightBtn release];
    [_bmiBtn release];
    [_shangSizeBtn release];
    [_kuSizeBtn release];
    [_shoesBtn release];
    [_typeLabel release];
    [_sexBtn release];
    [_BMIView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPickView:nil];
    [self setPv:nil];
    [self setAgeBtn:nil];
    [self setWeightBtn:nil];
    [self setHeightBtn:nil];
    [self setBmiBtn:nil];
    [self setShangSizeBtn:nil];
    [self setKuSizeBtn:nil];
    [self setShoesBtn:nil];
    [self setTypeLabel:nil];
    [self setSexBtn:nil];
    [self setBMIView:nil];
    [super viewDidUnload];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _pickView.hidden = NO;
    }
}

//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_arrayData objectAtIndex:row];
    switch (row) {
        case 0:
            NSLog(@"row:%d",row);
            break;
        case 1:
            NSLog(@"row:%d",row);
            break;
    }
}
#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return [_arrayData count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component {
    return [_arrayData objectAtIndex:row];
}


- (IBAction)hidenPickView:(id)sender {
    _pickView.hidden = YES;
    NSInteger row = [_pv selectedRowInComponent:0];
    NSString *selected = [_arrayData objectAtIndex:row];
    if ([selected isEqualToString:@""]) {
        return;
    }
    
    if (_btnTag == 100) { //年龄
        [_ageBtn setText:selected];
    } else if (_btnTag == 200) { //身高
        [_heightBtn setText:selected ];
    } else if (_btnTag == 300) { //体重
        [_weightBtn setText:selected];
    } else if (_btnTag == 400) { //bmi
                
        
    } else if (_btnTag == 500) { //上衣尺码
        [_shangSizeBtn setText:selected];
    } else if (_btnTag == 600) { //裤装尺码
        [_kuSizeBtn setText:selected ];
    } else if (_btnTag == 700){ //我的鞋码
        [_shoesBtn setText:selected];
    } else {
        [_sexBtn setText:selected];
    }
    
}

- (IBAction)ageBtnAction:(id)sender {
    _pickView.hidden = NO;
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 100) { //年龄
        _arrayData = _ageArray;
        _stringText =_ageBtn.text;
        _typeLabel.text = @"岁";
    } else if (button.tag == 200) { //身高
        _arrayData = _heightArray;
        _stringText = _heightBtn.text;
        _typeLabel.text = @"cm";
    } else if (button.tag == 300) { //体重
        _arrayData = _weightArray;
        _stringText = _weightBtn.text;
        _typeLabel.text = @"kg";
    } else if (button.tag == 400) { //bmi
        
    } else if (button.tag == 500) { //上衣尺码
        _arrayData = _coatArray;
        _stringText = _shangSizeBtn.text;
         _typeLabel.text = @"";
    } else if (button.tag == 600) { //裤装尺码
        _arrayData = _kuArray;
        _stringText  = _kuSizeBtn.text;
         _typeLabel.text = @"";
    } else if (button.tag == 700) { //我的鞋码
        _arrayData = _shoesArray;
        _stringText = _shoesBtn.text;
         _typeLabel.text = @"";
    } else {
        _arrayData = _sexArray;
        _stringText = _sexBtn.text;
        _typeLabel.text = @"";
    }
     _btnTag = button.tag;
    NSLog(@"pickViewDataString:%@",_stringText);
    [_pv reloadAllComponents];
    [self getPickViewData:_arrayData textString:_stringText];

}

//让pickview记住上次选中的状态
- (void)getPickViewData:(NSArray *)arrayPick textString:(NSString *)stringContent
{
    for (int i = 0; i<_arrayData.count; i++) {
        NSString *stringText = [_arrayData objectAtIndex:i];
        if ([stringContent isEqualToString:stringText]) {
            NSLog(@"相等的下表是：%d", i);
            [self.pv selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}

- (IBAction)bmiAction:(id)sender {
    if (_BMIView.hidden == YES) {
        _BMIView.hidden = NO;
    } else {
        _BMIView.hidden = YES;
    }
    float weightNum = [_weightBtn.text intValue];
    float heightNum = [_heightBtn.text intValue];
    float heiNum = [[NSString stringWithFormat:@"%0.1f",heightNum/100] floatValue];
    float bmi = [[NSString stringWithFormat:@"%0.1f",weightNum/(heiNum*heiNum)] floatValue];
    [_bmiBtn setTitle:[NSString stringWithFormat:@"%0.01f",bmi] forState:UIControlStateNormal];

}


@end
