//
//  CLBaseViewModel.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CLModelHandler)(BOOL succeeded, CLBaseModel *_Nullable model);

@interface CLBaseViewModel : NSObject

@end

NS_ASSUME_NONNULL_END
