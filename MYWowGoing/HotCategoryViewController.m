//
//  HotCategoryViewController.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-3.
//
//

#import "HotCategoryViewController.h"
#import "SubHotCategorViewController.h"
#import "HotCategoryCell.h"
#import "ProductListViewController.h"

@interface HotCategoryViewController ()<UIFolderTableViewDelegate>
@property (retain, nonatomic) NSIndexPath  *currentIndexPath;
@property  (nonatomic,retain)  NSDictionary  *categoryDic;
@property  (nonatomic,retain) NSMutableArray  *categoryArray;

@end

@implementation HotCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 6, 52, 32)];
		[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
  		UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		self.navigationItem.leftBarButtonItem = litem;
    
		[litem release];
        
        self.title = @"热门类目";
        
    }
    return self;
}


-  (void)backAction:(UIButton*)sender{
  
    [self.navigationController popViewControllerAnimated:YES];

}


-(NSArray *)cates
{
    if (_cates == nil){
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"CategoryLeiBie" withExtension:@"plist"];
        _cates = [[NSArray arrayWithContentsOfURL:url]  retain];
    }
    return _cates;
}

- (void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.categoryDic = [NSDictionary dictionary];
    self.categoryArray = [NSMutableArray array];
    
    [self requestCategoryList];
}


- (void) requestCategoryList{
  
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[NSString stringWithFormat:@"%@",[Util getLoginName]] forKey:@"loginId"];
        [common setValue:[NSString stringWithFormat:@"%@",[Util getPassword]] forKey:@"password"];
    }else{
       
        [common setValue:[NSString stringWithFormat:@"%@",USERNAME] forKey:@"loginId"];
        [common setValue:[NSString stringWithFormat:@"%@",PASSWORD] forKey:@"password"];
    }
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getBrowerCity] forKey:@"cityName"];
    [jsonreq setValue:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",@"上装",@"裤装",@"裙装",@"内衣",@"包",@"配饰",@"鞋"] forKey:@" categoryList"];
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,@"category/list"];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm setDidFinishSelector:@selector(requestCategoryListFinish:)];
    [requestForm setDidFailSelector:@selector(requestCategoryListFail:)];
    
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startAsynchronous];
    [requestForm setDelegate:self];

}

-  (void) requestCategoryListFinish:(ASIFormDataRequest*) requestForm{
    NSMutableDictionary *dic=nil;
    
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
    }else{
        return;
    }
    if (error) {
        return;
    }
    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        return;
    }
    
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    
    if (responseStatus!=200) {
        [MBProgressHUD hideHUDForView:self.navigationController.view  animated:YES];
        return;
    }
    
    if (dic != NULL) {
        self.categoryDic = dic;
    }
    
}
- (void) requestCategoryListFail:(ASIFormDataRequest*) requet{}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.cates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    
    HotCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"HotCategoryCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *cate = [self.cates objectAtIndex:indexPath.row];
    cell.itemLable.text = [cate objectForKey:@"name"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            self.categoryArray = [self.categoryDic objectForKey:@"upClothes"];
            break;
        case 1:
            self.categoryArray = [self.categoryDic objectForKey:@"downClothes"];
            break;
        case 2:
            self.categoryArray = [self.categoryDic objectForKey:@"underwaistList"];
            break;
        case 3:
            self.categoryArray = [self.categoryDic objectForKey:@"dressList"];
            break;
        case 4:
            self.categoryArray = [self.categoryDic objectForKey:@"Bag"];
            break;
        case 5:
            self.categoryArray = [self.categoryDic objectForKey:@"shooseList"];
            break;
        case 6:
            self.categoryArray = [self.categoryDic objectForKey:@"ornamentList"];
            break;
        default:
            break;
    }
    
    SubHotCategorViewController *subVc = [[[SubHotCategorViewController alloc]
             initWithNibName:NSStringFromClass([SubHotCategorViewController class])
             bundle:nil] autorelease];

    subVc.subCates = self.categoryArray;
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    subVc.hotCateVC  = self;
    
    [self.folderTbaleView openFolderAtIndexPath:self.currentIndexPath WithContentView:subVc.view   openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                          
                                          self.folderTbaleView.contentSize = CGSizeMake(320, self.folderTbaleView.frame.size.height + subVc.view.frame.size.height);
                                      }
                                     closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                         // closing actions
                                     }
                                completionBlock:^{
                                    // completed actions
                                    self.folderTbaleView.scrollEnabled = YES;
                                }];

    
}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)subCateBtnAction:(UIButton *)btn
{
    
    ProductListViewController  *proListVC = [[[ProductListViewController alloc ]initWithNibName:@"ProductListViewController" bundle:nil] autorelease];
    
    
    if ([btn.titleLabel.text isEqualToString:@"ALL"]) {
        switch (self.currentIndexPath.row) {
            case 0:
                proListVC.type = @"1";
                proListVC.conditionStr = @"上装";
            break;
            case 1:
                proListVC.type = @"3";
                proListVC.conditionStr = @"裤装";
                break;
            case 2:
                proListVC.type = @"10";
                proListVC.conditionStr = @"内衣";
                break;
            case 3:
                proListVC.type = @"2";
                proListVC.conditionStr = @"裙装";
                break;
            case 4:
                proListVC.type = @"6";
                proListVC.conditionStr = @"包";
                break;
            case 5:
                proListVC.type = @"5";
                proListVC.conditionStr = @"鞋";
                break;
            case 6:
                proListVC.type = @"4";
                proListVC.conditionStr = @"配饰";
                break;
            default:
                break;
        }
    }else{
        proListVC.styleTypeName = btn.titleLabel.text;
        proListVC.conditionStr = btn.titleLabel.text;
    }
    
    proListVC.flagForBrandOrShop = 3;
    [self.navigationController pushViewController:proListVC animated:YES];
    [self.folderTbaleView performClose];
       
}

- (void) clearSelectedItem:(UIButton*) sender{

    int count = self.cates.count;
    for (int i = 0; i < count; i ++) {
         HotCategoryCell  *cell =(HotCategoryCell*) [self.folderTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.subItemLable.text =@"ALL";
    }
    
    [self.folderTbaleView reloadData];
    
}
- (void) sureAction:(UIButton*) sender{
   
    ProductListViewController  *proListVC = [[[ProductListViewController alloc ]initWithNibName:@"ProductListViewController" bundle:nil] autorelease];
    
    proListVC.flagForBrandOrShop = 3;
    
    int count = self.cates.count;
    NSMutableArray  *stringArray  = [NSMutableArray array];
    
    for (int i = 0; i < count; i ++) {
        HotCategoryCell  *cell =(HotCategoryCell*) [self.folderTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (![cell.subItemLable.text  isEqualToString:@"ALL"]) {
            [stringArray addObject:cell.subItemLable.text];
        }
    }
    
    NSString  *typeString = nil;
    if (stringArray.count != 0) {
         typeString = [stringArray componentsJoinedByString:@","];
    }else{
          [self.view makeToast:@"请选择类目" duration:0.5 position:@"center" title:nil];
        return;
    }
   
    proListVC.styleTypeName = typeString;
    
    [self.navigationController pushViewController:proListVC animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_currentIndexPath release];
    [_categoryArray release];
    [_categoryDic release];
    [_cates release];
    [_folderTbaleView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFolderTbaleView:nil];
    [super viewDidUnload];
}
@end
