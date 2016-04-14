//
//  KSVisitsInfoApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSVisitsInfoApi.h"
#import "KSActivity.h"
@implementation KSVisitsInfoApi

- (NSString *)requestUrl {
    return @"/analyse/visitsinfo";
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
