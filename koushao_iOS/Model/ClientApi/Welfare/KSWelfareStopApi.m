//
//  KSWelfareStopApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/28.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareStopApi.h"
#import "KSActivity.h"
@implementation KSWelfareStopApi
- (NSString *)requestUrl {
    return @"/activity/welfare/stop";
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
