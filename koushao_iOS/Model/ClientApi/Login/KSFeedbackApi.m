//
//  KSFeedbackApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSFeedbackApi.h"

@implementation KSFeedbackApi
- (NSString *)requestUrl {
    return @"/feedback";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"content":_content,
                                   @"contact":_contact,
                                   }];
    return [self getSource:params];
}
@end
