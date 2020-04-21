//
//  CLVideoModel.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLVideoModel : CLBaseModel

/// <#Description#>
@property (copy, nonatomic) NSString *title;
/// <#Description#>
@property (copy, nonatomic) NSString *cover;
/// <#Description#>
@property (copy, nonatomic) NSString *publishTime;

@end

NS_ASSUME_NONNULL_END
