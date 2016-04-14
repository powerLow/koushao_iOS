//
//  KSDrawCashApi.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"


@interface KSDrawCashApi : KSBaseApiRequest
@property(nonatomic,copy)NSString* account;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,assign)float money;
@property(nonatomic,copy)NSString* code;
@property(nonatomic,copy)NSString* pic_1;
@end
