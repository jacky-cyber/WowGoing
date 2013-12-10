//
//  NetworkUtil.m
//  LibHsqCore
//
//  Created by wkf on 12-8-30.
//
//

#import "NetworkUtil.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation NetworkUtil

+(BOOL)canConnect
{
    BOOL result = NO;
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            result = NO;
            break;
        case ReachableViaWWAN:
            result = YES;
            break;
        case ReachableViaWiFi:
            result = YES;
            break;
    }
    
    return result;
}

+(BOOL)is3G
{
    BOOL result = NO;
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus])
    {
        case ReachableViaWWAN:
            result = YES;
            break;
        case ReachableViaWiFi:
            result = NO;
            break;
    }
    
    return result;
}

+(BOOL)isWifi
{
    BOOL result = NO;
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus])
    {
        case ReachableViaWWAN:
            result = NO;
            break;
        case ReachableViaWiFi:
            result = YES;
            break;
    }
    
    return result;
}



@end
