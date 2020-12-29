//
//  CLToastView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/8/4.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLToastView.h"

// MARK: - 声明定义一个ToastLabel对象
@interface CLToastLabel : UILabel

/// 设置显示的文字
/// @param text 文字文本
- (CGRect)setMessageText:(NSString *)text;

@end

// MARK: - 声明定义一个ToastWindow对象
@interface CLToastWindow : UIWindow
+ (instancetype)sharedInstance;
- (void)show;
- (void)hide;
@end

// MARK: - 接口
@interface CLToastView ()

/// 标签
@property (nonatomic, strong) CLToastLabel *toastLabel;
/// 定时器
@property (nonatomic, strong) NSTimer *countTimer;
/// 计数
@property (nonatomic, assign) int changeCount;

@end

#pragma mark - 实现CLToastView的方法
@implementation CLToastView

- (CLToastWindow *)addToWindow {
    return [CLToastWindow sharedInstance];
}

+ (instancetype)sharedInstance {
    static CLToastView *instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        instance = [[super allocWithZone:NULL] initWithEffect:blurEffect];
        instance.layer.cornerRadius = 8;
        instance.layer.masksToBounds = YES;
        instance.contentView.backgroundColor = [UIColor grayColor];
        
        /// 标签
        instance.toastLabel = [[CLToastLabel alloc]init];
        [instance.contentView addSubview:instance.toastLabel];
        
        /// 定时器
        instance.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:instance selector:@selector(changeTime) userInfo:nil repeats:YES];
        /// 关闭定时器
        instance.countTimer.fireDate = [NSDate distantFuture];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [CLToastView sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [CLToastView sharedInstance];
}

/// 弹出并显示Toast
/// @param message 文本内容
/// @param duration 显示时间
/// @param position 位置
- (void)showWithMessage:(NSString *)message duration:(CGFloat)duration position:(CLToastPosition)position {
    if ([message length] == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [self.toastLabel setMessageText:message];
        CGFloat width = rect.size.width+rect.origin.x*2.0;
        CGFloat height = rect.size.height+rect.origin.y*2.0;
        CGFloat x = (SCREEN_WIDTH - width) / 2;
        CGFloat y = 0;
        if (position == CLToastPosition_Top) {
            y = TOP_BAR_HEIGHT;
        }else if (position == CLToastPosition_Center) {
            y = (SCREEN_HEIGHT - height) / 2;
        }else{
            y = SCREEN_HEIGHT - height - TABBAR_HEIGHT;
        }
        self.frame = CGRectMake(x, y, width, height);
        
        [self.addToWindow show];
        [self.addToWindow addSubview:self];
        
        self.alpha = 1.0;
        /// 开启定时器
        self.countTimer.fireDate = [NSDate distantPast];
        self.changeCount = duration;
    });
}

/// 隐藏Toast
- (void)hide {
    self.changeCount = 0;
    [self changeTime];
}

/// 定时器回调方法
- (void)changeTime {
    //NSLog(@"时间：%d",changeCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.changeCount-- <= 0){
            self.countTimer.fireDate = [NSDate distantFuture];//关闭定时器
            [UIView animateWithDuration:0.2f animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [self.addToWindow hide];
            }];
        }
    });
}

#pragma mark -
#pragma mark 字体颜色
- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.toastLabel.textColor = textColor;
        });
    }
}
#pragma mark 字体
- (void)setFont:(UIFont *)font {
    if (font) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.toastLabel.font = font;
        });
    }
}

@end

#pragma mark - 实现CLToastLabel的方法
@implementation CLToastLabel

/// 初始化，为label设置各种属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:15];
        self.numberOfLines = 0;
    }
    return self;
}

/// 设置显示的文字
/// @param text 文字文本
- (CGRect)setMessageText:(NSString *)text {
    /// 样式 - 增加行高
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    style.alignment = NSTextAlignmentCenter;
    /// 属性
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : style,
        NSFontAttributeName : self.font,
        NSForegroundColorAttributeName : self.textColor
    };
    /// 富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text attributes:attributes];
    self.attributedText = attributedString;
    /// 大小
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-62, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    self.frame = CGRectMake(20, 20, rect.size.width, rect.size.height);
    return self.frame;
}

@end

#pragma mark - 实现CLToastWindow的方法
@implementation CLToastWindow

+ (instancetype)sharedInstance {
    static CLToastWindow *instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
        if (@available(iOS 11, *)) {
            instance.windowLevel = UIWindowLevelStatusBar + 1688;// 比这小的值都要被我遮挡
        } else {
            instance.windowLevel = UIWindowLevelAlert;
        }
        /// 设置背景颜色透明
        instance.backgroundColor = [UIColor clearColor];
        /// 设主键并可视化
        [instance makeKeyAndVisible];
    });
    return instance;
}

- (void)show {
    self.hidden = NO;
    [self makeKeyAndVisible];
}

- (void)hide {
    self.hidden = YES;
    [self resignKeyWindow];
}

#pragma mark 重写事件传递方法，作用于，只要点击的自身容器背景（没有控件的地方），都穿透到底层响应。
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}

@end
