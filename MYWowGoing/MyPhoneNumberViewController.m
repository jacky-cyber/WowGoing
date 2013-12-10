//
//  MyPhoneNumberViewController.m
//  MYWowGoing
//
//  Created by zhangM on 13-4-22.
//
//

#import "MyPhoneNumberViewController.h"
 
 
#import "JSON.h"

@interface MyPhoneNumberViewController ()
@property (retain, nonatomic) IBOutlet UITextField *phoneNumberField;

@end

@implementation MyPhoneNumberViewController

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
- (IBAction)commitAction:(id)sender {
   
    if (![self.phoneNumberField.text isEqualToString:self.phoneString]) {
              if (![Util checkPhoneNumber:self.phoneNumberField.text]) {
                  [self.view makeToast:@"请您输入正确的电话号码" duration:0.5 position:@"center" title:nil];
                  return;
        }else{
             [self.phoneNumberField resignFirstResponder];
            [self saveUserPhoneNumber:self.phoneNumberField.text];
        }
    }else{
         [Util saveUserPhoneNumber:self.phoneNumberField.text];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.phoneNumberField.text=[Util takePhoneNumber];
    [self.phoneNumberField becomeFirstResponder];
    self.phoneNumberField.keyboardType=UIKeyboardTypeNumberPad;

}

#pragma mark
#pragma mark  保存录入电话
-(void)saveUserPhoneNumber:(NSString*)phoneNumber{ //向后台存放用户录入的电话号码
    
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
    requestForm.delegate=self;
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];//  发送同步请求
    
   }

- (void)requestFinished:(ASIHTTPRequest *)request{

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
    
    if (responseStatus!=200) {
        [self.view makeToast:@"保存电话失败" duration:0.5 position:@"center" title:nil];
    }else{
    
        [Util saveUserPhoneNumber:self.phoneNumberField.text];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_phoneNumberField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPhoneNumberField:nil];
    [super viewDidUnload];
}
@end
