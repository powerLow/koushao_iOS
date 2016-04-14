//
//  KSActivitySignQRCodeViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignQRCodeViewModel.h"
#import "KSSignCodeResultViewModel.h"

@interface KSActivitySignQRCodeViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation KSActivitySignQRCodeViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.title = @"二维码签到";

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [KSClientApi signinWithType:KSSigninTypeQRCode SmsCode:input];
    }];

    [[[self.requestRemoteDataCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
        NSString *title = @"验证码签到";
        KSSignCodeResultViewModel *viewModel = [[KSSignCodeResultViewModel alloc] initWithServices:self.services params:@{@"title" : title, @"model" : x}];
        [self.services pushViewModel:viewModel animated:YES];
    }];

}
@end
