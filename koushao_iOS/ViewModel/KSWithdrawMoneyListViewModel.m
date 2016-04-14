//
//  KSWithdrawMoneyListViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWithdrawMoneyListViewModel.h"
#import "KSMoneyRecordListModel.h"
#import "KSWithdrawMoneyItemViewModel.h"
@interface KSWithdrawMoneyListViewModel()

@property (nonatomic,strong) KSMoneyRecordListModel *model;
@end

@implementation KSWithdrawMoneyListViewModel
- (void)initialize {
    [super initialize];
    self.title = @"累计提现金额";
    
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSNumber *mid = @0;
        NSMutableArray *mids = [NSMutableArray new];
        if (self.items != nil) {
            for (KSMoneyRecordItemModel *item in self.items) {
                [mids addObject:item.mid];
            }
            if ([input unsignedIntegerValue] == KSRequestRefreshTypePullDown) {
                //下拉
                //找到最大的id
                mid = [mids valueForKeyPath:@"@max.self"];
            } else {
                //上拉，找到最小的id
                mid = [mids valueForKeyPath:@"@min.self"];
            }
        }
        
        return [self requestRemoteDataSignalWithId:mid refresh_type:[input unsignedIntegerValue]];
    }];
    
    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:nil];
}

- (RACSignal*)requestRemoteDataSignalWithId:(NSNumber *)mid refresh_type:(KSRequestRefreshType)refresh_type{
    RACSignal *fetchSignal =  [KSClientApi getMoneyRecordWithId:mid refresh_type:refresh_type record_type:KSMoneyRecordApiTypeWithDraw limit:@(self.perPage)];
    
    return [[[fetchSignal take:self.perPage]
             doNext:^(KSMoneyRecordListModel *model) {
                 NSLog(@"缓存第一页的数据");
             }]
            map:^id(KSMoneyRecordListModel *model) {
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
                
                if (mid != 0) {
                    if (refresh_type == KSRequestRefreshTypePullDown) {
                        items = @[items.rac_sequence, (self.items ?: @[]).rac_sequence].rac_sequence.flatten.array;
                    } else {
                        items = @[(self.items ?: @[]).rac_sequence, items.rac_sequence].rac_sequence.flatten.array;
                    }
                }
                return items;
            }];
}
- (NSArray*)dataSourceWithItems:(NSArray *)items {
    if (items.count == 0) return nil;
    
    NSArray *viewModels = [items.rac_sequence map:^(KSMoneyRecordItemModel *item) {
        KSWithdrawMoneyItemViewModel *viewModel = [[KSWithdrawMoneyItemViewModel alloc] initWithServices:self.services params:@{@"item" : item}];
        return viewModel;
    }].array;
    
    return @[viewModels];
}
@end
