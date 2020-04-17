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
 #pragma mark - Model包含其他Model。 {"目标字段":"Model的类"} (以 Class 或 Class Name 的形式)。
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

#pragma mark - 进行NSUserDefaults存取
#pragma mark 归档
+ (void)archiveModel:(id)model withKey:(NSString *)key {
	NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:model];
	[[NSUserDefaults standardUserDefaults] setValue:archiveData forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 读档
+ (id)unarchiverModelWithKey:(NSString *)key {
	NSData *unarchiveObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	return [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveObject];
}

@end

