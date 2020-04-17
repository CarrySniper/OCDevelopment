//
//  UIColor+CLCategory.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//--------------颜色配置---------------
#define COLOR_THEME           		[UIColor colorWithLightHexString:@"#F32524" darkHexString:@""]//主题颜色
#define COLOR_NAVIGATION            [UIColor colorWithLightHexString:@"#E5E5E5" darkHexString:@"#17191D"]//导航栏
#define COLOR_TABBAR                [UIColor colorWithLightHexString:@"#E5E5E5" darkHexString:@"#17191D"]//选项栏
#define COLOR_TITLE                 [UIColor colorWithLightHexString:@"#17191D" darkHexString:@"#E5E5E5"]//标题颜色
#define COLOR_VIEW                  [UIColor colorWithLightHexString:@"#E5E5E5" darkHexString:@"17191D"]//背景颜色
#define COLOR_CELL                  [UIColor colorWithLightHexString:@"#E5E5E5" darkHexString:@"17191D"]//背景颜色
#define COLOR_SECTION               [UIColor colorWithLightHexString:@"#C1C1C1" darkHexString:@"#202226"]//SECTION颜色
#define COLOR_LINE                  [UIColor colorWithLightHexString:@"#DDDDDD" darkHexString:@""]//线条颜色

#define COLOR_NORMAL           		[UIColor colorHexString:@"#737577"]	//正常状态
#define COLOR_SELECTED           	[UIColor colorHexString:@"#4E56FF"]	//选中状态

#define COLOR_LIGHT_GRAY            [UIColor colorWithLightHexString:@"#999999" darkHexString:@"666666"]//字体浅灰色
#define COLOR_GRAY                  [UIColor colorWithLightHexString:@"#696969" darkHexString:@"969696"]//字体灰色
#define COLOR_BLACK                 [UIColor colorWithLightHexString:@"#333333" darkHexString:@"DDDDDD"]//字体黑色
#define COLOR_PLACEHOLDER           [UIColor colorWithLightHexString:@"#838298" darkHexString:@""]//占位符字体黑色
#define COLOR_TEXT           		[UIColor colorWithLightHexString:@"#2B2B2B" darkHexString:@""]//字体黑色

@interface UIColor (CLCategory)

/// 获取十六进制字符串转颜色
/// @param lightHexString 浅色字符串
/// @param darkHexString 深色字符串，格式：@"FFFFFF"
+ (UIColor *)colorWithLightHexString:(NSString *)lightHexString darkHexString:(NSString *)darkHexString;

/// 获取颜色
/// @param lightColor 浅色
/// @param darkColor 深色
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

/// 获取颜色
/// @param hex 十六进制数值，格式：0xFFFFFF
+ (UIColor *)colorHex:(NSUInteger)hex;

/// 获取颜色，带透明度
/// @param hex 十六进制数值，格式：0xFFFFFF
/// @param alpha 透明度：0.0f～1.0f
+ (UIColor *)colorHex:(NSUInteger)hex alpha:(CGFloat)alpha;

/// 获取颜色
/// @param hexString 十六进制RGB字符串，格式：@"FFFFFF"
+ (UIColor *)colorHexString:(NSString *)hexString;

/// 获取颜色，带透明度
/// @param hexString 十六进制RGB字符串，格式：@"FFFFFF"
/// @param alpha 透明度：0.0f～1.0f
+ (UIColor *)colorHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
