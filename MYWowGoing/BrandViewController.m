//
//  BrandViewController.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-10.
//
//

#import "BrandViewController.h"
#import "ShopITwoCell.h"
#import "ShopIThreeCell.h"

#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
 
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
 
#import "CustomAlertView.h"
#import "Single.h"
@interface BrandViewController ()


@property(nonatomic,retain)UITableView   *brandtableView;
@end

@implementation BrandViewController

@synthesize brandtableView = _brandtableView;
@synthesize brandDic=_brandDic;
@synthesize allKeys=_allKeys;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.brandDic=[NSMutableDictionary dictionary];
    self.allKeys=[NSMutableArray array];
    [self requestData];
    
    [self loadBrandTableview];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)doneAction:(id)sender {
    
    if (!self.allBtn.selected) {
        NSArray *allKeyArray=[self.brandDic allKeys];
        NSString *brandString=[allKeyArray componentsJoinedByString:@","];
        [self updateMyfavoritesBrand:brandString :1];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


-(void)loadBrandTableview
{
    _brandtableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, 320, IPHONE_HEIGHT-141) style:UITableViewStylePlain];
    _brandtableView.delegate  = self;
    _brandtableView.dataSource  = self;
    _brandtableView.backgroundColor = [UIColor clearColor];
    _brandtableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_brandtableView];
    
}

//全选按钮
- (IBAction)allSelectAction:(id)sender { 
    
    if (self.allBtn.selected) { //全选按钮选中
        
        self.allSelectImageView.image = [UIImage imageNamed:@"对勾.png"];
        [self drawAllSelect];
        [self.allBtn setSelected:NO];
        
    }
    else
    {
       self.allSelectImageView.image = [UIImage imageNamed:@""];
       [self.allBtn setSelected:YES];
        [self drawAllSelect];
    }
}

