//
//  KSWelfareVerifyLogsResultModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "result": {
        "draw_count": 3,
        "list": [
        {
            "welfare_item_title": "三等奖",
            "welfare_title": "暴力熊33",
            "admin": "18679824092",
            "time": 1447322318,
            "receiver": "13014874534",
            "welfare_type": 1,
            "id": 138
        }
                 ],
        "verified_count": 1
    },
    "error": {
        "errorno": 0,
        "msg": "success"
    }
}
 */

typedef enum : NSUInteger {
    KSWelfareTypeQuan,
    KSWelfareTypeWuPin = 2,
} KSWelfareType;

@interface KSWelfareVerifyLogsItemModel : NSObject

@property (nonatomic,copy,readonly) NSString *welfare_item_title;
@property (nonatomic,copy,readonly) NSString *welfare_title;
@property (nonatomic,copy,readonly) NSString *admin;
@property (nonatomic,copy,readonly) NSString *receiver;

@property (nonatomic,strong,readonly) NSNumber *time;
@property (nonatomic,assign,readonly) KSWelfareType welfare_type;
@property (nonatomic,strong,readonly) NSNumber *id;

@end

@interface KSWelfareVerifyLogsResultModel : NSObject

@property (nonatomic,strong,readonly) NSNumber *draw_count;
@property (nonatomic,strong,readonly) NSNumber *verified_count;

@property (nonatomic,strong,readonly) NSArray *list;
@end

@interface KSWelfareVerifyLogsDetailModel : NSObject

@property (nonatomic,strong,readonly) NSNumber *get_time;
@property (nonatomic,strong,readonly) NSNumber *verify_time;
@property (nonatomic,copy,readonly) NSString *avatar;
@property (nonatomic,copy,readonly) NSString *activity_title;
@property (nonatomic,copy,readonly) NSString *welfare_title;
@property (nonatomic,copy,readonly) NSString *welfare_item_title;
@property (nonatomic,copy,readonly) NSString *welfare_item;
@property (nonatomic,copy,readonly) NSString *receiver;
@property (nonatomic,copy,readonly) NSString *id;
@end
