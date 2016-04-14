//
//  KSSignResultModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KSSignUserInfo : NSObject

@property (nonatomic,copy,readonly) NSString *name;
@property (nonatomic,copy,readonly) NSString *phone;

@end

@interface KSSignResultModel : NSObject

/*
 {
 "result": {
 "ticket_info": {
 "phone": "13216708954",
 "ticket_title": "三等座",
 "ticket_id": "KS8881446695778905",
 "ticket_price": 0.01
 },
 "signinAdmin": "18679824092",
 "signinTime": 1446877550,
 "type": 1,
 "userinfo": {}
 },
 "error": {
 "errorno": 323,
 "msg": "ticket has been use"
 }
 }
 */
@property (nonatomic,assign,readwrite,getter=isSuccess) BOOL success;

@property (nonatomic,strong,readonly) NSDictionary *ticket_info;
@property (nonatomic,strong,readonly) KSSignUserInfo *userinfo;
@property (nonatomic,copy,readonly) NSString *mobilePhone;
@property (nonatomic,copy,readonly) NSString *signinAdmin;
@property (nonatomic,strong,readonly) NSNumber *signinTime;
@property (nonatomic,strong,readonly) NSNumber *type;

//ticket_info
@property (nonatomic,copy,readonly) NSString *phone;
@property (nonatomic,copy,readonly) NSString *ticket_title;
@property (nonatomic,copy,readonly) NSString *ticket_id;
@property (nonatomic,strong,readonly) NSNumber *ticket_price;

//userinfo
@end
