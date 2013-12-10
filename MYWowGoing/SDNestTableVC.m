//
//  SDNestTableVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-4-13.
//
//

#import "SDNestTableVC.h"
#import "SDNestSubViewController.h"
 
 
#import "JSON.h"
#import "SearchRequestBS.h"

#import "ProductViewController.h"

#import "AppDelegate.h"

#define COLUMN 5

@interface SDNestTableVC ()

@property (strong, nonatomic) NSArray *cates;
@property (nonatomic,retain)NSMutableArray  *browseArray;
@property(nonatomic,retain) UIButton *clearBut; //清除按钮
@property(nonatomic,retain) UIButton *commitBut; //确定按钮
@property(nonatomic,retain) NSMutableDictionary *selectedItemDic;//存放已选择的搜索条件
@property(nonatomic,retain) NSMutableDictionary *selectItemNameDice;
@property(nonatomic,retain) NSMutableDictionary *colorDic; //存放颜色字典
@property(nonatomic,retain) NSMutableArray *itemArray;

@property (nonatomic,retain) NSIndexPath  *currentIndexPath;
@property (nonatomic,retain) NSMutableArray  *categoryArray;

@end

@implementation SDNestTableVC

@synthesize cates=_cates,browseArray=_browseArray,clearBut=_clearBut,commitBut=_commitBut,selectedItemDic=_selectedItemDic,colorDic=_colorDic,productType=_productType,itemArray=_itemArray,selectItemNameDice=_selectItemNameDice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
/*****************************
 方法名称:cates
 功能描述:从plist文件中获取数据
 传入参数:N/A
 传出参数:N/A
 返回值: NSArray * 返回数组
 */
- (NSArray *)cates
{
    if (_cates == nil){
        NSString *pathString = nil;
        switch (self.typeScreen) {
            case 1:
                pathString = [NSString stringWithFormat:@"CategoryShop"];
                break;
            case 2:
                pathString = [NSString stringWithFormat:@"CategoryBrand"];
                break;
            case 3:
                pathString = [NSString stringWithFormat:@"CategoryWithOutLeiBie"];
                break;
            case 4:
            case 5:
            case 6:
            case 8:
            case 9:
                  pathString = [NSString stringWithFormat:@"Category"];
                break;
            default:
                break;
        }
        NSURL *url = [[NSBundle mainBundle] URLForResource:pathString  withExtension:@"plist"];
        _cates = [[NSArray arrayWithContentsOfURL:url] retain];
    }
    
    return _cates;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedItemDic = [NSMutableDictionary dictionary];
    self.selectItemNameDice = [NSMutableDictionary dictionary];
    self.browseArray = [NSMutableArray array];
    self.categoryArray = [NSMutableArray array];
     
    for (int i=0;i<self.cates.count; i++) {
        [self.selectItemNameDice setValue:@"ALL" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.colorDic = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"NO",@"0",@"NO",@"1",@"NO",@"2",@"NO",@"3",@"NO",@"4",@"NO",@"5",@"NO",@"6",@"NO",@"7",@"NO",@"8",@"NO",@"9",@"NO",@"10",@"NO",@"11", nil] autorelease];
    self.itemArray = [NSMutableArray array];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSelector:)];

     swipe.direction = UISwipeGestureRecognizerDirectionRight;
     [self.tableView addGestureRecognizer:swipe];
     [swipe release];

}

/*****************************
 方法名称:handleSelector:(UISwipeGestureRecognizer*)sender
 功能描述:向右滑动手势触发的方法,主要是移除筛选界面,返回来页
 传入参数:(UISwipeGestureRecognizer*)sender
 传出参数:N/A
 返回值: N/A
 */
- (void)handleSelector:(UISwipeGestureRecognizer*)sender{
    
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
            
            UITableView *tableView = (UITableView*)[delegate.window viewWithTag:1871734];
            tableView.userInteractionEnabled=YES;
            
            [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
            
            UIButton *btn = (UIButton*)[delegate.window viewWithTag:19860922];
            
            UIButton *btnAD = (UIButton*)[delegate.window viewWithTag:19860923];
            
            if (btn != nil & btnAD != nil) {
                btnAD.selected = !btnAD.selected;
            }else{
                btn.selected = !btn.selected;
            }
        
        } completion:^(BOOL finished) {
            [self.tableView.superview removeFromSuperview];

            [self.tableView removeGestureRecognizer:sender];
        }];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [self requestData];

}
/*****************************
 方法名称:requestData
 功能描述:创建发送请求,请求筛选界面各个筛选条件下的子项数据
 传入参数:N/A
 传出参数:N/A
 返回值: N/A
 */
