//
//  BrandsListViewController.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-7-25.
//
//

#import "BrandsListViewController.h"

#import "CoordinateReverseGeocoder.h"
#import "JSON.h"
#import "ProductCell.h"
#import "ShopDistanceListCell.h"
#import "ProductListViewController.h"
#import "MBProgressHUD.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

@interface BrandsListViewController ()
@property (retain, nonatomic) IBOutlet UITableView *brandAndShopTableView;
@property (retain,nonatomic) NSMutableArray *dataSouceArray;


@end

@implementation BrandsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(10, 6, 52, 32)];;
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem1 = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = litem1;
        [litem1 release];
        
    }
    return self;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    //********  zhangMeng     主要用于去除出现在详情界面的系统返回按钮
    UIBarButtonItem *nItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem=nItem;
    [nItem release];
    self.navigationItem.hidesBackButton=YES;
    //**********zhangMeng

   
    self.brandAndShopTableView.frame = CGRectMake(0, 0, 320,IPHONE_HEIGHT - 44 - 49 - 20) ;
    self.dataSouceArray = [NSMutableArray array] ;
    
    if (self.type == 1) {
        self.title = [NSString stringWithFormat:@"品牌列表"];
    }else{
        self.title = [NSString stringWithFormat:@"商场列表"];
        [CoordinateReverseGeocoder getCurrentCity];
    }
    
    if ([Util isLogin]) {
        [self dataSorceBrandAllPage:USERNAME password:PASSWORD cityName:[Util getBrowerCity]];
    }else{
        [self dataSorceBrandAllPage:[Util getLoginName] password:[Util getPassword] cityName:[Util getBrowerCity]];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

#pragma mark
#pragma mark    *********UITableViewDataSource/UITableViewDelegate*******
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return [self.dataSouceArray count]/2 + [self.dataSouceArray count]%2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSMutableDictionary *object =nil;
    if((indexPath.row*2) <[self.dataSouceArray count]){
        object = [self.dataSouceArray objectAtIndex:indexPath.row*2];
    }
    
    NSMutableDictionary *object2 =nil;
    if ((indexPath.row*2+1) <[self.dataSouceArray count]) {
        object2 = [self.dataSouceArray objectAtIndex:indexPath.row*2+1];
    }
    
    //品牌id
    
    int brandAndMarketID1 = 0;
    int brandAndMarketID2  = 0;
    if (self.type == 1) {
        brandAndMarketID1 = [[object objectForKey:@"brandId"] intValue];
        brandAndMarketID2 = [[object2 objectForKey:@"brandId"] intValue];
    }else{
        brandAndMarketID1 = [[object objectForKey:@"marketId"] intValue];
        brandAndMarketID2 = [[object2 objectForKey:@"marketId"] intValue];
    }

    if (self.type == 1) {
        
        static NSString *prodctTableIdentifier = @"productcell";
        ProductCell *cell_Product = [tableView dequeueReusableCellWithIdentifier:
                                     prodctTableIdentifier];
        
        if (cell_Product == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil] ;
            
            //迭代nib重的所有对象来查找NewCell类的一个实例
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[ProductCell class]]) {
                    cell_Product = (ProductCell *)oneObject;
                }
            }
        }
        if (object2 == nil) {// 隐藏右侧所有控件
            
            [cell_Product.uidbtn_Right setHidden: YES];
            [cell_Product.img2 setHidden:YES];
            [cell_Product.img_CloseRight  setHidden:YES];
            
            [cell_Product.img_CloseLeft  setImageWithURL:[NSURL URLWithString:[object objectForKey:@"brandPic"]] placeholderImage:[UIImage imageNamed:@"水印店铺入口"]];
            cell_Product.img_CloseLeft.tag = BRAND_PRO;
            
            cell_Product.uidbtn_Left.tag = brandAndMarketID1;
            cell_Product.uidbtn_Left.data = object;
            [cell_Product.uidbtn_Left addTarget:self action:@selector(toShowByBrandId:) forControlEvents:UIControlEventTouchUpInside];

        }else{
            
            [cell_Product.uidbtn_Right setHidden: NO];
            [cell_Product.img2 setHidden:NO];
            [cell_Product.img_CloseRight  setHidden:NO];
            
            [cell_Product.img_CloseLeft  setImageWithURL:[NSURL URLWithString:[object objectForKey:@"brandPic"]] placeholderImage:[UIImage imageNamed:@"水印店铺入口"]];
            cell_Product.img_CloseLeft.tag = BRAND_PRO;
          
            cell_Product.uidbtn_Left.tag = brandAndMarketID1;
            cell_Product.uidbtn_Left.data = object;
            [cell_Product.uidbtn_Left addTarget:self action:@selector(toShowByBrandId:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell_Product.img_CloseRight  setImageWithURL:[NSURL URLWithString:[object2 objectForKey:@"brandPic"]] placeholderImage:[UIImage imageNamed:@"水印店铺入口"]];
            cell_Product.img_CloseRight.tag = BRAND_PRO;
            [cell_Product.uidbtn_Right addTarget:self action:@selector(toShowByBrandId:) forControlEvents:UIControlEventTouchUpInside];
            cell_Product.uidbtn_Right.data = object2;
             cell_Product.uidbtn_Right.tag = brandAndMarketID2;
        }
        
        return cell_Product;

    }else{
        
        static NSString *prodctTableCell = @"shopDistanceCell";
        ShopDistanceListCell  *cell_shopDistance =
                            [tableView dequeueReusableCellWithIdentifier:prodctTableCell];
        
        if (cell_shopDistance == nil) {
            NSArray * nib = [[NSBundle mainBundle]  loadNibNamed:@"ShopDistanceListCell" owner:self options:nil] ;
            
            //迭代nib重的所有对象来查找NewCell类的一个实例
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[ShopDistanceListCell class]]) {
                    cell_shopDistance= (ShopDistanceListCell *)oneObject;
                }
            }
       }
            
        if (object2 == nil) {// 隐藏右侧所有控件
            
            [cell_shopDistance.rightDataBut setHidden: YES];
            [cell_shopDistance.rightShopImageView setHidden:YES];
            [cell_shopDistance.rightDistanceLable setHidden:YES];
            [cell_shopDistance.right_BianKuangImage setHidden:YES];
            
            
            [cell_shopDistance.leftShopImageView setImageWithURL:[NSURL URLWithString:[object objectForKey:@"marketPic"]] placeholderImage:[UIImage imageNamed:@"水印店铺入口"]];
            
            NSString *marketId = [object objectForKey:@"marketId"];
    
            if ([marketId intValue] == 42 ) {
                cell_shopDistance.leftDistanceLable.hidden = YES;
            }else{
                cell_shopDistance.leftDistanceLable.hidden = NO;
                 cell_shopDistance.leftDistanceLable.text = [NSString stringWithFormat:@"距离您%.1f公里",[[object objectForKey:@"distance"] floatValue]];
            }
            
            cell_shopDistance.leftDistanceLable.text = [NSString stringWithFormat:@"距离您%.1f公里",[[object objectForKey:@"distance"] floatValue]];
            cell_shopDistance.leftDataBut.data= object;
            [cell_shopDistance.leftDataBut addTarget:self action:@selector(toShowByBrandId:)forControlEvents:UIControlEventTouchUpInside];
            cell_shopDistance.leftDataBut.tag = brandAndMarketID1;

            
        }else{
            [cell_shopDistance.rightDataBut setHidden: NO];
            [cell_shopDistance.rightShopImageView setHidden:NO];
            [cell_shopDistance.rightDistanceLable setHidden:NO];
            [cell_shopDistance.right_BianKuangImage setHidden:NO];

          [cell_shopDistance.leftShopImageView setImageWithURL:[NSURL URLWithString:[object objectForKey:@"marketPic"]] placeholderImage:[UIImage imageNamed:@"水印店铺入口"]];
            
            NSString *marketId = [object objectForKey:@"marketId"];
            
            if ([marketId intValue] == 42 ) {
                cell_shopDistance.leftDistanceLable.hidden = YES;
            }else{
                cell_shopDistance.leftDistanceLable.hidden = NO;
                cell_shopDistance.leftDistanceLable.text = [NSString stringWithFormat:@"距离您%.1f公里",[[object objectForKey:@"distance"] floatValue]];
            }

          cell_shopDistance.leftDataBut.data= object;
          [cell_shopDistance.leftDataBut addTarget:self action:@selector(toShowByBrandId:)forControlEvents:UIControlEventTouchUpInside];
          cell_shopDistance.leftDataBut.tag = brandAndMarketID1;
            
        
          [cell_shopDistance.rightShopImageView setImageWithURL:[NSURL URLWithString:[object2 objectForKey:@"marketPic"]] placeholderImage:[UIImage imageNamed:@"水印店铺入口"]];
            
            NSString *marketIdRight = [object objectForKey:@"marketId"];
            
            if ([marketIdRight intValue] == 42) {
                cell_shopDistance.rightDistanceLable.hidden = YES;
            }else{
                cell_shopDistance.rightDistanceLable.hidden = NO;
                cell_shopDistance.rightDistanceLable.text = [NSString stringWithFormat:@"距离您%.1f公里",[[object2 objectForKey:@"distance"] floatValue]];
            }

          cell_shopDistance.rightDistanceLable.text = [NSString stringWithFormat:@"距离您%@公里",[object2 objectForKey:@"distance"]];
         cell_shopDistance.rightDataBut.data= object2;
         [cell_shopDistance.rightDataBut addTarget:self action:@selector(toShowByBrandId:)forControlEvents:UIControlEventTouchUpInside];
        cell_shopDistance.rightDataBut.tag = brandAndMarketID2;
        }
        
        return  cell_shopDistance;
    }
}

