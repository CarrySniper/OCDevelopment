//
//  CLShareViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/5/5.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLShareViewController.h"
#import "CLTextView.h"

@interface CLShareViewController ()

/// 标题
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

/// 内容
@property (weak, nonatomic) IBOutlet CLTextView *contentTextView;

/// 链接
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

/// 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation CLShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	NSDictionary *data = self.routerParameters[MGJRouterParameterUserInfo];
	self.title = data[@"title"];
	
	[self setup];
}

#pragma mark - Action
#pragma mark 分享
- (IBAction)shareAction:(id)sender {
	if ([self.titleTextField.text trimSpaces].length == 0 &&
		[self.contentTextView.text trimSpaces].length == 0 &&
		[self.urlTextField.text trimSpaces].length == 0
		) {
		SHOW_TOAST_INFO(@"需要填写一项内容");
		return;
	}
	[AppDelegate shareWithTitle:[self.titleTextField.text trimSpaces] content:[self.contentTextView.text trimSpaces] image:nil URL:[NSURL URLWithString:[self.urlTextField.text trimSpaces]] completionHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
		
	}];
}

#pragma mark - 配置
- (void)setup {
	self.doneButton.layer.cornerRadius = 22.0;
	self.contentTextView.layer.masksToBounds = YES;
	
	// 内容
//	self.contentTextView.delegate = self;
	self.contentTextView.font = [UIFont systemFontOfSize:14];
	self.contentTextView.placeholder = @"请输入内容";
	self.contentTextView.placeholderColor = COLOR_PLACEHOLDER;
	
	self.contentTextView.layer.borderColor =  [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
	self.contentTextView.layer.borderWidth = 1;
	self.contentTextView.layer.cornerRadius = 6;
	self.contentTextView.layer.masksToBounds = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
