//
//  ShopIntroduceVC.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-9.
//
//

#import "ShopIntroduceVC.h"
#import "ShopInfoDetailViewController.h"


#import "ShopITwoCell.h"
#import "ShopIThreeCell.h"
#import "ShopAddressListCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

 
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
 
#import "CustomAlertView.h"
#import "ShopInforVC.h"

@interface ShopIntroduceVC ()
@property(nonatomic,retain)UITableView   *tableview ;
@property(nonatomic,retain)UITableView   *siTableview;
@property(nonatomic,retain)UIImageView  *arrowsImageView;
@property(nonatomic,retain)NSMutableArray  *shopListArray;
@property(nonatomic,retain)NSString   *selectBrandID;
@end

@implementation ShopIntroduceVC
@synthesize siTableview = _siTableview;
@synthesize tableview= _tableview;
@synthesize arrowsImageView = _arrowsImageView;
@synthesize shopListArray =_shopListArray;
@synthesize selectBrandID = _selectBrandID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [_siTableview release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     _shopListArray = [NSMutableArray array];
    [self requestData];
    [self loadTableview];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
//    [_arrowsImageView removeFromSuperview];
//    [_tableview removeFromSuperview];
    [_siTableview setUserInteractionEnabled:YES];
    self.navigationController.navigationBarHidden = YES;
   
}

