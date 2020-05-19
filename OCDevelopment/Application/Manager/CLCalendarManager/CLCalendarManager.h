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
// 1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.

#pragma mark - class
@interface CLCalendarManager : NSObject

/// 当前日期
@property (nonatomic, strong) NSDate *date;

/// 日历
@property (nonatomic, strong) NSCalendar *calendar;

/// 日期格式化
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

#pragma mark - method

/// 单例实例化
+ (instancetype)sharedInstance;

#pragma mark - 获取当前日期

/* currentDay：1-31 currentMonth：1-12 currentYear：2020 currentWeek:1-7(日-六)  */

/// 获取当前是几号 1-31
- (NSInteger)currentDay;

/// 获取当前是几月 1-12
- (NSInteger)currentMonth;

/// 获取当前是哪一年 2020
- (NSInteger)currentYear;

/// 获取当前是星期几 1-7(日-六)
- (NSInteger)currentWeekday;

/// 获取当前月份有多少天 28-31
- (NSInteger)currentMonthDays;

#pragma mark - 获取某时间对象的数据

/* 年月，这个月的天数，这个月的第一天是星期几，上一个月，下一个月 */

/// 获取月份 1-12
/// @param date 日期对象
- (NSInteger)month:(NSDate *)date;

/// 获取年份 2020
/// @param date 日期对象
- (NSInteger)year:(NSDate *)date;

/// 这个月共有几天 28-31
/// @param date 日期对象
- (NSInteger)totalDaysInMonth:(NSDate *)date;

/// 这个月的第一天是星期几 1-7(日-六)
/// @param date 日期对象
- (NSInteger)firstWeekdayInMonth:(NSDate *)date;

/// 获取这个月的上一个月日期
/// @param date 日期对象
- (NSDate *)lastMonth:(NSDate *)date;

/// 获取这个月的下一个月日期
/// @param date 日期对象
- (NSDate *)nextMonth:(NSDate *)date;

/// 获取某日期相距多少天之前、之后的日期
/// @param date 日期对象
/// @param days 相距天数（正数-将来；负数-过去）
- (NSDate *)getDateFromDate:(NSDate *)date withDays:(NSInteger)days;

/// 获取两个时间之间的所有日期（按天算）
/// @param startDate 开始日期
/// @param endtDate 结束日期
- (NSArray<NSDate *> *)datesBetweenTwoTimesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endtDate;

#pragma mark - 格式转换

/// NSDate->NSString 时间转字符串
/// @param date 日期
/// @param dateFormat 时间格式化
- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/// NSTimeInterval->NSString 时间戳转字符串
/// @param timestamp 时间戳（秒，如果是分秒，需要/1000）
/// @param dateFormat 时间格式化
- (NSString *)stringFromTimestamp:(NSTimeInterval)timestamp dateFormat:(NSString *)dateFormat;

/// NSString->NSDate 字符串转时间
/// @param dateString 时间字符串
/// @param dateFormat 时间格式化
- (NSDate *)dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat;

/// 格式化星期（周日-周一）
/// @param weekday 星期
- (NSString *)formatWeekDay:(NSInteger)weekday;

#pragma mark - 比较时间

/// 判断目标日期是否为今天
/// @param fireDate 指定日期
- (BOOL)isToday:(NSDate *)fireDate;

/// 判断两个日期是否是同一天
/// @param date1 日期1
/// @param date2 日期2
- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2;

/// 判断是否是同一周（周日到周六为一周）
/// @param date1 日期1
/// @param date2 日期2
- (BOOL)isSameWeek:(NSDate *)date1 date2:(NSDate *)date2;

/// 比较日期和当前日期大小
/// @param dateString 时间字符串
/// @param dateFormat 时间格式化
- (NSComparisonResult)compareWithDate:(NSString *)dateString dateFormat:(NSString *)dateFormat;

/// 获取比较时间差。（是现在的xx分钟前，xx小时前，xx天前，xx月前）
/// @param fireDate 目标日期
- (NSString *)prettyWithDate:(NSDate *)fireDate;

#pragma mark - 扩展获取数据

/// 获取最近几年（可以自定义10年）
- (NSArray *)getRecentYears;

/// 获取12月字符串数组
- (NSArray *)getMonths;

/// 获取最近一周的日期时间（yyyy-MM-dd数组）
- (NSArray<NSString*> *)getRecentWeekDays;

/// 获取当前一整月的日期时间（yyyy-MM-dd数组）
- (NSArray<NSString*> *)getCurrentMonthDays;

@end

NS_ASSUME_NONNULL_END
