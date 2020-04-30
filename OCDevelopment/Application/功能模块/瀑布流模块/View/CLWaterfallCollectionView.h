//
//  CLWaterfallCollectionView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLCollectionView.h"
#import "CLWaterfallViewModel.h"
#import <CHTCollectionViewWaterfallLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLWaterfallCollectionView : CLCollectionView<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

/// ViewModel
@property (nonatomic, strong) CLWaterfallViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
