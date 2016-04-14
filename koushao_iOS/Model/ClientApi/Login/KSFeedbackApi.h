//
//  KSFeedbackApi.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSFeedbackApi : KSBaseApiRequest
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* contact;
@end
