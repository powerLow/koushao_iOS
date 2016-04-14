//
//  KSSignCodeResultViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSignCodeResultViewModel.h"

@interface KSSignCodeResultViewModel ()

@property(nonatomic, strong, readwrite) KSSignResultModel *result;
@property(nonatomic, strong, readwrite) RACCommand *didClickOkBtnCommand;

@end

@implementation KSSignCodeResultViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (services) {
        self.result = params[@"model"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"签到结果";

    self.didClickOkBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
}
@end
