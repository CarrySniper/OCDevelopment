//
//  MainTableViewCell.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewCell : CLBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

NS_ASSUME_NONNULL_END
