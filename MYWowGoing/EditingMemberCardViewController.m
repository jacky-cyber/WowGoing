//
//  EditingMemberCardViewController.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-29.
//
//

#import "EditingMemberCardViewController.h"
#import "EditCardBS.h"
#import "EditCardBS.h"
#import "DetelMemberCardBS.h"
#import "AddMemberCardBS.h"
@interface EditingMemberCardViewController ()
@property (retain, nonatomic) IBOutlet UIButton *edittingBut;
@property (retain, nonatomic) IBOutlet UIButton *cancleBut;
@property (retain, nonatomic) IBOutlet UIButton *addBut;

@end

@implementation EditingMemberCardViewController

- (void)dealloc {
    [_memberTypeString release];
    [_memberInfoIdString release];
    [_memberNumberString release];
    [_edittingBut release];
    [_cancleBut release];
    [_addBut release];
    [_card release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMemberInfoIdString:nil];
    [self setMemberNumberString:nil];
    [self setMemberTypeString:nil];
    [self setEdittingBut:nil];
    [self setCancleBut:nil];
    [self setAddBut:nil];
    [self setCard:nil];
    [super viewDidUnload];
}

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
        self.title = @"会员卡";
    }
    return self;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editMemberCard {
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    if (self.flagCardType == 1 && [_memberTypeString isEqualToString:@"1"]) {
        self.edittingBut.hidden = NO;
        self.cancleBut.hidden = NO;
        self.addBut.hidden = YES;
    }
    if (self.flagCardType == 1 && [_memberTypeString isEqualToString:@"0"]){
        self.edittingBut.hidden = YES;
        self.cancleBut.hidden = NO;
        self.addBut.hidden = YES;
    }
    if (self.flagCardType == 0 && [_memberTypeString isEqualToString:@"1"]){
        self.edittingBut.hidden = YES;
        self.cancleBut.hidden = YES;
        self.addBut.hidden = NO;
    }
    _card.text = _memberNumberString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ---------- 添加会员卡

- (IBAction)addMemberCard:(id)sender {
    AddMemberCardBS *ml = [[[AddMemberCardBS alloc] init] autorelease];
    ml.delegate = self;
    ml.username = [Util getLoginName];
    ml.password = [Util getPassword];
    ml.customeridString = [Util getCustomerID];
    ml.memberInfoIdString = _memberInfoIdString;
    ml.membershipNumberString = _card.text;
    ml.onFaultSeletor = @selector(memberAddFault:);
    ml.onSuccessSeletor = @selector(memberAddSuccess:);
    [ml asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)memberAddFault:(ASIFormDataRequest *)request {
        
    [self.view makeToast:NETWORK_STRING];
}

- (void)memberAddSuccess:(ASIFormDataRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
    }else{
        return;
    }
    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        NSLog(@"返回结果错误");
        return;
    }
    BOOL isExist = [[dic objectForKey:@"isExist"] boolValue];
    if (isExist)
    {
        [self.view makeToast:@"您的会员卡已存在，不能重复添加"];
        return;
    }
    
    BOOL successStatus = [[dic objectForKey:@"successStatus"] boolValue];

    if (successStatus)
    {
        NSLog(@"返回结果错误");
        [self.view makeToast:@"添加会员卡成功"];
    } else {
        [self.view makeToast:@"添加会员卡失败"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---------- 编辑会员卡
- (IBAction)editCardAction:(id)sender {
    
    EditCardBS *ml = [[[EditCardBS alloc] init] autorelease];
    ml.delegate = self;
    ml.username = [Util getLoginName];
    ml.password = [Util getPassword];
    ml.customeridString = [Util getCustomerID];
    ml.memberInfoIdString = _memberInfoIdString;
//    ml.memberInfoIdString = @"7";
    ml.membershipNumberString = _card.text;
    ml.onFaultSeletor = @selector(memberEditFault:);
    ml.onSuccessSeletor = @selector(memberEditSuccess:);
    [ml asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)memberEditSuccess:(ASIFormDataRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
    }else{
        
        return;
    }
    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    BOOL successStatus = [[dic objectForKey:@"successStatus"] boolValue];
    if (!successStatus)
    {
        [self.view makeToast:@"卡号编辑错误"];
    } else {
        [self.view makeToast:@"卡号编辑成功"];
    }
[self.navigationController popViewControllerAnimated:YES];
    
}


- (void)memberEditFault:(ASIFormDataRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    NSLog(@"%@",dic);
}

#pragma mark ---------- 删除会员卡
- (IBAction)deleteCardAction:(id)sender {
    
    DetelMemberCardBS *ml = [[[DetelMemberCardBS alloc] init] autorelease];
    ml.delegate = self;
    ml.username = [Util getLoginName];
    ml.password = [Util getPassword];
    ml.customeridString = [Util getCustomerID];
    ml.memberInfoIdString = _memberInfoIdString;
    ml.membershipNumberString = _card.text;
    ml.onFaultSeletor = @selector(memberDetelFault:);
    ml.onSuccessSeletor = @selector(memberDetelSuccess:);
    [ml asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)memberDetelSuccess:(ASIFormDataRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
    }else{
        return;
    }
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        NSLog(@"返回结果错误");
        return;
    }
    
    BOOL successStatus = [[dic objectForKey:@"successStatus"] boolValue];
    if (successStatus)
    {
        [self.view makeToast:@"删除会员卡成功"];
    } else {
        [self.view makeToast:@"删除会员卡失败"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)memberDetelFault:(ASIFormDataRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
        
    }
    
    return YES;
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}
@end
