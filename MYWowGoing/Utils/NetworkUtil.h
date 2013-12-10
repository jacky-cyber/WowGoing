//
//  NetworkUtil.h
//  LibHsqCore
//
//  Created by wkf on 12-8-30.
//
//

#import <Foundation/Foundation.h>

@interface NetworkUtil : NSObject

+(BOOL)canConnect;
+(BOOL)is3G;
+(BOOL)isWifi;

@end
