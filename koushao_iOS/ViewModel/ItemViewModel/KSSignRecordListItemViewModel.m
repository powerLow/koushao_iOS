//
//  KSSignRecordListItemViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSignRecordListItemViewModel.h"

@implementation KSSignRecordListItemViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.itemModel = params[@"item"];
    }
    return self;
}

@end
