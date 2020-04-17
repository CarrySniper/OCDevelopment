//
//  CLDefine.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#ifndef CLDefine_h
#define CLDefine_h

#import "CLDefineName.h"
#import "CLDefineTypedef.h"
#import "CLDefineUrl.h"

/*假如宏定义比较多,建议用FOUNDATION_EXPORT。
.h 文件中 -------------
typedef NSString *KLTypeStr NS_STRING_ENUM;
 
FOUNDATION_EXPORT KLTypeStr const KLTypeStringRed;
FOUNDATION_EXPORT KLTypeStr const KLTypeStringGreen;
FOUNDATION_EXPORT KLTypeStr const KLTypeStringOrange;
 
.m 文件中 --------------
NSString * const KLTypeStringRed = @"红色";
NSString * const KLTypeStringGreen = @"绿色";
*/


#endif /* CLDefine_h */
