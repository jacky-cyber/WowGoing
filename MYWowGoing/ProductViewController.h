//
//  FirstViewController.h
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDataButton.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "JSON.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"
#import "MySettingViewController.h"
 
#import <CoreLocation/CoreLocation.h>


@interface ProductViewController : BaseController<UIScrollViewDelegate,EGORefreshTableHeaderDelegate,SDWebImageManagerDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    
    //get with tag is nil ,so create an proptery handler
    
    int             m_intOffset;

    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    int   nowPageNum;
    
    BOOL  isXiangGang;
    
    int rows;
    int cols;
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    BOOL isSelected;
    
    BOOL isNOData;
    ASIFormDataRequest *requestForm;

    BOOL adv;
    BOOL istableviewScrolldirection;//tableview滑动方向
    double shopL;//店铺对应的经度
    double shopLL;//店铺对应的纬度
    double myDistance;//相距的距离
}
@property (nonatomic, retain) IBOutlet UITableView *tableview_myTableView;

@property (retain, nonatomic) IBOutlet UIButton *qianggouBtn;
@property (retain, nonatomic) IBOutlet UIButton *zhekouBtn;
@property (retain, nonatomic) NSString  *cityName;

@property (retain,nonatomic) UIButton *btn_rightItem;
@property (retain,nonatomic)IBOutlet UIButton *btn_Man;
@property (retain,nonatomic)IBOutlet UIButton *btn_WoMan;
@property (retain,nonatomic)IBOutlet UIButton *btn_Price;
@property (retain,nonatomic)IBOutlet UIButton *btn_Discount;
@property(retain,nonatomic)IBOutlet UIView *view_title;
@property(retain,nonatomic) NSMutableArray *AllProducts;
@property (assign) BOOL isXianShi; //是否限时 限时抢购为yes 否则为no
@property (assign)BOOL isdraging;//是否列表拖拽


+(ProductViewController *)shareProduct;

-(void)activegoBookDetailsController:(UIDataButton *)buttonBook;

-(void)fristLoad;
-(void)reloadData:(NSString*)jsonString Add:(BOOL)isAdd;

-(void)toAllNewProduct;
//男装
-(IBAction)ManCloses:(id)sender;
//女装
-(IBAction)WoManCloses:(id)sender;
//价格从低到高
- (IBAction)priceLowToHighClick:(id)sender;
//折扣从高到低
- (IBAction)discountHighToLowAction:(id)sender;
- (IBAction)selectSegment:(id)sender;

@end
