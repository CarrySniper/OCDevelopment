//
//  CLFMDBManager.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLFMDBManager.h"
#import <objc/runtime.h>

@implementation CLFMDBManager
//@dynamic property
//@synthesize fileName;

#pragma mark - 初始化
+ (instancetype)sharedInstance {
	return [[self alloc] init];
}

static CLFMDBManager *instance = nil;
static dispatch_once_t onceToken;
- (instancetype)init
{
	dispatch_once(&onceToken, ^{
		instance = [super init];
		// 1.数据库文件的路径
		NSLog(@"数据库文件的路径 %@", self.filePath);
		// 2.得到数据库，不存在文件时会自动创建
		// FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
		// 3.操作数据库
	});
	return instance;
}

#pragma mark - getter
#pragma mark 数据库文件路径，不存在则创建（此时没有创建数据库文件）
- (NSString *)filePath {
	NSString *filePath = objc_getAssociatedObject(self, _cmd);
	if (!filePath) {
		NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		// 到文件夹路径
		filePath = [document stringByAppendingPathComponent:[kFmdbName stringByDeletingLastPathComponent]];
		if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
			NSError *error;
			[[NSFileManager  defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
			NSAssert(!error, error.description);// 断言
		}
		// 重设文件完成路径
		filePath = [document stringByAppendingPathComponent:kFmdbName];
		objc_setAssociatedObject(self, _cmd, filePath, OBJC_ASSOCIATION_RETAIN);
	}
	return filePath;
}

#pragma mark -
#pragma mark 对指定数据表进行 数据插入
- (void)insertDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
				 dictionary:(NSDictionary *)dictionary
		  completionHandler:(CLFMDBBoolHandler)completionHandler
{
	// 获取主键的值
	__block NSString *primaryValue = [NSString stringWithFormat:@"%@", dictionary[primaryKey]];
	if (!primaryValue || [primaryValue length] == 0) {
		completionHandler(nil, NO);
		return;
	}
	
	__weak __typeof(self)weakSelf = self;
	// 创建或者获取数据表
	[self createTable:tableName primaryKey:primaryKey completionHandler:^(FMDatabase *db, BOOL successful) {
		if (successful) {
			if ([weakSelf haveTable:tableName primaryKey:primaryKey primaryValue:primaryValue database:db]) {
				// MARK: 已存在该主键。执行更新数据方法
				[weakSelf updateTable:tableName primaryKey:primaryKey primaryValue:primaryValue dictionary:dictionary database:db completionHandler:completionHandler];
			}else{
				// MARK: 不存在该主键。执行插入数据方法
				NSString *insertSql = [NSString stringWithFormat:
									   @"INSERT INTO '%@' ('%@') VALUES (?)",
									   tableName, primaryKey];
				
				[db executeUpdate:insertSql, primaryValue];
				[weakSelf updateTable:tableName primaryKey:primaryKey primaryValue:primaryValue dictionary:dictionary database:db completionHandler:completionHandler];
			}
		}else{
			completionHandler(db, successful);
		}
	}];
}

#pragma mark 对指定数据表进行 数据删除
- (void)deleteDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
			   primaryValue:(NSString *)primaryValue
		  completionHandler:(CLFMDBBoolHandler)completionHandler
{
	if ([primaryValue length] == 0) {
		completionHandler(nil, NO);
		return;
	}
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		
		NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ = '%@'", tableName, primaryKey, primaryValue];
		BOOL result = [db executeUpdate:deleteSql];
		if (completionHandler) {
			completionHandler(db, result);
		}
	}];
}

#pragma mark 对指定数据表进行 数据清空
- (void)deleteAllDataWithTable:(NSString * _Nonnull)tableName
			 completionHandler:(CLFMDBBoolHandler)completionHandler
{
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@'", tableName];
		BOOL result = [db executeUpdate:deleteSql];
		if (completionHandler) {
			completionHandler(db, result);
		}
	}];
}

#pragma mark 对指定数据表进行 表删除
- (void)deleteTable:(NSString * _Nonnull)tableName
  completionHandler:(CLFMDBBoolHandler)completionHandler
{
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *deleteSql = [NSString stringWithFormat:@"DROP TABLE  '%@'", tableName];
		BOOL result = [db executeUpdate:deleteSql];
		completionHandler(db, result);
	}];
}

