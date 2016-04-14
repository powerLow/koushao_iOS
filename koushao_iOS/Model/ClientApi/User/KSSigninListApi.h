//
//  KSSigninListApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"


typedef enum : NSUInteger {
    KSSigninListApiTypeNO,//未签到
    KSSigninListApiTypeYes,//已签到
} KSSigninListApiType;
@interface KSSigninListApi : KSBaseApiRequest

- (instancetype)initWithTid:(NSNumber*)tid
                        type:(KSSigninListApiType)type
                refresh_tyep:(KSRequestRefreshType)refresh_type
                       limit:(NSNumber *)limit;
@end
