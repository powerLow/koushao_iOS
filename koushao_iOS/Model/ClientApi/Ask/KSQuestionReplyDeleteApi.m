//
//  KSQuestionDeleteApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSQuestionReplyDeleteApi.h"
#import "KSActivity.h"

@interface KSQuestionReplyDeleteApi()

@property (nonatomic,strong) NSNumber *qid;
@property (nonatomic,assign) KSQuestionReplyDeleteApiType del_type;
@end

@implementation KSQuestionReplyDeleteApi

- (instancetype)initWithType:(KSQuestionReplyDeleteApiType)type Id:(NSNumber*)qid{
    self  = [super init];
    if (self) {
        self.qid = qid;
        self.del_type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/question/reply";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDelete;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"id":_qid == nil ? @0 : _qid,
                              @"del_type":@(_del_type),
                              };
    return [self getSource:params];
}

@end
