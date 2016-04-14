//
//  KSSetUserNickname.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/1.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSetUserProfile.h"

@implementation KSSetUserProfile
{
    NSString *_nickname;
    NSInteger _gender;
}
- (NSString *)requestUrl {
    return @"/users/profile";
}
- (id)initWithNickname:(NSString *)nickname andGender:(NSInteger)gender {
    self = [super init];
    if (self) {
        _nickname = nickname;
        _gender=gender;
    }
    return self;
}

- (id)requestArgument {
    NSDictionary *params =  @{
                              @"name" : _nickname,
                              @"gender":@(_gender)
                              };
    return [self getSource:params];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

@end
