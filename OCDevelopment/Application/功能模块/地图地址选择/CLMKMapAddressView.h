//
//  CLMKMapAddressView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/9/25.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPopupView.h"
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLMKMapAddressView : CLPopupView

+ (void)showViewWithCompletionHandler:(void(^)(NSString *address))completionHandler;

@end

@interface CLAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
