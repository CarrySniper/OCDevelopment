//
//  CLMainTableView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLTableView.h"
#import "CLMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLMainTableView : CLTableView<UITableViewDataSource>

/// ViewModel
@property (strong, nonatomic) CLMainViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
