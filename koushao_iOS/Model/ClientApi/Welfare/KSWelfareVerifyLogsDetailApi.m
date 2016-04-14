//
//  KSWelfareVerifyLogsDetailApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareVerifyLogsDetailApi.h"
#import "KSActivity.h"

@interface KSWelfareVerifyLogsDetailApi()

@property (nonatomic,strong) NSNumber* wid;

@end

@implementation KSWelfareVerifyLogsDetailApi
- (instancetype)initWithWid:(NSNumber*)wid{
    self = [super init];
    if (self) {
        self.wid = wid;
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
                              @"id":_wid == nil ? @0 : _wid,
                              };
    return [self getSource:params];
}
@end
