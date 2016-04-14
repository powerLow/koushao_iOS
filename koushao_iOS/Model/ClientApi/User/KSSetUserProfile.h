//
//  KSSetUserNickname.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/1.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSSetUserProfile : KSBaseApiRequest
- (id)initWithNickname:(NSString *)nickname andGender:(NSInteger)gender;
@end
