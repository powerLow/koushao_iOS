//
//  KSMyDataViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/15.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyDataViewModel.h"

@interface KSMyDataViewModel ()

//举办次数
@property(nonatomic, copy, readwrite) NSString *labelTitle;
//访问次数
@property(nonatomic, strong, readwrite) NSNumber *count;
//单位
@property(nonatomic, copy, readwrite) NSString *unit;

@property(nonatomic, strong, readwrite) NSArray *datas;
@end

@implementation KSMyDataViewModel

- (void)initialize {
    [super initialize];
    self.title = @"活动统计";

    RAC(self, datas) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];

}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [KSClientApi getMyinfo];
    return [[[[fetchSignal take:self.perPage] collect]
            doNext:^(NSArray *datas) {
                //缓存
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    KSMyInfo *info = [datas lastObject];
                    [info ks_saveOrUpdate];
                });
            }]
            map:^id(NSArray *datas) {
                KSMyInfo *myinfo = [datas lastObject];
                return @[myinfo.count, myinfo.visits, myinfo.interested, myinfo.enroll];
            }];
}

//处理错误
- (BOOL (^)(NSError *))requestRemoteDataErrorsFilter {
    return ^BOOL(NSError *error) {
        [KSUtil filterError:error params:self.services];
        return YES;
    };
}

//拉取缓存
- (id)fetchLocalData {
    KSMyInfo *myinfo = [KSMyInfo ks_fetchById:DB_ID_KSMYINFO];
    NSArray *items = nil;
    if (myinfo == nil) {
        items = @[@0, @0, @0, @0];
    } else {
        items = @[myinfo.count, myinfo.visits, myinfo.interested, myinfo.enroll];
    }

    return items;
}

//当events更新时候,会调用此方法更新viewModels
- (NSArray *)dataSourceWithDatas:(NSArray *)datas {
    if (datas.count == 0) return nil;

    NSArray *titledata = @[@"举办活动次数", @"访问人数", @"感兴趣人数", @"报名人数"];
    NSArray *unitdata = @[@"次", @"人", @"人", @"人"];
    NSMutableArray *viewModels = [[NSMutableArray alloc] initWithCapacity:titledata.count];
    for (int i = 0; i < titledata.count; i++) {
        KSMyDataViewModel *viewModel = [[KSMyDataViewModel alloc] init];
        viewModel.labelTitle = titledata[i];
        viewModel.unit = unitdata[i];
        viewModel.count = datas[i];
        [viewModels addObject:viewModel];
    }
    return @[viewModels];
}
@end