#pragma mark 对指定数据表进行 数据更新
- (void)updateDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
				 dictionary:(NSDictionary *)dictionary
		  completionHandler:(CLFMDBBoolHandler)completionHandler
{
	// 获取主键的值
	__block NSString *primaryValue = [NSString stringWithFormat:@"%@", dictionary[primaryKey]];
	if (!primaryValue || [primaryValue length] == 0) {
		completionHandler(nil, NO);
		return;
	}
	__weak __typeof(self)weakSelf = self;
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		if ([weakSelf haveTable:tableName primaryKey:primaryKey primaryValue:primaryValue database:db]) {
			// MARK: 已存在该主键。执行更新数据方法
			[weakSelf updateTable:tableName primaryKey:primaryKey primaryValue:primaryValue dictionary:dictionary database:db completionHandler:nil];
		}else{
			// MARK: 不存在该主键。给失败回调
			completionHandler(db, NO);
		}
	}];
}

#pragma mark 对指定数据表进行 数据查询
- (void)selectDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
			   primaryValue:(NSString *)primaryValue
		  completionHandler:(CLFMDBResultHandler)completionHandler
{
	
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		
		NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE %@ = '%@'", tableName, primaryKey, primaryValue];
		FMResultSet *result = [db executeQuery:selectSql];
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
		do {
			if (result.resultDictionary) {
				[array addObject:result.resultDictionary];
			}
		} while ([result next]);
		// FIXME: executeQuery查询之后要关闭查询
		[result close];
		if (completionHandler) {
			completionHandler(array);
		}
	}];
}

#pragma mark 对指定数据表进行 精准数据查询
- (void)selectDataWithTable:(NSString * _Nonnull)tableName
				 conditions:(NSDictionary *)conditions
		  completionHandler:(CLFMDBResultHandler)completionHandler
{
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		
		NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM '%@'", tableName];
		NSString *conditionString = @"";
		if (conditions.allKeys.count > 0) {
			for (NSString *key in conditions.allKeys) {
				conditionString = [NSString stringWithFormat:@"%@ %@ = '%@'", conditionString, key, conditions[key]];
				if (![key isEqual:conditions.allKeys.lastObject]) {
					conditionString = [conditionString stringByAppendingString:@" AND "];
				}
			}
			selectSql = [selectSql stringByAppendingFormat:@" WHERE %@", conditionString];
		}
		
		FMResultSet *result = [db executeQuery:selectSql];
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
		do {
			if (result.resultDictionary) {
				[array addObject:result.resultDictionary];
			}
		} while ([result next]);
		// FIXME: executeQuery查询之后要关闭查询
		[result close];
		if (completionHandler) {
			completionHandler(array);
		}
	}];
}

#pragma mark 对指定数据表进行 模糊数据查询
- (void)selectFuzzyDataWithTable:(NSString * _Nonnull)tableName
					  conditions:(NSDictionary *)conditions
			   completionHandler:(CLFMDBResultHandler)completionHandler
{
	
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM '%@'", tableName];
		NSString *conditionString = @"";
		if (conditions.allKeys.count > 0) {
			for (NSString *key in conditions.allKeys) {
				conditionString = [NSString stringWithFormat:@"%@ %@ LIKE '%%%@%%'", conditionString, key, conditions[key]];
				if (![key isEqual:conditions.allKeys.lastObject]) {
					conditionString = [conditionString stringByAppendingString:@" AND "];
				}
			}
			selectSql = [selectSql stringByAppendingFormat:@" WHERE %@", conditionString];
		}
		
		FMResultSet *result = [db executeQuery:selectSql];
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
		do {
			if (result.resultDictionary) {
				[array addObject:result.resultDictionary];
			}
		} while ([result next]);
		// FIXME: executeQuery查询之后要关闭查询
		[result close];
		if (completionHandler) {
			completionHandler(array);
		}
	}];
}
/**
 对自定义进行Where 数据查询
 
 @param tableName 数据表名称
 @param completionHandler 查询结果回调
 */
- (void)selectDataWithTable:(NSString * _Nonnull)tableName
		  customWhereSqlite:(NSString *)customSqlite
		  completionHandler:(CLFMDBResultHandler)completionHandler
{
	
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		
		NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM '%@' %@", tableName,customSqlite];// WHERE, customSqlite
		FMResultSet *result = [db executeQuery:selectSql];
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
		do {
			if (result.resultDictionary) {
				[array addObject:result.resultDictionary];
			}
		} while ([result next]);
		// FIXME: executeQuery查询之后要关闭查询
		[result close];
		if (completionHandler) {
			completionHandler(array);
		}
	}];
}


#pragma mark -
#pragma mark 对指定数据表进行 批量数据插入
- (void)insertMultipleDataWithTable:(NSString * _Nonnull)tableName
						 primaryKey:(NSString * _Nonnull)primaryKey
					  primaryValues:(NSArray *)valuesArray
{
	// 获取主键的值
	__block NSString *primaryValue = [NSString stringWithFormat:@"%@", valuesArray.firstObject[primaryKey]];
	if (!primaryValue || [primaryValue length] == 0) {
		return;
	}
	for (NSDictionary *dict in valuesArray) {
		[self insertDataWithTable:tableName primaryKey:primaryKey dictionary:dict completionHandler:nil];
	}
}

