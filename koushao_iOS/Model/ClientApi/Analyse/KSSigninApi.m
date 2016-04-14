//
//  KSSigninApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSigninApi.h"
#import "KSActivity.h"


@interface KSSigninApi()

@property (nonatomic,copy) NSString* code;
@property (nonatomic,assign) KSSigninType type;

@end

@implementation KSSigninApi

- (instancetype)initWithSignType:(KSSigninType)type Code:(NSString*)code{
    self = [super init];
    if (self) {
        self.code = [code copy];
        self.type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/activity/signin";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"code":_code,
                              @"type":@(_type),
                              };
    return [self getSource:params];
}

@end
