//
//  KSEnrollRecordViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordViewModel.h"
#import "KSEnrollRecordItemViewModel.h"
#import "KSClientApi.h"
#import "KSActivityEnrollRecordItem.h"
#import "KSEnrollRecordDetailViewModel.h"

@interface KSEnrollRecordViewModel ()

@property(nonatomic, strong, readwrite) KSActivity *activity;
@property(nonatomic, strong, readwrite) RACCommand *didClickCellCommand;
@property(nonatomic, assign, readwrite) BOOL isEnroll;

@end


@implementation KSEnrollRecordViewModel

- (instancetype)initWithServices:(id)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.isEnroll = [params[@"isEnroll"] boolValue];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.activity = [KSUtil getCurrentActivity];

    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        KSEnrollRecordItemViewModel *viewModel = self.dataSource[indexPath.section][indexPath.row];
        NSString *title = nil;
        if (viewModel.isEnroll) {
            title = @"报名详情";
        } else {
            title = @"购票详情";
        }

        KSEnrollRecordDetailViewModel *vM = [[KSEnrollRecordDetailViewModel alloc] initWithServices:self.services params:@{@"title" : title, @"ticket_id" : viewModel.item.ticket_id, @"isEnroll" : @(_isEnroll)}];
        [self.services pushViewModel:vM animated:YES];

        return [RACSignal empty];
    }];

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSNumber *tid = @0;
        NSMutableArray *timeArray = [NSMutableArray new];
        if (self.items != nil) {
            //搜集起来所有时间
            for (KSActivityEnrollRecordItem *item in self.items) {
                [timeArray addObject:item.tid];
            }
            if ([input unsignedIntegerValue] == KSRequestRefreshTypePullDown) {
                //下拉
                //找到最大的create_time
                tid = [timeArray valueForKeyPath:@"@max.self"];
            } else {
                //上拉，找到最小的create_time
                tid = [timeArray valueForKeyPath:@"@min.self"];
            }

        }
        return [self requestRemoteDataSignalWithTid:tid type:[input integerValue]];
    }];

    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];
}


- (RACSignal *)requestRemoteDataSignalWithTid:(NSNumber *)tid type:(KSRequestRefreshType)type {
    RACSignal *fetchSignal = [KSClientApi getEnrollRecordApiWithTid:tid limit:@(self.perPage) type:type];
    return [[[[fetchSignal take:self.perPage] collect]
            doNext:^(NSArray *events) {

            }]
            map:^id(NSArray *tickets) {

                if (type == KSRequestRefreshTypePullDown) {
                    if (tickets.count < self.perPage && self.items.count == 0) {
                        //第一次下拉刷新,没有够分页数,肯定是没有更多了
                        self.isNoMoreData = YES;
                    }
                    tickets = @[tickets.rac_sequence, (self.items ?: @[]).rac_sequence].rac_sequence.flatten.array;
                } else {
                    if (tickets.count < self.perPage) {
                        //上拉不满每次查询数,肯定是没有更多数据了
                        self.isNoMoreData = YES;
                    } else {
                        self.isNoMoreData = tickets.count == 0;
                    }

                    tickets = @[(self.items ?: @[]).rac_sequence, tickets.rac_sequence].rac_sequence.flatten.array;
                }

                return tickets;
            }];
}

- (BOOL (^)(NSError *))requestRemoteDataErrorsFilter {
    return ^BOOL(NSError *error) {
        [KSUtil filterError:error params:self.services];
        return YES;
    };
}

- (id)fetchLocalData {
    NSArray *items = nil;
    return items;
}

- (NSArray *)dataSourceWithItems:(NSArray *)items {
    if (items.count == 0) return nil;

    NSArray *viewModels = [items.rac_sequence map:^(KSActivityEnrollRecordItem *ticket) {
        KSEnrollRecordItemViewModel *viewModel = [[KSEnrollRecordItemViewModel alloc] initWithServices:self.services params:@{@"item" : ticket, @"isEnroll" : @(_isEnroll)}];
        viewModel.cellHeight = 65;
        return viewModel;
    }].array;

    return @[viewModels];
}
@end
