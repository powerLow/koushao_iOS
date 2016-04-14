//
//  KSSubaccountGetApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSubaccountGetApi.h"
#import "KSActivity.h"

@implementation KSSubaccountGetApi

- (NSString *)requestUrl {
    return @"/users/subaccount";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              };
    return [self getSource:params];
}
@end
