//
//  KSRefreshTableViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSRefreshTableViewModel : KSViewModel

@property(nonatomic, copy) NSArray *dataSource;
@property(nonatomic, copy) NSArray *sectionIndexTitles;
@property(nonatomic, copy) NSArray *items;

@property(nonatomic, assign) NSUInteger perPage;

@property(nonatomic, strong) RACCommand *didSelectCommand;
@property(nonatomic, strong) RACCommand *didSwitchTypeCommand;

- (id)fetchLocalData;

- (RACSignal *)requestRemoteDataSignalWithId:(NSNumber*)aid refresh_type:(KSRequestRefreshType)refresh_type;
- (NSArray *)dataSourceWithItems:(NSArray *)items;
@end
