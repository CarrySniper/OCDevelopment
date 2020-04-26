//
//  CLFMDBManager.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLFMDBManager.h"
#import <objc/runtime.h>
//#import “FMDatabaseAdditions.h”
#import <FMDatabaseAdditions.h>
@implementation CLFMDBManager

@dynamic filePath;

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
		// 2.得到数据库，不存在文件时会自动创建，不需要open、close
		// FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
		// 3.操作数据库
		/*
		 [queue inDatabase:^(FMDatabase *db) {
		 // 4.当表不存在时创建新表（NOT EXISTS），只有一列（主键 列）
		 NSString *createTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY)", kFmdbTableName , kPrimaryKey];
		 // 5.提交更新
		 BOOL result = [db executeUpdate:createTable];
		 
		 }];
		 */
//		FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
//		[queue inDatabase:^(FMDatabase * _Nonnull db) {
//			[db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE '%@' DROP COLUMN '%@'", @"CLMainViewModel", @"abc"]];
//		}];
//
//		[self deleteColum:@"abc" inTable:@"CLMainViewModel"];
		
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
		completionHandler(NO);
		return;
	}
	
	__weak __typeof(self)weakSelf = self;
	// 创建或者获取数据表
	[self createTable:tableName primaryKey:primaryKey completionHandler:^(BOOL successful) {
		if (successful) {
			[weakSelf haveTable:tableName primaryKey:primaryKey primaryValue:primaryValue completionHandler:^(BOOL isHave) {
				if (isHave) {
					// 执行更新表方法
					[weakSelf updateTable:tableName primaryKey:primaryKey primaryValue:primaryValue dictionary:dictionary completionHandler:completionHandler];
				} else {
					completionHandler(isHave);
				}
			}];
		} else {
			completionHandler(successful);
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
		completionHandler(NO);
		return;
	}
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ = '%@'", tableName, primaryKey, primaryValue];
		BOOL result = [db executeUpdate:deleteSql];
		if (completionHandler) {
			completionHandler(result);
		}
	}];
}

#pragma mark 对指定数据表进行 数据清空
- (void)deleteAllDataWithTable:(NSString * _Nonnull)tableName completionHandler:(CLFMDBBoolHandler)completionHandler
{
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@'", tableName];
		BOOL result = [db executeUpdate:deleteSql];
		if (completionHandler) {
			completionHandler(result);
		}
	}];
}

#pragma mark 对指定数据表进行 表删除
- (void)deleteTable:(NSString * _Nonnull)tableName completionHandler:(CLFMDBBoolHandler)completionHandler
{
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *deleteSql = [NSString stringWithFormat:@"DROP TABLE  '%@'", tableName];
		BOOL result = [db executeUpdate:deleteSql];
		completionHandler(result);
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
		completionHandler(NO);
		return;
	}
	__weak __typeof(self)weakSelf = self;
	[self haveTable:tableName primaryKey:primaryKey primaryValue:primaryValue completionHandler:^(BOOL isHave) {
		if (isHave) {
			// 执行更新表方法
			[weakSelf updateTable:tableName primaryKey:primaryKey primaryValue:primaryValue dictionary:dictionary completionHandler:completionHandler];
		} else {
			completionHandler(isHave);
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
/// 创建数据表
/// @param tableName 表名称
/// @param primaryKey 主键
/// @param completionHandler 已有或创建成功successful=yes
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
			completionHandler(result);
		}
	}];
}

#pragma mark 判断数据表是否已经存在该主键，没有则创建（私有方法，内部调用）
- (void)haveTable:(NSString * _Nonnull)tableName primaryKey:(NSString * _Nonnull)primaryKey primaryValue:(NSString *)primaryValue
completionHandler:(CLFMDBBoolHandler)completionHandler
{
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase * _Nonnull db) {
		NSString *selectSql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM '%@' WHERE %@ IN (%@)", tableName, primaryKey, primaryValue];
		NSUInteger count = [db intForQuery:selectSql];
		BOOL result = count > 0 ? YES : NO;
		if (result == NO) {
			// 不存在该主键
			NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@') VALUES (?)", tableName, primaryKey];
			result = [db executeUpdate:insertSql, primaryValue];
		}
		if (completionHandler) {
			completionHandler(result);
		}
	}];
}

