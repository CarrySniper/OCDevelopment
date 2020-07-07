//
//  CLPickerToolView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/13.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPickerToolView.h"

@interface CLPickerToolView ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 返回按钮
@property (nonatomic, strong) UIButton *backButton;

/// 确认按钮
@property (nonatomic, strong) UIButton *confirmButton;

/// 类型 定位/选择
@property (nonatomic, strong) UILabel *typeLabel;

/// 地址
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation CLPickerToolView

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.title = @"选择地区";
		self.typeName = @"选择";
		self.titleColor = [UIColor blackColor];
		self.textColor = [UIColor grayColor];
		self.confirmTextColor = [UIColor blackColor];
		self.backImage = [UIImage imageNamed:@"icon_cl_item_back"];
		
		[self addSubview:self.titleLabel];
		[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.top.equalTo(self);
			make.height.mas_equalTo(44);
		}];
		[self addSubview:self.backButton];
		[self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self);
			make.left.equalTo(self).offset(16);
			make.width.mas_equalTo(44);
			make.height.mas_equalTo(44);
		}];
		[self addSubview:self.confirmButton];
		[self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self);
			make.right.equalTo(self).offset(-16);
			make.width.mas_equalTo(44);
			make.height.mas_equalTo(44);
		}];
		[self addSubview:self.typeLabel];
		[self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.left.equalTo(self).offset(16);
			make.height.mas_equalTo(36);
		}];
		[self addSubview:self.addressLabel];
		[self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.left.equalTo(self.typeLabel.mas_right).offset(16);
			make.right.equalTo(self).offset(-16);
			make.height.mas_equalTo(36);
		}];
	}
	return self;
}

#pragma mark - Action
- (void)backAction {
	if (self.pickerProtocol && [self.pickerProtocol respondsToSelector:@selector(pickerToolViewWithBackAction:)]) {
		[self.pickerProtocol pickerToolViewWithBackAction:self];
	}
}

- (void)confirmAction {
	if (self.pickerProtocol && [self.pickerProtocol respondsToSelector:@selector(pickerToolViewWithConfirmAction:)]) {
		[self.pickerProtocol pickerToolViewWithConfirmAction:self];
	}
}

#pragma mark -
- (void)setTitle:(NSString *)title {
	if (title) {
		self.titleLabel.text = title;
	}
}

- (void)setTypeName:(NSString *)typeName {
	if (typeName) {
		self.typeLabel.text = typeName;
	}
}

- (void)setAddress:(NSString *)address {
	if (address) {
		self.addressLabel.text = address;
	}
}

- (void)setBackImage:(UIImage *)backImage {
	if (backImage) {
		[self.backButton setImage:backImage forState:(UIControlStateNormal)];
		[self.backButton setTitle:nil forState:(UIControlStateNormal)];
	}
}

- (void)setBackText:(NSString *)backText {
	if (backText) {
		[self.backButton setImage:nil forState:(UIControlStateNormal)];
		[self.backButton setTitle:backText forState:(UIControlStateNormal)];
	}
}

- (void)setTitleColor:(UIColor *)titleColor {
	if (titleColor) {
		self.titleLabel.textColor = titleColor;
	}
}

- (void)setTextColor:(UIColor *)textColor {
	if (textColor) {
		self.typeLabel.textColor = textColor;
		self.addressLabel.textColor = textColor;
	}
}

- (void)setConfirmTextColor:(UIColor *)confirmTextColor {
	[self.backButton setTitleColor:confirmTextColor forState:(UIControlStateNormal)];
	[self.confirmButton setTitleColor:confirmTextColor forState:(UIControlStateNormal)];
}

#pragma mark - Getter
#pragma mark 标题
- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.text = self.title;
		_titleLabel.textColor = self.titleColor;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
	}
	return _titleLabel;
}

#pragma mark 类型
- (UILabel *)typeLabel {
	if (!_typeLabel) {
		_typeLabel = [[UILabel alloc] init];
		_typeLabel.text = self.typeName;
		_typeLabel.textColor = self.textColor;
		_typeLabel.textAlignment = NSTextAlignmentLeft;
		_typeLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
	}
	return _typeLabel;
}

#pragma mark 类型
- (UILabel *)addressLabel {
	if (!_addressLabel) {
		_addressLabel = [[UILabel alloc] init];
		_addressLabel.text = @"无";
		_addressLabel.textColor = self.textColor;
		_addressLabel.textAlignment = NSTextAlignmentRight;
		_addressLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
	}
	return _addressLabel;
}

#pragma mark 返回按钮
- (UIButton *)backButton {
	if (!_backButton) {
		_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_backButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
		[_backButton setImage:self.backImage forState:(UIControlStateNormal)];
		[_backButton setTitleColor:self.confirmTextColor forState:(UIControlStateNormal)];
		[_backButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
		[_backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
	}
	return _backButton;
}

#pragma mark 确认按钮
- (UIButton *)confirmButton {
	if (!_confirmButton) {
		_confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_confirmButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
		[_confirmButton setTitle:@"确认" forState:(UIControlStateNormal)];
		[_confirmButton setTitleColor:self.confirmTextColor forState:(UIControlStateNormal)];
		[_confirmButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
		[_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
	}
	return _confirmButton;
}

@end
