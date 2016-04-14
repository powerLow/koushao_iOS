//
//  KSSignCodeResultViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSSignResultModel.h"

@interface KSSignCodeResultViewModel : KSViewModel

@property(nonatomic, strong, readonly) KSSignResultModel *result;
@property(nonatomic, strong, readonly) RACCommand *didClickOkBtnCommand;

@end