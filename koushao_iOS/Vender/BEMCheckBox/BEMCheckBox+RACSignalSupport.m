//
//  BEMCheckBox+RACSignalSupport.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "BEMCheckBox+RACSignalSupport.h"

@implementation BEMCheckBox (RACSignalSupport)

- (RACSignal *)rac_StatueChangeSignal{
    @weakify(self);
    return [[[[RACSignal
                defer:^{
                    @strongify(self);
                    return [RACSignal return:self];
                }]
              concat:[self rac_signalForSelector:@selector(setOn:animated:)]]
              map:^(id x) {
                  if ([NSStringFromClass([x class]) isEqualToString:@"BEMCheckBox"]) {
                      return @0;
                  }
                  RACTuple *tuple = x;
//                  NSLog(@"x = %@",tuple.first);
                  return (NSNumber*)tuple.first;
              }]
             takeUntil:self.rac_willDeallocSignal];
}

@end
