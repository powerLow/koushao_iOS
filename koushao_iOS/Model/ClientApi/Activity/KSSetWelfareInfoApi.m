//
//  KSSetWelfareInfoApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSetWelfareInfoApi.h"
#import "KSActivityCreatManager.h"
#import "WelfareItem.h"

@implementation KSSetWelfareInfoApi
- (NSString *)requestUrl {
    return @"/activity/welfare";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"hash": activityCreatManager.hashCode,
                                   @"category": @(activityCreatManager.welfare_Category),
                                   @"probability": @(activityCreatManager.welfare_Probability),
                                   @"welfare_description":activityCreatManager.welfare_description,
                                   @"welfare_items":[WelfareItem mj_keyValuesArrayWithObjectArray:activityCreatManager.welfare_items],
                                   @"welfare_name":@""
                                   }];
    return [self getSource:params];
}

@end