#pragma mark 对指定数据表进行 批量数据删除
- (void)deleteMultipleDataWithTable:(NSString * _Nonnull)tableName
						 primaryKey:(NSString * _Nonnull)primaryKey
					  primaryValues:(NSArray *)valuesArray
{
	// 获取主键的值
	__block NSString *primaryValue = [NSString stringWithFormat:@"%@", valuesArray.firstObject[primaryKey]];
	if (!primaryValue || [primaryValue length] == 0) {
		return;
	}
	for (NSDictionary *dict in valuesArray) {
		NSString *primaryValue = [NSString stringWithFormat:@"%@", dict[primaryKey]];
		[self deleteDataWithTable:tableName primaryKey:primaryKey primaryValue:primaryValue completionHandler:nil];
	}
}

#pragma mark -
#pragma mark 创建数据表（私有方法，内部调用）
- (void)createTable:(NSString * _Nonnull)tableName primaryKey:(NSString * _Nonnull)primaryKey completionHandler:(CLFMDBBoolHandler)completionHandler
{
	// 3.打开数据库
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		// 4.当表不存在时创建新表（NOT EXISTS），只有一列（主键 列）
		NSString *createTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY)", tableName , primaryKey];
		// 5.提交更新
		BOOL result = [db executeUpdate:createTable];
		
		if (completionHandler) {
			completionHandler(db, result);
		}
	}];
}

#pragma mark 判断数据表是否已经存在该主键（私有方法，内部调用）
- (BOOL)haveTable:(NSString * _Nonnull)tableName primaryKey:(NSString * _Nonnull)primaryKey primaryValue:(NSString *)primaryValue
		 database:(FMDatabase *)database
{
	NSString *selectSql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM '%@' WHERE %@ IN (%@)", tableName, primaryKey, primaryValue];
	
	NSUInteger count = [database intForQuery:selectSql];
	if (count > 0) {
		return YES;
	}else{
		return NO;
	}
}

#pragma mark 更新表数据（私有方法，内部调用）
- (void)updateTable:(NSString * _Nonnull)tableName primaryKey:(NSString * _Nonnull)primaryKey primaryValue:(NSString *)primaryValue dictionary:(NSDictionary *)dictionary database:(FMDatabase *)database completionHandler:(CLFMDBBoolHandler)completionHandler
{
	__block NSString *sqlString = @"";
	for (id key in dictionary) {
		NSString *keyStr = [NSString stringWithFormat:@"%@", key];
		if ([keyStr isEqualToString:primaryKey])
			continue ;
		
		id value = [dictionary objectForKey:key];
		// 检测是否存在该列，若不存在则创建
		if (![database columnExists:keyStr inTableWithName:tableName]) {
			/*
			 integer : 整型值
			 real : 浮点值
			 text : 文本字符串
			 blob : 二进制数据（比如文件）
			 */
			NSString *addSql;
			if ([value isKindOfClass:[NSNumber class]]) {
				addSql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' integer;", tableName, keyStr];
			}else if ([value isKindOfClass:[NSData class]]) {
				addSql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' blob;", tableName, keyStr];
			}else{
				addSql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' text;", tableName, keyStr];
			}
			sqlString = [sqlString stringByAppendingString:addSql];
		}
		
		// 更新数据
		NSString *updateSql = [NSString stringWithFormat:
							   @"UPDATE '%@' SET '%@' = '%@' WHERE %@ = '%@';",
							   tableName,   keyStr,  value ,primaryKey,  primaryValue];
		sqlString = [sqlString stringByAppendingString:updateSql];
	}
	// MARK: 批处理数据，一个字符串包含多个方法
	BOOL result = [database executeStatements:sqlString];
	if (completionHandler) {
		completionHandler(database, result);
	}
}

@end

/*
 ALTER 语句修改数据表
 1.修改数据表名
 ALTER TABLE [方案名.]OLD_TABLE_NAME RENAME TO NEW_TABLE_NAME;
 2.修改列名
 ALTER TABLE [方案名.]TABLE_NAME RENAME COLUMN OLD_COLUMN_NAME TO NEW_COLUMN_NAME;
 3.修改列的数据类型
 ALTER TABLE [方案名.]TABLE_NAME MODIFY COLUMN_NAME NEW_DATATYPE;
 4.插入列
 ALTER TABLE [方案名.]TABLE_NAME ADD COLUMN_NAME DATATYPE;
 5.删除列
 ALTER TABLE [方案名.]TABLE_NAME DROP COLUMN COLUMN_NAME;
 */
