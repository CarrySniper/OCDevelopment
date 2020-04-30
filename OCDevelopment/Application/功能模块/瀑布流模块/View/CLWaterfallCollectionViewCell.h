//
//  CLWaterfallCollectionViewCell.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLWaterfallCollectionViewCell : CLBaseCollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *cover;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
