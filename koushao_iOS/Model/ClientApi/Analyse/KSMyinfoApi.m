//
//  KSMyinfoApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/21.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyinfoApi.h"

@implementation KSMyinfoApi

- (NSString *)requestUrl {
    return @"/analyse/info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{};
    return [self getSource:params];
}

@end
