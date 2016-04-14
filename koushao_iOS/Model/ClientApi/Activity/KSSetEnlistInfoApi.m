//
//  KSSetEnlistInfoApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/20.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSetEnlistInfoApi.h"
#import "KSActivityCreatManager.h"
#import "EnlistFeeItem.h"

@implementation KSSetEnlistInfoApi
- (NSString *)requestUrl {
    return @"/activity/ticket";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    if(activityCreatManager.enlist_type==0)
    {
        if(activityCreatManager.enlist_limit==0)
            activityCreatManager.enlist_limit=1;
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"hash": activityCreatManager.hashCode,
                                   @"type": @(activityCreatManager.enlist_type),
                                   @"limit": @(activityCreatManager.enlist_limit),
                                   @"verify":@(activityCreatManager.enlist_generate_enlist_certificate),
                                   @"form":[NSString mj_keyValuesArrayWithObjectArray:activityCreatManager.enlist_form_info_array],
                                   @"items":[EnlistFeeItem mj_keyValuesArrayWithObjectArray:activityCreatManager.enlist_fee_item_array]
                                   }];
    return [self getSource:params];
}
@end
