//
//  KSRefreshTableViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSRefreshTableViewModel.h"

@implementation KSRefreshTableViewModel

- (void)initialize {
    [super initialize];
    
    self.perPage = 10;
    
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *refresh) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithId:@0 refresh_type:[refresh unsignedIntegerValue]] takeUntil:self.rac_willDeallocSignal];
    }];
    
    
    
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithId:(NSNumber*)aid refresh_type:(KSRequestRefreshType)refresh_type{
    return [RACSignal empty];
}
- (NSArray *)dataSourceWithItems:(NSArray *)items {
    return nil;
}
@end
