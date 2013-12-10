//
//  AddressBS.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-15.
//
//

#import <Foundation/Foundation.h>
#import "Service.h"
@interface AddressBS : BizService
@property (nonatomic,retain) NSMutableDictionary  *addressDic;
@property (assign,nonatomic) int  type; // 1.保存收货地址  2. 获取收货地址
@end
