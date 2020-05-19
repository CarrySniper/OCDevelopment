//
//  CLCalendarManager.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/22.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLCalendarManager.h"

@implementation CLCalendarManager

#pragma mark - init
+ (instancetype)sharedInstance {
	return [[self alloc] init];
}

- (instancetype)init
{
	static CLCalendarManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [super init];
		/// 实例化 - 指定日历的算法
		self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		[self.calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
		/// 设置一周起始日是星期几
		[self.calendar setFirstWeekday:0];
		
		self.dateFormatter = [[NSDateFormatter alloc] init];;
		[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
		[self.dateFormatter setLocale:[NSLocale currentLocale]];
	});
	return instance;
}

- (void)dealloc {
	_calendar = nil;
	_dateFormatter = nil;
}

#pragma mark - 获取当前日期

#pragma mark 获取当前日期
- (NSDate *)date {
	return [NSDate date];
}

#pragma mark 获取当前是几号
- (NSInteger)currentDay {
	NSDateComponents *components = [self.calendar components:(NSCalendarUnitDay) fromDate:self.date];
	return [components day];
}

#pragma mark 获取当前是几月
- (NSInteger)currentMonth {
	NSDateComponents *components = [self.calendar components:(NSCalendarUnitMonth) fromDate:self.date];
	return [components month];
}

#pragma mark 获取当前是哪一年
- (NSInteger)currentYear {
	NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear) fromDate:self.date];
	return [components year];
}

#pragma mark 获取当前是星期几
- (NSInteger)currentWeekday {
	NSDateComponents *components = [self.calendar components:(NSCalendarUnitWeekday) fromDate:self.date];
	return [components weekday];
}

#pragma mark 获取当前月份有多少天
- (NSInteger)currentMonthDays {
	NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date];
	return range.length;
}

#pragma mark - 获取某时间对象的数据

#pragma mark 获取月份 1-12
- (NSInteger)month:(NSDate *)date {
	NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
	return [components month];
}

#pragma mark 获取年份 2020
- (NSInteger)year:(NSDate *)date {
	NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
	return [components year];
}

#pragma mark 这个月共有几天 28-31
- (NSInteger)totalDaysInMonth:(NSDate *)date {
	NSRange daysInMonth = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
	return daysInMonth.length;
}

#pragma mark 这个月的第一天是星期几 1-7(日-六)
- (NSInteger)firstWeekdayInMonth:(NSDate *)date {
	NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
	[components setDay:1];// 设置为1号
	NSDate *firstDayDate = [self.calendar dateFromComponents:components];
	components = [self.calendar components:(NSCalendarUnitWeekday) fromDate:firstDayDate];
	return [components weekday];
}

#pragma mark 获取这个月的上一个月日期
- (NSDate *)lastMonth:(NSDate *)date {
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.month = -1;// 正数-将来，负数-过去
	NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:date options:0];
	return newDate;
}

#pragma mark 获取这个月的下一个月日期
- (NSDate *)nextMonth:(NSDate *)date {
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.month = +1;// 正数-将来，负数-过去
	NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:date options:0];
	return newDate;
}

#pragma mark 获取某日期相距多少天之前、之后的日期
- (NSDate *)getDateFromDate:(NSDate *)date withDays:(NSInteger)days {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:days];// 正数-将来，负数-过去
	return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

#pragma mark 获取两个时间之间的所有日期（按天算）
- (NSArray<NSDate *> *)datesBetweenTwoTimesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endtDate {
	if ([startDate compare:endtDate] != NSOrderedDescending) {
		NSMutableArray *array = [NSMutableArray array];
		[array addObject:startDate];
		
		NSDateComponents *endComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:endtDate];
		NSDate *tempDate = startDate;
		NSDateComponents *tempComponents;
		do {
			tempComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:tempDate];
			[tempComponents setDay:([tempComponents day] + 1)];
			tempDate = [self.calendar dateFromComponents:tempComponents];
			[array addObject:tempDate];
		} while (![tempComponents isEqual:endComponents]);
		
		return array;
	} else {
		return nil;
	}
}

#pragma mark - 格式转换
#pragma mark NSDate->NSString 时间转字符串
- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
	[self.dateFormatter setDateFormat:dateFormat];
	return [self.dateFormatter stringFromDate:date];
}

#pragma mark NSTimeInterval->NSString 时间戳转字符串
- (NSString *)stringFromTimestamp:(NSTimeInterval)timestamp dateFormat:(NSString *)dateFormat {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
	return [self stringFromDate:date dateFormat:dateFormat];
}

#pragma mark NSString->NSDate 字符串转时间
- (NSDate *)dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat {
	[self.dateFormatter setDateFormat:dateFormat];
	return [self.dateFormatter dateFromString:dateString];
}

#pragma mark 格式化星期（周日-周一）
- (NSString *)formatWeekDay:(NSInteger)weekday {
	switch (weekday) {
		case 1:
			return @"周日";
			break;
		case 2:
			return @"周一";
			break;
		case 3:
			return @"周二";
			break;
		case 4:
			return @"周三";
			break;
		case 5:
			return @"周四";
			break;
		case 6:
			return @"周五";
			break;
		case 7:
			return @"周六";
			break;
		default:
			break;
	}
	return @"Unknown";
}

#pragma mark - 比较时间

