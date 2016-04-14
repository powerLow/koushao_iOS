//
//  KSBaseApiRequest.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "YTKRequest.h"

typedef enum : NSUInteger {
    KSRequestRefreshTypePullUp, // 上拉 == 0
    KSRequestRefreshTypePullDown, //下拉 == 1
} KSRequestRefreshType;

@interface KSBaseApiRequest : YTKRequest

-(NSDictionary*)getSource:(NSDictionary*)args;
- (NSString *)getMd5_32Bit_String:(NSString *)srcString;
@end
