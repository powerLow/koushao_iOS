//
//  KSWelfareStatusApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/28.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareStatusApi.h"
#import "KSActivity.h"
@implementation KSWelfareStatusApi
- (NSString *)requestUrl {
    return @"/activity/welfare/status";
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
