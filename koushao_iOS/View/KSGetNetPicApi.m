//
//  KSGetNetPicApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSGetNetPicApi.h"

@implementation KSGetNetPicApi
- (NSString *)requestUrl {
    return @"/picture";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{@"type" :@(self.type)};
    return [self getSource:params];
}
@end
