//
//  NSString+CLEncode.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/8/10.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CLEncode)

/// 哈希算法
- (NSString *)SHA1;

/// 32位MD5加密
- (NSString *)md5HexDigest;

/// Base64加密
- (NSString *)base64Encode;

/// Base64解密
- (NSString *)base64Decode;

/// AES128/ECB/PKCS7Padding/Base64 加密
/// @param secretKey 密钥
- (NSString *)AESEncryptWithKey:(NSString *)secretKey;

/// AES128/ECB/PKCS7Padding/Base64 解密
/// @param secretKey 密钥
/// @return 解密字符串
- (NSString *)AESDecryptWithKey:(NSString *)secretKey;

/// AES128/ECB/PKCS7Padding/Base64 解密
/// @param secretKey 密钥
/// @return 解密数据
- (NSData *)dataAESDecryptWithKey:(NSString *)secretKey;

@end

NS_ASSUME_NONNULL_END
