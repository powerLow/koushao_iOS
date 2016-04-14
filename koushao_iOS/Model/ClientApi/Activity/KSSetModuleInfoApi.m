//
//  KSSetModuleInfoApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/20.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSetModuleInfoApi.h"
#import "KSActivityCreatManager.h"

@implementation KSSetModuleInfoApi
- (NSString *)requestUrl {
    return @"/activity/module";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"hash": activityCreatManager.hashCode,
                                   @"signin": @(activityCreatManager.enlist_isOpen),
                                   @"question": @(activityCreatManager.consult_isOpen),
                                   @"welfare": @(activityCreatManager.welfare_isOpen),
                                   }];
    return [self getSource:params];
}

@end
