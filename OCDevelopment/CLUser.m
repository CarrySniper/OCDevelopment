//
//  CLUser.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLUser.h"

static NSString * const kArchiverKeyOfUser = @"ArchiverKeyOfUser";

@implementation CLUser

#pragma mark - 当前存储对象
+ (instancetype)currentUser {
	CLUser *user = [self unarchiverModelWithKey:kArchiverKeyOfUser];
	if (user.user_nickname.length == 0) {
		user.user_nickname = [NSString stringWithFormat:@"%@****%@", [user.mobile substringToIndex:3], [user.mobile substringFromIndex:7]];;
	}
	return user;
}

#pragma mark - 退出登录，移除数据
+ (void)logout {
	[self saveUserData:[NSDictionary new]];
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
+ (void)saveUserData:(NSDictionary *_Nonnull)dictionary {
	CLUser *user = [CLUser yy_modelWithDictionary:dictionary];
	[self archiveModel:user withKey:kArchiverKeyOfUser];
}

#pragma mark 更新用户信息
+ (void)updateUserData:(NSDictionary *_Nonnull)dictionary {
	// 如果有相同key，用传入的参数代替默认参数值
	NSMutableDictionary *currentDict = [NSMutableDictionary dictionaryWithDictionary:[self allData]];
	[currentDict setValuesForKeysWithDictionary:dictionary];
	[self saveUserData:currentDict];
}

#pragma mark 获取所以用户数据
+ (NSDictionary *)allData {
	return [[CLUser currentUser] yy_modelToJSONObject];
}

@end
