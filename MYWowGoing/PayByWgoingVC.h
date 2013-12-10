//
//  PayByWgoingVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-3-20.
//
//

#import <UIKit/UIKit.h>
#import "Prodect.h"
#import "BaseController.h"

@interface PayByWgoingVC : BaseController
@property (retain, nonatomic) IBOutlet UILabel *productsCount;//商品数量

@property (retain, nonatomic) IBOutlet UIScrollView *productsScroll;//展示商品详情

@property (retain, nonatomic) IBOutlet UILabel *productsPrice;//商品总价
@property (copy,nonatomic) NSString *totolPrice;//商品总价

@property (retain, nonatomic) IBOutlet UILabel *balanceAcount;//购引账户余额


@property (retain,nonatomic) NSMutableArray *productsArray;//商品数组
@property (retain,nonatomic) NSMutableDictionary   *productDic;
@property (copy,nonatomic)NSString *orderId;
@property (nonatomic,copy)NSString *orderIdString;

@property (nonatomic,assign) BOOL _isCartList;//购物车列表购买
@property (nonatomic,assign) BOOL _shouYe; //首页立即购买

@property (nonatomic,assign) BOOL _notPay;//我的订单未付款


+(PayByWgoingVC*)shareFnalStatementController;
@end
