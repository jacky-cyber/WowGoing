//
//  DeviceInformation.h
//  idenfier
//
//  Created by liangliang on 12-10-30.
//  Copyright (c) 2012年 LL. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IPAddress.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface DeviceInformation : NSObject

+ (NSString *)getMacAddress;
+ (NSString *)getCurrentIOSVersion;
+ (NSString *)getDeviceVersion;

@end
