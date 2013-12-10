//
//  MembershipCardVC.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-7-29.
//
//

#import "MembershipCardVC.h"
#import "Cell.h"
#import "SubCateViewController.h"
#import "AddMemberCardViewController.h"
#import "MyMembershipCardBS.h"
#import "UIImageView+WebCache.h"

@interface MembershipCardVC ()
@property (strong, nonatomic) NSArray *memberListArray;
@property (strong, nonatomic) NSMutableArray *activityList;
@property (assign) int num;
@end

@implementation MembershipCardVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         UIButton *addMember = [UIButton buttonWithType:UIButtonTypeCustom];
        [addMember setFrame:CGRectMake(10, 6, 33, 32)];;
        [addMember addTarget:self action:@selector(AddMembershipAction:) forControlEvents:UIControlEventTouchUpInside];
        [addMember setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        UIBarButtonItem *litem1 = [[UIBarButtonItem alloc] initWithCustomView:addMember];
        self.navigationItem.rightBarButtonItem = litem1;
        [litem1 release];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 6, 52, 32)];
        [backBtn addTarget:self action:@selector(back) forControlEvents:  UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
        UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = litem;
        [litem release];
        self.title = @"我的会员卡";
//        self.memberListArray = [NSArray array];

    }
    return self;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)AddMembershipAction:(id)sender {
    
    AddMemberCardViewController *addMembeView = [[[AddMemberCardViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:addMembeView animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _num = 0;
    [self membershipCardList];
    self.isOpen = NO;
}

- (void)viewDidLoad
{
//    _num = 0;
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
//    [self membershipCardList];
//    self.isOpen = NO;

    // Do any additional setup after loading the view from its nib.
}
- (void)membershipCardList {
    MyMembershipCardBS *mebBS = [[[MyMembershipCardBS alloc] init] autorelease];
    mebBS.delegate = self;
    mebBS.username = [Util getLoginName];
    mebBS.password = [Util getPassword];
    mebBS.onFaultSeletor = @selector(memberFault:);
    mebBS.onSuccessSeletor = @selector(mebSuccess:);
    [mebBS asyncExecute];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)mebSuccess:(ASIHTTPRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)request;
    NSMutableDictionary *dic=nil;
    NSError *error=nil;
    if (requestForm.responseData.length>0) {
        
        dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];
    }else{
        return;
    }
    if (error) {
        return;
    }
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    if (!resultStatus)
    {
        NSLog(@"返回结果错误");
        return;
    }
    
    //取出会员卡列表数据
    NSArray *memberArr = [dic objectForKey:@"membershipCardList"];
    self.memberListArray = memberArr;
    [self showtMemberImageOnSrollView:_memberListArray];
    _specialoffersLabel.text = [[memberArr objectAtIndex:0] objectForKey:@"specialoffers"];
    [_tableView reloadData];

}

- (void)specialoffersTitle:(int)num {
    _specialoffersLabel.text = [[self.memberListArray objectAtIndex:num] objectForKey:@"specialoffers"];
}

- (void)memberFault:(ASIHTTPRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_memberCartScroller release];
    [_tableView release], _tableView = nil;
    [_selectIndex release],_selectIndex = nil;
    [_memberCartPageControl release];
    [_memberPageControl release];
    [_memberListArray release];
    [_specialoffersLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMemberCartScroller:nil];
    [self setMemberCartPageControl:nil];
    [self setMemberPageControl:nil];
    [self setSpecialoffersLabel:nil];
    [super viewDidUnload];
}

