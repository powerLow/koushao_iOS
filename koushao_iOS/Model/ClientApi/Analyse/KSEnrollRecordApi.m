//
//  KSEnrollRecordApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordApi.h"
#import "KSActivity.h"

@interface KSEnrollRecordApi()

@property (nonatomic,strong,readwrite) NSNumber* tid;
@property (nonatomic,strong,readwrite) NSNumber* limit;
@property (nonatomic,strong,readwrite) NSNumber* type;
@end

@implementation KSEnrollRecordApi

-(instancetype)initWithTid:(NSNumber*)tid
              refresh_type:(KSRequestRefreshType)type
                     limit:(NSNumber*)limit{
    self = [super init];
    if (self) {
        self.tid = tid;
        self.limit = limit;
        self.type = @(type);
    }
    return self;
    
}
- (NSString *)requestUrl {
    return @"/analyse/enrollrecord";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"limit":_limit,
                              @"refresh_type":_type,
                              @"tid":_tid == nil ? @0 : _tid,
                              };
    return [self getSource:params];
}

@end
