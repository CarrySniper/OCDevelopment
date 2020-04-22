//
//  AFNetworkHandle.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AFNetworkHandle.h"
#import "CLUser.h"

@implementation AFNetworkHandle

- (void)dealloc {
	[_networkTool cancelAllRequest];
	_networkTool = nil;
	_containerView.userInteractionEnabled = YES;
}

#pragma mark - Lazy
- (AFNetworkTool *)networkTool {
	if (!_networkTool) {
		_networkTool = [[AFNetworkTool alloc]init];
	}
	return _networkTool;
}

#pragma mark - 必要参数
#pragma mark 请求头参数
- (NSDictionary *)defaultHeaders {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//	[dictionary setValue:kAppLanguage forKey:@"xx-Language"];
//	[dictionary setValue:kApiVersion forKey:@"xx-Version"];
//	[dictionary setValue:kDeviceType forKey:@"XX-Device-Type"];
	
	// 用户token之类的
	if ([CLUser currentUser]) {
		[dictionary setValue:[CLUser currentUser].sessionToken forKey:@"XX-Token"];
	}
	
	return dictionary;
}

#pragma mark 默认基础参数
- (NSDictionary *)defaultParameters {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//	[dictionary setValue:kApplyName forKey:@"apply_name"];
	// 用户token之类的
	
	return dictionary;
}

#pragma mark - 发起请求
- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *)urlString
		   parameters:(id)parameters
			  success:(AFSuccessfulHandler)success
			  failure:(AFFailureHandler)failure
{
	[self requestMethod:requestMethod urlString:urlString headers:nil parameters:parameters isJsonBody:NO neesJsonResponse:YES success:success failure:failure];
}

- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *)urlString
			  headers:(id _Nullable)headers
		   parameters:(id _Nullable)parameters
			  success:(AFSuccessfulHandler)success
			  failure:(AFFailureHandler)failure
{
	[self requestMethod:requestMethod urlString:urlString headers:headers parameters:parameters isJsonBody:NO neesJsonResponse:YES success:success failure:failure];
}

- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *)urlString
			  headers:(id _Nullable)headers
		   parameters:(id _Nullable)parameters
		   isJsonBody:(BOOL)isJsonBody
	 neesJsonResponse:(BOOL)neesJsonResponse
			  success:(AFSuccessfulHandler _Nullable)success
			  failure:(AFFailureHandler _Nullable)failure {
	
	// 设置请求过程中不允许触摸事件
	if (self.containerView) {
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			self.containerView.userInteractionEnabled = NO;
		});
	}
	// 显示网络活动标志
	[self showNetWorkActivity];
	
	// 配置
	self.networkTool.isJsonBody = isJsonBody;
	self.networkTool.neesJsonResponse = neesJsonResponse;
	self.networkTool.requestTimeout = 10.0;
	self.networkTool.defaultHeaders = self.defaultHeaders;
	self.networkTool.defaultParameters = self.defaultParameters;
	
	// 开始请求
	__weak __typeof(self)weakSelf = self;
	[self.networkTool requestMethod:requestMethod
						  urlString:urlString
							headers:headers
						 parameters:parameters
							success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		[weakSelf cl_dealWithSuccessfulResponse:(NSHTTPURLResponse*)task.response responseObject:responseObject success:success failure:failure];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		[weakSelf cl_dealWithFailureResponse:error failure:failure];
	}];
}

#pragma mark - 上传图片
- (void)uploadFileDataArray:(NSArray<AFFileItem *> *)dataArray
				  urlString:(NSString *)urlString
					headers:(id)headers
				 parameters:(id)parameters
				   progress:(AFProgressHandler)progress
					success:(AFSuccessfulHandler)success
					failure:(AFFailureHandler)failure
{
	// 配置
	self.networkTool.requestTimeout = 20.0;
	self.networkTool.defaultHeaders = self.defaultHeaders;
	self.networkTool.defaultParameters = self.defaultParameters;
	// 开始请求
	__weak __typeof(self)weakSelf = self;
	[self.networkTool uploadFilesArray:dataArray
							 urlString:urlString
							   headers:headers
							parameters:parameters
							  progress:progress
							   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		[weakSelf cl_dealWithSuccessfulResponse:(NSHTTPURLResponse *)task.response responseObject:responseObject success:success failure:failure];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		[weakSelf cl_dealWithFailureResponse:error failure:failure];
	}];
}

