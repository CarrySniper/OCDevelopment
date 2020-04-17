//
//  UIColor+CLCategory.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UIColor+CLCategory.h"

@implementation UIColor (CLCategory)

+ (UIColor *)colorWithLightHexString:(NSString *)lightHexString darkHexString:(NSString *)darkHexString {
	return [self colorWithLightColor:[UIColor colorHexString:lightHexString] darkColor:[UIColor colorHexString:darkHexString]];
}

+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
	if (@available(iOS 13.0, *)) {
		return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
			if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
				return darkColor;
			} else {
				return lightColor;
			}
		}];
	} else {
		return lightColor;
	}
}

+ (UIColor *)colorHex:(NSUInteger)hex {
	return [self colorHex:hex alpha:1.0];
}

+ (UIColor *)colorHex:(NSUInteger)hex alpha:(CGFloat)alpha {
	return [UIColor colorWithRed:(((hex & 0xFF0000) >> 16))/255.0 green:(((hex &0xFF00) >>8))/255.0 blue:((hex &0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)colorHexString:(NSString *)hexString {
	return [self colorHexString:hexString alpha:1.0];
}

+ (UIColor *)colorHexString:(NSString *)hexString alpha:(CGFloat)alpha {
	hexString = [hexString lowercaseString];
	hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] ;
	hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
	if (hexString.length != 6) {
		return UIColor.clearColor;
	}
	return [UIColor colorWithRed:((strtoul([hexString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16) & 0xFF0000 )>>16)/255.0 green:((strtoul([hexString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16) & 0x00FF00 )>>8)/255.0 blue:(strtoul([hexString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16) & 0x0000FF)/255.0 alpha:alpha];
}

@end
