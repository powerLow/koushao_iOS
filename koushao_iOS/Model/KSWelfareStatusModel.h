//
//  KSWelfareStatusModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/28.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSWelfareStatusModel : NSObject

@property (nonatomic,copy,readonly) NSString *welfare_name;
@property (nonatomic,copy,readonly) NSString *activity_title;
@property (nonatomic,strong,readonly) NSNumber *status;
@property (nonatomic,strong,readonly) NSNumber *endtime;
@end
