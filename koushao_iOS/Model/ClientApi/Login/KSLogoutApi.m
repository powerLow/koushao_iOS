//
//  KSLogoutApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSLogoutApi.h"

@implementation KSLogoutApi{
    NSString *_mobile;
}

- (id)initWithMobilePhone:(NSString *)mobilePhone {
    self = [super init];
    if (self) {
        _mobile = mobilePhone;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/logout";
}

- (id)requestArgument {
    NSDictionary *params =  @{
                              @"mobilePhone" : _mobile,
                              };
    return [self getSource:params];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}
@end
