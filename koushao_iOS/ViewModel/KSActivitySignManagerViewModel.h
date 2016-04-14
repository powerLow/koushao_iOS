//
//  KSActivitySignManagerViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSActivitySignManagerViewModel : KSViewModel

@property(nonatomic, strong, readonly) RACCommand *didClickQrcodeScanCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickSmsCodeCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickUserSignCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickSignRecordCommand;

@end
