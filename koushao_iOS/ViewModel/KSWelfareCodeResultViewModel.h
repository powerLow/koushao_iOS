//
//  KSWelfareQRCodeViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/11.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSWelfareVerifyResultModel.h"

@interface KSWelfareCodeResultViewModel : KSViewModel

@property(nonatomic, strong, readonly) KSWelfareVerifyResultModel *result;
@property(nonatomic, strong, readonly) RACCommand *didClickOkBtnCommand;

@end
