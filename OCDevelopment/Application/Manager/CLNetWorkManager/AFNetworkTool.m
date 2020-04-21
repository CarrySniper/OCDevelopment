//
//  AFNetworkTool.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AFNetworkTool.h"

@interface AFNetworkTool ()

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;
@property (nonatomic, strong) NSURLSessionDataTask *currentDataTask;

@end

@implementation AFNetworkTool

#pragma mark - Lazy Loading
#pragma mark AFHTTPSessionManager 请求会话
- (AFHTTPSessionManager *)sessionManager {
	if (!_sessionManager) {
		_sessionManager = [AFHTTPSessionManager manager];
	}
	return _sessionManager;
}

#pragma mark AFHTTPRequestSerializer 请求
- (AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer {
	AFHTTPRequestSerializer *requestSerializer;
	if (self.isJsonBody) {
		// post json raw body
		requestSerializer = [AFJSONRequestSerializer serializer];
	} else {
		requestSerializer = [AFHTTPRequestSerializer serializer];
	}
	// 设置超时时间(设置有效)
	[requestSerializer willChangeValueForKey:@"timeoutInterval"];
	requestSerializer.timeoutInterval = MAX(self.requestTimeout, 0);
	[requestSerializer didChangeValueForKey:@"timeoutInterval"];
	return requestSerializer;
}

#pragma mark AFHTTPResponseSerializer 响应
- (AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer {
	AFHTTPResponseSerializer *responseSerializer;
	if (self.neesJsonResponse) {
		responseSerializer = [AFJSONResponseSerializer serializer];
	} else {
		responseSerializer = [AFHTTPResponseSerializer serializer];
	}
	responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"charset=UTF-8", nil];
	responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:self.acceptableStatusCodesRange];//200~502
	return responseSerializer;
}

#pragma mark - Init
- (instancetype)init
{
	self = [super init];
	if (self) {
		self.isJsonBody = NO;
		self.neesJsonResponse = YES;
		self.requestTimeout = 10.0;
		self.acceptableStatusCodesRange = NSMakeRange(200, 1);
	}
	return self;
}

- (void)dealloc {
	[_sessionManager.operationQueue cancelAllOperations];
	[_sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
	_sessionManager = nil;
}

#pragma mark - 网络请求，回调请求成功和失败
- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *_Nonnull)urlString
			  headers:(NSDictionary *_Nullable)headers
		   parameters:(id _Nullable)parameters
			  success:(AFResponseSuccessHandler)success
			  failure:(AFResponseFailureHandler)failure
{
	self.currentDataTask = [self cl_makeDataTaskWithRequestMethod:requestMethod
													 urlString:urlString
													filesArray:nil
													   headers:headers
													parameters:parameters
													  progress:nil
													   success:success
													   failure:failure];
}

#pragma mark - 上传文件
- (void)uploadFilesArray:(NSArray<AFFileItem*> *_Nullable)filesArray
			   urlString:(NSString *_Nonnull)urlString
				 headers:(NSDictionary *_Nullable)headers
			  parameters:(id _Nullable)parameters
				progress:(AFProgressHandler)progress
				 success:(AFResponseSuccessHandler)success
				 failure:(AFResponseFailureHandler)failure
{
	self.currentDataTask = [self cl_makeDataTaskWithRequestMethod:AF_UPLOAD
													 urlString:urlString
													filesArray:filesArray
													   headers:headers
													parameters:parameters
													  progress:progress
													   success:success
													   failure:failure];
}

#pragma mark - 私有方法（Private）
#pragma mark 请求附加头部参数
- (NSMutableDictionary *)setHeaders:(NSDictionary *)headers {
	// 如果有相同key，用传入的参数代替默认参数值
	NSMutableDictionary *allParameter = [NSMutableDictionary dictionaryWithDictionary:self.defaultHeaders];
	[allParameter setValuesForKeysWithDictionary:headers];
	return allParameter;
}

#pragma mark 请求附加参数
- (NSMutableDictionary *)setParameters:(NSDictionary *)parameters {
	// 如果有相同key，用传入的参数代替默认参数值
	NSMutableDictionary *allParameter = [NSMutableDictionary dictionaryWithDictionary:self.defaultHeaders];
	[allParameter setValuesForKeysWithDictionary:parameters];
	return allParameter;
}

