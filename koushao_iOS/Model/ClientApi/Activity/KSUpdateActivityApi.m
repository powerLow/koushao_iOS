//
//  KSUpdateActivityApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/11.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSUpdateActivityApi.h"
#import "KSActivityCreatManager.h"

@implementation KSUpdateActivityApi
- (NSString *)requestUrl {
    return @"/activity";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPut;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    [self.params setObject:activityCreatManager.hashCode forKey:@"hash"];
    return [self getSource:self.params];
}

@end