-(void)requestData
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }else
    {
        [common setValue:@"123@abc.com" forKey:@"loginId"];
        [common setValue:@"888888" forKey:@"password"];
    }
    
    //    0  品牌浏览  1.商场浏览 2.类别浏览 3.折扣浏览 4.颜色浏览  5.价格浏览 http://www.wowgoing.com/api/scan/list
    
    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/scan/list",SEVERURL];
    [jsonreq setValue:common forKey:@"common"];
    
    [jsonreq setValue:[Util getAdViewCity] forKey:@"cityName"];
    [jsonreq setValue:[Util getDeviceId] forKey: @"deviceId"];
    [jsonreq setValue:[NSNumber numberWithInt:1] forKey:@"pageNumber"];
    
    NSString *sbreq = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {//IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }else{
        SBJsonWriter *sbJsonWriter = [SBJsonWriter alloc];
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

    int responseStatus = [[[dic objectForKey:@"common"] objectForKey:@"responseStatus"] intValue];
    if (responseStatus != 200) {
        return;
    }
    
    NSMutableArray *brandsListArray = [dic objectForKey:@"brands"];
    NSMutableArray  *marketList = [dic objectForKey:@"marketListDto"];
    NSMutableArray *styleTypesListArray = [dic objectForKey:@"styleTypeList"];
    NSMutableArray  *discountDtoListArray = [dic objectForKey:@"discountDto"];
    NSMutableArray *priceDtoListArray = [dic objectForKey:@"priceDto"];
    
    //商场列表marketListDto   类别styleTypes  折扣discountDto   原价priceDto  品牌brands
    if (brandsListArray == nil || brandsListArray.count == 0)
    {
    }else{
        [Util SvaeBrandArray:brandsListArray];
    }
    if (marketList == nil ||marketList.count == 0) {
    }else{
        [Util SvaeMarketArray:marketList];
    }
    if (styleTypesListArray == nil ||styleTypesListArray.count == 0) {
    }else{
        [Util SvaeStyleTypesArray:styleTypesListArray];
    }
    if (discountDtoListArray == nil ||discountDtoListArray.count == 0) {
    }else{
        [Util SvaeDiscountArray:discountDtoListArray];
    }
    if (priceDtoListArray == nil ||priceDtoListArray.count == 0) {
    }else{
        [Util SvaePriceArray:priceDtoListArray];
    }

}


#pragma mark - Nested Tables methods

- (NSInteger)mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    return [self.cates count];
}

- (NSInteger)mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    int indexRow=indexPath.row;
    

    if (self.typeScreen == 1) {    //店铺入口
        if (indexRow == 0) {
             self.browseArray=[Util getBrandArray];
        }else if (indexRow ==1){
            self.browseArray=[Util getStyleTypesArray];

        }else if(indexRow == 2){
           self.browseArray=[Util getDiscountArray];
        }else if(indexRow == 3){
             self.browseArray=[Util getPriceArray];
        }else{
           return 1;
        }
    }else if (self.typeScreen ==2){  //品牌入口
        if (indexRow == 0) {
            self.browseArray=[Util getMarketArray];
        }else if (indexRow ==1){
            self.browseArray=[Util getStyleTypesArray];
        }else if(indexRow == 2){
            self.browseArray=[Util getDiscountArray];
        }else if(indexRow == 3){
           self.browseArray=[Util getPriceArray];
        }else{
            return 1;
        }
    }else if (self.typeScreen == 3){
     
        if (indexRow == 0) {
            self.browseArray=[Util getMarketArray];
        }else if (indexRow ==1){
             self.browseArray=[Util getBrandArray];
        }else if(indexRow == 2){
            self.browseArray=[Util getDiscountArray];
        }else if(indexRow == 3){
            self.browseArray=[Util getPriceArray];
        }else{
            return 1;
        }
    }else{    //其他
        if (indexRow == 0) {
            self.browseArray=[Util getMarketArray];
        }else if (indexRow ==1){
             self.browseArray=[Util getStyleTypesArray];
        }else if(indexRow == 2){
            self.browseArray=[Util getBrandArray];
        }else if(indexRow == 3){
            self.browseArray=[Util getDiscountArray];
        }else if (indexRow == 4){
            self.browseArray=[Util getPriceArray];
        }else if (indexPath.row == 5){
            return 1;
        }
}
    
        return self.browseArray.count;
}

- (SDGroupCell *)mainTable:(UITableView *)mainTable setItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cate = [self.cates objectAtIndex:indexPath.row];
    item.itemText.text = [cate objectForKey:@"name"];
    item.selectedItemName.text=[self.selectItemNameDice objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    return item;
}

