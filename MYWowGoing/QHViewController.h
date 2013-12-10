//
//  QHViewController.h
//  MYWowGoing
//
//  Created by wkf on 12-12-18.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "BaseController.h"
#define CART_REQUEST_FRIST       3
#define CART_REQUEST_PAGE_UPDATE    1
#define CART_REQUEST_PAGE_NEXT   2
@class ShopIntroduceVC;
@interface QHViewController : BaseController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    int nowPageNum;
    
    MBProgressHUD   *HUD;
}
@property (retain, nonatomic) IBOutlet UIImageView *emptImageView;
@property (retain, nonatomic) IBOutlet UILabel *label1;
@property (retain, nonatomic) IBOutlet UILabel *label2;
@property (retain, nonatomic) IBOutlet UIButton *goShopBtn;

@property (retain, nonatomic) IBOutlet UILabel *promptlabel1;
@property (retain, nonatomic) IBOutlet UILabel *promptLabel2;
@property (retain, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (retain, nonatomic) IBOutlet UIButton *shoppingBtn;
@property (strong, nonatomic) ShopIntroduceVC *detailViewController;

@end
