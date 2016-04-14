//
//  KSStartpageViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSStartpageViewModel.h"
#import "KSLoginViewModel.h"
#import "KSLoginSubViewModel.h"
#import "KSHomepageViewModel.h"

@interface KSStartpageViewModel ()

//手机号登陆
@property(nonatomic, strong, readwrite) RACCommand *loginWithPhoneCommand;

//子账号登陆
@property(nonatomic, strong, readwrite) RACCommand *loginWithSubAccountCommand;

//发起活动
@property(nonatomic, strong, readwrite) RACCommand *beginActivityCommand;

@property(nonatomic, strong, readwrite) RACCommand *loginCommand;

@end


@implementation KSStartpageViewModel


- (void)initialize {
    [super initialize];

//    @weakify(self)

    self.loginWithPhoneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *oneTimePassword) {
//        @strongify(self)
        NSLog(@"手机号登陆-页面");
        KSLoginViewModel *loginVM = [[KSLoginViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:loginVM animated:YES];
        return [RACSignal empty];
    }];

    self.loginWithSubAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"子账号登陆-页面");
        KSLoginSubViewModel *loginVM = [[KSLoginSubViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:loginVM animated:YES];
        return [RACSignal empty];
    }];

    self.beginActivityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"发起活动-页面");
        return [RACSignal empty];
    }];
    @weakify(self)
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        KSUser *user = [KSUser currentUser];
        NSLog(@"登陆成功 = %@", user.mobilePhone);

        SSKeychain.rawLogin = user.username;
        SSKeychain.accessToken = user.sessionToken;

        [user ks_saveOrUpdate];
        KSHomepageViewModel *viewModel = [[KSHomepageViewModel alloc] initWithServices:self.services params:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.services resetRootViewModel:viewModel];
        });
        return [RACSignal empty];
    }];
}


@end
