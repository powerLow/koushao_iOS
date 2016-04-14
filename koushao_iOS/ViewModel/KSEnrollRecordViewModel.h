//
//  KSEnrollRecordViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSRefreshTableViewModel.h"
#import "KSActivity.h"

@interface KSEnrollRecordViewModel : KSRefreshTableViewModel

@property(nonatomic, strong, readonly) KSActivity *activity;
@property(nonatomic, strong, readonly) RACCommand *didClickCellCommand;
@property(nonatomic, assign, readonly) BOOL isEnroll;




@end
