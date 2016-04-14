//
//  KSActivityWelfareRecordViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityWelfareRecordViewModel.h"
#import "KSWelfareRecordItemViewModel.h"
#import "KSWelfareRecordItemDetailViewModel.h"
#import "KSConfirmResultViewModel.h"
#import "NSDate+Category.h"

@interface KSActivityWelfareRecordViewModel ()

@property(nonatomic, strong, readwrite) NSArray *items;

@property(nonatomic, strong, readwrite) NSArray *sectionSource;

@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;


@property(nonatomic, strong, readwrite) KSWelfareVerifyLogsResultModel *model;
@property(nonatomic, assign, readwrite) KSWelfareVerifyLogsRecordType curRequestType;
@property(nonatomic, strong, readwrite) RACCommand *didSwitchCommand;

@end

@implementation KSActivityWelfareRecordViewModel
@synthesize requestRemoteDataCommand;

- (instancetype)initWithServices:(id)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.curRequestType = KSWelfareVerifyLogsRecordTypeAll;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"发放记录";
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        KSWelfareRecordItemViewModel *viewModel = self.dataSource[indexPath.section][indexPath.row];
        NSString *title = @"";
        if (viewModel.itemModel.welfare_type == KSWelfareTypeWuPin) {
            title = @"实物奖品发放详情";
            KSConfirmResultViewModel *vM = [[KSConfirmResultViewModel alloc]
                    initWithServices:self.services params:@{@"wid" : viewModel.itemModel.id, @"title" : title}];
            [self.services pushViewModel:vM animated:YES];
        } else {
//            title = @"奖卷奖品发放详情";
//            KSWelfareRecordItemDetailViewModel *vM = [[KSWelfareRecordItemDetailViewModel alloc]
//                    initWithServices:self.services params:@{@"item" : viewModel.itemModel, @"title" : title}];
//            [self.services pushViewModel:vM animated:YES];
        }

        return [RACSignal empty];
    }];

    self.didSwitchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *type) {
        @strongify(self)
        if ([type unsignedIntegerValue] == 0) {
            self.curRequestType = KSWelfareVerifyLogsRecordTypeAll;
        } else if ([type unsignedIntegerValue] == 1) {
            self.curRequestType = KSWelfareVerifyLogsRecordTypeAllQuan;
        } else if ([type unsignedIntegerValue] == 2) {
            self.curRequestType = KSWelfareVerifyLogsRecordTypeShiwu;
        }
        self.isNoMoreData = NO;
        self.items = nil;
        [self.requestRemoteDataCommand execute:@(KSRequestRefreshTypePullDown)];
        return [RACSignal empty];
    }];

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self)
        NSNumber *wid = @0;
        NSLog(@"wid = %@", wid);
        NSMutableArray *wids = [NSMutableArray new];
        NSArray *items = self.items;
        if (items != nil) {
            for (KSWelfareVerifyLogsItemModel *item in items) {
                [wids addObject:item.id];
            }
            if ([input unsignedIntegerValue] == KSRequestRefreshTypePullDown) {
                //下拉
                //找到最大的id
                wid = [wids valueForKeyPath:@"@max.self"];
            } else {
                //上拉，找到最小的id
                wid = [wids valueForKeyPath:@"@min.self"];
            }

        }
        NSLog(@"wid = %@", wid);
        return [[self requestRemoteDataSignalWid:wid refresh_type:[input unsignedIntegerValue]] takeUntil:self.rac_willDeallocSignal];
    }];

    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];

    [self.didSwitchCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
        self.items = [items copy];
    }];

    [[self.requestRemoteDataCommand.errors
            filter:[self requestRemoteDataErrorsFilter]]
            subscribe:self.errors];
}


