//
//  KSLoginSubAccount.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSLoginSubAccount : KSBaseApiRequest
- (id)initWithUserName:(NSString *)userName password:(NSString *)password;

- (NSString *)username;
- (NSString *)msg;
- (NSNumber *)errorno;
@end