#pragma mark 更新表数据（私有方法，内部调用）
- (void)updateTable:(NSString * _Nonnull)tableName primaryKey:(NSString * _Nonnull)primaryKey primaryValue:(NSString *)primaryValue dictionary:(NSDictionary *)dictionary completionHandler:(CLFMDBBoolHandler)completionHandler
{
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase * _Nonnull db) {
		__block NSString *sqlString = @"";
		for (id key in dictionary) {
			@autoreleasepool {
				NSString *keyString = [NSString stringWithFormat:@"%@", key];
				if ([keyString isEqualToString:primaryKey])
					continue ;
				
				id value = [dictionary objectForKey:key];
				// 检测是否存在该列，若不存在则创建
				if (![db columnExists:keyString inTableWithName:tableName]) {
					/*
					 integer : 整型值
					 real : 浮点值
					 text : 文本字符串
					 blob : 二进制数据（比如文件）
					 */
					NSString *addSql;
					if ([value isKindOfClass:[NSNumber class]]) {
						addSql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' integer;", tableName, keyString];
					} else if ([value isKindOfClass:[NSData class]]) {
						addSql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' blob;", tableName, keyString];
					} else{
						addSql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' text;", tableName, keyString];
					}
					sqlString = [sqlString stringByAppendingString:addSql];
				}
				
				// 更新数据
				NSString *updateSql = [NSString stringWithFormat:
									   @"UPDATE '%@' SET '%@' = '%@' WHERE %@ = '%@';",
									   tableName, keyString, value , primaryKey, primaryValue];
				sqlString = [sqlString stringByAppendingString:updateSql];
			}
		}
		// MARK: 批处理数据，一个字符串包含多个方法
		BOOL result = [db executeStatements:sqlString];
		if (completionHandler) {
			completionHandler(result);
		}
	}];
	
}

@end

#pragma mark - 针对NSData数据处理
@implementation CLFMDBManager (NSData)

static NSString * const kDataKey = @"data";
static NSString * const kUpdateKey = @"updateAt";

#pragma mark - getter
#pragma mark NSData数据键
- (NSString *)dataKey {
	NSString *dataKey = objc_getAssociatedObject(self, _cmd);
	if (!dataKey) {
		dataKey = kDataKey;
		objc_setAssociatedObject(self, _cmd, dataKey, OBJC_ASSOCIATION_RETAIN);
	}
	return dataKey;
}

#pragma mark 时间戳数据
- (NSNumber *)getDateValue:(BOOL)needRefresh {
	NSNumber *dateValue = objc_getAssociatedObject(self, _cmd);
	if (!dateValue || needRefresh) {
		NSTimeInterval updateValue = [[NSDate date] timeIntervalSince1970];
		dateValue = [NSNumber numberWithLong:updateValue];
		objc_setAssociatedObject(self, _cmd, dateValue, OBJC_ASSOCIATION_RETAIN);
	}
	return dateValue;
}

- (void)backupTable:(NSString * _Nonnull)tableName columnsAndTypes:(NSString *)columnsAndTypes db:(FMDatabase *)db {

		// 删除旧字段（sqlite3无法使用DROP删除字段，先复制备份，再创建新的表）
		if (![db executeUpdate:@"BEGIN TRANSACTION"]) {
			NSLog(@"BEGIN TRANSACTION失败");
		}
		NSString *table_backup = [NSString stringWithFormat:@"%@_backup", tableName];
		NSString *sql = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE %@(%@)", table_backup, columnsAndTypes];
		if (![db executeUpdate:sql]) {
			NSLog(@"CREATE TEMPORARY TABLE %@ 失败", table_backup);
		}
		if (![db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ SELECT %@ FROM %@", table_backup, columnsAndTypes, tableName]]) {
			NSLog(@"INSERT INTO %@ 失败", table_backup);
		}
//		if (![db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@", tableName]]) {
//			NSLog(@"DROP TABLE %@ 失败", tableName);
//		}
//		if (![db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@(%@)", tableName, renamedColumnsAndTypes]]) {
//			NSLog(@"CREATE TABLE %@ 失败", tableName);
//		}
//		if (![db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ SELECT %@ FROM %@", tableName, renamedColumnNames, table_backup]]) {
//			NSLog(@"INSERT INTO %@ SELECT FROM %@ 失败", tableName, table_backup);
//		}
//		if (![db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@", table_backup]]) {
//			NSLog(@"DROP TABLE %@ 失败", table_backup);
//		}
		if (![db executeUpdate:@"COMMIT"]) {
			NSLog(@"COMMIT失败");
		}
}

/// 检测数据表和表列缺失情况
/// @param tableName 表名
/// @param primaryKey 主键
/// @param completionHandler 回调
- (void)checkWithTable:(NSString * _Nonnull)tableName primaryKey:(NSString * _Nonnull)primaryKey completionHandler:(CLFMDBBoolHandler)completionHandler {
	/// 添加的列 ===移除列，不支持，需要备份转移重命名操作===
	NSDictionary *addColumn = @{kDataKey : NSData.class,
								kUpdateKey : NSNumber.class};
	
	/// 数据库语句
	__block NSString *sqlString = @"";
	
	// 多线程安全FMDatabaseQueue
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase * _Nonnull db) {
		/// 当表不存在时创建新表（NOT EXISTS），列有primaryKey主键、dataKey数据键、updateAt更新时间戳
		NSString *columnsAndTypes = [NSString stringWithFormat:@"'%@' TEXT PRIMARY KEY, '%@' BLOB, '%@' INTEGER", primaryKey, kDataKey, kUpdateKey];
		NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@)", tableName , columnsAndTypes];
		/// 5.提交更新
		BOOL result = [db executeUpdate:createTable];
		if (!result && completionHandler) {
			NSLog(@"CREATE TABLE error");
			completionHandler(NO);
			return;
		}
		
		/// 当表中不存在某列时，进行添加列操作
		[addColumn enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class _Nonnull obj, BOOL * _Nonnull stop) {
			if (![db columnExists:key inTableWithName:tableName]) {
				/*
				 integer : 整型值
				 real : 浮点值
				 text : 文本字符串
				 blob : 二进制数据（比如文件）
				 */
				if ([obj isKindOfClass:[NSNumber class]]) {
					sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' REAL;", tableName, key]];
				} else if ([obj isKindOfClass:[NSData class]]) {
					sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' BLOB;", tableName, key]];
				} else {
					sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' TEXT;", tableName, key]];
				}
			}
		}];
		
		/// MARK: 批处理数据，一个字符串包含多个方法
		result = [db executeStatements:sqlString];
		if (completionHandler) {
			completionHandler(result);
		}
	}];
}

