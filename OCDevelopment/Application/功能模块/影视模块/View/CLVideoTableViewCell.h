//
//  CLVideoTableViewCell.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLVideoTableViewCell : CLBaseTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *cover;
@property (nonatomic, weak) IBOutlet UILabel *title;

@end

NS_ASSUME_NONNULL_END
