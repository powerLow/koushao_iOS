//
//  KSRequestSmsCode.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSRequestSmsCode : KSBaseApiRequest
- (id)initWithMobile:(NSString *)mobile withType:(NSInteger)type;
@end
