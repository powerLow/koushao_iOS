//
//  KSDrawMoneyViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSDrawMoneyViewModel.h"

@interface KSDrawMoneyViewModel ()

@property(nonatomic, strong, readwrite) KSMyMoneyInfo *moneyinfo;

@end

@implementation KSDrawMoneyViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.moneyinfo = params[@"moneyinfo"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"申请提现";
}
@end
