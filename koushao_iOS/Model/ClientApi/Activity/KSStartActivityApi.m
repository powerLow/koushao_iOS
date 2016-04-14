//
//  KSStartActivityApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSStartActivityApi.h"
#import "KSActivityCreatManager.h"

@implementation KSStartActivityApi
- (NSString *)requestUrl {
    return @"/activity/start";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary: @{ @"hash": activityCreatManager.hashCode}];
    return [self getSource:params];
}
@end
