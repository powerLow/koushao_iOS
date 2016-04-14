//
//  RegisterDeviceApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "RegisterDeviceApi.h"

@implementation RegisterDeviceApi
{
    NSString* _username;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)initWithUsername:(NSString *)username
{
    self = [super init];
    if (self) {
        _username = username;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/registerdevice";
}



- (id)requestArgument {
    NSDictionary *params =  @{
                              @"regid": _username,
                              @"os":@"ios"
                              };
    return [self getSource:params];
}


@end
