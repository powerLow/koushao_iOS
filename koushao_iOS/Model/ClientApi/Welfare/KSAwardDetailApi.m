//
//  KSAwardDetailApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSAwardDetailApi.h"
#import "KSActivity.h"

@interface KSAwardDetailApi()

@property (nonatomic,strong) NSNumber *wid;

@end

@implementation KSAwardDetailApi

- (instancetype)initWithWid:(NSNumber*)wid{
    self = [super init];
    if (self) {
        self.wid = wid;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/activity/welfare/award/detail";
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
