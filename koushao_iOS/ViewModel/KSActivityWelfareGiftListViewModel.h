//
//  KSActivityWelfareGiftListViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTableViewModel.h"

@interface KSActivityWelfareGiftListViewModel : KSTableViewModel

@property(nonatomic, strong, readonly) RACCommand *didSwitchTypeCommand;
@property(nonatomic, assign, readonly) KSAwardListApiType curRequestType;

@property(nonatomic, strong, readonly) NSArray *items;

- (NSArray *)dataSourceWithItems:(NSArray *)items;
@end
