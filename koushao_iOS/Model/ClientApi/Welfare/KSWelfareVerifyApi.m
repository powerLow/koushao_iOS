//
//  KSWelfareVerifyApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/11.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareVerifyApi.h"
#import "KSActivity.h"
@interface KSWelfareVerifyApi()

@property (nonatomic,copy) NSString* code;
@property (nonatomic,assign) KSWelfareVerifyType type;

@end

@implementation KSWelfareVerifyApi

- (instancetype)initWithType:(KSWelfareVerifyType)type Code:(NSString*)code{
    self = [super init];
    if (self) {
        self.code = [code copy];
        self.type = type;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/activity/welfare/verify";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"code":_code,
                              @"verify_type":@(_type),
                              };
    return [self getSource:params];
}

@end
