//
//  KSLoginSubViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSLoginSubViewModel.h"
#import "KSClientApi.h"
#import "KSHomepageViewModel.h"
#import "APService.h"
@interface KSLoginSubViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *loginCommand;

@end
@implementation KSLoginSubViewModel

- (void)initialize {
    [super initialize];
    self.title = @"子账号登陆";
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *oneTimePassword) {
        return [KSClientApi loginWithSubAccount:_username password:_password];
    }];
    
    @weakify(self);
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        KSUser *user = [KSUser currentUser];
        NSLog(@"登陆成功 = %@", user.mobilePhone);
        
        SSKeychain.rawLogin = user.username;
        SSKeychain.accessToken = user.sessionToken;
        [APService setAlias:user.username callbackSelector:nil object:nil];
        [user ks_saveOrUpdate];
        [[KSClientApi registerDevice:user.username]subscribeNext:^(id x) {
            
        } error:^(NSError *error) {
            
        }];
        KSHomepageViewModel *viewModel = [[KSHomepageViewModel alloc] initWithServices:self.services params:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.services resetRootViewModel:viewModel];
        });
    }];
}


@end
