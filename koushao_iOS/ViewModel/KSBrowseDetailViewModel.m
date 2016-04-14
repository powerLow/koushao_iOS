//
//  KSBrowseDetailViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBrowseDetailViewModel.h"

#import "KSClientApi.h"

@interface KSBrowseDetailViewModel ()
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@property(nonatomic, strong, readwrite) KSActivityVisitsInfo *visitsInfo;

@end

@implementation KSBrowseDetailViewModel

@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.title = @"浏览详情";

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[self requestVisitsInfo] takeUntil:self.rac_willDeallocSignal];
    }];

    RAC(self, visitsInfo) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];
//    [RACObserve(self, visitsInfo) subscribeNext:^(id x) {
//        NSLog(@"self.visitsInfo = %@",self.visitsInfo);
//    }];
}

- (RACSignal *)requestVisitsInfo {
    return [[KSClientApi getVisitsInfoApi] doNext:^(KSActivityVisitsInfo *x) {
        //缓存
        //NSLog(@"donext = %@",x);
        [x ks_saveOrUpdate];

    }];
}

- (id)fetchLocalData {
    KSActivityVisitsInfo *info = nil;
    info = [KSActivityVisitsInfo ks_fetch];
    return info;
}


@end
