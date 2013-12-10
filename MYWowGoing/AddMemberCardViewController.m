//
//  AddMemberCardViewController.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-29.
//
//

#import "AddMemberCardViewController.h"
#import "ScanningVC.h"
#import "EditingMemberCardViewController.h"
#import "MemberList.h"
#import "UIImageView+WebCache.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
@interface AddMemberCardViewController ()
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (retain, nonatomic) NSArray *cardArray;

@end

@implementation AddMemberCardViewController

- (void)dealloc {
    [_mainScrollView release];
    [_cardArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScrollView:nil];
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
        //        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
		UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		self.navigationItem.leftBarButtonItem = litem;
		[litem release];

        self.title = @"添加会员卡";
        
        self.cardArray = [NSArray array];
    }
    return self;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saoYiSaoAction:(id)sender {
    
    ScanningVC  *scanningVC = [[[ScanningVC alloc ]initWithNibName:@"ScanningVC" bundle:nil] autorelease];
    
    scanningVC.type = 1;
    
    [self.navigationController pushViewController:scanningVC animated:YES];
//    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)addCardAction1:(id)sender {
    
    EditingMemberCardViewController  *edittingVC = [[[EditingMemberCardViewController alloc ]initWithNibName:@"EditingMemberCardViewController" bundle:nil] autorelease];
    edittingVC.flagCardType = 1;
    [self.navigationController pushViewController:edittingVC animated:YES];
    
}

- (IBAction)addCardAction2:(id)sender {
    
    EditingMemberCardViewController  *edittingVC = [[[EditingMemberCardViewController alloc ]initWithNibName:@"EditingMemberCardViewController" bundle:nil] autorelease];
    edittingVC.flagCardType = 2;
    [self.navigationController pushViewController:edittingVC animated:YES];
}
#pragma mark ---------- 会员卡列表
- (void)memberCardList {
    
    MemberList *ml = [[[MemberList alloc] init] autorelease];
    ml.delegate = self;
    ml.username = [Util getLoginName];
    ml.password = [Util getPassword];
    ml.onFaultSeletor = @selector(memberListFault:);
    ml.onSuccessSeletor = @selector(memberListSuccess:);
    [ml asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)memberListFault:(ASIFormDataRequest *)request {
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
- (void)memberListSuccess:(ASIFormDataRequest *)request {

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
    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    //遍历会员卡列表
    [self showMemberCard:dic];
 
}

- (void)showMemberCard:(NSMutableDictionary *)dict {

    self.cardArray = [dict objectForKey:@"memberList"];
    NSLog(@"%d",_cardArray.count);
    //会员卡列表
//    NSArray *arrayMemberList = [dict objectForKey:@"memberList"];
    EGOImageButton *imageView = nil;
    EGOImageButton *imageDefault = nil;
    for (int i=0; i<_cardArray.count; i++)
    {
        int ishaveNum = [[[_cardArray objectAtIndex:i] objectForKey:@"ishave"] intValue];
        NSString *urlString = [[_cardArray objectAtIndex:i] objectForKey:@"memberPic"];
        imageView = [[EGOImageButton alloc] initWithFrame:CGRectMake(i%3 * (101+8), i/3 * (69+8), 101, 69)];
        imageDefault = [[EGOImageButton alloc] initWithFrame:CGRectMake(i%3 * (101+8), i/3 * (69+8), 101, 69)];
        if (ishaveNum == 0) {
            [imageView setImageURL:[NSURL URLWithString:urlString]];
            [imageDefault setImage:[UIImage imageNamed:@"会员卡添加按钮"] forState:UIControlStateNormal];
            NSLog(@"可以添加会员卡");
        } else {
            [imageView setImageURL:[NSURL URLWithString:urlString]];
//            [imageView setImage:[UIImage imageNamed:@"添加会员卡"] forState:UIControlStateNormal];
            NSLog(@"不可添加会员卡");
        }
        imageView.tag = i;
        imageDefault.tag = i;
        [imageView addTarget:self action:@selector(showCardAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageDefault addTarget:self action:@selector(showCardAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:imageView];
        [_mainScrollView addSubview:imageDefault];
        [imageView release];
   
    }
    
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, (_cardArray.count/3)*(69+8)+69+8+79);
}

- (void)showCardAction: (id)sender {
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    NSDictionary *dic = [_cardArray objectAtIndex:tag];
    //是否有添加按钮
    NSString *stringisHave = [dic objectForKey:@"ishave"];
    //会员id
    NSString *memberInfoIdStr = [dic objectForKey:@"memberInfoId"];
    //会员卡号
    NSString *memberNumberIdStr = [dic objectForKey:@"membershipNumber"];
    //是否可以出现删除按钮
    NSString *memberType = [dic objectForKey:@"membertype"];
    EditingMemberCardViewController  *edittingVC = [[[EditingMemberCardViewController alloc ]initWithNibName:@"EditingMemberCardViewController" bundle:nil] autorelease];
    if ([stringisHave isEqualToString:@"1"]) {
        edittingVC.flagCardType = 1;
    }else {
        edittingVC.flagCardType = 0;
    }
    edittingVC.memberInfoIdString = memberInfoIdStr;
    edittingVC.memberNumberString = memberNumberIdStr;
    edittingVC.memberTypeString = memberType;
    [self.navigationController pushViewController:edittingVC animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //显示会员卡
    [self memberCardList];
//    self.navigationController.navigationBarHidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