#pragma mark
#pragma mark    **********数据请求************
-(void)dataSorceBrandAllPage:(NSString *)userName
                    password:(NSString *)password
                    cityName:(NSString *)cityName
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:userName forKey:@"loginId"];
    [common setValue:password forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getBrowerCity] forKey:@"cityName"];
    
    NSString *urlS = nil;
    if (self.type == 1) {
        urlS = [NSString stringWithFormat:@"%@/%@",SEVERURL,HOT_BRANDS];
    }else{
        
       urlS = [NSString stringWithFormat:@"%@/%@",SEVERURL,HOT_SHOP];
        float  lon = [[[Util takeCurrentLocationPoint]  objectForKey:@"longitude"] floatValue];
        float  lat = [[[Util takeCurrentLocationPoint]  objectForKey:@"latitude"] floatValue];
        [jsonreq setValue:[NSNumber numberWithFloat:lon] forKey:@"userCurrentLon"];
        [jsonreq setValue:[NSNumber numberWithFloat:lat]  forKey:@"userCurrentLat"];
    }

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
    
    ASIFormDataRequest  *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlS]];
    [requestForm setDidFinishSelector:@selector(brandAndShopDataRequestFinished:)];
    [requestForm setDidFailSelector:@selector(brandAndShopDataRequestFail:)];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setDelegate:self];
    [requestForm startAsynchronous];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

