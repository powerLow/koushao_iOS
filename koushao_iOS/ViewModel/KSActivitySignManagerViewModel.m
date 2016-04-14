//
//  KSActivitySignManagerViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignManagerViewModel.h"

#import "KSActivitySignQRCodeViewModel.h"
#import "KSActivitySignCodeViewModel.h"
#import "KSActivityUserSignViewModel.h"
#import "KSActivitySignRecordViewModel.h"

@interface KSActivitySignManagerViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didClickQrcodeScanCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickSmsCodeCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickUserSignCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickSignRecordCommand;
@end

@implementation KSActivitySignManagerViewModel

- (void)initialize {
    [super initialize];
    self.title = @"签到管理";


    self.didClickQrcodeScanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"扫码签到");
        KSActivitySignQRCodeViewModel *viewModel = [[KSActivitySignQRCodeViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didClickSmsCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"短信签到");
        KSActivitySignCodeViewModel *viewModel = [[KSActivitySignCodeViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didClickUserSignCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"主动签到");
        KSActivityUserSignViewModel *viewModel = [[KSActivityUserSignViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didClickSignRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"签到记录");
        KSActivitySignRecordViewModel *viewModel = [[KSActivitySignRecordViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

}

@end
