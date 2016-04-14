//
//  KSActivityConsultReplyViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityConsultReplyViewModel.h"
#import "KSQuestionReplyItemViewModel.h"
#import "KSQuestionReplyResultModel.h"
#import "KSQuestionDeleteResultModel.h"
#import "KSQuestionListModel.h"

@interface KSActivityConsultReplyViewModel ()

@property(nonatomic, strong, readwrite) NSArray *items;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property(nonatomic, strong, readwrite) RACCommand *didSwitchTypeCommand;
@property(nonatomic, strong, readwrite) RACCommand *didSendReplyCommand;
@property(nonatomic, strong, readwrite) RACCommand *didDeleteReplyCommand;
@property(nonatomic, strong, readwrite) RACCommand *didDeleteQuestionCommand;

@end

@implementation KSActivityConsultReplyViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.title = @"咨询回复";
    //默认是请求未回复的
    self.currentType = KSQuestionListApiReplyTypeNo;
    
    @weakify(self)
    //获取列表
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSNumber *qid = @0;
        NSMutableArray *qids = [NSMutableArray new];
        NSArray *items = self.items;
        if (items != nil) {
            for (KSQuestionListItemModel *item in items) {
                [qids addObject:item.id];
            }
            if ([input unsignedIntegerValue] == KSRequestRefreshTypePullDown) {
                //下拉
                //找到最大的id
                qid = [qids valueForKeyPath:@"@max.self"];
            } else {
                //上拉，找到最小的id
                qid = [qids valueForKeyPath:@"@min.self"];
            }
            
        }
        return [self requestRemoteWithId:qid refresh_type:[input unsignedIntegerValue]];
    }];
    
    RAC(self, items) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:nil];
    //回复问题
    self.didSendReplyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *qid, NSString *answer) = tuple;
        return [KSClientApi PostReplyWithId:qid answer:answer];
    }];
    //删除问题
    self.didDeleteQuestionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *qid) {
        return [KSClientApi DeleteReplyWithType:KSQuestionReplyDeleteApiTypeQuestion Id:qid];
    }];
    //删除评论
    self.didDeleteReplyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *qid) {
        return [KSClientApi DeleteReplyWithType:KSQuestionReplyDeleteApiTypeReply Id:qid];
    }];
    [self.didSendReplyCommand.executionSignals.switchToLatest subscribeNext:^(KSQuestionReplyResultModel *x) {
        NSLog(@"回复成功 = %@", x);
        NSMutableArray *items = [_items mutableCopy];
        for (KSQuestionListItemModel *item in items) {
            if ([item.id isEqual:x.questionid]) {
                [items removeObject:item];
                break;
            }
        }
        self.items = [items copy];
        KSSuccess(@"回复成功,我们已经通过短信通知对方!");
    }];
    //切换 未回复/已回复
    self.didSwitchTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        KSQuestionListApiReplyType type = [input unsignedIntegerValue];
        self.currentType = type;
        self.items = nil;
        self.isNoMoreData = NO;
        return [self.requestRemoteDataCommand execute:@(KSRequestRefreshTypePullDown)];
    }];
    
    //请求结果
    [self.didDeleteQuestionCommand.executionSignals.switchToLatest subscribeNext:^(KSQuestionDeleteResultModel *x) {
        NSLog(@"删除问题成功 = %@", x);
        NSMutableArray *items = [_items mutableCopy];
        for (KSQuestionListItemModel *item in items) {
            if ([item.id isEqual:x.questionid]) {
                [items removeObject:item];
                break;
            }
        }
        self.items = [items mutableCopy];
        KSSuccess(@"删除成功");
    }];
    [self.didDeleteReplyCommand.executionSignals.switchToLatest subscribeNext:^(KSQuestionDeleteResultModel *x) {
        NSLog(@"删除回复成功 = %@", x.questionid);
        NSMutableArray *items = [_items mutableCopy];
        //回复列表中删了，添加到未回复列表
        for (KSQuestionListItemModel *item in items) {
            if ([item.id isEqual:x.questionid]) {
                [items removeObject:item];
                item.answerer = @"";
                item.answer = @"";
                item.answer_time = 0;
                break;
            }
        }
        self.items = [items mutableCopy];
        KSSuccess(@"删除成功");
    }];
    
    //错误处理
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
    [[self.didSendReplyCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
    [[self.didDeleteReplyCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
    [[self.didDeleteQuestionCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

- (RACSignal *)requestRemoteWithId:(NSNumber *)qid
                      refresh_type:(KSRequestRefreshType)refresh_type {
    
    RACSignal *fetchSignal = [KSClientApi GetQuestionListWithId:qid type:refresh_type replytype:_currentType limit:@(self.perPage)];
    return [[[[fetchSignal take:self.perPage] collect]
             doNext:^(NSArray *items) {
                 
             }]
            map:^id(NSArray *items) {
                if (refresh_type == KSRequestRefreshTypePullDown) {
                    if (items.count < self.perPage && self.items.count == 0) {
                        //第一次下拉刷新,没有够分页数,肯定是没有更多了
                        self.isNoMoreData = YES;
                    }
                } else {
                    if (items.count < self.perPage) {
                        //上拉不满每次查询数,肯定是没有更多数据了
                        self.isNoMoreData = YES;
                    } else {
                        self.isNoMoreData = items.count == 0;
                    }
                    
                }
                
                if (qid != 0) {
                    if (refresh_type == KSRequestRefreshTypePullDown) {
                        items = @[items.rac_sequence, (self.items ?: @[]).rac_sequence].rac_sequence.flatten.array;
                    } else {
                        items = @[(self.items ?: @[]).rac_sequence, items.rac_sequence].rac_sequence.flatten.array;
                    }
                }
                return items;
            }];
}

- (NSArray *)dataSourceWithItems:(NSArray *)items {
    if (items.count == 0) return nil;
    
    NSArray *viewModels = [items.rac_sequence map:^(KSQuestionListItemModel *item) {
        KSQuestionReplyItemViewModel *viewModel = [[KSQuestionReplyItemViewModel alloc] initWithServices:self.services params:@{@"item" : item, @"type" : @(_currentType)}];
        viewModel.cellHeight = 100;
        return viewModel;
    }].array;
    
    return @[viewModels];
}
@end
