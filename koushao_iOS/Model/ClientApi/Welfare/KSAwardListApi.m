//
//  KSAwardListApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSAwardListApi.h"
#import "KSActivity.h"

@interface KSAwardListApi()

@property (nonatomic,assign) KSAwardListApiType type;
@property (nonatomic,strong) NSNumber *wid;
@property (nonatomic,assign) KSRequestRefreshType refresh_type;
@property (nonatomic,strong) NSNumber *limit;

@end

@implementation KSAwardListApi

- (instancetype)initWithWid:(NSNumber*)wid
               refresh_type:(KSRequestRefreshType)refresh_type
                      limit:(NSNumber*)limit
                       type:(KSAwardListApiType)type{
    self = [super init];
    if (self) {
        self.type = type;
        self.limit = limit;
        self.wid = wid;
        self.refresh_type = refresh_type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/activity/welfare/award/list";
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
                              @"wid":_wid == nil ? @0 : _wid,
                              };
    return [self getSource:params];
}

@end