-(void)loadTableview
{
    _siTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 ,320, IPHONE_HEIGHT-133) style:UITableViewStylePlain];
    _siTableview.backgroundColor = [UIColor  clearColor];
    _siTableview.delegate = self;
    _siTableview.dataSource = self;
    _siTableview.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_siTableview];
}
- (IBAction)backAction:(id)sender {
    UITableView *tab=(UITableView*)[self.view viewWithTag:54342];
    if (tab!=nil) {
        [_tableview removeFromSuperview];
        [_arrowsImageView removeFromSuperview];
        [_siTableview setUserInteractionEnabled:YES];
        [_siTableview setContentOffset:CGPointMake(0, 0) animated:YES];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==54342) {
        
        return 44;
    }
  else
  {
      return 110;
  }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==54342) {
        
       return  _shopListArray.count;
    }
    else
    {
       return [Util getBrandShopArray].count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 54342) {
        self.navigationController.navigationBarHidden=YES;
         [self.tableview removeFromSuperview];
         [self.arrowsImageView removeFromSuperview];
         ShopAddressListCell *cell = (ShopAddressListCell*)[self.tableview cellForRowAtIndexPath:indexPath];
        cell.selectImageView.image = [UIImage imageNamed:@"对勾.png"];
        ShopInforVC   *shopInforVC = [[[ShopInforVC alloc] initWithNibName:@"ShopInforVC" bundle:nil] autorelease];
        
        shopInforVC.brandID = _selectBrandID;
        shopInforVC.shopId = [[_shopListArray objectAtIndex:indexPath.row] objectForKey:@"shopId"];
        shopInforVC.shopName=[[_shopListArray objectAtIndex:indexPath.row] objectForKey:@"shopName"];
        shopInforVC.type = 2;
        [self.navigationController pushViewController:shopInforVC animated:YES];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag ==54342) {
        
        static NSString *CellIdentifier = @"ShopAddressListCell";
        ShopAddressListCell *cell = (ShopAddressListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopAddressListCell" owner:self options:nil];
            cell = (ShopAddressListCell *)[nib objectAtIndex:0];
        }
        if (indexPath.row==0) {
            cell.backImageView.image = [UIImage imageNamed:@"logo店铺列表弹框_顶部阴影带色块(320_44).png"];
        }else
        {
            cell.backImageView.image = [UIImage imageNamed:@"logo店铺列表弹框_色块(1_44).png"];
        }
        
        
        cell.shopAddressLabel.text = [[_shopListArray objectAtIndex:indexPath.row] objectForKey:@"shopName"];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"ShopITwoCell";
        static NSString *CellIdentifier3 = @"ShopIThreeCell";
//        %2 !=  显示两个   
        if (indexPath.row%2 !=0) {
            ShopIThreeCell *cell = (ShopIThreeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            
            if (cell==nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopIThreeCell" owner:self options:nil];
                cell = (ShopIThreeCell *)[nib objectAtIndex:0];
            }
            return [self drawShopThreeCell:cell indexPath:indexPath];;
        }else
        {
            ShopITwoCell *cell = (ShopITwoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopITwoCell" owner:self options:nil];
                cell = (ShopITwoCell *)[nib objectAtIndex:0];
            }
            return [self drawShopTwoCell:cell indexPath:indexPath];
        }
    }
}
#pragma mark ----绘制2
-(UITableViewCell*)drawShopThreeCell:(ShopIThreeCell*)shopIThreeCell indexPath:(NSIndexPath*)indexPath
{
    ShopIThreeCell *cell = shopIThreeCell;
    [cell.leftSelectImageView setHidden:YES];
    [cell.leftNoselectView setHidden:YES];
    [cell.rightNoselectView setHidden:YES];
    [cell.rightSelectImageView setHidden:YES];
    
    NSString  *one=  [[[[Util getBrandShopArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"pictureurl"];
    NSString  *two=  [[[[Util getBrandShopArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"pictureurl"];
    
    int  left  = indexPath.row*100+0;
    cell.leftBtn.tag = left;
    
    if ([one isEqualToString:@""]|| one==nil) {
    }else{
        [cell.leftBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
        [cell.leftLogoImageView setImageWithURL:[NSURL URLWithString:one] placeholderImage:[UIImage imageNamed:@""]];
    }
    int right = indexPath.row*100+1;
    cell.rightBtn.tag = right;
    if ([two isEqualToString:@""]|| two==nil) {
    }else{
        [cell.rightBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightLogoImageView setImageWithURL:[NSURL URLWithString:two] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    return  cell;
}
#pragma mark----绘制3
-(UITableViewCell*)drawShopTwoCell:(ShopITwoCell*)shopItwoCell indexPath:(NSIndexPath*)indexPath
{
    ShopITwoCell *cell = shopItwoCell;
    
    [cell.leftNoSelectView setHidden:YES];
    [cell.leftSelectView setHidden:YES];
    [cell.midSelectView setHidden:YES];
    [cell.midNoDelectView setHidden:YES];
    [cell.rightNoselectView setHidden:YES];
    [cell.rightSelectView setHidden:YES];
    
    NSString *one=  [[[[Util getBrandShopArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"pictureurl"];
    NSString *two=  [[[[Util getBrandShopArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"pictureurl"];
    NSString *three=[[[[Util getBrandShopArray] objectAtIndex:indexPath.row] objectForKey:@"third"]objectForKey:@"pictureurl"];
    
    [cell.leftLogoImageView setImageWithURL:[NSURL URLWithString:one] placeholderImage:[UIImage imageNamed:@""]];
    [cell.midLogoImageView setImageWithURL:[NSURL URLWithString:two] placeholderImage:[UIImage imageNamed:@""]];
    [cell.rightLogoImageView setImageWithURL:[NSURL URLWithString:three] placeholderImage:[UIImage imageNamed:@""]];
    
    int left = indexPath.row*100+0;
    cell.leftBtn.tag = left;
    
    int mid = indexPath.row*100+1;
    cell.midBtn.tag = mid;
    
    int right = indexPath.row*100+2;
    cell.rightBtn.tag = right;
    if ([one isEqualToString:@""]|| one==nil) {
    }else{
        [cell.leftBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([two isEqualToString:@""]|| two==nil) {
    }else{
        [cell.rightBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([three isEqualToString:@""]|| three==nil) {
    }else{
        [cell.midBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return  cell;
}

-(void)showList:(id)sender
{
   
    UIButton   *btn = (UIButton*)sender;
    int   index=     btn.tag/100;
    
//    if (index==0) {
//
//    }else if(index==1)
//    {
//        [_siTableview setContentOffset:CGPointMake(0, 110) animated:YES];
//    }else if(index==2){
//       [_siTableview setContentOffset:CGPointMake(0, 220+5) animated:YES];
//    }else{
//       [_siTableview setContentOffset:CGPointMake(0, index*110+5) animated:YES];
//    }

    if (btn.tag%100==0) {
        _selectBrandID = [[[[Util getBrandShopArray] objectAtIndex:index] objectForKey:@"one"] objectForKey:@"brandid"];
        _shopListArray = [[[[Util getBrandShopArray] objectAtIndex:index] objectForKey:@"one"] objectForKey:@"shoplist"];
        _arrowsImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(80, 164, 9, 6)] autorelease];

    }else if(btn.tag%100==1)
    {
         _selectBrandID = [[[[Util getBrandShopArray] objectAtIndex:index] objectForKey:@"two"] objectForKey:@"brandid"];
        _shopListArray = [[[[Util getBrandShopArray] objectAtIndex:index] objectForKey:@"two"] objectForKey:@"shoplist"];
        _arrowsImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(180, 164, 9, 6)] autorelease];

    }
    else
    {
         _selectBrandID = [[[[Util getBrandShopArray] objectAtIndex:index] objectForKey:@"third"] objectForKey:@"brandid"];
        _shopListArray = [[[[Util getBrandShopArray] objectAtIndex:index] objectForKey:@"third"] objectForKey:@"shoplist"];
        _arrowsImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(240, 164, 9, 6)] autorelease];

    }
    
    
    ShopInfoDetailViewController *shopDetailVC = [[ShopInfoDetailViewController alloc ] initWithNibName:@"ShopInfoDetailViewController" bundle:nil];
    shopDetailVC.brandId = _selectBrandID;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
    
    self.navigationController.navigationBarHidden = NO;

//    _arrowsImageView.backgroundColor = [UIColor clearColor];
//    _arrowsImageView.image = [UIImage imageNamed:@"logo店铺列表弹框_箭头.png"];
//    
//    [self.view addSubview:_arrowsImageView];
//    
//    _tableview  = [[[UITableView alloc] initWithFrame:CGRectMake(0, 170, 320, IPHONE_HEIGHT-233) style:UITableViewStylePlain] autorelease];
//    _tableview.backgroundColor = [UIColor grayColor];
//    _tableview.tag  = 54342;
//    _tableview.delegate = self;
//    _tableview.dataSource = self;
//    _tableview.separatorStyle =UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:_tableview];
//    [_siTableview setUserInteractionEnabled:NO];
//    [_tableview reloadData];
}
#pragma mark-----根据用户品牌编号查看这个品牌下的所有产品列表
-(void)requestData
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }else{
        [common setValue:@"123@abc.com" forKey:@"loginId"];
        [common setValue:@"888888" forKey:@"password"];
    }
    
    NSString *urlString=nil;
    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    
    urlString = [NSString stringWithFormat:@"%@/favorites/favoriteBrandListWhitShop",SEVERURL];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey: @"deviceId"];
    [jsonreq setValue:[self getBrowerCity] forKey:@"cityName"];
    [jsonreq setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
    
    NSString *sbreq=nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {//IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
        NSError *error=nil;
        NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }else{
        SBJsonWriter *sbJsonWriter=[SBJsonWriter alloc];
        sbreq = [sbJsonWriter stringWithObject:jsonreq];
        [sbJsonWriter release];
    }

    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}
#pragma mark----ASIHTTPRequest 代理方法
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return;
        }
        if (error) {
        return;
        }
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    NSMutableArray *productListArray = [dic objectForKey:@"favoritesBrandWithShopDtoList"];
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {
        
        return;
    }
    
    if (!productListArray || ![productListArray isKindOfClass:[NSArray class]])
    {
        return ;
    }
    
    if (productListArray.count<1) {        
    }else
    {
      [Util SvaeBrandShopArray:productListArray];
      [_siTableview reloadData];
    }
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    return;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tableview removeFromSuperview];
    [_arrowsImageView removeFromSuperview];
    [_siTableview setUserInteractionEnabled:YES];
    [_siTableview setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
