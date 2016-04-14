//
//  KSActivityListViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityListViewModel.h"
#import "KSActivityListItemViewModel.h"
#import "KSActivityManagerViewModel.h"

@interface KSActivityListViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didClickItemCommand;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation KSActivityListViewModel
@synthesize requestRemoteDataCommand;


- (void)initialize {
    [super initialize];
    self.title = @"活动列表";
    self.isNoMoreData = NO;
    @weakify(self)
    self.didClickItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [KSUtil cacheCurrentActivity:input];
        KSActivityManagerViewModel *viewModel = [[KSActivityManagerViewModel alloc] initWithServices:self.services params:@{@"activity" : input}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        //取出KSActivity数据模型
        KSActivityListItemViewModel *viewModel = self.dataSource[indexPath.section][indexPath.row];
        return [self.didClickItemCommand execute:viewModel.activity];
    }];
    
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSNumber *create_time = @0;
        NSMutableArray *timeArray = [NSMutableArray new];
        if (self.items != nil) {
            //搜集起来所有时间
            for (KSActivity *item in self.items) {
                [timeArray addObject:item.create_time];
            }
            if ([input unsignedIntegerValue] == 1) {
                //下拉
                //找到最大的create_time
                create_time = [timeArray valueForKeyPath:@"@max.self"];
            } else {
                //上拉，找到最小的create_time
                create_time = [timeArray valueForKeyPath:@"@min.self"];
            }
            
        }

        return [self requestRemoteDataSignalWithTime:create_time type:[input unsignedIntegerValue]];
    }];
    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:nil];
    
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

- (RACSignal *)requestRemoteDataSignalWithTime:(NSNumber *)time type:(KSRequestRefreshType)type {
    RACSignal *fetchSignal = [KSClientApi getActivityListWithLimit:@(self.perPage) time:time type:type];
    return [[[[fetchSignal take:self.perPage] collect]
             doNext:^(NSArray *datas) {
                 //缓存第一页的数据
                 //                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 //                     [KSActivity ks_saveActivitys:datas];
                 //                 });
             }]
            map:^id(NSArray *datas) {
                
                if (type == KSRequestRefreshTypePullDown) {
                    if (datas.count < self.perPage && self.items.count == 0) {
                        //第一次下拉刷新,没有够单页数,肯定是没有更多了
                        self.isNoMoreData = YES;
                    }
                    datas = @[datas.rac_sequence, (self.items ?: @[]).rac_sequence].rac_sequence.flatten.array;
                } else {
                    self.isNoMoreData = datas.count == 0;
                    datas = @[(self.items ?: @[]).rac_sequence, datas.rac_sequence].rac_sequence.flatten.array;
                }
                
                return datas;
            }];
}

- (id)fetchLocalData {
    NSArray *items = nil;
    items = [KSActivity ks_fetchActivitys];
    //排序一下
    NSComparator cmptr = ^(KSActivity *obj1, KSActivity *obj2) {
        if ([obj1.create_time integerValue] < [obj2.create_time integerValue]) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        
        if ([obj1.create_time integerValue] > [obj2.create_time integerValue]) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        return (NSComparisonResult) NSOrderedSame;
    };
    
    NSArray *sorts = [items sortedArrayUsingComparator:cmptr];
    
    return sorts;
}

//当events更新时候,会调用此方法更新viewModels
- (NSArray *)dataSourceWithItems:(NSArray *)datas {
    if (datas.count == 0) return nil;
    
    NSArray *viewModels = [datas.rac_sequence map:^(KSActivity *activity) {
        KSActivityListItemViewModel *viewModel = [[KSActivityListItemViewModel alloc] initWithActivity:activity];
        viewModel.cellHeight = 80;
        return viewModel;
    }].array;
    
    return @[viewModels];
}


@end