- (void)saveDataWithTable:(NSString * _Nonnull)tableName
			   primaryKey:(NSString * _Nonnull)primaryKey
				dataArray:(NSArray<NSDictionary *> *)dataArray
			  needRefresh:(BOOL)needRefresh
		completionHandler:(CLFMDBBoolHandler)completionHandler {
	// 多线程安全FMDatabaseQueue
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	// 开启事务
	[queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
		
		/// 更新时间戳
		__block NSNumber *updateValue = [self getDateValue:needRefresh];
		
		/// 遍历
		[dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			/// 查询是否已存在该主键数据
			NSString *selectSql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM '%@' WHERE %@ = ?", tableName, primaryKey];
			NSUInteger count = [db intForQuery:selectSql, obj[primaryKey]];
			BOOL result = count > 0 ? YES : NO;
			if (result == NO) {
				// 不存在该主键数据
				NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES (?,?,?)", tableName, primaryKey, kDataKey, kUpdateKey];
				result = [db executeUpdate:insertSql, obj[primaryKey], obj[kDataKey], updateValue];
				if (!result ) {
					//当最后*rollback的值为YES的时候，事务回滚，如果最后*rollback为NO，事务提交
					NSLog(@"INSERT error，事务回滚");
					if (completionHandler) {
						completionHandler(NO);
					}
					*rollback = YES;
					*stop = YES;// 终止循环
					return;// 跳出
				}
			} else {
				// 存在则更新数据
				NSString *updateSql = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = ?, '%@' = ? WHERE %@ = ?;",
									   tableName, kUpdateKey, kDataKey, primaryKey];
				result = [db executeUpdate:updateSql, updateValue, obj[kDataKey], obj[primaryKey]];
				if (!result ) {
					//当最后*rollback的值为YES的时候，事务回滚，如果最后*rollback为NO，事务提交
					NSLog(@"UPDATE error，事务回滚");
					if (completionHandler) {
						completionHandler(NO);
					}
					*rollback = YES;
					*stop = YES;// 终止循环
					return;// 跳出
				}
			}
		}];
		if (completionHandler) {
			completionHandler(YES);
		}
	}];
}

#pragma mark 保存/更新数据NSData
- (void)updateDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
				  dataArray:(NSArray<NSDictionary *> *)dataArray
				needRefresh:(BOOL)needRefresh
		  completionHandler:(CLFMDBBoolHandler)completionHandler {
	[self checkWithTable:tableName primaryKey:primaryKey completionHandler:^(BOOL successful) {
		if (successful) {
			[self saveDataWithTable:tableName primaryKey:primaryKey dataArray:dataArray needRefresh:needRefresh completionHandler:completionHandler];
		} else {
			NSLog(@"checkWithTable error");
		}
	}];
}

#pragma mark 查询数据NSData
- (void)selectDataWithTable:(NSString * _Nonnull)tableName completionHandler:(CLFMDBDataResultHandler)completionHandler {
	// 多线程安全FMDatabaseQueue
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM '%@' ORDER BY %@ DESC", tableName, kUpdateKey];
		FMResultSet *resultSet = [db executeQuery:selectSql];
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
		while ([resultSet next]) {
			/*
			 这里是取所有数据
			 if (resultSet.resultDictionary) {
			 [array addObject:resultSet.resultDictionary];
			 }
			 */
			// 只取valueKey列数据
			NSData *data = [resultSet dataForColumn:kDataKey];
			if (data) {
				[array addObject:data];
			}
		}
		/// executeQuery查询之后要关闭查询
		[resultSet close];
		if (completionHandler) {
			completionHandler(array);
		}
	}];
}

- (void)autoDeleteDataWithTable:(NSString * _Nonnull)tableName completionHandler:(CLFMDBBoolHandler)completionHandler
{
	// 多线程安全FMDatabaseQueue
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
	[queue inDatabase:^(FMDatabase *db) {
//		NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE", tableName];
//		BOOL result = [db executeUpdate:deleteSql];
//		if (completionHandler) {
//			completionHandler(result);
//		}
	}];
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
 5.删除列（不支持）
 ALTER TABLE [方案名.]TABLE_NAME DROP COLUMN COLUMN_NAME;
 */
