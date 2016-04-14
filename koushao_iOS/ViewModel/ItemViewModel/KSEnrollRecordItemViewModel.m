//
//  KSEnrollRecordItemViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordItemViewModel.h"

@interface KSEnrollRecordItemViewModel ()

@property(nonatomic, strong, readwrite) KSActivityEnrollRecordItem *item;
@property(nonatomic, assign, readwrite) BOOL isEnroll;
@end

@implementation KSEnrollRecordItemViewModel


- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params {
    self = [super init];
    if (self) {
        self.item = params[@"item"];
        self.isEnroll = [params[@"isEnroll"] boolValue];
    }
    return self;
}

@end
