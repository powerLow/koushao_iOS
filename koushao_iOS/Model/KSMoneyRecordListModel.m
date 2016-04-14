//
//  KSMoneyRecordListModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMoneyRecordListModel.h"

@implementation KSMoneyRecordItemModel


@end

@implementation KSMoneyRecordListModel

+(NSDictionary*)mj_objectClassInArray{
    return @{
             @"list":[KSMoneyRecordItemModel class],
             };
}

@end
