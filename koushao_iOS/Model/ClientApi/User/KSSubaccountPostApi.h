//
//  KSSubaccountApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"

@interface KSSubaccountPostApi : KSBaseApiRequest

- (instancetype)initWithAccount:(NSString*)account
                       Password:(NSString*)password
                         signin:(BOOL)signin
                       question:(BOOL)question
                        welfare:(BOOL)welfare;
@end
