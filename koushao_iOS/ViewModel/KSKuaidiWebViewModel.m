//
//  KSKuaidiWebViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSKuaidiWebViewModel.h"

@interface KSKuaidiWebViewModel ()

@property(nonatomic, copy, readwrite) NSString *nu;
@property(nonatomic, copy, readwrite) NSString *company;

@end

@implementation KSKuaidiWebViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.nu = [params[@"nu"] copy];
        self.company = [params[@"company"] copy];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"查询结果";
}
@end
