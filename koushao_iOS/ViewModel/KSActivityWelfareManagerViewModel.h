//
//  KSActivityWelfareManagerViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSActivityWelfareManagerViewModel : KSViewModel


@property(nonatomic, strong, readonly) RACCommand *didClickQrcodeScanCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickSmsCodeCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickRealGiftCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickWelfareRecordCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickWelfareStatisticsCommand;

@end
