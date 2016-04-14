//
//  KSMoneyRecordApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

typedef enum : NSUInteger {
    KSMoneyRecordApiTypeObtain = 1,//获得
    KSMoneyRecordApiTypeWithDraw,//提现
    KSMoneyRecordApiTypeWithRecharge,//充值
} KSMoneyRecordApiType;

@interface KSMoneyRecordApi : KSBaseApiRequest

-(instancetype)initWithId:(NSNumber*)mid
              record_type:(KSMoneyRecordApiType)record_type
             refresh_type:(KSRequestRefreshType)refresh_type
                    limit:(NSNumber*)limit;

@end
