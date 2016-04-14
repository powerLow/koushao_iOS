//
//  KSActivityListApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSActivityListApi : KSBaseApiRequest

- (instancetype)initWithLimit:(NSNumber*)limit createtime:(NSNumber*)createtime type:(KSRequestRefreshType)type;

@end
