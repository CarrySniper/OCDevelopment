//
//  AFNetworkHandle.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AFNetworkHandle.h"

@implementation AFNetworkHandle

- (void)dealloc {
	[_networkTool cancelAllRequest];
	_networkTool = nil;
	_containerView.userInteractionEnabled = YES;
}

#pragma mark - Lazy
- (AFNetworkTool *)networkTool {
	if (!_networkTool) {
		_networkTool = [[AFNetworkTool alloc]initWithBaseURL:[NSURL URLWithString:self.baseUrl]];
	}
	return _networkTool;
}

#pragma mark 8位随机密码
- (NSString *)randomKey {
    NSTimeInterval random = [NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    return [[randomString componentsSeparatedByString:@"."] lastObject];
}

#pragma mark - 必要参数
#pragma mark 请求头参数
- (NSDictionary *)defaultHeaders {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	// 终端平台，如android, ios
	[dictionary setValue:@"ios" forKey:@"terminal"];
	// 调用源
	[dictionary setValue:@"iosapp" forKey:@"source"];
	// 用户token之类的
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

#pragma mark - 请求成功统一回调方法（有例外就另外处理）
//FIXME : 这个看接口协议自定义
- (void)cl_dealWithSuccessfulResponse:(NSHTTPURLResponse *)httpResponse
					   responseObject:(id)responseObject
							  success:(void (^)(id responseObject))success
							  failure:(void (^)(NSError *error))failure
{
	// 隐藏网络活动标志
	[self hidenNetWorkActivity];
	
	// 恢复交互
	self.containerView.userInteractionEnabled = YES;
	
	@try {
		NSLog(@"\n🍏 success 🍏\n%@\n%@", httpResponse.URL, responseObject);
		if (responseObject && httpResponse.statusCode == 200) {// 200成功
			if([responseObject isKindOfClass:NSDictionary.class] && [[responseObject allKeys] containsObject:@"code"]) {
				NSInteger code = [responseObject[@"code"] integerValue];
				NSString *message = [responseObject objectForKey:@"message"];
				switch (code) {
					case NetworkCodeForSuccess:{
						message = @"请求成功";
						if (success) {
							success(responseObject[@"data"]);
						}
					}
						break;
					case NetworkCodeForLogin:{// 未登陆
						[AppDelegate notificationShowAccountPage];
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
	} @catch (NSException *exception) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"返回数据格式异常，或者使用参数有误。" forKey:NSLocalizedDescriptionKey];
		NSError *aError = [NSError errorWithDomain:@"" code:0 userInfo:userInfo];
		if (failure) {
			failure(aError);
		}
		// 捕获到的崩溃异常exception
		NSLog(@"\n⚠️ 捕获到的崩溃异常exception ⚠️\n%@\n\n------------------------------------------------",exception);
	} @finally {
		/// 完成回调
		self.completionHandler ? self.completionHandler(responseObject, nil) : nil;
	}
}

#pragma mark - 请求失败统一回调方法
- (void)cl_dealWithFailureResponse:(NSError *)error failure:(void (^)(NSError *error))failure
{
	/// 隐藏网络活动标志
	[self hidenNetWorkActivity];
	
	/// 恢复交互
	self.containerView.userInteractionEnabled = YES;
	
	NSLog(@"\n🍎 Http StatusCode方面报错 🍎\n%ld %@",(long)error.code, error.localizedDescription);
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
	/// 构建错误
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage  forKey:NSLocalizedDescriptionKey];
	NSError *aError = [NSError errorWithDomain:@"" code:error.code userInfo:userInfo];
	/// 失败回调
	failure ? failure(aError) : nil;
	
	/// 完成回调
	self.completionHandler ? self.completionHandler(nil, aError) : nil;
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

#pragma mark - -------------------------------------------------
@implementation AFNetworkHandle (Singleton)

#pragma mark - 单例，如果是init方式初始化，那将创建新的对象，不强制使用单例
+ (instancetype)sharedInstance {
	static AFNetworkHandle *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
		/// 请求设置固定地址
		instance.baseUrl = @"";
	});
	return instance;
}

#pragma mark - 发起请求
+ (void)requestMethod:(AFRequestMethod)requestMethod urlString:(NSString *)urlString parameters:(id _Nullable)parameters completionHandler:(AFCompletionHandler _Nullable)completionHandler {
	[[AFNetworkHandle sharedInstance] requestMethod:requestMethod urlString:urlString parameters:parameters success:^(id _Nonnull responseObject) {
		completionHandler ? completionHandler(responseObject, nil) : nil;
	} failure:^(NSError * _Nonnull error) {
		completionHandler ? completionHandler(nil, error) : nil;
	}];
}

@end

#pragma mark - -------------------------------------------------
@implementation AFNetworkHandle (UFileSDK)

+ (void)uploadWithImages:(NSArray<UIImage *> *)imageArray maxPixel:(CGFloat)maxPixel completionHandler:(void(^)(NSArray * _Nullable urlArray, NSError * _Nullable error))completionHandler {
	if (imageArray.count == 0) {
		/// 构建错误
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"没有文件"  forKey:NSLocalizedDescriptionKey];
		NSError *aError = [NSError errorWithDomain:@"" code:-1 userInfo:userInfo];
		completionHandler ? completionHandler(nil, aError) : nil;
		return;
	}
	
}

#pragma mark - 我喜欢的图片尺寸900*900的，太大上传不好
+ (UIImage *)scaleImage:(UIImage *)image toMaxPixel:(CGFloat)maxPixel {
	UIImage *scaleImage = image;
	if (maxPixel > 0) {
		CGSize size = CGSizeFromString(NSStringFromCGSize(image.size));
		CGFloat maxSize = size.width > size.height ? size.width : size.height;
		float scale = maxSize > maxPixel ? maxPixel/maxSize : 1.0;
		scaleImage = [self scaleImage:image scaling:scale];
	}
	return scaleImage;
}

#pragma mark - 等比率缩放图片
+ (UIImage *)scaleImage:(UIImage *)image scaling:(float)scaling {
	UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaling,image.size.height*scaling));
	[image drawInRect:CGRectMake(0, 0, image.size.width * scaling, image.size.height *scaling)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

@end
