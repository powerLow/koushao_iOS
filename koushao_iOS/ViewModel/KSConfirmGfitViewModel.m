//
//  KSConfirmGfitViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSConfirmGfitViewModel.h"
#import "KSAwardDetailApi.h"

@interface KSConfirmGfitViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *didClickConfirmBtn;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property(nonatomic, strong, readwrite) NSNumber *wid;
@property(nonatomic, strong, readwrite) KSAwardDetailModel *model;
@property(nonatomic, strong, readwrite) KSAwardConfirmResultModel *result;
@end

@implementation KSConfirmGfitViewModel
@synthesize requestRemoteDataCommand;

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.wid = params[@"wid"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"实物奖品发放";

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [KSClientApi getAwardDetailWid:_wid];
    }];

    RAC(self, model) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:nil];

    self.didClickConfirmBtn = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(NSString *nu, NSString *company) = tuple;
        return [KSClientApi confirmAwardWithWid:_wid nu:nu company:company];
    }];

    RAC(self, result) = [self.didClickConfirmBtn.executionSignals.switchToLatest startWith:nil];

    [RACObserve(self, result) subscribeNext:^(KSAwardConfirmResultModel *x) {
        if (x.nu != nil) {
            NSLog(@"确认成功 = \n单号:%@\n快递:%@", x.nu, x.company);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmGift" object:self.wid];
            [self.services popViewModelAnimated:YES];
        }
    }];
}
@end
