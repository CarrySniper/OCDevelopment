//
//  CLFMDBManager.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - 模版别名 数据处理回调 [resultSet stringForColumn:@"xxx"]
typedef void (^CLFMDBBoolHandler)(BOOL successful);
typedef void (^CLFMDBResultHandler)(NSArray<NSDictionary *> *_Nullable resultSets);
typedef void (^CLFMDBDataResultHandler)(NSArray<NSData *> *_Nullable dataArray);

// sqlFile  数据库文件（一个即可）
static NSString *const kFmdbName = @"cl_sqlite.db";       //数据库的名称,可以定义成任何类型的文件


// table    要多少个表，就定义多少个
static NSString *const kFmdbTableName = @"cl_table";                    //xxx数据表

/**
 注意：
 
 主键：primaryKey，数据的对象Id主键
 需要根据这个key来插入、查询、更新、删除数据
 每个表都有自己的主键，主键需要根据接口返回id来定义字段
 */
static NSString *const kPrimaryKey = @"objectId";           // xxx表的主键

#pragma mark - Class
@interface CLFMDBManager : NSObject

/// 数据库文件路径
@property (strong, nonatomic, readonly) NSString *filePath;

#pragma mark - method
/// 数据库操作：增（insert）、删（delete）、改（update）、查（select）。
/// 注意：insert会包含update操作，当插入数据主键已存在时，会替换数据以保证主键的唯一性。
+ (instancetype)sharedInstance;

#pragma mark - 单数据处理    增删改查操作
/// 对指定数据表进行 数据插入（1.表不存在则创建create；2.主键已存在则更新数据update）
/// @param tableName 数据表名称
/// @param primaryKey 插入数据主键
/// @param dictionary 插入数据集合
/// @param completionHandler 结果回调
- (void)insertDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
				 dictionary:(NSDictionary *)dictionary
		  completionHandler:(CLFMDBBoolHandler _Nullable)completionHandler;

/// 对指定数据表进行 数据删除
///
/// @param tableName 数据表名称
/// @param primaryKey 删除数据主键
/// @param primaryValue 查询数据主键对应值
/// @param completionHandler 结果回调
- (void)deleteDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
			   primaryValue:(NSString *)primaryValue
		  completionHandler:(CLFMDBBoolHandler _Nullable)completionHandler;

/// 对指定数据表进行 数据更新
///
/// @param tableName 数据表名称
/// @param primaryKey 更新数据主键
/// @param dictionary 更新数据集合
/// @param completionHandler 结果回调
- (void)updateDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
				 dictionary:(NSDictionary *)dictionary
		  completionHandler:(CLFMDBBoolHandler _Nullable)completionHandler;

/// 对指定数据表进行 数据查询
///
/// @param tableName 数据表名称
/// @param primaryKey 查询数据主键
/// @param primaryValue 查询数据主键对应值
/// @param completionHandler 查询结果回调
- (void)selectDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
			   primaryValue:(NSString *)primaryValue
		  completionHandler:(CLFMDBResultHandler _Nullable)completionHandler;

/// 对自定义数据查询Where
///
/// @param tableName 数据表名称
/// @param completionHandler 查询结果回调
- (void)selectDataWithTable:(NSString * _Nonnull)tableName
		  customWhereSqlite:(NSString *)customSqlite
		  completionHandler:(CLFMDBResultHandler _Nullable)completionHandler;

/// 对指定数据表进行 精准数据查询
///
/// @param tableName 数据表名称
/// @param conditions 查询条件集合，内容与条件都一致才匹配到，若为空则查询所有数据
/// @param completionHandler 查询结果回调
- (void)selectDataWithTable:(NSString * _Nonnull)tableName
				 conditions:(NSDictionary *)conditions
		  completionHandler:(CLFMDBResultHandler _Nullable)completionHandler;

/// 对指定数据表进行 模糊数据查询
///
/// @param tableName 数据表名称
/// @param conditions 查询条件集合，内容带有条件多都可以匹配到，若为空则查询所有数据
/// @param completionHandler 查询结果回调
- (void)selectFuzzyDataWithTable:(NSString * _Nonnull)tableName
					  conditions:(NSDictionary *)conditions
			   completionHandler:(CLFMDBResultHandler _Nullable)completionHandler;


#pragma mark - 批量数据处理

/// 对指定数据表进行 批量数据插入
///
/// @param tableName 数据表名称
/// @param primaryKey 数据主键
/// @param valuesArray 数据数组（集合元素）
- (void)insertMultipleDataWithTable:(NSString * _Nonnull)tableName
						 primaryKey:(NSString * _Nonnull)primaryKey
					  primaryValues:(NSArray<NSDictionary *> *)valuesArray;

/// 对指定数据表进行 批量数据删除
///
/// @param tableName 数据表名称
/// @param primaryKey 数据主键
/// @param valuesArray 数据数组（集合元素）
- (void)deleteMultipleDataWithTable:(NSString * _Nonnull)tableName
						 primaryKey:(NSString * _Nonnull)primaryKey
					  primaryValues:(NSArray<NSDictionary *> *)valuesArray;

#pragma mark - 特殊处理

/// 对指定数据表进行数据清空
///
/// @param tableName 数据表名称
/// @param completionHandler 结果回调
- (void)deleteAllDataWithTable:(NSString * _Nonnull)tableName
			 completionHandler:(CLFMDBBoolHandler _Nullable)completionHandler;

/// 对指定数据表进行表删除
///
/// @param tableName 数据表名称
/// @param completionHandler 结果回调
- (void)deleteTable:(NSString * _Nonnull)tableName completionHandler:(CLFMDBBoolHandler _Nullable)completionHandler;

@end

#pragma mark - 针对NSData数据处理
@interface CLFMDBManager (NSData)

/// NSData数据键
@property (strong, nonatomic, readonly) NSString *dataKey;

/// 保存/更新数据NSData
/// @param tableName 表名
/// @param primaryKey 主键
/// @param dataArray 数据数组
/// @param needRefresh 是否需要刷新时间，保证新数据在最前面
/// @param completionHandler 结果回调
- (void)updateDataWithTable:(NSString * _Nonnull)tableName
				 primaryKey:(NSString * _Nonnull)primaryKey
				  dataArray:(NSArray<NSDictionary *> *)dataArray
				needRefresh:(BOOL)needRefresh
		  completionHandler:(CLFMDBBoolHandler)completionHandler;

/// 查询数据NSData
/// @param tableName 表名
/// @param completionHandler 结果回调
- (void)selectDataWithTable:(NSString * _Nonnull)tableName
		  completionHandler:(CLFMDBDataResultHandler)completionHandler;


/// 自动删除过期数据，7天前的
/// @param tableName 表名
/// @param completionHandler 结果回调
- (void)autoDeleteDataWithTable:(NSString * _Nonnull)tableName completionHandler:(CLFMDBBoolHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