#pragma mark 目标日期是否为今天
- (BOOL)isToday:(NSDate *)fireDate {
	return [self isSameDay:self.date date2:fireDate];
}

#pragma mark 判断是否是同一天
- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2 {
	unsigned unitFlag = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
	NSDateComponents *comp1 = [self.calendar components:unitFlag fromDate:date1];
	NSDateComponents *comp2 = [self.calendar components:unitFlag fromDate:date2];
	return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

#pragma mark 判断是否是同一周
- (BOOL)isSameWeek:(NSDate *)date1 date2:(NSDate *)date2 {
	unsigned unitFlag = NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitYear;
	NSDateComponents *comp1 = [self.calendar components:unitFlag fromDate:date1];
	NSDateComponents *comp2 = [self.calendar components:unitFlag fromDate:date2];
	return (([comp1 weekOfMonth] == [comp2 weekOfMonth]) && ([comp1 weekOfYear] == [comp2 weekOfYear]) && ([comp1 year] == [comp2 year]));
}

#pragma mark - 比较当前日期大小
- (NSComparisonResult)compareWithDate:(NSString *)dateString dateFormat:(NSString *)dateFormat {
	[self.dateFormatter setDateFormat:dateFormat];
	NSDate *fireDate = [self.dateFormatter dateFromString:dateString];
	NSComparisonResult result = [fireDate compare:self.date];
	return result;
}

#pragma mark 比较时间差。（是现在的xx分钟前，xx小时前，xx天前，xx月前）
- (NSString *)prettyWithDate:(NSDate *)fireDate {
	NSString *suffix = @"前";
	
	float different = [self.date timeIntervalSinceDate:fireDate];
	if (different < 0) {
		different = -different;
		suffix = @"以后";
	}
	
	// days = different / (24 * 60 * 60), take the floor value
	float dayDifferent = floor(different / 86400);
	
	int days   = (int)dayDifferent;
	int months = (int)ceil(dayDifferent / 30);
	int years  = (int)ceil(dayDifferent / 365);
	
	// It belongs to today
	if (dayDifferent <= 0) {
		// lower than 60 seconds
		if (different < 60) {
			return @"刚刚";
		}
		
		// lower than 120 seconds => one minute and lower than 60 seconds
		if (different < 120) {
			return [NSString stringWithFormat:@"1分钟%@", suffix];
		}
		
		// lower than 60 minutes
		if (different < 60 * 60) {
			return [NSString stringWithFormat:@"%d分钟%@", (int)floor(different / 60), suffix];
		}
		
		// lower than 60 * 2 minutes => one hour and lower than 60 minutes
		if (different < 7200) {
			return [NSString stringWithFormat:@"1小时%@", suffix];
		}
		
		// lower than one day
		if (different < 86400) {
			return [NSString stringWithFormat:@"%d小时%@", (int)floor(different / 3600), suffix];
		}
	}
	// lower than one month
	else if (days < 30) {
		return [NSString stringWithFormat:@"%d天%@", days, suffix];
	}
	// lager than a month and lower than a year
	else if (months < 12) {
		return [NSString stringWithFormat:@"%d月%@", months, suffix];
	}
	// lager than a year
	else {
		return [NSString stringWithFormat:@"%d年%@", years, suffix];
	}
	
	return self.description;
}


#pragma mark - 扩展获取数据 转换数组
#pragma mark 获取最近几年（可以自定义10年）
- (NSArray *)getRecentYears {
	NSMutableArray *array = [NSMutableArray array];
	NSInteger year = [self.calendar component:NSCalendarUnitYear fromDate:self.date];
	for (NSInteger i = year; i >= year - 10; i--) {
		[array addObject:[NSString stringWithFormat:@"%ld年", i]];// 可以自己加单位
	}
	return array;
}

#pragma mark 获取12月字符串数组
- (NSArray *)getMonths {
	NSMutableArray *array = [NSMutableArray array];
	for (NSInteger i = 1; i <= 12; i++) {
		[array addObject:[NSString stringWithFormat:@"%02ld月", i]];
	}
	return array;
}

#pragma mark 获取最近一周的日期时间（yyyy-MM-dd数组）
- (NSArray<NSString *> *)getRecentWeekDays {
	NSMutableArray *dayArray = [[NSMutableArray alloc] init];
	for (NSInteger i = 7; i > 0; i--) {
		NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
		[dateComponents setDay:1-i];
		NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:self.date options:0];
		NSString *day = [self stringFromDate:newDate dateFormat:@"yyyy-MM-dd"];
		[dayArray addObject:day];
	}
	return [dayArray mutableCopy];
}

#pragma mark 获取当前一整月的日期时间（yyyy-MM-dd数组）
- (NSArray<NSString *> *)getCurrentMonthDays {
	NSUInteger numberOfDaysInMonth = [self currentMonthDays];
	NSUInteger currentMonth = [self currentMonth];
	NSUInteger currentYear = [self currentYear];
	
	NSMutableArray *dayArray = [[NSMutableArray alloc] init];
	for (NSInteger i = 1; i <= numberOfDaysInMonth; i++) {
		NSString *day = [NSString stringWithFormat:@"%zd-%zd-%02zd", currentYear, currentMonth, i];
		[dayArray addObject:day];
	}
	return [dayArray mutableCopy];
}

@end

