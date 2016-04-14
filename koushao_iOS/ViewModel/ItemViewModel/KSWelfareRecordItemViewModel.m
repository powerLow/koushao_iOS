//
//  KSWelfareRecordItemViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareRecordItemViewModel.h"

@interface KSWelfareRecordItemViewModel ()
@property(nonatomic, strong, readwrite) KSWelfareVerifyLogsItemModel *itemModel;

@end

@implementation KSWelfareRecordItemViewModel

- (instancetype)initWithServices:(id)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.itemModel = params[@"item"];
    }
    return self;
}

@end
