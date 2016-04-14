//
//  KSApiResult.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSApiResult : NSObject

@property (copy, nonatomic) NSString *errorno;
@property (copy, nonatomic) NSString *msg;
@property (nonatomic,strong) id dict;
@end
