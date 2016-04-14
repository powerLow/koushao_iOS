//
//  KSTableViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSTableViewModel : KSViewModel


@property(nonatomic, copy) NSArray *dataSource;

@property(nonatomic, assign) NSUInteger page;
@property(nonatomic, assign) NSUInteger perPage;

@property(nonatomic, copy) NSArray *sectionIndexTitles;

@property(nonatomic, assign) BOOL shouldPullToRefresh;
@property(nonatomic, assign) BOOL shouldInfiniteScrolling;
@property(nonatomic, assign) BOOL shouldDisplayEmptyDataSet;

@property(nonatomic, strong) RACCommand *didSelectCommand;


- (id)fetchLocalData;

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

- (NSUInteger)offsetForPage:(NSUInteger)page;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;


@end
