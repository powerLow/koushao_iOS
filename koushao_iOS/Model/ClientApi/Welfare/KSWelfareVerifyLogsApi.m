//
//  KSWelfareVerifyLogsApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareVerifyLogsApi.h"
#import "KSActivity.h"


@interface KSWelfareVerifyLogsApi()

@property (nonatomic,assign) KSRequestRefreshType refresh_type;
@property (nonatomic,strong) NSNumber* _id;
@property (nonatomic,strong) NSNumber* limit;
@property (nonatomic,strong) NSNumber* record_type;
@end

@implementation KSWelfareVerifyLogsApi

- (instancetype)initWithWid:(NSNumber*)wid
               refresh_type:(KSRequestRefreshType)type
                record_type:(KSWelfareVerifyLogsRecordType)record_type
                      limit:(NSNumber*)limit{
    self = [super init];
    if (self) {
        self._id = wid;
        self.refresh_type = type;
        self.limit = limit;
        self.record_type = @(record_type);
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/activity/welfare/verifylogs";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"limit":_limit,
                              @"id":__id == nil ? @0 : __id,
                              @"record_type":_record_type,
                              @"refresh_type":@(_refresh_type),
                              };
    return [self getSource:params];
}

@end
