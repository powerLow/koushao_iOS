//
//  KSAwardDetailModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "result": {
        "delivery_info": {
            "phone": "13211111112",
            "post": "4h7kj",
            "name": "hjw",
            "address": "4h7kj"
        },
        "welfare_name": "暴力熊11",
        "receiver": "13141271541"
    },
    "error": {
        "errorno": 0,
        "msg": "success"
    }
}*/
@interface KSDeliveryInfo : NSObject

@property (nonatomic,copy,readonly) NSString* phone;
@property (nonatomic,copy,readonly) NSString* post;
@property (nonatomic,copy,readonly) NSString* name;
@property (nonatomic,copy,readonly) NSString* address;

@property (nonatomic,copy,readonly) NSString* nu;
@property (nonatomic,copy,readonly) NSString* company;
@end

@interface KSAwardDetailModel : NSObject

@property (nonatomic,strong,readonly) KSDeliveryInfo* delivery_info;
@property (nonatomic,copy,readonly) NSString* welfare_name;
@property (nonatomic,copy,readonly) NSString* receiver;
@property (nonatomic,strong,readonly) NSNumber* time;
@property (nonatomic,copy,readonly) NSString* admin;


@end
