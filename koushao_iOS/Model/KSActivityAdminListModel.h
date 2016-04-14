//
//  KSActivityAdminListModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "result": {
        "list": [
        {
            "username": "1@18679824092",
            "attr": {
                "signin": 0,
                "question": 0,
                "welfare": 0
            },
            "gender": 255,
            "isSubAccount": 1,
            "nickname": "1",
            "mobilePhone": "1@18679824092"
        },
                 ]
    },
    "error": {
        "errorno": 0,
        "msg": "success"
    }
}
*/
@interface KSActivityAccessModel : NSObject

@property (nonatomic,strong,readonly) NSNumber* signin;
@property (nonatomic,strong,readonly) NSNumber* question;
@property (nonatomic,strong,readonly) NSNumber* welfare;

@end

@interface KSActivityAdminItemModel : NSObject
@property (nonatomic,copy,readonly) NSString* username;
@property (nonatomic,strong,readonly) KSActivityAccessModel *attr;
@property (nonatomic,strong,readonly) NSNumber* gender;
@property (nonatomic,strong,readonly) NSNumber* isSubAccount;
@property (nonatomic,strong,readonly) NSString* nickname;
@property (nonatomic,copy,readonly) NSString* mobilePhone;

@end

@interface KSActivityAdminListModel : NSObject

@property (nonatomic,strong,readonly) NSArray* list;

@end
