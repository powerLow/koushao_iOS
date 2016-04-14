//
//  KSActivityListItemViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityListItemViewModel.h"

@interface KSActivityListItemViewModel ()

@property(nonatomic, strong, readwrite) KSActivity *activity;

@end

@implementation KSActivityListItemViewModel

- (instancetype)initWithActivity:(KSActivity *)activity {
    self = [super init];
    if (self) {
        self.activity = activity;
    }
    return self;
}
@end
