//
//  KSMapPoisApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSMapPoisApi : KSBaseApiRequest

-(instancetype)initWithQuery:(NSString*)query
                   longitude:(NSString*)longitude
                    latitude:(NSString*)latitude;

@end
