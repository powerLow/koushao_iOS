//
//  KSQuestionPostApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSQuestionReplyPostApi.h"
#import "KSActivity.h"

@interface KSQuestionReplyPostApi()

@property (nonatomic,strong) NSNumber *qid;
@property (nonatomic,copy) NSString *answer;

@end

@implementation KSQuestionReplyPostApi

- (instancetype)initWithId:(NSNumber*)qid
                    answer:(NSString*)answer {
    self = [super init];
    if (self) {
        self.qid = qid;
        self.answer = [answer copy];
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/question/reply";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"id":_qid == nil ? @0 : _qid,
                              @"answer":_answer,
                              };
    return [self getSource:params];
}

@end
