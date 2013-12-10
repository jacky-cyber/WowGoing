//
//  JFVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-12.
//
//
    
#import "JFVC.h"
#import "JifenBS.h"
#import "JSON.h"

@interface JFVC ()

@end

@implementation JFVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        返回按钮
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
        UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = litem;
        [backBtn release];
        [litem release];
        
        UIImageView  *titbackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
        titbackImageview.image = [UIImage imageNamed:@"top_bar.png"];
        [self.view addSubview:titbackImageview];
        [titbackImageview release];
    }
    return self;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"积分规则";
    [self takeJifen];
}

-(void)takeJifen{
    JifenBS *jifenbs=[[[JifenBS alloc]init] autorelease];
    jifenbs.delegate=self;
    jifenbs.onSuccessSeletor=@selector(takeJifenSuccess:);
    jifenbs.onFaultSeletor=@selector(takeJifenFault:);
    [jifenbs asyncExecute];
   
}

-(void)takeJifenSuccess:(ASIHTTPRequest*)request{
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        return;
    }
//    NSLog(@"dic====",dic);
    self.jiFenTextView.text=[[dic objectForKey:@"Credits"] objectForKey:@"creditText"];
}

- (void)viewDidUnload
{
    [self setJiFenTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_jiFenTextView release];
    [super dealloc];
}
@end
