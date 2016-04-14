//
//  KSWelfareStatisticsViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSWelfareAnalyseModel.h"

@interface KSWelfareStatisticsViewModel : KSViewModel
@property(nonatomic, strong, readonly) NSArray *dataSource;
@property(nonatomic, strong, readonly) KSWelfareAnalyseModel *model;

- (void)dataSourceWithModel:(KSWelfareAnalyseModel *)model;
@end
