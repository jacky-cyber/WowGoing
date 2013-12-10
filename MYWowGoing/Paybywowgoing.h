//
//  Paybywowgoing.h
//  MYWowGoing
//
//  Created by zhangM on 13-3-27.
//
//

#import <Foundation/Foundation.h>
#import "Service.h"

 
#import "JSON.h"
 
@interface Paybywowgoing : BizService
@property(nonatomic,retain) NSMutableArray *productsArray;//商品数组
@property(nonatomic,copy) NSString *orderId; //订单号
@property(nonatomic,copy) NSString *orderIdString; //多个订单号的结合字符串
@end
