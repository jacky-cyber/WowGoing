//
//  FavoriteViewController.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-4.
//
//

#import "FavoriteViewController.h"
#import "ScanningVC.h"
#import "ShopITwoCell.h"
#import "ShopIThreeCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "Api.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "GZBS.h"
#import "LoginViewController.h"
#import "RegisterView.h" 

@interface FavoriteViewController ()
@property (retain, nonatomic)  UITableView *brandTableView;
@property(nonatomic,retain) NSMutableDictionary *brandDic;
@property(nonatomic,retain) NSMutableArray *allKeys;
@property (retain, nonatomic) IBOutlet UIImageView *duiGouImage;

@property (retain,nonatomic) NSMutableDictionary  *selectBrandDic;

@property (retain, nonatomic) IBOutlet UIButton *allBut;


@end

@implementation FavoriteViewController
@synthesize brandTableView = _brandTableView;
@synthesize brandDic = _brandDic;
@synthesize allKeys = _allKeys;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 6, 52, 32)];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:  UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = litem;
        [litem release];
        self.title = @"关注";
    }
    return self;
}


- (IBAction)selectAllAction:(id)sender {
    
    if (self.allBut.selected) { //全选按钮选中
        _duiGouImage.hidden = YES;
        [self.allBut setSelected:NO];
        [self drawAllSelect];
        [self changStateForAllBrand:NO];
    }
    else
    {
        _duiGouImage.hidden = NO;
        [self.allBut setSelected:YES];
        [self drawAllSelect];
        [self changStateForAllBrand:YES];
    }
    
}

#pragma mark ---------- 关注返回按钮
- (void)backAction:(id)sender {
    
    if ([Util isLogin]) {
        NSArray  *brandArray = nil;
        if (self.allBut.selected) {
            brandArray =[self.brandDic allKeys];
        }else{
            brandArray = [self.selectBrandDic allValues];
        }
        
        NSString *brandString = [brandArray componentsJoinedByString:@","];
        [self updateMyfavoritesBrand:brandString];
    }else{
    
        [self dismissModalViewControllerAnimated:YES];
    }

}
- (IBAction)goToScanningAction:(id)sender {
    
    if ([Util isLogin]) {
        ScanningVC *scanVC = [[[ScanningVC alloc ]initWithNibName:@"ScanningVC" bundle:nil] autorelease];
        scanVC.type = 1;
        [self.navigationController pushViewController:scanVC animated:YES];
    }else{
        
        UIAlertView *custom=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录,请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",@"注册",nil];
        [custom show];
        [custom release];
    
     }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqualToString:@"您还未登录,请先登录"]) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
            {
                LoginViewController *loginVC=[[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil] autorelease];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
                break;
            case 2:
            {
                RegisterView *registerVC=[[[RegisterView alloc]initWithNibName:@"RegisterView" bundle:nil] autorelease];
                [self.navigationController pushViewController:registerVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void) viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];

    self.brandDic=[NSMutableDictionary dictionary];
    self.allKeys=[NSMutableArray array];
    
    self.selectBrandDic = [NSMutableDictionary dictionary];
    [self requestData];
    
    [self loadBrandTableview];
    
}
-(void)loadBrandTableview
{
    _brandTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, IPHONE_HEIGHT - 85 - 44 - 20) style:UITableViewStylePlain];
    _brandTableView.delegate  = self;
    _brandTableView.dataSource  = self;
    _brandTableView.backgroundColor = [UIColor clearColor];
    _brandTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_brandTableView];
    
}

-(void)drawAllSelect
{
    [_brandTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Util getLikeBrandArray].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row%2 !=0) { //奇数行 两张图片布局CELL
        static NSString *CellIdentifier3 = @"ShopIThreeCell";
        ShopIThreeCell *cell = (ShopIThreeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopIThreeCell" owner:self options:nil];
            cell = (ShopIThreeCell *)[nib objectAtIndex:0];
        }
        return [self drawShopThreeCell:cell indexPath:indexPath];;
        
    }else
    {   //偶数行   三张图片布局CELL
        static NSString *CellIdentifier = @"ShopITwoCell";
        ShopITwoCell *cell = (ShopITwoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopITwoCell" owner:self options:nil];
            cell = (ShopITwoCell *)[nib objectAtIndex:0];
        }
        return [self drawShopTwoCell:cell indexPath:indexPath];
    }
    
}

