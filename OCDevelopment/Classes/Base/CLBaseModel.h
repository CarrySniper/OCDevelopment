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

#pragma mark 归档
+ (void)archiveModel:(id)model withKey:(NSString *)key;

#pragma mark 读档
+ (id)unarchiverModelWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
