//
//  KSTableViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTableViewModel.h"

@interface KSTableViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation KSTableViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];

    self.page = 1;
    self.perPage = 10;

    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];

    RAC(self, shouldDisplayEmptyDataSet) = [RACSignal
            combineLatest:@[self.requestRemoteDataCommand.executing, RACObserve(self, dataSource)]
                   reduce:^(NSNumber *executing, NSArray *dataSource) {
                       RACSequence *sequenceOfSequences = [dataSource.rac_sequence map:^(NSArray *array) {
                           @strongify(self)
                           NSParameterAssert([array isKindOfClass:[NSArray class]]);
                           return array.rac_sequence;
                       }];
                       return @(!executing.boolValue && sequenceOfSequences.flatten.array.count == 0);
                   }];

    [[self.requestRemoteDataCommand.errors
            filter:[self requestRemoteDataErrorsFilter]]
            subscribe:self.errors];
}

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        [KSUtil filterError:error params:self.services];
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

@end
