//
//  CLUser.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLUser : CLBaseModel

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *user_nickname;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *sessionToken;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger user_status;

@property (nonatomic, assign) long long birthday;

/// 当前用户对象
+ (instancetype)currentUser;

/// 登出
+ (void)logout;

/// 是否已经登录
+ (BOOL)isLogin;

/// 保存用户数据
/// @param dictionary 集合
+ (void)saveUserData:(NSDictionary *_Nonnull)dictionary;

/// 更新用户数据
/// @param dictionary 集合
+ (void)updateUserData:(NSDictionary *_Nonnull)dictionary;

@end

NS_ASSUME_NONNULL_END
