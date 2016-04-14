//
//  KSLoginSmsApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"
@interface KSLoginSmsApi : KSBaseApiRequest

- (id)initWithMobile:(NSString *)mobile smscode:(NSString *)code;

- (NSString *)username;
- (NSString *)msg;
- (NSNumber *)errorno;
@end
