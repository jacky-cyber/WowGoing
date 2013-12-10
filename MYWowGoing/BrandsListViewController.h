//
//  BrandsListViewController.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-7-25.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface BrandsListViewController : BaseController<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic) int type; // 整形标记 1.品牌列表   2. 店铺列表   
@end
