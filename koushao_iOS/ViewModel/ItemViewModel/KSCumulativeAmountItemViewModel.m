//
//  KSCumulativeAmountItemViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSCumulativeAmountItemViewModel.h"

@implementation KSCumulativeAmountItemViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.itemModel = params[@"item"];
    }
    return self;
}


@end
