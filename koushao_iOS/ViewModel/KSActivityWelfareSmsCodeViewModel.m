//
//  KSActivityWelfareSmsCodeViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityWelfareSmsCodeViewModel.h"
#import "KSWelfareCodeResultViewModel.h"
#import "KSActivityWelfareRecordViewModel.h"

@interface KSActivityWelfareSmsCodeViewModel ()


@property(nonatomic, strong, readwrite) RACCommand *didSubmitCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickViewRecordCommand;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation KSActivityWelfareSmsCodeViewModel

@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.title = @"验证码发放";


    self.didSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        [self.requestRemoteDataCommand execute:input];
        return [RACSignal empty];
    }];

    self.didClickViewRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        KSActivityWelfareRecordViewModel *viewModel = [[KSActivityWelfareRecordViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"验证码验证:%@", input);
        return [KSClientApi requestWelafreVerifyWithType:KSWelfareVerifyTypeSMSCode Code:input];
    }];

    [[[self.requestRemoteDataCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
        NSString *title = @"验证码发放";
        KSWelfareCodeResultViewModel *viewModel = [[KSWelfareCodeResultViewModel alloc] initWithServices:self.services params:@{@"title" : title, @"model" : x}];
        [self.services pushViewModel:viewModel animated:YES];
    }];

    [[self.requestRemoteDataCommand.errors
            filter:[self requestRemoteDataErrorsFilter]]
            subscribe:self.errors];
}

@end
