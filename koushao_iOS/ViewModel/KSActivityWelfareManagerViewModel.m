//
//  KSActivityWelfareManagerViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityWelfareManagerViewModel.h"
#import "KSActivityWelfareQRCodeViewModel.h"
#import "KSActivityWelfareSmsCodeViewModel.h"
#import "KSActivityWelfareGiftListViewModel.h"

#import "KSActivityWelfareRecordViewModel.h"
#import "KSWelfareStatisticsViewModel.h"

@interface KSActivityWelfareManagerViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didClickQrcodeScanCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickSmsCodeCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickRealGiftCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickWelfareRecordCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickWelfareStatisticsCommand;
@end


@implementation KSActivityWelfareManagerViewModel

- (void)initialize {
    [super initialize];
    self.title = @"福利管理";

    self.didClickQrcodeScanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"扫码发放");

        KSActivityWelfareQRCodeViewModel *viewModel = [[KSActivityWelfareQRCodeViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];

        return [RACSignal empty];
    }];

    self.didClickSmsCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"短信发放");
        KSActivityWelfareSmsCodeViewModel *viewModel = [[KSActivityWelfareSmsCodeViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didClickRealGiftCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"实物奖品发放");
        KSActivityWelfareGiftListViewModel *viewModel = [[KSActivityWelfareGiftListViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didClickWelfareRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"福利发放记录");
        KSActivityWelfareRecordViewModel *viewModel = [[KSActivityWelfareRecordViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.didClickWelfareStatisticsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"福利发放统计");
        KSWelfareStatisticsViewModel *viewModel = [[KSWelfareStatisticsViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}

@end
