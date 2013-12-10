//
//  HistoryVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-2-22.
//
//

#import "HistoryVC.h"

#import "UIImageView+WebCache.h"
#import "HistoryVC.h"
 

#import "HistoryListBS.h"
#import "NewProductCell.h"
#import "MyCustomNavigationBar.h"
@interface HistoryVC ()

@end

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"nav_bar_bg@2x.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation HistoryVC

- (void)dealloc {
    [_proDetailView release];
    [_historyArray release];
    [_myTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 52, 32)];
		[backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_点击.png"] forState:UIControlStateHighlighted];
		UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		self.navigationItem.leftBarButtonItem = litem;
		[backBtn release];
		[litem release];
        self.historyArray = [NSMutableArray array];
    }
    return self;
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
//    [self.navigationController.navigationBar.backItem setTitle:@"返回"];
//    [self.navigationController.navigationBar.backItem setBackBarButtonItem:uibar]
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  

    self.title = @"浏览记录";
    HistoryListBS *hisbs = [[[HistoryListBS alloc] init] autorelease];
    hisbs.delegate = self;
    hisbs.onSuccessSeletor = @selector(historeSucess:);
    hisbs.onFaultSeletor = @selector(historyFault:);
    [hisbs asyncExecute];
//    [self showLoadingView];
    [MBProgressHUD  showHUDAddedTo:self.view  animated:YES];

    // Do any additional setup after loading the view from its nib.
}


