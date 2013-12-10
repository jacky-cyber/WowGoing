//
//  EvaluationViewController.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-5.
//
//

#import "EvaluationViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "EvaluateBS.h"

@interface EvaluationViewController ()<UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *productImageView;
@property (retain, nonatomic) IBOutlet UILabel *productNameLable;
@property (retain, nonatomic) IBOutlet UILabel *colorSizeDiscountLable;
@property (retain, nonatomic) IBOutlet UILabel *discountPriceLable;
@property (retain, nonatomic) IBOutlet UITextView *evaluationTextView;

@property (retain,nonatomic) NSMutableDictionary  *evaluationDic;

@end

@implementation EvaluationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 6, 52, 32)];
		[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
  		UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		self.navigationItem.leftBarButtonItem = litem;
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn setFrame:CGRectMake(10, 6, 52, 32)];
		[commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn setBackgroundImage:[UIImage imageNamed:@"提交.png"] forState:UIControlStateNormal];
  		UIBarButtonItem *litem2 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
		self.navigationItem.rightBarButtonItem = litem2;
        
		[litem release];
        [litem2 release];
        
        self.title = @"评价";
  
        self.productDic = [NSMutableDictionary dictionary];
        self.evaluationDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) backAction:(UIButton*)sender{
   
    [self.navigationController popViewControllerAnimated:YES];
    

}

- (void)commitAction:(UIButton*)sender{
    
    
    [self.evaluationDic setValue:self.evaluationTextView.text forKey:@"content"];
       
    EvaluateBS *evaluateBS= [[[EvaluateBS alloc ]init] autorelease];
    evaluateBS.delegate  = self;
    evaluateBS.evaluateType = 1;
    evaluateBS.evaluateDic =self.evaluationDic;
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
        [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
        return;
    }

    
     [self.view makeToast:@"您的评价已完成" duration:0.5 position:@"center" title:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
      


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
    
    
     [self.view makeToast:@"您的评价未完成" duration:0.5 position:@"center" title:nil];

}

- (IBAction)attitudeBut1:(id)sender {
    UIButton *but = (UIButton*)sender;
    if (but.selected) {
        for (int i = but.tag + 1 ; i < but.tag +5  ; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = NO;
        }
    }else{
        but.selected = YES;
    }
    
    [self.evaluationDic setValue:@"1" forKey:@"serveGrade"];
}

- (IBAction)attitudeBut2:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    if (!but.selected) {
        for (int i = but.tag + 1 ; i < but.tag +4  ; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = NO;
        }
    }else{
        for (int i = 50 ; i <= but.tag; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = YES;
        }
    }
    
    [self.evaluationDic setValue:@"2" forKey:@"serveGrade"];

}
- (IBAction)attitudeBut3:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    if (!but.selected) {
        for (int i = but.tag + 1 ; i < but.tag +3  ; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = NO;
        }
    }else{
        for (int i = 50 ; i <= but.tag  ; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = YES;
        }
    }
    
    [self.evaluationDic setValue:@"3" forKey:@"serveGrade"];
}

- (IBAction)attitudeBut4:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    if (!but.selected) {
        for (int i = but.tag + 1 ; i < but.tag + 2  ; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = NO;
        }
    }else{
        for (int i = 50 ; i <= but.tag  ; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = YES;
        }
    }
    
    [self.evaluationDic setValue:@"4" forKey:@"serveGrade"];

}

- (IBAction)attitudeBut5:(id)sender {
    UIButton *but = (UIButton*)sender;
    if (but.selected) {
        but.selected = NO;
    }else{
        for (int i = 50 ; i <= but.tag  ; i ++) {
            UIButton *button =(UIButton*) [self.view viewWithTag:i];
            button.selected = YES;
        }
    }
    
    [self.evaluationDic setValue:@"5" forKey:@"serveGrade"];
}

