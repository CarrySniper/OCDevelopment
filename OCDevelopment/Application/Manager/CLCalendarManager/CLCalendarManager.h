//
//  CLCalendarManager.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/22.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 更多见CLDefine
// @"yyyy-MM-dd";
// @"yyyy-MM-dd HH:mm:ss";

@interface CLCalendarManager : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (instancetype)sharedInstance;

/**
 获取当前日期
 
 @return currentDay：1-31 currentMonth：1-12 currentYear：2018 currentWeek:1-7(日-六)
 */
- (NSInteger)currentDay;
- (NSInteger)currentMonth;
- (NSInteger)currentYear;
- (NSInteger)currentWeek;
/**
 获取月份
 
 @return 1-12
 */
- (NSInteger)month:(NSDate *)date;

/**
 获取年份
 
 @return 2018
 */
- (NSInteger)year:(NSDate *)date;

/**
 这个月有几天
 
 @param date 日期对象
 @return 0-31
 */
- (NSInteger)totalDaysInMonth:(NSDate *)date;

/**
 这个月的第一天是星期几
 
 @param date 日期对象
 @return 0-6
 */
- (NSInteger)firstWeekdayInMonth:(NSDate *)date;

/**
 获取上个月
 
 @param date 指定日期
 @return 日期
 */
- (NSDate *)lastMonth:(NSDate *)date;

/**
 获取下个月
 
 @param date 指定日期
 @return 日期
 */
- (NSDate *)nextMonth:(NSDate *)date;

/**
 日期转换成字符串
 
 @param date 日期
 @param dateFormat 时间格式化
 @return 字符串
 */
- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/**
 字符串转换成日期
 
 @param dateString 时间字符串
 @param dateFormat 时间格式化
 @return 日期
 */
- (NSDate *)dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat;

/**
 比较日期大小
 
 @param dateString 时间字符串
 @param dateFormat 时间格式化
 @return 结果
 */
- (NSComparisonResult)compareWithDate:(NSString *)dateString dateFormat:(NSString *)dateFormat;

/**
 获取两个时间之间的所有日期（日）
 
 @param startDate 开始时间
 @param endtDate 结束时间
 @return 日期数组
 */
- (NSArray<NSDate*> *)datesBetweenTwoTimesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endtDate;

/**
 比较时间差。（是现在的xx分钟前，xx小时前，xx天前，xx月前）

 @param fireDate 目标时间
 @return 时间差
 */
- (NSString *)prettyWithDate:(NSDate *)fireDate;

/**
 目标日期是否为今天
 
 @param fireDate 指定日期
 @return 是否
 */
- (BOOL)isToday:(NSDate *)fireDate;

/**
 判断是否是同一天
 */
- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2;

/**
 判断是否是同一周 (周日到周六为一周)
 */
- (BOOL)isSameWeek:(NSDate *)date1 date2:(NSDate *)date2;

/**
 获取今天某天相距多少个天的日期
 */
- (NSDate *)getDateFromDate:(NSDate *)date withDays:(NSInteger)days;

/**
 获取当前月份有多少天
 */
- (NSInteger)currentMonthDays;

- (NSArray *)getRecentYears;
- (NSArray *)getMonths;
- (NSArray<NSString*> *)getRecentWeekDays;
- (NSArray<NSString*> *)getCurrentMonthDays;

- (NSString *)formatWeekDay:(NSInteger)weekday;

@end

NS_ASSUME_NONNULL_END
