//
//  KSSigninApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

typedef enum : NSUInteger {
    KSSigninTypeQRCode,
    KSSigninTypeSmsCode,
} KSSigninType;

@interface KSSigninApi : KSBaseApiRequest

- (instancetype)initWithSignType:(KSSigninType)type Code:(NSString*)code;

@end