#pragma mark 设置请求头, AFN4.0后面不需要
- (void)setHeaderField:(NSDictionary *_Nullable)headers {
	for (NSString *key in headers.allKeys) {
		[self.sessionManager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
	}
}

#pragma mark 会话数据的任务
- (NSURLSessionDataTask *)cl_makeDataTaskWithRequestMethod:(AFRequestMethod)requestMethod
											  urlString:(NSString *_Nonnull)urlString
											 filesArray:(NSArray<AFFileItem*> *_Nullable)filesArray
												headers:(NSDictionary *_Nullable)headers
											 parameters:(id _Nullable)parameters
											   progress:(AFProgressHandler)progress
												success:(AFResponseSuccessHandler)success
												failure:(AFResponseFailureHandler)failure {
	
	
	// 获取请求、响应序列化器
	self.sessionManager.requestSerializer = self.requestSerializer;
	self.sessionManager.responseSerializer = self.responseSerializer;
	
	// 设置请求头，重置请求序列化器头部验证
	[self.sessionManager.requestSerializer clearAuthorizationHeader];
	headers = [self setHeaders:headers];
	//[self setHeaderField:headers];//AFN4.0之后换了位置
	
	// 请求附加参数
	parameters = [self setParameters:parameters];
	
	// 会话对象
	NSString *method = @"未知";
	NSURLSessionDataTask *dataTask;
	switch (requestMethod) {
			//GET 方法
		default: {
			method = @"GET";
			dataTask = [self.sessionManager GET:urlString parameters:parameters headers:headers progress:nil success:success failure:failure];
		}   break;
			//HEAD 方法
		case AF_HEAD: {
			method = @"HEAD";
			dataTask = [self.sessionManager HEAD:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task) {
				if (success) {
					success(task, nil);
				}
			} failure:failure];
		}   break;
			//POST 方法
		case AF_POST:{
			method = @"POST";
			dataTask = [self.sessionManager POST:urlString parameters:parameters headers:headers progress:nil success:success failure:failure];
		}   break;
			//AF_DELETE 方法
		case AF_DELETE:{
			method = @"DELETE";
			dataTask = [self.sessionManager DELETE:urlString parameters:parameters headers:headers success:success failure:failure];
		}   break;
			//AF_PUT 方法
		case AF_PUT:{
			method = @"PUT";
			dataTask = [self.sessionManager PUT:urlString parameters:parameters headers:headers success:success failure:failure];
		}   break;
			//AF_PATCH 方法
		case AF_PATCH:{
			method = @"PATCH";
			dataTask = [self.sessionManager PATCH:urlString parameters:parameters headers:headers success:success failure:failure];
		}   break;
			//UPLOAD
		case AF_UPLOAD:{
			method = @"POST上传";
			dataTask = [self.sessionManager POST:urlString parameters:parameters headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
				/*
				 fileData: 需要上传的数据
				 name: 服务器参数的名称
				 fileName: 文件名称
				 mimeType: 文件的类型
				 */
				if (filesArray.count > 0) {
					for (AFFileItem *fileItem in filesArray) {
						@autoreleasepool {
							[formData appendPartWithFileData:fileItem.fileData
								name:fileItem.name
							fileName:fileItem.fileName
							mimeType:fileItem.mimeType];
						}
					}
				}
			} progress:progress success:success failure:failure];
		}   break;
	}
	NSLog(@"\n网络请求:%@\n--API: %@ \n--Headers: %@ \n--Parameters: %@", method, urlString, headers, parameters);
	return dataTask;
}

#pragma mark - 请求操作
#pragma mark 恢复请求
- (void)resumeRequest {
	if (self.currentDataTask.state == NSURLSessionTaskStateSuspended) {
		[self.currentDataTask resume];;
	}
}

#pragma mark 暂停请求
- (void)suspendRequest {
	if (self.currentDataTask.state == NSURLSessionTaskStateRunning) {
		[self.currentDataTask suspend];
	}
}

#pragma mark 取消请求
- (void)cancelRequest {
	if (self.currentDataTask.state == NSURLSessionTaskStateRunning ||
		self.currentDataTask.state == NSURLSessionTaskStateSuspended) {
		[self.currentDataTask cancel];
	}
}

#pragma mark 取消所有请求
- (void)cancelAllRequest {
    [self.sessionManager.operationQueue cancelAllOperations];
}

@end

#pragma mark - Item
@implementation AFFileItem

@end
