//
//  KSWelfareVerifyLogsResultModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareVerifyLogsResultModel.h"
@implementation KSWelfareVerifyLogsItemModel
@end

@implementation KSWelfareVerifyLogsResultModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list":[KSWelfareVerifyLogsItemModel class],
             };
}
@end
@implementation KSWelfareVerifyLogsDetailModel
@end
