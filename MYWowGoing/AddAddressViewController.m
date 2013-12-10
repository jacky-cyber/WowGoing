//
//  AddAddressViewController.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-9.
//
//

#import "AddAddressViewController.h"
#import "AddressBS.h"
#import "HZAreaPickerView.h"
#import "CoordinateReverseGeocoder.h"

@interface AddAddressViewController ()<UITextFieldDelegate,HZAreaPickerDelegate,UITextViewDelegate>
{

    NSArray *provinces, *cities, *areas;
    
}
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;

@property (retain, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (retain, nonatomic) IBOutlet UITextField *postalcodeTextField;
@property (retain, nonatomic) IBOutlet UITextField *areaTextField;
@property (retain, nonatomic) IBOutlet UITextView *detailAddress;

@property (retain,nonatomic) NSMutableDictionary  *addressDic;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

-(void)cancelLocatePicker;

@end

@implementation AddAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}


- (void) checkLoccityInArray:(NSString*)cityString{

    NSArray *provincesArray = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]] autorelease];
    
    int count = provincesArray.count;
    for (int i = 0; i< count; i++) {
        
        NSArray *cityArray = [[provincesArray objectAtIndex:i] objectForKey:@"cities"];
        
        int k = cityArray.count;
        
        for (int j = 0; j < k; j++) {
            NSString *string = [[cityArray objectAtIndex:j] objectForKey:@"city"];
            if ([cityString isEqualToString:string]) {
                               
                self.locatePicker = [[[HZAreaPickerView alloc] initWithdelegate:self  andProvincesindex:i andCityIndex:j] autorelease];
                [self.locatePicker showInView:self.view];

                break;
            }
        }
    }
}
    
    
- (IBAction)cancelAction:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)saveAdressAction:(id)sender {
    
    if (![Util checkPhoneNumber:self.phoneNumberTextField.text]) {
        [self.view makeToast:@"请您输入正确的电话号码" duration:0.5 position:nil title:nil];
        return;
    }
    
    if (self.nameTextField.text.length == 0 || self.detailAddress.text.length == 0 || self.areaTextField.text.length == 0 || self.postalcodeTextField.text == 0) {
         [self.view makeToast:@"请您把相关信息填写完整" duration:0.5 position:nil title:nil];
        return;
    }
    
        [self.addressDic setValue:self.nameTextField.text forKey:@"name"];
        [self.addressDic setValue:self.phoneNumberTextField.text forKey:@"phone"];
        [self.addressDic setValue:self.detailAddress.text forKey:@"address"];
        [self.addressDic setValue:self.areaTextField.text forKey:@"cityName"];
        [self.addressDic setValue:self.postalcodeTextField.text forKey:@"postCode"];
        
        [self requestData:1];
    
    }

- (void) saveAdressActionFinish:(ASIFormDataRequest*)request{
    
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
    
    BOOL resultStatus = [[dic objectForKey:@"isSuccess"]  boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
         [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
    
    
    if (request.tag == 1) {
        
        [self.view makeToast:@"您的地址信息录入已完成" duration:0.5 position:@"center" title:nil];
    
        [self.delegate postProtocolMethod];
        
        [self  dismissModalViewControllerAnimated:YES];
    }else{
    
        NSDictionary  *customDic = [dic objectForKey:@"customerInfor"];
        self.nameTextField.text = [customDic objectForKey:@"Name"];
        self.phoneNumberTextField.text = [customDic objectForKey:@"phone"];
        self.areaTextField.text = [customDic objectForKey:@"cityName"];
        self.detailAddress.text = [customDic objectForKey:@"address"];
        self.postalcodeTextField.text = [customDic objectForKey:@"postCode"];
    }
}
- (void) saveAdressActionFault:(ASIFormDataRequest*)request{
   
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
    
    BOOL resultStatus = [[dic objectForKey:@"successStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }
      [self.view makeToast:@"您的地址未录入完成" duration:0.5 position:@"center" title:nil];

}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self cancelLocatePicker];
    if ([textField isEqual:self.areaTextField]) {
        
        for (UIView *view in [self.view subviews]) {
            if ([view  isKindOfClass:[UITextField class]]  && [(UITextField*)view  isEditing]) {
                [view resignFirstResponder];
            }else{
                [self.detailAddress   resignFirstResponder];
                [UIView animateWithDuration:0.5 animations:^{
                    self.view.frame = CGRectMake(0, 20, self.view.frame.size.width,self.view.frame.size.height);
                }];
            }
        }
        
        NSString *city = [Util getBrowerCity];
        NSString *cityStr = [city substringWithRange:NSMakeRange(0,city.length - 1)];
        [self checkLoccityInArray:cityStr];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    [self cancelLocatePicker];
    [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptionCurveEaseInOut ) animations:^{
        self.view.frame = CGRectMake(0, -44, self.view.frame.size.width,self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSArray  *subViews = [self.view subviews];
    int count = subViews.count;
    for (int i = 0; i < count; i ++) {
        UIView  *view = [subViews objectAtIndex:i];
        if ([view  isKindOfClass:[UITextField class]]  && [(UITextField*)view  isEditing]) {
            [view resignFirstResponder];
        }else{
            [self.detailAddress   resignFirstResponder];
        }
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptionCurveEaseInOut ) animations:^{
        self.view.frame = CGRectMake(0, 20, self.view.frame.size.width,self.view.frame.size.height);
    } completion:^(BOOL finished) {}];
    
    [self cancelLocatePicker];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self requestData:0];
    self.addressDic = [NSMutableDictionary dictionary];
  
}

- (void) requestData:(int)type{

    AddressBS  *addressBS = [[[AddressBS alloc ]init] autorelease];
    addressBS.delegate = self;
     addressBS.type = type;
    if (type == 1) {
        addressBS.addressDic = self.addressDic;
    }

    [addressBS setOnSuccessSeletor:@selector(saveAdressActionFinish:)];
    [addressBS setOnFaultSeletor:@selector(saveAdressActionFault:)];
    
    [addressBS asyncExecute];

}


#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dealloc{

    [_addressDic release];
    [_nameTextField release];
    [_phoneNumberTextField release];
    [_postalcodeTextField release];
    [_areaTextField release];
    [_detailAddress release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
