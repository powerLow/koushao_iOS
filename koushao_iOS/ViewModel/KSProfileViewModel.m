//
//  KSProfileViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSProfileViewModel.h"
#import "KSStartpageViewModel.h"

#import "KSProfileDetailViewModel.h"
#import "KSMyDataViewModel.h"
#import "KSMyMoneyInfoViewModel.h"
#import "KSFeedBackViewModel.h"
#import "KSAboutUsViewModel.h"

@interface KSProfileViewModel ()

@property(nonatomic, strong, readwrite) KSUser *user;

@end

@implementation KSProfileViewModel

- (void)initialize {
    [super initialize];
    self.title = @"我的";

    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        if (indexPath.section == 0) {
            //个人资料
            KSProfileDetailViewModel *viewModel = [[KSProfileDetailViewModel alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:viewModel animated:YES];
        }
        if (indexPath.section == 1) {
            NSArray *viewModels = @[
                    //活动统计
                    [[KSMyDataViewModel alloc] initWithServices:self.services params:nil],
                    //金额统计
                    [[KSMyMoneyInfoViewModel alloc] initWithServices:self.services params:nil],
                    //意见反馈
                    [[KSFeedBackViewModel alloc] initWithServices:self.services params:nil],
                    //关于我们
                    [[KSAboutUsViewModel alloc] initWithServices:self.services params:nil],
            ];

            [self.services pushViewModel:viewModels[indexPath.row] animated:YES];
        }
//        if (indexPath.section == 2 && indexPath.row == 0) {
//            //登出
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出? " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//            [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
//                if ([indexNumber intValue] == 1) {
//                    NSLog(@"取消");
//                } else {
//                    [[KSClientApi logout] subscribeCompleted:^{
//                        NSLog(@"登出成功");
//                        [KSUser cacheUser:nil];
//                    }];
//                    [SSKeychain deleteAccessToken];
//                    KSStartpageViewModel *startViewModel = [[KSStartpageViewModel alloc] initWithServices:self.services params:nil];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.services resetRootViewModel:startViewModel];
//                    });
//                }
//            }];
//            [alertView show];
//
//
//        }
        return [RACSignal empty];
    }];
}

@end
