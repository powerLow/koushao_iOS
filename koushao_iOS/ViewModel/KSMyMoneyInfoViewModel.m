//
//  KSMyMoneyInfoViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/22.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyMoneyInfoViewModel.h"
#import "KSMyInfo.h"
#import "KSMyMoneyInfo.h"
#import "KSMyMoneyInfoViewModel.h"
#import "KSCumulativeAmountListViewModel.h"
#import "KSWithdrawMoneyListViewModel.h"

@interface KSMyMoneyInfoViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didDrawMoneyBtnClick;

//标题
@property(nonatomic, copy, readwrite) NSString *labelTitle;
//次数
@property(nonatomic, strong, readwrite) NSNumber *count;
//单位
@property(nonatomic, copy, readwrite) NSString *unit;

@property(nonatomic, strong, readwrite) KSMyMoneyInfo *moneyinfo;

@property (nonatomic, assign, readwrite) BOOL has_arrow;

@end

@implementation KSMyMoneyInfoViewModel

- (void)initialize {
    [super initialize];
    self.title = @"金额统计";
    @weakify(self)
    self.didDrawMoneyBtnClick = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        if (self.moneyinfo != nil) {
            KSDrawMoneyViewModel *viewModel = [[KSDrawMoneyViewModel alloc] initWithServices:self.services params:@{@"moneyinfo" : self.moneyinfo}];
            [self.services pushViewModel:viewModel animated:YES];
        }
        return [RACSignal empty];
    }];

    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        if (indexPath.row == 0) {
            KSCumulativeAmountListViewModel *viewModel = [[KSCumulativeAmountListViewModel alloc] initWithServices:self.services params:@{@"title" : @"累计获得金额"}];
            [self.services pushViewModel:viewModel animated:YES];
        } else {
            KSWithdrawMoneyListViewModel *viewModel = [[KSWithdrawMoneyListViewModel alloc] initWithServices:self.services params:@{@"title" : @"累计取现金额"}];
            [self.services pushViewModel:viewModel animated:YES];
        }

        return [RACSignal empty];
    }];

    RAC(self, datas) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];

}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [KSClientApi getMyMoneyinfo];
    return [[[[fetchSignal take:self.perPage] collect]
            doNext:^(NSArray *datas) {
                //缓存
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    KSMyMoneyInfo *info = [datas lastObject];
                    [info ks_saveOrUpdate];
                });
            }]
            map:^id(NSArray *datas) {
                KSMyMoneyInfo *myinfo = [datas lastObject];
                self.moneyinfo = myinfo;
                return @[myinfo.obtain, myinfo.cash, /* myinfo.recharge, */ myinfo.applicant];
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
    KSMyMoneyInfo *myinfo = [KSMyMoneyInfo ks_fetchById:DB_ID_KSMYINFO];
    NSArray *items = nil;
    if (myinfo == nil) {
        items = @[@0, @0, @0, @0];
    } else {
        items = @[myinfo.obtain, myinfo.cash,/* myinfo.recharge, */myinfo.applicant];
    }

    return items;
}

//当events更新时候,会调用此方法更新viewModels
- (NSArray *)dataSourceWithDatas:(NSArray *)datas {
    if (datas.count == 0) return nil;

    NSArray *titledata = @[@"累计获取金额", @"获取金额记录",/* @"累计充值金额",*/@"当前可提现余额"];
    NSArray *unitdata = @[@"元", @"元",/*@"元",*/@"元"];
    NSMutableArray *viewModels = [[NSMutableArray alloc] initWithCapacity:titledata.count];
    for (int i = 0; i < titledata.count; i++) {
        KSMyMoneyInfoViewModel *viewModel = [[KSMyMoneyInfoViewModel alloc] init];
        viewModel.labelTitle = titledata[i];
        viewModel.unit = unitdata[i];
        viewModel.count = datas[i];
        viewModel.has_arrow = i > 1 ? NO : YES;
        [viewModels addObject:viewModel];
    }
    return @[viewModels];
}


@end
