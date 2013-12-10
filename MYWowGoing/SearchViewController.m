//
//  SearchViewController.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-22.
//
//

#import "SearchViewController.h"
#import "HistoryVC.h"
#import "ProductListViewController.h"
#import "BrandsListViewController.h"
#import "HotCategoryViewController.h"
#import "SDNestTableVC.h"
#import "HotWordsBS.h"
#import "LKCustomTabBar.h"
#import "MobClick.h"
@interface SearchViewController ()<UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UIView *underButView;
@property (retain, nonatomic) IBOutlet UIView *hotWordsView;
@property (retain ,nonatomic)  NSMutableArray *hotwordsArray;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
     [self requestHotWordsList];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //********  zhangMeng
    UIBarButtonItem *nItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem=nItem;
    [nItem release];
    self.navigationItem.hidesBackButton=YES;
    //**********zhangMeng

       if (iPhone5) {
        _underButView.frame = CGRectMake(0, 302, 320, 177);
        _hotWordsView.frame = CGRectMake(0, 44, 320, 250);
    }else{
        _underButView.frame = CGRectMake(0, 235, 320, 177);
         _hotWordsView.frame = CGRectMake(0, 44, 320, 180);

    }
	// Do any additional setup after loading the view.
}


#pragma  mark
#pragma mark    ************请求热词*********
- (void) requestHotWordsList{
    HotWordsBS   *hotVC = [[[HotWordsBS alloc ]init] autorelease];
    hotVC.delegate = self;
    [hotVC setOnSuccessSeletor:@selector(requestHotWordsListSuccess:)];
    [hotVC setOnFaultSeletor:@selector(requestHotWordsListFault:)];
    [hotVC asyncExecute];
}

- (void) requestHotWordsListSuccess:(ASIFormDataRequest*) request{
    
    NSMutableDictionary *dic=nil;
            NSError *error=nil;
    if (request.responseData.length>0) {
        dic= [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
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

    //    校验是否成功
    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus!=200) {
        return;
    }

    NSString   *hotWordsString = [[[dic objectForKey:@"greatWordslist"] objectAtIndex:0]  objectForKey:@"greateWordsText"];
    self.hotwordsArray = [NSMutableArray arrayWithArray:[hotWordsString componentsSeparatedByString:@","]];
    if (self.hotwordsArray.count != 0) {
        [self draweInterFaceForButtons:self.hotwordsArray];
    }

}
- (void) requestHotWordsListFault:(ASIFormDataRequest*) request{


}

#pragma mark 
#pragma  mark     ************对热词进行随机布局*************
- (void) draweInterFaceForButtons:(NSMutableArray*)array{
    
    [self.hotWordsView removeAllSubviews];
    int x = 0;
    int y = 0;
    int k = 0;
    int counts = array.count;
    int width = self.hotWordsView.frame.size.width - 61;
    int height = self.hotWordsView.frame.size.height - 30;
    int rowCount = 0;
    if (counts%4 == 0) {
        rowCount = counts/4;
    }else{
         rowCount = counts/4 + 1;
    }
       for (int i = 0; i < rowCount ;  i ++) {
           for (int j = 0 ; j < 4; j++) {
               x = rand()%(width/4)/2 + width/4*j + 10 ;
               y = rand()%(height/rowCount)/2 + height/rowCount*i + 10;
               if (k > counts - 1) {
                   break;
               }
               UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
               button.frame = CGRectMake(x , y, 61, 26);
               [button setBackgroundImage:[UIImage imageNamed:@"搜索标签.png"] forState:UIControlStateNormal];
               [button setBackgroundImage:[UIImage imageNamed:@"标签-选中.png"] forState:UIControlStateSelected];
               [button setTitle:[array objectAtIndex:k]  forState:UIControlStateNormal];
               [button setTitleColor:[UIColor colorWithRed:138.0/255.0 green:91.0/255.0 blue:10.0/255.0 alpha:1.0] forState:UIControlStateNormal];
               [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
               [button addTarget:self action:@selector(hotWordsAction:) forControlEvents:UIControlEventTouchUpInside];
               button.tag = k ;
               [self.hotWordsView addSubview:button];
                k ++;
           }
    }
    
}

- (void) hotWordsAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    ProductListViewController *productListVC = [[[ProductListViewController alloc ]initWithNibName:@"ProductListViewController" bundle:nil] autorelease];
    
    productListVC.flagForBrandOrShop = 9;
    
    productListVC.styleTypeName = sender.titleLabel.text;
    productListVC.conditionStr = sender.titleLabel.text;
    
    [self.navigationController pushViewController:productListVC animated:YES];

}

#pragma mark  
#pragma mark    ************UISearchBarDelegate***********

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    
    ProductListViewController *productListVC = [[[ProductListViewController alloc ]initWithNibName:@"ProductListViewController" bundle:nil] autorelease];
    
    productListVC.flagForBrandOrShop = 4;
    
    productListVC.styleTypeName = self.searchBar.text;
    productListVC.conditionStr = self.searchBar.text;
    
    [self.navigationController pushViewController:productListVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//热门类目
- (IBAction)popularCategory:(id)sender {
    
    [MobClick event:@"reMenLeiMu"];
    HotCategoryViewController *hotCategoryVC = [[[HotCategoryViewController alloc ] initWithNibName:@"HotCategoryViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:hotCategoryVC animated:YES];
}
//热门品牌
- (IBAction)popularBrands:(id)sender{
    [MobClick event:@"reMenPinPai"];
    BrandsListViewController *brandVC = [[[BrandsListViewController alloc ]initWithNibName:@"BrandsListViewController" bundle:nil] autorelease];
    brandVC.type = 1;
    [self.navigationController pushViewController:brandVC animated:YES];
    
}
//商场
- (IBAction)nearbyShopping:(id)sender {
    [MobClick event:@"shangChangLieBiao"];
    BrandsListViewController *brandVC = [[[BrandsListViewController alloc ]initWithNibName:@"BrandsListViewController" bundle:nil] autorelease];
    brandVC.type = 2;
    [self.navigationController pushViewController:brandVC animated:YES];
    
}
//浏览
- (IBAction)history:(id)sender {
    
    [MobClick event:@"zuiJinLiuLan"];
    HistoryVC *history = [[[HistoryVC alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:history animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.searchBar resignFirstResponder];
}




- (void)dealloc {
    [_underButView release];
    [_hotWordsView release];
    [_hotwordsArray release];
    [_searchBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setUnderButView:nil];
    [self setHotWordsView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
