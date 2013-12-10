//
//  Single.h
//  StudyiOS
//
//  Created by  on 11-10-28.
//  Copyright (c) 2011年 ZhangYiCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Single : NSObject

@property (retain, nonatomic) NSString *string;
@property (assign, nonatomic) BOOL isResf;
@property (assign) BOOL isADV;
@property (assign) BOOL isXianShi;
@property (assign) BOOL  isLeiBie;
@property (assign) int adNum;
@property (assign) int advertisementPriority; //判断广告图片是否被点击
@property (retain,nonatomic) NSString *advertisementId;

+ (Single *)shareSingle;

- (void)setConfigServerURL:(NSString *)urlString;
- (NSString *)getConfigServerURL;
@end
