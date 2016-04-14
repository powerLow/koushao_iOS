//
//  KSStopActivityApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSStopActivityApi.h"
#import "KSActivity.h"

@implementation KSStopActivityApi

- (NSString *)requestUrl {
    return @"/activity/stop";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              };
    return [self getSource:params];
}

@end
