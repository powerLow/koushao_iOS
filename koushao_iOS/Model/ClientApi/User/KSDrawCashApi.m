//
//  KSDrawCashApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSDrawCashApi.h"


@implementation KSDrawCashApi
- (NSString *)requestUrl {
    return @"/money/drawcash";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"account":_account,
                                   @"name":_name,
                                   @"money":@(_money),
                                   @"code":_code,
                                   @"pic_1":_pic_1
                                   }];
    return [self getSource:params];
}
@end
