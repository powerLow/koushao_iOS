//
//  KSWelfareAnalyseApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareAnalyseApi.h"
#import "KSActivity.h"
@implementation KSWelfareAnalyseApi

- (NSString *)requestUrl {
    return @"/activity/welfare/analyse";
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
