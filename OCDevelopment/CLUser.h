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

+ (instancetype)currentUser;

+ (void)logout;

+ (BOOL)isLogin;

+ (void)saveUserData:(NSDictionary *_Nullable)dictionary;

+ (void)updateUserData:(NSDictionary *_Nullable)dictionary;

@end

NS_ASSUME_NONNULL_END
