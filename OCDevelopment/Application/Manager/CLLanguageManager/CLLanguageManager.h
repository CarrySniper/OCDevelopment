//
//  CLLanguageManager.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CLLocalized(key) [[CLLanguageManager sharedInstance] matchString:(key)]

/// 可选择的语言，PROJECT处添加支持语言，创建String Flie文件，勾选对应的本地化语言
typedef NSString * const CLStringType NS_STRING_ENUM;
 
FOUNDATION_EXPORT CLStringType CLLanguageOfSimplifiedChinese;		// 简体中文
FOUNDATION_EXPORT CLStringType CLLanguageOfTraditionalChinese;		// 繁体中文
FOUNDATION_EXPORT CLStringType CLLanguageOfEnglish;					// 英文

#pragma mark - 方法一：可使用通知模式，监听语言修改
@protocol CLLanguageManagerDelegate<NSObject>

- (void)languageManagerDidChanged:(NSString *)language;

@end
// ==============================

#pragma mark - Class
@interface CLLanguageManager : NSObject

/// 系统语言，只读
@property (nonatomic, strong, readonly) NSString *systemLanguage;

/// 当前语言，只读
@property (nonatomic, strong, readonly) NSString *currentLanguage;

/// 语言切换代理
@property (nonatomic, weak) id<CLLanguageManagerDelegate> delegate;

/// 单例获取
+ (instancetype)sharedInstance;

/// 根据键值获取对应文字。table为语言文件名Language.strings亦可直接使用宏定义：CLLocalized(string)
/// @param string 要翻译的词
- (NSString *)matchString:(NSString *)string;

/// 设置当前语言
/// @param currentLanguage 可选择的语言 CLLanguageOf xxx
- (void)setCurrentLanguage:(NSString *)currentLanguage;

#pragma mark - 方法二：可使用通知模式，监听语言修改
/// 添加语言切换通知
/// @param observer 观察者
/// @param selector 选择器
+ (void)addNotificationCenter:(id)observer selector:(SEL)selector;

/// 移除语言切换通知
/// @param observer 观察者
+ (void)removeNotificationCenter:(id)observer;

@end

NS_ASSUME_NONNULL_END

/*
 #import "CLLanguageManager.h"
 NSLog(@"系统语言：%@", [[CLLanguageManager sharedInstance] systemLanguage]);
 NSLog(@"当前语言：%@", [[CLLanguageManager sharedInstance] currentLanguage]);
 NSLog(@"测试语言：%@", CLLocalized(@"apple"));
 
 方法一：
 设置代理协议及方法：<CLLanguageManagerDelegate>
 [CLLanguageManager sharedInstance].delegate = self;
 - (void)notificationLanguageDidChanged:(NSString *)language {
 NSLog(@"当前语言：%@", language);
 }
 
 
 方法二：
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 // MARK: 添加语言切换通知
 [CLLanguageManager addNotificationCenter:self selector:@selector(notificationLanguageDidChanged:)];
 }
 
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 
 // MARK: 移除语言切换通知
 [CLLanguageManager removeNotificationCenter:self];
 }
 
 
 #pragma mark - NSNotification
 #pragma mark 语言切换通知事件
 - (void)notificationLanguageDidChanged:(NSNotification *)notification
 {
 NSString *currentLanguage = notification.object;
 NSLog(@"当前语言：%@", currentLanguage);
 }
 */
