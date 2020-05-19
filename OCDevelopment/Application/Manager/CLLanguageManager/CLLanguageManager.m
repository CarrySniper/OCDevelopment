//
//  CLLanguageManager.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLLanguageManager.h"

/*假如宏定义比较多,建议用FOUNDATION_EXPORT。*/
CLStringType CLLanguageOfSimplifiedChinese 	= @"zh-Hans";     // 简体中文
CLStringType CLLanguageOfTraditionalChinese = @"zh-Hant";     // 繁体中文
CLStringType CLLanguageOfEnglish 			= @"en";          // 英文

/// NSUserDefaults键字符串
static CLStringType kCLKeyForAppLanguage = @"CLAppLanguage";

/// 语言文件名.string
static CLStringType kCLNameForLanguageFile = @"CLLanguage";

/// 通知——语言改变
static CLStringType kCLNotificationLanguageChange = @"CLNotificationLanguageChange";

@implementation CLLanguageManager

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

static CLLanguageManager *instance = nil;
static dispatch_once_t onceToken;
- (instancetype)init
{
    dispatch_once(&onceToken, ^{
        instance = [super init];
        // FIXME: 没有设置过语言，就获取当前系统语言，并设置为APP语言
        if (!self.currentLanguage) {
            if ([self.systemLanguage hasPrefix:CLLanguageOfSimplifiedChinese]) {//开头匹配
                self.currentLanguage = CLLanguageOfSimplifiedChinese;
            } else if ([self.systemLanguage hasPrefix:CLLanguageOfTraditionalChinese]) {
                self.currentLanguage = CLLanguageOfTraditionalChinese;
			} else {
				self.currentLanguage = CLLanguageOfEnglish;
			}
        }
		[self setCurrentLanguage:self.currentLanguage];
    });
    return instance;
}

#pragma mark 根据键值获取对应文字。table为语言文件名Language.strings
- (NSString *)matchString:(NSString *)string {
    NSString *path = [self currentLanguagePath];
    NSString *matchString = [[NSBundle bundleWithPath:path] localizedStringForKey:string value:nil table:kCLNameForLanguageFile];
    return matchString ? matchString : string;
}

#pragma mark -
#pragma mark 内部方法
/// 设置当前语言
/// @param currentLanguage 可选择的语言 CLLanguageOf xxx
- (void)setCurrentLanguage:(NSString *)currentLanguage {
    if ([currentLanguage isEqualToString:self.currentLanguage]) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:currentLanguage forKey:kCLKeyForAppLanguage];
    [userDefaults synchronize];
    
    // 方法一：代理切换事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(languageManagerDidChanged:)]) {
        [self.delegate languageManagerDidChanged:currentLanguage];
    }
    // 方法二：发出切换通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kCLNotificationLanguageChange object:currentLanguage];
}

#pragma mark 系统语言，只读
- (NSString *)systemLanguage {
    return (NSString *)[[NSLocale preferredLanguages] objectAtIndex:0];
}

#pragma mark 获取保存在NSUserDefaults的本地语言
- (NSString *)currentLanguage {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCLKeyForAppLanguage];
}

#pragma mark 根据获取语言文件所在路径。文件名类型Type为lproj，即.lproj的文件夹。  zh-Hans.lproj和en.lproj
- (NSString *)currentLanguagePath {
    NSString *language = [self currentLanguage];
    return (NSString *)[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
}

#pragma mark -
#pragma mark 添加语言切换通知
+ (void)addNotificationCenter:(id)observer selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:kCLNotificationLanguageChange object:nil];
}

#pragma mark 移除语言切换通知
+ (void)removeNotificationCenter:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:kCLNotificationLanguageChange object:nil];
}

@end
