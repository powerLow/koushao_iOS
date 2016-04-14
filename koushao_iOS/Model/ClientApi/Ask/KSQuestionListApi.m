//
//  KSQuestionListApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSQuestionListApi.h"
#import "KSActivity.h"



@interface KSQuestionListApi()

@property (nonatomic,strong) NSNumber *qid;
@property (nonatomic,assign) KSRequestRefreshType type;            //0是下拉，找比此id更小的数据
@property (nonatomic,assign) KSQuestionListApiReplyType reply_type; //0是未回复 1是已经回复
@property (nonatomic,strong) NSNumber *limit;                       //limit限制

@end

@implementation KSQuestionListApi


- (instancetype)initWithId:(NSNumber*)qid
                      type:(KSRequestRefreshType)type
                 replytype:(KSQuestionListApiReplyType)replytype
                     limit:(NSNumber*)limit{
    self = [super init];
    if (self) {
        self.qid = qid;
        self.type = type;
        self.reply_type = replytype;
        self.limit = limit;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/question/list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}
//ask_args.add_argument('id', type=int, default=0)
//ask_args.add_argument('type', type=int, default=0)
//ask_args.add_argument('reply_type', type=int, default=0)
//ask_args.add_argument('limit', type=int, default=10)
//ask_args.add_argument('hash', type=str, required=True, default="")
- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"id":_qid == nil ? @0 : _qid,
                              @"type":@(_type),
                              @"reply_type":@(_reply_type),
                              @"limit":_limit,
                              };
    return [self getSource:params];
}
@end
