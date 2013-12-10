//
//  ShopInforVC.h
//  MYWowGoing
//
//  Created by 马奕兆 on 13-1-8.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BaseController.h"


@interface ShopInforVC : BaseController<UITableViewDataSource,UITableViewDelegate>

/*
 功能描述：展示品牌的店铺地址以及电话
 参数说明：1.shopId 商店的唯一id  2.品牌的唯一id
 */
@property (nonatomic,copy)NSString  *shopId;
@property (nonatomic,copy)NSString  *brandID;
@property(nonatomic,copy)NSString * brandName;
@property (nonatomic,retain) NSString *activatyID;
@property(nonatomic,copy) NSString *shopName;
@property (nonatomic,assign) int type;   // 1. 放大镜入口     2.店铺列表入口 
@end
