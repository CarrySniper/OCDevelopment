//
//  NSString+CLEncode.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/8/10.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "NSString+CLEncode.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (CLEncode)

#pragma mark - 哈希算法
- (NSString *)SHA1 {
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes,(unsigned int)data.length,digest);
	NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
	
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[outputString appendFormat:@"%02x",digest[i]];
	}
	return [outputString lowercaseString];
}

#pragma mark - 32位MD5加密
- (NSString *)md5HexDigest {
	const char *original_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", result[i]];
	return [hash lowercaseString];
}

#pragma mark - base64加密
- (NSString *)base64Encode {
	/// 1、先将string转化为data二进制数据
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	/// 2、对二进制数据进行base64编码，返回编码后的字符串
	return [data base64EncodedStringWithOptions:0];
}

#pragma mark - base64解密
- (NSString *)base64Decode {
	/// 1、先将base64编码后的字符串『解码』为二进制数据
	NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
	/// 2、把二进制数据转换为字符串返回
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - AES128/ECB/PKCS7Padding/Base64加密
- (NSString *)AESEncryptWithKey:(NSString *)secretKey {
	/// Base64方式
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSUInteger dataLength = [data length];
	/// AES128
	size_t size = kCCBlockSizeAES128;
	CCAlgorithm algorithm = kCCAlgorithmAES128;
	/// 数据量
	size_t bufferSize = dataLength + size;
	void *buffer = malloc(bufferSize);
	size_t numBytesCrypted = 0;
	/// 加密kCCEncrypt
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, algorithm,
										  kCCOptionPKCS7Padding | kCCOptionECBMode,
										  [secretKey UTF8String], size,
										  NULL,//偏移量
										  [data bytes], dataLength,
										  buffer, bufferSize,
										  &numBytesCrypted);
	if (cryptStatus == kCCSuccess) {
		NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
		/// Base64方式
		return [resultData base64EncodedStringWithOptions:0];
	}
	free(buffer);
	return nil;
}

#pragma mark - AES128/ECB/PKCS7Padding/Base64解密
- (NSString *)AESDecryptWithKey:(NSString *)secretKey {
	NSData *data = [self dataAESDecryptWithKey:secretKey];
	if (data) {
		return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	return nil;
}

#pragma mark - AES128/ECB/PKCS7Padding/Base64解密
- (NSData *)dataAESDecryptWithKey:(NSString *)secretKey {
	/// Base64方式
	NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
	NSUInteger dataLength = [data length];
	/// AES128
	size_t size = kCCBlockSizeAES128;
	CCAlgorithm algorithm = kCCAlgorithmAES128;
	/// 数据量
	size_t bufferSize = dataLength + size;
	void *buffer = malloc(bufferSize);
	size_t numBytesCrypted = 0;
	/// 解密kCCDecrypt
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, algorithm,
										  kCCOptionPKCS7Padding | kCCOptionECBMode,
										  [secretKey UTF8String], size,
										  NULL,//偏移量
										  [data bytes], dataLength,
										  buffer, bufferSize,
										  &numBytesCrypted);
	if (cryptStatus == kCCSuccess) {
		return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
	}
	free(buffer);
	return nil;
}

//- (NSString *)AESDecryptWithKey:(NSString *)secretKey {
//	/// Base64方式
//	NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
//	NSUInteger dataLength = [data length];
//	/// AES128
//	size_t size = kCCBlockSizeAES128;
//	CCAlgorithm algorithm = kCCAlgorithmAES128;
//	/// 数据量
//	size_t bufferSize = dataLength + size;
//	void *buffer = malloc(bufferSize);
//	size_t numBytesCrypted = 0;
//
//	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, algorithm,
//										  kCCOptionPKCS7Padding | kCCOptionECBMode,
//										  [secretKey UTF8String], size,
//										  NULL,//偏移量
//										  [data bytes], dataLength,
//										  buffer, bufferSize,
//										  &numBytesCrypted);
//	if (cryptStatus == kCCSuccess) {
//		NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
//		return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
//	}
//	free(buffer);
//	return nil;
//}
@end
