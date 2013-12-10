//
//  FnalStatementVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-3-16.
//
//

#import <UIKit/UIKit.h>
#import "Prodect.h"
#import "BaseController.h"

@interface FnalStatementVC : BaseController

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView; 
@property (retain, nonatomic) IBOutlet UILabel *productsCount; //商品个数

@property (retain, nonatomic) IBOutlet UIScrollView *scrollViewProducts;//商品详情

@property (retain, nonatomic) IBOutlet UILabel *totalPrices;//商品总价

@property (retain, nonatomic) IBOutlet UILabel *accountBalance;//购引账户余额
@property (copy,nonatomic) NSString *balanceString;

@property (retain, nonatomic) IBOutlet UILabel *payment;//应支付款项
@property (nonatomic,copy) NSString *paymentString;

@property (retain, nonatomic) IBOutlet UIImageView *select;//选中图片

@property (retain, nonatomic) IBOutlet UIButton *payByWeb;//支付宝网页

@property (retain, nonatomic) IBOutlet UIImageView *selectByClient;//选中图片

@property (retain, nonatomic) IBOutlet UIButton *payByClient;//支付宝客户端

@property (retain,nonatomic) NSMutableArray *productsArray;//商品数组
@property (retain ,nonatomic) NSMutableDictionary  *productDic;
@property (nonatomic,copy) NSString *orderId;//订单ID
@property (nonatomic,copy) NSString  *orderIdString;//多个订单号的结合字符串

@property (nonatomic,assign) BOOL _isCartList;//购物车列表购买
@property (nonatomic,assign) BOOL _shouYe; //首页立即购买
@property (nonatomic,assign) BOOL _payByWeb;//网页支付
@property (nonatomic,assign) BOOL _notPay;//我的订单未付款


+(FnalStatementVC*)shareFnalStatementController;

@end
