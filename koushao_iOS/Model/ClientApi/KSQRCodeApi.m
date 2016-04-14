//
//  KSQRCodeApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSQRCodeApi.h"
#import "KSActivity.h"
@implementation KSQRCodeApi


- (NSString *)requestUrl {
    return @"/activity/qrcode";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              };
    return [self getSource:params];
}

@end
