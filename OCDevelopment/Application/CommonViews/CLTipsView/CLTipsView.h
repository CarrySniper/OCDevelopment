//
//  CLTipsView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLTipsView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, weak) IBOutlet UIButton *button;


/// 按键点击操作处理block
@property (nonatomic, copy) CLVoidHandler actionHandler;

@end

NS_ASSUME_NONNULL_END
