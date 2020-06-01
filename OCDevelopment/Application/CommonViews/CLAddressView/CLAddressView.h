//
//  CLAddressView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/1.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLAddressView : CLPopupView
+ (instancetype)showViewWithCurrentModel:(NSString *)currentModel
					   completionHandler:(void(^)(NSString *currentModel))completionHandler;
@end

NS_ASSUME_NONNULL_END
