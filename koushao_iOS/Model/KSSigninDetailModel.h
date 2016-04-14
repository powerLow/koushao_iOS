//
//  KSSigninDetailModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "result": {
 "ticket_id": "KS3661446695778570",
 "signin_time": 1446959250,
 "signin_type": 0,
 "pay_channel": 1,
 "ticket_price": 0.01,
 "signup_name": null,
 "signup_user": "13216708954",
 "signup_time": 1446695778,
 "avatar": "https://dn-koushao.qbox.me/avatar/16.png",
 "activity_name": "周末观影",
 "signup_mobile": null,
 "signin_admin": "18679824092",
 "ticket_name": "一等座"
 },
 "error": {
 "errorno": 0,
 "msg": "success"
 }
 }
 */
/*
{
    "result": {
        "signin_time": 1448872050,
        "signin_type": 0,
        "pay_channel": 2,
        "signup_name": "lalala",
        "gender": 1,
        "custom_info": [
        {
            "三围": "13216708954"
        }
                        ],
        "signup_user": "18679824092",
        "signup_time": 1448872001,
        "avatar": "http://image.koushaoapp.com/FlRk4Y5dZLk74ABjmZmQ3hDZmmGp",
        "activity_name": "周末有福利",
        "signup_mobile": "13216708954",
        "signin_admin": "18679824092",
        "ticket_id": "KS1261448872001104"
    },
    "error": {
        "errorno": 0,
        "msg": "成功"
    }
}*/
@interface KSSigninDetailModel : NSObject


@property (nonatomic,copy,readonly) NSString *ticket_id;//票的id
@property (nonatomic,copy,readonly) NSString *ticket_name;//票的名字
@property (nonatomic,strong,readonly) NSNumber *signin_time;//签到时间
@property (nonatomic,strong,readonly) NSNumber *signin_type;//签到类型
@property (nonatomic,strong,readonly) NSNumber *pay_channel;//支付的方式
@property (nonatomic,strong,readonly) NSNumber *ticket_price;//票的价格

@property (nonatomic,copy,readonly) NSString *signup_user;//报名人的购买账号

@property (nonatomic,copy,readonly) NSString *signup_name;//报名人填写的名字
@property (nonatomic,strong,readonly) NSNumber *gender;//报名人填写的性别
@property (nonatomic,copy,readonly) NSString *signup_mobile;//报名人填写的手机号
@property (nonatomic,strong,readwrite) NSArray *custom_info;//报名填写的自定义信息
@property (nonatomic,strong,readonly) NSNumber *signup_time;//报名的时间

@property (nonatomic,copy,readwrite) NSString *avatar;
@property (nonatomic,copy,readonly) NSString *activity_name;

@property (nonatomic,copy,readonly) NSString *signin_admin;

@end
