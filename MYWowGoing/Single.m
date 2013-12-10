//
//  Single.m
//  StudyiOS
//
//  Created by  on 11-10-28.
//  Copyright (c) 2011年 ZhangYiCheng. All rights reserved.
//

#import "Single.h"

static Single *single = nil;

@implementation Single

- (void)dealloc
{
    [_string release];
    [_advertisementId release];
    [super dealloc];
}
+ (Single *)shareSingle {
    if (single == nil) {
        single = [[Single alloc] init];
    }
    return single;
}



- (void)setConfigServerURL:(NSString *)urlString {
    [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:@"urlConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getConfigServerURL {
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"urlConfig"];
}

@end
