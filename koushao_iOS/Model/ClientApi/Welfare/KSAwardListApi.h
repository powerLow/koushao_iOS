//
//  KSAwardListApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

typedef enum : NSUInteger {
    KSAwardListApiTypeNoSend,
    KSAwardListApiTypeSend,
} KSAwardListApiType;

@interface KSAwardListApi : KSBaseApiRequest

- (instancetype)initWithWid:(NSNumber*)wid
               refresh_type:(KSRequestRefreshType)refresh_type
                      limit:(NSNumber*)limit
                       type:(KSAwardListApiType)type;

@end
