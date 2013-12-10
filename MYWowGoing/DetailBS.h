//
//  DetailBS.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-26.
//
//

#import "Service.h"

@interface DetailBS : BizService

@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *password;
@property (assign) int productIdNum;
@property (assign) int activityIdNum;

@end
