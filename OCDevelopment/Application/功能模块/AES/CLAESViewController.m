//
//  CLAESViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/8/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLAESViewController.h"
#import "NSString+CLEncode.h"
#import <UITextView+Placeholder.h>

@interface CLAESViewController ()
@property (weak, nonatomic) IBOutlet UITextField *secretKeyTextField;
@property (weak, nonatomic) IBOutlet UITextView *originalTextView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UIButton *encodeButton;
@property (weak, nonatomic) IBOutlet UIButton *decodeButton;

@end

@implementation CLAESViewController

static CLAESViewController *aesInstance = nil;
static dispatch_once_t onceTokenAES;

- (instancetype)init {
	dispatch_once(&onceTokenAES, ^{
		aesInstance = [super init];
	});
	return aesInstance;
}
#pragma mark 销毁单例
+ (void)destroy {
	onceTokenAES = 0l;
	aesInstance = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"AES加密解密";
	
	[self setup];
}

- (IBAction)didTapEncodeAction:(id)sender {
	NSString *text = [self.originalTextView.text AESEncryptWithKey:self.secretKeyTextField.text];
	if (text) {
		self.resultTextView.text = text;
	} else {
		self.resultTextView.text = @"加密失败";
	}
}

- (IBAction)didTapDecodeAction:(id)sender {
	NSString *text = [self.originalTextView.text AESDecryptWithKey:self.secretKeyTextField.text];
	if (text) {
		self.resultTextView.text = text;
	} else {
		self.resultTextView.text = @"解密失败";
	}
}

#pragma mark - 配置
- (void)setup {
	self.encodeButton.layer.cornerRadius = 22.0;
	self.encodeButton.layer.masksToBounds = YES;
	
	self.decodeButton.layer.cornerRadius = 22.0;
	self.decodeButton.layer.masksToBounds = YES;
	
	/// 内容
	self.originalTextView.placeholder = @"请输入待加密/解密原文";
	self.originalTextView.placeholderColor = COLOR_PLACEHOLDER;
	
	self.originalTextView.layer.borderColor =  [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
	self.originalTextView.layer.borderWidth = 1;
	self.originalTextView.layer.cornerRadius = 6;
	self.originalTextView.layer.masksToBounds = YES;
	
	self.resultTextView.placeholder = @"将显示加密/解密结果";
	self.resultTextView.placeholderColor = COLOR_PLACEHOLDER;
	
	self.resultTextView.layer.borderColor =  [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
	self.resultTextView.layer.borderWidth = 1;
	self.resultTextView.layer.cornerRadius = 6;
	self.resultTextView.layer.masksToBounds = YES;

	self.resultTextView.text = @"";
	self.originalTextView.text = @"ywwF8yAjDkOVMv4gsO/WuOBTl/zWnd+QBUBCoreeeSQwgh0OSrsr113sXKBAukJ+XnlZsd/zYukjZJdi26oK8/QLWOyQkvlFBhkWD7inIgVBIkJxpYeQQRzPq6/bgQeoFjYbomm1h7GsKTZ0vIvcPbJ6NUjK5zK0Qfq1Df8TKauGpSzUctrSgY1hnxC45pKX";
	self.secretKeyTextField.text = @"abcd1234";
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