-(void)drawAllSelect
{
    [_brandtableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Util getLikeBrandArray].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    if (!self.allBtn.selected) {
        [cell.leftSelectImageView setHidden:NO];
        [cell.leftNoselectView setHidden:YES];
        [cell.rightSelectImageView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
    }else
    {  
        if ([[[self.brandDic objectForKey:brand1] objectForKey:@"ishave"] intValue]==1) {
            [cell.leftSelectImageView setHidden:NO];
            [cell.leftNoselectView setHidden:YES];
            cell.leftBtn.selected=YES;
        }else{
            [cell.leftSelectImageView setHidden:YES];
            [cell.leftNoselectView setHidden:NO];
            cell.leftBtn.selected=NO;
        }
        
        if ([[[self.brandDic objectForKey:brand2] objectForKey:@"ishave"] intValue]==1) {
            [cell.rightSelectImageView setHidden:NO];
            [cell.rightNoselectView setHidden:YES];
            cell.rightBtn.selected=YES;
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


    cell.leftBtn.tag = 100*indexPath.row+0;
    [cell.leftBtn addTarget:self action:@selector(two_left_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightBtn.tag = 100*indexPath.row+1;
    [cell.rightBtn addTarget:self action:@selector(two_right_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (!self.allBtn.selected) {
        
        [cell.leftSelectView setHidden:NO];
        [cell.leftNoSelectView setHidden:YES];
        
        [cell.midSelectView setHidden:NO];
        [cell.midNoDelectView setHidden:YES];
        [cell.rightSelectView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
        
    }
    else
    {
        
        if ([[[self.brandDic objectForKey:brand1] objectForKey:@"ishave"] intValue]==1) {
            [cell.leftSelectView setHidden:NO];
            [cell.leftNoSelectView setHidden:YES];
            cell.leftBtn.selected=YES;
        }else{
            [cell.leftSelectView setHidden:YES];
            [cell.leftNoSelectView setHidden:NO];
            cell.leftBtn.selected=NO;
        }
        
        if ([[[self.brandDic objectForKey:brand2] objectForKey:@"ishave"] intValue]==1) {
            [cell.midSelectView setHidden:NO];
            [cell.midNoDelectView  setHidden:YES];
            cell.midBtn.selected=YES;
        }else{
            
            [cell.midSelectView setHidden:YES];
            [cell.midNoDelectView setHidden:NO];
            cell.midBtn.selected=NO;
        }

        if ([[[self.brandDic objectForKey:brand3] objectForKey:@"ishave"] intValue]==1) {
    
            [cell.rightSelectView setHidden:NO];
            [cell.rightNoselectView setHidden:YES];
            cell.rightBtn.selected=YES;

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


    cell.leftBtn.tag = 100*indexPath.row+0;
    [cell.leftBtn addTarget:self action:@selector(three_left_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightBtn.tag = 100*indexPath.row+2;
    [cell.rightBtn addTarget:self action:@selector(three_right_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
    cell.midBtn.tag = 100*indexPath.row+1;
    [cell.midBtn addTarget:self action:@selector(three_mid_drawSelectView:) forControlEvents:UIControlEventTouchUpInside];
    
    return  cell;
}

#pragma mark---画俩个中的左
-(void)two_left_drawSelectView:(id)sender
{
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopIThreeCell* cell = (ShopIThreeCell*)[_brandtableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandLeft=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"brandid"];
    
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandLeft];

    if (btn.selected)
    {
        btn.selected=NO;
        [cell.leftSelectImageView setHidden:YES];
        [cell.leftNoselectView setHidden:NO];
        [dic setValue:@"0" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandLeft :0];
    }else
    {
        btn.selected=YES;
        [cell.leftSelectImageView setHidden:NO];
        [cell.leftNoselectView setHidden:YES];
        [dic setValue:@"1" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandLeft :1];
    }
    

}
-(void)two_right_drawSelectView:(id)sender
{
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopIThreeCell* cell = (ShopIThreeCell*)[_brandtableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandRgiht=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"brandid"];
    
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandRgiht];
    
    if (btn.selected)
    {
        btn.selected=NO;
        [cell.rightSelectImageView setHidden:YES];
        [cell.rightNoselectView setHidden:NO];
        [dic setValue:@"0" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandRgiht :0];
    }else
    {
        btn.selected=YES;
        [cell.rightSelectImageView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
        [dic setValue:@"1" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandRgiht :1];
    }
}

#pragma mark----画三个左边
-(void)three_left_drawSelectView:(id)sender
{
   
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopITwoCell* cell = (ShopITwoCell*)[_brandtableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandLeft=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"one"] objectForKey:@"brandid"];
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandLeft];
    
   
    if (btn.selected)
    {
        btn.selected=NO;
        [cell.leftSelectView setHidden:YES];
        [cell.leftNoSelectView setHidden:NO];
        [dic setValue:@"0" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandLeft :0];
   
    }else
    {
        btn.selected=YES;
        [cell.leftSelectView setHidden:NO];
        [cell.leftNoSelectView setHidden:YES];
        [dic setValue:@"1" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandLeft :1];
    }

}
-(void)three_mid_drawSelectView:(id)sender
{
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopITwoCell* cell = (ShopITwoCell*)[_brandtableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandMid=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"two"] objectForKey:@"brandid"];
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandMid];

    if (btn.selected)
    {
        btn.selected=NO;
        [cell.midSelectView setHidden:YES];
        [cell.midNoDelectView setHidden:NO];
        [dic setValue:@"0" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandMid :0];
    }else
    {
        btn.selected=YES;
        [cell.midSelectView setHidden:NO];
        [cell.midNoDelectView setHidden:YES];
        [dic setValue:@"1" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandMid :1];
    }

}
-(void)three_right_drawSelectView:(id)sender
{
    
    UIButton  *btn = (UIButton*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag/100 inSection:0];
    ShopITwoCell* cell = (ShopITwoCell*)[_brandtableView cellForRowAtIndexPath:indexPath];
    
    NSString *brandRight=[[[[Util getLikeBrandArray] objectAtIndex:indexPath.row] objectForKey:@"third"] objectForKey:@"brandid"];
    NSMutableDictionary  *dic=[self.brandDic objectForKey:brandRight];
    
    if (btn.selected)
    {
        btn.selected=NO;
        [cell.rightSelectView setHidden:YES];
        [cell.rightNoselectView setHidden:NO];
        [dic setValue:@"0" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandRight :0];
    }else
    {
        btn.selected=YES;
        [cell.rightSelectView setHidden:NO];
        [cell.rightNoselectView setHidden:YES];
        [dic setValue:@"1" forKey:@"ishave"];
        [self updateMyfavoritesBrand:brandRight :1];
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
    
    
    [_brandtableView reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    return;
    
}

-(void)dealloc
{
    [_brandtableView release];
    [_allSelectImageView release];
    [_allBtn release];
    [_brandDic release];
    [_allKeys release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
//  Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAllSelectImageView:nil];
    [self setAllBtn:nil];
    [self setBrandDic:nil];
    [self setAllKeys:nil];
    [super viewDidUnload];
} 

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

-(void)updateMyfavoritesBrand:(NSString*)brandID :(int)type{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }
    
    NSString *urlString=nil;
    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    
    if (type==1) {//添加 
        urlString = [NSString stringWithFormat:@"%@/favorites/add",SEVERURL];
         [jsonreq setValue:brandID forKey:@"brandIdListStr"];
    }else{  //取消
        urlString =
        [NSString stringWithFormat:@"%@/favorites/cancel",SEVERURL];
         [jsonreq setValue:[NSNumber numberWithInt:[brandID intValue]] forKey:@"brandId"];
    }
   
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey: @"deviceId"];
    
    
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
    [requestForm setDidFinishSelector:@selector(updateMyfavoritesBrandFinish:)];
    [requestForm setDidFailSelector:@selector(updateMyfavoritesBrandFail:)];
    [requestForm setShouldContinueWhenAppEntersBackground:YES ];
    [requestForm setTimeOutSeconds:10];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];
}
-(void)updateMyfavoritesBrandFinish:(ASIHTTPRequest *)request{
    if (!self.allBtn.selected) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}


@end
