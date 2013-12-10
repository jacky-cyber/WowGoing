//
//  UserGuiderViewController.m
//  MYWowGoing
//
//  Created by YangJingchao on 13-7-4.
//
//

#import "UserGuiderViewController.h"

@interface UserGuiderViewController ()

@end

@implementation UserGuiderViewController
@synthesize myTextView;

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
        
        [self.navigationController setHidesBottomBarWhenPushed:YES];
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
    self.title = @"功能介绍";
    NSString *versionString = APP_VERSION;
    self.myTextView.text = [NSString stringWithFormat:@"        购引是一款全新模式的手机逛街购物APP！线上所有商品都来自您身边的商场和专卖店，并且价格低于店柜，给您最新的商品信息和专享购物折扣。！\n        您可以通过手机客户端免费预订，并在限定时间内到商场店柜试穿、支付、取货，退换随心。无忧正品保障，享受与正价商品同等的售后服务，免除所有后顾之忧！\n\n\n网址：www.wowgoing.com\n客服电话：029-88318395  18691550014\n\n公众微信:gouyinxiaomishu\n工作时间：周一至周六9:00-22:00，法定节假日除外 \n\n                               @2013 WowGoing.com", versionString];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMyTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    
    [super dealloc];
}
@end