- (IBAction)makeAnAppointmentButYes:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    UIButton  *butNo = (UIButton*)[self.view viewWithTag:button.tag + 1];
    if (button.selected) {
        butNo.selected = NO;
        [self.evaluationDic setValue:@"1" forKey:@"isCall"];
    }else{
       butNo.selected = YES;
         [self.evaluationDic setValue:@"0" forKey:@"isCall"];
    }
}

- (IBAction)makeAnAppointmentButNo:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    UIButton  *butYes = (UIButton*)[self.view viewWithTag:button.tag - 1];
    if (button.selected) {
        butYes.selected = NO;
        [self.evaluationDic setValue:@"0" forKey:@"isCall"];
    }else{
        butYes.selected = YES;
        [self.evaluationDic setValue:@"1" forKey:@"isCall"];
    }

}
- (IBAction)recommendButYes:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    UIButton  *butNo = (UIButton*)[self.view viewWithTag:button.tag + 1];
    if (button.selected) {
         [self.evaluationDic setValue:@"1" forKey:@"isRecom"];
        butNo.selected = NO;
    }else{
        butNo.selected = YES;
        [self.evaluationDic setValue:@"0" forKey:@"isRecom"];

    }

}
- (IBAction)recommendButNo:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    UIButton  *butYes = (UIButton*)[self.view viewWithTag:button.tag - 1];
    if (button.selected) {
        [self.evaluationDic setValue:@"0" forKey:@"isRecom"];
        butYes.selected = NO;
    }else{
        butYes.selected = YES;
        [self.evaluationDic setValue:@"1" forKey:@"isRecom"];

    }


}
- (IBAction)extraConsumptionButYes:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    UIButton  *butNo = (UIButton*)[self.view viewWithTag:button.tag + 1];
    if (button.selected) {
        [self.evaluationDic setValue:@"1" forKey:@"isOther"];

        butNo.selected = NO;
    }else{
        butNo.selected = YES;
         [self.evaluationDic setValue:@"0" forKey:@"isOther"];
    }
}
- (IBAction)extraConsumptionButNo:(id)sender {
    UIButton  *button = (UIButton*) sender;
    button.selected = !button.selected;
    UIButton  *butYes = (UIButton*)[self.view viewWithTag:button.tag - 1];
    if (button.selected) {
        butYes.selected = NO;
         [self.evaluationDic setValue:@"0" forKey:@"isOther"];
    }else{
        butYes.selected = YES;
         [self.evaluationDic setValue:@"1" forKey:@"isOther"];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.productImageView setImageWithURL:[NSURL URLWithString:[self.productDic objectForKey:@"picUrl"]] placeholderImage:nil];
    self.productNameLable.text = [self.productDic objectForKey:@"productName"];
    NSString *colorStr = [self.productDic objectForKey:@"color"];
    NSString  *sizeStr = [self.productDic objectForKey:@"strsize"];
    NSString *discountStr = [self.productDic objectForKey:@"discount"];
    self.colorSizeDiscountLable.text = [NSString stringWithFormat:@"%@/%@/%@折",colorStr,sizeStr,discountStr];
    self.discountPriceLable.text = [NSString stringWithFormat:@"￥%@",[self.productDic objectForKey:@"discountPrice"]];
    
    [self.evaluationDic setValue:[self.productDic objectForKey:@"shopId"] forKey:@"shopId"];
    [self.evaluationDic setValue:[self.productDic objectForKey:@"orderId"] forKey:@"orderId"];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     [self.evaluationTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}


- (void) textViewDidBeginEditing:(UITextView *)textView{

    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, -20, 320, self.view.frame.size.height);
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_evaluationDic release];
    [_productDic release];
    _productDic = nil;
    [_productImageView release];
    [_productNameLable release];
    [_colorSizeDiscountLable release];
    [_discountPriceLable release];
    [_evaluationTextView release];
    [super dealloc];

}
- (void)viewDidUnload {
    [self setProductImageView:nil];
    [self setProductNameLable:nil];
    [self setColorSizeDiscountLable:nil];
    [self setDiscountPriceLable:nil];
    [self setEvaluationTextView:nil];
    [super viewDidUnload];
}
@end
