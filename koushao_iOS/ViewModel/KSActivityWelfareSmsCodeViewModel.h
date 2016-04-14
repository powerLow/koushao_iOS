//
//  KSActivityWelfareSmsCodeViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSActivityWelfareSmsCodeViewModel : KSViewModel

@property(nonatomic, strong, readonly) RACCommand *didSubmitCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickViewRecordCommand;

@end
