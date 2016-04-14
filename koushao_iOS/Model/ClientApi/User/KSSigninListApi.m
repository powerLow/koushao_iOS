//
//  KSSigninListApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSigninListApi.h"
#import "KSActivity.h"

@interface KSSigninListApi()

@property (nonatomic, strong) NSNumber* tid;
@property (nonatomic, assign) KSSigninListApiType type;
@property (nonatomic, assign) KSRequestRefreshType refresh_type;
@property (nonatomic, strong) NSNumber *limit;

@end

@implementation KSSigninListApi

- (instancetype)initWithTid:(NSNumber*)tid
                        type:(KSSigninListApiType)type
                refresh_tyep:(KSRequestRefreshType)refresh_type
                       limit:(NSNumber *)limit{
    self = [super init];
    if (self) {
        self.tid = tid;
        self.type = type;
        self.refresh_type = refresh_type;
        self.limit = limit;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/activity/signin/list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"type":@(_type),
                              @"refresh_type":@(_refresh_type),
                              @"limit":_limit,
                              @"tid":_tid == nil ? @0 : _tid,
                              };
    return [self getSource:params];
}

@end
