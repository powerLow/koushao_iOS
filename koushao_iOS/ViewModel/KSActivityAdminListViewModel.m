//
//  KSActivityAdminListViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityAdminListViewModel.h"
#import "KSActivityAdminListModel.h"
#import "KSActivityAdminManagerViewModel.h"

@interface KSActivityAdminListViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didClickItemEditBtn;
@property(nonatomic, strong, readwrite) RACCommand *didClickItemDeleteBtn;

@end

@implementation KSActivityAdminListViewModel

- (void)initialize {
    [super initialize];
    self.title = @"已添加账号";

    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        return [RACSignal empty];
    }];


    self.didClickItemDeleteBtn = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(KSActivityAdminItemViewModel *vm) {
        return [KSClientApi DelSubAccount:vm.itemModel.nickname];
    }];

    self.didClickItemEditBtn = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(KSActivityAdminItemViewModel *vm) {
        KSActivityAdminManagerViewModel *viewModel = [[KSActivityAdminManagerViewModel alloc] initWithServices:self.services params:@{@"item" : vm, @"title" : @"编辑管理员"}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];


    [[self.didClickItemDeleteBtn.errors
            filter:[self requestRemoteDataErrorsFilter]]
            subscribe:self.errors];
    
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self requestRemoteDataSignalWithPage:1];
    }];
    
    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];

    [self.didClickItemDeleteBtn.executionSignals.switchToLatest subscribeNext:^(NSString *nickname) {
        NSLog(@"删除成功 = %@", nickname);
        NSMutableArray *items = [self.items mutableCopy];
        for (KSActivityAdminItemModel *item in items) {
            if (item.nickname == nickname) {
                [items removeObject:item];
                break;
            }
        }

        self.items = [items copy];
    }];


}

- (BOOL (^)(NSError *))requestRemoteDataErrorsFilter {
    return ^BOOL(NSError *error) {
        [KSUtil filterError:error params:self.services];
        return YES;
    };
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {

    RACSignal *fetchSignal = [KSClientApi getSubAccountList];
    return [[[[fetchSignal take:self.perPage] collect]
            doNext:^(NSArray *items) {;
            }]
            map:^id(NSArray *items) {
                NSLog(@"page = %ld", (unsigned long)page);
                if (page != 1) {
                    items = @[(self.items ?: @[]).rac_sequence, items.rac_sequence].rac_sequence.flatten.array;
                }
                return items;
            }];
}


- (id)fetchLocalData {
    NSArray *items = nil;
    return items;
}

- (NSArray *)dataSourceWithItems:(NSArray *)items {
    if (items.count == 0) return nil;

    NSArray *viewModels = [items.rac_sequence map:^(KSActivityAdminItemModel *item) {
        KSActivityAdminItemViewModel *viewModel = [[KSActivityAdminItemViewModel alloc] initWithServices:self.services params:@{@"item" : item}];
        viewModel.cellHeight = 80;
        return viewModel;
    }].array;
    return @[viewModels];
}
@end
