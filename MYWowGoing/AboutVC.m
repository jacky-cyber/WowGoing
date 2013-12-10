//
//  AboutVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-12.
//
//

#import "AboutVC.h"
#import "WTVC.h"
#import "JFVC.h"
#import "UserGuiderViewController.h"
#import "MobClick.h"
#import "UMFeedbackViewController.h"
#import "AppDelegate.h"
#import "AboutCell.h"
#import "SMVC.h"
@interface AboutVC ()

@end
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"nav_bar_bg@2x.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
@implementation AboutVC
@synthesize items;
@synthesize umFeedback = _umFeedback;

- (void)dealloc {
    [items release];
    [_myTextView release];
    [_vLabel release];
    [super dealloc];
}

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
    [UMFeedback setLogEnabled:YES];
    _umFeedback = [UMFeedback sharedInstance];
    [_umFeedback setAppkey:UMENG_APPKEY delegate:self];
    
    
    [super viewDidLoad];
    self.title = @"关于购引";

    NSString *versionString = APP_VERSION;
    _vLabel.text = [NSString stringWithFormat:@"购引 v%@", versionString];
    self.myTextView.text = [NSString stringWithFormat:@"        购引（WowGoing）是一款全新模式的手机逛街购物APP！线上所有商品都来自您身边的商场和专卖店，并保证价格低于店柜，给您最真实的商品信息和专享购物折扣！\n        您可以通过手机客户端预订或购买，并在限定时间内到商场店柜试穿、取货，退换随心。无忧正品保障，享受与正价商品同等的售后服务，免除所有后顾之忧！！\n\n购引v%@ For iPhone\n网址：www.wowgoing.com\n客服电话：029-88318395\n\n公众微信：购引西安站         购引石家庄站\n微博：购引-西安站 \n\n                               @2013 WowGoing.com", versionString];

    NSArray *stringArray = [[NSArray alloc] initWithObjects:@"常见问题",@"功能介绍",@"积分规则",@"意见反馈",@"二维码下载", nil];
    self.items  = stringArray;
    [stringArray release];
    self.myTableview.backgroundView = [[[UIView alloc]init] autorelease];
    self.myTableview.backgroundColor = [UIColor clearColor];
    self.myTableview.showsHorizontalScrollIndicator = false;
    self.myTableview.showsVerticalScrollIndicator = false;
    
}

- (void)viewDidUnload
{
    [self setMyTextView:nil];
    [self setVLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCell = @"customCell";
	AboutCell *cell = (AboutCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
	
	if (cell == nil) {
		//如果没有可重用的单元，我们就从nib里面加载一个，
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AboutCell"
													 owner:self options:nil];
		//迭代nib重的所有对象来查找NewCell类的一个实例
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[AboutCell class]]) {
				cell = (AboutCell *)oneObject;
			}
		}
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]] autorelease];
        imageView.frame = CGRectMake(0, 0, imageView.frame.size.width/2, imageView.frame.size.height/2);
        UIView *view  = [[[UIView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)] autorelease];
        [view addSubview:imageView];
        cell.accessoryView = view;
	}
    
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    // Step 1: Check to see if we can reuse a cell from a row that has just rolled off the screen
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    // Step 2: If there are no cells to reuse, create a new one
//    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    
//    
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    
//    
//    cell.textLabel.text = [items objectAtIndex:indexPath.row];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            //App评分代码***
        {
            WTVC *wtvc = [[[WTVC alloc]initWithNibName:@"WTVC" bundle:nil] autorelease];
            [self.navigationController pushViewController:wtvc animated:YES];
            break;
//            NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=608833789";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1:
        {
            UserGuiderViewController *ugvc = [[[UserGuiderViewController alloc]initWithNibName:@"UserGuiderViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:ugvc animated:YES];
            
            break;
        }
        case 2:{
            JFVC *jfvc = [[[JFVC alloc]initWithNibName:@"JFVC" bundle:nil] autorelease];
            [self.navigationController pushViewController:jfvc animated:YES];
            break;
        }
        case 3:{
            
            [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
            break;
        }
            
        case 4:{
            SMVC *sm = [[[SMVC alloc] initWithNibName:nil bundle:nil] autorelease];
            [self.navigationController pushViewController:sm animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil] autorelease];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:feedbackViewController] autorelease];
    [self presentModalViewController:navigationController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