- (void) showtMemberImageOnSrollView:(NSArray *)productImageArray{
    
    if (!productImageArray || ![productImageArray isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    
    [_memberCartScroller setContentSize:CGSizeMake(_memberCartScroller.frame.size.width * productImageArray.count , 133)];//设置————ScrollView滚动范围
    _memberCartScroller.clipsToBounds = NO;
    _memberCartScroller.delegate = self;
    _memberPageControl.currentPage = 0;
    for (int i = 0; i < productImageArray.count; i++) {
        //创建图片
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake((_memberCartScroller.frame.size.width)*i + (_memberCartScroller.frame.size.width-226)/2, 0,226, 133)];
//        UILabel *labelNumberCard = [[[UILabel alloc] initWithFrame:CGRectMake((_memberCartScroller.frame.size.width)*i + (_memberCartScroller.frame.size.width-226)/2 - 278, imageview.frame.size.height-95/2,200, 30)] autorelease];
        UILabel *labelNumberCard = [[[UILabel alloc] initWithFrame:CGRectMake(45, imageview.frame.size.height-95/2,200, 30)] autorelease];
        labelNumberCard.backgroundColor = [UIColor clearColor];
        labelNumberCard.font = [UIFont systemFontOfSize:14];
        labelNumberCard.textAlignment = UITextAlignmentLeft;
//        labelNumberCard.textColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:255.0/255.0 alpha:1.0];
        labelNumberCard.textColor = [UIColor whiteColor];
        labelNumberCard.text = [[productImageArray objectAtIndex:i] objectForKey:@"membershipNumber"];
        NSLog(@"卡号：%@",labelNumberCard.text);
        [imageview setImageWithURL:[NSURL URLWithString:[[productImageArray objectAtIndex:i] objectForKey:@"membershopPic"]] placeholderImage:nil];
        NSLog(@"会员卡图片%@", [NSURL URLWithString:[[productImageArray objectAtIndex:i] objectForKey:@"membershopPic"]]);
        imageview.userInteractionEnabled = YES;
        [_memberCartScroller addSubview:imageview];
        [imageview addSubview:labelNumberCard];
        [imageview release];
    }
    
    //设置PageControl页数
    [_memberPageControl setNumberOfPages:productImageArray.count];
    
}


#pragma mark
#pragma mark   UIScrollViewDelegate M
/*
 方法名称:scrollViewDidScroll:(UIScrollView *)scrollView
 功能描述: 在scrollView的代理方法中修改pageControl的坐标
 传入参数:(UIScrollView *)scrollView
 传出参数：N/A
 返回值:N/A
 */
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.memberPageControl.currentPage = scrollView.contentOffset.x/_memberCartScroller.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _memberCartScroller) {
        self.memberPageControl.currentPage = scrollView.contentOffset.x/_memberCartScroller.frame.size.width;
        _num = self.memberPageControl.currentPage;
        [self specialoffersTitle:_num];
        [self.tableView reloadData];
               
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *memberActivityListArray;
//    for (int i = 0; i < self.memberListArray.count; i++) {
        memberActivityListArray =  [[self.memberListArray objectAtIndex:_num] objectForKey:@"memberActivityList"];
//    }
    return memberActivityListArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCell = @"Cell";
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:customCell];
    
    if (cell == nil) {
        //如果没有可重用的单元，我们就从nib里面加载一个，
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell"
                                                     owner:self options:nil];
        //迭代nib重的所有对象来查找NewCell类的一个实例
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[Cell class]]) {
                cell = (Cell *)oneObject;
            }
        }
        
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }

//    [_dataList retain];
    NSArray *activityListDic = [[self.memberListArray objectAtIndex:_num] objectForKey:@"memberActivityList"];
    NSMutableArray *avtivityArray = [NSMutableArray array];
    
    for (int i = 0; i < activityListDic.count; i++) {
        NSMutableDictionary *activitySmallDic = [NSMutableDictionary dictionary];
        NSString *activityTitleString =  [[activityListDic objectAtIndex:i] objectForKey:@"activityTitle"];
        NSString *activitySmallTile =  [[activityListDic objectAtIndex:i] objectForKey:@"activitySmallTile"];
        NSString *activityDetailString = [[activityListDic objectAtIndex:indexPath.row] objectForKey:@"activityDetail"];
        [activitySmallDic setValue:activityTitleString forKey:@"activityTitle"];
        [activitySmallDic setValue:activitySmallTile forKey:@"activitySmallTile"];
        [activitySmallDic setValue:activityDetailString forKey:@"activityDetail"];
        [avtivityArray addObject:activitySmallDic];
        NSLog(@"%@",activityTitleString);
    }
    
    cell.titleLabel.text = [[avtivityArray objectAtIndex:indexPath.row] objectForKey:@"activityTitle"];
    cell.activitySmallTile.text = [[avtivityArray objectAtIndex:indexPath.row] objectForKey:@"activitySmallTile"];
    [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView performClose];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [cell changeArrowWithUp:YES];
    SubCateViewController *subVc = [[[SubCateViewController alloc]
                                    initWithNibName:NSStringFromClass([SubCateViewController class])
                                    bundle:nil] autorelease];
    NSArray *activityListDic = [[self.memberListArray objectAtIndex:_num] objectForKey:@"memberActivityList"];
    NSString *titileString = [[activityListDic objectAtIndex:indexPath.row] objectForKey:@"activityDetail"];
    subVc.Info = titileString;
    //NSDictionary *cate = [self.cates objectAtIndex:indexPath.row];
    //self.currentCate = cate;
    self.tableView.scrollEnabled = YES;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    folderTableView.cardBool = YES;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
//                                     [self CloseAndOpenACtion:indexPath];
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
//                                    [self CloseAndOpenACtion:indexPath];
//                                    [cell changeArrowWithUp:NO];
                                }
                           completionBlock:^{
                               // completed actions
                               self.tableView.scrollEnabled = YES;
                               [cell changeArrowWithUp:NO];
                           }];
}

-(void)CloseAndOpenACtion:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectIndex]) {
        self.isOpen = NO;
        [self didSelectCellRowFirstDo:NO nextDo:NO];
        self.selectIndex = nil;
    }
    else
    {
        if (!self.selectIndex) {
            self.selectIndex = indexPath;
            [self didSelectCellRowFirstDo:YES nextDo:NO];
            
        }
        else
        {
            [self didSelectCellRowFirstDo:NO nextDo:YES];
        }
    }
}
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell *cell = (Cell *)[self.tableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}



@end