- (SDSubCell *)item:(SDGroupCell *)item setSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *itemString=item.itemText.text;
   NSMutableArray *subArray;
    if ([itemString isEqualToString:@"商场"]) {
        subArray=[Util getMarketArray];
        subItem.itemText.text=[NSString stringWithFormat:@"%@",[[subArray objectAtIndex:indexPath.row] objectForKey:@"marketname"]];

    }else if ([itemString isEqualToString:@"类别"]){
        
        NSDictionary  *dic = [[Util getStyleTypesArray]  objectAtIndex:indexPath.row];
        NSString  *typeString = [dic objectForKey:@"styleTypeName"];
        
        item.flagImage.hidden = NO;
        
        if ([typeString isEqualToString:@"上装"]) {
            subItem.itemText.text = typeString;
            item.flagImage.image = [UIImage imageNamed:@"t恤.png"];
            
            if (item.opening0) {
                [self showAllStyleOnCell:subItem :self.categoryArray];
            }

            
        }else if ([typeString isEqualToString:@"裤装"]){
            
             subItem.itemText.text = typeString;
             item.flagImage.image = [UIImage imageNamed:@"牛仔裤.png"];
            
            if (item.opening4) {
                [self showAllStyleOnCell:subItem :self.categoryArray];
            }

        
        }else if ([typeString isEqualToString:@"内衣"]){
            subItem.itemText.text = typeString;
             item.flagImage.image = [UIImage imageNamed:@"文胸.png"];
            
            if (item.opening1) {
                [self showAllStyleOnCell:subItem :self.categoryArray];
            }
        
        }else if ([typeString isEqualToString:@"裙装"]){
            
            subItem.itemText.text = typeString;
             item.flagImage.image = [UIImage imageNamed:@"连衣裙.png"];
            
            if (item.opening3) {
                [self showAllStyleOnCell:subItem :self.categoryArray];
            }

            
        }else if ([typeString isEqualToString:@"包"]){
            
            subItem.itemText.text =typeString;

             item.flagImage.image = [UIImage imageNamed:@"手拎包.png"];
            
            if (item.opening2) {
                [self showAllStyleOnCell:subItem :self.categoryArray];
            }

            
        }else if ([typeString isEqualToString:@"鞋"]){
            subItem.itemText.text = typeString;

             item.flagImage.image = [UIImage imageNamed:@"休闲鞋.png"];
            
            if (item.opening6) {
                [self showAllStyleOnCell:subItem :self.categoryArray];
            }

            
        }else if ([typeString isEqualToString:@"配饰"]){
            
            subItem.itemText.text = typeString;
             item.flagImage.image = [UIImage imageNamed:@"手链.png"];
            
            if (item.opening5) {
                [self showAllStyleOnCell:subItem :self.categoryArray];
            }

        }
    }else if([itemString isEqualToString:@"品牌"]){
        subArray=[Util getBrandArray];
        subItem.itemText.text=[NSString stringWithFormat:@"%@",[[subArray objectAtIndex:indexPath.row] objectForKey:@"brandname"]];
    }
    else if ([itemString isEqualToString:@"折扣"]){
        subArray=[Util getDiscountArray];
        subItem.itemText.text=[NSString stringWithFormat:@"%@ 折",[[subArray objectAtIndex:indexPath.row] objectForKey:@"discount"]];
    }else if([itemString isEqualToString:@"价格"]){
        subArray=[Util getPriceArray];
        subItem.itemText.text=[NSString stringWithFormat:@"￥%@",
                           [[subArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
    }else if ([itemString isEqualToString:@"颜色"]){
        [subItem.itemText removeFromSuperview];
        [subItem.onCheckBox removeFromSuperview];
        [subItem.offCheckBox removeFromSuperview];
        
        NSDictionary *cate = nil;
        if (self.typeScreen ==1 || self.typeScreen == 2 || self.typeScreen == 3) {
             cate = [self.cates objectAtIndex:4];
        }else{
            cate = [self.cates objectAtIndex:5];
        }
        
        NSArray *colorArray=[cate objectForKey:@"subClass"];
    
        int total = colorArray.count;
        #define ROWHEIHT 25
        int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
        
        for (int i = 0; i< total; i++) {
            int row = i / COLUMN;
            int column = i % COLUMN;
            NSDictionary *data = [colorArray objectAtIndex:i];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(25*column+20*column+20, ROWHEIHT*row+20*row+20, 25, ROWHEIHT);
            btn.tag = i*5+10000;
            
            NSString *string=[self.colorDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            
            if ([string isEqualToString:@"YES"]) {
             [btn setBackgroundImage:[UIImage imageNamed:[[data objectForKey:@"name"] stringByAppendingFormat:@"-选中.png"]] forState:UIControlStateNormal];
              btn.selected=YES;
            }else{
              [btn setBackgroundImage:[UIImage imageNamed:[[data objectForKey:@"name"] stringByAppendingFormat:@".png"]]
                               forState:UIControlStateNormal];
            }
            
            [btn addTarget:self action:@selector(colorAction:) forControlEvents:UIControlEventTouchUpInside];
            [subItem addSubview:btn];
            
        }
        
        CGRect viewFrame = subItem.frame;
        viewFrame.size.height = ROWHEIHT * rows+20*4;
        subItem.frame = viewFrame;
        
        item.fengexian.hidden=YES;
    }
    
    return subItem;
}

- (void) mainTable:(UITableView *)mainTable itemDidChange:(SDGroupCell *)item
{
    SelectableCellState state = item.selectableCellState;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:item];
    switch (state) {
        case Checked:
            break;
        case Unchecked:
           
            break;

        default:
            break;
    }
}

- (void) item:(SDGroupCell *)item subItemDidChange:(SDSelectableCell *)subItem
{
    SelectableCellState state = subItem.selectableCellState;
    
    switch (state) {
        case Checked:
        {
            item.selectedItemName.text=subItem.itemText.text;
            NSIndexPath *index=[self.tableView indexPathForCell:item];
            NSIndexPath *subIndex=[item.subTable indexPathForCell:subItem];
            NSString *selcetedItem = nil;
            if ([item.itemText.text isEqualToString:@"商场"]) {
                selcetedItem=[[[Util getMarketArray] objectAtIndex:subIndex.row] objectForKey:@"marketid"];
            }else if ([item.itemText.text isEqualToString:@"类别"]){
                
                int count = [Util getStyleTypesArray].count;
                
                for (int i = 0; i < count ; i ++) {
                    NSDictionary *styDic = [[Util getStyleTypesArray] objectAtIndex:i];
                    NSString *typeString = [styDic objectForKey:@"styleTypeName"];
                    if ([typeString isEqualToString:subItem.itemText.text]) {
                        
                        if ([typeString isEqualToString:@"上装"]) {
                            self.categoryArray = [styDic objectForKey:@"upClothes"];
                            
                            item.opening0 = YES;
                            item.opening1 = NO;
                            item.opening2= NO;
                            item.opening3 = NO;
                            item.opening4 = NO;
                            item.opening5 =NO;
                            item.opening6 = NO;
                            item.count = self.categoryArray.count;
                            
                        }else if ([typeString isEqualToString:@"裤装"]){
                            
                            item.opening4 = YES;
                            item.opening0 = NO;
                            item.opening1 = NO;
                            item.opening2= NO;
                            item.opening3 = NO;
                            item.opening5 =NO;
                            item.opening6 = NO;
                            
                            self.categoryArray = [styDic objectForKey:@"downClothes"];
                             item.count = self.categoryArray.count;
                            
                            
                        }else if ([typeString isEqualToString:@"内衣"]){
                            
                            item.opening1 = YES;
                            item.opening4 = NO;
                            item.opening0 = NO;
                            item.opening2= NO;
                            item.opening3 = NO;
                            item.opening5 =NO;
                            item.opening6 = NO;

                            self.categoryArray = [styDic objectForKey:@"underwaistList"];
                            item.count = self.categoryArray.count;

                            
                           
                        }else if ([typeString isEqualToString:@"裙装"]){
                            
                            item.opening3 = YES;
                            item.opening4 = NO;
                            item.opening0 = NO;
                            item.opening1 = NO;
                            item.opening2= NO;
                            
                            item.opening5 =NO;
                            item.opening6 = NO;

                           self.categoryArray = [styDic objectForKey:@"dressList"];
                            item.count = self.categoryArray.count;

                            
                        }else if ([typeString isEqualToString:@"包"]){
                            
                            item.opening2 = YES;
                            item.opening3 = NO;
                            item.opening4 = NO;
                            item.opening0 = NO;
                            item.opening1 = NO;
                            item.opening5 =NO;
                            item.opening6 = NO;

                            
                            self.categoryArray = [styDic objectForKey:@"Bag"];
                             item.count = self.categoryArray.count;
                            
                        }else if ([typeString isEqualToString:@"鞋"]){
                            
                            item.opening6 = YES;
                            item.opening2 = NO;
                            item.opening3 = NO;
                            item.opening4 = NO;
                            item.opening0 = NO;
                            item.opening1 = NO;
                            item.opening5 =NO;
                            self.categoryArray = [styDic  objectForKey:@"shooseList"];
                             item.count = self.categoryArray.count;
                        }else if ([typeString isEqualToString:@"配饰"]){
                            
                            item.opening5 = YES;
                            item.opening2 = NO;
                            item.opening3 = NO;
                            item.opening4 = NO;
                            item.opening0 = NO;
                            item.opening1 = NO;
                            item.opening6 = NO;

                            self.categoryArray = [styDic objectForKey:@"ornamentList"];
                            item.count = self.categoryArray.count;
                        }

                        break;
                    }
                }
        
            }else if ([item.itemText.text isEqualToString:@"品牌"]){
            
                selcetedItem=[[[Util getBrandArray] objectAtIndex:subIndex.row] objectForKey:@"brandid"];
            
            }else if ([item.itemText.text isEqualToString:@"折扣"]){
                
                selcetedItem=[[[Util getDiscountArray] objectAtIndex:subIndex.row] objectForKey:@"discount"];
            }else if ([item.itemText.text isEqualToString:@"价格"]){
            
                selcetedItem=[[[Util getPriceArray] objectAtIndex:subIndex.row] objectForKey:@"price"];
            }
            else {
                selcetedItem=[NSString stringWithFormat:@""];
            }
            
            [self.selectedItemDic setValue:selcetedItem forKey:item.itemText.text];
            
            [self.selectItemNameDice setValue:subItem.itemText.text forKey:[NSString stringWithFormat:@"%d",index.row]];
            
            [self collapsableTapped:index];
        }
            
            break;
        case Unchecked:
        {
            NSIndexPath *index=[self.tableView indexPathForCell:item];
            NSString *selcetedItem=[NSString string];

            if ([item.itemText.text isEqualToString:@"颜色"]) {
                NSDictionary *cate = [self.cates objectAtIndex:index.row];
                NSMutableArray *array=[NSMutableArray arrayWithArray:[cate objectForKey:@"subClass"]];
                
                NSArray *arrayColor=[self.colorDic allKeys];
                
                for (int i = 0; i< arrayColor.count; i++) {
                    NSString *string=[self.colorDic objectForKey:[self.colorDic.allKeys objectAtIndex:i]];
                    if ([string isEqualToString:@"YES"]) {
                        NSDictionary *subCate = [array  objectAtIndex:[[self.colorDic.allKeys objectAtIndex:i] integerValue]];
                        selcetedItem = [subCate objectForKey:@"name"];
                        item.selectedItemName.text=selcetedItem;
                    }
                }
                if (selcetedItem == nil || [selcetedItem isEqualToString:@""]) {
                    selcetedItem=[NSString stringWithFormat:@"ALL"];
                }
                
               [self.selectedItemDic setValue:selcetedItem forKey:item.itemText.text];
                
                [self.selectItemNameDice setValue:selcetedItem forKey:[NSString stringWithFormat:@"%d",index.row]];
               [self collapsableTapped:index];
            }else{
            
                NSString *typeString =subItem.itemText.text;
                
                if ([typeString isEqualToString:subItem.itemText.text]) {
                    
                    if ([typeString isEqualToString:@"上装"]) {
                    
                        item.opening0 = NO;
                        item.count = 0;
                        
                        [self removeStyleButtonOnCell:subItem];
                    
                    }else if ([typeString isEqualToString:@"裤装"]){
                        
                        item.opening4 = NO;
                        
                        item.count =0;
                        
                        [self removeStyleButtonOnCell:subItem];

                    }else if ([typeString isEqualToString:@"内衣"]){
                        
                        item.opening1 = NO;
                
                        item.count = 0;
                        
                        [self removeStyleButtonOnCell:subItem];

                    }else if ([typeString isEqualToString:@"裙装"]){
                        
                        item.opening3 = NO;
                        item.count = 0;
                        [self removeStyleButtonOnCell:subItem];

                    }else if ([typeString isEqualToString:@"包"]){
                        
                        item.opening2 = NO;
                        item.count = 0;
                        [self removeStyleButtonOnCell:subItem];

                    }else if ([typeString isEqualToString:@"鞋"]){
                        
                        item.opening6 = NO;
                        item.count =0;
                        [self removeStyleButtonOnCell:subItem];

                    }else if ([typeString isEqualToString:@"配饰"]){
                        
                        item.opening5 = NO;
                        item.count = 0;
                        [self removeStyleButtonOnCell:subItem];

                    }

                }

                item.selectedItemName.text=[NSString stringWithFormat:@"ALL"];
                [self.selectedItemDic removeObjectForKey:item.itemText.text];
                [self.selectItemNameDice setValue:@"ALL" forKey:[NSString stringWithFormat:@"%d",index.row]];
                [self collapsableTapped:index];
            }
        }
            break;
        default:
            break;
    }
}

- (void)expandingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
   
    
}

- (void)collapsingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)collapsableTapped:(NSIndexPath*)index{
    
    UITableView *tableView = self.tableView;
    NSIndexPath * indexPath = index;
    if ( indexPath == nil )
        return;
    
    if ([[self.expandedIndexes objectForKey:indexPath] boolValue]) {
        [self collapsingItem:(SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath] withIndexPath:indexPath];
    } else {
        [self expandingItem:(SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath] withIndexPath:indexPath];
    }
    
    SDGroupCell * groupCell = (SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (groupCell.opening0 || groupCell.opening1 || groupCell.opening2  || groupCell.opening3 || groupCell.opening4 || groupCell.opening5 || groupCell.opening6) {

    }else{
        
        BOOL isExpanded = ![[self.expandedIndexes objectForKey:indexPath] boolValue];
        NSNumber *expandedIndex = [NSNumber numberWithBool:isExpanded];
        [self.expandedIndexes setObject:expandedIndex forKey:indexPath];
        
        }
//  [self.tableView beginUpdates];
//  [self.tableView endUpdates];
    
    [self.tableView reloadData];
    
}

#pragma mark
#pragma mark  *************选取颜色后触发的方法***********
- (void)colorAction:(UIButton*)sender{
    
    int index=(sender.tag-10000)/5;
    SDGroupCell *cell = nil;
    if (self.typeScreen == 1 || self.typeScreen ==2 || self.typeScreen == 3 ) {
        cell=(SDGroupCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    }else{
        cell=(SDGroupCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    }

    SDSubCell *subCell=(SDSubCell*)[cell.subTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (sender.selected) {
        sender.selected=NO;
        [self.colorDic setValue:@"NO" forKey:[NSString stringWithFormat:@"%d",index]];
        
        cell.selectedItemName.text=[NSString stringWithFormat:@"ALL"];
        
    }else{
        
        NSArray *colorArray=[self.colorDic allKeys];
        for (int i = 0;i< colorArray.count;i++) {
            NSString *_isSelected=[self.colorDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            if ([_isSelected isEqualToString:@"YES"]) {
                [self.colorDic setValue:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
                
                UIButton *button=(UIButton*)[self.tableView viewWithTag:i*5+10000];
                button.selected=NO;
            }
        }
        sender.selected=YES;
    
        [self.colorDic setValue:@"YES" forKey:[NSString stringWithFormat:@"%d",index]];

    }
    if (self.typeScreen == 1 || self.typeScreen ==2  || self.typeScreen == 3) {
        [self groupCell:cell didSelectSubCell:subCell withIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] andWithTap:YES];
    }else{
         [self groupCell:cell didSelectSubCell:subCell withIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] andWithTap:YES];
    }

}


#pragma mark
#pragma mark   UITableViewDelegate   确认和清除按钮布局
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 105;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 105)];
    
    self.clearBut=[UIButton buttonWithType:UIButtonTypeCustom];
  
    self.clearBut.frame=CGRectMake(20, 55, 94, 30);

    [self.clearBut setImage:[UIImage imageNamed:@"qingchu.png"] forState:UIControlStateNormal];
    [self.clearBut addTarget:self action:@selector(clearSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.clearBut];
    
    self.commitBut=[UIButton buttonWithType:UIButtonTypeCustom];

    self.commitBut.frame=CGRectMake(137,55, 94, 30);
    
     [self.commitBut setImage:[UIImage imageNamed:@"queding.png"] forState:UIControlStateNormal];
    [self.commitBut addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.commitBut];
    
    return [view autorelease];
}

#pragma mark
#pragma mark  *************确认按钮方法***********
- (void)sureAction:(UIButton*)sender{
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    NSString *market=[self.selectedItemDic objectForKey:@"商场"];
    NSString *type=[self.selectedItemDic objectForKey:@"类别"];
    NSString *brand=[self.selectedItemDic objectForKey:@"品牌"];
    NSString *discount=[self.selectedItemDic objectForKey:@"折扣"];
    NSString *price=[self.selectedItemDic objectForKey:@"价格"];
    NSString *color=[self.selectedItemDic objectForKey:@"颜色"];
    
    if (self.selectedItemDic.allValues.count == 0 || self.selectedItemDic == nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"购引提示" message:@"尊敬的用户,请先选择您要筛选的条件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }else{
        if (![market isEqualToString:@""]) {
            [parameterDic setValue:market forKey:@"marketID"];}
        if(![type isEqualToString:@""]){
            
            if ([type isEqualToString:@"上装"]) {
                 [parameterDic setValue:@"1" forKey:@"type"];
            }else if ([type isEqualToString:@"内衣"]){
                [parameterDic setValue:@"10" forKey:@"type"];
            }else if([type isEqualToString:@"包"]){
                [parameterDic setValue:@"6" forKey:@"type"];
            }else if([type isEqualToString:@"裙装"]){
                [parameterDic setValue:@"2" forKey:@"type"];
            }else if([type isEqualToString:@"裤装"]){
                [parameterDic setValue:@"3" forKey:@"type"];
            }else if ([type isEqualToString:@"配饰"]){
                 [parameterDic setValue:@"4" forKey:@"type"];
            }else if([type isEqualToString:@"鞋"]){
                  [parameterDic setValue:@"5" forKey:@"type"];
            }else{
                  [parameterDic setValue:type forKey:@"styleTypeName"];
            }
        }

       if(![brand isEqualToString:@""]){
         [parameterDic setValue:brand forKey:@"brandId"];}
        if (![discount isEqualToString:@""]) {
          [parameterDic setValue:discount forKey:@"searchdiscountKey"];
        }
        if (![price isEqualToString:@""]) {
            [parameterDic setValue:price forKey:@"searchpriceKey"];
        }
        if (![color isEqualToString:@""]) {
            [parameterDic setValue:color forKey:@"colorName"];
        }
        [parameterDic setValue:self.productType forKey:@"productType"];
    
    }
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString    *valueStr  in [self.selectItemNameDice  allValues]) {
        if (![valueStr isEqualToString:@"ALL"]) {
            [valueArray addObject:valueStr];
        }
    }
    
    [parameterDic setValue:[valueArray componentsJoinedByString:@"/"] forKey:@"conditionStr"];
    
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UITableView *tableView=(UITableView*)[delegate.window viewWithTag:1871734];
    tableView.userInteractionEnabled=YES;
    
    if (self.typeScreen == 6) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shaixuan" object:parameterDic];

        }else  if (self.typeScreen ==5 ||self.typeScreen ==4){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shaixuanProduct" object:parameterDic];
        
        }else {
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shaixuanProductList" object:parameterDic];

        }
     delegate.window.frame = CGRectMake(0, 0, 320, IPHONE_HEIGHT);
    
     [self.tableView.superview removeFromSuperview];
    [LKCustomTabBar shareTabBar].btn4.userInteractionEnabled=YES;
    
}


