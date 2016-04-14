//
//  KSActivityBaseApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/19.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityBaseApi.h"
#import "KSActivity.h"

@implementation KSActivityBaseApi

- (NSString *)requestUrl {
    return @"/analyse/baseinfo";
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
