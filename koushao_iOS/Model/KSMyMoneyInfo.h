//
//  KSMyMonelInfo.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/22.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_ID_KSMYMONEYINFO @"db_mymoneyinfo"

@interface KSMyMoneyInfo : NSObject <KSPersistenceProtocol>

//金额统计
@property (nonatomic, strong, readonly) NSNumber *obtain;       //累计获得金额
@property (nonatomic, strong, readonly) NSNumber *cash;         //累计充值金额
@property (nonatomic, strong, readonly) NSNumber *recharge;     //累计充值金额(暂时没有)
@property (nonatomic, strong, readonly) NSNumber *applicant;    //当前可提现余额


@end