- (void)historeSucess:(ASIFormDataRequest *)requestFrom {
    
    [MBProgressHUD  hideHUDForView:self.view  animated:YES];
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        dic= [NSJSONSerialization JSONObjectWithData:requestFrom.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        NSString *jsonString = [requestFrom responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    self.historyArray = [dic objectForKey:@"scanList"];
    if (self.historyArray.count == 0) {
         [self.view makeToast:@"暂无浏览记录" duration:0.5 position:@"center" title:nil];
    }
    if (self.historyArray == nil || ![self.historyArray isKindOfClass:[NSMutableArray class]]) {
          [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
    }
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200 ) {
        
        return;
    }
    [self.myTableView reloadData];
}
- (void)historyFault:(ASIFormDataRequest *)requestFrom {
    [MBProgressHUD  hideHUDForView:self.view  animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyArray count ]/2 +[self.historyArray count ]%2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 156;
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *adTableIdentifier = @"NewProductCell";
    NewProductCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            adTableIdentifier];
    
    if (cell == nil) {
        //如果没有可重用的单元，我们就从nib里面加载一个，
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewProductCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[NewProductCell class]]) {
                cell = (NewProductCell *)oneObject;
            }
        }
    }
    
    NSDictionary *proDic=[self.historyArray objectAtIndex:indexPath.row*2];
    NSDictionary *proDic2=nil;
    if ((indexPath.row*2+1) <[self.historyArray count]) {
        proDic2 = [self.historyArray objectAtIndex:indexPath.row*2+1];
        
    }
    
    if (proDic2 == nil) {
        [cell.productImageRight setHidden: YES];
        [cell.img1 setHidden:YES];
        [cell.productPriceRight  setHidden:YES];
        [cell.img_money2 setHidden:YES];
        [cell.discountRight setHidden:YES];
        [cell.discountPriceRight setHidden:YES];
        [cell.img_touming setHidden:YES];
        [cell.btn_Right setHidden:YES];
        [cell.brandLogoRight setHidden:YES];
        @autoreleasepool {
            [cell.productImageLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"水印-大图.png"]];
            cell.productImageLeft.tag = BRAND_PRO;
            
            [cell.brandLogoLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"brandLogo"]] placeholderImage:nil];

            cell.productPriceLeft.text = [NSString stringWithFormat:@"￥%d",[[proDic  objectForKey:@"discountPrice"]intValue]];
            
            cell.discountPriceLeft.backgroundColor = [UIColor clearColor];
            cell.discountPriceLeft.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
            cell.discountPriceLeft.strikeThroughEnabled=YES;
            cell.discountPriceLeft.font = [UIFont systemFontOfSize:12];
            cell.discountPriceLeft.text=[NSString stringWithFormat:@"￥%@",[proDic objectForKey:@"price"]];
            
            cell.discountLeft.text=[NSString stringWithFormat:@"%@折",[proDic objectForKey:@"discount"]];
            cell.label_productName.text=[proDic objectForKey:@"productName"];
            [cell.btn_Left addTarget:self action:@selector(productDetaiAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Left.data=[NSMutableDictionary dictionaryWithDictionary:proDic];
        }
        
    }else{
        [cell.productImageRight setHidden: NO];
        [cell.img1 setHidden:NO];
        [cell.productPriceRight  setHidden:NO];
        [cell.img_money2 setHidden:NO];
        [cell.discountRight setHidden:NO];
        [cell.discountPriceRight setHidden:NO];
        [cell.img_touming setHidden:NO];
        [cell.btn_Right setHidden:NO];
        [cell.brandLogoRight setHidden:NO];
        @autoreleasepool {
            [cell.productImageLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"水印-大图.png"]];
            cell.productImageLeft.tag = BRAND_PRO;
            
            [cell.brandLogoLeft setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"brandLogo"]] placeholderImage:nil];
               cell.productPriceLeft.text = [NSString stringWithFormat:@"￥%d",[[proDic  objectForKey:@"discountPrice"]intValue]];
            
            cell.discountPriceLeft.backgroundColor = [UIColor clearColor];
            cell.discountPriceLeft.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
            cell.discountPriceLeft.strikeThroughEnabled=YES;
            cell.discountPriceLeft.font = [UIFont systemFontOfSize:12];
            cell.discountPriceLeft.text=[NSString stringWithFormat:@"￥%@",[proDic objectForKey:@"price"]];
            
            cell.discountLeft.text=[NSString stringWithFormat:@"%@折",[proDic objectForKey:@"discount"]];
            cell.label_productName.text=[proDic objectForKey:@"productName"];
            [cell.btn_Left addTarget:self action:@selector(productDetaiAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Left.data=[NSMutableDictionary dictionaryWithDictionary:proDic];
            
            
            [cell.productImageRight setImageWithURL:[NSURL URLWithString:[proDic2 objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"水印-大图.png"]];
            cell.productImageRight.tag = BRAND_PRO;
            
            [cell.brandLogoRight setImageWithURL:[NSURL URLWithString:[proDic2 objectForKey:@"brandLogo"]] placeholderImage:nil];
            
            cell.productPriceRight.text = [NSString stringWithFormat:@"￥%d",[[proDic2  objectForKey:@"discountPrice"]intValue]];
            
            cell.discountPriceRight.backgroundColor = [UIColor clearColor];
            cell.discountPriceRight.textColor =  [UIColor colorWithRed:139.0/255.0  green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
            cell.discountPriceRight.strikeThroughEnabled=YES;
            cell.discountPriceRight.font = [UIFont systemFontOfSize:12];
            cell.discountPriceRight.text=[NSString stringWithFormat:@"￥%@",[proDic2 objectForKey:@"price"]];
            
            cell.discountRight.text=[NSString stringWithFormat:@"%@折",[proDic2 objectForKey:@"discount"]];
            NSLog(@"折扣：%@",[NSString stringWithFormat:@"%@折",[proDic2 objectForKey:@"discount"]]);
            cell.label_productName.text=[proDic2 objectForKey:@"productName"];
            [cell.btn_Right addTarget:self action:@selector(productDetaiAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Right.data=[NSMutableDictionary dictionaryWithDictionary:proDic2];
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)closeSizeViewAction:(id)sender {
    self.myTableView.userInteractionEnabled = YES;
}
-(void)closeSizeAction
{
    self.myTableView.userInteractionEnabled = YES;
}
-(void)pushCounterVC:(NSDictionary *)dic{
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int stockid = [[[self.historyArray objectAtIndex:row] objectForKey:@"stock"] intValue];
    if (stockid == 0) {
//        [self showToastMessageAtCenter:@"该产品已售罄"];
        return;
    }
   
    int activityId = [[[self.historyArray objectAtIndex:row] objectForKey:@"activityId"] intValue];
    int productId = [[[self.historyArray objectAtIndex:row] objectForKey:@"productId"] intValue];
    ProductDetailViewController_Detail2 *proDetailView = [[[ProductDetailViewController_Detail2 alloc] initWithNibName:@"ProductDetailViewController_Detail2" bundle:nil] autorelease];
    NSMutableDictionary *proDic = [self.historyArray objectAtIndex:indexPath.row];
    proDetailView.prductDetailDic = proDic;
    proDetailView.activityId = activityId;
    proDetailView.productId = productId;
    [self.navigationController pushViewController:proDetailView animated:NO];
}

#pragma mark  ********产品详情*********
-(void)productDetaiAction:(UIDataButton*)sender{
    
    ProductDetailViewController_Detail2 *productDetail = [[[ProductDetailViewController_Detail2 alloc] initWithNibName:@"ProductDetailViewController_Detail2" bundle:nil] autorelease];

    productDetail.productId=[[sender.data objectForKey:@"productId"] intValue];
    productDetail.activityId=[[sender.data objectForKey:@"activityId"] intValue];
    productDetail.prductDetailDic=sender.data;
    [self.navigationController pushViewController:productDetail animated:NO];
//    [_topImage setHidden:YES];
    
}

@end
