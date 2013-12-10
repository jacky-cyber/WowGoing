//
//  AdproductListVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-4-24.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@interface AdproductListVC : BaseController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    int nowPageNum;
    BOOL isBottom;
    
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
   
    ASIFormDataRequest *requestForm;
    NSAutoreleasePool *pool;
}

@property (retain, nonatomic) IBOutlet UITableView *adProductTbale;
@property (retain, nonatomic) NSString *cityName;
@property(nonatomic,retain) NSString *advertisementId;
@property (retain, nonatomic) UILabel *lableName;
@property(nonatomic,retain) UIButton *btnFilter;
@property(nonatomic,retain)ASIFormDataRequest *requestForm;
@end
