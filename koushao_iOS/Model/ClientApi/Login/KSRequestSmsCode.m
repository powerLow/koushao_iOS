//
//  KSRequestSmsCode.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSRequestSmsCode.h"

@implementation KSRequestSmsCode{
    NSString *_mobile;
    NSInteger requestType;
}


- (id)initWithMobile:(NSString *)mobile withType:(NSInteger)type{
    self = [super init];
    if (self) {
        _mobile = mobile;
        requestType=type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/requestSmsCode";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{
                              @"mobilePhoneNumber": _mobile,
                              @"type":@(requestType)
                              };
    return [self getSource:params];
}
@end
