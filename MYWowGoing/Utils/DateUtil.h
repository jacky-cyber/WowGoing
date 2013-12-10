//
//  DateUtil.h
//  HuaShangPaper
//
//  Created by cdm on 10-12-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateUtil : NSObject {

}

// 时间由utc专程gmt
+(NSDate *)GMTDate:(NSDate *)utcDate;
// 将date和当前时间相比, 返回一个描述时间的字符串
+ (NSString *)desStringFromDate:(NSDate *)date;
// 将NSString，按照字符串目前的年月日格式，转换为NSDate
+ (NSDate *)stringToDate:(NSString *)str withFormat:(NSString *)format;
// 将NSDate，按照指定的格式，转换为NSString
+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format;
// 获取NSDate的日
+ (int)getDay:(NSDate *)date;
// 获取NSDate中的月
+ (int)getMonth:(NSDate	 *)date;
// 获取NSDate中的年
+ (int)getYear:(NSDate *)date;
// 获取传入的NSDate的前一天
+ (NSDate *)getPreviousDate:(NSDate *)date;
+(NSInteger)getDateCountInMonth :(NSInteger)year Month:(NSInteger)month;
+(NSString*)GetWeekDayFromDate:(NSDate *)date;
+(NSString *)getFormatedDateString:(NSInteger)sec withFormat:(NSString *)format;
// 获取农历
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;
+(NSString*)getChineseCalendarNoYearWithDate:(NSDate *)date;
//得到2012年12月12日
+(NSString*)getMyTime:(NSString*)inputTimeStr;
//得到2012-12-13格式
+(NSString*)getTimeYear:(NSString*)inputTimeStr;
@end
