//
//  SizeWebVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-13.
//
//

#import "SizeWebVC.h"
#import "Api.h"
#import "MBProgressHUD.h"
@interface SizeWebVC ()

@end

@implementation SizeWebVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *addMember = [UIButton buttonWithType:UIButtonTypeCustom];
        [addMember setFrame:CGRectMake(10, 6, 52, 32)];;
        [addMember addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [addMember setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem1 = [[UIBarButtonItem alloc] initWithCustomView:addMember];
        self.navigationItem.leftBarButtonItem = litem1;
        [litem1 release];
        self.title = @"尺码";
    }
    return self;
}
- (IBAction)back:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@ %@ %@",_brandidString,  _styleTypeIdString, _genderString);
    NSString *urlString = [NSString stringWithFormat:@"%@/sizes/?brandId=%@&styleTypeId=%@&gender=%@",WX_SEVERURL,_brandidString,_styleTypeIdString,_genderString];
    NSURL* url = [NSURL URLWithString:urlString ];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    _sizeWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _sizeWebView.delegate = self;
    _sizeWebView.autoresizesSubviews = NO; //自动调整大小
    _sizeWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [_sizeWebView loadRequest:request];//加载
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_sizeWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSizeWebView:nil];
    [super viewDidUnload];
}
@end