#pragma mark - 请求成功统一回调方法（演号除上传图片外）
//FIXME : 这个看接口协议自定义
- (void)cl_dealWithSuccessfulResponse:(NSHTTPURLResponse *)httpResponse
					   responseObject:(id)responseObject
							  success:(void (^)(id responseObject))success
							  failure:(void (^)(NSError *error))failure
{
	// 隐藏网络活动标志
	[self showNetWorkActivity];
	
	// 恢复交互
	self.containerView.userInteractionEnabled = YES;
	
	@try {
		NSLog(@"success\n%@\n%@", httpResponse.URL, responseObject);
		if (responseObject && httpResponse.statusCode == 200) {// 200成功
			if([responseObject isKindOfClass:NSDictionary.class] && [[responseObject allKeys] containsObject:@"code"]) {
				NSInteger code = [responseObject[@"code"] integerValue];
				NSString *message = [responseObject objectForKey:@"message"];
				switch (code) {
					case 200:{
						message = @"请求成功";
						if (success) {
							success(responseObject[@"data"]);
						}
					}
						break;
					case 10001:{
						message = @"登录失效";
						[AppDelegate notificationLogonInvalidation];
					}
						break;
					case 1104:{
						message = @"封号";
						[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AccountClose object:nil];
					}
						break;
					default:{
						NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
						NSError *aError = [NSError errorWithDomain:@"" code:code userInfo:userInfo];
						if (failure) {
							failure(aError);
						}
					}
						break;
				}
			}
		}
		
		/*
		 // 根据HTTP返回的statusCode确定是否成功，成功里面还需要再判断里面的code值
		 switch (httpResponse.statusCode) {
		 case 200:// 200成功
		 if (success) {
		 success(responseObject);
		 }
		 break;
		 
		 default:
		 NSLog(@"statusCode不等于200");
		 if (failure) {
		 failure(nil);
		 }
		 break;
		 }
		 */
	} @catch (NSException *exception) {
		if (failure) {
			failure(nil);
		}
		// 捕获到的崩溃异常exception
		NSLog(@"\n------------------------------------------------\n捕获到的崩溃异常exception \n%@\n\n------------------------------------------------",exception);
	} @finally {
		// 完成回调
		if (self.completionHandler) {
			self.completionHandler();
		}
	}
}

#pragma mark - 请求失败统一回调方法
- (void)cl_dealWithFailureResponse:(NSError *)error failure:(void (^)(NSError *error))failure
{
	// 隐藏网络活动标志
	[self showNetWorkActivity];
	
	// 恢复交互
	self.containerView.userInteractionEnabled = YES;
	
	NSLog(@"HTTP statusCode方面报错--------------\n%ld %@",(long)error.code, error.localizedDescription);
	NSString *errorMessage = error.localizedDescription;
	switch (error.code) {
		case AFNetworkErrorType_Cancel :
			errorMessage = @"请求取消！";
			break;
		case AFNetworkErrorType_NoNetwork :
			errorMessage = @"暂无网络，请检查网络！";
			break;
		case AFNetworkErrorType_TimedOut :
			errorMessage = @"请求服务超时，请稍后重试！";
			break;
		case AFNetworkErrorType_ConnectFailed :
			errorMessage = @"网络链接失败，请检查网络！";
			break;
		case AFNetworkErrorType_404Failed :
			errorMessage = @"服务器正在升级，请稍后重试！";
			break;
		case AFNetworkErrorType_3840Failed :
			errorMessage = @"服务器优化中，请稍后再访问！";
			break;
		default:
			break;
	}
	
	if (failure) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage  forKey:NSLocalizedDescriptionKey];
		NSError *aError = [NSError errorWithDomain:@"" code:error.code userInfo:userInfo];
		failure(aError);
	}
	
	// 完成回调
	if (self.completionHandler) {
		self.completionHandler();
	}
}

#pragma mark - 网络活动标志
#pragma mark 显示
- (void)showNetWorkActivity {
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	});
}

#pragma mark 隐藏
- (void)hidenNetWorkActivity {
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	});
}

@end

