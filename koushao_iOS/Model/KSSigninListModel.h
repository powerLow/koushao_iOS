//
//  KSSigninListModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 {
 "result": {
 "list": [
 {
 "mobilePhone": "13216708954",
 "signin_time": 1446877550,
 "signin_type": 1,
 "ticket_id": "KS8881446695778905",
 "nickname": "三等座",
 "signin_admin": "18679824092",
 "ticket_name": "三等座"
 },
 {
 "mobilePhone": "13216708954",
 "signin_time": 1446884603,
 "signin_type": 1,
 "ticket_id": "KS2591446695778117",
 "nickname": "二等座",
 "signin_admin": "18679824092",
 "ticket_name": "二等座"
 },
 {
 "mobilePhone": "13216708954",
 "signin_time": 1446959250,
 "signin_type": 0,
 "ticket_id": "KS3661446695778570",
 "nickname": "一等座",
 "signin_admin": "18679824092",
 "ticket_name": "一等座"
 }
 ],
 "signup_count": 3,
 "signin_count": 3
 },
 "error": {
 "errorno": 0,
 "msg": "success"
 }
 }
 */
@interface KSSigninListItemModel : NSObject

@property (nonatomic,copy,readonly) NSString *mobilePhone;
@property (nonatomic,strong,readonly) NSNumber *signup_time;
@property (nonatomic,strong,readonly) NSNumber *signin_time;
@property (nonatomic,strong,readonly) NSNumber *signin_type;
@property (nonatomic,copy,readonly) NSString *ticket_id;
@property (nonatomic,copy,readonly) NSString *nickname;
@property (nonatomic,copy,readonly) NSString *signin_admin;
@property (nonatomic,copy,readonly) NSString *ticket_name;
@property (nonatomic,strong,readonly) NSNumber* tid;

@end
@interface KSSigninListModel : NSObject

@property (nonatomic,strong,readonly) NSNumber *signup_count;
@property (nonatomic,strong,readonly) NSNumber *signin_count;
@property (nonatomic,strong,readonly) NSArray *list;
@end
