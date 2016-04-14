//
//  KSLoginSubAccount.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSLoginSubAccount.h"

@implementation KSLoginSubAccount
{
    NSString *_username;
    NSString *_password;
}



-(id)initWithUserName:(NSString *)userName password:(NSString *)password
{
    self = [super init];
    if (self) {
        _username = userName;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{
                              @"mobilePhone": _username,
                              @"password": _password
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
