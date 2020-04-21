//
//  AFNetworkTool.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@class AFFileItem;

// MARK: - 枚举 请求方式
typedef NS_ENUM(NSInteger, AFRequestMethod) {
	AF_GET = 0,         // GET default 	查
	AF_HEAD,         	// HEAD 		查
	AF_POST,            // POST 		增
	AF_DELETE,          // DELETE 		删
	AF_PUT,             // PUT			改（不存在就增加）
	AF_PATCH,			// PATCH 		改（修改局部，PUT的补充）
	AF_UPLOAD = 998,    // 上传文件
};

// MARK: - 模版别名
typedef void (^AFProgressHandler)(NSProgress * _Nonnull progress);
typedef void (^AFResponseSuccessHandler)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void (^AFResponseFailureHandler)(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error);

#pragma mark - Class
@interface AFNetworkTool : NSObject

/// 会话管理
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

/// 是否是Json Raw Body传参方式 default NO
@property (nonatomic, assign) BOOL isJsonBody;

/// 是否要求Json格式返回 default YES，非json格式报3840错误
@property (nonatomic, assign) BOOL neesJsonResponse;

/// 请求超时时间 default 10s
@property (nonatomic, assign) NSTimeInterval requestTimeout;

/// 允许接收httpCode状态码范围，默认NSMakeRange(200, 1)，只接受200
@property (nonatomic, assign) NSRange acceptableStatusCodesRange;

/// 请求默认附加头部参数
@property (nonatomic, strong) NSDictionary * _Nullable defaultHeaders;

/// 请求默认附加参数
@property (nonatomic, strong) NSDictionary * _Nullable defaultParameters;

/// MARK: - 方法

/// 发出请求
/// @param requestMethod 请求方式
/// @param urlString 请求地址
/// @param headers 请求头
/// @param parameters 请求参数
/// @param success 成功的回调
/// @param failure 失败的回调
- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *_Nonnull)urlString
			  headers:(NSDictionary *_Nullable)headers
		   parameters:(id _Nullable)parameters
			  success:(AFResponseSuccessHandler _Nullable)success
			  failure:(AFResponseFailureHandler _Nullable)failure;

/// 上传文件
/// @param filesArray 二维文件数组 AFFileItem格式
/// @param urlString 请求地址
/// @param headers 请求头
/// @param parameters 请求参数
/// @param progress 进度回调
/// @param success 成功的回调
/// @param failure 失败的回调
- (void)uploadFilesArray:(NSArray<AFFileItem*> *_Nullable)filesArray
			   urlString:(NSString *_Nonnull)urlString
				 headers:(NSDictionary *_Nullable)headers
			  parameters:(id _Nullable)parameters
				progress:(AFProgressHandler _Nullable)progress
				 success:(AFResponseSuccessHandler _Nullable)success
				 failure:(AFResponseFailureHandler _Nullable)failure;

/// 恢复请求
- (void)resumeRequest;

/// 暂停请求
- (void)suspendRequest;

/// 取消请求
- (void)cancelRequest;

/// 取消所有请求
- (void)cancelAllRequest;

@end

// ================================只是规范传值数组元素格式================================
#pragma mark - 其他类对象
#pragma mark 上传文件Item
@interface AFFileItem : NSObject

/// 文件数据
@property (nonatomic, copy) NSData *fileData;

/// 服务器参数的名称
@property (nonatomic, copy) NSString *name;

/// 保存文件名称:a.png
@property (nonatomic, copy) NSString *fileName;

/// 文件文件的类型:image/jpeg video/mp4
@property (nonatomic, copy) NSString *mimeType;

@end

#pragma mark - 内联函数 CG_INLINE NS_INLINE
NS_INLINE AFFileItem *AFFileItemMake(NSData *fileData, NSString *name, NSString *fileName, NSString *mimeType) {
	AFFileItem *item = [AFFileItem new];
	
	item.fileData = fileData;
	item.name = name;
	item.fileName = fileName;
	item.mimeType = mimeType;
	return item;
}

NS_ASSUME_NONNULL_END
