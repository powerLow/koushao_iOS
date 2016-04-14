//
//  KSSignRecordDetailViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSignRecordDetailViewModel.h"
#import "KSSigninListModel.h"

@interface KSSignRecordDetailViewModel ()

@property(nonatomic, strong) KSSigninListItemModel *item;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property(nonatomic, strong, readwrite) KSSigninDetailModel *model;
@end

@implementation KSSignRecordDetailViewModel
@synthesize requestRemoteDataCommand;

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.item = params[@"item"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"签到详情";

    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self requestSignInDeatil] takeUntil:self.rac_willDeallocSignal];
    }];
    RAC(self, model) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];
}

- (RACSignal *)requestSignInDeatil {
    return [[KSClientApi getSigninDetailWithTicketId:self.item.ticket_id] doNext:^(id x) {
        NSLog(@"requestSignInDeatil = %@", x);
    }];
}

- (id)fetchLocalData {
    return nil;
}

@end
