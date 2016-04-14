//
//  KSActivityManagerViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/25.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityManagerViewModel.h"
#import "KSActivityConsultReplyViewModel.h"
#import "KSActivityShareViewModel.h"
#import "KSActivityWelfareManagerViewModel.h"
#import "KSActivitySignManagerViewModel.h"
#import "KSActivityAdminManagerViewModel.h"
#import "KSBrowseDetailViewModel.h"
#import "KSEnrollDetailViewModel.h"


#define RAFN_MAINTAIN_COMPLETION_BLOCKS

#import "RACAFNetworking.h"

@interface KSActivityManagerViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didClickShareBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickAskBtnCommand;

@property(nonatomic, strong, readwrite) RACCommand *didClickWelfareBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickSignBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickAdminBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickLookBtnCommand;

@property(nonatomic, strong, readwrite) RACCommand *didClickStopBtnCommand;

@property(nonatomic, strong, readwrite) RACCommand *didClickBrowseDetailCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickEnrollDetailCommand;


@end

@implementation KSActivityManagerViewModel


- (instancetype)initWithServices:(id)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.activity = params[@"activity"];
    }
    return self;
}

- (RACSignal *)getShortUrl {

    NSURL *shortUrl = [NSURL URLWithString:@"http://api.t.sina.com.cn/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
            initWithBaseURL:shortUrl];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *longurl = [NSString stringWithFormat:@"http://m.koushaoapp.com/activity/%@", self.activity.sig];
    NSDictionary *params = @{
            @"source" : @"3918506055",
            @"url_long" : longurl,
    };
    return [manager rac_GET:@"short_url/shorten.json" parameters:params];
}

- (void)initialize {
    [super initialize];
    self.title = @"活动管理";

    [[[self getShortUrl] doNext:^(id x) {
        NSLog(@"读取缓存短网址 = %@", self.activity.shortUrl);
    }] subscribeNext:^(RACTuple *JSONAndHeaders) {
        RACTupleUnpack(NSArray *result, NSHTTPURLResponse *response) = JSONAndHeaders;
        if (response.statusCode == 200) {
            self.activity.shortUrl = result[0][@"url_short"];
            NSLog(@"url_short = %@", self.activity.shortUrl);
            [self.activity ks_saveOrUpdate];
        }
    }];

    @weakify(self)
    self.didClickShareBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        KSActivityShareViewModel *viewModel = [[KSActivityShareViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didClickAskBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KSActivityConsultReplyViewModel *viewModel = [[KSActivityConsultReplyViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.didClickWelfareBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KSActivityWelfareManagerViewModel *viewModel = [[KSActivityWelfareManagerViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.didClickSignBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KSActivitySignManagerViewModel *viewModel = [[KSActivitySignManagerViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.didClickAdminBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KSActivityAdminManagerViewModel *viewModel = [[KSActivityAdminManagerViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.didClickLookBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSString *u = [NSString stringWithFormat:@"http://m.koushaoapp.com/activity/%@", self.activity.sig];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:u]];
        return [RACSignal empty];
    }];
    
    self.didClickBrowseDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KSBrowseDetailViewModel *viewModel = [[KSBrowseDetailViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.didClickEnrollDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KSEnrollDetailViewModel *viewModel = [[KSEnrollDetailViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.didClickStopBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [KSClientApi stopActivity];
    }];
    
    self.requestRemoteDataCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[KSClientApi getActivityBaseInfo] takeUntil:self.rac_willDeallocSignal];
    }];
    
    RAC(self, baseinfo) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:nil];
    
    
    
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
    [[self.didClickStopBtnCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

@end
