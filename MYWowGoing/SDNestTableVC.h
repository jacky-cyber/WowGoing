//
//  SDNestTableVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-4-13.
//
//

#import "SDNestedTableViewController.h"
#import "iToast.h"

@interface SDNestTableVC : SDNestedTableViewController
@property(nonatomic,copy)NSString * productType;
@property (assign,nonatomic) int typeScreen;// 筛选标识：1.店铺列表  2.品牌列表  3.类别     4. 新品折扣  5. 限时抢购   6.广告页   8.搜索栏  9.热词

@end
