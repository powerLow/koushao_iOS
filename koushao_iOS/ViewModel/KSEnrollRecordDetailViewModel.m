//
//  KSEnrollRecordDetailViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordDetailViewModel.h"
#import "KSClientApi.h"


@interface KSEnrollRecordDetailViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@property(nonatomic, strong, readwrite) KSActivityEnrollRecordItemInfo *info;

@property(nonatomic, copy, readwrite) NSString *ticket_id;
@property(nonatomic, assign, readwrite) BOOL isEnroll;
@end

@implementation KSEnrollRecordDetailViewModel
@synthesize requestRemoteDataCommand;

- (instancetype)initWithServices:(id)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.isEnroll = [params[@"isEnroll"] boolValue];
        self.ticket_id = [params[@"ticket_id"] copy];
    }
    return self;
}


- (void)initialize {
    [super initialize];

    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self requestEnrollRecordDetailInfo] takeUntil:self.rac_willDeallocSignal];
    }];

    RAC(self, info) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];

}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestEnrollRecordDetailInfo {
    return [KSClientApi getEnrollRecordDetailWithTicketId:_ticket_id];
}

@end
