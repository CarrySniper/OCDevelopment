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
@property (nonatomic, weak) IBOutlet UIButton *btn;
@property (nonatomic, weak) IBOutlet UILabel *lab;

@property (nonatomic, weak) IBOutlet UIImageView *icon;

@end

NS_ASSUME_NONNULL_END
