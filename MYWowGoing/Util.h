//
//  Util.h
//  MYWowGoing
//
//  Created by duyingfeng on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Util : NSObject

+(void)setDefauts;
+(NSString*)getDeviceId;

+(BOOL)isLogin;
+(void)setLogin:(NSString*)uerName password:(NSString*)password;
+(void)setLoginOk;
+(void)cancelLogin;

+(NSString*)getLoginName;
+(NSString*)getPassword;


+(void)setCustomerID:(NSString*)customerId;
+(NSString*)getCustomerID;

+(void)setBingWeibo:(int)index;//0 未绑定 1 新浪微薄 2 腾讯微薄

+(int)getBingWeibo;

+(void)saveCity:(NSString *)cityName;
+(NSString*)getCityName;
+(void)deleteCityName;


+(void)saveBrowerCity:(NSString *)cityName;//保存服务器返回城市
+(NSString *)getBrowerCity;//获取服务器返回城市


+(void)SvaeBrandArray:(NSMutableArray*)brandArray;
+(NSMutableArray*)getBrandArray;

+(void)SvaeMarketArray:(NSMutableArray*)marketArray;
+(NSMutableArray*)getMarketArray;

+(void)SvaeStyleTypesArray:(NSMutableArray*)styleTypesArray;
+(NSMutableArray*)getStyleTypesArray;

+(void)SvaeDiscountArray:(NSMutableArray*)discountArray;
+(NSMutableArray*)getDiscountArray;

+(void)SvaePriceArray:(NSMutableArray*)priceArray;
+(NSMutableArray*)getPriceArray;

//专柜取货
+(void)SaveShoppeArray:(NSMutableArray*)shoppeArray;
+(NSMutableArray*)getShoppeArray;

+(void)saveNoPayArray:(NSMutableArray*)noPayArray;
+(NSMutableArray*)takeNoPayArray;

+(void)saveHadTakenArray:(NSMutableArray*)hadTakenArray;
+(NSMutableArray*)takeHadTakenArray;

//专柜详情
+(void)SaveShoppeInfoArray:(NSMutableDictionary*)shoppeInfoDic;
+(NSMutableDictionary*)getShoppeInfoDic;

//品牌
+(void)SvaeBrandShopArray:(NSMutableArray*)brandShopArray;
+(NSMutableArray*)getBrandShopArray;
//关注品牌
+(void)SaveLikeBrandArray:(NSMutableArray*)likeBrandArray;
+(NSMutableArray*)getLikeBrandArray;

//购物车
+(void)saveCartProducts:(NSMutableArray*)productsArray;
+(NSMutableArray*)takeCartProducts;


+(void)saveCartListCount:(NSString*)countString;//存储购物车内商品数量
+(NSString*)takeCartListCount;


+(void)saveCartPicture:(NSArray*)pictures;
+(NSArray*)takePictures;

+(void)saveSinaOrQQ:(NSString *)username password:(NSString *)password;
+(NSString *)getSinaUserName;
+ (NSString *)getSinaPassWord;
+(void)cancelSinaLogin;


+(void)saveUserPhoneNumber:(NSString*)phoneString;
+(NSString*)takePhoneNumber;


//保存浏览记录
+ (void)saveHistory:(NSMutableArray *)array;
//获取浏览记录
+ (NSMutableArray *)getHistory;
+ (void)saveDeviceToken:(NSString *)tokenString;
+ (NSString *)getDeviceToken;
+ (BOOL)JudgeStr:(NSString *)str isContainedByMatchStr:(NSString *)matchStr;
+ (void)saveAdViewCity:(NSString *)adStringCity;
+ (NSString *)getAdViewCity;

//存储/获取当前经纬度信息
+ (void) saveCurrentLocationPoint:(NSMutableDictionary*) pointDic;
+ (NSMutableDictionary*) takeCurrentLocationPoint;

+ (BOOL) checkPhoneNumber:(NSString*) phoneNumber;

@end
