//
//  CLBaseModel.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseModel.h"

@implementation CLBaseModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
	return @{@"objectId":@"id"};
}
/*
 YYModel扩展使用，视情况选择实现
 
 #pragma mark - 字段映射。{"自定义字段":"目标字段"}
 + (NSDictionary *)modelCustomPropertyMapper {
 return @{@"name" : @"n"};
 }
 #pragma mark - Model包含其他Model数组等容器类。 {"目标字段":"Model的类"} (以 Class 或 Class Name 的形式)。
 + (NSDictionary *)modelContainerPropertyGenericClass {
 return @{@"base" : [BaseModel class]};
 }
 #pragma mark - 黑名单。如果实现了该方法，则处理过程中会忽略该列表内的所有属性
 + (NSArray *)modelPropertyBlacklist {
 return @[@"name"];
 }
 #pragma mark - 白名单。如果实现了该方法，则处理过程中不会处理该列表外的属性。
 + (NSArray *)modelPropertyWhitelist {
 return @[@"name"];
 }
 */


#pragma mark - YYModel 直接添加以下代码即可自动完成序列化／反序列化
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
	return [self yy_modelCopy];
}
- (NSUInteger)hash {
	return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object {
	return [self yy_modelIsEqual:object];
}
- (NSString *)description {
	return [self yy_modelDescription];
}

@end

#pragma mark - CLCategory
#pragma mark - 模型存储
@implementation CLBaseModel (CLStorage)

#pragma mark 获取当前存储Model
+ (instancetype)currentModel {
	return [self unarchiverModelWithKey:NSStringFromClass(self.class)];
}

#pragma mark 保存Model
- (void)saveModel {
	[CLBaseModel archiveModel:self withKey:NSStringFromClass(self.class)];
}

#pragma mark 保存Model，key为类名（可自定义，避免重复）
+ (void)saveModelData:(NSDictionary * _Nullable)dictionary {
	CLBaseModel *model = [self yy_modelWithDictionary:dictionary];
	[CLBaseModel archiveModel:model withKey:NSStringFromClass(self.class)];
}

#pragma mark 更新Model
+ (void)updateModelData:(NSDictionary * _Nullable)dictionary {
	// 如果有相同key，用传入的参数代替默认参数值
	NSMutableDictionary *currentDict = [NSMutableDictionary dictionaryWithDictionary:[self allModelData]];
	[currentDict setValuesForKeysWithDictionary:dictionary];
	[self saveModelData:currentDict];
}

#pragma mark 获取所有数据
+ (NSDictionary *)allModelData {
	return [[self currentModel] yy_modelToJSONObject];
}

@end

#pragma mark - 模型归档存储
@implementation CLBaseModel (UserDefaults)

#pragma mark - 进行NSUserDefaults存取 文件会以NSData形式保存在Library/Preferences/xxx.plist
#pragma mark 数据归档并保存
+ (void)archiveModel:(CLBaseModel * _Nullable)model withKey:(NSString * _Nonnull)key {
	NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:model];
	[[NSUserDefaults standardUserDefaults] setValue:archiveData forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 本地读取数据读档
+ (instancetype)unarchiverModelWithKey:(NSString * _Nonnull)key {
	NSData *unarchiveObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	return [self unarchiverModelWithData:unarchiveObject];
}

#pragma mark 数据归档
- (NSData *)archiveModel {
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark 数据读档
+ (instancetype)unarchiverModelWithData:(NSData * _Nullable)data {
	return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
