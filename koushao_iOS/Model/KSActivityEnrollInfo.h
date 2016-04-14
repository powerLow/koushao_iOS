//
//  KSActivityEnrollInfo.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_ID_ENROLLINFO @"db_enrollInfo"

@interface KSActivityTickets : NSObject

@property (nonatomic, strong, readonly) NSNumber *count;            //售出数量
@property (nonatomic, strong, readonly) NSNumber *price;            //出售价格
@property (nonatomic, copy, readonly) NSString *name;               //票名

@end


@interface KSActivityEnrollInfo : NSObject <KSPersistenceProtocol>
///{u'result': {u'tickets': [], u'money': 0, u'enroll': 3, u'gender': {u'male': 1, u'female': 2}}, u'error': {u'msg': u'success', u'errorno': 0}}

@property (nonatomic, strong, readonly) NSNumber *money;            //收款金额
@property (nonatomic, strong, readonly) NSNumber *enroll;           //报名人数
@property (nonatomic, strong, readonly) NSArray *tickets;              //票
@property (nonatomic, strong, readonly) NSDictionary *gender;          //男女分布

- (BOOL)isEnroll;

@end
