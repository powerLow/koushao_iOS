//
//  KSLoginSmsApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSLoginSmsApi.h"


@implementation KSLoginSmsApi{
    NSString *_mobile;
    NSString *_smscode;
}


- (id)initWithMobile:(NSString *)mobile smscode:(NSString *)code {
    self = [super init];
    if (self) {
        _mobile = mobile;
        _smscode = code;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/login/sms";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{
             @"mobilePhone": _mobile,
             @"code": _smscode
             };
    return [self getSource:params];
}


- (NSString *)username {
    return [[[self responseJSONObject] objectForKey:@"username"] stringValue];
}
- (NSNumber *)errorno {
    NSDictionary *error = [[self responseJSONObject] objectForKey:@"error"];
    return [error objectForKey:@"errorno"];
}
- (NSString *)msg {
    NSDictionary *error = [[self responseJSONObject] objectForKey:@"error"];
    return [error objectForKey:@"msg"];
}
@end
