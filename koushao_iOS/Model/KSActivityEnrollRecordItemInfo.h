//
//  KSActivityEnrollRecordItemInfo.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSActivityEnrollRecordItemInfo : NSObject

@property (nonatomic, copy, readonly) NSString *nickname;         //昵称
@property (nonatomic, copy, readonly) NSString *gender;           //性别
@property (nonatomic, copy, readonly) NSString *mobilePhone;        //手机
@property (nonatomic, strong, readonly) NSArray *custom_info;       //自定义信息

@property (nonatomic, strong, readonly) NSNumber *bsign;            //是否签到
@property (nonatomic, strong, readonly) NSNumber *signup_time;      //报名时间
@property (nonatomic, copy, readonly) NSString *fee_name;           //费用名称
@property (nonatomic, strong, readonly) NSNumber *fee_price;        //票价格

@end
