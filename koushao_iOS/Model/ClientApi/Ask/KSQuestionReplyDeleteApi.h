//
//  KSQuestionDeleteApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

typedef enum : NSUInteger {
    KSQuestionReplyDeleteApiTypeReply,      //删除回复
    KSQuestionReplyDeleteApiTypeQuestion,   //删除问题
} KSQuestionReplyDeleteApiType;

@interface KSQuestionReplyDeleteApi : KSBaseApiRequest

- (instancetype)initWithType:(KSQuestionReplyDeleteApiType)type Id:(NSNumber*)qid;

@end
