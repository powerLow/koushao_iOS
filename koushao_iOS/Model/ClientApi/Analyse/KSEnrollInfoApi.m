//
//  KSEnrollInfoApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollInfoApi.h"
#import "KSActivity.h"

@implementation KSEnrollInfoApi
- (NSString *)requestUrl {
    return @"/analyse/enrollinfo";
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
