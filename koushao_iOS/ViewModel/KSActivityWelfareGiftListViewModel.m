//
//  KSActivityWelfareGiftListViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityWelfareGiftListViewModel.h"
#import "KSAwardItemViewModel.h"
#import "KSAwardItemModel.h"
#import "KSConfirmGfitViewModel.h"
#import "KSConfirmResultViewModel.h"
#import "NSDate+Category.h"
@interface KSActivityWelfareGiftListViewModel ()

@property(nonatomic, strong, readwrite) NSArray *items;

@property(nonatomic, strong, readwrite) RACCommand *didSwitchTypeCommand;
@property(nonatomic, assign, readwrite) KSAwardListApiType curRequestType;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation KSActivityWelfareGiftListViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.curRequestType = KSAwardListApiTypeNoSend;
    self.title = @"实物奖品发放";
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        KSAwardItemViewModel *vm = self.dataSource[indexPath.section][indexPath.row];
        if (_curRequestType == KSAwardListApiTypeSend) {
            //已发放
            KSConfirmResultViewModel *viewModel = [[KSConfirmResultViewModel alloc] initWithServices:self.services params:@{@"wid" : vm.itemModel.id}];
            [self.services pushViewModel:viewModel animated:YES];
        } else {
            //未发放
            KSConfirmGfitViewModel *viewModel = [[KSConfirmGfitViewModel alloc] initWithServices:self.services params:@{@"wid" : vm.itemModel.id}];
            [self.services pushViewModel:viewModel animated:YES];
        }

        return [RACSignal empty];
    }];
    
    
    
    

    
    self.didSwitchTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if ([input integerValue] == 0) {
            _curRequestType = KSAwardListApiTypeNoSend;
        } else {
            _curRequestType = KSAwardListApiTypeSend;
        }
        self.items = nil;
        [self.requestRemoteDataCommand execute:@(KSRequestRefreshTypePullDown)];
        return [RACSignal empty];
    }];
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSNumber *wid = @0;
        NSMutableArray *wids = [NSMutableArray new];
        if (self.items != nil) {
            for (KSAwardItemModel *item in self.items) {
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

        return [self requestRemoteDataSignalWithId:wid refresh_type:[input integerValue]];
    }];
    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteItem:) name:@"confirmGift" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"confirmGift" object:nil];
}

-(void)deleteItem:(NSNotification*)notification {
    
    NSLog(@"删除wid = %@",notification.object );
    NSMutableArray *items = [_items mutableCopy];
    for (KSAwardItemModel* item in items) {
        if ([item.id isEqualToString:notification.object]) {
            [items removeObject:item];
            break;
        }
    }
    self.items = [items copy];
}

- (RACSignal *)requestRemoteDataSignalWithId:(NSNumber *)wid refresh_type:(KSRequestRefreshType)refresh_type {
    RACSignal *fetchSignal = [KSClientApi getAwardListWithWid:wid refresh_type:refresh_type limit:@(self.perPage) type:_curRequestType];
    return [[[[fetchSignal take:self.perPage] collect]
            doNext:^(NSArray *items) {

            }]
            map:^id(NSArray *items) {

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

- (NSArray *)dataSourceWithItems:(NSArray *)items {
    if (items.count == 0) {
        self.sectionIndexTitles = [NSArray new];
        return nil;
    }
//    NSArray *viewModels = nil;
//    viewModels = [items.rac_sequence map:^(KSAwardItemModel *item) {
//        KSAwardItemViewModel *viewModel = [[KSAwardItemViewModel alloc] initWithServices:self.services params:@{@"item" : item}];
//        viewModel.isSend = _curRequestType == KSAwardListApiTypeSend;
//        viewModel.cellHeight = viewModel.isSend ? 120 : 100;
//        return viewModel;
//    }].array;
//    return @[viewModels];
    NSMutableArray *vms = [NSMutableArray new];
    NSMutableArray *sectionTitles = [NSMutableArray new];
    NSMutableArray *vm = nil;
    KSAwardItemModel *lastItem = nil;
    NSDateFormatter *ft = [NSDateFormatter new];
    
    
    for (int i = 0; i < items.count; ++i) {
        KSAwardItemModel *item = items[i];
        KSAwardItemViewModel *viewModel = [[KSAwardItemViewModel alloc] initWithServices:self.services params:@{@"item" : item}];
        viewModel.isSend = _curRequestType == KSAwardListApiTypeSend;
        viewModel.cellHeight = viewModel.isSend ? 120 : 100;
        ft.dateFormat = viewModel.isSend ? @"发放日期: yyyy-MM-dd" : @"抽奖日期: yyyy-MM-dd";
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
    self.sectionIndexTitles = [sectionTitles copy];
    return vms;
}
@end
