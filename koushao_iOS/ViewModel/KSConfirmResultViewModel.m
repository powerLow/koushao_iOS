//
//  KSConfirmResultViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSConfirmResultViewModel.h"
#import "KSKuaidiWebViewModel.h"

@interface KSConfirmResultViewModel ()

@property(nonatomic, strong, readwrite) NSNumber *wid;
@property(nonatomic, strong, readwrite) KSAwardDetailModel *model;

@property(nonatomic, strong, readwrite) RACCommand *didClickLoopUpBtn;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;


@end

@implementation KSConfirmResultViewModel
@synthesize requestRemoteDataCommand;

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.wid = params[@"wid"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"实物奖品发放详情";

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [KSClientApi getAwardDetailWid:_wid];
    }];

    RAC(self, model) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:nil];

    self.didClickLoopUpBtn = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(NSString *nu, NSString *company) = tuple;

        KSKuaidiWebViewModel *viewModel = [[KSKuaidiWebViewModel alloc] initWithServices:self.services params:@{@"nu" : nu, @"company" : company}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}
@end
