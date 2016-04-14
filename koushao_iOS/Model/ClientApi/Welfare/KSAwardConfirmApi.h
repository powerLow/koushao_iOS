//
//  KSAwardConfirm.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSAwardConfirmApi : KSBaseApiRequest

- (instancetype)initWithWid:(NSNumber*)wid
                         nu:(NSString*)nu
                    company:(NSString*)company;

@end
