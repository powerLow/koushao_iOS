//
//  KSLoginViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSLoginViewModel.h"
#import "KSHomepageViewModel.h"
#import "KSLoginSmsApi.h"
#import "KSUser.h"
#import "APService.h"

@interface KSLoginViewModel ()

@property(nonatomic, copy, readwrite) NSURL *avatarURL;

@property(nonatomic, strong, readwrite) RACSignal *validLoginSignal;

@property(nonatomic, strong, readwrite) RACCommand *loginCommand;

@property(nonatomic, strong, readwrite) RACCommand *requestSmsCommand;

@property(nonatomic, assign, readwrite) BOOL isSmsRequestSuccess;

@end


@implementation KSLoginViewModel

- (void)initialize {
    [super initialize];
    self.title = @"手机号登陆";
    self.isSmsRequestSuccess = NO;
    @weakify(self)
    self.validLoginSignal = [[RACSignal
            combineLatest:@[RACObserve(self, mobilePhone), RACObserve(self, smscode)] reduce:^id(NSString *mobilePhone, NSString *smscode) {
                return @(mobilePhone.length == 11 && smscode.length > 0);
            }]
            distinctUntilChanged];

    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *oneTimePassword) {
        return [KSClientApi loginWithPhone:_mobilePhone SmsCode:_smscode];
    }];
    self.requestSmsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"请求手机短信");
        return [KSClientApi requestSMSCode:_mobilePhone withType:1];
    }];

    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        KSUser *user = [KSUser currentUser];
        NSLog(@"登陆成功 = %@", user.mobilePhone);

        SSKeychain.rawLogin = user.username;
        SSKeychain.accessToken = user.sessionToken;

        [user ks_saveOrUpdate];
        [APService setAlias:user.username callbackSelector:nil object:nil];
        [[KSClientApi registerDevice:user.username]subscribeNext:^(id x) {
            
        } error:^(NSError *error) {
            
        }];
        KSHomepageViewModel *viewModel = [[KSHomepageViewModel alloc] initWithServices:self.services params:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.services resetRootViewModel:viewModel];
        });
    }];
    [self.requestSmsCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"结束请求手机短信 = %@", x);
        self.isSmsRequestSuccess = YES;
    }];


}

@end
