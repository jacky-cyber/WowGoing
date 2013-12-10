//
//  SubHotCategorViewController.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-3.
//
//

#import "SubHotCategorViewController.h"
#define COLUMN 4

@interface SubHotCategorViewController ()

@end

@implementation SubHotCategorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-  (void)dealloc{
    [_hotCateVC release];
    [_subCates release];
    [super dealloc];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    int total = self.subCates.count;
#define ROWHEIHT 30
    int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    for (int i=0; i<total; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        NSDictionary *data = [self.subCates objectAtIndex:i];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40 + 70*column, 5 + 30 * row, 70, 30);
        btn.tag = i;
        [btn addTarget:self.hotCateVC
                action:@selector(subCateBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[data objectForKey:@"SubName"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = ROWHEIHT * rows + 10 ;
    self.view.frame = viewFrame;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