- (void) brandAndShopDataRequestFinished:(ASIFormDataRequest*)requestForm{

    NSMutableDictionary *dic=nil;
    
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            return;
        }
        if (error) {
          [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            return;
        }
    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        return;
    }
    
   int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
   if (responseStatus!=200) {
      [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
       return;
   }

    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    if (self.type == 1) {
        self.dataSouceArray = [dic objectForKey:@"greatBrandPics"];
    }else{
        //店铺信息
        
        self.dataSouceArray = [dic  objectForKey:@"marketDetail"];
    }
    
    [self.brandAndShopTableView reloadData];
}


- (void) brandAndShopDataRequestFail:(ASIFormDataRequest*)request{
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
      [self.view makeToast:NETWORK_STRING duration:0.5 position:@"center" title:nil];
    
}


- (void)toShowByBrandId:(UIDataButton*)sender{
    ProductListViewController *productListVC = [[[ProductListViewController alloc ]initWithNibName:@"ProductListViewController" bundle:nil] autorelease];
    if (self.type == 1) {
        productListVC.flagForBrandOrShop = 1;
        productListVC.brandID =[NSString stringWithFormat:@"%d",sender.tag];
        productListVC.conditionStr = [sender.data objectForKey:@"brandName"];
    }else{
        productListVC.flagForBrandOrShop = 2;
        productListVC.shopID = [NSString stringWithFormat:@"%d",sender.tag];
        productListVC.conditionStr = [sender.data objectForKey:@"marketName"];

    }
    
    [self.navigationController pushViewController:productListVC animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    [_brandAndShopTableView release];
    [_dataSouceArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBrandAndShopTableView:nil];
    [super viewDidUnload];
}
@end
