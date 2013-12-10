//
//  CancelReasonViewController.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-5.
//
//

#import "CancelReasonViewController.h"
#import "EvaluateBS.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface CancelReasonViewController ()<UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *productImageView;

@property (retain, nonatomic) IBOutlet UILabel *productNameLable;
@property (retain, nonatomic) IBOutlet UILabel *colorSizeDiscountLable;
@property (retain, nonatomic) IBOutlet UILabel *discountPrice;

@property (retain, nonatomic) IBOutlet UITextView *inPutTextView;
@property (retain, nonatomic) IBOutlet UIView *backView;

@end

@implementation CancelReasonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.productDic = [NSMutableDictionary dictionary] ;
    }
    return self;
}

- (IBAction)cancleBut:(id)sender {
    [self.delegate cancleReasonProtocolMethed];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)whetherToTheShopOfYes:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    
    UIButton  *butNo = (UIButton*)[self.view viewWithTag:button.tag + 1];
    if (button.selected) {
        [self.productDic  setValue:@"1" forKey:@"IsToShop"];
        butNo.selected = NO;
    }else{
        butNo.selected = YES;
         [self.productDic  setValue:@"0" forKey:@"IsToShop"];
    }


}
- (IBAction)whetherToTheShopOfNo:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    
    UIButton  *butYes = (UIButton*)[self.view viewWithTag:button.tag - 1];
    if (button.selected) {
         [self.productDic  setValue:@"0" forKey:@"IsToShop"];
        butYes.selected = NO;
    }else{
        butYes.selected = YES;
         [self.productDic  setValue:@"1" forKey:@"IsToShop"];
    }
}

- (IBAction)cancleReasonForMistake:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    if (button.selected) {
         [self.productDic  setValue:@"1" forKey:@"wrong"];
    }else{
        [self.productDic  setValue:@"0" forKey:@"wrong"];
    }

}

- (IBAction)cancleReasonForProductOutOfStock:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self.productDic  setValue:@"1" forKey:@"noStock"];
    }else{
        [self.productDic  setValue:@"0" forKey:@"noStock"];
    }
}

- (IBAction)cancleReasonForInappropriateSize:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.productDic  setValue:@"1" forKey:@"noSize"];
    }else{
        [self.productDic  setValue:@"0" forKey:@"noSize"];
    }

}
- (IBAction)cancleReasonForNotLike:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self.productDic  setValue:@"1" forKey:@"noLike"];
    }else{
        [self.productDic  setValue:@"0" forKey:@"noLike"];
    }

}

- (IBAction)cancleReasonForBadAttitude:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.productDic  setValue:@"1" forKey:@"noGood"];
    }else{
        [self.productDic  setValue:@"0" forKey:@"noGood"];
    }

}

- (IBAction)commitAction:(id)sender {
    
    [self.productDic setValue:self.inPutTextView.text forKey:@"content"];

    EvaluateBS *evaluateBS= [[[EvaluateBS alloc ]init] autorelease];
    evaluateBS.delegate  = self;
    evaluateBS.evaluateType = 3;
    evaluateBS.evaluateDic =self.productDic ;
    evaluateBS.onSuccessSeletor = @selector(commitActionFinished:);
    evaluateBS.onFaultSeletor = @selector(commitActionFailed:);
    [evaluateBS asyncExecute];
}

    
- (void) commitActionFinished:(ASIFormDataRequest*)request{
    
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
    
//    BOOL resultStatus = [[dic objectForKey:@"successStatus"] boolValue];
//    if (!resultStatus)
//    {
//        return;
//    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        [self.view makeToast:NETWORK_STRING];
        return;
    }
    
    [self.view makeToast:@"您的评价已完成" duration:0.5 position:@"center" title:nil];

    [self.delegate  cancleReasonProtocolMethed];
    
    [self dismissModalViewControllerAnimated:YES];
    
    
    
}
- (void) commitActionFailed:(ASIFormDataRequest*)request{
    
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
    
    [self.view makeToast:@"您的评价未完成"  duration:0.5 position:@"center" title:nil];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!iPhone5) {
        self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
    }
    

    [self.productImageView setImageWithURL:[NSURL URLWithString:[self.productDic objectForKey:@"picUrl"]] placeholderImage:nil];
    self.productNameLable.text = [self.productDic objectForKey:@"productName"];
    
    NSString *sizeString=[self.productDic objectForKey:@"strsize"];//尺寸
    NSString *colorString=[self.productDic objectForKey:@"color"];//颜色
    NSString *discountString=[self.productDic objectForKey:@"discount"];//折扣
    self.colorSizeDiscountLable.text=[NSString stringWithFormat:@"%@/%@码/%@折",colorString,sizeString,discountString];

    self.discountPrice.text=[NSString  stringWithFormat:@"￥%@",[self.productDic objectForKey:@"discountPrice"]];

}

- (void)textViewDidBeginEditing:(UITextView *)textView{
   
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, -180, 320, self.view.frame.size.height);
    }];

}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 20, 320, self.view.frame.size.height);
        [self.inPutTextView resignFirstResponder];
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_productImageView release];
    [_productNameLable release];
    [_colorSizeDiscountLable release];
    [_discountPrice release];
    [_inPutTextView release];
    
    [_productDic  release];
    [_backView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProductImageView:nil];
    [self setProductNameLable:nil];
    [self setColorSizeDiscountLable:nil];
    [self setDiscountPrice:nil];
    [self setInPutTextView:nil];
    [self setBackView:nil];
    [super viewDidUnload];
}
@end
