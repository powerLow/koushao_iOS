//
//  KSActivityAdminListModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityAdminListModel.h"

@implementation KSActivityAccessModel


@end

@implementation KSActivityAdminItemModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"attr":[KSActivityAccessModel class],
             };
}

@end

@implementation KSActivityAdminListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list":[KSActivityAdminItemModel class],
             };
}

@end