#pragma mark
#pragma mark  *************清除按钮方法***********
- (void)clearSelectedItem:(UIButton*)sendert{
    
    [self.selectedItemDic removeAllObjects];
    
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0] ; i++){
        SDGroupCell *cell=(SDGroupCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (![cell.selectedItemName.text isEqualToString:@"ALL"]) {
            cell.selectedItemName.text=[NSString stringWithFormat:@"ALL"];
            
            [self.selectItemNameDice setValue:@"ALL" forKey:[NSString stringWithFormat:@"%d",i]];
            
            if (i != [self.tableView numberOfRowsInSection:0] - 1) {
                for (int j = 0; j < [cell.subTable numberOfRowsInSection:0] ; j++) {
                    SDSubCell *subCell=(SDSubCell*)[cell.subTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:j inSection:0]];
                    subCell.offCheckBox.hidden=YES;
                    
                    [[self.selectableSubCellsState objectForKey:[NSIndexPath indexPathForItem:i inSection:0]] setObject:[NSNumber numberWithInt:0] forKey:[NSIndexPath indexPathForItem:j inSection:0]];
                    
                    [cell.subTable reloadData];

                }
            }else{
                NSDictionary *cate = [self.cates objectAtIndex:i];
                NSMutableArray *array=[cate objectForKey:@"subClass"];
                            
                for (int k = 0; k< array.count ; k++) {
                    
                    UIButton *colorBtn=(UIButton*)[cell.subTable viewWithTag:k*5+10000];
                    colorBtn.selected=NO;
                    [colorBtn setImage:[UIImage imageNamed:[[[array objectAtIndex:k] objectForKey:@"name"] stringByAppendingFormat:@".png"]] forState:UIControlStateNormal];
                    
                    [self.colorDic setValue:@"NO" forKey:[NSString stringWithFormat:@"%d",k]];
                    
                    [cell.subTable reloadData];
                    
               }
            }
        }
    }
}


