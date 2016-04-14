//
//  KSWelfareQRCodeViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/11.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareCodeResultViewModel.h"

@interface KSWelfareCodeResultViewModel ()

@property(nonatomic, strong, readwrite) KSWelfareVerifyResultModel *result;
@property(nonatomic, strong, readwrite) RACCommand *didClickOkBtnCommand;
@end

@implementation KSWelfareCodeResultViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (services) {
        self.result = params[@"model"];
    }
    return self;
}

- (void)initialize {

    self.didClickOkBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
}

@end
