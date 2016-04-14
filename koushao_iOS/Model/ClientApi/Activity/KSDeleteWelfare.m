//
//  KSDeleteWelfare.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSDeleteWelfare.h"
#import "KSActivityCreatManager.h"

@implementation KSDeleteWelfare
- (NSString *)requestUrl {
    return @"/activity/welfare";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDelete;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"hash": activityCreatManager.hashCode,

                                   }];
    return [self getSource:params];
}


@end
