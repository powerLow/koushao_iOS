//
//  KSSigninListModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSigninListModel.h"
@implementation KSSigninListItemModel

@end
@implementation KSSigninListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list":[KSSigninListItemModel class],
             };
}

@end
