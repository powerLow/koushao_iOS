//
//  KSActivityWelfareQRCodeViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <nameser.h>
#import "KSActivityWelfareQRCodeViewModel.h"
#import "KSWelfareVerifyResultModel.h"
#import "KSWelfareCodeResultViewModel.h"

@interface KSActivityWelfareQRCodeViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation KSActivityWelfareQRCodeViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.title = @"二维码发放";

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"二维码:%@", input);
        return [KSClientApi requestWelafreVerifyWithType:KSWelfareVerifyTypeQRCode Code:input];
    }];

    [[[self.requestRemoteDataCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]
            subscribeNext:^(KSWelfareVerifyResultModel *x) {
                NSLog(@"x = %@", x);
                NSString *title = @"二维码发放";
                KSWelfareCodeResultViewModel *viewModel = [[KSWelfareCodeResultViewModel alloc] initWithServices:self.services params:@{@"title" : title, @"model" : x}];
                [self.services pushViewModel:viewModel animated:YES];
            }];
}
@end
