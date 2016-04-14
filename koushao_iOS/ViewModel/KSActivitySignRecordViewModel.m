//
//  KSActivitySignRecordViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignRecordViewModel.h"
#import "KSSignRecordDetailViewModel.h"
#import "KSSignRecordListItemViewModel.h"
#import "NSDate+Category.h"

@interface KSActivitySignRecordViewModel ()

@property(nonatomic, strong, readwrite) NSArray *sectionSource;
@property(nonatomic, strong, readwrite) KSSigninListModel *listModel;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

//切换已签到,未签到
@property(nonatomic, assign, readwrite) KSSigninListApiType curRequestType;
@property(nonatomic, strong) NSArray *itemsYes;
//已签到的
@property(nonatomic, strong) NSArray *itemsNO;//未签到的
@end

@implementation KSActivitySignRecordViewModel
@synthesize requestRemoteDataCommand;

- (instancetype)initWithServices:(id)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.curRequestType = KSSigninListApiTypeYes;
    }
    return self;
}


- (void)initialize {
    [super initialize];
    self.title = @"签到记录";

    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *index) {
        KSSignRecordListItemViewModel *vm = self.dataSource[index.section][index.row];
        KSSigninListItemModel *item = vm.itemModel;
        KSSignRecordDetailViewModel *viewModel = [[KSSignRecordDetailViewModel alloc] initWithServices:self.services params:@{@"item" : item}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didSwitchTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id type) {
        if ([type unsignedIntegerValue] == 1) {
            self.curRequestType = KSSigninListApiTypeNO;//未签到
        } else if ([type unsignedIntegerValue] == 0) {
            self.curRequestType = KSSigninListApiTypeYes;//已签到
        }
        self.isNoMoreData = NO;
        [self.requestRemoteDataCommand execute:@(KSRequestRefreshTypePullDown)];
        return [RACSignal empty];
    }];
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSNumber *tid = @0;
        NSMutableArray *tids = [NSMutableArray new];
        NSArray *items = _curRequestType == KSSigninListApiTypeYes ? self.itemsYes : self.itemsNO;
        if (items != nil) {
            for (KSSigninListItemModel *item in items) {
                [tids addObject:item.tid];
            }
            if ([input unsignedIntegerValue] == KSRequestRefreshTypePullDown) {
                //下拉
                //找到最大的tid
                tid = [tids valueForKeyPath:@"@max.self"];
            } else {
                //上拉，找到最小的tid
                tid = [tids valueForKeyPath:@"@min.self"];
            }

        }
        NSLog(@"tid = %@", tid);
        if (tid == nil) {
            tid = @0;
        }
        return [self requestRemoteDataSignalWithTid:tid refresh_tyep:[input integerValue]];
    }];
    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];
}

- (RACSignal *)requestRemoteDataSignalWithTid:(NSNumber *)tid
                                 refresh_tyep:(KSRequestRefreshType)refresh_type {
    RACSignal *fetchSignal = [KSClientApi getSigninListWithTid:tid type:_curRequestType refresh_tyep:refresh_type limit:@(self.perPage)];
    return [[[fetchSignal take:self.perPage]
            doNext:^(KSSigninListModel *model) {
            }]
            map:^id(KSSigninListModel *model) {
                self.listModel = model;
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

                if (_curRequestType == KSSigninListApiTypeYes) {
                    if (tid != 0) {
                        self.itemsYes = @[(self.itemsYes ?: @[]).rac_sequence, items.rac_sequence].rac_sequence.flatten.array;
                    }
                    items = [_itemsYes copy];
                } else {
                    if (tid != 0) {
                        self.itemsNO = @[(self.itemsNO ?: @[]).rac_sequence, items.rac_sequence].rac_sequence.flatten.array;
                    }
                    items = [_itemsNO copy];
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

    NSMutableArray *vms = [NSMutableArray new];
    NSMutableArray *sectionTitles = [NSMutableArray new];
    NSMutableArray *vm = nil;
    NSDateFormatter *ft = [NSDateFormatter new];
    if (_curRequestType == KSSigninListApiTypeYes) {
        ft.dateFormat = @"签到日期: yyyy-MM-dd";
    } else {
        ft.dateFormat = @"报名日期: yyyy-MM-dd";
    }
    KSSigninListItemModel *lastItem = nil;
    for (int i = 0; i < items.count; ++i) {
        KSSigninListItemModel *item = items[i];
        KSSignRecordListItemViewModel *viewModel = [[KSSignRecordListItemViewModel alloc] initWithServices:self.services params:@{@"item" : item}];
        viewModel.cellHeight = 110;
        if (_curRequestType == KSSigninListApiTypeYes) {
            viewModel.isSignin = YES;
        } else {
            viewModel.isSignin = NO;
        }
        if (lastItem != nil) {
            NSDate *lastdate = nil;
            NSDate *date = nil;
            //已签到按签到时间,未签到按报名时间
            if (_curRequestType == KSSigninListApiTypeYes) {
                lastdate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastItem.signin_time unsignedIntegerValue]];
                date = [[NSDate alloc] initWithTimeIntervalSince1970:[item.signin_time unsignedIntegerValue]];
            } else {
                lastdate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastItem.signup_time unsignedIntegerValue]];
                date = [[NSDate alloc] initWithTimeIntervalSince1970:[item.signup_time unsignedIntegerValue]];
            }
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
                NSDate *lastdate = nil;
                if (_curRequestType == KSSigninListApiTypeYes) {
                    lastdate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastItem.signin_time unsignedIntegerValue]];
                } else {
                    lastdate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastItem.signup_time unsignedIntegerValue]];
                }
                NSString *strTime = [ft stringFromDate:lastdate];
                [sectionTitles addObject:strTime];
                [vms addObject:vm];
            }
        }
    }
    self.sectionSource = [sectionTitles copy];
    return vms;
//    return @[ viewModels ];
}

@end
