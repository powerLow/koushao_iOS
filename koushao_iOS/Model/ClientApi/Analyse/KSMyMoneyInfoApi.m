//
//  KSMyMoneyInfoApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/22.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyMoneyInfoApi.h"

@implementation KSMyMoneyInfoApi

- (NSString *)requestUrl {
    return @"/analyse/moneyinfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{};
    return [self getSource:params];
}

@end
