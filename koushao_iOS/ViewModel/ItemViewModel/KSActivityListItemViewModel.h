//
//  KSActivityListItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSActivity.h"

@interface KSActivityListItemViewModel : NSObject
@property(nonatomic, assign) CGFloat cellHeight;

@property(nonatomic, strong, readonly) KSActivity *activity;

- (instancetype)initWithActivity:(KSActivity *)activity;

@end
