//
//  KSEnrollRecordApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSEnrollRecordApi : KSBaseApiRequest

-(instancetype)initWithTid:(NSNumber*)tid
              refresh_type:(KSRequestRefreshType)type
                      limit:(NSNumber*)limit;

@end
