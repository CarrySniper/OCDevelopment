//
//  CLMineHomeViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMineHomeViewController.h"

@interface CLMineHomeViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CLMineHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.leftBarButtonItem = nil;
	
	[self.imageView setImageWithURL:[NSURL URLWithString:@"http://qianhe.cn-gd.ufileos.com/8b85f8ce-acb3-446a-a40e-96c8189230d8.jpg?iopcmd=watermark&type=2&gravity=SouthEast&imageurl=aHR0cDovL3FpYW5oZS5jbi1nZC51ZmlsZW9zLmNvbS9pbWFnZXMvd2F0ZXJfaWNvbi5wbmc="] placeholderImage:nil];
	
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
