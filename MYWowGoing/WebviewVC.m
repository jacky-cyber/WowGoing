//
//  WebviewVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-2-20.
//
//

#import "WebviewVC.h"
@interface WebviewVC ()

@end


@implementation WebviewVC

@synthesize urlString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(10, 6, 52, 32)];;
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        
        self.title = @"网页支付";
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc ]initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = item;
        [item  release];
    
    }
    return self;
}

- (void) backAction:(UIButton*)sender{

       [self.navigationController  popToRootViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    HUD.labelText=@"";
    self.webView.frame = CGRectMake(0, 0, 320,IPHONE_HEIGHT);
    [self.webView addSubview:HUD];
    self.webView.delegate=self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [HUD show:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [HUD setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
