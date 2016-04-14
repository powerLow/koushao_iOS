//
//  KSWelfareVerifyApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/11.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

typedef enum : NSUInteger {
    KSWelfareVerifyTypeQRCode,
    KSWelfareVerifyTypeSMSCode,
} KSWelfareVerifyType;

@interface KSWelfareVerifyApi : KSBaseApiRequest

- (instancetype)initWithType:(KSWelfareVerifyType)type Code:(NSString*)code;

@end
