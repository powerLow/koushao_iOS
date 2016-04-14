//
//  KSEnrollDetailViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivity.h"
#import "KSActivityEnrollInfo.h"

@interface KSEnrollDetailViewModel : KSViewModel

@property(nonatomic, strong, readonly) KSActivity *activity;
@property(nonatomic, strong, readonly) KSActivityEnrollInfo *enrollInfo;
@property(nonatomic, strong, readonly) RACCommand *didClickViewEnrollRecordCommand;

@end
