//
//  KSEnrollDetailViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollDetailViewModel.h"
#import "KSEnrollRecordViewModel.h"
#import "KSClientApi.h"

@interface KSEnrollDetailViewModel ()

@property(nonatomic, strong, readwrite) KSActivity *activity;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@property(nonatomic, strong, readwrite) RACCommand *didClickViewEnrollRecordCommand;

@property(nonatomic, strong, readwrite) KSActivityEnrollInfo *enrollInfo;

@end

@implementation KSEnrollDetailViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.activity = [KSUtil getCurrentActivity];
    self.title = @"报名详情";
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self requestEnrollInfo] takeUntil:self.rac_willDeallocSignal];
    }];
    
    self.didClickViewEnrollRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *param = nil;
        if ([_enrollInfo isEnroll]) {
            param = @{@"title" : @"报名记录", @"isEnroll" : @(YES)};
        } else {
            param = @{@"title" : @"售票记录", @"isEnroll" : @(NO)};
        }
        KSEnrollRecordViewModel *viewModel = [[KSEnrollRecordViewModel alloc] initWithServices:self.services params:param];
        
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    RAC(self, enrollInfo) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];
}

- (RACSignal *)requestEnrollInfo {
    return [[KSClientApi getEnrollInfoApi] doNext:^(KSActivityEnrollInfo *x) {
        [x ks_saveOrUpdate];
    }];
}

- (id)fetchLocalData {
    KSActivityEnrollInfo *info = nil;
    info = [KSActivityEnrollInfo ks_fetch];
    return info;
}

@end
