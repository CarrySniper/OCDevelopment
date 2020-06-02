//
//  CLUser.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLUser.h"

@implementation CLUser

#pragma mark - 当前存储对象
+ (instancetype)currentUser {
	CLUser *user = [self currentModel];
	if (user.user_nickname.length == 0) {
		user.user_nickname = [NSString stringWithFormat:@"%@****%@", [user.mobile substringToIndex:3], [user.mobile substringFromIndex:7]];;
	}
	return user;
}

#pragma mark - 退出登录，移除数据
+ (void)logout {
	[self saveModelData:nil];
}

#pragma mark 检查用户登录状态
+ (BOOL)isLogin {
	CLUser *user = [self currentUser];
	if (user && user.sessionToken.length > 0) {
		return YES;
	}
	return NO;
}

#pragma mark 保存用户信息
+ (void)saveUserData:(NSDictionary *)dictionary {
	[self saveModelData:dictionary];
}

#pragma mark 更新用户信息
+ (void)updateUserData:(NSDictionary *)dictionary {
	[self updateModelData:dictionary];
}

@end
