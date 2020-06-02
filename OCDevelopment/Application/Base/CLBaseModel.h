//
//  CLBaseModel.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - class
@interface CLBaseModel : NSObject<NSCoding, NSCopying>

/// id
@property (nonatomic, copy) NSString *objectId;

@end

#pragma mark - CLCategory
#pragma mark 模型存储
@interface CLBaseModel (CLStorage)

/// 获取当前存储Model
+ (instancetype)currentModel;

/// 保存Model对香
- (void)saveModel;

/// 保存Model数据
/// @param dictionary 数据集合
+ (void)saveModelData:(NSDictionary * _Nullable)dictionary;

/// 更新Model数据
/// @param dictionary 数据集合
+ (void)updateModelData:(NSDictionary * _Nullable)dictionary;

/// 获取所有数据
+ (NSDictionary *)allModelData;

@end

#pragma mark 模型归档存储
@interface CLBaseModel (UserDefaults)

/// 数据归档并保存
/// @param model 模型
/// @param key NSUserDefaults的key
+ (void)archiveModel:(CLBaseModel * _Nullable)model withKey:(NSString * _Nonnull)key;

/// 本地读取数据读档
/// @param key NSUserDefaults的key
+ (instancetype)unarchiverModelWithKey:(NSString * _Nonnull)key;

/// 数据归档
- (NSData *)archiveModel;

/// 数据读档
/// @param data 数据对象
+ (instancetype)unarchiverModelWithData:(NSData * _Nullable)data;

@end

NS_ASSUME_NONNULL_END
