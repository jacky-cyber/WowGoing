//
//  AdproductsListBS.h
//  MYWowGoing
//
//  Created by zhangM on 13-4-24.
//
//

#import <Foundation/Foundation.h>
#import "Service.h"
@interface AdproductsListBS :BizService
@property(nonatomic,copy) NSString *advertisementId;
@property(nonatomic,assign)int pageNumber;
@property(nonatomic,assign) int requestTag;
@end
