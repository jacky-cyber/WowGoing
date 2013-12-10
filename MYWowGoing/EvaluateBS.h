//
//  EvaluateBS.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-15.
//
//

#import <Foundation/Foundation.h>
#import "Service.h"
@interface EvaluateBS : BizService

@property (assign,nonatomic) int  evaluateType; // 评价类型  1.已取货  2.退货  3.取消订单
@property (nonatomic,retain) NSMutableDictionary  *evaluateDic;
@end
