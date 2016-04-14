//
//  KSQuestionListModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSQuestionListModel.h"


@implementation KSQuestionListItemModel

- (NSString *)description{
    return  [NSString stringWithFormat:@"id:%@,question:%@",_id,_question];
}

@end


@implementation KSQuestionListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list":[KSQuestionListItemModel class],
             };
}

@end
