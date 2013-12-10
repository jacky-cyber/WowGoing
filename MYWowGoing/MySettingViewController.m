//
//  MySettingViewController.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-9.
//
//

#import "MySettingViewController.h"
#import "SettingCell.h"
#import "SettingCell1.h"
#import "SettingCell2.h"
#import "MySizeVC.h"
#import "BrandViewController.h"
#import "ScanningVC.h"
#import "ASIHTTPRequest.h"
 
#import "AddressManageViewController.h"

#import "CustomAlertView.h"
#import "JSON.h"
#import <ShareSDK/ShareSDK.h>

@interface MySettingViewController ()
@property (nonatomic,retain) NSArray *list;
@property (nonatomic ,retain) NSDictionary *dictionary;
@property (nonatomic ,assign) int deletedNum; //push
@property (nonatomic ,assign) int typeId; //push
@property(nonatomic,assign) BOOL saomiao;
@end

@implementation MySettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
- (void)backAction {
    if (self.saomiao) {
        self.saomiao=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WowCreads" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = litem;
    [backBtn release];
    [litem release];
    
    self.title = @"个人设置";
    UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
    [self.view addSubview:titbackImageview];
    [titbackImageview release];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myTableView release];
    [_myView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [self setMyView:nil];
    [super viewDidUnload];
}
-(IBAction)closeDone:(id)sender
{
    UITextField *textField = (UITextField*)sender;
    
    [textField resignFirstResponder];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    CustomAlertView *alert = [[[CustomAlertView alloc] initWithTitle:nil
                                                             message:@"敬请期待"
                                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消", nil] autorelease];
    [alert show];
}
- (void)PushfindDevicenum:(int)deletedNumber
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    NSString *urlString;
   
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }else{
        [common setValue:@"123@abc.com" forKey:@"loginId"];
        [common setValue:@"111111" forKey:@"password"];
    }
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    //0接受 1 不接受
    [jsonreq setValue:[NSNumber numberWithInt:deletedNumber] forKey:@"deleted"];
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

    urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,PUSH_UPDATE];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(pushFinishSuccess:)];
    [requestForm setDidFailSelector:@selector(pushFail:)];
    [self showLoadingView];
}

- (void)pushOnOrOff:(UISwitch *)swicth
{
    BOOL swichbool = swicth.isOn;
    if (swichbool) {
        NSLog(@"on");
        [self PushfindDevicenum:0];

    } else {
        NSLog(@"off");
        [self PushfindDevicenum:1];
    }
}

- (void)pushFail:(ASIHTTPRequest *)request
{

    [self hideLoadingView];

}
- (void)pushFinishSuccess:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
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

    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {
        [self.view makeToast:@"您的网络不给力,请重新试试吧"];
        return;
    }
    
    if (dic == NULL  ) {
        [self.view makeToast:@"您的网络不给力,请重新试试吧"];
        return;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //每个数组都有一个分组
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取分组
    if (section == 0)
    {
        return 5;
    }
    else if (section == 2)
    {
        return 2;
    }
    return 0;

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        static NSString *customCell = @"customCell2";
        SettingCell2 *cell = (SettingCell2 *)[tableView dequeueReusableCellWithIdentifier:customCell];
        
        if (cell == nil) {
            //如果没有可重用的单元，我们就从nib里面加载一个，
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingCell2"
                                                         owner:self options:nil];
            //迭代nib重的所有对象来查找SettingCell类的一个实例
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[SettingCell2 class]]) {
                    cell = (SettingCell2 *)oneObject;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row ==0) {
            cell.weiboLogo.image = [UIImage imageNamed:@"个人设置_新浪微博"];
            cell.weiboName.text = @"新浪微博";
            if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
                cell.weiboBinding.text = @"已授权";
            } else {
                cell.weiboBinding.text = @"未授权";
            }
            
        } else {
            cell.weiboLogo.image = [UIImage imageNamed:@"个人设置_腾讯微博"];
            cell.weiboName.text = @"腾讯微博";
            if ([ShareSDK hasAuthorizedWithType:ShareTypeTencentWeibo]) {
                cell.weiboBinding.text = @"已授权";
            } else {
                cell.weiboBinding.text =  @"未授权";
            }
        }
        
        return cell;
    }
    
    static NSString *customCell = @"customCell";
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
    
    if (cell == nil) {
        //如果没有可重用的单元，我们就从nib里面加载一个，
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingCell"
                                                     owner:self options:nil];
        //迭代nib重的所有对象来查找SettingCell类的一个实例
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[SettingCell class]]) {
                cell = (SettingCell *)oneObject;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.txtLabel.text = @"我的推荐人";
        } else if (indexPath.row == 1) {
            cell.txtLabel.text = @"我的电话";
        }else if (indexPath.row==2){
           cell.txtLabel.text = @"我的尺码";
        }else if(indexPath.row == 3) {
            cell.txtLabel.text = @"关注品牌";
        }else{
            cell.txtLabel.text = @"地址管理";
        }
    }
    return cell; 

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//获取分组标题并显示
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return @"分享设置";
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            ScanningVC *scan=[[[ScanningVC alloc]initWithNibName:@"ScanningVC" bundle:nil] autorelease];
            scan.type = 2;
           [self.navigationController pushViewController:scan  animated:YES];
            self.saomiao=YES;
           
        } else if(indexPath.row==1){
        
            MyPhoneNumberViewController *myPhoneVC=[[[MyPhoneNumberViewController alloc]initWithNibName:@"MyPhoneNumberViewController" bundle:nil] autorelease];
    
            [self.navigationController pushViewController:myPhoneVC animated:YES];
            self.navigationController.navigationBarHidden=YES;
        
        }
        else if (indexPath.row == 2) {
            MySizeVC *mysizevc = [[[MySizeVC alloc] initWithNibName:@"MySizeVC" bundle:nil] autorelease];
            [self.navigationController pushViewController:mysizevc animated:YES];
        } else if (indexPath.row == 3) {
            
            BrandViewController *brand = [[[BrandViewController alloc] initWithNibName:@"BrandViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:brand animated:YES];
            self.navigationController.navigationBarHidden = YES;
        }else if (indexPath.row == 4){
        
            AddressManageViewController  *addressManageVC = [[[AddressManageViewController alloc ]initWithNibName:@"AddressManageViewController" bundle:nil] autorelease];
            
            [self.navigationController pushViewController:addressManageVC animated:YES];
                    
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadgps" object:nil];
            
        }
    }
    
    if (indexPath.section == 2) {

        if (indexPath.row == 0) {
            if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
                [self.view makeToast:@"已经授权"];
            } else {
             [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:[ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleModal viewDelegate:nil authManagerViewDelegate:nil] result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                    if (result)
                        {
                            [tableView reloadData];
                        }else {
                            [self.view makeToast:@"授权失败，请重新授权"];
                        }
                }];
            }
        }  else {
            
            if ([ShareSDK hasAuthorizedWithType:ShareTypeTencentWeibo]) {
                [self.view makeToast:@"已经授权"];
            } else {
                [ShareSDK getUserInfoWithType:ShareTypeTencentWeibo authOptions:[ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleModal viewDelegate:nil authManagerViewDelegate:nil] result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                    if (result)
                    {
                        [tableView reloadData];
                    }else {
                        [self.view makeToast:@"授权失败，请重新授权"];
                    }
                }];
            }
        }
    }
}


- (void)alertModel
{
    CustomAlertView *alert = [[[CustomAlertView alloc] initWithTitle:nil
                                                             message:@"敬请期待"
                                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消", nil] autorelease];
    [alert show];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


@end
