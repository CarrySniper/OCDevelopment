//
//  WaterfallCell.m
//  CKWaterFlow
//
//  Created by azxy on 15/8/24.
//  Copyright (c) 2015年 azxy. All rights reserved.
//

#import "WaterfallCell.h"

@implementation WaterfallCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Scale the imageview to fit inside the contentView with the image centered:
        CGRect imageViewFrame = CGRectMake(0.f, 0.f,
                                           CGRectGetMaxX(self.contentView.bounds),
                                           CGRectGetMaxY(self.contentView.bounds));
        _showImageView                  = [UIImageView new];
        _showImageView.contentMode      = UIViewContentModeScaleAspectFill;
        _showImageView.frame            = imageViewFrame;
        _showImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_showImageView.backgroundColor = UIColor.redColor;
        [self addSubview:_showImageView];
    }
    return self;
}

@end
