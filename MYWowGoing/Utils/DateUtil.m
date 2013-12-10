//
//  DateUtil.m
//  HuaShangPaper
//
//  Created by cdm on 10-12-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DateUtil.h"


@implementation DateUtil

+(NSDate *)GMTDate:(NSDate *)utcDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger utcInterval = [zone secondsFromGMTForDate:utcDate];
    return [utcDate  dateByAddingTimeInterval: utcInterval];  
}


+ (NSString *)desStringFromDate:(NSDate *)date
{
    if (!date)
    {
        return @"未知";
    }
    
    NSTimeInterval ti = [date timeIntervalSinceNow];

    if (ti > 0)
    {
        return @"刚刚";
    }
    
    if (ti > -60)
    {
        int mi = -ti;
        return [NSString stringWithFormat:@"%d秒之前", mi];
    }
    
    if (ti > -60 * 60)
    {
        int mi = abs(ti / 60);
        return [NSString stringWithFormat:@"%d分钟之前", mi];
    }

    if (ti > -60 * 60 * 10)
    {
        int mi = abs(ti / (60 * 60));
        return [NSString stringWithFormat:@"%d小时之前", mi];
    }

    int year = [DateUtil getYear:date];
    int nowYear = [DateUtil getYear:[NSDate date]];
    if (nowYear == year)
    {
        int month = [DateUtil getMonth:date];
        int nowMonth = [DateUtil getMonth:[NSDate date]];
        if (nowMonth == month)
        {
            int day = [DateUtil getDay:date];
            int nowDay = [DateUtil getDay:[NSDate date]];
            if (nowDay == day)
            {
                // yyyy-MM-dd HH:mm:ss
                return [NSString stringWithFormat:@"今天 %@", [DateUtil dateToString:date withFormat:@"HH:mm"]];
            }
            
            int yesterdayDay = [DateUtil getDay:[NSDate dateWithTimeIntervalSinceNow: - 60 * 60 * 24]];
            if (yesterdayDay == day)
            {
                // yyyy-MM-dd HH:mm:ss
                return [NSString stringWithFormat:@"昨天 %@", [DateUtil dateToString:date withFormat:@"HH:mm"]];
            }
            
            int tdbyDay = [DateUtil getDay:[NSDate dateWithTimeIntervalSinceNow: - 60 * 60 * 48]];
            if (tdbyDay == day)
            {
                // yyyy-MM-dd HH:mm:ss
                return [NSString stringWithFormat:@"前天 %@", [DateUtil dateToString:date withFormat:@"HH:mm"]];
            }
        }
    }

    return [DateUtil dateToString:date withFormat:@"MM-dd HH:mm"];
}

+ (NSDate *)stringToDate:(NSString *)str withFormat:(NSString *)format
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:format];
	NSDate *date = [formatter dateFromString:str];
	return date;
}

+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format 
{
    // 8小时问题
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *str = [formatter stringFromDate:date];
    NSString *dateString = [[[NSString alloc] initWithString:str] autorelease];
	[formatter release];
	return dateString;
}

+ (int)getDay:(NSDate *)date {
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [calender components:unitFlags fromDate:date];
	int day = [dateComponents day];
	
	return day;
}

+ (int)getMonth:(NSDate *)date {
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [calender components:unitFlags fromDate:date];
	int month = [dateComponents month];
	
	return month;
}

+ (int)getYear:(NSDate *)date {
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [calender components:unitFlags fromDate:date];
	int year = [dateComponents year];
	
	return year;
}

+ (NSDate *)getPreviousDate:(NSDate *)date {
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [calender components:unitFlags fromDate:date];
	
	NSInteger day = [dateComponents day];
	NSInteger month = [dateComponents month];
	NSInteger year = [dateComponents year];
	
	day--;
	if (day == 0) {
		month--;
		if (month == 0) {
			month = 12;
			year--;
		}
		day = [self getDateCountInMonth:year Month:month];
	}
	[dateComponents setYear:year];
	[dateComponents setMonth:month];
	[dateComponents setDay:day];
	
	NSDate *newDate = [calender dateFromComponents:dateComponents];
	// NSLog(@"newDate: %@",newDate);
	return newDate;
}

+(NSInteger)getDateCountInMonth :(NSInteger)year Month:(NSInteger)month {
	NSInteger daysCount = -1;
	switch(month)
	{
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			daysCount = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			daysCount = 30;
			break;
		case 2:
			if(year%400==0||(year%4==0&&year%100!=0))
				daysCount=29;
			else daysCount=28;
			break;
	}
	return daysCount;
}
+(NSString *)GetWeekDayFromDate:(NSDate *)date{
    NSString *day=@"";
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags = NSWeekdayCalendarUnit;
	NSDateComponents *dateComponents = [calender components:unitFlags fromDate:date];
    int intDay = [dateComponents weekday];
    if (intDay > 0 && intDay < 8) {
        switch (intDay) {
            case 1 :{
                day = @"星期日"; 
                break;
            }
            case 2 :{
                day = @"星期一";
                break;
            }
            case 3 :{
                day = @"星期二";
                break;
            }
            case 4 :{
                day = @"星期三";   
                break;
            }
            case 5 :{
                day = @"星期四";   
                break;
            }
            case 6 :{
                day = @"星期五";   
                break;
            }
            case 7 :{
                day = @"星期六";   
                break;
            }            
            default:{
                NSLog(@"获取星期时发生 Unknown error !");
                break;
            }
        }
    } 

    return day;
}


+(NSString *)getFormatedDateString:(NSInteger)sec withFormat:(NSString *)format{
   // NSDate *date = 
    //exp..  
    //NSDate *thedate = [[NSDate alloc] initWithTimeIntervalSince1970:1318208077];
    // thedate: 2011-10-10 00:54:37 +0000
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:sec];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *str = [formatter stringFromDate:date];

    NSString *dateString = [[[NSString alloc] initWithString:str] autorelease];
	[formatter release];
    [date release];
    return dateString;
}

+(NSString*)getChineseCalendarNoYearWithDate:(NSDate *)date{  
    
//    NSArray *chineseYears = [NSArray arrayWithObjects:  
//                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",  
//                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",  
//                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",  
//                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",  
//                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",  
//                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];  
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:  
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",   
                            @"九月", @"十月", @"冬月", @"腊月", nil];  
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:  
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",   
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",  
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];  
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];  
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;  
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];  
    
//    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);  
    
//    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];  
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];  
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];  
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@",m_str,d_str];  
    
    [localeCalendar release];  
    
    return chineseCal_str;  
}  

+(NSString*)getChineseCalendarWithDate:(NSDate *)date{  
    
    NSArray *chineseYears = [NSArray arrayWithObjects:  
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",  
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",  
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",  
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",  
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",  
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];  
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:  
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",   
                            @"九月", @"十月", @"冬月", @"腊月", nil];  
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:  
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",   
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",  
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];  
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];  
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;  
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];  
    
    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);  
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];  
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];  
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];  
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];  
    
    [localeCalendar release];  
    
    return chineseCal_str;  
}


+(NSString*)getMyTime:(NSString*)inputTimeStr
{
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:inputTimeStr];

    
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *outTimeStr = [outputFormatter stringFromDate:inputDate];
    return outTimeStr;
}

+(NSString*)getTimeYear:(NSString*)inputTimeStr
{
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:inputTimeStr];
    
    
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年-MM月-dd日"];
    
    NSString *outTimeStr = [outputFormatter stringFromDate:inputDate];
    return outTimeStr;
}
@end