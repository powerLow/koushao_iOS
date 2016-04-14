//
//  KSGetImageUploadTokenApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSGetImageUploadTokenApi.h"

@implementation KSGetImageUploadTokenApi
- (NSString *)requestUrl {
    return @"/upload/gettoken";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{};
    return [self getSource:params];
}
@end
