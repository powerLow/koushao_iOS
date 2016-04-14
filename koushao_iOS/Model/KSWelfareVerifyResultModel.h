//
//  KSWelfareVerifyResultModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/11.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KSWelfareVerifyResultModel : NSObject
/*
{
    "result": {
        "admin": "18679824092",
        "welfare_item_title": "暴力熊11",
        "avatar": "https://dn-koushao.qbox.me/avatar/16.png",
        "welfare_title": "一等奖",
        "time": 1448867731,
        "mobile": "132****8954",
        "type": 1,
        "nickname": "132****8954",
        "activity_tilte": "周末有福利"
    },
    "error": {
        "errorno": 331,
                "msg": "验证码已经被使用"
    }
}
 */
@property (nonatomic, assign, readwrite, getter=isSuccess) BOOL success;
@property (nonatomic, strong, readonly) NSNumber *time;
@property (nonatomic, strong, readonly) NSNumber *type;
@property (nonatomic, copy, readonly) NSString *admin;
@property (nonatomic, copy, readonly) NSString *welfare_item_title;
@property (nonatomic, copy, readonly) NSString *avatar;
@property (nonatomic, copy, readonly) NSString *welfare_title;
@property (nonatomic, copy, readonly) NSString *mobile;
@property (nonatomic, copy, readonly) NSString *activity_tilte;
@property (nonatomic, copy, readonly) NSString *nickname;
@end
