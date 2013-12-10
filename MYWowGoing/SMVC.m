//
//  SMVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-23.
//
//

#import "SMVC.h"

@interface SMVC ()

@end

@implementation SMVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        返回按钮
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = litem;
        [backBtn release];
        [litem release];
    }
    return self;
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _smScrollView.contentSize = CGSizeMake(_smScrollView.frame.size.width, 600);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_smScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSmScrollView:nil];
    [super viewDidUnload];
}
@end
