//
//  KSQuestionPostApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSQuestionReplyPostApi : KSBaseApiRequest


- (instancetype)initWithId:(NSNumber*)qid
                    answer:(NSString*)answer;

@end
