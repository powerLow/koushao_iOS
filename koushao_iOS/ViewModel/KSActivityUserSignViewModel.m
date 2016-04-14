//
//  KSActivityUserSignViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityUserSignViewModel.h"

@interface KSActivityUserSignViewModel ()

@property(nonatomic, strong, readwrite) KSActivity *activity;
@property(nonatomic, strong, readwrite) KSQRCodeResultModel *model;
@property(nonatomic, strong, readwrite) RACCommand *didSubmitCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickViewRecordCommand;
@property(nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation KSActivityUserSignViewModel
@synthesize requestRemoteDataCommand;

- (void)initialize {
    [super initialize];
    self.activity = [KSUtil getCurrentActivity];
    self.title = @"用户主动签到";

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [KSClientApi getcheckinQRCode];
    }];

    RAC(self, model) = [self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData];
}

- (id)fetchLocalData {
    return nil;
}
@end
