//
//  Request.h
//  MYWowGoing
//
//  Created by zhangM on 13-3-27.
//
//

#import <Foundation/Foundation.h>
#import "Service.h"

 
#import "JSON.h"
 

@interface Request : BizService
@property(copy,nonatomic) NSString *requestUrl;
@property(assign,nonatomic) int requestTag;
@property (assign,nonatomic) int pageNumber;
@property (retain,nonatomic) NSNumber *orderID;
@property (assign,nonatomic) int requestTpye;//请求类型
@property (copy,nonatomic)  NSString *orderType;
@end
/*
 requestTpye 请求类型定义:
 1. 购物车列表
 2. 购物车详情
 3. 专柜取货列表
 4. 专柜取货 取消待取货订单
 5.  专柜取货 取消未付款订单
 .....
 */