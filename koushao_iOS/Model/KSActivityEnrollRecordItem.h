//
//  KSActivityEnrollRecordItem.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSActivityEnrollRecordItem : NSObject

/*
 {
 "result": {
 "tickets": [
 {
 "count": 1,
 "price": 0,
 "name": "免费"
 },
 {
 "count": 1,
 "price": 0,
 "name": "免费2"
 },
 {
 "count": 1,
 "price": 0,
 "name": "免费3"
 }
 ],
 "money": 0,
 "enroll": 3,
 "gender": {
 "male": 1,
 "female": 2
 }
 },
 "error": {
 "errorno": 0,
 "msg": "success"
 }
 }*/

@property (nonatomic, strong, readonly) NSNumber *signin;          //是否签到
@property (nonatomic, strong, readonly) NSNumber *time;            //报名时间
@property (nonatomic, copy, readonly) NSString *nickname;          //购票人名字
@property (nonatomic, copy, readonly) NSString *ticket_id;         //票务id
@property (nonatomic, strong, readonly) NSNumber *ticket_money;    //票务金额
@property (nonatomic, strong, readonly) NSNumber *tid;
@end
