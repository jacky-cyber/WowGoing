//
//  SearchRequestBS.h
//  MYWowGoing
//
//  Created by zhangM on 13-4-16.
//
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface SearchRequestBS : BizService
@property(nonatomic,retain) NSMutableDictionary *parameterDic;
@property (assign,nonatomic) BOOL isSearch;
@end
