//
//  KSSigninDetailApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSSigninDetailApi : KSBaseApiRequest

- (instancetype)initWithTicketId:(NSString*)ticket_id;

@end
