//
//  CouponBS.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-24.
//
//

#import "Service.h"
#define REQUEST_PAGE_ONE    1
#define REQUEST_PAGE_NEXT   2
@interface CouponBS : BizService

@property (strong, nonatomic) NSString *orderTypeString;
@property (assign) int pageNumber;

@end