- (RACSignal *)requestRemoteDataSignalWid:(NSNumber *)wid refresh_type:(KSRequestRefreshType)refresh_type {
    RACSignal *fetchSignal = [RACSignal empty];
//    self.perPage = 1;
    fetchSignal = [KSClientApi getWelfareLogsListWid:wid refresh_type:refresh_type record_type:_curRequestType limit:@(self.perPage)];

    return [[[fetchSignal take:self.perPage]
            doNext:^(KSWelfareVerifyLogsResultModel *model) {
                NSLog(@"缓存第一页的数据");
            }]
            map:^id(KSWelfareVerifyLogsResultModel *model) {
                self.model = model;
                NSArray *items = [model.list copy];

                if (refresh_type == KSRequestRefreshTypePullDown) {
                    if (items.count < self.perPage && self.items.count == 0) {
                        //第一次下拉刷新,没有够分页数,肯定是没有更多了
                        self.isNoMoreData = YES;
                    }
                } else {
                    if (items.count < self.perPage) {
                        //上拉不满每次查询数,肯定是没有更多数据了
                        self.isNoMoreData = YES;
                    } else {
                        self.isNoMoreData = items.count == 0;
                    }

                }

                if (wid != 0) {
                    if (refresh_type == KSRequestRefreshTypePullDown) {
                        items = @[items.rac_sequence, (self.items ?: @[]).rac_sequence].rac_sequence.flatten.array;
                    } else {
                        items = @[(self.items ?: @[]).rac_sequence, items.rac_sequence].rac_sequence.flatten.array;
                    }
                }
                return items;
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

//    __block KSWelfareVerifyLogsItemModel *lastItem = nil;
//    NSArray *viewModels = [items.rac_sequence map:^(KSWelfareVerifyLogsItemModel* item) {
//        KSWelfareRecordItemViewModel *viewModel = [[KSWelfareRecordItemViewModel alloc] initWithServices:self.services params:@{@"item":item}];
//        if (lastItem != nil) {
//            NSDate *lastdate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastItem.time unsignedIntegerValue]];
//            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[item.time unsignedIntegerValue]];
//            NSLog(@"lastdate = %@ date = %@",lastdate,date);
//            viewModel.showTime = [NSDate isSameDay:lastdate date2:date] ? NO : YES;
//        }else{
//            viewModel.showTime = YES;
//        }
//        
//        NSLog(@"viewModel.showTime = %d",viewModel.showTime);
//        lastItem = item;
//        return viewModel;
//    }].array;

    NSMutableArray *vms = [NSMutableArray new];
    NSMutableArray *sectionTitles = [NSMutableArray new];
    NSMutableArray *vm = nil;
    KSWelfareVerifyLogsItemModel *lastItem = nil;
    NSDateFormatter *ft = [NSDateFormatter new];
    ft.dateFormat = @"发放日期: yyyy-MM-dd";

    for (int i = 0; i < items.count; ++i) {
        KSWelfareVerifyLogsItemModel *item = items[i];
        KSWelfareRecordItemViewModel *viewModel = [[KSWelfareRecordItemViewModel alloc] initWithServices:self.services params:@{@"item" : item}];
        if (lastItem != nil) {
            NSDate *lastdate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastItem.time unsignedIntegerValue]];
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[item.time unsignedIntegerValue]];
//            NSLog(@"lastdate = %@ date = %@",lastdate,date);
            if ([NSDate isSameDay:lastdate date2:date]) {
                viewModel.showTime = NO;
            } else {
                viewModel.showTime = YES;
                NSString *strTime = [ft stringFromDate:lastdate];
                [sectionTitles addObject:strTime];
                [vms addObject:vm];
                vm = nil;
                vm = [NSMutableArray new];
            }
        } else {
            vm = [NSMutableArray new];
            viewModel.showTime = YES;
        }
        [vm addObject:viewModel];
        lastItem = item;
        if (i == items.count - 1) {
            if (vm.count > 0) {
                NSDate *lastdate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastItem.time unsignedIntegerValue]];
                NSString *strTime = [ft stringFromDate:lastdate];
                [sectionTitles addObject:strTime];
                [vms addObject:vm];
            }
        }
    }
    self.sectionSource = [sectionTitles copy];
//    NSLog(@"vms = %@",vms);
    return vms;
}

@end