#pragma mark
#pragma mark  *************点击类别展示明细***********
#define ROW_COUNT   3
- (void) showAllStyleOnCell:(SDSubCell*)groupCll :(NSMutableArray*)styleArray {

    int count = styleArray.count;
    
    int lineCount = 0;
    
    if (count%ROW_COUNT !=0) {
        lineCount = count/ROW_COUNT + 1;
    }else{
        lineCount = count/ROW_COUNT;
    }
    
    int loopCount = 0;
    
    for (int i = 0;  i < lineCount ; i ++) {
        for (int j = 0; j < ROW_COUNT ; j++) {
            
            if (loopCount > count - 1) {
                break;
            }
            
            NSDictionary *dic = [styleArray objectAtIndex:loopCount];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(50+ 60*j,  50 +35 * i, 60, 35);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:[dic objectForKey:@"SubName"] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
            [button addTarget:self action:@selector(styleButtonPressAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = loopCount + 10000;
            [groupCll addSubview:button];
            loopCount ++;
        }
    }
    
    UIImageView   *xuXianImage =  [[UIImageView alloc ] initWithFrame:CGRectMake(57, 50 +lineCount*buttonHeight, 263, 1)];
    xuXianImage.image = [UIImage imageNamed:@"长.png"];
    [groupCll addSubview:xuXianImage];
    [xuXianImage release];
    
}


#pragma mark
#pragma mark  *************清除类别明细按钮***********
- (void) removeStyleButtonOnCell:(SDSelectableCell*) subCell{
    
    for (UIButton  *button  in [subCell subviews]) {
        [button     removeFromSuperview];
    }
}



#pragma mark
#pragma mark  *************类别明细按钮点击后触发的方法***********
- (void) styleButtonPressAction:(UIButton*)sender{
    
    SDGroupCell  *groupCell =(SDGroupCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    if (groupCell.opening0) {
        if ([sender.titleLabel.text isEqualToString:@"ALL"]) {
            [self.selectedItemDic setValue:@"上装"  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:@"上装"  forKey:[NSString stringWithFormat:@"%d",1]];
        }else{
            [self.selectedItemDic setValue:sender.titleLabel.text  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:sender.titleLabel.text forKey:[NSString stringWithFormat:@"%d",1]];
        }
    }else if (groupCell.opening1){
        if ([sender.titleLabel.text isEqualToString:@"ALL"]) {
            [self.selectedItemDic setValue:@"内衣"  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:@"内衣"  forKey:[NSString stringWithFormat:@"%d",1]];
        }else{
            [self.selectedItemDic setValue:sender.titleLabel.text  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:sender.titleLabel.text  forKey:[NSString stringWithFormat:@"%d",1]];
        }
    }else if (groupCell.opening2){
        
        if ([sender.titleLabel.text isEqualToString:@"ALL"]) {
            [self.selectedItemDic setValue:@"包"  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:@"包"  forKey:[NSString stringWithFormat:@"%d",1]];
        }else{
            [self.selectedItemDic setValue:sender.titleLabel.text  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:sender.titleLabel.text  forKey:[NSString stringWithFormat:@"%d",1]];
        }
        
        
    }else if (groupCell.opening3){
        if ([sender.titleLabel.text isEqualToString:@"ALL"]) {
            [self.selectedItemDic setValue:@"裙装"  forKey:groupCell.itemText.text];
             [self.selectItemNameDice setValue:@"裙装"  forKey:[NSString stringWithFormat:@"%d",1]];
        }else{
            [self.selectedItemDic setValue:sender.titleLabel.text  forKey:groupCell.itemText.text];
             [self.selectItemNameDice setValue:sender.titleLabel.text  forKey:[NSString stringWithFormat:@"%d",1]];
        }
        
    }else if (groupCell.opening4){
        if ([sender.titleLabel.text isEqualToString:@"ALL"]) {
            [self.selectedItemDic setValue:@"裤装"  forKey:groupCell.itemText.text];
             [self.selectItemNameDice setValue:@"裤装"  forKey:[NSString stringWithFormat:@"%d",1]];
        }else{
            [self.selectedItemDic setValue:sender.titleLabel.text  forKey:groupCell.itemText.text];
             [self.selectItemNameDice setValue:sender.titleLabel.text forKey:[NSString stringWithFormat:@"%d",1]];
        }
    }else if (groupCell.opening5){
        if ([sender.titleLabel.text isEqualToString:@"ALL"]) {
            [self.selectedItemDic setValue:@"配饰"  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:@"配饰"  forKey:[NSString stringWithFormat:@"%d",1]];
        }else{
            [self.selectedItemDic setValue:sender.titleLabel.text  forKey:groupCell.itemText.text];
           [self.selectItemNameDice setValue:sender.titleLabel.text forKey:[NSString stringWithFormat:@"%d",1]];
        }
    }else if(groupCell.opening6){
        if ([sender.titleLabel.text isEqualToString:@"ALL"]) {
            [self.selectedItemDic setValue:@"鞋"  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:@"鞋"  forKey:[NSString stringWithFormat:@"%d",1]];
        }else{
            [self.selectedItemDic setValue:sender.titleLabel.text  forKey:groupCell.itemText.text];
            [self.selectItemNameDice setValue:sender.titleLabel.text forKey:[NSString stringWithFormat:@"%d",1]];
        }
    }
    
    if (groupCell.opening0 || groupCell.opening1 || groupCell.opening2  || groupCell.opening3 || groupCell.opening4 || groupCell.opening5 || groupCell.opening6) {
        
        groupCell.opening5 = NO;
        groupCell.opening2 = NO;
        groupCell.opening3 = NO;
        groupCell.opening4 = NO;
        groupCell.opening0 = NO;
        groupCell.opening1 = NO;
        groupCell.opening6 = NO;
    }
    
    [self collapsableTapped:[NSIndexPath indexPathForRow:1 inSection:0]];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_categoryArray release];
    [_currentIndexPath release];
    [_browseArray release];
    [_cates release];
    [_clearBut release];
    [_commitBut release];
    [_selectedItemDic release];
    [_colorDic release];
    [_productType release];
    [_itemArray release];
    [_selectItemNameDice release];
    [super dealloc];

}
@end
