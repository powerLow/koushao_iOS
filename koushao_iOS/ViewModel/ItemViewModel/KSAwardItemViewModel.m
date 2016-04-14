//
//  KSAwardSendItemViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSAwardItemViewModel.h"

@interface KSAwardItemViewModel ()

@property(nonatomic, strong, readwrite) KSAwardItemModel *itemModel;

@end

@implementation KSAwardItemViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.itemModel = params[@"item"];
    }
    return self;
}

@end
