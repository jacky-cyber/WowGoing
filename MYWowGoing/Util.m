//
//  Util.m
//  MYWowGoing
//
//  Created by duyingfeng on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import <ShareSDK/ShareSDK.h>
#import "DeviceInformation.h"
#import "LXF_OpenUDID.h"
@implementation Util

+(NSString*)getDeviceId
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceId"];
}

#pragma mark ---------- 获取MAC地址
+(void)setDefauts
{
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Defauts"] == NO) {
        NSLog(@"程序每一次启动");
        NSString *deviceId;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Defauts"];
        if (version >= 7.0) {
             deviceId = [LXF_OpenUDID value];
        }
        else {
            deviceId = [DeviceInformation getMacAddress];
        }

        NSLog(@"opngudid== %@",deviceId);
        [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"DeviceId"];
    }
}

+(BOOL)isLogin
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == YES) {
        return YES;
    }
    else{
        return NO;
    }
}

+(void)setLogin:(NSString*)uerName password:(NSString*)password
{
    [[NSUserDefaults standardUserDefaults] setObject:uerName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLoginOk{
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
     [[NSUserDefaults standardUserDefaults] synchronize];
}



//存新浪和qq的用户名和密码
+ (void)saveSinaOrQQ:(NSString *)username password:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getSinaUserName
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaUserName"];
}

+ (NSString *)getSinaPassWord
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaPassWord"];
}

+(void)cancelSinaLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sinaUserName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sinaPassWord"];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(NSString*)getLoginName
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}
+(NSString*)getPassword
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}
+(void)cancelLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)setCustomerID:(NSString*)customerId
{
    [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getCustomerID
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
}


+(void)setBingWeibo:(int)index//0 未绑定 1 新浪微薄 2 腾讯微薄
{
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"weiboKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(int)getBingWeibo{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"weiboKey"];
    
}

//保存定位的城市
+(void)saveCity:(NSString *)cityName {
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"cityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSString*)getCityName {
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    if (cityName == nil) {
        return @"";
    }
    return cityName;
}

+(void)deleteCityName  {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//保存服务器返回的城市
+ (void)saveBrowerCity:(NSString *)cityName {
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"serverCityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获得城市
+(NSString *)getBrowerCity {
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverCityName"];
    if (cityName == nil) {
        return @"当前位置";
    }
    return cityName;
}


+(void)SvaeBrandArray:(NSMutableArray*)brandArray
{
    [[NSUserDefaults standardUserDefaults] setObject:brandArray forKey:@"brandArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSMutableArray*)getBrandArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"brandArray"];
}
+(void)SvaeMarketArray:(NSMutableArray*)marketArray
{
    [[NSUserDefaults standardUserDefaults] setObject:marketArray forKey:@"marketArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSMutableArray*)getMarketArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"marketArray"];
}

+(void)SvaeStyleTypesArray:(NSMutableArray*)styleTypesArray
{
    [[NSUserDefaults standardUserDefaults] setObject:styleTypesArray   forKey:@"styleTypesArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSMutableArray*)getStyleTypesArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"styleTypesArray"];
}
+(void)SvaeDiscountArray:(NSMutableArray*)discountArray
{
    [[NSUserDefaults standardUserDefaults] setObject:discountArray forKey:@"discountArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSMutableArray*)getDiscountArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"discountArray"];
}

+(void)SvaePriceArray:(NSMutableArray*)priceArray
{
    [[NSUserDefaults standardUserDefaults] setObject:priceArray forKey:@"priceArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSMutableArray*)getPriceArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"priceArray"];
}

+(void)SaveShoppeArray:(NSMutableArray*)shoppeArray
{
    [[NSUserDefaults standardUserDefaults] setObject:shoppeArray forKey:@"shoppeArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSMutableArray*)getShoppeArray
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"shoppeArray"];
}

+(void)saveNoPayArray:(NSMutableArray*)noPayArray{
    [[NSUserDefaults standardUserDefaults] setObject:noPayArray forKey:@"noPayArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSMutableArray*)takeNoPayArray{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"noPayArray"];
}

+(void)saveHadTakenArray:(NSMutableArray*)hadTakenArray{
    [[NSUserDefaults standardUserDefaults] setObject:hadTakenArray forKey:@"hadTakenArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSMutableArray*)takeHadTakenArray{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"hadTakenArray"];
}


+(void)SaveShoppeInfoArray:(NSMutableDictionary*)shoppeInfoDic
{
    [[NSUserDefaults standardUserDefaults] setObject:shoppeInfoDic forKey:@"shoppeInfoDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSMutableDictionary*)getShoppeInfoDic
{
    return (NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:@"shoppeInfoDic"];
}

+(void)SvaeBrandShopArray:(NSMutableArray*)brandShopArray
{
    [[NSUserDefaults standardUserDefaults] setObject:brandShopArray forKey:@"brandShopArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSMutableArray*)getBrandShopArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"brandShopArray"];
}

+(void)SaveLikeBrandArray:(NSMutableArray*)likeBrandArray
{
    [[NSUserDefaults standardUserDefaults] setObject:likeBrandArray forKey:@"likeBrandArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSMutableArray*)getLikeBrandArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"likeBrandArray"];

}

+(void)saveCartListCount:(NSString*)countString{
    [[NSUserDefaults standardUserDefaults] setObject:countString  forKey:@"cartListCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)takeCartListCount{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"cartListCount"];
}


+(void)saveCartPicture:(NSArray *)pictures{
    [[NSUserDefaults standardUserDefaults] setObject:pictures  forKey:@"pictures"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSArray*)takePictures{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"pictures"];
}

+(void)saveCartProducts:(NSMutableArray*)productsArray{
    [[NSUserDefaults standardUserDefaults] setObject:productsArray forKey:@"cartProducts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableArray*)takeCartProducts{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"cartProducts"];
}


+(void)saveUserPhoneNumber:(NSString*)phoneString{
    [[NSUserDefaults standardUserDefaults] setObject:phoneString forKey:@"phoneString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)takePhoneNumber{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneString"];

}



//保存浏览记录
+ (void)saveHistory:(NSMutableArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取浏览记录
+ (NSMutableArray *)getHistory
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
}

+ (void)saveDeviceToken:(NSString *)tokenString
{
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getDeviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

//判断一个字符是否被另一个字符串包含
+ (BOOL)JudgeStr:(NSString *)str isContainedByMatchStr:(NSString *)matchStr
{
    NSRange range;
    range = [matchStr rangeOfString:str];
    if (range.location == NSNotFound) {
        return NO; //不包含
    }else {
        return YES; //包含
    }
}

+ (void)saveAdViewCity:(NSString *)adStringCity {
    [[NSUserDefaults standardUserDefaults] setObject:adStringCity forKey:@"adCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAdViewCity {
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"adCity"];
    if (cityName == nil) {
        return @"当前位置";
    }
    return cityName;
}

+ (void)saveCurrentLocationPoint:(NSMutableDictionary *)pointDic{
    [[NSUserDefaults standardUserDefaults] setObject:pointDic forKey:@"LocationPoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSMutableDictionary*)takeCurrentLocationPoint{
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationPoint"];
}


+ (BOOL) checkPhoneNumber:(NSString*) phoneNumber{
    
    /*
     电信手机号码号段： 133、153、180、181、189
     联通手机号码号段 ：130、131、132、145（无线上网卡专用号段）、155、156、185、186
     移动手机号码号段 ：134、135、136、137、138、139、147、150、151、152、157、158、159、182、183、184、187、188
   */
    
    NSString *regex = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return  isMatch;

}

@end
