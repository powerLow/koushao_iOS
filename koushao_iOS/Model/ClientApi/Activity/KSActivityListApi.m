//
//  KSActivityListApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityListApi.h"

@implementation KSActivityListApi{
    NSNumber *_limit;
    NSNumber *_createTime;
    NSNumber *_type; //0取小于create，1取大于create_time
}

- (id)initWithLimit:(NSNumber*)limit createtime:(NSNumber*)createtime type:(KSRequestRefreshType)type {
    self = [super init];
    if (self) {
        _limit = limit;
        _createTime = createtime;
        _type = @(type);
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/activity/list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{
                              @"limit": _limit,
                              @"create_time": _createTime == nil? @0 : _createTime,
                              @"type" : _type,
                              };
    return [self getSource:params];
}

@end
