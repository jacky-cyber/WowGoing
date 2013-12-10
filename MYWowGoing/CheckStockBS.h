//
//  CheckStockBS.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-16.
//
//

#import <Foundation/Foundation.h>
#import "Service.h"
@interface CheckStockBS : BizService
@property (nonatomic,retain) NSMutableArray  *activityArray;
@property (nonatomic,retain) NSMutableArray *orderIDArray;
@property (nonatomic,assign) int  type;
@property (nonatomic,assign) BOOL  isNoPay;
@end
