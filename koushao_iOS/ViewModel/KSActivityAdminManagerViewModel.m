//
//  KSActivityAdminManagerViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityAdminManagerViewModel.h"

@interface KSActivityAdminManagerViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didClickAddBtn;
@property(nonatomic, strong, readwrite) RACCommand *didClickEditBtn;
@property(nonatomic, strong, readwrite) RACCommand *didClickLookBtn;

@property(nonatomic, strong, readwrite) KSAddSubAccountResultModel *resultModel;

@property(nonatomic, strong, readwrite) KSActivityAdminItemViewModel *item;

@end

@implementation KSActivityAdminManagerViewModel

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.item = params[@"item"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"管理员管理";

    self.didClickAddBtn = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(NSString *account, NSString *password, NSNumber *signin, NSNumber *question, NSNumber *welfare) = tuple;
        return [KSClientApi addSubAccount:account Password:password signin:[signin boolValue] question:[question boolValue] welfare:[welfare boolValue]];
    }];

    self.didClickEditBtn = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(NSString *account, NSString *password, NSNumber *signin, NSNumber *question, NSNumber *welfare) = tuple;
        return [KSClientApi ModifySubAccount:account Password:password signin:[signin boolValue] question:[question boolValue] welfare:[welfare boolValue]];
    }];


    RAC(self, resultModel) = self.didClickAddBtn.executionSignals.switchToLatest;

    [self.didClickEditBtn.executionSignals.switchToLatest subscribeNext:^(NSString *nickname) {
        NSLog(@"编辑成功 = %@", nickname);
        [self.services popViewModelAnimated:YES];
    }];

    [[self.didClickAddBtn.errors
            filter:[self requestRemoteDataErrorsFilter]]
            subscribe:self.errors];

    [[self.didClickEditBtn.errors
            filter:[self requestRemoteDataErrorsFilter]]
            subscribe:self.errors];

    self.didClickLookBtn = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        KSActivityAdminListViewModel *viewModel = [[KSActivityAdminListViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}

- (BOOL (^)(NSError *))requestRemoteDataErrorsFilter {
    return ^BOOL(NSError *error) {
        [KSUtil filterError:error params:self.services];
        return YES;
    };
}
@end
