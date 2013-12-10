//
//  ProductsVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-4-9.
//
//

#import "ProductsVC.h"
#import "XianShiCell.h"
@interface ProductsVC ()

@end

@implementation ProductsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)back:(id)sender {
    
}

- (IBAction)screeningProducts:(id)sender {//筛选
}

- (IBAction)allProducts:(id)sender { //全部
}

- (IBAction)productsForMan:(id)sender { //男装
}

- (IBAction)productsForWoman:(id)sender { //女装
}


- (IBAction)orderByPrice:(id)sender { //按价格排序
}
- (IBAction)orderByDiscount:(id)sender {  //按折扣排序

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify=@"Cell";
    XianShiCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[[XianShiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell prepareForReuse];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_productTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProductTable:nil];
    [super viewDidUnload];
}
@end
