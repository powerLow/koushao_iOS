//
//  KSActivityWelfareRecordViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTableViewModel.h"
#import "KSWelfareVerifyLogsResultModel.h"

@interface KSActivityWelfareRecordViewModel : KSTableViewModel

@property(nonatomic, strong, readonly) NSArray *items;
@property(nonatomic, strong, readonly) NSArray *sectionSource;
@property(nonatomic, strong, readonly) RACCommand *didSwitchCommand;
@property(nonatomic, strong, readonly) KSWelfareVerifyLogsResultModel *model;

- (NSArray *)dataSourceWithItems:(NSArray *)items;

@end
