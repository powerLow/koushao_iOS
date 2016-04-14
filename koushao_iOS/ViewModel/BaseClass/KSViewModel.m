//
//  KSViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSViewModel ()

@property(nonatomic, strong, readwrite) id <KSViewModelServices> services;
@property(nonatomic, strong, readwrite) id params;

@end

@implementation KSViewModel


@synthesize services = _services;
@synthesize params = _params;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize callback = _callback;
@synthesize errors = _errors;
@synthesize titleViewType = _titleViewType;
@synthesize willDisappearSignal = _willDisappearSignal;
@synthesize shouldFetchLocalDataOnViewModelInitialize = _shouldFetchLocalDataOnViewModelInitialize;
@synthesize shouldRequestRemoteDataOnViewDidLoad = _shouldRequestRemoteDataOnViewDidLoad;


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    KSViewModel *viewModel = [super allocWithZone:zone];

    @weakify(viewModel)
    [[viewModel
            rac_signalForSelector:@selector(initWithServices:params:)]
            subscribeNext:^(id x) {
                @strongify(viewModel)
                [viewModel initialize];
            }];

    return viewModel;
}

- (instancetype)initWithServices:(id)services params:(id)params {
    self = [super init];
    if (self) {
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.title = params[@"title"];
        self.services = services;
        self.params = params;
    }
    return self;
}

- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

- (BOOL (^)(NSError *))requestRemoteDataErrorsFilter {
    return ^BOOL(NSError *error) {
        [KSUtil filterError:error params:self.services];
        return YES;
    };
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = [RACSubject subject];
    return _willDisappearSignal;
}

- (void)initialize {
}


@end
