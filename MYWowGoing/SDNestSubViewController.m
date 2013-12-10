//
//  SDNestSubViewController.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-13.
//
//

#import "SDNestSubViewController.h"
#define COLUMN 4

@interface SDNestSubViewController ()

@end

@implementation SDNestSubViewController

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
   
    int total = self.subCates.count;
#define ROWHEIHT 35
    int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    
    for (int i=0; i<total; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        NSDictionary *data = [self.subCates objectAtIndex:i];
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(57 +65*column, ROWHEIHT*row, 65, ROWHEIHT)] autorelease];
        view.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 5, 45, 25);
        btn.tag = i;
        [btn addTarget:self.hotCateVC
                action:@selector(subCateBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[data objectForKey:@"styleTypeName"] forState:UIControlStateNormal];
        [view addSubview:btn];
        
        [self.view addSubview:view];
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = ROWHEIHT * rows ;
    self.view.frame = viewFrame;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
