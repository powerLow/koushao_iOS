//
//  KSActivityConsultReplyViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTableViewModel.h"

@interface KSActivityConsultReplyViewModel : KSTableViewModel

@property(nonatomic, strong, readonly) RACCommand *didSendReplyCommand;
@property(nonatomic, strong, readonly) RACCommand *didDeleteReplyCommand;
@property(nonatomic, strong, readonly) RACCommand *didDeleteQuestionCommand;

@property(nonatomic, strong, readonly) RACCommand *didSwitchTypeCommand;
@property(nonatomic, strong, readonly) NSArray *items;
@property(nonatomic, assign) KSQuestionListApiReplyType currentType;


- (NSArray *)dataSourceWithItems:(NSArray *)items;

@end
