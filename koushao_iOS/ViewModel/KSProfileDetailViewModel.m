//
// Created by 廖哲琦 on 15/11/30.
// Copyright (c) 2015 kuaicuhmen. All rights reserved.
//

#import "KSProfileDetailViewModel.h"
#import "KSStartpageViewModel.h"
#import "APService.h"

@interface KSProfileDetailViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didQuitBtnCommand;

@end

@implementation KSProfileDetailViewModel
- (void)initialize {
    [super initialize];
    self.title = @"账号设置";
    
    self.didQuitBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出? " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
            if ([indexNumber intValue] == 1) {
                NSLog(@"取消");
            } else {
                KSStartpageViewModel *startViewModel = [[KSStartpageViewModel alloc] initWithServices:self.services params:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.services resetRootViewModel:startViewModel];
                });
                
                [[KSClientApi registerDevice:@""]subscribeNext:^(id x) {
                    [[KSClientApi logout] subscribeCompleted:^{
                        [APService setAlias:@"" callbackSelector:nil object:nil];
                    }];
                } error:^(NSError *error) {
                    [KSUser cacheUser:nil];
                    [SSKeychain deleteAccessToken];
                }];
                
            }
        }];
        [alertView show];
        return [RACSignal empty];
    }];
}
@end