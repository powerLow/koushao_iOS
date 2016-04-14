//
//  KSQuestionListApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

typedef enum : NSUInteger {
    KSQuestionListApiReplyTypeNo,//未回复
    KSQuestionListApiReplyTypeYes,//已回复
} KSQuestionListApiReplyType;

@interface KSQuestionListApi : KSBaseApiRequest

- (instancetype)initWithId:(NSNumber*)qid
                      type:(KSRequestRefreshType)type
                 replytype:(KSQuestionListApiReplyType)replytype
                     limit:(NSNumber*)limit;

@end
