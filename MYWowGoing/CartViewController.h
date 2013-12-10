//
//  SecondViewController.h
//  MYWowGoing
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "CustomAlertView.h"

#import "MBProgressHUD.h"
 
#import "CartListCell.h"

#import "ProductViewController.h"

#define CART_REQUEST_FRIST       3
#define CART_REQUEST_PAGE_UPDATE    1
#define CART_REQUEST_PAGE_NEXT   2

#define CART_TIME   2700

@interface CartViewController : BaseController<EGORefreshTableHeaderDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    UIView       *emptyCartView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    int nowPageNum;
    
    BOOL   isDidLoad;
    
    UIImageView *inPutboxImage;//电话录入视图
    UIImageView *promptBox;//录入电话成功后的提示框
    
    UIButton *doneInKeyboardButton;

    BOOL _isdelete;
    
}
@property (nonatomic ,retain) IBOutlet UIView *emptyCartView;
@property (nonatomic ,assign)  BOOL   isDidLoad;

@property (retain, nonatomic) IBOutlet UIButton *payByOnline;//在线支付
@property (retain, nonatomic) IBOutlet UIButton *payByToshop;//到店支付

@property (nonatomic,retain) UITableView *cartTable;//显示购物车中的商品
@property (nonatomic,retain) NSMutableArray *productsPayOnline;//在线支付商品
@property (nonatomic,retain) NSMutableArray *productsPayToShop;//到店支付商品
@property (nonatomic,copy) NSString *shopID;//店铺 ID
@property (nonatomic,copy) NSString *brandID;//品牌 ID
@property (nonatomic,copy) NSString *takeTime;//取货日期

@property (nonatomic,copy) NSString *orderId;//订单ID
@property (nonatomic,copy) NSString *orderItemStatus;//订单状态

@property (nonatomic,assign) BOOL  _islogout; //注销

@property (nonatomic,assign) BOOL  _isempty; //购物车为空

@property (nonatomic,copy) NSString *phoneNumberString;


+(id)shareCartController;

- (void)requestData:(int)pageNumber requestTag:(int)tagNumber;

-(void)showProductsCount;

@end

