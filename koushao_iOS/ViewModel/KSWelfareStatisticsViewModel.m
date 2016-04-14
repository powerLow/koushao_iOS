//
//  KSWelfareStatisticsViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareStatisticsViewModel.h"
#import "KSWelfareAnalyseModel.h"
#import "KSWelfareStatisticsItemViewModel.h"

@interface KSWelfareStatisticsViewModel ()

@property(nonatomic, strong, readwrite) NSArray *dataSource;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property(nonatomic, strong, readwrite) KSWelfareAnalyseModel *model;

@end

@implementation KSWelfareStatisticsViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.title = @"福利发放统计";

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [KSClientApi getWelfareAnalyse];
//        return [KSClientApi MapPoisWithQuery:@"北京" longitude:@"40.047857" latitude:@"116.313534"];
    }];

    RAC(self, model) = self.requestRemoteDataCommand.executionSignals.switchToLatest;

    [[self.requestRemoteDataCommand.errors
            filter:[self requestRemoteDataErrorsFilter]]
            subscribe:self.errors];
}

- (void)dataSourceWithModel:(KSWelfareAnalyseModel *)model {
    if (model != nil) {
        NSLog(@"model  = %@", model);
//        {
//            "result": {
//                "total_statistics": {
//                    "nodraw": 3, "total": 6, "detail": {
//                        "hasget": 2, "noget": 1
//                    }, "hasdraw": 3
//                }, "detail_statistics": [{"name": "\u4e00\u7b49\u5956", "detail": {
//                    "hasget": 1, "noget": 1
//                }, "nodraw": 0, "hasdraw": 2, "total": 2, "type": 1}, {"name": "\u4e8c\u7b49\u5956", "detail": {
//                    "hasget": 0, "noget": 0
//                }, "nodraw": 2, "hasdraw": 0, "total": 2, "type": 1}, {"name": "\u4e09\u7b49\u5956", "detail": {
//                    "hasget": 1, "noget": 0
//                }, "nodraw": 1, "hasdraw": 1, "total": 2, "type": 0}]
//            },
//        }
        NSMutableArray *datas = [NSMutableArray new];
        NSArray *titles = @[@"未抽取数量", @"已抽取数量", @"未发放数量", @"已发放数量"];
        //一点偏移有层次感
        NSArray *offsets = @[@0, @0, @15, @15];
        //总计
        NSMutableArray *total_datas = [NSMutableArray new];
        NSArray *counts = @[
                model.total_statistics.nodraw,
                model.total_statistics.hasdraw,
                model.total_statistics.detail.noget,
                model.total_statistics.detail.hasget];
        for (int i = 0; i < 4; ++i) {
            KSWelfareStatisticsItemViewModel *itemViewModel = [[KSWelfareStatisticsItemViewModel alloc] initWithServices:self.services params:nil];
            itemViewModel.text = titles[i];
            itemViewModel.count = counts[i];
            itemViewModel.left_offset = offsets[i];
            if (i < 2) {
                itemViewModel.font = KS_FONT_18;
                itemViewModel.line = YES;
                itemViewModel.bkcolr = [UIColor whiteColor];
            } else {
                itemViewModel.font = KS_SMALL_FONT;
                itemViewModel.line = NO;
//                itemViewModel.bkcolr = RGB(242, 242, 242);
                itemViewModel.bkcolr = [UIColor whiteColor];
            }
            [total_datas addObject:itemViewModel];
        }
        [datas addObject:total_datas];
        //每个奖品
        for (int j = 0; j < model.detail_statistics.count; ++j) {
            NSMutableArray *detail_datas = [NSMutableArray new];
            KSWelfareDetailStatistics *detail = model.detail_statistics[j];
            NSArray *counts = @[
                    detail.nodraw,
                    detail.hasdraw,
                    detail.detail.noget,
                    detail.detail.hasget];
            for (int i = 0; i < 4; ++i) {
                KSWelfareStatisticsItemViewModel *itemViewModel = [[KSWelfareStatisticsItemViewModel alloc] initWithServices:self.services params:nil];
                itemViewModel.text = titles[i];
                itemViewModel.count = counts[i];
                itemViewModel.left_offset = offsets[i];
                if (i < 2) {
                    itemViewModel.font = KS_FONT_18;
                    itemViewModel.line = YES;
                    itemViewModel.bkcolr = [UIColor whiteColor];
                } else {
                    itemViewModel.font = KS_SMALL_FONT;
                    itemViewModel.line = NO;
//                    itemViewModel.bkcolr = RGB(242, 242, 242);
                    itemViewModel.bkcolr = [UIColor whiteColor];
                }
                [detail_datas addObject:itemViewModel];
            }
            [datas addObject:detail_datas];
        }
        self.dataSource = [datas copy];

    }
}
@end
