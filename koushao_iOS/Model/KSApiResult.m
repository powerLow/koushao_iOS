//
//  KSApiResult.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSApiResult.h"

@implementation KSApiResult

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"errorno" : @"error.errorno",
             @"msg" : @"error.msg",
             @"dict" : @"result",
             };
}
@end
