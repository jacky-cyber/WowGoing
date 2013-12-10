//
//  Api.h
//  MYWowGoing
//
//  Created by wkf on 12-12-28.
//
//
#import "Single.h"
#import "Toast+UIView.h"
#ifndef MYWowGoing_Api_h
#define MYWowGoing_Api_h
#define NUMBERS @"123456"
#define USERNAME @"123@abc.com"
#define PASSWORD @"888888"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define RESULTSTATUS BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];\
if (!resultStatus){return;}
#define NSLog(...)
//判断app版本
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]
//动态获取设备高度
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width
//判断是否是iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kFilenameXian        @"xianData.plist"
#define kFileNamePing        @"xinping.plist"
#define kFilenameMing        @"mingData.plist"
#define kFileHistory         @"hsitory.plist"

//#define SEVERURL @"http://www.wowgoing.com/apiAndroidV111" //1.1.1版本
#define WX_SEVERURL @"http://www.wowgoing.com/" //微信连接

//#define SEVERURL    @"http://192.168.1.150:8080/wowgoing2/apiv12"
//#define SEVERURL @"http://192.168.1.161:8080/wowgoing2/apiv12"
//#define SEVERURL @"http://192.168.1.104:8080/wowgoing2/apiv12"
#define SEVERURL  @"http://www.wowgoing.com/apiv12"

//#define SEVERURL  @"http://115.29.38.58:9080/apiv12"

//#define SEVERURL  @"http://125.76.226.154:8080/wowgoing/apiv12"

//#define SEVERURL ([[Single shareSingle] getConfigServerURL])
//判断是否有网络
#define NET_WORK [NetworkUtil canConnect]
//网络错误提示
#define NETWORK_STRING @"您的网络不给力,请重新试试吧"
//邀请码
#define INVITATION_CODE @"invitationcode/checkcode" 
//读取push状态
#define PUSH_FINDDEVICENUM @"push/findDevicenum"
//更新用户状态
#define PUSH_UPDATE @"push/update"
//详情product/detail
#define PRODUCT_DETAIL @"product/detail"
// 立即购买
#define PRODUCT_BUYNOW  @"cart/buyNow"

//登录
#define ACCOUNT_LOGIN @"account/login"
//点击立即购买
#define CART_BUYNOW @"cart/buyNow"
//添加用户尺码
#define USER_ADD @"user/add"
//获得用户尺码
#define USER_USERSIZE @"user/userSize"
//申请退款状态
#define CART_ACCEPTREFUND @"history/acceptRefund"
//push
#define PUSH_SERVER @"push/update"
//购物小票
#define HISTORY_PRINTCARD @"shoppePickup/printCard"
//历史记录
#define SCAN_NOTES @"scannotes/list"
//购物车列表
#define CART_LIST  @"cart/list"
//购物车详情
#define CART_DETAIL  @"cart/detail"

//核查  订单状态
#define  CART_CHECK_ORDER @"cart/toSettleOrder"

#define  CART_SUREPAY @"cart/surePay"

//取消订单
#define CART_CANCEL  @"cart/cancel"
// 收货人地址添加
#define  CART_ADDRESS  @"cart/takeGoodAddress"
#define  CART_FINDADDRESS  @"cart/findTakeGoodInfor"

//更新订单状态
#define CART_UPDATEORDER  @"cart/updateOrder"
//专柜取货
#define QH_LIST  @"shoppePickup/orderlisttoBuy"
//使用wowgoing账户支付
#define CART_UPDATE_ORDER  @"cart/updateOrderwithMoney"
//优惠劵
#define COUPON_LIST @"coupon/list"
//广告
#define ADVERTISEMENT_LIST @"advertisement/list"
#define ADDETAIL_LIST @"advertisement/productList"
#define ADVERTISEMENT_DETAIL @"advertisement/detail"
//优惠劵详情 coupon/detail
#define COUPON_DETAIL @"coupon/detail"
#define JIFEN @"credits/list"
#define EXIT_USER  @"exit/userexit"
#define BRAND_DETAIL  @"brand/detail"
//以下为消息使用
#define PUSH_ADVIEW @"pushAdview"
#define PUSH_ADPUSHVIEW @"pushADpushView" //点击广告后的消息名称
//限时抢购
#define XIANSHI_LIST @"product/list"
//店铺入口
#define SHOP_LIST @"product/shopBrandInfor"
//新品折扣
#define XINPING_LIST @"product/list"
#define  PRODUCT_LIST @"product/list"

//热词表
#define   HOT_WORDS   @"search/greatWordsList"
//热门品牌
#define  HOT_BRANDS   @"search/greatBrand"

//热门店铺
#define  HOT_SHOP  @"search/greatMarket"

//loadpage
#define LOAD_PAGE @"homepage/gethomepage"

//会员卡信息列表
#define MEMBERSHIPCARD_CUSTOM @"membershipCard/customermemberList"

//会员卡活动信息
#define MEMBERSHIPCARD_LIST @"membershipCard/list"
//添加会员卡
#define MEMBERSHIPCARD_ADDMEMBER @"membershipCard/addMemberNumber"
//编辑卡号
#define MEMBERSHIPCARD_EDITMEMBER @"membershipCard/editMemberNumber"
//删除
#define MEMBERSHIPCARD_DELETEMEMBER @"membershipCard/deleteMemberNumber"
//评价
#define   CUSTOM_EVALUATE   @"shoppePickup/customerEvaluate"


//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif


/** DEBUG RELEASE **/
#if DEBUG

#define MCRelease(x)            [x release]

#else

#define MCRelease(x)            [x release], x = nil

#endif


/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil


/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
\
[_OBJECT viewWithTag : _TAG]

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

// ARC
#if __has_feature(objc_arc)
/** Compiling with ARC */
#else
/** Compiling without ARC */
#endif


/* ****************************************************************************************************************** */
#pragma mark - Log Method (宏 LOG)

// 日志 / 断点
// =============================================================================================================================
// DEBUG模式
#define ITTDEBUG

// LOG等级
#define ITTLOGLEVEL_INFO        10
#define ITTLOGLEVEL_WARNING     3
#define ITTLOGLEVEL_ERROR       1

// =============================================================================================================================
// LOG最高等级
#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// =============================================================================================================================
// LOG PRINT
// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)      NSLog(@"< %s:(%d) > : " xx , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)      ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME()   ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)      ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)      ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)    ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)    ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)       ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)       ((void)0)
#endif

// 条件LOG
#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...)\
\
{\
if ((condition))\
{\
ITTDPRINT(xx, ##__VA_ARGS__);\
}\
}
#else
#define ITTDCONDITIONLOG(condition, xx, ...)\
\
((void)0)
#endif

// 断点Assert
#define ITTAssert(condition, ...)\
\
do {\
if (!(condition))\
{\
[[NSAssertionHandler currentHandler]\
handleFailureInFunction:[NSString stringWithFormat:@"< %s >", __PRETTY_FUNCTION__]\
file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
lineNumber:__LINE__\
description:__VA_ARGS__];\
}\
} while(0)


/* ****************************************************************************************************************** */
#pragma mark - Constants (宏 常量)


/** 时间间隔 */
#define kHUDDuration            (1.f)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))


//** textAlignment ***********************************************************************************

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
# define TextAlignmentLeft UITextAlignmentLeft
# define TextAlignmentCenter UITextAlignmentCenter
# define TextAlignmentRight UITextAlignmentRight

#else
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
# define TextAlignmentLeft NSTextAlignmentLeft
# define TextAlignmentCenter NSTextAlignmentCenter
# define TextAlignmentRight NSTextAlignmentRight

#endif




#endif
