//
//  ProductListViewController.h
//  MYWowGoing
//
//  Created by zhangM on 13-7-27.
//
//
//  主要用于展现品牌/店铺下的所有商品
#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface ProductListViewController : BaseController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSString *brandID;  // 品牌ID
@property (nonatomic,retain) NSString *conditionStr;  // 搜索条件 
@property (nonatomic,retain) NSString *shopID;  //店铺ID
@property (nonatomic,retain) NSString   *leiBieStr;
@property (nonatomic,assign) int    flagForBrandOrShop;  //标志位 1.品牌    2. 店铺   3.类别  4.搜索栏    9.热词
@property  (nonatomic,retain) NSString  *styleTypeName; //  上装、裤装、内衣。。。。。
@property (nonatomic,retain) NSString *type;
@end