#pragma mark ----绘制2
-(UITableViewCell*)drawShopThreeCell:(ShopIThreeCell*)shopIThreeCell indexPath:(NSIndexPath*)indexPath
{
    ShopIThreeCell *cell = shopIThreeCell;
    //获取 品牌图片和品牌ID
    NSString  *one=  [[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"pictureurl"];
    NSString *brand1=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"brandid"];
    
    NSString  *two=  [[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"pictureurl"];
    NSString *brand2=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"brandid"];
    
    cell.leftBtn.tag = 100*indexPath.row+0;
    [cell.leftBtn addTarget:self action:@selector(two_left_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightBtn.tag = 100*indexPath.row+1;
    [cell.rightBtn addTarget:self action:@selector(two_right_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];

    if (self.allBut.selected) {
        [cell.leftSelectImageView setHidden:NO];
        [cell.leftNoselectView setHidden:YES];
        [cell.rightSelectImageView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
        
        [self.selectBrandDic setValue:brand1 forKey:[NSString stringWithFormat:@"%d",cell.leftBtn.tag]];
      
        [self.selectBrandDic setValue:brand2 forKey:[NSString stringWithFormat:@"%d",cell.rightBtn.tag]];
        cell.leftBtn.selected = YES;
        cell.rightBtn.selected = YES;
        
           }else
    {
        if ([[[self.brandDic objectForKey:brand1] objectForKey:@"ishave"] intValue]==1) {
            [cell.leftSelectImageView setHidden:NO];
            [cell.leftNoselectView setHidden:YES];
            cell.leftBtn.selected=YES;
             [self.selectBrandDic setValue:brand1 forKey:[NSString stringWithFormat:@"%d",cell.leftBtn.tag]];
        }else{
            [cell.leftSelectImageView setHidden:YES];
            [cell.leftNoselectView setHidden:NO];
            cell.leftBtn.selected=NO;
        }
        
        if ([[[self.brandDic objectForKey:brand2] objectForKey:@"ishave"] intValue]==1) {
            [cell.rightSelectImageView setHidden:NO];
            [cell.rightNoselectView setHidden:YES];
            cell.rightBtn.selected=YES;
            
            [self.selectBrandDic setValue:brand2 forKey:[NSString stringWithFormat:@"%d",cell.rightBtn.tag]];

             
        }else{
            [cell.rightSelectImageView setHidden:YES];
            [cell.rightNoselectView setHidden:NO];
            cell.rightBtn.selected=NO;
        }
    }
    
    [cell.leftLogoImageView setImageWithURL:[NSURL URLWithString:one] placeholderImage:[UIImage imageNamed:@""]];
    [cell.rightLogoImageView setImageWithURL:[NSURL URLWithString:two] placeholderImage:[UIImage imageNamed:@""]];
    
    if (two==nil || [two isEqualToString:@""]) {
        cell.rightSelectImageView.hidden=YES;
        cell.rightNoselectView.hidden=YES;
        cell.rightBtn.enabled=NO;
    }
    
    
       return  cell;
}
#pragma mark----绘制3
-(UITableViewCell*)drawShopTwoCell:(ShopITwoCell*)shopItwoCell indexPath:(NSIndexPath*)indexPath
{
    ShopITwoCell *cell = shopItwoCell; //包含三张图片
    
    NSString *one=  [[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"pictureurl"];
    NSString *brand1=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"brandid"];
    
    NSString *two=  [[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"pictureurl"];
    NSString *brand2=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"brandid"];
    
    NSString *three=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"third"]objectForKey:@"pictureurl"];
    NSString *brand3=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"third"] objectForKey:@"brandid"];
    
    
    cell.leftBtn.tag = 100*indexPath.row+0;
    [cell.leftBtn addTarget:self action:@selector(three_left_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightBtn.tag = 100*indexPath.row+2;
    [cell.rightBtn addTarget:self action:@selector(three_right_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
    cell.midBtn.tag = 100*indexPath.row+1;
    [cell.midBtn addTarget:self action:@selector(three_mid_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];

    
    if (self.allBut.selected) {
        
        [cell.leftSelectView setHidden:NO];
        [cell.leftNoSelectView setHidden:YES];
        
        cell.leftBtn.selected = YES;
        cell.midBtn.selected = YES;
        cell.rightBtn.selected = YES;
        
        [cell.midSelectView setHidden:NO];
        [cell.midNoDelectView setHidden:YES];
        [cell.rightSelectView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
        
        [self.selectBrandDic setValue:brand1 forKey:[NSString stringWithFormat:@"%d",cell.leftBtn.tag]];
        
        [self.selectBrandDic setValue:brand2 forKey:[NSString stringWithFormat:@"%d",cell.midBtn.tag]];
        
        [self.selectBrandDic setValue:brand3 forKey:[NSString stringWithFormat:@"%d",cell.rightBtn.tag]];

    }
    else
    {
        
        if ([[[self.brandDic objectForKey:brand1] objectForKey:@"ishave"] intValue]==1) {
            [cell.leftSelectView setHidden:NO];
            [cell.leftNoSelectView setHidden:YES];
            cell.leftBtn.selected=YES;
            
            [self.selectBrandDic setValue:brand1 forKey:[NSString stringWithFormat:@"%d",cell.leftBtn.tag]];
            
            [self.selectBrandDic setValue:brand3 forKey:[NSString stringWithFormat:@"%d",cell.rightBtn.tag]];
        }else{
            [cell.leftSelectView setHidden:YES];
            [cell.leftNoSelectView setHidden:NO];
            cell.leftBtn.selected=NO;
        }
        
        if ([[[self.brandDic objectForKey:brand2] objectForKey:@"ishave"] intValue]==1) {
            [cell.midSelectView setHidden:NO];
            [cell.midNoDelectView  setHidden:YES];
            cell.midBtn.selected=YES;
            
              [self.selectBrandDic setValue:brand2 forKey:[NSString stringWithFormat:@"%d",cell.midBtn.tag]];
        
        }else{
            
            [cell.midSelectView setHidden:YES];
            [cell.midNoDelectView setHidden:NO];
            cell.midBtn.selected=NO;
        }
        
        if ([[[self.brandDic objectForKey:brand3] objectForKey:@"ishave"] intValue]==1) {
            
            [cell.rightSelectView setHidden:NO];
            [cell.rightNoselectView setHidden:YES];
            cell.rightBtn.selected=YES;
            
             [self.selectBrandDic setValue:brand3 forKey:[NSString stringWithFormat:@"%d",cell.rightBtn.tag]];
            
        }else{
            [cell.rightSelectView setHidden:YES];
            [cell.rightNoselectView setHidden:NO];
            cell.rightBtn.selected=NO;
        }
    }
    

    [cell.leftLogoImageView setImageWithURL:[NSURL URLWithString:one] placeholderImage:[UIImage imageNamed:@""]];
    [cell.midLogoImageView setImageWithURL:[NSURL URLWithString:two] placeholderImage:[UIImage imageNamed:@""]];
    [cell.rightLogoImageView setImageWithURL:[NSURL URLWithString:three] placeholderImage:[UIImage imageNamed:@""]];
    
    if (three==nil || [three isEqualToString:@""]) {
        cell.rightSelectView.hidden=YES;
        cell.rightNoselectView.hidden=YES;
        cell.rightBtn.enabled=NO;
    }
    
    if (two==nil || [two isEqualToString:@""]) {
        cell.midSelectView.hidden=YES;
        cell.midNoDelectView.hidden=YES;
        cell.midBtn.enabled=NO;
    }
    
    return  cell;
}

#pragma mark---画俩个中的左
-(void)two_left_drawSelectView:(id)sender
{
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopIThreeCell* cell = (ShopIThreeCell*)[self.brandTableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandLeft=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"brandid"];
    
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandLeft];
    
    if (btn.selected)
    {
        btn.selected=NO;
        self.allBut.selected = NO;
        _duiGouImage.hidden = YES;
        [cell.leftSelectImageView setHidden:YES];
        [cell.leftNoselectView setHidden:NO];
        
        [self.selectBrandDic removeObjectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [dic setValue:@"0" forKey:@"ishave"];

    }else
    {
        btn.selected=YES;
        
        [cell.leftSelectImageView setHidden:NO];
        [cell.leftNoselectView setHidden:YES];
        
          [self.selectBrandDic setValue:brandLeft forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [dic setValue:@"1" forKey:@"ishave"];

    }
    
}
-(void)two_right_drawSelectView:(id)sender
{
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopIThreeCell* cell = (ShopIThreeCell*)[self.brandTableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandRgiht=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"brandid"];
    
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandRgiht];
    
    if (btn.selected)
    {
        btn.selected=NO;
        self.allBut.selected = NO;
        _duiGouImage.hidden = YES;
        [cell.rightSelectImageView setHidden:YES];
        [cell.rightNoselectView setHidden:NO];
        [self.selectBrandDic removeObjectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [dic setValue:@"0" forKey:@"ishave"];

    }else
    {
        btn.selected=YES;
        
        [cell.rightSelectImageView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
        [self.selectBrandDic setValue:brandRgiht forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [dic setValue:@"1" forKey:@"ishave"];

    }
}

#pragma mark----画三个左边
-(void)three_left_drawSelectView:(id)sender
{
    
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopITwoCell* cell = (ShopITwoCell*)[self.brandTableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandLeft=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"brandid"];
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandLeft];
    
    
    if (btn.selected)
    {
        btn.selected=NO;
        self.allBut.selected = NO;
        _duiGouImage.hidden = YES;
        [cell.leftSelectView setHidden:YES];
        [cell.leftNoSelectView setHidden:NO];
        
        [self.selectBrandDic removeObjectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [dic setValue:@"0" forKey:@"ishave"];
        
    }else
    {
        btn.selected=YES;
        [cell.leftSelectView setHidden:NO];
        [cell.leftNoSelectView setHidden:YES];
        
         [self.selectBrandDic setValue:brandLeft forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [dic setValue:@"1" forKey:@"ishave"];

    }
    
}
-(void)three_mid_drawSelectView:(id)sender
{
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopITwoCell* cell = (ShopITwoCell*)[self.brandTableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandMid=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"brandid"];
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandMid];
    
    if (btn.selected)
    {
        btn.selected=NO;
        self.allBut.selected = NO;
        _duiGouImage.hidden = YES;
        [cell.midSelectView setHidden:YES];
        [cell.midNoDelectView setHidden:NO];
        
        [self.selectBrandDic removeObjectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
        
        [dic setValue:@"0" forKey:@"ishave"];
    }else
    {
        btn.selected=YES;
        
        [cell.midSelectView setHidden:NO];
        [cell.midNoDelectView setHidden:YES];
        
        [self.selectBrandDic setValue:brandMid forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        
        [dic setValue:@"1" forKey:@"ishave"];

    }
    
}
-(void)three_right_drawSelectView:(id)sender
{
    
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopITwoCell* cell = (ShopITwoCell*)[self.brandTableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandRight=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"third"] objectForKey:@"brandid"];
    
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandRight];
    
    if (btn.selected)
    {
        btn.selected=NO;
        
        self.allBut.selected = NO;
        _duiGouImage.hidden = YES;
        [cell.rightSelectView setHidden:YES];
        [cell.rightNoselectView setHidden:NO];
        
        [self.selectBrandDic removeObjectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [dic setValue:@"0" forKey:@"ishave"];

    }else
    {
        btn.selected=YES;
        
        [cell.rightSelectView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
        
         [self.selectBrandDic setValue:brandRight forKey:[NSString stringWithFormat:@"%d",btn.tag]];
       
        [dic setValue:@"1" forKey:@"ishave"];
    }
}

#pragma mark-----根据用户品牌编号查看这个品牌下的所有产品列表
-(void)requestData
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }
    
    NSString *urlString ;    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    
    urlString = [NSString stringWithFormat:@"%@/favorites/branddisplaylist",SEVERURL];
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
    
}

#pragma mark----ASIHTTPRequest 代理方法
- (void)requestFinished:(ASIHTTPRequest *)request
{
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
        [Util SaveLikeBrandArray:productListArray];
        [self getallBrnadID:productListArray];
    }
    
    
    [_brandTableView reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{

    return;
    
}


#pragma mark 
#pragma mark    ****************获取所有品牌的品牌ID**************
- (void)getallBrnadID:(NSArray*)brandArray{  //获取所有品牌的品牌ID
    //下面的算法 主要是将品牌ID和与之对应的ishave(表示是否是藏)摘取出来存放在self.brandDic字典中
    for (NSDictionary *dic in brandArray) {
        NSMutableDictionary *tempDicOne=[NSMutableDictionary dictionary];
        NSDictionary *tempOne=[dic objectForKey:@"one"];
        [tempDicOne setValue:[tempOne objectForKey:@"brandid"] forKey:@"brandId"];
        [tempDicOne setValue:[tempOne objectForKey:@"ishave"] forKey:@"ishave"];
        [self.brandDic setValue:tempDicOne forKey:[tempOne objectForKey:@"brandid"]];
        
        NSMutableDictionary *tempDicTwo=[NSMutableDictionary dictionary];
        NSDictionary *tempTwo=[dic objectForKey:@"two"];
        if (![[tempTwo objectForKey:@"brandid"] intValue]==0){
            [tempDicTwo setValue:[tempTwo objectForKey:@"brandid"] forKey:@"brandId"];
            [tempDicTwo setValue:[tempTwo objectForKey:@"ishave"] forKey:@"ishave"];
            [self.brandDic setValue:tempDicTwo forKey:[tempTwo objectForKey:@"brandid"]];
        }
        
        NSMutableDictionary *tempDicThird=[NSMutableDictionary dictionary];
        NSDictionary *tempThird=[dic objectForKey:@"third"];
        if (![[tempThird objectForKey:@"brandid"] intValue]==0) {
            [tempDicThird setValue:[tempThird objectForKey:@"brandid"] forKey:@"brandId"];
            [tempDicThird setValue:[tempThird objectForKey:@"ishave"] forKey:@"ishave"];
            [self.brandDic setValue:tempDicThird forKey:[tempThird objectForKey:@"brandid"]];
        }
    }
    
}

#pragma mark ---------- 更新关注的品牌在点击返回按钮的时候开始更新
-(void)updateMyfavoritesBrand:(NSString*)brandID{
    
    GZBS *GZ = [[[GZBS alloc] init] autorelease];
    GZ.delegate = self;
    GZ.brandString = brandID;
    GZ.onFaultSeletor = @selector(updateMyfavoritesBrandFail:);
    GZ.onSuccessSeletor = @selector(updateMyfavoritesBrandFinish:);
    [GZ asyncExecute];

}
-(void)updateMyfavoritesBrandFinish:(ASIHTTPRequest *)request{
    
    [self dismissModalViewControllerAnimated:YES];
   
}

#pragma mark 
#pragma mark   *********改变各个品牌的选中标记******
- (void) changStateForAllBrand:(BOOL) isAll{
    
    NSArray  *brandIDArray = [self.brandDic allKeys];

    for (int i = 0 ; i < brandIDArray.count; i++) {
            NSDictionary *brandDic = [self.brandDic objectForKey:[brandIDArray objectAtIndex:i]];
            if (isAll) {
                [brandDic setValue:@"1" forKey:@"ishave"];
            }else{
                 [brandDic setValue:@"0" forKey:@"ishave"];
            }
        }
    
    if (!isAll) {
        [self.selectBrandDic removeAllObjects];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_selectBrandDic release];
    [_brandTableView release];
    [_allKeys release];
    [_brandDic release];
    [_duiGouImage release];
    [_allBut release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBrandTableView:nil];
    [self setDuiGouImage:nil];
    [self setAllBut:nil];
    [super viewDidUnload];
}
@end
