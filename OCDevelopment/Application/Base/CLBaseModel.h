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

@interface CLBaseModel : NSObject<NSCoding, NSCopying>

/// id
@property (nonatomic, copy) NSString *objectId;

@end


@interface CLBaseModel (CLCategory)

/// 数据归档并保存
/// @param key NSUserDefaults的key
- (void)archiveModelWithKey:(NSString *)key;

/// 本地读取数据读档
/// @param key NSUserDefaults的key
+ (instancetype)unarchiverModelWithKey:(NSString *)key;

/// 数据归档
- (NSData *)archiveModel;

/// 数据读档
/// @param data 数据对象
+ (instancetype)unarchiverModelWithData:(NSData *)data;

@end
NS_ASSUME_NONNULL_END
