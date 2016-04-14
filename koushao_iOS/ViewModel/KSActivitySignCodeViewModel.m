//
//  KSActivitySignCodeViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignCodeViewModel.h"
#import "KSActivitySignRecordViewModel.h"
#import "KSClientApi.h"

#import "KSSignCodeResultViewModel.h"

@interface KSActivitySignCodeViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didSubmitCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickViewRecordCommand;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
//@property (nonatomic,strong,readwrite) 
@end

@implementation KSActivitySignCodeViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.title = @"验证码签到";


    self.didSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        [self.requestRemoteDataCommand execute:input];
        return [RACSignal empty];
    }];

    self.didClickViewRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        KSActivitySignRecordViewModel *viewModel = [[KSActivitySignRecordViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [KSClientApi signinWithType:KSSigninTypeSmsCode SmsCode:input];
    }];

    [[[self.requestRemoteDataCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
        NSString *title = @"验证码签到";
        KSSignCodeResultViewModel *viewModel = [[KSSignCodeResultViewModel alloc] initWithServices:self.services params:@{@"title" : title, @"model" : x}];
        [self.services pushViewModel:viewModel animated:YES];
    }];
}


@end
